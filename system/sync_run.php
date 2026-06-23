<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - LOCAL SYNC RUNNER
 * 
 * Target script executed periodically by Task Scheduler / Cron.
 * Initializes LocalSyncManager and runs the push/pull cycle.
 */

// Run from CLI or web
if (php_sapi_name() !== 'cli') {
    header('Content-Type: application/json; charset=utf-8');
}

$base_dir = dirname(__DIR__);

// Load database connection
include_once($base_dir . '/assets/mashaAllah/gyada.php');

// Load configurations
include_once($base_dir . '/system/sync_config.php');

// Load Sync Manager
include_once($base_dir . '/system/LocalSyncManager.php');

if (!isset($con) || !$con) {
    $response = ['success' => false, 'error' => 'Database connection missing.'];
    echo json_encode($response);
    exit;
}

$syncManager = new LocalSyncManager($con);

// Run Synchronization
$success = $syncManager->synchronize();

$response = [
    'success' => $success,
    'timestamp' => date('Y-m-d H:i:s'),
    'push' => [
        'records_pushed' => $syncManager->getPushedCount()
    ],
    'pull' => [
        'records_pulled' => $syncManager->getPulledCount()
    ],
    'error' => $success ? '' : 'Synchronization failed. See sync_logs.'
];

echo json_encode($response);
exit;
