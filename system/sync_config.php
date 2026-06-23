<?php
/**
 * Offline-First Synchronization System Configuration
 * Dansarki General Enterprise
 */

// API Configuration
define('SYNC_API_URL', 'http://localhost/dansarki/api/sync.php'); // Replace with your cloud VPS domain (e.g., https://yourdomain.com/api/sync.php)
define('SYNC_API_TOKEN', 'ds_sync_secure_token_5fb901c34aef82b'); // Secure token for server authentication

// Local Database settings (already loaded via gyada.php, but used for reference)
define('SYNC_BATCH_SIZE', 100);
define('SYNC_RETRY_INTERVAL', 300); // 5 minutes in seconds

// Table Configuration with dependency ordering and relationships
// Dependency order: parents first, children next
$sync_tables = [
    'branch' => [
        'primary_key' => 'id',
        'relations' => []
    ],
    'facility' => [ // Users
        'primary_key' => 'id',
        'relations' => []
    ],
    'customers' => [
        'primary_key' => 'id',
        'relations' => []
    ],
    'stocks' => [ // Products
        'primary_key' => 'id',
        'relations' => []
    ],
    'purchase_history' => [
        'primary_key' => 'id',
        'relations' => [
            'stock_id' => 'stocks'
        ]
    ],
    'purchase_deposit_history' => [
        'primary_key' => 'id',
        'relations' => [
            'purchaseID' => 'purchase_history'
        ]
    ],
    'orders' => [ // Sales
        'primary_key' => 'id',
        'relations' => [
            'stockID' => 'stocks',
            'customerID' => 'customers'
        ]
    ],
    'order_items' => [ // Sales Items (if used)
        'primary_key' => 'id',
        'relations' => [
            'stockID' => 'stocks'
        ]
    ],
    'deposit_history' => [ // Customer payments
        'primary_key' => 'id',
        'relations' => [
            'customerID' => 'customers'
        ]
    ],
    'outstand' => [ // Outstanding credit balances
        'primary_key' => 'id',
        'relations' => [
            'customerID' => 'customers'
        ]
    ],
    'expense' => [
        'primary_key' => 'id',
        'relations' => []
    ]
];
?>
