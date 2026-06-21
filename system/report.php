<?php
session_start();
error_reporting(0);
include('../assets/mashaAllah/gyada.php');
if (strlen($_SESSION['email']) == 0) {
    header('location:../index.php');
    exit;
}

$facilityID = $_SESSION['facilityID'];
$from_date = isset($_GET['from_date']) ? mysqli_real_escape_string($con, $_GET['from_date']) : '';
$to_date = isset($_GET['to_date']) ? mysqli_real_escape_string($con, $_GET['to_date']) : '';

// 1. Profit & Loss Data
$profit_data = [];
$labels = [];

if ($from_date && $to_date) {
    // Daily view for selected range
    $start = new DateTime($from_date);
    $end = new DateTime($to_date);
    $interval = new DateInterval('P1D');
    $period = new DatePeriod($start, $interval, $end->modify('+1 day'));

    foreach ($period as $date) {
        $day = $date->format('Y-m-d');
        $display = $date->format('d M');
        $labels[] = $display;

        // Sales and Cost
        $q = mysqli_query($con, "SELECT 
            SUM(CAST(o.subtotal AS DECIMAL(10,2)) - CAST(o.discount AS DECIMAL(10,2))) as sales,
            SUM(CAST(o.quantity AS DECIMAL(10,2)) * CAST(s.buying AS DECIMAL(10,2))) as cost
            FROM orders o 
            JOIN stocks s ON o.stockID = s.id
            WHERE DATE(o.creation) = '$day'");
        $row = mysqli_fetch_assoc($q);
        $sales = $row['sales'] ?? 0;
        $cost = $row['cost'] ?? 0;

        // Expenses
        $eq = mysqli_query($con, "SELECT SUM(price) as total FROM expense WHERE DATE(creation) = '$day' AND type='out'");
        $erow = mysqli_fetch_assoc($eq);
        $expenses = $erow['total'] ?? 0;

        $profit_data[] = round($sales - $cost - $expenses, 2);
    }
    $filter_sql = " AND DATE(creation) BETWEEN '$from_date' AND '$to_date'";
    $purchase_filter_sql = " AND DATE(purchase_date) BETWEEN '$from_date' AND '$to_date'";
    $chart_title = "Profit / Loss Trend (" . date('d M', strtotime($from_date)) . " - " . date('d M', strtotime($to_date)) . ")";
} else {
    // Grouped by Month for the last 6 months (Default)
    for ($i = 5; $i >= 0; $i--) {
        $month = date('Y-m', strtotime("-$i months"));
        $display_month = date('M Y', strtotime("-$i months"));
        $labels[] = $display_month;

        // Sales and Cost
        $q = mysqli_query($con, "SELECT 
            SUM(CAST(o.subtotal AS DECIMAL(10,2)) - CAST(o.discount AS DECIMAL(10,2))) as sales,
            SUM(CAST(o.quantity AS DECIMAL(10,2)) * CAST(s.buying AS DECIMAL(10,2))) as cost
            FROM orders o 
            JOIN stocks s ON o.stockID = s.id
            WHERE o.creation LIKE '$month%'");
        $row = mysqli_fetch_assoc($q);
        $sales = $row['sales'] ?? 0;
        $cost = $row['cost'] ?? 0;

        // Expenses
        $eq = mysqli_query($con, "SELECT SUM(price) as total FROM expense WHERE creation LIKE '$month%' AND type='out'");
        $erow = mysqli_fetch_assoc($eq);
        $expenses = $erow['total'] ?? 0;

        $profit_data[] = round($sales - $cost - $expenses, 2);
    }
    $filter_sql = "";
    $purchase_filter_sql = "";
    $chart_title = "Profit / Loss Trend (Last 6 Months)";
}

// 2. Top Selling Stocks
$ts_labels = [];
$ts_values = [];
$ts_q = mysqli_query($con, "SELECT item, SUM(CAST(quantity AS DECIMAL(10,2))) as total_qty 
                           FROM orders 
                           WHERE 1=1 $filter_sql
                           GROUP BY item 
                           ORDER BY total_qty DESC LIMIT 5");
while ($row = mysqli_fetch_assoc($ts_q)) {
    $ts_labels[] = $row['item'];
    $ts_values[] = (float)$row['total_qty'];
}

// 3. Stocks Mostly Purchased (Inventory)
$tp_labels = [];
$tp_values = [];
$tp_q = mysqli_query($con, "SELECT stock_name, SUM(quantity) as total_qty 
                           FROM purchase_history 
                           WHERE 1=1 $purchase_filter_sql
                           GROUP BY stock_name 
                           ORDER BY total_qty DESC LIMIT 5");
while ($row = mysqli_fetch_assoc($tp_q)) {
    $tp_labels[] = $row['stock_name'];
    $tp_values[] = (float)$row['total_qty'];
}

// 4. Recommendations
$recommendations = [];
// Low Stock
$low_stock_q = mysqli_query($con, "SELECT name, quantity FROM stocks WHERE CAST(quantity AS DECIMAL(10,2)) < 10 LIMIT 3");
while ($row = mysqli_fetch_assoc($low_stock_q)) {
    $recommendations[] = [
        'type' => 'warning',
        'msg' => "<b>{$row['name']}</b> is running low ({$row['quantity']} remaining). Consider restocking soon."
    ];
}
// Best Seller
if (!empty($ts_labels)) {
    $recommendations[] = [
        'type' => 'success',
        'msg' => "<b>{$ts_labels[0]}</b> is your top-selling item. Ensure you maintain high stock levels."
    ];
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no">
    <title>Business Report - Dansarki</title>
    <link href="../assets/img/dansarkilogo.jpg" rel="shortcut icon">
    <link href="https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap" rel="stylesheet">
    <link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="../assets/css/widgets/modules-widgets.css" rel="stylesheet" type="text/css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .report-card { border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); background: #fff; padding: 20px; margin-bottom: 30px; }
        .card-title { font-weight: 700; color: #3b3f5c; margin-bottom: 20px; font-size: 1.1rem; border-bottom: 2px solid #f1f2f3; padding-bottom: 10px; }
        .rec-item { padding: 15px; border-radius: 8px; margin-bottom: 10px; border-left: 5px solid; }
        .rec-success { background: #e7f7ed; border-color: #2ecc71; color: #1e8449; }
        .rec-warning { background: #fff9e6; border-color: #f1c40f; color: #9a7d0a; }
        .rec-info { background: #eaf1ff; border-color: #FFB200; color: #1b2e4b; }
    </style>
</head>
<body class="sidebar-noneoverflow">
    <?php include('header.php'); ?>
    <div class="main-container" id="container">
        <div class="overlay"></div>
        <?php include('sidebar.php'); ?>
        <div id="content" class="main-content">
            <div class="layout-px-spacing">
                
                <div class="row layout-top-spacing">
                    <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
                        <div class="report-card">
                            <form method="GET">
                                <div class="row align-items-end">
                                    <div class="col-md-4">
                                        <label>From Date</label>
                                        <input type="date" name="from_date" class="form-control" value="<?= $from_date ?>">
                                    </div>
                                    <div class="col-md-4">
                                        <label>To Date</label>
                                        <input type="date" name="to_date" class="form-control" value="<?= $to_date ?>">
                                    </div>
                                    <div class="col-md-4">
                                        <button type="submit" class="btn btn-primary">Filter Report</button>
                                        <a href="report" class="btn btn-danger">Reset</a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="row">
                    
                    <!-- Profit/Loss Chart -->
                    <div class="col-xl-8 col-lg-12 col-md-12 col-sm-12 col-12 layout-spacing">
                        <div class="report-card">
                            <h5 class="card-title"><?= $chart_title ?></h5>
                            <canvas id="profitChart" height="150"></canvas>
                        </div>
                    </div>

                    <!-- Recommendations -->
                    <div class="col-xl-4 col-lg-12 col-md-12 col-sm-12 col-12 layout-spacing">
                        <div class="report-card">
                            <h5 class="card-title">Smart Recommendations</h5>
                            <div class="recommendations-list">
                                <?php if (empty($recommendations)): ?>
                                    <div class="rec-item rec-info">Business is looking stable. Keep monitoring your stock levels!</div>
                                <?php else: ?>
                                    <?php foreach ($recommendations as $rec): ?>
                                        <div class="rec-item rec-<?= $rec['type'] ?>"><?= $rec['msg'] ?></div>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>

                    <!-- Top Selling -->
                    <div class="col-xl-6 col-lg-12 col-md-12 col-sm-12 col-12 layout-spacing">
                        <div class="report-card">
                            <h5 class="card-title">Best Selling Items (Customer Favorites)</h5>
                            <canvas id="sellingChart"></canvas>
                        </div>
                    </div>

                    <!-- Top Purchased -->
                    <div class="col-xl-6 col-lg-12 col-md-12 col-sm-12 col-12 layout-spacing">
                        <div class="report-card">
                            <h5 class="card-title">Most Restocked Inventory</h5>
                            <canvas id="purchaseChart"></canvas>
                        </div>
                    </div>

                </div>
            </div>
            <?php include('footer.php'); ?>
        </div>
    </div>

    <script src="../assets/js/libs/jquery-3.1.1.min.js"></script>
    <script src="../bootstrap/js/bootstrap.min.js"></script>
    <script src="../assets/js/app.js"></script>
    <script>
        $(document).ready(function() { App.init(); });

        // Chart Configurations
        Chart.defaults.font.family = "'Quicksand', sans-serif";

        // 1. Profit Chart
        new Chart(document.getElementById('profitChart'), {
            type: 'line',
            data: {
                labels: <?= json_encode($labels) ?>,
                datasets: [{
                    label: 'Net Profit (₦)',
                    data: <?= json_encode($profit_data) ?>,
                    borderColor: '#FFB200',
                    backgroundColor: 'rgba(255, 178, 0, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointRadius: 5
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });

        // 2. Selling Chart
        new Chart(document.getElementById('sellingChart'), {
            type: 'bar',
            data: {
                labels: <?= json_encode($ts_labels) ?>,
                datasets: [{
                    label: 'Quantity Sold',
                    data: <?= json_encode($ts_values) ?>,
                    backgroundColor: '#2ecc71'
                }]
            }
        });

        // 3. Purchase Chart
        new Chart(document.getElementById('purchaseChart'), {
            type: 'bar',
            data: {
                labels: <?= json_encode($tp_labels) ?>,
                datasets: [{
                    label: 'Quantity Purchased',
                    data: <?= json_encode($tp_values) ?>,
                    backgroundColor: '#ffbb44'
                }]
            }
        });
    </script>
</body>
</html>



