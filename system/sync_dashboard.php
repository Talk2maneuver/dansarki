<?php
session_start();
error_reporting(E_ALL); // Enable error reporting for debugging
include('../assets/mashaAllah/gyada.php'); // Database connection
include('sync_config.php'); // Sync config

// Check if user is logged in
if (empty($_SESSION['email'])) {
    header('location:../index.php');
    exit;
}

// Handle AJAX settings update
if (isset($_POST['action']) && $_POST['action'] === 'toggle_auto_sync') {
    $status = isset($_POST['status']) && $_POST['status'] == 1 ? '1' : '0';
    
    // Ensure system_settings table exists
    $con->query("CREATE TABLE IF NOT EXISTS `system_settings` (
        `key_name` VARCHAR(100) PRIMARY KEY,
        `val_value` TEXT NULL,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB;");
    
    $stmt = $con->prepare("INSERT INTO system_settings (key_name, val_value) VALUES ('auto_sync_enabled', ?) ON DUPLICATE KEY UPDATE val_value = ?");
    $stmt->bind_param("ss", $status, $status);
    $success = $stmt->execute();
    
    header('Content-Type: application/json');
    echo json_encode(['success' => $success]);
    exit;
}

// 1. Get metrics
$total_pending = 0;
$total_failed = 0;
$table_stats = [];

// Get totals directly from sync_queue
$res_total_pending = $con->query("SELECT COUNT(*) as count FROM `sync_queue` WHERE `status` = 'pending'");
$total_pending = $res_total_pending ? intval($res_total_pending->fetch_assoc()['count']) : 0;

$res_total_failed = $con->query("SELECT COUNT(*) as count FROM `sync_queue` WHERE `status` = 'failed'");
$total_failed = $res_total_failed ? intval($res_total_failed->fetch_assoc()['count']) : 0;

foreach ($sync_tables as $table => $cfg) {
    // Count pending
    $res_pending = $con->query("SELECT COUNT(*) as count FROM `sync_queue` WHERE `table_name` = '$table' AND `status` = 'pending'");
    $pending_count = $res_pending ? intval($res_pending->fetch_assoc()['count']) : 0;

    // Count failed
    $res_failed = $con->query("SELECT COUNT(*) as count FROM `sync_queue` WHERE `table_name` = '$table' AND `status` = 'failed'");
    $failed_count = $res_failed ? intval($res_failed->fetch_assoc()['count']) : 0;

    // Total records
    // Check if deleted_flag column exists in table
    $resCols = $con->query("DESCRIBE `$table`");
    $hasDeletedFlag = false;
    if ($resCols) {
        while ($col = $resCols->fetch_assoc()) {
            if ($col['Field'] === 'deleted_flag') {
                $hasDeletedFlag = true;
                break;
            }
        }
    }
    $whereClause = $hasDeletedFlag ? "WHERE deleted_flag = 0" : "";
    $res_total = $con->query("SELECT COUNT(*) as count FROM `$table` $whereClause");
    $total_count = $res_total ? intval($res_total->fetch_assoc()['count']) : 0;

    $table_stats[$table] = [
        'pending' => $pending_count,
        'failed' => $failed_count,
        'total' => $total_count
    ];
}

// 2. Get settings
// Make sure system_settings table exists
$con->query("CREATE TABLE IF NOT EXISTS `system_settings` (
    `key_name` VARCHAR(100) PRIMARY KEY,
    `val_value` TEXT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;");

$res_sync_time = $con->query("SELECT val_value FROM system_settings WHERE key_name = 'last_sync_timestamp'");
$last_sync_time = $res_sync_time && $res_sync_time->num_rows > 0 ? $res_sync_time->fetch_assoc()['val_value'] : 'Never';

$res_auto_sync = $con->query("SELECT val_value FROM system_settings WHERE key_name = 'auto_sync_enabled'");
$auto_sync_enabled = $res_auto_sync && $res_auto_sync->num_rows > 0 ? intval($res_auto_sync->fetch_assoc()['val_value']) : 1;

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no">
    <title>Dansarki - Data Synchronization Dashboard</title>
    <link rel="icon" href="../assets/img/dansarkilogo.jpg">
    
    <!-- Global Mandatory Styles -->
    <link href="https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap" rel="stylesheet">
    <link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="../assets/css/plugins.css" rel="stylesheet">
    
    <!-- Page Level Styles -->
    <link href="../plugins/table/datatable/datatables.css" rel="stylesheet">
    <link href="../plugins/table/datatable/dt-global_style.css" rel="stylesheet">
    <link href="../assets/css/widgets/modules-widgets.css" rel="stylesheet">
    
    <!-- Custom styling for rich aesthetics -->
    <style>
        .sync-card {
            border-radius: 8px;
            box-shadow: 0 4px 20px 0 rgba(0,0,0,0.05);
            border: none;
            transition: all 0.3s ease;
        }
        .sync-card:hover {
            transform: translateY(-5px);
        }
        .status-dot {
            height: 12px;
            width: 12px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 5px;
        }
        .status-online { background-color: #25d366; box-shadow: 0 0 8px #25d366; }
        .status-offline { background-color: #ff3b30; box-shadow: 0 0 8px #ff3b30; }
        .status-syncing { 
            background-color: #007aff; 
            box-shadow: 0 0 8px #007aff;
            animation: pulse 1.5s infinite; 
        }
        @keyframes pulse {
            0% { transform: scale(0.95); opacity: 0.5; }
            50% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(0.95); opacity: 0.5; }
        }
        .badge-sync-pending { background-color: #e2a03f; color: #fff; }
        .badge-sync-failed { background-color: #e7515a; color: #fff; }
        .badge-sync-synced { background-color: #1abc9c; color: #fff; }
        .nav-tabs .nav-link.active {
            font-weight: 700;
            border-color: #1b55e2;
            color: #1b55e2;
        }
    </style>
</head>
<body class="sidebar-noneoverflow">
    <?php include('header.php'); ?>

    <div class="main-container" id="container">
        <div class="overlay"></div>
        <div class="search-overlay"></div>

        <?php include('sidebar.php'); ?>

        <div id="content" class="main-content">
            <div class="layout-px-spacing">
                <div class="page-header mt-4">
                    <div class="page-title">
                        <h3>Data Synchronization</h3>
                    </div>
                </div>

                <div class="row layout-top-spacing">
                    <!-- Status Cards -->
                    <div class="col-xl-3 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                        <div class="card sync-card bg-white p-4">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted font-weight-bold">System Status</h6>
                                    <h4 class="mt-2 d-flex align-items-center">
                                        <span id="conn-dot" class="status-dot status-offline"></span>
                                        <span id="conn-text">Checking...</span>
                                    </h4>
                                </div>
                                <div class="icon-box">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#1b55e2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-wifi"><path d="M5 12.55a11 11 0 0 1 14.08 0"></path><path d="M1.42 9a16 16 0 0 1 21.16 0"></path><path d="M8.53 16.11a6 6 0 0 1 6.95 0"></path><line x1="12" y1="20" x2="12.01" y2="20"></line></svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                        <div class="card sync-card bg-white p-4">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted font-weight-bold">Last Synchronized</h6>
                                    <h4 class="mt-2 text-primary" id="last-sync-display" style="font-size: 1.1rem; word-break: break-all;">
                                        <?php echo htmlspecialchars($last_sync_time); ?>
                                    </h4>
                                </div>
                                <div class="icon-box">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#8dbf42" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-clock"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                        <div class="card sync-card bg-white p-4">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted font-weight-bold">Pending Records</h6>
                                    <h4 class="mt-2 text-warning" id="pending-records-display"><?php echo $total_pending; ?></h4>
                                </div>
                                <div class="icon-box">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#e2a03f" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-refresh-cw"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                        <div class="card sync-card bg-white p-4">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted font-weight-bold">Failed Records</h6>
                                    <h4 class="mt-2 text-danger" id="failed-records-display"><?php echo $total_failed; ?></h4>
                                </div>
                                <div class="icon-box">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#e7515a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-triangle"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Operations Card -->
                <div class="row">
                    <div class="col-12 layout-spacing">
                        <div class="widget-content widget-content-area br-6 p-4">
                            <div class="row align-items-center">
                                <div class="col-md-6 col-12">
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" class="custom-control-input" id="autoSyncToggle" <?php echo $auto_sync_enabled ? 'checked' : ''; ?>>
                                        <label class="custom-control-label font-weight-bold" for="autoSyncToggle">Enable Background Auto-Sync</label>
                                    </div>
                                    <p class="text-muted small mt-1 mb-0">Runs automatically in background every 1 minute when internet is available.</p>
                                </div>
                                <div class="col-md-6 col-12 text-md-right mt-3 mt-md-0">
                                    <button class="btn btn-primary btn-lg" id="btnManualSync">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-rotate-cw mr-1"><polyline points="23 4 23 10 17 10"></polyline><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path></svg>
                                        Sync Now (Manual)
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabs for Logs and Tables -->
                <div class="row">
                    <div class="col-12 layout-spacing">
                        <div class="widget-content widget-content-area br-6 p-4">
                            <ul class="nav nav-tabs mb-3" id="syncTabs" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" id="summary-tab" data-toggle="tab" href="#summary" role="tab" aria-selected="true">Tables Summary</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="logs-tab" data-toggle="tab" href="#logs" role="tab" aria-selected="false">Sync History Logs</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="conflicts-tab" data-toggle="tab" href="#conflicts" role="tab" aria-selected="false">Conflicts resolved</a>
                                </li>
                            </ul>
                            
                            <div class="tab-content" id="syncTabsContent">
                                <!-- Summary tab -->
                                <div class="tab-pane fade show active" id="summary" role="tabpanel">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Table Name</th>
                                                    <th>Total Local Records</th>
                                                    <th>Pending Sync</th>
                                                    <th>Failed Sync</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php foreach ($table_stats as $tbl => $stats): ?>
                                                <tr>
                                                    <td class="font-weight-bold"><?php echo htmlspecialchars($tbl); ?></td>
                                                    <td><?php echo $stats['total']; ?></td>
                                                    <td>
                                                        <span class="badge <?php echo $stats['pending'] > 0 ? 'badge-sync-pending' : 'badge-light'; ?>">
                                                            <?php echo $stats['pending']; ?>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge <?php echo $stats['failed'] > 0 ? 'badge-sync-failed' : 'badge-light'; ?>">
                                                            <?php echo $stats['failed']; ?>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <?php if ($stats['pending'] > 0 || $stats['failed'] > 0): ?>
                                                            <span class="text-warning small"><i class="fa fa-spinner fa-spin"></i> Awaiting Sync</span>
                                                        <?php else: ?>
                                                            <span class="text-success small">✔ Up to date</span>
                                                        <?php endif; ?>
                                                    </td>
                                                </tr>
                                                <?php endforeach; ?>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <!-- Logs tab -->
                                <div class="tab-pane fade" id="logs" role="tabpanel">
                                    <div class="table-responsive">
                                        <table id="logs-table" class="table table-hover" style="width: 100%;">
                                            <thead>
                                                <tr>
                                                    <th>Timestamp</th>
                                                    <th>Table</th>
                                                    <th>Record UUID</th>
                                                    <th>Action</th>
                                                    <th>Status</th>
                                                    <th>Details</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php
                                                $res_logs = $con->query("SELECT * FROM sync_logs ORDER BY id DESC LIMIT 100");
                                                while ($lrow = $res_logs->fetch_assoc()):
                                                ?>
                                                <tr>
                                                    <td><?php echo $lrow['created_at']; ?></td>
                                                    <td><?php echo htmlspecialchars($lrow['table_name']); ?></td>
                                                    <td><code style="font-size: 0.8rem;"><?php echo htmlspecialchars($lrow['record_uuid'] ?? 'N/A'); ?></code></td>
                                                    <td><?php echo htmlspecialchars(strtoupper($lrow['action'])); ?></td>
                                                    <td>
                                                        <span class="badge <?php 
                                                            echo (strcasecmp($lrow['status'], 'failure') === 0 || strcasecmp($lrow['status'], 'failed') === 0) ? 'badge-danger' : 
                                                                 ((strcasecmp($lrow['status'], 'inserted') === 0 || strcasecmp($lrow['status'], 'updated') === 0 || strcasecmp($lrow['status'], 'success') === 0) ? 'badge-success' : 'badge-warning'); 
                                                        ?>">
                                                            <?php echo htmlspecialchars($lrow['status']); ?>
                                                        </span>
                                                    </td>
                                                    <td><?php echo htmlspecialchars($lrow['message'] ?? ''); ?></td>
                                                </tr>
                                                <?php endwhile; ?>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <!-- Conflicts tab -->
                                <div class="tab-pane fade" id="conflicts" role="tabpanel">
                                    <div class="table-responsive">
                                        <table id="conflicts-table" class="table table-hover" style="width: 100%;">
                                            <thead>
                                                <tr>
                                                    <th>Resolved At</th>
                                                    <th>Table</th>
                                                    <th>Record UUID</th>
                                                    <th>Local Timestamp</th>
                                                    <th>Cloud Timestamp</th>
                                                    <th>Resolution Outcome</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php
                                                $res_conflicts = $con->query("SELECT * FROM sync_conflicts ORDER BY id DESC LIMIT 100");
                                                while ($crow = $res_conflicts->fetch_assoc()):
                                                ?>
                                                <tr>
                                                    <td><?php echo $crow['created_at']; ?></td>
                                                    <td><?php echo htmlspecialchars($crow['table_name']); ?></td>
                                                    <td><code style="font-size: 0.8rem;"><?php echo htmlspecialchars($crow['record_uuid']); ?></code></td>
                                                    <td><?php echo $crow['local_time']; ?></td>
                                                    <td><?php echo $crow['cloud_time']; ?></td>
                                                    <td>
                                                        <span class="badge <?php echo (strcasecmp($crow['resolution'], 'cloud_wins') === 0 || strcasecmp($crow['resolution'], 'server_wins') === 0) ? 'badge-info' : 'badge-primary'; ?>">
                                                            <?php echo (strcasecmp($crow['resolution'], 'cloud_wins') === 0 || strcasecmp($crow['resolution'], 'server_wins') === 0) ? 'Cloud Wins (Updated)' : 'Local Wins (Kept)'; ?>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <?php endwhile; ?>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Toast Notifications container -->
                <div style="position: fixed; bottom: 20px; right: 20px; z-index: 9999;">
                    <div id="syncToast" class="toast hide" role="alert" aria-live="assertive" aria-atomic="true" data-delay="6000">
                        <div class="toast-header bg-primary text-white">
                            <strong class="mr-auto"><i class="fa fa-refresh mr-1"></i> Data Synchronization</strong>
                            <button type="button" class="ml-2 mb-1 close text-white" data-dismiss="toast" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="toast-body" id="syncToastBody">
                            Sync process started...
                        </div>
                    </div>
                </div>

                <?php include('footer.php'); ?>
            </div>
        </div>
    </div>

    <!-- Global Mandatory Scripts -->
    <script src="../assets/js/libs/jquery-3.1.1.min.js"></script>
    <script src="../bootstrap/js/popper.min.js"></script>
    <script src="../bootstrap/js/bootstrap.min.js"></script>
    <script src="../plugins/perfect-scrollbar/perfect-scrollbar.min.js"></script>
    <script src="../assets/js/app.js"></script>
    
    <!-- Datatables -->
    <script src="../plugins/table/datatable/datatables.js"></script>
    
    <script>
        $(document).ready(function() {
            App.init();
            
            // Initialize datatables
            $('#logs-table').DataTable({
                "pageLength": 10,
                "ordering": false,
                "oLanguage": {
                    "oPaginate": { "sPrevious": '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-left"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>', "sNext": '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-right"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>' },
                    "sInfo": "Showing page _PAGE_ of _PAGES_",
                    "sSearchPlaceholder": "Search logs...",
                    "sLengthMenu": "Results :  _MENU_",
                }
            });
            $('#conflicts-table').DataTable({
                "pageLength": 10,
                "ordering": false,
                "oLanguage": {
                    "oPaginate": { "sPrevious": '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-left"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>', "sNext": '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-right"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>' },
                    "sInfo": "Showing page _PAGE_ of _PAGES_",
                    "sSearchPlaceholder": "Search conflicts...",
                    "sLengthMenu": "Results :  _MENU_",
                }
            });

            // 1. Connection Monitoring
            function checkConnection() {
                if (navigator.onLine) {
                    // Quick ping to api endpoint to verify actual internet routing
                    $.ajax({
                        url: 'sync_run.php',
                        type: 'GET',
                        timeout: 5000,
                        success: function() {
                            $('#conn-dot').removeClass('status-offline status-syncing').addClass('status-online');
                            $('#conn-text').text('Online');
                        },
                        error: function() {
                            $('#conn-dot').removeClass('status-online status-syncing').addClass('status-offline');
                            $('#conn-text').text('Offline (Local Host)');
                        }
                    });
                } else {
                    $('#conn-dot').removeClass('status-online status-syncing').addClass('status-offline');
                    $('#conn-text').text('Offline');
                }
            }

            checkConnection();
            setInterval(checkConnection, 10000); // Check status every 10 seconds

            // 2. Toggle Auto-Sync
            $('#autoSyncToggle').change(function() {
                var isChecked = $(this).is(':checked') ? 1 : 0;
                $.ajax({
                    url: 'sync_dashboard.php',
                    type: 'POST',
                    data: {
                        action: 'toggle_auto_sync',
                        status: isChecked
                    },
                    success: function(res) {
                        if (res.success) {
                            showToast("Auto-Sync " + (isChecked ? "Enabled" : "Disabled") + " successfully.");
                        } else {
                            alert("Failed to update auto-sync setting.");
                        }
                    }
                });
            });

            // 3. Manual Sync Button
            $('#btnManualSync').click(function() {
                var btn = $(this);
                btn.prop('disabled', true);
                btn.html('<i class="fa fa-spinner fa-spin mr-1"></i> Syncing...');
                $('#conn-dot').removeClass('status-online status-offline').addClass('status-syncing');
                showToast("Synchronization started in background...");

                $.ajax({
                    url: 'sync_run.php?manual=1',
                    type: 'GET',
                    success: function(res) {
                        btn.prop('disabled', false);
                        btn.html('<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-rotate-cw mr-1"><polyline points="23 4 23 10 17 10"></polyline><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path></svg> Sync Now (Manual)');
                        checkConnection();
                        
                        if (res.success) {
                            var pushed = res.push.records_pushed || 0;
                            var pulled = res.pull.records_pulled || 0;
                            
                            $('#last-sync-display').text(res.timestamp);
                            
                            showToast("Synchronization completed.<br>Pushed: " + pushed + " records.<br>Pulled: " + pulled + " records.");
                            
                            // Reload stats/page after 2 seconds to reflect new counts
                            setTimeout(function() {
                                location.reload();
                            }, 2000);
                        } else {
                            showToast("Sync finished with error: " + res.error);
                        }
                    },
                    error: function(xhr) {
                        btn.prop('disabled', false);
                        btn.html('<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-rotate-cw mr-1"><polyline points="23 4 23 10 17 10"></polyline><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path></svg> Sync Now (Manual)');
                        checkConnection();
                        showToast("Synchronization failed. Connection error.");
                    }
                });
            });

            function showToast(message) {
                $('#syncToastBody').html(message);
                $('#syncToast').toast('show');
            }
        });
    </script>
</body>
</html>
