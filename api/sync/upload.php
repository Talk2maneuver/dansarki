<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - SYNC UPLOAD API
 * POST /api/sync/upload
 * 
 * Receives batches of database updates from branch nodes and merges them
 * using Last-Write-Wins (LWW) conflict resolution.
 */

include_once(dirname(__DIR__) . '/api_helper.php');

// Security checks
requireHttps();
$branchId = authenticateRequest($con);
checkRateLimit($con);

// Restrict to POST method
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJsonResponse(['success' => false, 'error' => 'Method not allowed. Use POST.'], 405);
}

// Decode raw JSON input
$input = json_decode(file_get_contents('php://input'), true);
$batches = $input['batches'] ?? [];

if (empty($batches)) {
    sendJsonResponse(['success' => true, 'message' => 'No batches to upload.'], 200);
}

// Valid synchronized tables list
$allowedTables = [
    'branch', 'facility', 'customers', 'stocks', 'orders', 
    'order_items', 'purchase_history', 'expense', 'outstand', 
    'deposit_history', 'purchase_deposit_history'
];

// Helper to fetch table columns dynamically (cached per request)
function getTableColumns($con, $tableName) {
    static $cache = [];
    if (isset($cache[$tableName])) {
        return $cache[$tableName];
    }
    $columns = [];
    $res = $con->query("DESCRIBE `$tableName`");
    if ($res) {
        while ($row = $res->fetch_assoc()) {
            $columns[] = $row['Field'];
        }
    }
    $cache[$tableName] = $columns;
    return $columns;
}

// Helper to resolve parent UUIDs to local integer IDs
function resolveUuids($con, &$record) {
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
            $stmt = $con->prepare("SELECT id FROM `" . $cfg['table'] . "` WHERE uuid = ? LIMIT 1");
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

$results = [];

// Process each table batch
foreach ($batches as $tableName => $records) {
    if (!in_array($tableName, $allowedTables)) {
        $results[$tableName] = ['success' => false, 'error' => "Table '$tableName' is not allowed for synchronization."];
        continue;
    }
    
    $results[$tableName] = [];
    $tableColumns = getTableColumns($con, $tableName);
    
    foreach ($records as $record) {
        $uuid = $record['uuid'] ?? '';
        if (empty($uuid)) {
            continue;
        }
        
        // Force branch_id assignment to the authenticated branch
        $record['branch_id'] = $branchId;
        
        // Resolve parent UUIDs to local IDs
        resolveUuids($con, $record);
        
        // Filter record keys to only include columns that exist in the table
        $cleanRecord = [];
        foreach ($record as $key => $val) {
            if (in_array($key, $tableColumns)) {
                $cleanRecord[$key] = $val;
            }
        }
        
        if (empty($cleanRecord)) {
            $results[$tableName][$uuid] = ['success' => false, 'error' => 'Record contains no valid columns.'];
            continue;
        }
        
        // Check if record already exists on the server
        $checkStmt = $con->prepare("SELECT id, updated_at FROM `$tableName` WHERE uuid = ? LIMIT 1");
        $checkStmt->bind_param("s", $uuid);
        $checkStmt->execute();
        $existing = $checkStmt->get_result()->fetch_assoc();
        $checkStmt->close();
        
        if ($existing) {
            // Compare updated_at timestamps
            $localTimeStr = $existing['updated_at'] ?? '1970-01-01 00:00:00';
            $incomingTimeStr = $cleanRecord['updated_at'] ?? '1970-01-01 00:00:00';
            
            $localTime = strtotime($localTimeStr);
            $incomingTime = strtotime($incomingTimeStr);
            
            if ($incomingTime > $localTime) {
                // Update existing record (Last-Write-Wins: Client is newer)
                unset($cleanRecord['id']); // Prevent updating auto-increment primary key
                
                $updateParts = [];
                $types = '';
                $bindParams = [];
                
                foreach ($cleanRecord as $col => $val) {
                    $updateParts[] = "`$col` = ?";
                    $bindParams[] = $val;
                    $types .= 's'; // Default to string binding for simplicity
                }
                
                $bindParams[] = $uuid;
                $types .= 's';
                
                $updateQuery = "UPDATE `$tableName` SET " . implode(', ', $updateParts) . " WHERE uuid = ?";
                $updateStmt = $con->prepare($updateQuery);
                
                if ($updateStmt) {
                    $updateStmt->bind_param($types, ...$bindParams);
                    if ($updateStmt->execute()) {
                        $results[$tableName][$uuid] = ['success' => true, 'action' => 'updated'];
                        // Log success
                        $logStmt = $con->prepare("INSERT INTO sync_logs (table_name, record_uuid, action, status, message) VALUES (?, ?, 'UPLOAD', 'SUCCESS', 'Updated record via LWW')");
                        $logStmt->bind_param("ss", $tableName, $uuid);
                        $logStmt->execute();
                        $logStmt->close();
                    } else {
                        $results[$tableName][$uuid] = ['success' => false, 'error' => $updateStmt->error];
                    }
                    $updateStmt->close();
                } else {
                    $results[$tableName][$uuid] = ['success' => false, 'error' => 'Prepare failed during update.'];
                }
            } else {
                // Skip update (Server is newer or equal)
                $results[$tableName][$uuid] = ['success' => true, 'action' => 'skipped', 'message' => 'Server record is up to date.'];
                
                // If it is strictly less, register a conflict
                if ($incomingTime < $localTime) {
                    $conflictStmt = $con->prepare("INSERT INTO sync_conflicts (table_name, record_uuid, local_time, cloud_time, resolution) VALUES (?, ?, ?, ?, 'CLOUD_WINS')");
                    $conflictStmt->bind_param("ssss", $tableName, $uuid, $localTimeStr, $incomingTimeStr);
                    $conflictStmt->execute();
                    $conflictStmt->close();
                    
                    $logStmt = $con->prepare("INSERT INTO sync_logs (table_name, record_uuid, action, status, message) VALUES (?, ?, 'UPLOAD', 'SUCCESS', 'Conflict detected and resolved: CLOUD_WINS')");
                    $logStmt->bind_param("ss", $tableName, $uuid);
                    $logStmt->execute();
                    $logStmt->close();
                }
            }
        } else {
            // Insert new record
            unset($cleanRecord['id']); // Let MySQL handle auto-increment PK
            
            $cols = array_keys($cleanRecord);
            $placeholders = array_fill(0, count($cols), '?');
            $types = str_repeat('s', count($cols));
            $bindParams = array_values($cleanRecord);
            
            $insertQuery = "INSERT INTO `$tableName` (`" . implode("`, `", $cols) . "`) VALUES (" . implode(", ", $placeholders) . ")";
            $insertStmt = $con->prepare($insertQuery);
            
            if ($insertStmt) {
                $insertStmt->bind_param($types, ...$bindParams);
                if ($insertStmt->execute()) {
                    $results[$tableName][$uuid] = ['success' => true, 'action' => 'inserted'];
                    // Log success
                    $logStmt = $con->prepare("INSERT INTO sync_logs (table_name, record_uuid, action, status, message) VALUES (?, ?, 'UPLOAD', 'SUCCESS', 'Inserted new record')");
                    $logStmt->bind_param("ss", $tableName, $uuid);
                    $logStmt->execute();
                    $logStmt->close();
                } else {
                    $results[$tableName][$uuid] = ['success' => false, 'error' => $insertStmt->error];
                }
                $insertStmt->close();
            } else {
                $results[$tableName][$uuid] = ['success' => false, 'error' => 'Prepare failed during insert.'];
            }
        }
    }
}

sendJsonResponse(['success' => true, 'results' => $results]);
