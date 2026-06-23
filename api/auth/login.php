<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - AUTHENTICATION / LOGIN API
 * POST /api/auth/login
 * 
 * Verifies a branch node's access token and returns confirmation.
 */

include_once(dirname(__DIR__) . '/api_helper.php');

// Security checks
requireHttps();
checkRateLimit($con);

// Restrict to POST method
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJsonResponse(['success' => false, 'error' => 'Method not allowed. Use POST.'], 405);
}

// Decode raw JSON input
$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    $input = $_POST;
}

$branchUuid = trim($input['branch_uuid'] ?? '');
$apiToken = trim($input['api_token'] ?? $input['token'] ?? '');

// Simple validation
if (empty($branchUuid) || empty($apiToken)) {
    sendJsonResponse(['success' => false, 'error' => 'Validation failed: branch_uuid and api_token are required.'], 400);
}

// Verify credentials
$stmt = $con->prepare("
    SELECT b.id, b.name 
    FROM `branch` b 
    JOIN `api_tokens` t ON b.id = t.branch_id 
    WHERE b.uuid = ? AND t.token = ? AND t.status = 'active'
    LIMIT 1
");

if (!$stmt) {
    sendJsonResponse(['success' => false, 'error' => 'Server error during authentication preparation.'], 500);
}

$stmt->bind_param("ss", $branchUuid, $apiToken);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    $stmt->close();
    sendJsonResponse(['success' => false, 'error' => 'Unauthorized. Invalid branch UUID or API token.'], 401);
}

$branch = $result->fetch_assoc();
$stmt->close();

sendJsonResponse([
    'success' => true,
    'message' => 'Authentication successful.',
    'branch_id' => intval($branch['id']),
    'branch_name' => $branch['name'],
    'authenticated_at' => date('Y-m-d H:i:s')
]);
