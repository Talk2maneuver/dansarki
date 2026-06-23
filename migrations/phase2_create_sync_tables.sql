-- =========================================================================
-- DANSARKI SALES AND INVENTORY SYSTEM - DATABASE MIGRATION SCRIPT
-- PHASE 2: CREATE SYNCHRONIZATION TABLES
-- =========================================================================
-- This script creates the new tables required for the Offline-First
-- Multi-Branch synchronization layer.
--
-- Created Tables:
--   1. sync_logs - Audits sync operations and messages.
--   2. sync_queue - Tracks local modifications pending cloud upload.
--   3. sync_conflicts - Records details and resolutions of data conflicts.
--   4. api_tokens - Manages API access authentication tokens for branch nodes.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. Table: sync_logs
-- -------------------------------------------------------------------------
-- Stores a historical audit trail of all synchronization events.
CREATE TABLE IF NOT EXISTS `sync_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_name` VARCHAR(50) NOT NULL COMMENT 'The name of the database table synced',
    `record_uuid` VARCHAR(36) NOT NULL COMMENT 'The unique identifier of the synced record',
    `action` VARCHAR(20) NOT NULL COMMENT 'The type of action: UPLOAD, DOWNLOAD, CONFLICT_RESOLVE',
    `status` VARCHAR(20) NOT NULL COMMENT 'Result status: SUCCESS, FAILED',
    `message` TEXT NULL COMMENT 'Error messages, stack trace, or detail logging',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_sync_logs_table_uuid` (`table_name`, `record_uuid`),
    INDEX `idx_sync_logs_status` (`status`),
    INDEX `idx_sync_logs_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- -------------------------------------------------------------------------
-- 2. Table: sync_queue
-- -------------------------------------------------------------------------
-- Acts as the staging area/outbox tracking local changes waiting to be
-- pushed to the cloud master database.
CREATE TABLE IF NOT EXISTS `sync_queue` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_name` VARCHAR(50) NOT NULL COMMENT 'The name of the database table containing the dirty record',
    `record_uuid` VARCHAR(36) NOT NULL COMMENT 'The UUID of the pending record',
    `operation` VARCHAR(20) NOT NULL COMMENT 'The SQL operation: INSERT, UPDATE, DELETE',
    `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'Queue status: pending, processing, completed, failed',
    `attempts` INT NOT NULL DEFAULT 0 COMMENT 'Number of retries attempted on network or verification failure',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_sync_queue_lookup` (`status`, `table_name`),
    INDEX `idx_sync_queue_uuid` (`record_uuid`),
    -- Composite unique key prevents redundant pending queue items for the same record
    UNIQUE KEY `uq_pending_sync_item` (`table_name`, `record_uuid`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- -------------------------------------------------------------------------
-- 3. Table: sync_conflicts
-- -------------------------------------------------------------------------
-- Logs instances where the local record and the cloud record have both changed,
-- and tracks the resolution status (e.g. Last Updated Wins).
CREATE TABLE IF NOT EXISTS `sync_conflicts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_name` VARCHAR(50) NOT NULL COMMENT 'The name of the conflicting database table',
    `record_uuid` VARCHAR(36) NOT NULL COMMENT 'The UUID of the conflicting record',
    `local_time` DATETIME NOT NULL COMMENT 'The updated_at timestamp on the local node',
    `cloud_time` DATETIME NOT NULL COMMENT 'The updated_at timestamp on the cloud server',
    `resolution` VARCHAR(50) NOT NULL COMMENT 'Resolution outcome: CLOUD_WINS, LOCAL_WINS, MANUAL_MERGE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_sync_conflicts_lookup` (`table_name`, `record_uuid`),
    INDEX `idx_sync_conflicts_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- -------------------------------------------------------------------------
-- 4. Table: api_tokens
-- -------------------------------------------------------------------------
-- Stores tokens used by each branch database node to authenticate requests
-- made to the cloud central server API.
CREATE TABLE IF NOT EXISTS `api_tokens` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `branch_id` INT NOT NULL COMMENT 'References the local branch associated with the token',
    `token` VARCHAR(255) NOT NULL UNIQUE COMMENT 'The hashed/encrypted access token or plain secure token key',
    `status` VARCHAR(20) NOT NULL DEFAULT 'active' COMMENT 'Token status: active, revoked, expired',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_api_tokens_branch` (`branch_id`),
    INDEX `idx_api_tokens_status` (`status`),
    CONSTRAINT `fk_api_tokens_branch` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
