<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - SYNC DOWNLOAD API
 * GET /api/sync/download
 * 
 * Fetches all updates on the cloud master server since a specific timestamp.
 */

include_once(dirname(__DIR__) . '/api_helper.php');

// Security checks
requireHttps();
$branchId = authenticateRequest($con);
checkRateLimit($con);

// Restrict to GET method
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendJsonResponse(['success' => false, 'error' => 'Method not allowed. Use GET.'], 405);
}

$since = $_GET['since'] ?? '1970-01-01 00:00:00';

// Validate timestamp format
if (strtotime($since) === false) {
    sendJsonResponse(['success' => false, 'error' => 'Invalid timestamp format for parameter since.'], 400);
}

// Valid synchronized tables in hierarchical order
$allowedTables = [
    'branch', 'facility', 'customers', 'stocks', 'orders', 
    'order_items', 'purchase_history', 'expense', 'outstand', 
    'deposit_history', 'purchase_deposit_history'
];

// Helper to check if a column exists in a table
function columnExists($con, $tableName, $columnName) {
    static $cache = [];
    $cacheKey = "$tableName.$columnName";
    if (isset($cache[$cacheKey])) {
        return $cache[$cacheKey];
    }
    
    $stmt = $con->prepare("
        SELECT COUNT(*) as count 
        FROM information_schema.columns 
        WHERE table_schema = DATABASE() 
          AND table_name = ? 
          AND column_name = ?
    ");
    $stmt->bind_param("ss", $tableName, $columnName);
    $stmt->execute();
    $res = $stmt->get_result()->fetch_assoc();
    $stmt->close();
    
    $exists = (intval($res['count'] ?? 0) > 0);
    $cache[$cacheKey] = $exists;
    return $exists;
}

// Helper to pre-cache and map parent integer IDs to parent UUIDs in download payloads
function injectParentUuids($con, $tableName, &$rows) {
    if (empty($rows)) return;
    
    $mappings = [
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
        'purchaseID' => ['table' => 'purchase_history', 'out_field' => 'purchase_uuid'],
        
        'branch_id' => ['table' => 'branch', 'out_field' => 'branch_uuid'],
        'branchID' => ['table' => 'branch', 'out_field' => 'branch_uuid']
    ];
    
    foreach ($mappings as $fk_col => $cfg) {
        if (array_key_exists($fk_col, $rows[0])) {
            $parentIds = array_filter(array_unique(array_column($rows, $fk_col)));
            if (!empty($parentIds)) {
                $idsList = implode(',', array_map('intval', $parentIds));
                $res = $con->query("SELECT id, uuid FROM `" . $cfg['table'] . "` WHERE id IN ($idsList)");
                $idMap = [];
                if ($res) {
                    while ($r = $res->fetch_assoc()) {
                        $idMap[$r['id']] = $r['uuid'];
                    }
                }
                foreach ($rows as &$row) {
                    $val = $row[$fk_col];
                    $row[$cfg['out_field']] = $idMap[$val] ?? null;
                }
            } else {
                foreach ($rows as &$row) {
                    $row[$cfg['out_field']] = null;
                }
            }
        }
    }
}

$batches = [];
$serverTime = date('Y-m-d H:i:s');

foreach ($allowedTables as $tableName) {
    $rows = [];
    
    // Check if table contains branch_id column to filter downloads
    $hasBranchId = columnExists($con, $tableName, 'branch_id');
    
    if ($hasBranchId) {
        // Query updates for this specific branch or global shared updates
        $query = "SELECT * FROM `$tableName` WHERE (branch_id = ? OR branch_id IS NULL) AND updated_at > ?";
        $stmt = $con->prepare($query);
        $stmt->bind_param("is", $branchId, $since);
    } else {
        // Query global tables
        $query = "SELECT * FROM `$tableName` WHERE updated_at > ?";
        $stmt = $con->prepare($query);
        $stmt->bind_param("s", $since);
    }
    
    if ($stmt) {
        $stmt->execute();
        $res = $stmt->get_result();
        while ($row = $res->fetch_assoc()) {
            $rows[] = $row;
        }
        $stmt->close();
    }
    
    // Map parent IDs to parent UUIDs so the client can resolve them locally
    injectParentUuids($con, $tableName, $rows);
    
    if (!empty($rows)) {
        $batches[$tableName] = $rows;
    }
}

sendJsonResponse([
    'success' => true,
    'server_time' => $serverTime,
    'batches' => $batches
]);
