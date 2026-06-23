# Dansarki Sales and Inventory Sync - Deployment & Configuration Guide

This guide details the step-by-step instructions for deploying and seeding the multi-branch synchronization system.

---

## 1. Cloud Server Setup

### 1.1 Apache URL Rewrite Rules (`.htaccess`)
To access the REST APIs natively (e.g., `/api/sync/upload` mapping to `/api/sync/upload.php`), create or modify a `.htaccess` file in the root folder `c:/xampp/htdocs/dansarki/.htaccess` or the cloud server equivalent:

```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /dansarki/

    # Direct authorization endpoint rules
    RewriteRule ^api/auth/login$ api/auth/login.php [L,QSA]
    RewriteRule ^api/auth/branch-register$ api/auth/branch-register.php [L,QSA]

    # Direct synchronization endpoint rules
    RewriteRule ^api/sync/upload$ api/sync/upload.php [L,QSA]
    RewriteRule ^api/sync/download$ api/sync/download.php [L,QSA]
    RewriteRule ^api/sync/status$ api/sync/status.php [L,QSA]
    RewriteRule ^api/sync/logs$ api/sync/logs.php [L,QSA]
</IfModule>
```

### 1.2 Nginx Server Rewrite Configuration
If deploying on a Linux cloud server running Nginx, incorporate the following locations into your server configuration block:

```nginx
server {
    listen 443 ssl http2;
    server_name dansarki-cloud.com;
    root /var/www/html/dansarki;

    index index.php;

    location /api/auth/ {
        try_files $uri $uri/ /api/auth/$1.php$is_args$args;
        
        # Rewrites
        rewrite ^/api/auth/login$ /api/auth/login.php last;
        rewrite ^/api/auth/branch-register$ /api/auth/branch-register.php last;
    }

    location /api/sync/ {
        try_files $uri $uri/ /api/sync/$1.php$is_args$args;

        # Rewrites
        rewrite ^/api/sync/upload$ /api/sync/upload.php last;
        rewrite ^/api/sync/download$ /api/sync/download.php last;
        rewrite ^/api/sync/status$ /api/sync/status.php last;
        rewrite ^/api/sync/logs$ /api/sync/logs.php last;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
}
```

---

## 2. Database Migration

Deploy the database structure by running the SQL scripts in this exact order:

1. **Step 1: business tables modifications**
   - Run: `migrations/phase1_alter_tables.sql`
   - Purpose: Extends legacy business tables with `uuid`, `branch_id`, and `created_at`/`updated_at` datetime structures, while establishing triggers to auto-generate UUID keys.

2. **Step 2: sync tables creation**
   - Run: `migrations/phase2_create_sync_tables.sql`
   - Purpose: Creates the auxiliary framework tables `sync_logs`, `sync_queue`, `sync_conflicts`, and `api_tokens` to log telemetry data and cache sync states.

3. **Step 3: local queue triggers** (Local Replica branches only)
   - Run: `migrations/phase4_sync_triggers.sql`
   - Purpose: Configures stateful update listeners on replica tables. Triggers dynamically populate the `sync_queue` table on every modification. **Do not run this script on the Cloud Master Server.**

---

## 3. Background Sync Schedulers

### 3.1 Linux System (VPS Cloud & Clients) - Cron Job Configuration
Add a job to run every 1 minute under your system user's crontab on each local branch node:

```bash
# Edit crontab
crontab -e

# Append execution rule (Replace path with actual local install path)
* * * * * php /var/www/html/dansarki/system/sync_run.php > /dev/null 2>&1
```

### 3.2 Windows System (XAMPP Branch Clients) - Task Scheduler CMD
Create a basic task in Windows Task Scheduler:
- **Trigger**: Daily, repeating every 1 minute indefinitely.
- **Action**: Start a Program.
  - **Program/Script**: `C:\xampp\php\php.exe`
  - **Add Arguments**: `C:\xampp\htdocs\dansarki\system\sync_run.php`

---

## 4. Initial Database Seeding

To connect a new branch client to the cloud master database:

1. **Register the branch**:
   - Make a POST request to `/api/auth/branch-register` with the new branch's metadata.
   - Retain the returned `branch_id`, `branch_uuid`, and `api_token`.

2. **Configure client variables**:
   - Update `system/sync_config.php` on the branch machine:
     ```php
     define('SYNC_API_URL', 'https://dansarki-cloud.com/api/sync.php');
     define('SYNC_API_TOKEN', 'ds_tok_xxx_YOUR_GENERATED_API_TOKEN_xxx');
     define('BRANCH_UUID', 'xxx_YOUR_GENERATED_BRANCH_UUID_xxx');
     ```

3. **Backfill Existing Data**:
   - Run `tests/sync_test.php` in your browser or terminal to verify trigger operation and connectivity.
   - To seed historical local branch data to the cloud, manually insert all primary records (e.g. `stocks`, `customers`) into `sync_queue` with status `'pending'`:
     ```sql
     INSERT INTO sync_queue (table_name, record_uuid, operation, status)
     SELECT 'customers', uuid, 'INSERT', 'pending' FROM customers;
     
     INSERT INTO sync_queue (table_name, record_uuid, operation, status)
     SELECT 'stocks', uuid, 'INSERT', 'pending' FROM stocks;
     ```
   - Click **Sync Now** on the Dashboard. The synchronization engine will handle the initial batch uploads and seed the cloud master database.
