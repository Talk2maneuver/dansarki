<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - SYNC STATUS API
 * POST /api/sync/status
 * 
 * Verifies connection status and returns count statistics for sync tables.
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

$allowedTables = [
    'branch', 'facility', 'customers', 'stocks', 'orders', 
    'order_items', 'purchase_history', 'expense', 'outstand', 
    'deposit_history', 'purchase_deposit_history'
];

// Verify database connection and count table records
$status = [];
$totalRecords = 0;

foreach ($allowedTables as $tableName) {
    // Count only non-soft-deleted rows belonging to this branch (or global null branch)
    // To handle tables with or without branch_id / deleted_flag:
    $resCols = $con->query("DESCRIBE `$tableName`");
    $hasBranchId = false;
    $hasDeletedFlag = false;
    
    if ($resCols) {
        while ($col = $resCols->fetch_assoc()) {
            if ($col['Field'] === 'branch_id') $hasBranchId = true;
            if ($col['Field'] === 'deleted_flag') $hasDeletedFlag = true;
        }
    }
    
    $whereParts = [];
    if ($hasDeletedFlag) {
        $whereParts[] = "deleted_flag = 0";
    }
    if ($hasBranchId) {
        $whereParts[] = "(branch_id = " . intval($branchId) . " OR branch_id IS NULL)";
    }
    
    $whereClause = !empty($whereParts) ? "WHERE " . implode(" AND ", $whereParts) : "";
    $countQuery = "SELECT COUNT(*) as count FROM `$tableName` $whereClause";
    
    $res = $con->query($countQuery);
    $count = $res ? intval($res->fetch_assoc()['count']) : 0;
    
    $status['tables'][$tableName] = $count;
    $totalRecords += $count;
}

$status['total_active_records'] = $totalRecords;
$status['database_connected'] = true;
$status['server_time'] = date('Y-m-d H:i:s');
$status['branch_id'] = $branchId;

sendJsonResponse([
    'success' => true,
    'status' => $status
]);
