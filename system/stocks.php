<?php
session_start();
// error_reporting(0);
include('../assets/mashaAllah/gyada.php');
if (strlen($_SESSION['email']) == 0) {
    header('location:../index.php');
} else {
    $facilityID = $_SESSION['facilityID'];
    $report_date = isset($_GET['report_date']) ? $_GET['report_date'] : date('Y-m-d');

    // Handle new stock creation or purchase
    if (isset($_POST['submit'])) {
        $stock_id = mysqli_real_escape_string($con, $_POST['stock_id']);
        $name = mysqli_real_escape_string($con, $_POST['name']);
        $sell = !empty($_POST['sell']) ? (float)$_POST['sell'] : 0;
        $bought = (float)$_POST['bought'];
        $quantity = (float)$_POST['quantity'];
        $branch = mysqli_real_escape_string($con, $_POST['branch']);
        $b_subtotal = $bought * $quantity;
        $s_subtotal = $sell * $quantity;

        if ($stock_id) {
            // Fetch current quantity to record as initial_quantity
            $current_stock_query = mysqli_query($con, "SELECT quantity FROM stocks WHERE id = '$stock_id'");
            $current_stock_row = mysqli_fetch_array($current_stock_query);
            $initial_qty = $current_stock_row['quantity'];

            $sql = mysqli_query($con, "
                UPDATE stocks 
                SET quantity = quantity + '$quantity',
                    new_order = new_order + '$quantity',
                    Bsubtotal = buying * (quantity + '$quantity'),
                    Ssubtotal = selling * (quantity + '$quantity')
                WHERE id = '$stock_id' AND facilityID = '$branch'
            ");

            if ($sql) {
                // Insert into purchase_history with all required fields
                $purchase_from = mysqli_real_escape_string($con, $_POST['purchase_from'] ?? '');
                $amount_paid = (float)($_POST['amount_paid'] ?? 0);
                $balance = $b_subtotal - $amount_paid;
                $for_desc = mysqli_real_escape_string($con, $_POST['for_desc'] ?? '');

                mysqli_query($con, "
                    INSERT INTO purchase_history(facilityID, stock_id, initial_quantity, stock_name, quantity, cost_price, total_cost, amount_paid, balance, for_desc, purchase_date, purchase_from) 
                    VALUES('$branch', '$stock_id', '$initial_qty', (SELECT name FROM stocks WHERE id='$stock_id' LIMIT 1), '$quantity', '$bought', '$b_subtotal', '$amount_paid', '$balance', '$for_desc', CURDATE(), '$purchase_from')
                ");

                echo "<script>alert('Stock Purchase Successful'); window.location.href='stocks'</script>";
            } else {
                $error = "Something went wrong adding purchase: " . mysqli_error($con);
            }
        } else {
            // New stock creation
            $sql = mysqli_query($con, "
                INSERT INTO stocks(facilityID, name, selling, buying, quantity, opening_quantity, new_order, Bsubtotal, Ssubtotal, expiry) 
                VALUES('$branch', '$name', '$sell', '$bought', '$quantity', 0, '$quantity', '$b_subtotal', '$s_subtotal', NULL)
            ");

            if ($sql) {
                $new_stock_id = mysqli_insert_id($con);
                // Get form data for purchase fields
                $purchase_from = mysqli_real_escape_string($con, $_POST['purchase_from'] ?? '');
                $for_desc = mysqli_real_escape_string($con, $_POST['for_desc'] ?? '');
                $amount_paid = (float)($_POST['amount_paid'] ?? 0);
                $balance = $b_subtotal - $amount_paid;
                
                // Insert into purchase_history with all fields including for_desc and purchase_from
                $purchase_query = mysqli_query($con, "
                    INSERT INTO purchase_history(facilityID, stock_id, initial_quantity, stock_name, quantity, cost_price, total_cost, amount_paid, balance, for_desc, purchase_date, purchase_from) 
                    VALUES('$branch', '$new_stock_id', 0, '$name', '$quantity', '$bought', '$b_subtotal', '$amount_paid', '$balance', '$for_desc', CURDATE(), '$purchase_from')
                ");

                if ($purchase_query) {
                    echo "<script>alert('Stock added successfully');</script>";
                    echo "<script>window.location.href ='stocks.php'</script>";
                } else {
                    $error = "Stock added, but purchase history could not be recorded: " . mysqli_error($con);
                }
            } else {
                $error = "Something went wrong adding new stock: " . mysqli_error($con);
            }
        }
    }

    // Handle stock deletion
    if (isset($_GET['del'])) {
        mysqli_query($con, "UPDATE stocks SET deleted_flag = 1, sync_status = 'pending' WHERE id = '" . $_GET['id'] . "'");
        $msg = "Stock deleted successfully";
    }

    // Handle Close Day / Update Stock Quantities
    if (isset($_POST['update_stock_quantities'])) {
        $sql = mysqli_query($con, "
            UPDATE stocks 
            SET closing_quantity = quantity,
                opening_quantity = quantity,
                new_order = 0,
                out_stocks = 0
            WHERE 1=1
        ");
        if ($sql) {
            $msg = "Stock quantities updated (Day Closed) successfully";
        } else {
            $error = "Something went wrong updating stock quantities: " . mysqli_error($con);
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no">
    <title>Dansarki General Enterprise</title>
    <link href="../assets/img/Icon.png" rel="shortcut icon">
    <link href="../assets/css/loader.css" rel="stylesheet" type="text/css" />
    <script src="../assets/js/loader.js"></script>
    <link href="https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap" rel="stylesheet">
    <link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/css/plugins.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../plugins/table/datatable/datatables.css">
    <link rel="stylesheet" type="text/css" href="../plugins/table/datatable/custom_dt_html5.css">
    <link rel="stylesheet" type="text/css" href="../plugins/table/datatable/dt-global_style.css">
    <link rel="stylesheet" type="text/css" href="../assets/css/widgets/modules-widgets.css">
</head>
<body class="sidebar-noneoverflow">
    <div id="load_screen">
        <div class="loader">
            <div class="loader-content">
                <div class="spinner-grow align-self-center"></div>
            </div>
        </div>
    </div>
    <?php include('header.php'); ?>
    <div class="main-container" id="container">
        <div class="overlay"></div>
        <div class="search-overlay"></div>
        <?php include('sidebar.php'); ?>
        <div id="content" class="main-content">
            <div class="layout-px-spacing">
                <div class="row layout-top-spacing">
                    <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                        <div class="widget widget-account-invoice-two">
                            <div class="widget-content">
                                <div class="account-box">
                                    <div class="info">
                                        <h3 style="color:white;">Total Cost Price</h3>
                                    </div>
                                    <div class="acc-action">
                                        <?php
                                        $r_query = $con->query("SELECT SUM(buying * quantity) as 'buying' FROM stocks WHERE deleted_flag = 0");
                                        $r_row = $r_query->fetch_array();
                                        $real = $r_row['buying'];
                                        ?>
                                        <h1 style="color:white"> <b> ₦<?php echo number_format($real); ?></b></h1>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                        <div class="widget widget-account-invoice-two">
                            <div class="widget-content">
                                <div class="account-box">
                                    <div class="info">
                                        <h3 style="color:white;">Total Selling Price</h3>
                                    </div>
                                    <div class="acc-action">
                                        <?php
                                        $q_query = $con->query("SELECT SUM(selling * quantity) as 'selling' FROM stocks WHERE deleted_flag = 0");
                                        $q_row = $q_query->fetch_array();
                                        $real = $q_row['selling'];
                                        ?>
                                        <h1 style="color:white"> <b> ₦<?php echo number_format($real); ?></b></h1>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row layout-top-spacing" id="cancel-row">
                    <div class="col-xl-12 col-lg-12 col-sm-12 layout-spacing">
                        <button type="button" class="btn btn-primary mb-4 mr-2" data-toggle="modal" data-target="#stockModal">
                            Add New Stock
                        </button>



                        <form method="GET" class="mb-4">
                            <div class="row">
                                <div class="col-md-3">
                                    <label>Select Date</label>
                                    <input type="date" name="report_date" id="report_date" class="form-control" value="<?php echo $report_date; ?>">
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary w-100">Filter</button>
                                </div>
                            </div>
                        </form>

                        <div class="widget-content widget-content-area br-6">
                            <?php if ($error) { ?>
                                <strong style="color:red; font-size:18px; margin-top: 15px;"><?php echo $error; ?></strong>
                            <?php } else if ($msg) { ?>
                                <strong style="color:green; font-size:18px; margin-top: 15px;"><?php echo $msg; ?></strong>
                            <?php } ?>
                            <table id="html5-extension" class="table table-hover non-hover" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>S/N</th>
                                        <th>Branch ID</th>
                                        <th>Stock Name</th>
                                        <th>Cost Price</th>
                                        <th>Selling Price</th>
                                        <th>Quantity</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    $sql = mysqli_query($con, "SELECT * FROM stocks WHERE deleted_flag = 0");
                                    $cnt = 1;
                                    $is_today = ($report_date == date('Y-m-d'));
                                    
                                    while ($row = mysqli_fetch_array($sql)) {
                                        $stock_id = $row['id'];
                                        $stock_name = $row['name'];
                                        $display_quantity = $row['quantity'];
                                        
                                        if (!$is_today) {
                                            $current_qty = $row['quantity'];
                                            
                                            // Calculate Quantity at the end of selected date using "backward" logic:
                                            // Hist Qty = Current Qty - (Purchases made AFTER report_date) + (Sales made AFTER report_date)
                                            
                                            // Purchases after report_date
                                            $p_future_sql = mysqli_query($con, "SELECT COALESCE(SUM(quantity), 0) as total_p_future FROM purchase_history WHERE stock_id = '$stock_id' AND DATE(purchase_date) > '$report_date'");
                                            $p_future_row = mysqli_fetch_array($p_future_sql);
                                            $total_p_future = $p_future_row['total_p_future'];
                                            
                                            // Sales after report_date
                                            $s_future_sql = mysqli_query($con, "SELECT COALESCE(SUM(quantity), 0) as total_s_future FROM orders WHERE (stockID = '$stock_id' OR item = '$stock_name') AND DATE(creation) > '$report_date'");
                                            $s_future_row = mysqli_fetch_array($s_future_sql);
                                            $total_s_future = $s_future_row['total_s_future'];
                                            
                                            $display_quantity = $current_qty - $total_p_future + $total_s_future;
                                        }
                                    ?>
                                        <tr>
                                            <td class="center"><?php echo $cnt; ?>.</td>
                                            <td><?php echo $row['facilityID']; ?></td>
                                            <td><?php echo $row['name']; ?></td>
                                            <td>₦ <?php echo number_format($row['buying']); ?></td>
                                            <td>₦ <?php echo number_format($row['selling']); ?></td>
                                            <td><?php echo $display_quantity; ?></td>
                                            <td>
                                                <a href="edit-stock.php?id=<?php echo $row['id']; ?>" class="btn btn-primary btn-sm">Edit</a>
                                                <button type="button" class="btn btn-info btn-sm manage-btn" data-stock-id="<?php echo $row['id']; ?>" data-stock-name="<?php echo $row['name']; ?>">Manage</button>
                                                <a href="stocks.php?id=<?php echo $row['id']; ?>&del=delete" onClick="return confirm('Are you sure you want to delete?')" class="btn btn-danger btn-sm">Delete</a>
                                            </td>
                                        </tr>
                                    <?php
                                        $cnt++;
                                    }
                                    ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="stockModal" tabindex="-1" role="dialog" aria-labelledby="stockModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="stockModalLabel">Add New Stock</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-x"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                </button>
                            </div>
                            <form method="POST" id="stockForm">
                                <div class="modal-body">
                                    <input type="hidden" name="stock_id" id="stockIdHidden" value="">
                                    <div class="form-group" id="nameGroup">
                                        <label>Stock Name</label>
                                        <span style="color:red">*</span>
                                        <input type="text" class="form-control" name="name" id="nameInput" required>
                                    </div>
                                    <div class="form-group" id="sellGroup">
                                        <label>Selling Price</label>
                                        <span style="color:red">*</span>
                                        <input type="number" class="form-control" name="sell" id="sellInput" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Cost Price</label>
                                        <span style="color:red">*</span>
                                        <input type="number" class="form-control" name="bought" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Stock Quantity</label>
                                        <span style="color:red">*</span>
                                        <input type="number" class="form-control" name="quantity" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Branch</label>
                                        <span style="color:red">*</span>
                                        <select name="branch" id="branchSelect" class="form-control" required>
                                            <option value="">Select Branch</option>
                                            <?php
                                            $branchSql = mysqli_query($con, "SELECT * FROM branch");
                                            while ($brow = mysqli_fetch_array($branchSql)) {
                                                echo "<option value='{$brow['facilityID']}'>{$brow['name']}</option>";
                                            }
                                            ?>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>For Description</label>
                                        <input type="text" class="form-control" name="for_desc" placeholder="Enter description for this purchase">
                                    </div>
                                    <div class="form-group">
                                        <label>Purchase From</label>
                                        <input type="text" class="form-control" name="purchase_from" placeholder="Enter supplier/vendor name">
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn" data-dismiss="modal">Discard</button>
                                    <button type="submit" class="btn btn-primary" name="submit">Save</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="manageModal" tabindex="-1" role="dialog" aria-labelledby="manageModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content text-dark">
                            <div class="modal-header">
                                <h5 class="modal-title" id="manageModalLabel">Manage Purchases</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-x"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div id="history-container">
                                    <p class="text-center">Loading history...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="editPurchaseModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content text-dark">
                            <div class="modal-header">
                                <h5 class="modal-title">Modify Purchase</h5>
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                            </div>
                            <form id="editPurchaseForm">
                                <div class="modal-body">
                                    <input type="hidden" name="purchase_id" id="edit_p_id">
                                    <input type="hidden" name="stock_id" id="edit_p_stock_id">
                                    <div class="form-group">
                                        <label>Quantity</label>
                                        <input type="number" name="quantity" id="edit_p_qty" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Cost Price</label>
                                        <input type="number" name="cost" id="edit_p_cost" class="form-control" required>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Update Purchase</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
<?php include('footer.php'); ?>
        </div>
    </div>
    <script src="../assets/js/libs/jquery-3.1.1.min.js"></script>
    <script src="../bootstrap/js/popper.min.js"></script>
    <script src="../bootstrap/js/bootstrap.min.js"></script>
    <script src="../plugins/perfect-scrollbar/perfect-scrollbar.min.js"></script>
    <script src="../assets/js/app.js"></script>
     <script src="../plugins/table/datatable/datatables.js"></script>
    <!-- NOTE TO Use Copy CSV Excel PDF Print Options You Must Include These Files  -->
    <script src="../plugins/table/datatable/button-ext/dataTables.buttons.min.js"></script>
    <script src="../plugins/table/datatable/button-ext/jszip.min.js"></script>    
    <script src="../plugins/table/datatable/button-ext/buttons.html5.min.js"></script>
    <script src="../plugins/table/datatable/button-ext/buttons.print.min.js"></script>
    <script>
        $('#html5-extension').DataTable( {
            "dom": "<'dt--top-section'<'row'<'col-sm-12 col-md-6 d-flex justify-content-md-start justify-content-center'B><'col-sm-12 col-md-6 d-flex justify-content-md-end justify-content-center mt-md-0 mt-3'f>>>" +
        "<'table-responsive'tr>" +
        "<'dt--bottom-section d-sm-flex justify-content-sm-between text-center'<'dt--pages-count  mb-sm-0 mb-3'i><'dt--pagination'p>>",
            buttons: {
                buttons: [
                    { extend: 'copy', className: 'btn btn-sm' },
                    { extend: 'csv', className: 'btn btn-sm' },
                    { 
                        extend: 'excel', 
                        className: 'btn btn-sm',
                        title: 'Dansarki General Enterprise CLOSING - <?= date("Y-m-d"); ?>',
                        customize: function(xlsx) {
                            var sheet = xlsx.xl.worksheets['sheet1.xml'];
                            // Style 25 is thin border.
                            $('row c', sheet).attr('s', '25');
                        }
                    },
                    { extend: 'print', className: 'btn btn-sm' }
                ]
            },
            "oLanguage": {
                "oPaginate": { "sPrevious": '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-left"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>', "sNext": '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-right"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>' },
                "sInfo": "Showing page _PAGE_ of _PAGES_",
                "sSearch": '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>',
                "sSearchPlaceholder": "Search...",
               "sLengthMenu": "Results :  _MENU_",
            },
            "stripeClasses": [],
            "lengthMenu": [7, 10, 20, 50],
            "pageLength": 7 
        } );
    </script>
    <script>
        $(document).ready(function() {
            App.init();

            // Handle purchase button click using event delegation
            $(document).on('click', '.purchase-btn', function() {
                $('#stockModalLabel').text('Add Purchase');
                $('#stockIdHidden').val($(this).data('stock-id'));
                $('#nameInput').val($(this).data('stock-name')).prop('readonly', true).removeAttr('required');
                $('#sellInput').removeAttr('required');
                $('#branchSelect').val($(this).data('branch-id')).prop('disabled', true);
                
                // Add hidden branch for form submission (since disabled selects are not posted)
                if (!$('#branchHidden').length) {
                    $('#stockForm').append('<input type="hidden" name="branch" id="branchHidden" value="' + $(this).data('branch-id') + '">');
                } else {
                    $('#branchHidden').val($(this).data('branch-id'));
                }

                $('#nameGroup').hide();
                $('#sellGroup').hide();
                $('#stockForm').find('button[name="submit"]').text('Add Purchase');
            });

            // Reset modal for new stock
            $('#stockModal').on('hidden.bs.modal', function() {
                $('#stockModalLabel').text('Add New Stock');
                $('#stockForm')[0].reset();
                $('#nameInput').prop('readonly', false).attr('required', 'required');
                $('#sellInput').attr('required', 'required');
                $('#branchSelect').prop('disabled', false);
                $('#branchHidden').remove();
                $('#nameGroup').show();
                $('#sellGroup').show();
                $('#stockIdHidden').val('');
                $('#stockForm').find('button[name="submit"]').text('Save');
            });

            // Manage Purchases
            $(document).on('click', '.manage-btn', function() {
                const stockId = $(this).data('stock-id');
                const stockName = $(this).data('stock-name');
                const date = $('#report_date').val();

                $('#manageModalLabel').text('Purchase History: ' + stockName);
                $('#manageModal').modal('show');
                loadHistory(stockId, date, date); // Use same date for start/end to show that specific day
            });

            function loadHistory(stockId, start, end) {
                $('#history-container').html('<p class="text-center">Loading history...</p>');
                $.get('manage_purchases_api.php', { action: 'list', stock_id: stockId, start: start, end: end }, function(data) {
                    $('#history-container').html(data);
                });
            }

            // Removed #filter_date handler as it is now a standard form submit

            // Remove Purchase
            $(document).on('click', '.remove-p-btn', function() {
                if(confirm('Are you sure you want to remove this purchase? Stock quantity and report values will be adjusted.')) {
                    const pid = $(this).data('id');
                    const sid = $(this).data('stock-id');
                    $.post('manage_purchases_api.php', { action: 'delete', id: pid, stock_id: sid }, function(res) {
                        const date = $('#report_date').val();
                        loadHistory(sid, date, date);
                        alert(res.message);
                    }, 'json');
                }
            });

            // Edit Purchase
            $(document).on('click', '.edit-p-btn', function() {
                $('#edit_p_id').val($(this).data('id'));
                $('#edit_p_stock_id').val($(this).data('stock-id'));
                $('#edit_p_qty').val($(this).data('qty'));
                $('#edit_p_cost').val($(this).data('cost'));
                $('#editPurchaseModal').modal('show');
            });

            $('#editPurchaseForm').on('submit', function(e) {
                e.preventDefault();
                $.post('manage_purchases_api.php', $(this).serialize() + '&action=update', function(res) {
                    $('#editPurchaseModal').modal('hide');
                    const sid = $('#edit_p_stock_id').val();
                    const date = $('#report_date').val();
                    loadHistory(sid, date, date);
                    alert(res.message);
                }, 'json');
            });
        });
    </script>
</body>
</html>

