<?php
include('../assets/mashaAllah/gyada.php');
session_start();
error_reporting(0);

$purchaseId = mysqli_real_escape_string($con, $_GET['id']);

$purchase_query = $con->query("SELECT * FROM purchase_history WHERE id='$purchaseId' LIMIT 1");
$purchase_row = $purchase_query->fetch_array();

if (!$purchase_row) {
    header('location:purchase');
    exit;
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dansarki General Enterprise - Purchase Receipt</title>
    <link href="../assets/img/dansarkilogo.jpg" rel="shortcut icon">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

        * {
            box-sizing: border-box;
            -webkit-print-color-adjust: exact;
        }

        body {
            background-color: #fff;
            font-family: 'Inter', sans-serif;
            font-size: 12px;
            color: #000;
            margin: 0;
            padding: 20px 0;
            line-height: 1.4;
        }

        .receipt-container {
            background: #fff;
            width: 80mm;
            margin: 0 auto;
            padding: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border-radius: 8px;
            position: relative;
        }

        /* Watermark-like effect for professional look */
        .receipt-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: #000;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }

        .header {
            text-align: center;
            margin-bottom: 5px;
            padding-bottom: 0;
            border-bottom: none;
        }

        .header img {
            width: 85px;
            height: 85px;
            object-fit: contain;
            display: block;
            margin: 0 auto 10px;
            border: 1px solid #000;
            border-radius: 50%;
            padding: 5px;
            filter: grayscale(100%) contrast(1.2);
        }

        .header h1 {
            font-size: 18px;
            font-weight: 800;
            margin: 0 0 5px 0;
            color: #000;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .header .tagline {
            font-size: 11px;
            color: #000;
            font-style: italic;
            font-weight: 600;
            margin: 2px 0;
        }

        .header .address {
            font-size: 10px;
            color: #000;
            font-weight: 600;
            margin: 2px 0;
        }

        .header .contact-info {
            font-size: 10px;
            color: #000;
            font-style: italic;
            font-weight: 600;
            margin: 2px 0;
        }

        .separator {
            border-top: 1px dotted #000;
            margin: 15px 0;
        }

        .meta-section {
            margin-bottom: 12px;
            padding: 0;
        }

        .meta-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 4px;
            font-size: 11px;
        }

        .meta-label {
            color: #000;
            font-weight: 600;
        }

        .meta-value {
            color: #000;
            font-weight: 800;
            text-align: right;
        }

        .status-badge {
            display: block;
            width: 100%;
            text-align: center;
            padding: 6px;
            background: #fff;
            color: #000;
            border: 1px solid #000;
            font-weight: 800;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 3px;
            margin: 15px 0;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 10px;
        }

        .items-table th {
            text-align: left;
            border-bottom: 2px solid #000;
            padding: 6px 4px;
            font-size: 9px;
            font-weight: 800;
            text-transform: uppercase;
            color: #000;
        }

        .items-table td {
            padding: 6px 4px;
            border-bottom: 1px solid #000;
            vertical-align: top;
        }

        .item-description {
            font-weight: 600;
            font-size: 10px;
            color: #000;
        }

        .item-details {
            font-size: 8px;
            color: #000;
            display: block;
            margin-top: 1px;
        }

        .text-right {
            text-align: right;
        }

        .totals-container {
            border-top: 2px solid #000;
            padding-top: 8px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 3px 0;
            font-size: 10px;
        }

        .total-row.main-total {
            margin-top: 5px;
            padding: 8px 0;
            border-top: 1px solid #000;
            font-size: 14px;
            font-weight: 800;
            color: #000;
        }

        .payment-breakdown {
            margin-top: 8px;
            padding: 6px;
            background: #fff;
            border-radius: 6px;
            border-left: 3px solid #000;
        }

        .payment-breakdown .total-row {
            font-size: 9px;
            color: #000;
        }

        .signature-section {
            margin-top: 20px;
            text-align: center;
        }

        .signature-line {
            width: 120px;
            border-top: 1px solid #000;
            margin: 0 auto 3px;
        }

        .signature-text {
            font-size: 8px;
            font-weight: 700;
            text-transform: uppercase;
            color: #000;
        }

        .footer {
            margin-top: 15px;
            text-align: center;
            border-top: 1px solid #000;
            padding-top: 10px;
        }

        .footer .thank-you {
            font-size: 11px;
            font-weight: 700;
            color: #000;
            margin-bottom: 3px;
        }

        .footer small {
            font-size: 8px;
            color: #000;
            display: block;
            line-height: 1.4;
        }

        .print-actions {
            text-align: center;
            margin-top: 30px;
        }

        .btn-print {
            background: #000;
            color: #fff;
            padding: 12px 30px;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            font-weight: 700;
            font-size: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            background: #222;
        }

        @media print {
            body {
                background: #fff;
                padding: 0;
            }

            .receipt-container {
                box-shadow: none;
                width: 100%;
                padding: 5mm;
                border-radius: 0;
            }

            .receipt-container::before {
                display: none;
            }

            .no-print {
                display: none !important;
            }

            @page {
                margin: 0;
                size: 80mm auto;
            }
        }
    </style>
