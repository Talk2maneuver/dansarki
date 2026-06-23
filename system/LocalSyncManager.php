<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - LOCAL SYNC SERVICE
 * 
 * Manages the client-side execution loop: connection checks, batch upload
 * processing, download updates consolidation, LWW conflict resolution, and
 * sync telemetry logging.
 */

class LocalSyncManager {
    private $con;
    private $apiUrl;
    private $apiToken;
    private $branchUuid;
    private $batchSize;
    private $allowedTables;
    private $pushedCount = 0;
    private $pulledCount = 0;

    public function __construct($con) {
        $this->con = $con;
        
        // Load API Configuration details
        $this->apiUrl = defined('SYNC_API_URL') ? SYNC_API_URL : 'http://localhost/dansarki/api/sync.php';
        $this->apiToken = defined('SYNC_API_TOKEN') ? SYNC_API_TOKEN : '';
        $this->branchUuid = defined('BRANCH_UUID') ? BRANCH_UUID : '';
        $this->batchSize = defined('SYNC_BATCH_SIZE') ? SYNC_BATCH_SIZE : 100;
        
        // Hierarchical order for parent-to-child data integrity
        $this->allowedTables = [
            'branch', 'facility', 'customers', 'stocks', 'orders', 
            'order_items', 'purchase_history', 'expense', 'outstand', 
            'deposit_history', 'purchase_deposit_history'
        ];
        
        $this->ensureSystemSettingsTable();
    }

