-- =========================================================================
-- DANSARKI SALES AND INVENTORY SYSTEM - DATABASE MIGRATION SCRIPT
-- PHASE 1: SAFE ALTERATIONS FOR EXISTING TABLES
-- =========================================================================
-- This script safely extends the existing tables to support offline-first sync.
-- It adds:
--   1. uuid (VARCHAR 36) - Globally unique synchronization key
--   2. branch_id (INT) - Local branch identifier
--   3. created_at (DATETIME) - Creation timestamp
--   4. updated_at (DATETIME) - Last modification timestamp
--
-- Features:
--   - Uses a stored procedure helper to ensure idempotency (safe to re-run).
--   - Automatically populates missing UUIDs and timestamps for existing records.
--   - Creates triggers to auto-generate UUIDs for future local inserts.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. STORED PROCEDURE HELPER FOR IDempotent COLUMN ADDITIONS
-- -------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS AddColumnSafely;

DELIMITER //

CREATE PROCEDURE AddColumnSafely(
    IN p_table_name VARCHAR(64),
    IN p_column_name VARCHAR(64),
    IN p_column_definition VARCHAR(255)
)
BEGIN
    DECLARE col_exists INT DEFAULT 0;
    
    -- Check if the column already exists in the target table
    SELECT COUNT(*) INTO col_exists
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = p_table_name
      AND column_name = p_column_name;
      
    -- If the column does not exist, execute ALTER TABLE dynamically
    IF col_exists = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table_name, '` ADD COLUMN `', p_column_name, '` ', p_column_definition);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //

DELIMITER ;

-- -------------------------------------------------------------------------
-- 2. APPLY SAFE ALTERATIONS TO SYNCHRONIZED TABLES
-- -------------------------------------------------------------------------

-- List of synchronized tables to modify:
-- branch, facility, customers, stocks, orders, order_items, purchase_history, expense, outstand, deposit_history, purchase_deposit_history

-- 2.1. Table: branch
CALL AddColumnSafely('branch', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('branch', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('branch', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP AFTER address');
CALL AddColumnSafely('branch', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at');

-- 2.2. Table: facility
CALL AddColumnSafely('facility', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('facility', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('facility', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('facility', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- 2.3. Table: customers
CALL AddColumnSafely('customers', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('customers', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('customers', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('customers', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- 2.4. Table: stocks
CALL AddColumnSafely('stocks', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('stocks', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('stocks', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('stocks', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- 2.5. Table: orders
CALL AddColumnSafely('orders', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('orders', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('orders', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('orders', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- 2.6. Table: order_items
CALL AddColumnSafely('order_items', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('order_items', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('order_items', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('order_items', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- 2.7. Table: purchase_history
CALL AddColumnSafely('purchase_history', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('purchase_history', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('purchase_history', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('purchase_history', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- 2.8. Table: expense
CALL AddColumnSafely('expense', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('expense', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('expense', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('expense', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- 2.9. Table: outstand
CALL AddColumnSafely('outstand', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('outstand', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('outstand', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('outstand', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- 2.10. Table: deposit_history
CALL AddColumnSafely('deposit_history', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('deposit_history', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('deposit_history', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('deposit_history', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- 2.11. Table: purchase_deposit_history
CALL AddColumnSafely('purchase_deposit_history', 'uuid', 'VARCHAR(36) NULL UNIQUE AFTER id');
CALL AddColumnSafely('purchase_deposit_history', 'branch_id', 'INT NULL AFTER uuid');
CALL AddColumnSafely('purchase_deposit_history', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
CALL AddColumnSafely('purchase_deposit_history', 'updated_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');

-- Cleanup helper procedure
DROP PROCEDURE IF EXISTS AddColumnSafely;

-- -------------------------------------------------------------------------
-- 3. POPULATE INITIAL VALUES FOR EXISTING RECORDS
-- -------------------------------------------------------------------------

-- Generate UUIDs and default timestamps for records that currently lack them.
-- Uses the MySQL built-in UUID() function.

UPDATE `branch` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `facility` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `customers` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `stocks` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `orders` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `order_items` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `purchase_history` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `expense` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `outstand` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `deposit_history` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';
UPDATE `purchase_deposit_history` SET `uuid` = UUID() WHERE `uuid` IS NULL OR `uuid` = '';

-- Initialize timestamps for old records that have NULL values
UPDATE `branch` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `facility` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `customers` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `stocks` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `orders` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `order_items` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `purchase_history` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `expense` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `outstand` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `deposit_history` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;
UPDATE `purchase_deposit_history` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `created_at` IS NULL;

-- -------------------------------------------------------------------------
-- 4. CREATE DATABASE TRIGGERS FOR AUTOMATIC UUID GENERATION ON INSERT
-- -------------------------------------------------------------------------

-- Triggers guarantee that any new row inserted locally by the existing codebase
-- automatically generates a globally unique UUID key, keeping changes 100% compatible.

-- 4.1. Table: branch
DROP TRIGGER IF EXISTS tg_branch_uuid;
DELIMITER //
CREATE TRIGGER tg_branch_uuid BEFORE INSERT ON `branch`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.2. Table: facility
DROP TRIGGER IF EXISTS tg_facility_uuid;
DELIMITER //
CREATE TRIGGER tg_facility_uuid BEFORE INSERT ON `facility`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.3. Table: customers
DROP TRIGGER IF EXISTS tg_customers_uuid;
DELIMITER //
CREATE TRIGGER tg_customers_uuid BEFORE INSERT ON `customers`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.4. Table: stocks
DROP TRIGGER IF EXISTS tg_stocks_uuid;
DELIMITER //
CREATE TRIGGER tg_stocks_uuid BEFORE INSERT ON `stocks`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.5. Table: orders
DROP TRIGGER IF EXISTS tg_orders_uuid;
DELIMITER //
CREATE TRIGGER tg_orders_uuid BEFORE INSERT ON `orders`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.6. Table: order_items
DROP TRIGGER IF EXISTS tg_order_items_uuid;
DELIMITER //
CREATE TRIGGER tg_order_items_uuid BEFORE INSERT ON `order_items`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.7. Table: purchase_history
DROP TRIGGER IF EXISTS tg_purchase_history_uuid;
DELIMITER //
CREATE TRIGGER tg_purchase_history_uuid BEFORE INSERT ON `purchase_history`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.8. Table: expense
DROP TRIGGER IF EXISTS tg_expense_uuid;
DELIMITER //
CREATE TRIGGER tg_expense_uuid BEFORE INSERT ON `expense`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.9. Table: outstand
DROP TRIGGER IF EXISTS tg_outstand_uuid;
DELIMITER //
CREATE TRIGGER tg_outstand_uuid BEFORE INSERT ON `outstand`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.10. Table: deposit_history
DROP TRIGGER IF EXISTS tg_deposit_history_uuid;
DELIMITER //
CREATE TRIGGER tg_deposit_history_uuid BEFORE INSERT ON `deposit_history`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;

-- 4.11. Table: purchase_deposit_history
DROP TRIGGER IF EXISTS tg_purchase_deposit_history_uuid;
DELIMITER //
CREATE TRIGGER tg_purchase_deposit_history_uuid BEFORE INSERT ON `purchase_deposit_history`
FOR EACH ROW
BEGIN
    IF NEW.uuid IS NULL OR NEW.uuid = '' THEN
        SET NEW.uuid = UUID();
    END IF;
END //
DELIMITER ;