</head>

<body>

    <div class="receipt-container">
        <div class="header">
            <img src="../assets/img/dansarkilogo.jpg" alt="Logo">
            <h1>Dansarki General Enterprise</h1>
            <div class="tagline">Dealers on Rice, Spaghetti, Oil, Flour and Many More</div>
            <div class="address">No 4 Gidan Golden Penny, Ado Bayero Singa Market Kano</div>
            <div class="contact-info">09066686666, 08031111169</div>
        </div>

        <div class="separator"></div>

        <div class="meta-section">
            <div class="meta-row">
                <span class="meta-label">Purchase ID:</span>
                <span class="meta-value">#<?php echo $purchase_row['id']; ?></span>
            </div>
            <div class="meta-row">
                <span class="meta-label">Date:</span>
                <span class="meta-value"><?php echo date('d M Y', strtotime($purchase_row['purchase_date'])); ?></span>
            </div>
            <div class="meta-row">
                <span class="meta-label">Staff:</span>
                <span class="meta-value"><?php echo htmlspecialchars($_SESSION['name']); ?></span>
            </div>
            <div class="meta-row">
                <span class="meta-label">Supplier:</span>
                <span class="meta-value"><?php echo htmlspecialchars($purchase_row['purchase_from'] ?: 'N/A'); ?></span>
            </div>
        </div>

        <div class="status-badge">
            STOCKS/GOODS RECEIVED
        </div>

        <table class="items-table">
            <thead>
                <tr>
                    <th style="width: 50%;">Item</th>
                    <th class="text-right">Qty</th>
                    <th class="text-right">Cost Price</th>
                    <th class="text-right">Total Cost</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <span class="item-description"><?php echo htmlspecialchars($purchase_row['stock_name']); ?></span>
                        <?php if (!empty($purchase_row['for_desc'])): ?>
                            <span class="item-details"><?php echo htmlspecialchars($purchase_row['for_desc']); ?></span>
                        <?php endif; ?>
                    </td>
                    <td class="text-right"><?php echo number_format($purchase_row['quantity']); ?></td>
                    <td class="text-right">₦<?php echo number_format($purchase_row['cost_price']); ?></td>
                    <td class="text-right">₦<?php echo number_format($purchase_row['total_cost']); ?></td>
                </tr>
            </tbody>
        </table>

        <div class="totals-container">
            <div class="total-row">
                <span>Quantity Received</span>
                <span><?php echo number_format($purchase_row['quantity']); ?></span>
            </div>
            <div class="total-row">
                <span>Unit Cost Price</span>
                <span>₦<?php echo number_format($purchase_row['cost_price']); ?></span>
            </div>
            
            <div class="total-row main-total">
                <span>TOTAL COST</span>
                <span>₦<?php echo number_format($purchase_row['total_cost']); ?></span>
            </div>

            <div class="payment-breakdown">
                <div class="total-row" style="font-weight: 700; color: #000;">
                    <span>Amount Paid:</span>
                    <span>₦<?php echo number_format($purchase_row['amount_paid'] ?? 0); ?></span>
                </div>
                <?php if (($purchase_row['balance'] ?? 0) > 0): ?>
                    <div class="total-row">
                        <span>Balance Due:</span>
                        <span>₦<?php echo number_format($purchase_row['balance']); ?></span>
                    </div>
                <?php endif; ?>
            </div>
        </div>

        <div class="signature-section">
            <div class="signature-line"></div>
            <div class="signature-text">Authorized Signature</div>
        </div>

        <div class="footer">
            <div class="thank-you">Thank you for your business!</div>
            <small>Powered by Dansarki General Enterprise</small>
            <small>&copy; Teemassan Tech</small>
        </div>
    </div>

    <div class="print-actions no-print">
        <button class="btn-print" onclick="window.print()">Print This Receipt</button>
    </div>

</body>

</html>
