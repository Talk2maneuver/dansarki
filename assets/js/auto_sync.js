/**
 * Client-Side Background Auto-Sync Service
 * Dansarki General Enterprise
 */
(function() {
    // Wait for jQuery to load
    function init() {
        if (typeof jQuery === 'undefined') {
            setTimeout(init, 200);
            return;
        }
        startSync();
    }
    init();

    function startSync() {
        // Check if we are inside system, front, or sub folder
    const path = window.location.pathname;
    let runUrl = '';
    if (path.includes('/system/')) {
        runUrl = 'sync_run.php';
    } else if (path.includes('/front/') || path.includes('/sub/')) {
        runUrl = '../system/sync_run.php';
    } else {
        return; // Not in admin path
    }

    // Function to append toast dynamically if not present
    function ensureToastContainer() {
        if ($('#syncToast').length === 0) {
            const toastHtml = `
            <div style="position: fixed; bottom: 20px; right: 20px; z-index: 9999;">
                <div id="syncToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true" style="display:none; min-width:250px; background:#fff; border:1px solid #1b55e2; border-radius:6px; box-shadow:0 4px 12px rgba(0,0,0,0.15); font-family:'Quicksand', sans-serif;">
                    <div class="toast-header" style="background:#1b55e2; color:#fff; border-top-left-radius:5px; border-top-right-radius:5px; padding:8px 12px; display:flex; justify-content:space-between; align-items:center;">
                        <strong style="margin-right:auto; font-weight:700; display:flex; align-items:center;">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:8px;"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg> 
                            Sync Status
                        </strong>
                        <button type="button" class="close-sync-toast" style="background:none; border:none; color:#fff; font-size:20px; cursor:pointer; line-height:1; padding:0;">&times;</button>
                    </div>
                    <div id="syncToastBody" class="toast-body" style="padding:12px; font-size:0.9rem; color:#3b3f5c;">
                        Sync process started...
                    </div>
                </div>
            </div>`;
            $('body').append(toastHtml);
            
            // Add click listener for close button
            $(document).on('click', '.close-sync-toast', function() {
                $('#syncToast').fadeOut();
            });
        }
    }

    function showSyncToast(message) {
        ensureToastContainer();
        $('#syncToastBody').html(message);
        $('#syncToast').fadeIn();
        
        // Auto hide after 6 seconds
        setTimeout(function() {
            $('#syncToast').fadeOut();
        }, 6000);
    }

    function runBackgroundSync() {
        // Tab locking via localStorage to prevent parallel triggers
        const now = Date.now();
        const lastTriggered = localStorage.getItem('ds_last_sync_triggered');
        
        if (lastTriggered && (now - parseInt(lastTriggered) < 55000)) {
            // Checked less than 55 seconds ago, skip this tab
            return;
        }
        
        localStorage.setItem('ds_last_sync_triggered', now.toString());
        
        // If we are currently on the sync_dashboard, don't show toast notifications
        // because the dashboard handles its own UI updates and manual syncing
        if (path.includes('sync_dashboard')) {
            return;
        }

        // Call runner
        $.ajax({
            url: runUrl,
            type: 'GET',
            dataType: 'json',
            success: function(res) {
                if (res.success) {
                    const pushed = res.push.records_pushed || 0;
                    const pulled = res.pull.records_pulled || 0;
                    
                    if (pushed > 0 || pulled > 0) {
                        showSyncToast(`<strong>Sync Completed</strong><br>Pushed: ${pushed} records.<br>Pulled: ${pulled} records.`);
                    }
                }
            },
            error: function() {
                // Fail silently in background to not disturb the user
            }
        });
    }

    // Run sync when internet status transitions from offline to online
    window.addEventListener('online', function() {
        showSyncToast('Internet connection restored. Starting sync...');
        runBackgroundSync();
    });

    // Run sync periodically every 1 minute (60,000 ms)
    setInterval(function() {
        if (navigator.onLine) {
            runBackgroundSync();
        }
    }, 60000);
    
    // Initial delay load (run 10 seconds after page load if online)
    setTimeout(function() {
        if (navigator.onLine) {
            runBackgroundSync();
        }
    }, 10000);

    }
})();
