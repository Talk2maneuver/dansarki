<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - API HELPER
 * Common utilities for API endpoints (database connection, validation, rate limiting, authentication).
 */

// Error reporting settings (production-safe)
error_reporting(0);
ini_set('display_errors', 0);

// Load database connection
$db_path = dirname(__DIR__) . '/assets/mashaAllah/gyada.php';
if (file_exists($db_path)) {
    include_once($db_path);
}

// Fallback DB connection if $con is not defined
if (!isset($con) || !$con) {
    define('DB_SERVER_FALLBACK', 'localhost');
    define('DB_USER_FALLBACK', 'root');
    define('DB_PASS_FALLBACK', '');
    define('DB_NAME_FALLBACK', 'dansarki');
    
    $con = mysqli_connect(DB_SERVER_FALLBACK, DB_USER_FALLBACK, DB_PASS_FALLBACK, DB_NAME_FALLBACK);
    if (mysqli_connect_errno()) {
        sendJsonResponse([
            'success' => false,
            'error' => 'Database connection failed: ' . mysqli_connect_error()
        ], 500);
    }
}

// Unified JSON response helper
function sendJsonResponse($data, $statusCode = 200) {
    http_response_code($statusCode);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data);
    exit;
}

// Simple IP-based Rate Limiter (Database backed)
function checkRateLimit($con) {
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    $now = time();
    $window = $now - 60; // 1 minute window
    $limit = 100;        // Max 100 requests per minute
    
    // Create rate limits table if it does not exist dynamically
    $con->query("CREATE TABLE IF NOT EXISTS `rate_limits` (
        `ip` VARCHAR(45) NOT NULL,
        `timestamp` INT NOT NULL,
        INDEX `idx_rl_ip_time` (`ip`, `timestamp`)
    ) ENGINE=InnoDB;");
    
    // Probabilistic cleanup of old data (1% chance per request)
    if (rand(1, 100) === 1) {
        $con->query("DELETE FROM rate_limits WHERE timestamp < $window");
    }
    
    // Count requests in the current window
    $stmt = $con->prepare("SELECT COUNT(*) as count FROM rate_limits WHERE ip = ? AND timestamp > ?");
    $stmt->bind_param("si", $ip, $window);
    $stmt->execute();
    $res = $stmt->get_result()->fetch_assoc();
    $stmt->close();
    
    if ($res['count'] >= $limit) {
        sendJsonResponse([
            'success' => false,
            'error' => 'Too many requests. Rate limit exceeded.'
        ], 429);
    }
    
    // Log current request
    $stmt = $con->prepare("INSERT INTO rate_limits (ip, timestamp) VALUES (?, ?)");
    $stmt->bind_param("si", $ip, $now);
    $stmt->execute();
    $stmt->close();
}

// Authenticate API Token and return branch_id
function authenticateRequest($con) {
    $token = '';
    
    // 1. Check Authorization Bearer header
    $headers = array_change_key_case(getallheaders(), CASE_LOWER);
    if (isset($headers['authorization']) && preg_match('/Bearer\s(\S+)/', $headers['authorization'], $matches)) {
        $token = $matches[1];
    }
    
    // 2. Fallback to GET or POST request parameters
    if (empty($token)) {
        $token = $_GET['token'] ?? $_POST['token'] ?? '';
    }
    
    // 3. Fallback to raw JSON payload input
    if (empty($token)) {
        $rawInput = json_decode(file_get_contents('php://input'), true);
        $token = $rawInput['token'] ?? '';
    }
    
    if (empty($token)) {
        sendJsonResponse([
            'success' => false,
            'error' => 'Unauthorized. Missing API token.'
        ], 401);
    }
    
    // Query the api_tokens table
    $stmt = $con->prepare("SELECT branch_id FROM api_tokens WHERE token = ? AND status = 'active' LIMIT 1");
    if (!$stmt) {
        sendJsonResponse([
            'success' => false,
            'error' => 'Server error: unable to prepare auth statement.'
        ], 500);
    }
    
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        $stmt->close();
        sendJsonResponse([
            'success' => false,
            'error' => 'Unauthorized. Invalid or inactive API token.'
        ], 401);
    }
    
    $row = $result->fetch_assoc();
    $stmt->close();
    
    return intval($row['branch_id']);
}

// Safe function to check HTTPS requirement in production
function requireHttps() {
    // Note: Allow HTTP for localhost testing/XAMPP environments, but enforce in production
    $isLocalhost = in_array($_SERVER['REMOTE_ADDR'] ?? '', ['127.0.0.1', '::1']) || ($_SERVER['HTTP_HOST'] ?? '') === 'localhost';
    
    if (!$isLocalhost) {
        $isHttps = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || ($_SERVER['SERVER_PORT'] ?? 80) == 443;
        if (!$isHttps) {
            sendJsonResponse([
                'success' => false,
                'error' => 'Secure Connection Required. HTTPS must be used.'
            ], 403);
        }
    }
}
