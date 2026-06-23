-- =========================================================================
-- DANSARKI SALES AND INVENTORY SYSTEM - DATABASE MIGRATION SCRIPT
-- PHASE 4: LOCAL DATABASE TRIGGERS FOR SYNC QUEUE
-- =========================================================================
-- This script creates AFTER INSERT and AFTER UPDATE triggers on the 11
-- synchronized tables.
--
-- Features:
--   - Automatically inserts a record into `sync_queue` with status = 'pending'.
--   - Uses the connection variable `@is_syncing` to prevent feedback loops.
--     When the Local Sync Service updates the database during a Pull operation,
--     it sets `@is_syncing = 1` which tells the triggers to skip queuing.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Helper Procedure to drop existing triggers before recreating them
-- -------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS CreateSyncTriggers;

DELIMITER //

CREATE PROCEDURE CreateSyncTriggers(IN p_table_name VARCHAR(64))
BEGIN
    -- 1. Create AFTER INSERT trigger
    SET @sql_ins = CONCAT('
        CREATE TRIGGER `tg_', p_table_name, '_after_insert` AFTER INSERT ON `', p_table_name, '`
        FOR EACH ROW
        BEGIN
            IF @is_syncing IS NULL OR @is_syncing = 0 THEN
                INSERT INTO `sync_queue` (table_name, record_uuid, operation, status, attempts, created_at)
                VALUES (\'', p_table_name, '\', NEW.uuid, \'INSERT\', \'pending\', 0, NOW())
                ON DUPLICATE KEY UPDATE status = \'pending\', attempts = 0;
            END IF;
        END
    ');
    
    -- 2. Create AFTER UPDATE trigger
    SET @sql_upd = CONCAT('
        CREATE TRIGGER `tg_', p_table_name, '_after_update` AFTER UPDATE ON `', p_table_name, '`
        FOR EACH ROW
        BEGIN
            IF @is_syncing IS NULL OR @is_syncing = 0 THEN
                INSERT INTO `sync_queue` (table_name, record_uuid, operation, status, attempts, created_at)
                VALUES (\'', p_table_name, '\', NEW.uuid, \'UPDATE\', \'pending\', 0, NOW())
                ON DUPLICATE KEY UPDATE status = \'pending\', attempts = 0;
            END IF;
        END
    ');

    -- Drop Insert Trigger if exists and execute creation
    SET @drop_ins = CONCAT('DROP TRIGGER IF EXISTS `tg_', p_table_name, '_after_insert`');
    PREPARE stmt_drop_ins FROM @drop_ins;
    EXECUTE stmt_drop_ins;
    DEALLOCATE PREPARE stmt_drop_ins;

    PREPARE stmt_ins FROM @sql_ins;
    EXECUTE stmt_ins;
    DEALLOCATE PREPARE stmt_ins;

    -- Drop Update Trigger if exists and execute creation
    SET @drop_upd = CONCAT('DROP TRIGGER IF EXISTS `tg_', p_table_name, '_after_update`');
    PREPARE stmt_drop_upd FROM @drop_upd;
    EXECUTE stmt_drop_upd;
    DEALLOCATE PREPARE stmt_drop_upd;

    PREPARE stmt_upd FROM @sql_upd;
    EXECUTE stmt_upd;
    DEALLOCATE PREPARE stmt_upd;

END //

DELIMITER ;

-- -------------------------------------------------------------------------
-- Apply Triggers to all 11 Synchronized Tables
-- -------------------------------------------------------------------------
CALL CreateSyncTriggers('branch');
CALL CreateSyncTriggers('facility');
CALL CreateSyncTriggers('customers');
CALL CreateSyncTriggers('stocks');
CALL CreateSyncTriggers('orders');
CALL CreateSyncTriggers('order_items');
CALL CreateSyncTriggers('purchase_history');
CALL CreateSyncTriggers('expense');
CALL CreateSyncTriggers('outstand');
CALL CreateSyncTriggers('deposit_history');
CALL CreateSyncTriggers('purchase_deposit_history');

-- Cleanup temporary procedure
DROP PROCEDURE IF EXISTS CreateSyncTriggers;
