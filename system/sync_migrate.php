<?php
/**
 * Database Migration Script
 * Sets up synchronization columns on transactional tables and creates helper sync tables.
 */
session_start();
include(__DIR__ . '/../assets/mashaAllah/gyada.php');
include(__DIR__ . '/sync_config.php');

header('Content-Type: text/plain');

echo "==================================================\n";
echo "DANSARKI - SYNC SYSTEM DATABASE MIGRATION\n";
echo "==================================================\n\n";

// Helper to check if a column exists
function columnExists($con, $table, $column) {
    $res = $con->query("SHOW COLUMNS FROM `$table` LIKE '$column'");
    return $res && $res->num_rows > 0;
}

// 1. Create Sync Helper Tables
echo "Checking Sync Helper Tables...\n";

// Sync Logs Table
$sql_logs = "CREATE TABLE IF NOT EXISTS `sync_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `table_name` VARCHAR(100) NOT NULL,
  `uuid` VARCHAR(36) NULL,
  `action` VARCHAR(50) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `message` TEXT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX(`table_name`),
  INDEX(`uuid`),
  INDEX(`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;";

if ($con->query($sql_logs)) {
    echo "✔ sync_logs table is ready.\n";
} else {
    echo "❌ Error creating sync_logs: " . $con->error . "\n";
}

// Sync Conflicts Table
$sql_conflicts = "CREATE TABLE IF NOT EXISTS `sync_conflicts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `table_name` VARCHAR(100) NOT NULL,
  `uuid` VARCHAR(36) NOT NULL,
  `local_timestamp` TIMESTAMP NULL,
  `server_timestamp` TIMESTAMP NULL,
  `resolution` VARCHAR(255) NOT NULL,
  `resolved_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX(`table_name`),
  INDEX(`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;";

if ($con->query($sql_conflicts)) {
    echo "✔ sync_conflicts table is ready.\n";
} else {
    echo "❌ Error creating sync_conflicts: " . $con->error . "\n";
}

// Sync Settings Table
$sql_settings = "CREATE TABLE IF NOT EXISTS `sync_settings` (
  `key_name` VARCHAR(100) PRIMARY KEY,
  `val_value` TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;";

if ($con->query($sql_settings)) {
    echo "✔ sync_settings table is ready.\n";
    // Initialize auto sync status
    $con->query("INSERT IGNORE INTO `sync_settings` (`key_name`, `val_value`) VALUES ('auto_sync_enabled', '1')");
    $con->query("INSERT IGNORE INTO `sync_settings` (`key_name`, `val_value`) VALUES ('last_sync_time', 'never')");
} else {
    echo "❌ Error creating sync_settings: " . $con->error . "\n";
}

// Rate Limits Table
$sql_rate_limits = "CREATE TABLE IF NOT EXISTS `rate_limits` (
  `ip` VARCHAR(45) NOT NULL,
  `timestamp` INT NOT NULL,
  INDEX (`ip`, `timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;";

if ($con->query($sql_rate_limits)) {
    echo "✔ rate_limits table is ready.\n";
} else {
    echo "❌ Error creating rate_limits: " . $con->error . "\n";
}

echo "\n--------------------------------------------------\n";
echo "Altering Business Tables...\n";

// 2. Modify business tables to add sync columns
foreach ($sync_tables as $table => $config) {
    echo "Processing table `$table`...\n";
    
    // List of columns to add
    $columns_to_add = [
        'uuid' => "VARCHAR(36) DEFAULT NULL",
        'created_at' => "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP",
        'updated_at' => "TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP",
        'sync_status' => "ENUM('pending', 'synced', 'failed') NOT NULL DEFAULT 'pending'",
        'sync_timestamp' => "TIMESTAMP NULL DEFAULT NULL",
        'deleted_flag' => "TINYINT(1) NOT NULL DEFAULT 0"
    ];
    
    foreach ($columns_to_add as $col => $definition) {
        if (!columnExists($con, $table, $col)) {
            // Special handling to make sure updated_at does not conflict with existing default timestamp columns if any
            $alter_sql = "ALTER TABLE `$table` ADD `$col` $definition";
            if ($con->query($alter_sql)) {
                echo "  ✔ Added column `$col` to `$table`.\n";
            } else {
                echo "  ❌ Error adding `$col` to `$table`: " . $con->error . "\n";
            }
        } else {
            echo "  • Column `$col` already exists in `$table`.\n";
        }
    }
    
    // Add index to uuid, sync_status, and deleted_flag for performance
    $con->query("ALTER TABLE `$table` ADD INDEX IF NOT EXISTS (`uuid`)");
    $con->query("ALTER TABLE `$table` ADD INDEX IF NOT EXISTS (`sync_status`)");
    $con->query("ALTER TABLE `$table` ADD INDEX IF NOT EXISTS (`deleted_flag`)");

    // 3. Populate empty UUIDs
    echo "  Populating UUIDs for existing records in `$table`...\n";
    $result = $con->query("SELECT `id` FROM `$table` WHERE `uuid` IS NULL OR `uuid` = ''");
    if ($result && $result->num_rows > 0) {
        $count = 0;
        while ($row = $result->fetch_assoc()) {
            // Generate UUID using MySQL UUID()
            $id = $row['id'];
            $update_sql = "UPDATE `$table` SET `uuid` = UUID(), `sync_status` = 'pending' WHERE `id` = $id";
            if ($con->query($update_sql)) {
                $count++;
            }
        }
        echo "  ✔ Successfully generated and updated $count UUIDs in `$table`.\n";
    } else {
        echo "  • No missing UUIDs in `$table`.\n";
    }
    
    // 4. Create trigger to auto-generate UUIDs on insert
    echo "  Creating trigger for auto-generating UUIDs in `$table`...\n";
    $trigger_name = "tg_{$table}_uuid";
    $con->query("DROP TRIGGER IF EXISTS `$trigger_name`");
    
    $trigger_sql = "CREATE TRIGGER `$trigger_name` BEFORE INSERT ON `$table` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END;";
    if ($con->query($trigger_sql)) {
        echo "  ✔ Created trigger `$trigger_name` successfully.\n";
    } else {
        echo "  ❌ Error creating trigger `$trigger_name`: " . $con->error . "\n";
    }
    echo "\n";
}

echo "==================================================\n";
echo "Migration Completed Successfully!\n";
echo "==================================================\n";
?>
