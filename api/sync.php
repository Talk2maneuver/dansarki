<?php
/**
 * REST API Endpoint for Cloud Synchronization
 * Supports push, pull, status, and logs actions.
 */

// Error reporting settings
error_reporting(0);
ini_set('display_errors', 0);

header('Content-Type: application/json');

// 1. Database Connection Initialization
// Try standard paths relative to project root
$db_paths = [
    __DIR__ . '/../assets/mashaAllah/gyada.php',
    __DIR__ . '/../system/sync_config.php'
];

foreach ($db_paths as $path) {
    if (file_exists($path)) {
        include_once($path);
    }
}

// Fallback DB connection if gyada.php is not loaded or didn't connect
if (!isset($con) || !$con) {
    $db_host = defined('DB_SERVER') ? DB_SERVER : 'localhost';
    $db_user = defined('DB_USER') ? DB_USER : 'root';
    $db_pass = defined('DB_PASS') ? DB_PASS : '';
    $db_name = defined('DB_NAME') ? DB_NAME : 'dansarki';
    
    $con = @mysqli_connect($db_host, $db_user, $db_pass, $db_name);
    if (mysqli_connect_errno()) {
        echo json_encode([
            'success' => false,
            'error' => 'Database connection failed: ' . mysqli_connect_error()
        ]);
        exit;
    }
}

// Ensure SyncManager is available
if (file_exists(__DIR__ . '/../system/SyncManager.php')) {
    include_once(__DIR__ . '/../system/SyncManager.php');
} else {
    // If running standalone on cloud server
    include_once(__DIR__ . '/SyncManager.php');
}

// 2. Security Checks & Rate Limiting
$client_ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';

// Simple Rate Limiting check
function isRateLimited($con, $ip) {
    $now = time();
    $window = $now - 60; // 1 minute window
    $limit = 100; // max 100 requests per minute
    
    // Clean old entries (probabilistic cleanup to avoid overhead on every request)
    if (rand(1, 100) === 1) {
        $con->query("DELETE FROM rate_limits WHERE timestamp < $window");
    }
    
    // Count requests
    $stmt = $con->prepare("SELECT COUNT(*) as count FROM rate_limits WHERE ip = ? AND timestamp > ?");
    $stmt->bind_param("si", $ip, $window);
    $stmt->execute();
    $res = $stmt->get_result()->fetch_assoc();
    
    if ($res['count'] >= $limit) {
        return true;
    }
    
    // Log current request
    $stmt = $con->prepare("INSERT INTO rate_limits (ip, timestamp) VALUES (?, ?)");
    $stmt->bind_param("si", $ip, $now);
    $stmt->execute();
    
    return false;
}

if (isRateLimited($con, $client_ip)) {
    http_response_code(429);
    echo json_encode(['success' => false, 'error' => 'Too many requests. Rate limit exceeded.']);
    exit;
}

// 3. API Token Authentication
// Support Authorization header or parameter token
$authHeader = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
$token = '';

if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
    $token = $matches[1];
} else {
    // Try POST/GET token
    $jsonData = json_decode(file_get_contents('php://input'), true);
    $token = $_GET['token'] ?? $_POST['token'] ?? $jsonData['token'] ?? '';
}

$expected_token = defined('SYNC_API_TOKEN') ? SYNC_API_TOKEN : 'ds_sync_secure_token_5fb901c34aef82b';

if (empty($token) || $token !== $expected_token) {
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Unauthorized. Invalid API token.']);
    exit;
}

// 4. Action Routing
// Support clean URL routing (/api/sync/push) and request parameters (?action=push)
$action = $_GET['action'] ?? $_POST['action'] ?? null;
$uri = $_SERVER['REQUEST_URI'];

if (strpos($uri, '/api/sync/push') !== false) {
    $action = 'push';
} elseif (strpos($uri, '/api/sync/pull') !== false) {
    $action = 'pull';
} elseif (strpos($uri, '/api/sync/status') !== false) {
    $action = 'status';
} elseif (strpos($uri, '/api/sync/logs') !== false) {
    $action = 'logs';
}

$syncManager = new SyncManager($con);

switch ($action) {
    case 'push':
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(405);
            echo json_encode(['success' => false, 'error' => 'Method not allowed. Use POST.']);
            break;
        }
        
        $jsonData = json_decode(file_get_contents('php://input'), true);
        $batches = $jsonData['batches'] ?? [];
        
        if (empty($batches)) {
            echo json_encode(['success' => true, 'results' => [], 'message' => 'No batches found in request.']);
            break;
        }
        
        $results = $syncManager->processIncomingPush($batches);
        echo json_encode(['success' => true, 'results' => $results]);
        break;

    case 'pull':
        $since = $_GET['since'] ?? '1970-01-01 00:00:00';
        // Validate date format
        if (strtotime($since) === false) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Invalid timestamp format for parameter since.']);
            break;
        }
        
        $serverTime = date('Y-m-d H:i:s');
        $batches = $syncManager->getUpdatesForPull($since);
        
        echo json_encode([
            'success' => true,
            'server_time' => $serverTime,
            'batches' => $batches
        ]);
        break;

    case 'status':
        // Calculate status counts
        global $sync_tables;
        $status = [];
        $total_records = 0;
        
        foreach ($sync_tables as $table => $cfg) {
            $res = $con->query("SELECT COUNT(*) as count FROM `$table` WHERE deleted_flag = 0");
            $count = $res ? $res->fetch_assoc()['count'] : 0;
            $status['tables'][$table] = $count;
            $total_records += $count;
        }
        
        $status['total_records'] = $total_records;
        $status['database_connected'] = true;
        $status['server_time'] = date('Y-m-d H:i:s');
        
        echo json_encode(['success' => true, 'status' => $status]);
        break;

    case 'logs':
        $page = intval($_GET['page'] ?? 1);
        $limit = intval($_GET['limit'] ?? 50);
        $offset = ($page - 1) * $limit;
        
        $res = $con->query("SELECT COUNT(*) as total FROM sync_logs");
        $total = $res ? $res->fetch_assoc()['total'] : 0;
        
        $stmt = $con->prepare("SELECT * FROM sync_logs ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->bind_param("ii", $limit, $offset);
        $stmt->execute();
        $logs = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        
        echo json_encode([
            'success' => true,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
            'logs' => $logs
        ]);
        break;

    default:
        http_response_code(404);
        echo json_encode(['success' => false, 'error' => 'Endpoint not found. Specify a valid sync action.']);
        break;
}
?>
