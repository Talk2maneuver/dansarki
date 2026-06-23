<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - SYNC LOGS API
 * GET /api/sync/logs
 * 
 * Fetches page-segmented synchronization execution logs from the server.
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

// Read paging parameters
$page = intval($_GET['page'] ?? 1);
$limit = intval($_GET['limit'] ?? 50);

if ($page < 1) $page = 1;
if ($limit < 1 || $limit > 100) $limit = 50; // Cap page limit to 100

$offset = ($page - 1) * $limit;

// Count total sync logs
$countRes = $con->query("SELECT COUNT(*) as total FROM `sync_logs`");
$totalLogs = $countRes ? intval($countRes->fetch_assoc()['total']) : 0;

// Fetch logs ordered by recent events
$stmt = $con->prepare("
    SELECT id, table_name, record_uuid, action, status, message, created_at 
    FROM `sync_logs` 
    ORDER BY id DESC 
    LIMIT ? OFFSET ?
");

$logs = [];

if ($stmt) {
    $stmt->bind_param("ii", $limit, $offset);
    $stmt->execute();
    $res = $stmt->get_result();
    while ($row = $res->fetch_assoc()) {
        $logs[] = $row;
    }
    $stmt->close();
}

sendJsonResponse([
    'success' => true,
    'total_records' => $totalLogs,
    'page' => $page,
    'limit' => $limit,
    'logs' => $logs
]);