    /**
     * Guarantees settings persistence table exists in the database.
     */
    private function ensureSystemSettingsTable() {
        $this->con->query("CREATE TABLE IF NOT EXISTS `system_settings` (
            `key_name` VARCHAR(100) PRIMARY KEY,
            `val_value` TEXT NULL,
            `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        ) ENGINE=InnoDB;");
    }

    /**
     * Checks if the cloud server is reachable.
     */
    public function isOnline() {
        // Retrieve endpoint URL from base URL
        $statusUrl = str_replace('sync.php', 'sync/status.php', $this->apiUrl);
        if ($statusUrl === $this->apiUrl) {
            // If the base URL is generic, construct status path
            $statusUrl = dirname($this->apiUrl) . '/sync/status.php';
        }
        
        $ch = curl_init($statusUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $this->apiToken,
            'Content-Type: application/json'
        ]);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5); // 5 second timeout
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($httpCode === 200) {
            $data = json_decode($response, true);
            return isset($data['success']) && $data['success'] === true;
        }
        
        return false;
    }

    /**
     * Executes the full Push (Upload) and Pull (Download) loop.
     */
    public function synchronize() {
        if (!$this->isOnline()) {
            $this->logSyncEvent('SYSTEM', 'ALL', 'FAILED', 'Connection check failed. Cloud server offline.');
            return false;
        }
        
        $pushSuccess = $this->pushUpdates();
        $pullSuccess = $this->pullUpdates();
        
        return $pushSuccess && $pullSuccess;
    }

    /**
     * Extracts pending changes from local sync_queue and uploads them.
     */
    public function pushUpdates() {
        // Query pending records with attempts less than 5
        $query = "SELECT id, table_name, record_uuid, operation FROM `sync_queue` WHERE `status` IN ('pending', 'failed') AND `attempts` < 5 LIMIT " . intval($this->batchSize);
        $res = $this->con->query($query);
        
        if (!$res || $res->num_rows === 0) {
            return true; // No records to push
        }
        
        $queueIds = [];
        $batches = [];
        $recordMap = [];
        
        while ($row = $res->fetch_assoc()) {
            $queueIds[] = $row['id'];
            $tableName = $row['table_name'];
            $uuid = $row['record_uuid'];
            
            // Mark items as processing in local database
            $this->con->query("UPDATE `sync_queue` SET `status` = 'processing' WHERE id = " . intval($row['id']));
            
            // Fetch the actual record details
            $dataRes = $this->con->query("SELECT * FROM `$tableName` WHERE uuid = '" . $this->con->real_escape_string($uuid) . "' LIMIT 1");
            if ($dataRes && $dataRes->num_rows > 0) {
                $record = $dataRes->fetch_assoc();
                
                // Map relational parent IDs to parent UUIDs before upload
                $this->mapRelationsToUuids($tableName, $record);
                
                $batches[$tableName][] = $record;
                $recordMap[$uuid] = $row['id'];
            } else {
                // If record no longer exists locally, remove it from queue
                $this->con->query("DELETE FROM `sync_queue` WHERE id = " . intval($row['id']));
            }
        }
        
        if (empty($batches)) {
            return true;
        }
        
        // POST to cloud upload endpoint
        $uploadUrl = str_replace('sync.php', 'sync/upload.php', $this->apiUrl);
        if ($uploadUrl === $this->apiUrl) {
            $uploadUrl = dirname($this->apiUrl) . '/sync/upload.php';
        }
        
        $ch = curl_init($uploadUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $this->apiToken,
            'Content-Type: application/json'
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(['batches' => $batches]));
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($httpCode !== 200) {
            // Restore status to failed and increment attempts
            $idsList = implode(',', $queueIds);
            $this->con->query("UPDATE `sync_queue` SET `status` = 'failed', `attempts` = `attempts` + 1 WHERE id IN ($idsList)");
            $this->logSyncEvent('SYSTEM', 'ALL', 'FAILED', "Upload API request failed with code $httpCode");
            return false;
        }
        
        $resultData = json_decode($response, true);
        if (!isset($resultData['success']) || $resultData['success'] !== true) {
            $idsList = implode(',', $queueIds);
            $this->con->query("UPDATE `sync_queue` SET `status` = 'failed', `attempts` = `attempts` + 1 WHERE id IN ($idsList)");
            $this->logSyncEvent('SYSTEM', 'ALL', 'FAILED', "Upload execution failed: " . ($resultData['error'] ?? 'Unknown error'));
            return false;
        }
        
        // Resolve processed items statuses
        foreach ($resultData['results'] as $tableName => $records) {
            foreach ($records as $uuid => $statusInfo) {
                $queueId = $recordMap[$uuid] ?? null;
                if (!$queueId) continue;
                
                if ($statusInfo['success'] === true) {
                    // Update queue row as completed
                    $this->con->query("UPDATE `sync_queue` SET `status` = 'completed' WHERE id = " . intval($queueId));
                    $this->pushedCount++;
                    $this->logSyncEvent($tableName, $uuid, 'SUCCESS', 'Uploaded: ' . ($statusInfo['action'] ?? 'synced'));
                } else {
                    $this->con->query("UPDATE `sync_queue` SET `status` = 'failed', `attempts` = `attempts` + 1 WHERE id = " . intval($queueId));
                    $this->logSyncEvent($tableName, $uuid, 'FAILED', 'Upload error: ' . ($statusInfo['error'] ?? 'Server rejected'));
                }
            }
        }
        
        return true;
    }

    /**
     * Downloads delta changes from the cloud server and writes them locally.
     */
    public function pullUpdates() {
        $lastSync = $this->getSystemSetting('last_sync_timestamp') ?? '1970-01-01 00:00:00';
        
        $downloadUrl = str_replace('sync.php', 'sync/download.php', $this->apiUrl);
        if ($downloadUrl === $this->apiUrl) {
            $downloadUrl = dirname($this->apiUrl) . '/sync/download.php';
        }
        
        $ch = curl_init($downloadUrl . '?since=' . urlencode($lastSync));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $this->apiToken,
            'Content-Type: application/json'
        ]);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($httpCode !== 200) {
            $this->logSyncEvent('SYSTEM', 'ALL', 'FAILED', "Download API request failed with code $httpCode");
            return false;
        }
        
        $resultData = json_decode($response, true);
        if (!isset($resultData['success']) || $resultData['success'] !== true) {
            $this->logSyncEvent('SYSTEM', 'ALL', 'FAILED', "Download execution failed: " . ($resultData['error'] ?? 'Unknown error'));
            return false;
        }
        
        $batches = $resultData['batches'] ?? [];
        if (empty($batches)) {
            $this->setSystemSetting('last_sync_timestamp', $resultData['server_time']);
            return true; // Up to date
        }
        
        // Turn off local sync triggers during writes
        $this->con->query("SET @is_syncing = 1");
        
        // Loop in correct table order to maintain parent relations
        foreach ($this->allowedTables as $tableName) {
            if (!isset($batches[$tableName])) continue;
            
            $records = $batches[$tableName];
            $tableColumns = $this->getTableColumns($tableName);
            
            foreach ($records as $record) {
                $uuid = $record['uuid'] ?? '';
                if (empty($uuid)) continue;
                
                // Resolve UUID relations into local integer IDs
                $this->resolveParentUuids($record);
                
                // Filter columns
                $cleanRecord = [];
                foreach ($record as $key => $val) {
                    if (in_array($key, $tableColumns)) {
                        $cleanRecord[$key] = $val;
                    }
                }
                
                // Check if row already exists locally
                $checkRes = $this->con->query("SELECT id, updated_at FROM `$tableName` WHERE uuid = '" . $this->con->real_escape_string($uuid) . "' LIMIT 1");
                $existing = $checkRes ? $checkRes->fetch_assoc() : null;
                
                if ($existing) {
                    // Compare updated_at
                    $localTimeStr = $existing['updated_at'] ?? '1970-01-01 00:00:00';
                    $cloudTimeStr = $cleanRecord['updated_at'] ?? '1970-01-01 00:00:00';
                    
                    $localTime = strtotime($localTimeStr);
                    $cloudTime = strtotime($cloudTimeStr);
                    
                    if ($cloudTime > $localTime) {
                        // Server wins
                        unset($cleanRecord['id']);
                        $updateParts = [];
                        $types = '';
                        $bindParams = [];
                        
                        foreach ($cleanRecord as $col => $val) {
                            $updateParts[] = "`$col` = ?";
                            $bindParams[] = $val;
                            $types .= 's';
                        }
                        
                        $bindParams[] = $uuid;
                        $types .= 's';
                        
                        $updateQuery = "UPDATE `$tableName` SET " . implode(', ', $updateParts) . " WHERE uuid = ?";
                        $stmt = $this->con->prepare($updateQuery);
                        if ($stmt) {
                            $stmt->bind_param($types, ...$bindParams);
                            if ($stmt->execute()) {
                                $this->pulledCount++;
                                $this->logSyncEvent($tableName, $uuid, 'SUCCESS', 'Downloaded: LWW Server Wins');
                            }
                            $stmt->close();
                        }
                    } else if ($cloudTime < $localTime) {
                        // Local wins, write to conflicts
                        $stmt = $this->con->prepare("INSERT INTO sync_conflicts (table_name, record_uuid, local_time, cloud_time, resolution) VALUES (?, ?, ?, ?, 'LOCAL_WINS')");
                        if ($stmt) {
                            $stmt->bind_param("ssss", $tableName, $uuid, $localTimeStr, $cloudTimeStr);
                            $stmt->execute();
                            $stmt->close();
                        }
                        $this->logSyncEvent($tableName, $uuid, 'SUCCESS', 'Conflict detected: LOCAL_WINS');
                        
                        // Queue this local winner back for upload
                        $this->con->query("
                            INSERT INTO `sync_queue` (table_name, record_uuid, operation, status, attempts, created_at)
                            VALUES ('$tableName', '$uuid', 'UPDATE', 'pending', 0, NOW())
                            ON DUPLICATE KEY UPDATE status = 'pending', attempts = 0
                        ");
                    }
                } else {
                    // Insert new record
                    unset($cleanRecord['id']);
                    $cols = array_keys($cleanRecord);
                    $placeholders = array_fill(0, count($cols), '?');
                    $types = str_repeat('s', count($cols));
                    $bindParams = array_values($cleanRecord);
                    
                    $insertQuery = "INSERT INTO `$tableName` (`" . implode("`, `", $cols) . "`) VALUES (" . implode(", ", $placeholders) . ")";
                    $stmt = $this->con->prepare($insertQuery);
                    if ($stmt) {
                        $stmt->bind_param($types, ...$bindParams);
                        if ($stmt->execute()) {
                            $this->pulledCount++;
                            $this->logSyncEvent($tableName, $uuid, 'SUCCESS', 'Downloaded: Inserted new record');
                        }
                        $stmt->close();
                    }
                }
            }
        }
        
        $this->con->query("SET @is_syncing = 0");
        $this->setSystemSetting('last_sync_timestamp', $resultData['server_time']);
        return true;
    }

    /**
     * Resolves UUIDs in downlinks to local integer IDs.
     */
    private function resolveParentUuids(&$record) {
        $mappings = [
            'branch_uuid' => ['table' => 'branch', 'keys' => ['branch_id', 'branchID']],
            'facility_uuid' => ['table' => 'facility', 'keys' => ['facility_id', 'facilityID', 'staff_id', 'staffID', 'user_id', 'userID']],
            'customer_uuid' => ['table' => 'customers', 'keys' => ['customer_id', 'customerID']],
            'stock_uuid' => ['table' => 'stocks', 'keys' => ['stock_id', 'stockID']],
            'order_uuid' => ['table' => 'orders', 'keys' => ['order_id', 'orderID']],
            'purchase_uuid' => ['table' => 'purchase_history', 'keys' => ['purchase_id', 'purchaseID']]
        ];
        
        foreach ($mappings as $uuid_field => $cfg) {
            if (isset($record[$uuid_field]) && !empty($record[$uuid_field])) {
                $stmt = $this->con->prepare("SELECT id FROM `" . $cfg['table'] . "` WHERE uuid = ? LIMIT 1");
                if ($stmt) {
                    $stmt->bind_param("s", $record[$uuid_field]);
                    $stmt->execute();
                    $res = $stmt->get_result()->fetch_assoc();
                    $stmt->close();
                    if ($res) {
                        $resolvedId = intval($res['id']);
                        foreach ($cfg['keys'] as $key) {
                            $record[$key] = $resolvedId;
                        }
                    }
                }
                unset($record[$uuid_field]);
            }
        }
    }

    /**
     * Maps local integer relationships to parent UUIDs.
     */
    private function mapRelationsToUuids($tableName, &$record) {
        $mappings = [
            'branch_id' => ['table' => 'branch', 'out_field' => 'branch_uuid'],
            'branchID' => ['table' => 'branch', 'out_field' => 'branch_uuid'],
            'facility_id' => ['table' => 'facility', 'out_field' => 'facility_uuid'],
            'facilityID' => ['table' => 'facility', 'out_field' => 'facility_uuid'],
            'staff_id' => ['table' => 'facility', 'out_field' => 'facility_uuid'],
            'staffID' => ['table' => 'facility', 'out_field' => 'facility_uuid'],
            'user_id' => ['table' => 'facility', 'out_field' => 'facility_uuid'],
            'customer_id' => ['table' => 'customers', 'out_field' => 'customer_uuid'],
            'customerID' => ['table' => 'customers', 'out_field' => 'customer_uuid'],
            'stock_id' => ['table' => 'stocks', 'out_field' => 'stock_uuid'],
            'stockID' => ['table' => 'stocks', 'out_field' => 'stock_uuid'],
            'order_id' => ['table' => 'orders', 'out_field' => 'order_uuid'],
            'orderID' => ['table' => 'orders', 'out_field' => 'order_uuid'],
            'purchase_id' => ['table' => 'purchase_history', 'out_field' => 'purchase_uuid'],
            'purchaseID' => ['table' => 'purchase_history', 'out_field' => 'purchase_uuid']
        ];
        
        foreach ($mappings as $fk_col => $cfg) {
            if (isset($record[$fk_col]) && !empty($record[$fk_col])) {
                $stmt = $this->con->prepare("SELECT uuid FROM `" . $cfg['table'] . "` WHERE id = ? LIMIT 1");
                if ($stmt) {
                    $stmt->bind_param("i", $record[$fk_col]);
                    $stmt->execute();
                    $res = $stmt->get_result()->fetch_assoc();
                    $stmt->close();
                    if ($res) {
                        $record[$cfg['out_field']] = $res['uuid'];
                    }
                }
            }
        }
    }

    /**
     * Fetches local table columns dynamically.
     */
    private function getTableColumns($tableName) {
        static $cache = [];
        if (isset($cache[$tableName])) {
            return $cache[$tableName];
        }
        $columns = [];
        $res = $this->con->query("DESCRIBE `$tableName`");
        if ($res) {
            while ($row = $res->fetch_assoc()) {
                $columns[] = $row['Field'];
            }
        }
        $cache[$tableName] = $columns;
        return $columns;
    }

    /**
     * Local setting values manager.
     */
    private function getSystemSetting($key) {
        $stmt = $this->con->prepare("SELECT val_value FROM system_settings WHERE key_name = ? LIMIT 1");
        if ($stmt) {
            $stmt->bind_param("s", $key);
            $stmt->execute();
            $res = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $res['val_value'] ?? null;
        }
        return null;
    }

    private function setSystemSetting($key, $value) {
        $stmt = $this->con->prepare("INSERT INTO system_settings (key_name, val_value) VALUES (?, ?) ON DUPLICATE KEY UPDATE val_value = ?");
        if ($stmt) {
            $stmt->bind_param("sss", $key, $value, $value);
            $stmt->execute();
            $stmt->close();
        }
    }

    /**
     * Logs synchronization events to local database.
     */
    private function logSyncEvent($tableName, $recordUuid, $status, $message) {
        $stmt = $this->con->prepare("INSERT INTO sync_logs (table_name, record_uuid, action, status, message, created_at) VALUES (?, ?, 'LOCAL_SYNC', ?, ?, NOW())");
        if ($stmt) {
            $stmt->bind_param("ssss", $tableName, $recordUuid, $status, $message);
            $stmt->execute();
            $stmt->close();
        }
    }

    public function getPushedCount() {
        return $this->pushedCount;
    }

    public function getPulledCount() {
        return $this->pulledCount;
    }
}
