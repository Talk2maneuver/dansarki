<?php
/**
 * DANSARKI SALES AND INVENTORY SYSTEM - BRANCH REGISTRATION API
 * POST /api/auth/branch-register
 * 
 * Registers a new branch node and generates a unique API token for it.
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
    // Fallback to post parameters
    $input = $_POST;
}

$name = trim($input['name'] ?? '');
$address = trim($input['address'] ?? '');
$phone = trim($input['phone'] ?? '');

// Simple validation
if (empty($name)) {
    sendJsonResponse(['success' => false, 'error' => 'Validation failed: Branch name is required.'], 400);
}

// Start Transaction
$con->begin_transaction();

try {
    // Generate UUID for the branch
    $branchUuid = sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
        mt_rand(0, 0xffff), mt_rand(0, 0xffff),
        mt_rand(0, 0xffff),
        mt_rand(0, 0x0fff) | 0x4000,
        mt_rand(0, 0x3fff) | 0x8000,
        mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
    );
    
    // Insert into branch table
    $stmt = $con->prepare("INSERT INTO `branch` (uuid, name, address, phone, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())");
    $stmt->bind_param("ssss", $branchUuid, $name, $address, $phone);
    $stmt->execute();
    $branchId = $stmt->insert_id;
    $stmt->close();
    
    // Generate a secure API Token
    $apiToken = 'ds_tok_' . bin2hex(random_bytes(24));
    
    // Insert token into api_tokens
    $stmtToken = $con->prepare("INSERT INTO `api_tokens` (branch_id, token, status, created_at) VALUES (?, ?, 'active', NOW())");
    $stmtToken->bind_param("is", $branchId, $apiToken);
    $stmtToken->execute();
    $stmtToken->close();
    
    $con->commit();
    
    sendJsonResponse([
        'success' => true,
        'message' => 'Branch successfully registered.',
        'branch_id' => $branchId,
        'branch_uuid' => $branchUuid,
        'api_token' => $apiToken
    ], 201);
    
} catch (Exception $e) {
    $con->rollback();
    sendJsonResponse([
        'success' => false,
        'error' => 'Registration failed: ' . $e->getMessage()
    ], 500);
}
