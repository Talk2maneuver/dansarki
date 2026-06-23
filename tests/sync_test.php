<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - SYNC INTEGRATION TEST SUITE
 * 
 * Runs end-to-end checks to validate:
 *   1. Database columns existence (uuid, branch_id, created_at, updated_at).
 *   2. Synchronization tables schema integrity.
 *   3. Auto-queue trigger firing on business table inserts.
 *   4. REST API routing and auth challenge responses.
 */

define('CLI_MODE', php_sapi_name() === 'cli');

if (!CLI_MODE) {
    echo "<html><head><title>Sync Test Suite</title><style>
    body { font-family: monospace; background: #1a1a2e; color: #e2e2e2; padding: 20px; }
    .success { color: #4caf50; font-weight: bold; }
    .danger { color: #f44336; font-weight: bold; }
    .info { color: #00bcd4; }
    h2 { border-bottom: 1px solid #333; padding-bottom: 8px; }
    </style></head><body>";
}

function logTest($name, $status, $message = '') {
    if (CLI_MODE) {
        $statusStr = $status ? "[OK]  " : "[FAIL]";
        echo "$statusStr $name" . ($message ? " - $message" : "") . "\n";
    } else {
        $class = $status ? 'success' : 'danger';
        echo "<div>[<span class='$class'>" . ($status ? 'PASS' : 'FAIL') . "</span>] <strong>$name</strong>" . ($message ? " - $message" : "") . "</div>";
    }
}

// 1. Load connection
$base_dir = dirname(__DIR__);
include_once($base_dir . '/assets/mashaAllah/gyada.php');

if (!isset($con) || !$con) {
    logTest("Database Connection", false, "Connection variable \$con is not defined.");
    exit;
}
logTest("Database Connection", true, "Successfully connected to " . DB_NAME);

// 2. Check sync tables presence
$requiredSyncTables = ['sync_logs', 'sync_queue', 'sync_conflicts', 'api_tokens', 'system_settings'];
foreach ($requiredSyncTables as $tbl) {
    $res = $con->query("SHOW TABLES LIKE '$tbl'");
    if ($res && $res->num_rows > 0) {
        logTest("Table Check: $tbl", true, "Table exists.");
    } else {
        logTest("Table Check: $tbl", false, "Table is missing. Run Phase 2 migration.");
    }
}

// 3. Check columns in synchronized tables
$allowedTables = [
    'branch', 'facility', 'customers', 'stocks', 'orders', 
    'order_items', 'purchase_history', 'expense', 'outstand', 
    'deposit_history', 'purchase_deposit_history'
];

$missingCols = 0;
foreach ($allowedTables as $tbl) {
    $requiredCols = ['uuid', 'branch_id', 'created_at', 'updated_at'];
    foreach ($requiredCols as $col) {
        // Skip branch_id on branch table itself
        if ($tbl === 'branch' && $col === 'branch_id') continue;
        
        $res = $con->query("SHOW COLUMNS FROM `$tbl` LIKE '$col'");
        if ($res && $res->num_rows > 0) {
            // Found
        } else {
            logTest("Column Check: $tbl.$col", false, "Missing column.");
            $missingCols++;
        }
    }
}
if ($missingCols === 0) {
    logTest("Business Tables Schema Check", true, "All 11 synchronized tables contain sync metadata columns.");
} else {
    logTest("Business Tables Schema Check", false, "Found $missingCols missing columns. Run Phase 1 migration.");
}

// 4. Test database trigger auto-queuing
$testUuid = 'test-customer-uuid-9999';
$con->query("DELETE FROM `sync_queue` WHERE record_uuid = '$testUuid'");
$con->query("DELETE FROM `customers` WHERE uuid = '$testUuid'");

// Insert mock customer row
$insertOk = $con->query("
    INSERT INTO `customers` (uuid, customer_name, phone, address, created_at, updated_at) 
    VALUES ('$testUuid', 'Sync Tester', '0000000000', 'Test Suite', NOW(), NOW())
");

if ($insertOk) {
    // Check if trigger added it to sync_queue
    $resQueue = $con->query("SELECT * FROM `sync_queue` WHERE record_uuid = '$testUuid' LIMIT 1");
    if ($resQueue && $resQueue->num_rows > 0) {
        $row = $resQueue->fetch_assoc();
        logTest("Trigger Test (AFTER INSERT)", true, "New row was automatically added to sync_queue with status: " . $row['status']);
    } else {
        logTest("Trigger Test (AFTER INSERT)", false, "No queue entry detected. Run Phase 4 trigger migration.");
    }
    
    // Clean up
    $con->query("DELETE FROM `sync_queue` WHERE record_uuid = '$testUuid'");
    $con->query("DELETE FROM `customers` WHERE uuid = '$testUuid'");
} else {
    logTest("Trigger Test", false, "Failed to insert test customer row: " . $con->error);
}

// 5. Check local REST API routing accessibility
$localApiUrl = 'http://localhost/dansarki/api/sync/status.php';
$ch = curl_init($localApiUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 3);
$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($httpCode === 401) {
    logTest("API Auth Challenge", true, "Auth endpoint blocked request with HTTP status 401 (Unauthorized) as expected.");
} else {
    logTest("API Auth Challenge", false, "API status endpoint returned HTTP status $httpCode instead of 401. Ensure .htaccess / authentication is enabled.");
}

if (!CLI_MODE) {
    echo "</body></html>";
}
