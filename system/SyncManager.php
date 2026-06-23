<?php
/**
 * SyncManager - Main Offline-First Data Synchronization Engine
 * Handles push/pull operations, UUID mapping, conflict resolution, and logging.
 */

class SyncManager {
    private $con;
    private $tables;
    private $apiUrl;
    private $apiToken;
    private $batchSize;

    public function __construct($con) {
        $this->con = $con;
        
        // Load configuration
        if (!defined('SYNC_API_URL')) {
            include_once(__DIR__ . '/sync_config.php');
        }
        
        global $sync_tables;
        $this->tables = $sync_tables;
        $this->apiUrl = SYNC_API_URL;
        $this->apiToken = SYNC_API_TOKEN;
        $this->batchSize = defined('SYNC_BATCH_SIZE') ? SYNC_BATCH_SIZE : 100;
    }

    /**
     * Log a sync activity
     */
    public function logSync($table, $uuid, $action, $status, $message = null) {
        $stmt = $this->con->prepare("INSERT INTO sync_logs (table_name, uuid, action, status, message) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("sssss", $table, $uuid, $action, $status, $message);
        $stmt->execute();
    }

    /**
     * Log a resolved conflict
     */
    public function logConflict($table, $uuid, $localTime, $serverTime, $resolution) {
        $stmt = $this->con->prepare("INSERT INTO sync_conflicts (table_name, uuid, local_timestamp, server_timestamp, resolution) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("sssss", $table, $uuid, $localTime, $serverTime, $resolution);
        $stmt->execute();
    }

    /**
     * Get UUID of a record in a table by its integer ID
     */
    private function getUuidById($table, $id) {
        if (empty($id)) return null;
        $stmt = $this->con->prepare("SELECT uuid FROM `$table` WHERE id = ?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $res = $stmt->get_result()->fetch_assoc();
        return $res ? $res['uuid'] : null;
    }

    /**
     * Get local ID of a record in a table by its UUID
     */
    private function getIdByUuid($table, $uuid) {
        if (empty($uuid)) return null;
        $stmt = $this->con->prepare("SELECT id FROM `$table` WHERE uuid = ?");
        $stmt->bind_param("s", $uuid);
        $stmt->execute();
        $res = $stmt->get_result()->fetch_assoc();
        return $res ? $res['id'] : null;
    }

    /**
     * Map relation IDs to UUIDs in a row for outbound sync
     */
    private function mapOutboundRelations($table, $row) {
        $relations = $this->tables[$table]['relations'];
        foreach ($relations as $fkCol => $parentTable) {
            if (isset($row[$fkCol]) && !empty($row[$fkCol])) {
                $uuid = $this->getUuidById($parentTable, $row[$fkCol]);
                $row[$fkCol . '_uuid'] = $uuid;
            } else {
                $row[$fkCol . '_uuid'] = null;
            }
            // Remove the local integer ID from sync payload to avoid server confusion
            unset($row[$fkCol]);
        }
        return $row;
    }

    /**
     * Map UUIDs back to local integer IDs in a row for inbound sync
     */
    private function mapInboundRelations($table, $row) {
        $relations = $this->tables[$table]['relations'];
        foreach ($relations as $fkCol => $parentTable) {
            $uuidKey = $fkCol . '_uuid';
            if (isset($row[$uuidKey]) && !empty($row[$uuidKey])) {
                $localId = $this->getIdByUuid($parentTable, $row[$uuidKey]);
                $row[$fkCol] = $localId;
            } else {
                $row[$fkCol] = null;
            }
            // Clean up the uuid field from payload
            unset($row[$uuidKey]);
        }
        return $row;
    }

    /**
     * Prepare data payload for pushing pending local records to cloud
     */
    public function getPendingPayload() {
        $payload = [];
        foreach ($this->tables as $table => $config) {
            // Get records that are pending or failed sync, limited by batch size
            $query = "SELECT * FROM `$table` WHERE sync_status IN ('pending', 'failed') LIMIT " . intval($this->batchSize);
            $res = $this->con->query($query);
            
            $batch = [];
            while ($row = $res->fetch_assoc()) {
                // Map local foreign IDs to global UUIDs
                $row = $this->mapOutboundRelations($table, $row);
                $batch[] = $row;
            }
            
            if (!empty($batch)) {
                $payload[$table] = $batch;
            }
        }
        return $payload;
    }

    /**
     * Synchronize Local -> Cloud (Push)
     */
    public function pushPending() {
        $batches = $this->getPendingPayload();
        if (empty($batches)) {
            return ['success' => true, 'message' => 'No pending records to push.'];
        }

        // Send to Cloud API
        $postData = [
            'token' => $this->apiToken,
            'batches' => $batches
        ];

        $ch = curl_init($this->apiUrl . '?action=push');
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => json_encode($postData),
            CURLOPT_HTTPHEADER => ['Content-Type: application/json'],
            CURLOPT_TIMEOUT => 30
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if ($httpCode !== 200) {
            $msg = "Push failed with HTTP Code $httpCode. Error: " . ($response ? $response : $curlError);
            $this->logSync('all', null, 'push', 'failure', $msg);
            
            // Mark all currently pushed records as failed locally so they will retry
            foreach ($batches as $table => $rows) {
                foreach ($rows as $row) {
                    $this->updateLocalStatus($table, $row['uuid'], 'failed', null);
                }
            }
            return ['success' => false, 'error' => $msg];
        }

        $resData = json_decode($response, true);
        if (!$resData || !isset($resData['success']) || !$resData['success']) {
            $errorMsg = isset($resData['error']) ? $resData['error'] : 'Unknown Cloud API error';
            $this->logSync('all', null, 'push', 'failure', $errorMsg);
            return ['success' => false, 'error' => $errorMsg];
        }

        // Process results and update local sync status
        $results = $resData['results'] ?? [];
        $pushedCount = 0;
        
        foreach ($results as $table => $rows) {
            foreach ($rows as $uuid => $statusInfo) {
                if ($statusInfo['success']) {
                    $syncTime = $statusInfo['timestamp'] ?? date('Y-m-d H:i:s');
                    $this->updateLocalStatus($table, $uuid, 'synced', $syncTime);
                    $this->logSync($table, $uuid, 'push', $statusInfo['status'], 'Successfully pushed to cloud');
                    $pushedCount++;
                } else {
                    $errorMsg = $statusInfo['error'] ?? 'Insertion failed on cloud';
                    $this->updateLocalStatus($table, $uuid, 'failed', null);
                    $this->logSync($table, $uuid, 'push', 'failure', $errorMsg);
                }
            }
        }

        return ['success' => true, 'records_pushed' => $pushedCount];
    }

    /**
     * Synchronize Cloud -> Local (Pull)
     */
    public function pullUpdates() {
        // Get last successful sync time
        $stmt = $this->con->prepare("SELECT val_value FROM sync_settings WHERE key_name = 'last_sync_time'");
        $stmt->execute();
        $resSetting = $stmt->get_result()->fetch_assoc();
        $lastSyncTime = ($resSetting && $resSetting['val_value'] !== 'never') ? $resSetting['val_value'] : '1970-01-01 00:00:00';

        // Call Cloud API
        $url = $this->apiUrl . '?action=pull&since=' . urlencode($lastSyncTime) . '&token=' . urlencode($this->apiToken);
        
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 30
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if ($httpCode !== 200) {
            $msg = "Pull failed with HTTP Code $httpCode. Error: " . ($response ? $response : $curlError);
            $this->logSync('all', null, 'pull', 'failure', $msg);
            return ['success' => false, 'error' => $msg];
        }

        $resData = json_decode($response, true);
        if (!$resData || !isset($resData['success']) || !$resData['success']) {
            $errorMsg = isset($resData['error']) ? $resData['error'] : 'Unknown Cloud API error';
            $this->logSync('all', null, 'pull', 'failure', $errorMsg);
            return ['success' => false, 'error' => $errorMsg];
        }

        $serverTime = $resData['server_time'] ?? date('Y-m-d H:i:s');
        $batches = $resData['batches'] ?? [];
        $pulledCount = 0;

        // Process tables in dependency order
        foreach ($this->tables as $table => $config) {
            if (!isset($batches[$table]) || empty($batches[$table])) continue;

            $this->con->begin_transaction();
            try {
                foreach ($batches[$table] as $incomingRow) {
                    $uuid = $incomingRow['uuid'];
                    $incomingUpdatedAt = $incomingRow['updated_at'];
                    $incomingCreatedAt = $incomingRow['created_at'];

                    // Map inbound UUIDs to local primary keys
                    $incomingRow = $this->mapInboundRelations($table, $incomingRow);

                    // Check if record exists locally by UUID
                    $checkStmt = $this->con->prepare("SELECT id, updated_at FROM `$table` WHERE uuid = ?");
                    $checkStmt->bind_param("s", $uuid);
                    $checkStmt->execute();
                    $localRecord = $checkStmt->get_result()->fetch_assoc();

                    if ($localRecord) {
                        // Conflict resolution: Last Updated Wins
                        $localId = $localRecord['id'];
                        $localUpdatedAt = $localRecord['updated_at'];

                        if (empty($localUpdatedAt) || strtotime($incomingUpdatedAt) > strtotime($localUpdatedAt)) {
                            // Incoming is newer -> update local
                            $this->updateLocalRecord($table, $localId, $incomingRow);
                            $this->logSync($table, $uuid, 'pull', 'updated', 'Updated local record with newer cloud version');
                            $this->logConflict($table, $uuid, $localUpdatedAt, $incomingUpdatedAt, 'server_wins');
                            $pulledCount++;
                        } else {
                            // Local is newer -> skip (will be pushed on next push)
                            $this->logSync($table, $uuid, 'pull', 'skipped', 'Kept local version (local is newer)');
                            $this->logConflict($table, $uuid, $localUpdatedAt, $incomingUpdatedAt, 'local_wins');
                        }
                    } else {
                        // Insert new record locally
                        $this->insertLocalRecord($table, $incomingRow);
                        $this->logSync($table, $uuid, 'pull', 'inserted', 'Inserted new record from cloud');
                        $pulledCount++;
                    }
                }
                $this->con->commit();
            } catch (Exception $e) {
                $this->con->rollback();
                $this->logSync($table, null, 'pull', 'failure', 'Database error: ' . $e->getMessage());
                return ['success' => false, 'error' => 'Database error on pulling table ' . $table . ': ' . $e->getMessage()];
            }
        }

        // Save last sync time setting
        $stmt = $this->con->prepare("UPDATE sync_settings SET val_value = ? WHERE key_name = 'last_sync_time'");
        $stmt->bind_param("s", $serverTime);
        $stmt->execute();

        return ['success' => true, 'records_pulled' => $pulledCount];
    }

    /**
     * Cloud-side Handler: Process pushed batches from local offline client
     */
    public function processIncomingPush($batches) {
        $results = [];
        $serverTime = date('Y-m-d H:i:s');

        foreach ($this->tables as $table => $config) {
            if (!isset($batches[$table]) || empty($batches[$table])) continue;

            $results[$table] = [];

            foreach ($batches[$table] as $incomingRow) {
                $uuid = $incomingRow['uuid'];
                $incomingUpdatedAt = $incomingRow['updated_at'] ?? $serverTime;
                
                // Map inbound UUIDs to local IDs on cloud database
                $incomingRow = $this->mapInboundRelations($table, $incomingRow);

                $this->con->begin_transaction();
                try {
                    // Check if record exists in cloud database by UUID
                    $checkStmt = $this->con->prepare("SELECT id, updated_at FROM `$table` WHERE uuid = ?");
                    $checkStmt->bind_param("s", $uuid);
                    $checkStmt->execute();
                    $cloudRecord = $checkStmt->get_result()->fetch_assoc();

                    if ($cloudRecord) {
                        $cloudId = $cloudRecord['id'];
                        $cloudUpdatedAt = $cloudRecord['updated_at'];

                        // Last Updated Wins
                        if (empty($cloudUpdatedAt) || strtotime($incomingUpdatedAt) > strtotime($cloudUpdatedAt)) {
                            // Incoming (local) is newer -> update cloud
                            $this->updateLocalRecord($table, $cloudId, $incomingRow);
                            $results[$table][$uuid] = [
                                'success' => true,
                                'status' => 'updated',
                                'timestamp' => $serverTime
                            ];
                            $this->logConflict($table, $uuid, $incomingUpdatedAt, $cloudUpdatedAt, 'local_wins');
                        } else {
                            // Cloud is newer -> skip local push
                            $results[$table][$uuid] = [
                                'success' => true,
                                'status' => 'skipped',
                                'timestamp' => $serverTime
                            ];
                            $this->logConflict($table, $uuid, $incomingUpdatedAt, $cloudUpdatedAt, 'server_wins');
                        }
                    } else {
                        // Insert new record in cloud
                        $this->insertLocalRecord($table, $incomingRow);
                        $results[$table][$uuid] = [
                            'success' => true,
                            'status' => 'inserted',
                            'timestamp' => $serverTime
                        ];
                    }
                    $this->con->commit();
                } catch (Exception $e) {
                    $this->con->rollback();
                    $results[$table][$uuid] = [
                        'success' => false,
                        'status' => 'failed',
                        'error' => $e->getMessage()
                    ];
                }
            }
        }

        return $results;
    }

    /**
     * Cloud-side Handler: Fetch updates to send to local pull client
     */
    public function getUpdatesForPull($since) {
        $batches = [];
        foreach ($this->tables as $table => $config) {
            $stmt = $this->con->prepare("SELECT * FROM `$table` WHERE updated_at > ? OR created_at > ?");
            $stmt->bind_param("ss", $since, $since);
            $stmt->execute();
            $res = $stmt->get_result();

            $batch = [];
            while ($row = $res->fetch_assoc()) {
                $row = $this->mapOutboundRelations($table, $row);
                $batch[] = $row;
            }

            if (!empty($batch)) {
                $batches[$table] = $batch;
            }
        }
        return $batches;
    }

    /**
     * Helper: Update local sync status columns
     */
    private function updateLocalStatus($table, $uuid, $status, $timestamp) {
        $stmt = $this->con->prepare("UPDATE `$table` SET sync_status = ?, sync_timestamp = ? WHERE uuid = ?");
        $stmt->bind_param("sss", $status, $timestamp, $uuid);
        $stmt->execute();
    }

    /**
     * Helper: Dynamically insert a row into a table
     */
    private function insertLocalRecord($table, $row) {
        // Set sync metadata
        $row['sync_status'] = 'synced';
        $row['sync_timestamp'] = date('Y-m-d H:i:s');
        unset($row['id']); // Remove local PK if present, let database auto-increment it

        $columns = array_keys($row);
        $placeholders = array_fill(0, count($columns), '?');
        
        $sql = "INSERT INTO `$table` (`" . implode("`, `", $columns) . "`) VALUES (" . implode(", ", $placeholders) . ")";
        
        // Dynamic binding types
        $types = '';
        $values = [];
        foreach ($row as $val) {
            if (is_null($val)) {
                $types .= 's';
                $values[] = null;
            } elseif (is_int($val)) {
                $types .= 'i';
                $values[] = $val;
            } elseif (is_double($val)) {
                $types .= 'd';
                $values[] = $val;
            } else {
                $types .= 's';
                $values[] = strval($val);
            }
        }

        $stmt = $this->con->prepare($sql);
        $stmt->bind_param($types, ...$values);
        $stmt->execute();
    }

    /**
     * Helper: Dynamically update a row in a table
     */
    private function updateLocalRecord($table, $id, $row) {
        $row['sync_status'] = 'synced';
        $row['sync_timestamp'] = date('Y-m-d H:i:s');
        unset($row['id']); // ID cannot be updated
        unset($row['uuid']); // UUID is static
        unset($row['created_at']); // keep original creation

        $setParts = [];
        $values = [];
        $types = '';

        foreach ($row as $col => $val) {
            $setParts[] = "`$col` = ?";
            if (is_null($val)) {
                $types .= 's';
                $values[] = null;
            } elseif (is_int($val)) {
                $types .= 'i';
                $values[] = $val;
            } elseif (is_double($val)) {
                $types .= 'd';
                $values[] = $val;
            } else {
                $types .= 's';
                $values[] = strval($val);
            }
        }

        $sql = "UPDATE `$table` SET " . implode(", ", $setParts) . " WHERE id = ?";
        $types .= 'i';
        $values[] = $id;

        $stmt = $this->con->prepare($sql);
        $stmt->bind_param($types, ...$values);
        $stmt->execute();
    }
}
?>
