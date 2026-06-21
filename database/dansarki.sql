-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 06, 2026 at 08:02 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dansarki`
--

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`id`, `facilityID`, `name`, `address`) VALUES
(4, 'DANSARKI/001', 'Alh Yasir', 'No. 123 testing street, Kano');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `staffID` varchar(200) NOT NULL,
  `stockID` int(11) NOT NULL,
  `item` varchar(200) NOT NULL,
  `price` varchar(200) NOT NULL,
  `quantity` varchar(200) NOT NULL,
  `subtotal` varchar(200) NOT NULL,
  `discount` varchar(200) DEFAULT '0',
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `conca`
--

CREATE TABLE `conca` (
  `id` int(11) NOT NULL,
  `lastID` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conca`
--

INSERT INTO `conca` (`id`, `lastID`) VALUES
(1, '2');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `name` varchar(200) NOT NULL,
  `phone` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `gender` varchar(200) NOT NULL,
  `address` varchar(200) NOT NULL,
  `creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `updation` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `facilityID`, `name`, `phone`, `email`, `gender`, `address`, `creation`, `updation`) VALUES
(1, 'DANSARKI/001', 'DANSARKI BIG mur', '08025493838', '', 'Male', 'gidan MUR layin kwari', '2026-03-26 12:46:45', '0000-00-00 00:00:00'),
(2, 'DANSARKI/001', 'DANSARKI A64 G-baba', '08025493838', '', 'Male', 'hawa', '2026-03-26 12:48:58', '0000-00-00 00:00:00'),
(3, 'DANSARKI/001', 'DANSARKI G-Jallaba 6a.7a', '08025493838', '', 'Male', 'layin jallaba', '2026-03-26 12:50:47', '0000-00-00 00:00:00'),
(4, 'DANSARKI/001', 'H.J Textile A7', '09035893772', '', 'Male', 'gidan maiyari', '2026-03-26 12:53:27', '0000-00-00 00:00:00'),
(5, 'DANSARKI/001', 'AYACO TEX.', '08033722669', '', 'Male', 'gidan baba A45', '2026-03-26 12:55:39', '0000-00-00 00:00:00'),
(6, 'DANSARKI/001', 'BASH YENZI', '07084146183', '', 'Male', 'yenzi company NEW TEX.', '2026-03-28 15:56:28', '0000-00-00 00:00:00'),
(7, 'DANSARKI/001', 'HAMZA Shop', '09035893772', '', 'Male', 'gidan maiyari', '2026-03-28 15:57:52', '0000-00-00 00:00:00'),
(8, 'DANSARKI/001', 'AUWAL DUBAI apex', '09061838163', '', 'Male', 'gidan Amas', '2026-03-28 15:59:22', '0000-00-00 00:00:00'),
(9, 'DANSARKI/001', 'Goma 10', '08103418422', '', 'Male', 'baban hayat', '2026-03-29 11:44:20', '0000-00-00 00:00:00'),
(10, 'DANSARKI/001', 'ISHAKA BUNGEL', '08169988795', '', 'Male', 'Adamawa Yola', '2026-03-29 14:19:16', '0000-00-00 00:00:00'),
(11, 'DANSARKI/001', 'MAIBARGO ABBA', '07017501726', '', 'Male', 'gidan jallaba', '2026-04-01 14:55:48', '0000-00-00 00:00:00'),
(12, 'DANSARKI/001', 'ALIYU BASAKKWACHE', '09034261108', '', 'Male', 'sokoto', '2026-04-01 15:04:35', '0000-00-00 00:00:00'),
(13, 'DANSARKI/001', 'ALAMIN R. kings', '07083704677', '', 'Male', 'ginin me sahad', '2026-04-12 15:15:31', '0000-00-00 00:00:00'),
(14, 'DANSARKI/001', 'USSY ZARA', '08121232969', '', 'Male', 'gidan babansu', '2026-04-12 15:17:17', '0000-00-00 00:00:00'),
(15, 'DANSARKI/001', 'Soja babban wa', '08059906646', '', 'Female', 'gidan 80 ibb', '2026-04-13 10:20:03', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `debt_cart`
--

CREATE TABLE `debt_cart` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) NOT NULL,
  `customerID` varchar(200) NOT NULL,
  `staffID` varchar(200) NOT NULL,
  `stockID` int(11) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `item` varchar(200) NOT NULL,
  `price` varchar(200) NOT NULL,
  `quantity` varchar(200) NOT NULL,
  `subtotal` varchar(200) NOT NULL,
  `discount` decimal(15,2) DEFAULT 0.00,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deposit_history`
--

CREATE TABLE `deposit_history` (
  `id` int(11) NOT NULL,
  `customerID` int(11) NOT NULL,
  `transaction_id` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `previous_balance` decimal(10,2) NOT NULL,
  `new_balance` decimal(10,2) NOT NULL,
  `deposit_date` datetime NOT NULL DEFAULT current_timestamp(),
  `processed_by` varchar(100) NOT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deposit_history`
--

INSERT INTO `deposit_history` (`id`, `customerID`, `transaction_id`, `amount`, `payment_method`, `description`, `previous_balance`, `new_balance`, `deposit_date`, `processed_by`, `notes`) VALUES
(1, 1, 'DP-1774781559-4157', 1100000.00, 'Bank Transfer', 'N/A', 8041000.00, 6941000.00, '2026-03-29 11:52:39', 'Alh Yasir', 'N/A'),
(2, 7, 'DP-1774783798-9450', 415000.00, 'POS', 'N/A', 415000.00, 0.00, '2026-03-29 12:29:58', 'Alh Yasir', 'N/A'),
(3, 1, 'DP-1774977165-5805', 3100000.00, 'Bank Transfer', 'N/A', 10291000.00, 7191000.00, '2026-03-31 18:12:45', 'Alh Yasir', 'N/A'),
(4, 2, 'DP-1774978309-2972', 900000.00, 'Bank Transfer', 'N/A', 920000.00, 20000.00, '2026-03-31 18:31:49', 'Alh Yasir', 'N/A'),
(5, 3, 'DP-1774978404-9309', 800000.00, 'Bank Transfer', 'N/A', 4070000.00, 3270000.00, '2026-03-31 18:33:24', 'Alh Yasir', 'N/A'),
(6, 1, 'DP-1775062980-7832', 1300000.00, 'Bank Transfer', 'N/A', 8011000.00, 6711000.00, '2026-04-01 18:03:00', 'Alh Yasir', 'N/A'),
(7, 2, 'DP-1775146476-3001', 1000000.00, 'Bank Transfer', 'N/A', 2370000.00, 1370000.00, '2026-04-02 17:14:36', 'Alh Yasir', 'N/A'),
(8, 4, 'DP-1775148594-5996', 2500000.00, 'Bank Transfer', 'N/A', 2511750.00, 11750.00, '2026-04-02 17:49:54', 'Alh Yasir', 'N/A'),
(9, 3, 'DP-1775294460-6947', 720000.00, 'Bank Transfer', 'N/A', 3270000.00, 2550000.00, '2026-04-04 10:21:00', 'Alh Yasir', 'N/A'),
(10, 1, 'DP-1775294595-2459', 1521000.00, 'Bank Transfer', 'N/A', 9021000.00, 7500000.00, '2026-04-04 10:23:15', 'Alh Yasir', 'N/A'),
(11, 4, 'DP-1775319425-7470', 800000.00, 'Bank Transfer', 'N/A', 831750.00, 31750.00, '2026-04-04 17:17:05', 'Alh Yasir', 'N/A'),
(12, 2, 'DP-1775321187-8544', 600000.00, 'Bank Transfer', 'N/A', 2208450.00, 1608450.00, '2026-04-04 17:46:27', 'Alh Yasir', 'N/A'),
(13, 1, 'DP-1775322064-1388', 700000.00, 'Bank Transfer', 'N/A', 8330250.00, 7630250.00, '2026-04-04 18:01:05', 'Alh Yasir', 'N/A'),
(14, 4, 'DP-1775493436-9315', 1500000.00, 'Bank Transfer', 'N/A', 1596750.00, 96750.00, '2026-04-06 17:37:17', 'Alh Yasir', 'N/A'),
(15, 1, 'DP-1775495171-9546', 1500000.00, 'Bank Transfer', 'N/A', 11285250.00, 9785250.00, '2026-04-06 18:06:11', 'Alh Yasir', 'N/A'),
(16, 2, 'DP-1775495337-7782', 475000.00, 'Bank Transfer', 'N/A', 2023450.00, 1548450.00, '2026-04-06 18:08:57', 'Alh Yasir', 'N/A'),
(17, 3, 'DP-1775495401-4799', 340000.00, 'Bank Transfer', 'N/A', 4640000.00, 4300000.00, '2026-04-06 18:10:01', 'Alh Yasir', 'N/A'),
(18, 2, 'DP-1775663498-2643', 550000.00, 'Bank Transfer', 'N/A', 1548450.00, 998450.00, '2026-04-08 16:51:38', 'Alh Yasir', 'N/A'),
(19, 1, 'DP-1775663819-1625', 1150000.00, 'Bank Transfer', 'N/A', 9785250.00, 8635250.00, '2026-04-08 16:56:59', 'Alh Yasir', 'N/A'),
(20, 5, 'DP-1775663866-9911', 1500000.00, 'Bank Transfer', 'N/A', 6155600.00, 4655600.00, '2026-04-08 16:57:46', 'Alh Yasir', 'N/A'),
(21, 10, 'DP-1775822952-7032', 200000.00, 'Bank Transfer', 'N/A', 720000.00, 520000.00, '2026-04-10 13:09:12', 'Alh Yasir', 'N/A'),
(22, 8, 'DP-1775834875-1161', 200000.00, 'Cash', 'N/A', 500000.00, 300000.00, '2026-04-10 16:27:55', 'Alh Yasir', 'N/A'),
(23, 8, 'DP-1775834889-1495', 50000.00, 'Bank Transfer', 'N/A', 300000.00, 250000.00, '2026-04-10 16:28:09', 'Alh Yasir', 'N/A'),
(24, 4, 'DP-1775839766-2776', 2300000.00, 'Bank Transfer', 'N/A', 3161750.00, 861750.00, '2026-04-10 17:49:26', 'Alh Yasir', 'N/A'),
(25, 3, 'DP-1775839972-4156', 600000.00, 'Bank Transfer', 'N/A', 4300000.00, 3700000.00, '2026-04-10 17:52:52', 'Alh Yasir', 'N/A'),
(26, 2, 'DP-1775840065-5266', 540000.00, 'Bank Transfer', 'N/A', 998450.00, 458450.00, '2026-04-10 17:54:25', 'Alh Yasir', 'N/A'),
(27, 1, 'DP-1775841818-6507', 1150000.00, 'Bank Transfer', 'N/A', 11700250.00, 10550250.00, '2026-04-10 18:23:38', 'Alh Yasir', 'N/A'),
(28, 11, 'DP-1775916123-3010', 200000.00, 'Bank Transfer', 'N/A', 335000.00, 135000.00, '2026-04-11 15:02:03', 'Alh Yasir', 'N/A'),
(29, 7, 'DP-1776010169-7108', 315000.00, 'Bank Transfer', 'N/A', 315000.00, 0.00, '2026-04-12 17:09:29', 'Alh Yasir', 'N/A'),
(30, 1, 'DP-1776011469-8734', 1960000.00, 'Bank Transfer', 'N/A', 12010250.00, 10050250.00, '2026-04-12 17:31:09', 'Alh Yasir', 'N/A'),
(31, 3, 'DP-1776011621-3473', 390000.00, 'Bank Transfer', 'N/A', 3700000.00, 3310000.00, '2026-04-12 17:33:41', 'Alh Yasir', 'N/A'),
(32, 2, 'DP-1776011718-2972', 300000.00, 'Bank Transfer', 'N/A', 2068450.00, 1768450.00, '2026-04-12 17:35:18', 'Alh Yasir', 'N/A'),
(33, 1, 'DP-1776100092-4724', 1500000.00, 'Bank Transfer', 'N/A', 15105250.00, 13605250.00, '2026-04-13 18:08:12', 'Alh Yasir', 'N/A'),
(34, 2, 'DP-1776100180-4624', 350000.00, 'Bank Transfer', 'N/A', 1768450.00, 1418450.00, '2026-04-13 18:09:40', 'Alh Yasir', 'N/A'),
(35, 1, 'DP-1776156276-3503', 50.00, 'POS', 'testing', 13605250.00, 13605200.00, '2026-04-14 09:44:36', 'Alh Yasir', NULL),
(36, 1, 'DP-1777627378-4502', 50.00, 'Cash', 'test', 13633700.00, 13633650.00, '2026-05-01 10:22:58', 'Bilya staff1', NULL),
(37, 1, 'DP-1777627446-6154', 50.00, 'Cash', 'test', 13633650.00, 13633600.00, '2026-05-01 10:24:06', 'Bilya staff1', NULL),
(38, 1, 'DP-1777627605-9721', 50.00, 'Cash', 'test', 13633600.00, 13633550.00, '2026-05-01 10:26:45', 'Bilya staff1', NULL),
(39, 7, 'DP-1777627648-5581', 50.00, 'Cash', 'testing', 440000.00, 439950.00, '2026-05-01 10:27:28', 'Bilya staff1', NULL),
(40, 7, 'DP-1777627749-9359', 50.00, 'Cash', 'testing', 439950.00, 439900.00, '2026-05-01 10:29:09', 'Bilya staff1', NULL),
(41, 7, 'DP-1777627781-1881', 100.00, 'POS', 'testing', 444900.00, 444800.00, '2026-05-01 10:29:41', 'Bilya staff1', NULL),
(42, 6, 'DP-1777698758-8075', 1660000.00, 'Cash', 'testing', 1660000.00, 0.00, '2026-05-02 06:12:38', 'Alh Yasir', NULL),
(43, 1, 'DP-1777717091-1109', 550.00, 'POS', 'testing', 13633550.00, 13633000.00, '2026-05-02 11:18:11', 'Bilya staff1', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `expense`
--

CREATE TABLE `expense` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `item` varchar(200) NOT NULL,
  `price` varchar(200) NOT NULL,
  `type` varchar(11) DEFAULT NULL,
  `creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `updation` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') DEFAULT 'pending',
  `last_sync` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `facility`
--

CREATE TABLE `facility` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) NOT NULL,
  `agentID` varchar(200) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `phone` varchar(200) NOT NULL,
  `gender` varchar(200) NOT NULL,
  `dob` varchar(200) NOT NULL,
  `fname` varchar(200) NOT NULL,
  `address` varchar(200) NOT NULL,
  `country` varchar(200) NOT NULL,
  `state` varchar(200) NOT NULL,
  `lga` varchar(200) NOT NULL,
  `type` varchar(200) NOT NULL,
  `plan` varchar(200) NOT NULL,
  `price` varchar(200) NOT NULL,
  `role` varchar(200) NOT NULL,
  `status` int(11) NOT NULL,
  `paid` varchar(200) NOT NULL,
  `due` varchar(200) NOT NULL,
  `password` varchar(200) NOT NULL,
  `creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `updation` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `last_stock_reset` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `facility`
--

INSERT INTO `facility` (`id`, `facilityID`, `agentID`, `name`, `email`, `phone`, `gender`, `dob`, `fname`, `address`, `country`, `state`, `lga`, `type`, `plan`, `price`, `role`, `status`, `paid`, `due`, `password`, `creation`, `updation`, `last_stock_reset`) VALUES
(4, 'DANSARKI/001', '1', 'Alh Yasir', 'yasir@gmail.com', '1234567890', 'Male', '', 'Alh Yasir', 'No 123 Testing street', 'Nigeria', 'Kano', '', '', '', '', 'Admin', 1, '', '', 'fd149fa1f2a2fee8d88bc1be14467a81', '2025-06-17 15:16:03', '2026-03-26 12:31:42', '0000-00-00'),
(6, 'DANSARKI/001', 'N/A', 'Bilya staff1', 'staff1@gmail.com', '081234565789', 'Male', '', 'ALH Yasir', 'No 123 Testing street', '', '', '', '', '', '', 'Staff', 1, '', '', '827ccb0eea8a706c4c34a16891f84e7b', '2026-03-11 06:30:03', '2026-03-26 11:37:32', '0000-00-00');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `staffID` varchar(200) NOT NULL,
  `stockID` int(11) DEFAULT NULL,
  `item` varchar(200) NOT NULL,
  `price` varchar(200) NOT NULL,
  `quantity` varchar(200) NOT NULL,
  `subtotal` varchar(200) NOT NULL,
  `item_discount` varchar(200) DEFAULT '0',
  `staff` varchar(200) DEFAULT NULL,
  `payment` varchar(200) DEFAULT NULL,
  `orderID` varchar(200) DEFAULT NULL,
  `discount` varchar(200) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `customerID` int(11) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `buyer_name` varchar(255) DEFAULT NULL,
  `amount_paid` varchar(200) DEFAULT NULL,
  `change_given` varchar(200) DEFAULT NULL,
  `net_total` varchar(200) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `cash` varchar(200) DEFAULT NULL,
  `pos` varchar(200) DEFAULT NULL,
  `transfer` varchar(200) DEFAULT NULL,
  `creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `updation` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') DEFAULT 'pending',
  `last_sync` timestamp NULL DEFAULT NULL,
  `sync_attempts` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `facilityID`, `staffID`, `stockID`, `item`, `price`, `quantity`, `subtotal`, `item_discount`, `staff`, `payment`, `orderID`, `discount`, `status`, `customerID`, `customer_name`, `buyer_name`, `amount_paid`, `change_given`, `net_total`, `bank_name`, `cash`, `pos`, `transfer`, `creation`, `updation`, `sync_status`, `last_sync`, `sync_attempts`) VALUES
(1, 'DANSARKI/001', '6', 7, 'Gold Luxury', '420000', '1', '420000', 'N/A', 'Bilya staff1', 'Split Payment', '48946', '110000', 1, 0, 'N/A', 'H J textiles', '1810000', '0.00', '310000', 'N/A', '0', '0', '1810000', '2026-03-26 14:00:59', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(2, 'DANSARKI/001', '6', 1, 'LAS VEGAS', '450000', '2', '900000', 'N/A', 'Bilya staff1', 'Split Payment', '48946', '110000', 1, 0, 'N/A', 'H J textiles', '1810000', '0.00', '790000', 'N/A', '0', '0', '1810000', '2026-03-26 14:00:59', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(3, 'DANSARKI/001', '6', 2, 'SILVER CROWN', '600000', '1', '600000', 'N/A', 'Bilya staff1', 'Split Payment', '48946', '110000', 1, 0, 'N/A', 'H J textiles', '1810000', '0.00', '490000', 'N/A', '0', '0', '1810000', '2026-03-26 14:00:59', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(4, 'DANSARKI/001', '4', 7, 'Gold Luxury', '420000', '1', '420000', 'N/A', 'Alh Yasir', 'Split Payment', '177453995060', '110000', 1, 0, 'N/A', 'DANSARKI G-Baba A64', '1810000', '0.00', '310000', 'N/A', '0', '0', '1810000', '2026-03-26 14:45:50', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(5, 'DANSARKI/001', '4', 1, 'LAS VEGAS', '450000', '2', '900000', 'N/A', 'Alh Yasir', 'Split Payment', '177453995060', '110000', 1, 0, 'N/A', 'DANSARKI G-Baba A64', '1810000', '0.00', '790000', 'N/A', '0', '0', '1810000', '2026-03-26 14:45:50', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(6, 'DANSARKI/001', '4', 2, 'SILVER CROWN', '600000', '1', '600000', 'N/A', 'Alh Yasir', 'Split Payment', '177453995060', '110000', 1, 0, 'N/A', 'DANSARKI G-Baba A64', '1810000', '0.00', '490000', 'N/A', '0', '0', '1810000', '2026-03-26 14:45:50', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(7, 'DANSARKI/001', '6', 1, 'LAS VEGAS', '450000', '2', '900000', 'N/A', 'Bilya staff1', 'Credit', '177454164725', '110000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '790000', 'N/A', '0', '0', '0', '2026-03-26 15:14:07', '2026-03-26 15:14:07', 'pending', '0000-00-00 00:00:00', 0),
(8, 'DANSARKI/001', '6', 7, 'Gold Luxury', '420000', '1', '420000', 'N/A', 'Bilya staff1', 'Credit', '177454164725', '110000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '310000', 'N/A', '0', '0', '0', '2026-03-26 15:14:07', '2026-03-26 15:14:07', 'pending', '0000-00-00 00:00:00', 0),
(9, 'DANSARKI/001', '6', 2, 'SILVER CROWN', '600000', '1', '600000', 'N/A', 'Bilya staff1', 'Credit', '177454164725', '110000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '490000', 'N/A', '0', '0', '0', '2026-03-26 15:14:07', '2026-03-26 15:14:07', 'pending', '0000-00-00 00:00:00', 0),
(10, 'DANSARKI/001', '6', 25, 'OCEAN BLUE blsk', '1290000', '1', '1290000', 'N/A', 'Bilya staff1', 'Split Payment', '75920', '45000', 1, 0, 'N/A', 'H J textiles', '2800000', '0.00', '1245000', 'N/A', '0', '0', '2800000', '2026-03-28 16:24:35', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(11, 'DANSARKI/001', '6', 24, 'SILK ROAD AD', '1300000', '1', '1300000', 'N/A', 'Bilya staff1', 'Split Payment', '75920', '45000', 1, 0, 'N/A', 'H J textiles', '2800000', '0.00', '1255000', 'N/A', '0', '0', '2800000', '2026-03-28 16:24:35', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(12, 'DANSARKI/001', '6', 12, 'YJ 4#', '255000', '1', '255000', 'N/A', 'Bilya staff1', 'Split Payment', '75920', '45000', 1, 0, 'N/A', 'H J textiles', '2800000', '0.00', '210000', 'N/A', '0', '0', '2800000', '2026-03-28 16:24:35', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(13, 'DANSARKI/001', '6', 7, 'Gold Luxury', '420000', '1', '420000', 'N/A', 'Bilya staff1', 'Credit', '177471889268', '5000', 1, 7, 'HAMZA Shop', 'N/A', '0', '0', '415000', 'N/A', '0', '0', '0', '2026-03-28 16:28:12', '2026-03-28 16:28:12', 'pending', '0000-00-00 00:00:00', 0),
(14, 'DANSARKI/001', '6', 12, 'YJ 4#', '255000', '2', '510000', 'N/A', 'Bilya staff1', 'Credit', '177471900827', '50000', 1, 6, 'BASH YENZI', 'N/A', '0', '0', '460000', 'N/A', '0', '0', '0', '2026-03-28 16:30:08', '2026-03-28 16:30:08', 'pending', '0000-00-00 00:00:00', 0),
(15, 'DANSARKI/001', '6', 13, 'GK PLAIN 200y', '400000', '3', '1200000', 'N/A', 'Bilya staff1', 'Credit', '177471938014', '59000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1141000', 'N/A', '0', '0', '0', '2026-03-28 16:36:20', '2026-03-28 16:36:20', 'pending', '0000-00-00 00:00:00', 0),
(16, 'DANSARKI/001', '6', 19, 'FASHION GOLD', '1140000', '1', '1140000', 'N/A', 'Bilya staff1', 'Credit', '177471938014', '59000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1081000', 'N/A', '0', '0', '0', '2026-03-28 16:36:20', '2026-03-28 16:36:20', 'pending', '0000-00-00 00:00:00', 0),
(17, 'DANSARKI/001', '6', 21, 'VIP ILLUSION AD', '1350000', '1', '1350000', 'N/A', 'Bilya staff1', 'Credit', '177471938014', '59000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1291000', 'N/A', '0', '0', '0', '2026-03-28 16:36:20', '2026-03-28 16:36:20', 'pending', '0000-00-00 00:00:00', 0),
(18, 'DANSARKI/001', '6', 22, 'PROFESSOR AD', '1300000', '1', '1300000', 'N/A', 'Bilya staff1', 'Credit', '177471938014', '59000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1241000', 'N/A', '0', '0', '0', '2026-03-28 16:36:20', '2026-03-28 16:36:20', 'pending', '0000-00-00 00:00:00', 0),
(19, 'DANSARKI/001', '6', 23, 'WISE MAN AD', '1300000', '1', '1300000', 'N/A', 'Bilya staff1', 'Credit', '177471938014', '59000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1241000', 'N/A', '0', '0', '0', '2026-03-28 16:36:20', '2026-03-28 16:36:20', 'pending', '0000-00-00 00:00:00', 0),
(22, 'DANSARKI/001', '4', 13, 'GK PLAIN 200y', '400000', '2', '800000', 'N/A', 'Alh Yasir', 'Split Payment', '177478261197', '67000', 1, 0, 'N/A', 'DANSARKI G-Baba A64', '1113000', '0.00', '733000', 'N/A', '0', '0', '1113000', '2026-03-29 10:10:11', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(23, 'DANSARKI/001', '4', 9, 'THE ONE AMZ', '380000', '1', '380000', 'N/A', 'Alh Yasir', 'Split Payment', '177478261197', '67000', 1, 0, 'N/A', 'DANSARKI G-Baba A64', '1113000', '0.00', '313000', 'N/A', '0', '0', '1113000', '2026-03-29 10:10:11', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(25, 'DANSARKI/001', '4', 13, 'GK PLAIN 200y', '400000', '2', '800000', 'N/A', 'Alh Yasir', 'Split Payment', '177478326515', '150000', 1, 0, 'N/A', 'H J textiles', '2430000', '0.00', '650000', 'N/A', '0', '0', '2430000', '2026-03-29 10:21:05', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(26, 'DANSARKI/001', '4', 9, 'THE ONE AMZ', '380000', '1', '380000', 'N/A', 'Alh Yasir', 'Split Payment', '177478326515', '150000', 1, 0, 'N/A', 'H J textiles', '2430000', '0.00', '230000', 'N/A', '0', '0', '2430000', '2026-03-29 10:21:05', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(27, 'DANSARKI/001', '4', 6, 'PORTMANN AMZ PLAIN', '700000', '2', '1400000', 'N/A', 'Alh Yasir', 'Split Payment', '177478326515', '150000', 1, 0, 'N/A', 'H J textiles', '2430000', '0.00', '1250000', 'N/A', '0', '0', '2430000', '2026-03-29 10:21:05', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(28, 'DANSARKI/001', '4', 20, 'AUSTRAILIAN WIFI', '2050000', '1', '2050000', 'N/A', 'Alh Yasir', 'Credit', '177478368210', '170000', 1, 3, 'DANSARKI G-Jallaba 6a.7a', 'N/A', '1150000', '0', '1880000', 'N/A', '0', '0', '1150000', '2026-03-29 10:28:02', '2026-03-29 10:28:03', 'pending', '0000-00-00 00:00:00', 0),
(29, 'DANSARKI/001', '4', 6, 'PORTMANN AMZ PLAIN', '700000', '2', '1400000', 'N/A', 'Alh Yasir', 'Credit', '177478368210', '170000', 1, 3, 'DANSARKI G-Jallaba 6a.7a', 'N/A', '1150000', '0', '1230000', 'N/A', '0', '0', '1150000', '2026-03-29 10:28:02', '2026-03-29 10:28:03', 'pending', '0000-00-00 00:00:00', 0),
(30, 'DANSARKI/001', '4', 11, 'PHANTOM noble wool', '820000', '1', '820000', 'N/A', 'Alh Yasir', 'Credit', '177478368210', '170000', 1, 3, 'DANSARKI G-Jallaba 6a.7a', 'N/A', '1150000', '0', '650000', 'N/A', '0', '0', '1150000', '2026-03-29 10:28:02', '2026-03-29 10:28:03', 'pending', '0000-00-00 00:00:00', 0),
(31, 'DANSARKI/001', '4', 6, 'PORTMANN AMZ PLAIN', '700000', '2', '1400000', 'N/A', 'Alh Yasir', 'Credit', '177478553654', '170000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1230000', 'N/A', '0', '0', '0', '2026-03-29 10:58:56', '2026-03-29 10:58:57', 'pending', '0000-00-00 00:00:00', 0),
(32, 'DANSARKI/001', '4', 11, 'PHANTOM noble wool', '820000', '1', '820000', 'N/A', 'Alh Yasir', 'Credit', '177478553654', '170000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '650000', 'N/A', '0', '0', '0', '2026-03-29 10:58:56', '2026-03-29 10:58:57', 'pending', '0000-00-00 00:00:00', 0),
(33, 'DANSARKI/001', '4', 9, 'THE ONE AMZ', '380000', '1', '380000', 'N/A', 'Alh Yasir', 'Credit', '177478553654', '170000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '210000', 'N/A', '0', '0', '0', '2026-03-29 10:58:56', '2026-03-29 10:58:57', 'pending', '0000-00-00 00:00:00', 0),
(34, 'DANSARKI/001', '4', 6, 'PORTMANN AMZ PLAIN', '700000', '1', '700000', 'N/A', 'Alh Yasir', 'Credit', '177478837038', '70000', 1, 9, 'Goma 10', 'N/A', '0', '0', '630000', 'N/A', '0', '0', '0', '2026-03-29 11:46:10', '2026-03-29 11:46:11', 'pending', '0000-00-00 00:00:00', 0),
(35, 'DANSARKI/001', '4', 12, 'YJ 4#', '255000', '1', '255000', 'N/A', 'Alh Yasir', 'Split Payment', '177478854559', '15000', 1, 0, 'N/A', 'alh isah', '240000', '0.00', '240000', 'N/A', '0', '0', '240000', '2026-03-29 11:49:05', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(36, 'DANSARKI/001', '4', 26, 'swiss Okutex AD', '1120000', '1', '1120000', 'N/A', 'Alh Yasir', 'Credit', '177479461560', '0', 1, 3, 'DANSARKI G-Jallaba 6a.7a', 'N/A', '0', '0', '1120000', 'N/A', '0', '0', '0', '2026-03-29 13:30:15', '2026-03-29 13:30:15', 'pending', '0000-00-00 00:00:00', 0),
(37, 'DANSARKI/001', '4', 3, 'WATCHMAN', '200000', '1', '200000', 'N/A', 'Alh Yasir', 'Split Payment', '177479743591', '10000', 1, 0, 'N/A', 'ishaka bungel', '190000', '0.00', '190000', 'zenith bank', '0', '0', '190000', '2026-03-29 14:17:15', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(38, 'DANSARKI/001', '4', 27, 'SOFT COTTON shadda', '1600000', '1', '1600000', 'N/A', 'Alh Yasir', 'Credit', '177479803744', '35000', 1, 10, 'ISHAKA BUNGEL', 'N/A', '1700000', '0', '1565000', 'zenith bank', '0', '0', '1700000', '2026-03-29 14:27:17', '2026-03-29 14:27:17', 'pending', '0000-00-00 00:00:00', 0),
(39, 'DANSARKI/001', '4', 3, 'WATCHMAN', '200000', '1', '200000', 'N/A', 'Alh Yasir', 'Credit', '177479803744', '35000', 1, 10, 'ISHAKA BUNGEL', 'N/A', '1700000', '0', '165000', 'zenith bank', '0', '0', '1700000', '2026-03-29 14:27:17', '2026-03-29 14:27:17', 'pending', '0000-00-00 00:00:00', 0),
(40, 'DANSARKI/001', '4', 13, 'GK PLAIN 200y', '400000', '1', '400000', 'N/A', 'Alh Yasir', 'Credit', '177479803744', '35000', 1, 10, 'ISHAKA BUNGEL', 'N/A', '1700000', '0', '365000', 'zenith bank', '0', '0', '1700000', '2026-03-29 14:27:17', '2026-03-29 14:27:17', 'pending', '0000-00-00 00:00:00', 0),
(41, 'DANSARKI/001', '4', 12, 'YJ 4#', '255000', '1', '255000', 'N/A', 'Alh Yasir', 'Credit', '177479803744', '35000', 1, 10, 'ISHAKA BUNGEL', 'N/A', '1700000', '0', '220000', 'zenith bank', '0', '0', '1700000', '2026-03-29 14:27:17', '2026-03-29 14:27:17', 'pending', '0000-00-00 00:00:00', 0),
(42, 'DANSARKI/001', '4', 13, 'GK PLAIN 200y', '400000', '3', '1200000', 'N/A', 'Alh Yasir', 'Credit', '177489034535', '570000', 1, 5, 'AYACO TEX.', 'N/A', '3438400', '0', '630000', 'zenith bank', '0', '0', '3438400', '2026-03-30 16:05:45', '2026-03-30 16:05:45', 'pending', '0000-00-00 00:00:00', 0),
(43, 'DANSARKI/001', '4', 11, 'PHANTOM noble wool', '820000', '1', '820000', 'N/A', 'Alh Yasir', 'Credit', '177489034535', '570000', 1, 5, 'AYACO TEX.', 'N/A', '3438400', '0', '250000', 'zenith bank', '0', '0', '3438400', '2026-03-30 16:05:45', '2026-03-30 16:05:45', 'pending', '0000-00-00 00:00:00', 0),
(44, 'DANSARKI/001', '4', 7, 'Gold Luxury', '420000', '1', '420000', 'N/A', 'Alh Yasir', 'Credit', '177489034535', '570000', 1, 5, 'AYACO TEX.', 'N/A', '3438400', '0', '-150000', 'zenith bank', '0', '0', '3438400', '2026-03-30 16:05:45', '2026-03-30 16:05:45', 'pending', '0000-00-00 00:00:00', 0),
(45, 'DANSARKI/001', '4', 2, 'SILVER CROWN', '600000', '2', '1200000', 'N/A', 'Alh Yasir', 'Credit', '177489034535', '570000', 1, 5, 'AYACO TEX.', 'N/A', '3438400', '0', '630000', 'zenith bank', '0', '0', '3438400', '2026-03-30 16:05:45', '2026-03-30 16:05:45', 'pending', '0000-00-00 00:00:00', 0),
(46, 'DANSARKI/001', '4', 8, 'G-CELSIO', '370000', '2', '740000', 'N/A', 'Alh Yasir', 'Credit', '177489034535', '570000', 1, 5, 'AYACO TEX.', 'N/A', '3438400', '0', '170000', 'zenith bank', '0', '0', '3438400', '2026-03-30 16:05:45', '2026-03-30 16:05:45', 'pending', '0000-00-00 00:00:00', 0),
(47, 'DANSARKI/001', '4', 1, 'LAS VEGAS', '450000', '4', '1800000', 'N/A', 'Alh Yasir', 'Credit', '177489034535', '570000', 1, 5, 'AYACO TEX.', 'N/A', '3438400', '0', '1230000', 'zenith bank', '0', '0', '3438400', '2026-03-30 16:05:45', '2026-03-30 16:05:45', 'pending', '0000-00-00 00:00:00', 0),
(48, 'DANSARKI/001', '4', 15, 'GENTLEMAN A#', '480000', '2', '960000', 'N/A', 'Alh Yasir', 'Credit', '177489034535', '570000', 1, 5, 'AYACO TEX.', 'N/A', '3438400', '0', '390000', 'zenith bank', '0', '0', '3438400', '2026-03-30 16:05:45', '2026-03-30 16:05:45', 'pending', '0000-00-00 00:00:00', 0),
(49, 'DANSARKI/001', '4', 6, 'PORTMANN AMZ PLAIN', '700000', '2', '1400000', 'N/A', 'Alh Yasir', 'Credit', '177489034535', '570000', 1, 5, 'AYACO TEX.', 'N/A', '3438400', '0', '830000', 'zenith bank', '0', '0', '3438400', '2026-03-30 16:05:45', '2026-03-30 16:05:45', 'pending', '0000-00-00 00:00:00', 0),
(57, 'DANSARKI/001', '4', 12, 'YJ 4#', '255000', '1', '255000', 'N/A', 'Alh Yasir', 'Credit', '177496163055', '45000', 1, 4, 'H.J Textile A7', 'N/A', '528250', '0', '210000', 'zenith bank', '0', '0', '528250', '2026-03-31 11:53:50', '2026-03-31 11:53:50', 'pending', '0000-00-00 00:00:00', 0),
(58, 'DANSARKI/001', '4', 18, 'JU WOOL A florence', '480000', '1', '480000', 'N/A', 'Alh Yasir', 'Credit', '177496163055', '45000', 1, 4, 'H.J Textile A7', 'N/A', '528250', '0', '435000', 'zenith bank', '0', '0', '528250', '2026-03-31 11:53:50', '2026-03-31 11:53:50', 'pending', '0000-00-00 00:00:00', 0),
(60, 'DANSARKI/001', '4', 12, 'YJ 4#', '255000', '2', '510000', 'N/A', 'Alh Yasir', 'Credit', '177496191578', '70000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '440000', 'N/A', '0', '0', '0', '2026-03-31 11:58:35', '2026-03-31 11:58:35', 'pending', '0000-00-00 00:00:00', 0),
(61, 'DANSARKI/001', '4', 18, 'JU WOOL A florence', '480000', '1', '480000', 'N/A', 'Alh Yasir', 'Credit', '177496191578', '70000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '410000', 'N/A', '0', '0', '0', '2026-03-31 11:58:35', '2026-03-31 11:58:35', 'pending', '0000-00-00 00:00:00', 0),
(63, 'DANSARKI/001', '4', 12, 'YJ 4#', '255000', '2', '510000', 'N/A', 'Alh Yasir', 'Credit', '177496284997', '70000', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '440000', 'N/A', '0', '0', '0', '2026-03-31 12:14:09', '2026-03-31 12:14:09', 'pending', '0000-00-00 00:00:00', 0),
(64, 'DANSARKI/001', '4', 18, 'JU WOOL A florence', '480000', '1', '480000', 'N/A', 'Alh Yasir', 'Credit', '177496284997', '70000', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '410000', 'N/A', '0', '0', '0', '2026-03-31 12:14:09', '2026-03-31 12:14:09', 'pending', '0000-00-00 00:00:00', 0),
(66, 'DANSARKI/001', '4', 13, 'GK PLAIN 200y', '400000', '1', '400000', 'N/A', 'Alh Yasir', 'Credit', '177497050768', '35000', 1, 8, 'AUWAL DUBAI apex', 'N/A', '315000', '0', '365000', 'zenith bank', '0', '0', '315000', '2026-03-31 14:21:47', '2026-03-31 14:21:47', 'pending', '0000-00-00 00:00:00', 0),
(67, 'DANSARKI/001', '4', 14, 'Mr MURACCA', '450000', '1', '450000', 'N/A', 'Alh Yasir', 'Credit', '177497050768', '35000', 1, 8, 'AUWAL DUBAI apex', 'N/A', '315000', '0', '415000', 'zenith bank', '0', '0', '315000', '2026-03-31 14:21:47', '2026-03-31 14:21:47', 'pending', '0000-00-00 00:00:00', 0),
(68, 'DANSARKI/001', '6', 12, 'YJ 4#', '255000', '1', '255000', 'N/A', 'Bilya staff1', 'Split Payment', '18684', '15000', 1, 0, 'N/A', 'ABDUL RAHMAN ME LAFIYA', '240000', '0.00', '240000', 'N/A', '0', '240000', '0', '2026-04-01 09:54:33', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(69, 'DANSARKI/001', '6', 12, 'YJ 4#', '255000', '1', '255000', 'N/A', 'Bilya staff1', 'Split Payment', '47464', '15000', 1, 0, 'N/A', 'Kumurya', '240000', '0.00', '240000', 'N/A', '0', '0', '240000', '2026-04-01 14:32:26', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(70, 'DANSARKI/001', '4', 8, 'G-CELSIO', '370000', '1', '370000', 'N/A', 'Alh Yasir', 'Credit', '177505899094', '35000', 1, 11, 'MAIBARGO ABBA', 'N/A', '0', '0', '335000', 'N/A', '0', '0', '0', '2026-04-01 14:56:30', '2026-04-01 14:56:30', 'pending', '0000-00-00 00:00:00', 0),
(72, 'DANSARKI/001', '4', 1, 'LAS VEGAS', '450000', '2', '900000', 'N/A', 'Alh Yasir', 'Credit', '177506033356', '80000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '820000', 'N/A', '0', '0', '0', '2026-04-01 15:18:53', '2026-04-01 15:18:54', 'pending', '0000-00-00 00:00:00', 0),
(73, 'DANSARKI/001', '6', 18, 'JU WOOL A florence', '480000', '1', '480000', 'N/A', 'Bilya staff1', 'Split Payment', '34466', '20000', 1, 0, 'N/A', 'ABDULFATAH', '460000', '0.00', '460000', 'N/A', '0', '460000', '0', '2026-04-02 11:25:12', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(74, 'DANSARKI/001', '4', 8, 'G-CELSIO', '370000', '1', '370000', 'N/A', 'Alh Yasir', 'Credit', '177514154847', '210000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '160000', 'N/A', '0', '0', '0', '2026-04-02 13:52:28', '2026-04-02 13:52:28', 'pending', '0000-00-00 00:00:00', 0),
(75, 'DANSARKI/001', '4', 1, 'LAS VEGAS', '450000', '2', '900000', 'N/A', 'Alh Yasir', 'Credit', '177514154847', '210000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '690000', 'N/A', '0', '0', '0', '2026-04-02 13:52:28', '2026-04-02 13:52:28', 'pending', '0000-00-00 00:00:00', 0),
(76, 'DANSARKI/001', '4', 17, 'TIMBUKTU', '390000', '1', '390000', 'N/A', 'Alh Yasir', 'Credit', '177514154847', '210000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '180000', 'N/A', '0', '0', '0', '2026-04-02 13:52:28', '2026-04-02 13:52:28', 'pending', '0000-00-00 00:00:00', 0),
(77, 'DANSARKI/001', '4', 14, 'Mr MURACCA', '450000', '2', '900000', 'N/A', 'Alh Yasir', 'Credit', '177514154847', '210000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '690000', 'N/A', '0', '0', '0', '2026-04-02 13:52:28', '2026-04-02 13:52:28', 'pending', '0000-00-00 00:00:00', 0),
(81, 'DANSARKI/001', '6', 8, 'G-CELSIO', '370000', '1', '370000', 'N/A', 'Bilya staff1', 'Credit', '177514416542', '210000', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '160000', 'N/A', '0', '0', '0', '2026-04-02 14:36:05', '2026-04-02 14:36:06', 'pending', '0000-00-00 00:00:00', 0),
(82, 'DANSARKI/001', '6', 1, 'LAS VEGAS', '450000', '2', '900000', 'N/A', 'Bilya staff1', 'Credit', '177514416542', '210000', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '690000', 'N/A', '0', '0', '0', '2026-04-02 14:36:05', '2026-04-02 14:36:06', 'pending', '0000-00-00 00:00:00', 0),
(83, 'DANSARKI/001', '6', 17, 'TIMBUKTU', '390000', '1', '390000', 'N/A', 'Bilya staff1', 'Credit', '177514416542', '210000', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '180000', 'N/A', '0', '0', '0', '2026-04-02 14:36:05', '2026-04-02 14:36:06', 'pending', '0000-00-00 00:00:00', 0),
(84, 'DANSARKI/001', '6', 14, 'Mr MURACCA', '450000', '2', '900000', 'N/A', 'Bilya staff1', 'Credit', '177514416542', '210000', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '690000', 'N/A', '0', '0', '0', '2026-04-02 14:36:05', '2026-04-02 14:36:06', 'pending', '0000-00-00 00:00:00', 0),
(88, 'DANSARKI/001', '6', 8, 'G-CELSIO', '370000', '1', '370000', 'N/A', 'Bilya staff1', 'Credit', '177514498636', '150000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '220000', 'N/A', '0', '0', '0', '2026-04-02 14:49:46', '2026-04-02 14:49:46', 'pending', '0000-00-00 00:00:00', 0),
(89, 'DANSARKI/001', '6', 13, 'GK PLAIN 200y', '400000', '2', '800000', 'N/A', 'Bilya staff1', 'Credit', '177514498636', '150000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '650000', 'N/A', '0', '0', '0', '2026-04-02 14:49:46', '2026-04-02 14:49:46', 'pending', '0000-00-00 00:00:00', 0),
(90, 'DANSARKI/001', '6', 14, 'Mr MURACCA', '450000', '2', '900000', 'N/A', 'Bilya staff1', 'Credit', '177514498636', '150000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '750000', 'N/A', '0', '0', '0', '2026-04-02 14:49:46', '2026-04-02 14:49:46', 'pending', '0000-00-00 00:00:00', 0),
(91, 'DANSARKI/001', '6', 17, 'TIMBUKTU', '390000', '1', '390000', 'N/A', 'Bilya staff1', 'Credit', '177514498636', '150000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '240000', 'N/A', '0', '0', '0', '2026-04-02 14:49:46', '2026-04-02 14:49:46', 'pending', '0000-00-00 00:00:00', 0),
(92, 'DANSARKI/001', '4', 2, 'SILVER CROWN', '600000', '1', '600000', 'N/A', 'Alh Yasir', 'Split Payment', '177522359027', '30000', 1, 0, 'N/A', 'Mukthar hamza', '570000', '0.00', '570000', 'zenith bank', '0', '0', '570000', '2026-04-03 12:39:50', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(93, 'DANSARKI/001', '6', 8, 'G-CELSIO', '370000', '1', '370000', 'N/A', 'Bilya staff1', 'Split Payment', '40042', '20000', 1, 0, 'N/A', 'HAMZA', '350000', '0.00', '350000', 'N/A', '0', '350000', '0', '2026-04-03 15:54:53', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(94, 'DANSARKI/001', '4', 28, 'MARADONA Astere', '420000', '2', '840000', 'N/A', 'Alh Yasir', 'Credit', '177529544090', '20000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '820000', 'N/A', '0', '0', '0', '2026-04-04 08:37:20', '2026-04-04 08:37:20', 'pending', '0000-00-00 00:00:00', 0),
(95, 'DANSARKI/001', '4', 28, 'MARADONA Astere', '420000', '4', '1680000', 'N/A', 'Alh Yasir', 'Credit', '177529568491', '56000', 1, 5, 'AYACO TEX.', 'N/A', '0', '0', '1624000', 'N/A', '0', '0', '0', '2026-04-04 08:41:24', '2026-04-04 08:41:24', 'pending', '0000-00-00 00:00:00', 0),
(96, 'DANSARKI/001', '4', 28, 'MARADONA Astere', '420000', '2', '840000', 'N/A', 'Alh Yasir', 'Credit', '177529650436', '1550', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '838450', 'N/A', '0', '0', '0', '2026-04-04 08:55:04', '2026-04-04 08:55:04', 'pending', '0000-00-00 00:00:00', 0),
(97, 'DANSARKI/001', '4', 28, 'MARADONA Astere', '420000', '2', '840000', 'N/A', 'Alh Yasir', 'Credit', '177529663929', '9750', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '830250', 'N/A', '0', '0', '0', '2026-04-04 08:57:19', '2026-04-04 08:57:19', 'pending', '0000-00-00 00:00:00', 0),
(98, 'DANSARKI/001', '6', 16, 'GENTLEMAN B#', '450000', '1', '450000', 'N/A', 'Bilya staff1', 'Credit', '177539180043', '35000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '415000', 'N/A', '0', '0', '0', '2026-04-05 11:23:20', '2026-04-05 11:23:20', 'pending', '0000-00-00 00:00:00', 0),
(99, 'DANSARKI/001', '6', 16, 'GENTLEMAN B#', '450000', '1', '450000', 'N/A', 'Bilya staff1', 'Credit', '177539188735', '35000', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '415000', 'N/A', '0', '0', '0', '2026-04-05 11:24:47', '2026-04-05 11:24:47', 'pending', '0000-00-00 00:00:00', 0),
(100, 'DANSARKI/001', '6', 16, 'GENTLEMAN B#', '450000', '1', '450000', 'N/A', 'Bilya staff1', 'Credit', '177539199826', '35000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '415000', 'N/A', '0', '0', '0', '2026-04-05 11:26:38', '2026-04-05 11:26:38', 'pending', '0000-00-00 00:00:00', 0),
(101, 'DANSARKI/001', '4', 8, 'G-CELSIO', '370000', '1', '370000', 'N/A', 'Alh Yasir', 'Split Payment', '177548577885', '25000', 1, 0, 'N/A', 'mudassir', '345000', '0.00', '345000', 'N/A', '0', '345000', '0', '2026-04-06 13:29:38', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(102, 'DANSARKI/001', '4', 30, 'VIP VOCTORY shadda 300y', '2120000', '1', '2120000', 'N/A', 'Alh Yasir', 'Credit', '177549121545', '30000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '2090000', 'N/A', '0', '0', '0', '2026-04-06 15:00:15', '2026-04-06 15:00:15', 'pending', '0000-00-00 00:00:00', 0),
(103, 'DANSARKI/001', '4', 31, 'VIDA 300m', '2120000', '1', '2120000', 'N/A', 'Alh Yasir', 'Credit', '177549135099', '30000', 1, 3, 'DANSARKI G-Jallaba 6a.7a', 'N/A', '0', '0', '2090000', 'N/A', '0', '0', '0', '2026-04-06 15:02:30', '2026-04-06 15:02:30', 'pending', '0000-00-00 00:00:00', 0),
(104, 'DANSARKI/001', '4', 32, 'Special Extention all white 300m', '1150000', '1', '1150000', 'N/A', 'Alh Yasir', 'Credit', '177549271224', '0', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '1150000', 'N/A', '0', '0', '0', '2026-04-06 15:25:12', '2026-04-06 15:25:12', 'pending', '0000-00-00 00:00:00', 0),
(105, 'DANSARKI/001', '4', 32, 'Special Extention all white 300m', '1150000', '1', '1150000', 'N/A', 'Alh Yasir', 'Credit', '177549298480', '0', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1150000', 'N/A', '0', '0', '0', '2026-04-06 15:29:44', '2026-04-06 15:29:44', 'pending', '0000-00-00 00:00:00', 0),
(106, 'DANSARKI/001', '6', 12, 'YJ 4#', '255000', '1', '255000', 'N/A', 'Bilya staff1', 'Split Payment', '65238', '15000', 1, 0, 'N/A', 'ALIYU Yallow', '240000', '0.00', '240000', 'N/A', '0', '0', '240000', '2026-04-07 11:29:01', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(107, 'DANSARKI/001', '4', 33, 'CONGRESS P-AD 300m', '1470000', '1', '1470000', 'N/A', 'Alh Yasir', 'Credit', '177583534882', '65000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '1405000', 'N/A', '0', '0', '0', '2026-04-10 14:35:48', '2026-04-10 14:35:48', 'pending', '0000-00-00 00:00:00', 0),
(108, 'DANSARKI/001', '4', 35, '7star U&ME', '320000', '4', '1280000', 'N/A', 'Alh Yasir', 'Credit', '177583534882', '65000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '1215000', 'N/A', '0', '0', '0', '2026-04-10 14:35:48', '2026-04-10 14:35:48', 'pending', '0000-00-00 00:00:00', 0),
(109, 'DANSARKI/001', '4', 34, 'SILVER SEA florence', '380000', '1', '380000', 'N/A', 'Alh Yasir', 'Credit', '177583534882', '65000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '315000', 'N/A', '0', '0', '0', '2026-04-10 14:35:48', '2026-04-10 14:35:48', 'pending', '0000-00-00 00:00:00', 0),
(110, 'DANSARKI/001', '4', 35, '7star U&ME', '320000', '4', '1280000', 'N/A', 'Alh Yasir', 'Credit', '177583984818', '65000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1215000', 'N/A', '0', '0', '0', '2026-04-10 15:50:48', '2026-04-10 15:50:48', 'pending', '0000-00-00 00:00:00', 0),
(111, 'DANSARKI/001', '4', 33, 'CONGRESS P-AD 300m', '1470000', '1', '1470000', 'N/A', 'Alh Yasir', 'Credit', '177583984818', '65000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1405000', 'N/A', '0', '0', '0', '2026-04-10 15:50:48', '2026-04-10 15:50:48', 'pending', '0000-00-00 00:00:00', 0),
(112, 'DANSARKI/001', '4', 34, 'SILVER SEA florence', '380000', '1', '380000', 'N/A', 'Alh Yasir', 'Credit', '177583984818', '65000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '315000', 'N/A', '0', '0', '0', '2026-04-10 15:50:48', '2026-04-10 15:50:48', 'pending', '0000-00-00 00:00:00', 0),
(113, 'DANSARKI/001', '6', 35, '7star U&ME', '320000', '4', '1280000', 'N/A', 'Bilya staff1', 'Credit', '177590357240', '50000', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '1230000', 'N/A', '0', '0', '0', '2026-04-11 09:32:52', '2026-04-11 09:32:52', 'pending', '0000-00-00 00:00:00', 0),
(114, 'DANSARKI/001', '6', 34, 'SILVER SEA florence', '380000', '1', '380000', 'N/A', 'Bilya staff1', 'Credit', '177590357240', '50000', 1, 2, 'DANSARKI A64 G-baba', 'N/A', '0', '0', '330000', 'N/A', '0', '0', '0', '2026-04-11 09:32:52', '2026-04-11 09:32:52', 'pending', '0000-00-00 00:00:00', 0),
(116, 'DANSARKI/001', '6', 38, 'Phanta 300m', '1320000', '1', '1320000', 'N/A', 'Bilya staff1', 'Split Payment', '89115', '5000', 1, 0, 'N/A', 'Dahiru', '1315000', '0.00', '1315000', 'N/A', '0', '1315000', '0', '2026-04-11 13:54:03', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(117, 'DANSARKI/001', '6', 37, 'Micro Inso 300m', '1470000', '1', '1470000', 'N/A', 'Bilya staff1', 'Split Payment', '50629', '0', 1, 0, 'N/A', 'Hamisu', '1470000', '0.00', '1470000', 'N/A', '0', '0', '1470000', '2026-04-12 11:41:07', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(118, 'DANSARKI/001', '4', 35, '7star U&ME', '320000', '1', '320000', 'N/A', 'Alh Yasir', 'Credit', '177601009510', '5000', 1, 7, 'HAMZA Shop', 'N/A', '0', '0', '315000', 'N/A', '0', '0', '0', '2026-04-12 15:08:15', '2026-04-12 15:08:15', 'pending', '0000-00-00 00:00:00', 0),
(119, 'DANSARKI/001', '4', 37, 'Micro Inso 300m', '1470000', '1', '1470000', 'N/A', 'Alh Yasir', 'Credit', '177601069378', '0', 1, 13, 'ALAMIN R. kings', 'N/A', '0', '0', '1470000', 'N/A', '0', '0', '0', '2026-04-12 15:18:13', '2026-04-12 15:18:13', 'pending', '0000-00-00 00:00:00', 0),
(120, 'DANSARKI/001', '4', 36, 'Ambassadola 300m', '1470000', '1', '1470000', 'N/A', 'Alh Yasir', 'Credit', '177601081564', '10000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1460000', 'N/A', '0', '0', '0', '2026-04-12 15:20:15', '2026-04-12 15:20:15', 'pending', '0000-00-00 00:00:00', 0),
(121, 'DANSARKI/001', '4', 36, 'Ambassadola 300m', '1470000', '1', '1470000', 'N/A', 'Alh Yasir', 'Credit', '177601090079', '10000', 1, 4, 'H.J Textile A7', 'N/A', '0', '0', '1460000', 'N/A', '0', '0', '0', '2026-04-12 15:21:40', '2026-04-12 15:21:40', 'pending', '0000-00-00 00:00:00', 0),
(122, 'DANSARKI/001', '4', 41, 'Regency TR PRIDE 174y', '1113600', '1', '1113600', 'N/A', 'Alh Yasir', 'Credit', '177607568912', '177800', 1, 14, 'USSY ZARA', 'N/A', '0', '0', '935800', 'N/A', '0', '0', '0', '2026-04-13 09:21:29', '2026-04-13 09:21:29', 'pending', '0000-00-00 00:00:00', 0),
(123, 'DANSARKI/001', '4', 47, 'Regency TR PRIDE 195y', '1248000', '1', '1248000', 'N/A', 'Alh Yasir', 'Credit', '177607568912', '177800', 1, 14, 'USSY ZARA', 'N/A', '0', '0', '1070200', 'N/A', '0', '0', '0', '2026-04-13 09:21:29', '2026-04-13 09:21:29', 'pending', '0000-00-00 00:00:00', 0),
(124, 'DANSARKI/001', '4', 1, 'LAS VEGAS', '450000', '2', '900000', 'N/A', 'Alh Yasir', 'Credit', '177607568912', '177800', 1, 14, 'USSY ZARA', 'N/A', '0', '0', '722200', 'N/A', '0', '0', '0', '2026-04-13 09:21:29', '2026-04-13 09:21:29', 'pending', '0000-00-00 00:00:00', 0),
(125, 'DANSARKI/001', '4', 13, 'GK PLAIN 200y', '400000', '1', '400000', 'N/A', 'Alh Yasir', 'Credit', '177607568912', '177800', 1, 14, 'USSY ZARA', 'N/A', '0', '0', '222200', 'N/A', '0', '0', '0', '2026-04-13 09:21:29', '2026-04-13 09:21:29', 'pending', '0000-00-00 00:00:00', 0),
(126, 'DANSARKI/001', '4', 28, 'MARADONA Astere', '420000', '1', '420000', 'N/A', 'Alh Yasir', 'Credit', '177607568912', '177800', 1, 14, 'USSY ZARA', 'N/A', '0', '0', '242200', 'N/A', '0', '0', '0', '2026-04-13 09:21:29', '2026-04-13 09:21:29', 'pending', '0000-00-00 00:00:00', 0),
(127, 'DANSARKI/001', '4', 26, 'swiss Okutex AD', '1120000', '1', '1120000', 'N/A', 'Alh Yasir', 'Credit', '177607568912', '177800', 1, 14, 'USSY ZARA', 'N/A', '0', '0', '942200', 'N/A', '0', '0', '0', '2026-04-13 09:21:29', '2026-04-13 09:21:29', 'pending', '0000-00-00 00:00:00', 0),
(129, 'DANSARKI/001', '4', 3, 'WATCHMAN', '200000', '1', '200000', 'N/A', 'Alh Yasir', 'Split Payment', '177607826374', '100000', 1, 0, 'N/A', 'khalifa YOLA', '1350000', '0.00', '100000', 'zenith bank', '0', '0', '1350000', '2026-04-13 10:04:23', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(130, 'DANSARKI/001', '4', 4, 'MR FENDY', '200000', '1', '200000', 'N/A', 'Alh Yasir', 'Split Payment', '177607826374', '100000', 1, 0, 'N/A', 'khalifa YOLA', '1350000', '0.00', '100000', 'zenith bank', '0', '0', '1350000', '2026-04-13 10:04:23', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(131, 'DANSARKI/001', '4', 1, 'LAS VEGAS', '450000', '1', '450000', 'N/A', 'Alh Yasir', 'Split Payment', '177607826374', '100000', 1, 0, 'N/A', 'khalifa YOLA', '1350000', '0.00', '350000', 'zenith bank', '0', '0', '1350000', '2026-04-13 10:04:23', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(132, 'DANSARKI/001', '4', 2, 'SILVER CROWN', '600000', '1', '600000', 'N/A', 'Alh Yasir', 'Split Payment', '177607826374', '100000', 1, 0, 'N/A', 'khalifa YOLA', '1350000', '0.00', '500000', 'zenith bank', '0', '0', '1350000', '2026-04-13 10:04:23', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00', 0),
(136, 'DANSARKI/001', '4', 33, 'CONGRESS P-AD 300y', '1470000', '1', '1470000', 'N/A', 'Alh Yasir', 'Credit', '177607923295', '0', 1, 15, 'Soja babban wa', 'N/A', '0', '0', '1470000', 'N/A', '0', '0', '0', '2026-04-13 10:20:32', '2026-04-13 10:20:32', 'pending', '0000-00-00 00:00:00', 0),
(137, 'DANSARKI/001', '4', 28, 'MARADONA Astere', '420000', '2', '840000', 'N/A', 'Alh Yasir', 'Credit', '177607961617', '185000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '655000', 'N/A', '0', '0', '0', '2026-04-13 10:26:56', '2026-04-13 10:26:56', 'pending', '0000-00-00 00:00:00', 0),
(138, 'DANSARKI/001', '4', 2, 'SILVER CROWN', '600000', '1', '600000', 'N/A', 'Alh Yasir', 'Credit', '177607961617', '185000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '415000', 'N/A', '0', '0', '0', '2026-04-13 10:26:56', '2026-04-13 10:26:56', 'pending', '0000-00-00 00:00:00', 0),
(139, 'DANSARKI/001', '4', 13, 'GK PLAIN 200y', '400000', '1', '400000', 'N/A', 'Alh Yasir', 'Credit', '177607961617', '185000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '215000', 'N/A', '0', '0', '0', '2026-04-13 10:26:56', '2026-04-13 10:26:56', 'pending', '0000-00-00 00:00:00', 0),
(140, 'DANSARKI/001', '4', 8, 'G-CELSIO', '370000', '1', '370000', 'N/A', 'Alh Yasir', 'Credit', '177607961617', '185000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '185000', 'N/A', '0', '0', '0', '2026-04-13 10:26:56', '2026-04-13 10:26:56', 'pending', '0000-00-00 00:00:00', 0),
(141, 'DANSARKI/001', '4', 10, 'CASSADA AMZ', '370000', '1', '370000', 'N/A', 'Alh Yasir', 'Credit', '177607961617', '185000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '185000', 'N/A', '0', '0', '0', '2026-04-13 10:26:56', '2026-04-13 10:26:56', 'pending', '0000-00-00 00:00:00', 0),
(142, 'DANSARKI/001', '4', 29, 'GOLF 12000 mhood', '450000', '3', '1350000', 'N/A', 'Alh Yasir', 'Credit', '177607961617', '185000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1165000', 'N/A', '0', '0', '0', '2026-04-13 10:26:56', '2026-04-13 10:26:56', 'pending', '0000-00-00 00:00:00', 0),
(144, 'DANSARKI/001', '4', 38, 'Phanta 300m', '1320000', '1', '1320000', 'N/A', 'Alh Yasir', 'Credit', '177609776659', '10000', 1, 1, 'DANSARKI BIG mur', 'N/A', '0', '0', '1310000', 'N/A', '0', '0', '0', '2026-04-13 15:29:26', '2026-04-13 15:29:27', 'pending', '0000-00-00 00:00:00', 0),
(155, 'DANSARKI/001', '4', 60, 'Testing', '1000', '30', '30000', '50.00', 'Alh Yasir', 'Credit', '177651595270', '0', 1, 1, 'DANSARKI BIG mur', NULL, '0', '0', '28500', NULL, '0', '0', '0', '2026-04-18 12:39:12', '2026-04-18 12:39:12', 'pending', NULL, 0),
(157, 'DANSARKI/001', '4', 1, 'LAS VEGAS', '450000', '1', '450000', '5000.00', 'Alh Yasir', 'Credit', '177744498746', '5000', 1, 7, 'HAMZA Shop', NULL, '0', '0', '445000', NULL, '0', '0', '0', '2026-04-29 06:43:07', '2026-04-29 06:43:07', 'pending', NULL, 0),
(158, 'DANSARKI/001', '6', 13, 'GK PLAIN 200y', '400000', '2', '800000', '20000.00', 'Bilya staff1', 'Credit', '177769725433', '0', 1, 7, 'HAMZA Shop', NULL, '0', '0', '760000', NULL, '0', '0', '0', '2026-05-02 04:47:34', '2026-05-02 04:47:34', 'pending', NULL, 0),
(159, 'DANSARKI/001', '4', 51, 'Sonet PRIDE 100y', '650000', '2', '1300000', '50000.00', 'Alh Yasir', 'Credit', '177769776963', '0', 1, 6, 'BASH YENZI', NULL, '0', '0', '1200000', NULL, '0', '0', '0', '2026-05-02 04:56:09', '2026-05-02 04:56:09', 'pending', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `orderID` varchar(255) NOT NULL,
  `stockID` int(11) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `outstand`
--

CREATE TABLE `outstand` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `customerID` varchar(200) DEFAULT NULL,
  `staffID` varchar(200) NOT NULL,
  `Customer` varchar(200) NOT NULL,
  `staff` varchar(200) NOT NULL,
  `amount` varchar(200) NOT NULL,
  `balance` varchar(200) NOT NULL,
  `creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `updation` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `outstand`
--

INSERT INTO `outstand` (`id`, `facilityID`, `customerID`, `staffID`, `Customer`, `staff`, `amount`, `balance`, `creation`, `updation`) VALUES
(1, 'DANSARKI/001', '1', '6', 'DANSARKI BIG mur', 'Bilya staff1', '14981750', '13633000', '2026-03-26 15:14:07', '2026-05-02 10:18:11'),
(2, 'DANSARKI/001', '7', '6', 'HAMZA Shop', 'Bilya staff1', '730200', '1204800', '2026-03-28 16:28:12', '2026-05-02 04:47:34'),
(3, 'DANSARKI/001', '6', '6', 'BASH YENZI', 'Bilya staff1', '1660000', '0', '2026-03-28 16:30:08', '2026-05-02 05:12:38'),
(4, 'DANSARKI/001', '3', '4', 'DANSARKI G-Jallaba 6a.7a', 'Alh Yasir', '2850000', '3310000', '2026-03-29 10:28:02', '2026-04-12 15:33:41'),
(5, 'DANSARKI/001', '9', '4', 'Goma 10', 'Alh Yasir', '0', '630000', '2026-03-29 11:46:10', '0000-00-00 00:00:00'),
(6, 'DANSARKI/001', '10', '4', 'ISHAKA BUNGEL', 'Alh Yasir', '200000', '520000', '2026-03-29 14:27:17', '2026-04-10 11:09:12'),
(7, 'DANSARKI/001', '5', '4', 'AYACO TEX.', 'Alh Yasir', '1500000', '4655600', '2026-03-30 16:05:45', '2026-04-08 14:57:46'),
(8, 'DANSARKI/001', '4', '4', 'H.J Textile A7', 'Alh Yasir', '7100000', '2321750', '2026-03-31 11:53:50', '2026-04-12 15:21:40'),
(9, 'DANSARKI/001', '2', '4', 'DANSARKI A64 G-baba', 'Alh Yasir', '4715000', '1418450', '2026-03-31 12:14:09', '2026-04-13 16:09:40'),
(10, 'DANSARKI/001', '8', '4', 'AUWAL DUBAI apex', 'Alh Yasir', '250000', '250000', '2026-03-31 14:21:47', '2026-04-10 14:28:09'),
(11, 'DANSARKI/001', '11', '4', 'MAIBARGO ABBA', 'Alh Yasir', '200000', '135000', '2026-04-01 14:56:30', '2026-04-11 13:02:03'),
(12, 'DANSARKI/001', '12', '4', 'ALIYU BASAKKWACHE', 'Alh Yasir', '225000', '190000', '2026-04-01 15:06:44', '0000-00-00 00:00:00'),
(13, 'DANSARKI/001', '13', '4', 'ALAMIN R. kings', 'Alh Yasir', '0', '1470000', '2026-04-12 15:18:13', '2026-04-14 09:54:18'),
(14, 'DANSARKI/001', '14', '4', 'USSY ZARA', 'Alh Yasir', '0', '5023800', '2026-04-13 09:21:29', '0000-00-00 00:00:00'),
(15, 'DANSARKI/001', '15', '4', 'Soja babban wa', 'Alh Yasir', '0', '1470000', '2026-04-13 10:20:32', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_deposit_history`
--

CREATE TABLE `purchase_deposit_history` (
  `id` int(11) NOT NULL,
  `purchaseID` int(11) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `previous_balance` decimal(15,2) NOT NULL,
  `new_balance` decimal(15,2) NOT NULL,
  `processed_by` varchar(100) DEFAULT NULL,
  `deposit_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_history`
--

CREATE TABLE `purchase_history` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) DEFAULT NULL,
  `stock_id` int(11) DEFAULT NULL,
  `initial_quantity` int(11) DEFAULT 0,
  `purchaser` varchar(255) DEFAULT NULL,
  `purchase_from` varchar(255) DEFAULT NULL,
  `stock_name` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `cost_price` decimal(10,2) DEFAULT NULL,
  `total_cost` decimal(10,2) DEFAULT NULL,
  `amount_paid` decimal(15,2) DEFAULT 0.00,
  `balance` decimal(15,2) DEFAULT 0.00,
  `for_desc` varchar(255) DEFAULT '',
  `purchase_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_history`
--

INSERT INTO `purchase_history` (`id`, `facilityID`, `stock_id`, `initial_quantity`, `purchaser`, `purchase_from`, `stock_name`, `quantity`, `cost_price`, `total_cost`, `amount_paid`, `balance`, `for_desc`, `purchase_date`) VALUES
(1, '0', 0, 0, 'N/A', 'U&ME', 'LAS VEGAS', 19, 401000.00, 7619000.00, 0.00, 7619000.00, '', '2026-03-26 14:07:40'),
(2, '0', 0, 0, 'N/A', 'Goma', 'SILVER CROWN', 9, 560000.00, 5040000.00, 0.00, 5040000.00, '', '2026-03-26 14:11:10'),
(3, '0', 0, 0, 'N/A', 'Bash Yenzi', 'WATCHMAN', 19, 190000.00, 3610000.00, 0.00, 3610000.00, '', '2026-03-26 14:14:20'),
(4, '0', 0, 0, 'N/A', 'Bash Yenzi', 'MR FENDY', 3, 190000.00, 570000.00, 0.00, 570000.00, '', '2026-03-26 14:16:03'),
(5, '0', 0, 0, 'N/A', 'Bash Yenzi', 'STARLIGHT', 1, 190000.00, 190000.00, 0.00, 190000.00, '', '2026-03-26 14:16:50'),
(6, '0', 0, 0, 'N/A', 'Goma', 'PORTMANN AMZ PLAIN', 9, 640000.00, 5760000.00, 0.00, 5760000.00, '', '2026-03-26 14:18:25'),
(7, '0', 0, 0, 'N/A', 'Jabeer yards', 'Gold Luxury', 5, 395000.00, 1975000.00, 0.00, 1975000.00, '', '2026-03-26 14:24:09'),
(8, '0', 0, 0, 'N/A', 'Jabeer yards', 'G-CELSIO', 10, 330000.00, 3300000.00, 0.00, 3300000.00, '', '2026-03-26 14:26:01'),
(9, '0', 0, 0, 'N/A', 'Goma', 'THE ONE AMZ', 3, 350000.00, 1050000.00, 0.00, 1050000.00, '', '2026-03-26 14:27:23'),
(10, '0', 0, 0, 'N/A', 'Goma', 'CASSADA AMZ', 1, 350000.00, 350000.00, 0.00, 350000.00, '', '2026-03-26 14:29:57'),
(11, '0', 0, 0, 'N/A', 'Goma', 'PHANTOM noble wool', 3, 780000.00, 2340000.00, 0.00, 2340000.00, '', '2026-03-26 16:24:11'),
(12, '0', 0, 0, 'N/A', 'Bash Yenzi', 'YJ 4#', 35, 220000.00, 7700000.00, 0.00, 7700000.00, '', '2026-03-28 17:18:49'),
(13, '0', 0, 0, 'N/A', 'Jamilü unity', 'GK PLAIN 200y', 20, 390000.00, 7800000.00, 0.00, 7800000.00, '', '2026-03-28 17:21:30'),
(14, '0', 0, 0, 'N/A', 'Jamilü unity', 'Mr MURACCA', 10, 420000.00, 4200000.00, 0.00, 4200000.00, '', '2026-03-28 17:29:39'),
(15, '0', 0, 0, 'N/A', 'Jamilü unity', 'GENTLEMAN A#', 5, 450000.00, 2250000.00, 0.00, 2250000.00, '', '2026-03-28 17:31:14'),
(16, '0', 0, 0, 'N/A', 'Jamilü unity', 'GENTLEMAN B#', 5, 420000.00, 2100000.00, 0.00, 2100000.00, '', '2026-03-28 17:33:24'),
(17, '0', 0, 0, 'N/A', 'Jamilü unity', 'TIMBUKTU', 5, 360000.00, 1800000.00, 0.00, 1800000.00, '', '2026-03-28 17:35:37'),
(18, '0', 0, 0, 'N/A', 'Jamilü unity', 'JU WOOL A florence', 5, 450000.00, 2250000.00, 0.00, 2250000.00, '', '2026-03-28 17:38:11'),
(19, '0', 0, 0, 'N/A', 'Goma', 'FASHION GOLD', 1, 1125000.00, 1125000.00, 0.00, 1125000.00, '', '2026-03-28 17:42:21'),
(20, '0', 0, 0, 'N/A', 'Goma', 'AUSTRAILIAN WIFI', 1, 2010000.00, 2010000.00, 0.00, 2010000.00, '', '2026-03-28 17:44:37'),
(21, '0', 0, 0, 'N/A', 'Goma', 'VIP ILLUSION AD', 1, 1325000.00, 1325000.00, 0.00, 1325000.00, '', '2026-03-28 17:45:53'),
(22, '0', 0, 0, 'N/A', 'Goma', 'PROFESSOR AD', 1, 1285000.00, 1285000.00, 0.00, 1285000.00, '', '2026-03-28 17:47:17'),
(23, '0', 0, 0, 'N/A', 'Goma', 'WISE MAN AD', 1, 1285000.00, 1285000.00, 0.00, 1285000.00, '', '2026-03-28 17:49:54'),
(24, '0', 0, 0, 'N/A', 'Goma', 'SILK ROAD AD', 1, 1285000.00, 1285000.00, 0.00, 1285000.00, '', '2026-03-28 17:51:52'),
(25, '0', 0, 0, 'N/A', 'Goma', 'OCEAN BLUE blsk', 1, 1275000.00, 1275000.00, 0.00, 1275000.00, '', '2026-03-28 17:53:18'),
(26, '0', 0, 0, 'N/A', 'Abdulgee tex', 'swiss Okutex AD', 2, 1100000.00, 2200000.00, 0.00, 2200000.00, '', '2026-03-29 15:25:24'),
(27, '0', 0, 0, 'N/A', 'hamza Ali blocking', 'SOFT COTTON shadda', 1, 1580000.00, 1580000.00, 0.00, 1580000.00, '', '2026-03-29 15:29:34'),
(28, '0', 0, 0, 'N/A', 'Hayatu', 'MARADONA Astere', 10, 406000.00, 4060000.00, 0.00, 4060000.00, '', '2026-04-03 12:16:57'),
(29, '0', 0, 0, 'N/A', 'Hayatu', 'MARADONA Astere', 20, 406000.00, 8120000.00, 0.00, 8120000.00, '', '2026-04-04 17:12:44'),
(30, '0', 0, 0, 'N/A', 'Abba AGYL', 'GOLF 12000 mhood', 15, 425000.00, 6375000.00, 0.00, 6375000.00, '', '2026-04-06 15:33:30'),
(31, '0', 0, 0, 'N/A', 'hamza Ali blocking', 'VIP VOCTORY shadda 300y', 1, 2080000.00, 2080000.00, 0.00, 2080000.00, '', '2026-04-06 16:56:55'),
(32, '0', 0, 0, 'N/A', 'hamza Ali blocking', 'VIDA 300m', 1, 2080000.00, 2080000.00, 0.00, 2080000.00, '', '2026-04-06 16:59:17'),
(33, '0', 0, 0, 'N/A', 'Goma', 'Special Extention all white 300m', 3, 1125000.00, 3375000.00, 0.00, 3375000.00, '', '2026-04-06 17:24:11'),
(34, '0', 0, 0, 'N/A', 'hamza Ali blocking', 'CONGRESS P-AD 300m', 3, 1455000.00, 4365000.00, 0.00, 4365000.00, '', '2026-04-08 16:53:22'),
(35, '0', 0, 0, 'N/A', 'U&ME', 'SILVER SEA florence', 5, 365000.00, 1825000.00, 0.00, 1825000.00, '', '2026-04-08 16:54:23'),
(36, '0', 0, 0, 'N/A', 'Goma', 'SILVER CROWN', 3, 560000.00, 1680000.00, 0.00, 1680000.00, '', '2026-04-08 16:55:03'),
(37, '0', 0, 0, 'N/A', 'U&ME', '7star U&ME', 20, 306000.00, 6120000.00, 0.00, 6120000.00, '', '2026-04-10 13:16:59'),
(38, '0', 0, 0, 'N/A', 'Goma', 'Ambassadola 300m', 2, 1455000.00, 2910000.00, 0.00, 2910000.00, '', '2026-04-11 15:05:36'),
(39, '0', 0, 0, 'N/A', 'Goma', 'Micro Inso 300m', 2, 1455000.00, 2910000.00, 0.00, 2910000.00, '', '2026-04-11 15:06:55'),
(40, '0', 0, 0, 'N/A', 'Goma', 'Phanta 300m', 2, 1305000.00, 2610000.00, 0.00, 2610000.00, '', '2026-04-11 15:08:33'),
(41, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Fasino Check PRIDE 141y', 1, 874200.00, 874200.00, 0.00, 874200.00, '', '2026-04-13 10:52:35'),
(42, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Regency TR PRIDE 178y', 1, 1103600.00, 1103600.00, 0.00, 1103600.00, '', '2026-04-13 10:59:32'),
(43, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Regency TR PRIDE 174y', 1, 1078800.00, 1078800.00, 0.00, 1078800.00, '', '2026-04-13 11:00:53'),
(44, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'TR GOLD PRIDE 196y', 1, 1293600.00, 1293600.00, 0.00, 1293600.00, '', '2026-04-13 11:02:46'),
(45, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Vayana 02 PRIDE 155y', 1, 961000.00, 961000.00, 0.00, 961000.00, '', '2026-04-13 11:04:18'),
(46, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Fasino Check PRIDE 154y', 1, 954800.00, 954800.00, 0.00, 954800.00, '', '2026-04-13 11:05:40'),
(47, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'TR GOLD PRIDE 204y', 1, 1346400.00, 1346400.00, 0.00, 1346400.00, '', '2026-04-13 11:07:34'),
(48, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Regency TR PRIDE 198y', 1, 1227600.00, 1227600.00, 0.00, 1227600.00, '', '2026-04-13 11:08:49'),
(49, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Regency TR PRIDE 195y', 1, 1209000.00, 1209000.00, 0.00, 1209000.00, '', '2026-04-13 11:10:08'),
(50, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Vayana 02 PRIDE 146y', 1, 905200.00, 905200.00, 0.00, 905200.00, '', '2026-04-13 11:13:59'),
(51, '0', 0, 0, 'N/A', 'U&ME', 'LAS VEGAS', 10, 401000.00, 4010000.00, 0.00, 4010000.00, '', '2026-04-13 16:43:29'),
(52, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Regency TR PRIDE 199y', 1, 1233800.00, 1233800.00, 0.00, 1233800.00, '', '2026-04-13 17:09:14'),
(53, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Lycra Tanish PRIDE 150y', 2, 930000.00, 1860000.00, 0.00, 1860000.00, '', '2026-04-13 17:13:50'),
(54, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Sonet PRIDE 100y', 3, 620000.00, 1860000.00, 0.00, 1860000.00, '', '2026-04-13 17:16:01'),
(55, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Sonet PRIDE 98y', 1, 607600.00, 607600.00, 0.00, 607600.00, '', '2026-04-13 17:17:30'),
(56, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Leebay PRIDE 100y', 2, 620000.00, 1240000.00, 0.00, 1240000.00, '', '2026-04-13 17:18:42'),
(57, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Regency TR PRIDE 200y', 1, 1240000.00, 1240000.00, 0.00, 1240000.00, '', '2026-04-13 17:19:48'),
(58, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Ethnic PRIDE 150y', 1, 930000.00, 930000.00, 0.00, 930000.00, '', '2026-04-13 17:21:04'),
(59, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Ethnic PRIDE 186y', 1, 1153200.00, 1153200.00, 0.00, 1153200.00, '', '2026-04-13 17:22:17'),
(60, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Turkish TR PRIDE 71y', 1, 440200.00, 440200.00, 0.00, 440200.00, '', '2026-04-13 17:24:57'),
(61, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Dedication PRIDE 120y', 1, 744000.00, 744000.00, 0.00, 744000.00, '', '2026-04-13 17:26:33'),
(62, '0', 0, 0, 'N/A', 'Faruk PRIDE', 'Dedication PRIDE 129y', 1, 799800.00, 799800.00, 0.00, 799800.00, '', '2026-04-13 17:27:25'),
(63, 'DANSARKI/001', 60, 0, NULL, NULL, 'Testing', 100, 0.00, 0.00, 0.00, 0.00, '', '2026-04-18 00:00:00'),
(64, 'DANSARKI/001', 1, 11, NULL, 'Yakubu', 'LAS VEGAS', 10, 401000.00, 4010000.00, 10000.00, 4000000.00, 'FARKO', '2026-04-18 00:00:00'),
(65, 'DANSARKI/001', 1, 20, NULL, 'SHEHU', 'LAS VEGAS', 10, 401000.00, 4010000.00, 0.00, 4010000.00, 'FARKO', '2026-05-05 00:00:00'),
(66, 'DANSARKI/001', 61, 0, NULL, NULL, 'Testing', 10, 0.00, 0.00, 0.00, 0.00, '', '2026-05-05 00:00:00'),
(67, 'DANSARKI/001', 62, 0, NULL, NULL, 'Testing2', 10, 0.00, 0.00, 0.00, 0.00, '', '2026-05-05 00:00:00'),
(68, 'DANSARKI/001', 63, 0, NULL, 'danlti', 'why', 10, 0.00, 0.00, 0.00, 0.00, 'going', '2026-05-06 00:00:00'),
(69, 'DANSARKI/001', 64, 0, NULL, 'Mansur', 'zaga zaga', 50, 0.00, 0.00, 0.00, 0.00, 'first', '2026-05-06 00:00:00'),
(70, 'DANSARKI/001', 1, 30, NULL, 'Yakubu', 'LAS VEGAS', 10, 401000.00, 4010000.00, 0.00, 4010000.00, 'going', '2026-05-06 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `stocks`
--

CREATE TABLE `stocks` (
  `id` int(11) NOT NULL,
  `facilityID` varchar(200) NOT NULL,
  `name` varchar(200) NOT NULL,
  `buying` varchar(200) NOT NULL,
  `selling` varchar(200) NOT NULL,
  `quantity` varchar(200) NOT NULL,
  `opening_quantity` varchar(200) DEFAULT '0',
  `closing_quantity` varchar(200) DEFAULT '0',
  `new_order` varchar(200) DEFAULT '0',
  `out_stocks` varchar(200) DEFAULT '0',
  `Bsubtotal` varchar(200) DEFAULT NULL,
  `Ssubtotal` varchar(200) DEFAULT NULL,
  `expiry` varchar(200) DEFAULT NULL,
  `creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `updation` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') DEFAULT 'pending',
  `last_sync` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`id`, `facilityID`, `name`, `buying`, `selling`, `quantity`, `opening_quantity`, `closing_quantity`, `new_order`, `out_stocks`, `Bsubtotal`, `Ssubtotal`, `expiry`, `creation`, `updation`, `sync_status`, `last_sync`) VALUES
(1, 'DANSARKI/001', 'LAS VEGAS', '401000', '450000', '40', 'N/A', 'N/A', '30', '1', '16040000', '18000000', '', '2026-03-26 12:07:40', '2026-05-06 05:40:03', 'pending', '0000-00-00 00:00:00'),
(2, 'DANSARKI/001', 'SILVER CROWN', '560000', '600000', '4', 'N/A', 'N/A', 'N/A', 'N/A', '3360000', '3600000', '', '2026-03-26 12:11:10', '2026-04-13 10:23:53', 'pending', '0000-00-00 00:00:00'),
(3, 'DANSARKI/001', 'WATCHMAN', '190000', '200000', '16', 'N/A', 'N/A', 'N/A', '0', '3610000', '3800000', '', '2026-03-26 12:14:20', '2026-04-29 05:29:45', 'pending', '0000-00-00 00:00:00'),
(4, 'DANSARKI/001', 'MR FENDY', '190000', '200000', '2', 'N/A', 'N/A', 'N/A', 'N/A', '570000', '600000', '', '2026-03-26 12:16:03', '2026-04-13 09:55:45', 'pending', '0000-00-00 00:00:00'),
(5, 'DANSARKI/001', 'STARLIGHT', '190000', '200000', '1', 'N/A', 'N/A', 'N/A', 'N/A', '190000', '200000', '', '2026-03-26 12:16:50', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(6, 'DANSARKI/001', 'PORTMANN AMZ PLAIN', '640000', '700000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '5760000', '6300000', '', '2026-03-26 12:18:25', '2026-03-30 16:00:40', 'pending', '0000-00-00 00:00:00'),
(7, 'DANSARKI/001', 'Gold Luxury', '395000', '420000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1975000', '2100000', '', '2026-03-26 12:24:09', '2026-03-30 15:56:19', 'pending', '0000-00-00 00:00:00'),
(8, 'DANSARKI/001', 'G-CELSIO', '330000', '370000', '1', 'N/A', 'N/A', 'N/A', 'N/A', '3300000', '3700000', '', '2026-03-26 12:26:01', '2026-04-13 10:24:56', 'pending', '0000-00-00 00:00:00'),
(9, 'DANSARKI/001', 'THE ONE AMZ', '350000', '380000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1050000', '1140000', '', '2026-03-26 12:27:23', '2026-03-29 10:55:24', 'pending', '0000-00-00 00:00:00'),
(10, 'DANSARKI/001', 'CASSADA AMZ', '350000', '370000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '350000', '370000', '', '2026-03-26 12:29:57', '2026-04-13 10:25:28', 'pending', '0000-00-00 00:00:00'),
(11, 'DANSARKI/001', 'PHANTOM noble wool', '780000', '820000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '2340000', '2460000', '', '2026-03-26 14:24:11', '2026-03-30 15:56:04', 'pending', '0000-00-00 00:00:00'),
(12, 'DANSARKI/001', 'YJ 4#', '220000', '255000', '22', 'N/A', 'N/A', 'N/A', 'N/A', '7700000', '8925000', '', '2026-03-28 15:18:49', '2026-04-07 11:27:23', 'pending', '0000-00-00 00:00:00'),
(13, 'DANSARKI/001', 'GK PLAIN 200y', '390000', '400000', '2', 'N/A', 'N/A', 'N/A', 'N/A', '7800000', '8000000', '', '2026-03-28 15:21:30', '2026-05-02 04:47:23', 'pending', '0000-00-00 00:00:00'),
(14, 'DANSARKI/001', 'Mr MURACCA', '420000', '450000', '3', 'N/A', 'N/A', 'N/A', 'N/A', '4200000', '4500000', '', '2026-03-28 15:29:39', '2026-04-02 14:39:17', 'pending', '0000-00-00 00:00:00'),
(15, 'DANSARKI/001', 'GENTLEMAN A#', '450000', '480000', '3', 'N/A', 'N/A', 'N/A', 'N/A', '2250000', '2400000', '', '2026-03-28 15:31:14', '2026-03-30 15:59:35', 'pending', '0000-00-00 00:00:00'),
(16, 'DANSARKI/001', 'GENTLEMAN B#', '420000', '450000', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2100000', '2250000', '', '2026-03-28 15:33:24', '2026-04-05 11:26:02', 'pending', '0000-00-00 00:00:00'),
(17, 'DANSARKI/001', 'TIMBUKTU', '360000', '390000', '2', 'N/A', 'N/A', 'N/A', 'N/A', '1800000', '1950000', '', '2026-03-28 15:35:37', '2026-04-02 14:39:40', 'pending', '0000-00-00 00:00:00'),
(18, 'DANSARKI/001', 'JU WOOL A florence', '450000', '480000', '1', 'N/A', 'N/A', 'N/A', 'N/A', '2250000', '2400000', '', '2026-03-28 15:38:11', '2026-04-02 11:19:26', 'pending', '0000-00-00 00:00:00'),
(19, 'DANSARKI/001', 'FASHION GOLD', '1125000', '1140000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1125000', '1140000', '', '2026-03-28 15:42:21', '2026-03-28 16:32:00', 'pending', '0000-00-00 00:00:00'),
(20, 'DANSARKI/001', 'AUSTRAILIAN WIFI', '2010000', '2050000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '2010000', '2050000', '', '2026-03-28 15:44:37', '2026-03-29 10:25:43', 'pending', '0000-00-00 00:00:00'),
(21, 'DANSARKI/001', 'VIP ILLUSION AD', '1325000', '1350000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1325000', '1350000', '', '2026-03-28 15:45:53', '2026-03-28 16:32:21', 'pending', '0000-00-00 00:00:00'),
(22, 'DANSARKI/001', 'PROFESSOR AD', '1285000', '1300000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1285000', '1300000', '', '2026-03-28 15:47:17', '2026-03-28 16:33:02', 'pending', '0000-00-00 00:00:00'),
(23, 'DANSARKI/001', 'WISE MAN AD', '1285000', '1300000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1285000', '1300000', '', '2026-03-28 15:49:54', '2026-03-28 16:34:05', 'pending', '0000-00-00 00:00:00'),
(24, 'DANSARKI/001', 'SILK ROAD AD', '1285000', '1300000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1285000', '1300000', '', '2026-03-28 15:51:52', '2026-03-28 16:22:16', 'pending', '0000-00-00 00:00:00'),
(25, 'DANSARKI/001', 'OCEAN BLUE blsk', '1275000', '1290000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1275000', '1290000', '', '2026-03-28 15:53:18', '2026-03-28 16:21:49', 'pending', '0000-00-00 00:00:00'),
(26, 'DANSARKI/001', 'swiss Okutex AD', '1100000', '1120000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '2200000', '2240000', '', '2026-03-29 13:25:24', '2026-04-13 09:19:03', 'pending', '0000-00-00 00:00:00'),
(27, 'DANSARKI/001', 'SOFT COTTON shadda', '1580000', '1600000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1580000', '1600000', '', '2026-03-29 13:29:34', '2026-03-29 14:25:45', 'pending', '0000-00-00 00:00:00'),
(28, 'DANSARKI/001', 'MARADONA Astere', '406000', '420000', '17', 'N/A', 'N/A', 'N/A', 'N/A', '8120000', '8400000', '', '2026-04-03 10:16:57', '2026-04-13 10:23:39', 'pending', '0000-00-00 00:00:00'),
(29, 'DANSARKI/001', 'GOLF 12000 mhood', '425000', '450000', '12', 'N/A', 'N/A', 'N/A', 'N/A', '6375000', '6750000', '', '2026-04-06 13:33:30', '2026-04-13 10:25:45', 'pending', '0000-00-00 00:00:00'),
(30, 'DANSARKI/001', 'VIP VOCTORY shadda 300y', '2080000', '2120000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '2080000', '2120000', '', '2026-04-06 14:56:55', '2026-04-06 15:00:00', 'pending', '0000-00-00 00:00:00'),
(31, 'DANSARKI/001', 'VIDA 300m', '2080000', '2120000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '2080000', '2120000', '', '2026-04-06 14:59:17', '2026-04-06 15:02:20', 'pending', '0000-00-00 00:00:00'),
(32, 'DANSARKI/001', 'Special Extention all white 300m', '1125000', '1150000', '1', 'N/A', 'N/A', 'N/A', '0', '3375000', '3450000', '', '2026-04-06 15:24:11', '2026-04-29 05:35:28', 'pending', '0000-00-00 00:00:00'),
(33, 'DANSARKI/001', 'CONGRESS P-AD 300y', '1455000', '1470000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1455000', '1470000', '', '2026-04-08 14:53:22', '2026-04-13 10:20:28', 'pending', '0000-00-00 00:00:00'),
(34, 'DANSARKI/001', 'SILVER SEA florence', '365000', '380000', '2', 'N/A', 'N/A', 'N/A', 'N/A', '1825000', '1900000', '', '2026-04-08 14:54:23', '2026-04-11 09:27:48', 'pending', '0000-00-00 00:00:00'),
(35, 'DANSARKI/001', '7star U&ME', '306000', '320000', '8', 'N/A', 'N/A', 'N/A', '0', '6120000', '6400000', '', '2026-04-10 11:16:59', '2026-04-29 05:30:07', 'pending', '0000-00-00 00:00:00'),
(36, 'DANSARKI/001', 'Ambassadola 300m', '1455000', '1470000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '2910000', '2940000', '', '2026-04-11 13:05:36', '2026-04-12 15:21:30', 'pending', '0000-00-00 00:00:00'),
(37, 'DANSARKI/001', 'Micro Inso 300m', '1455000', '1470000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '2910000', '2940000', '', '2026-04-11 13:06:55', '2026-04-12 15:18:09', 'pending', '0000-00-00 00:00:00'),
(38, 'DANSARKI/001', 'Phanta 300m', '1305000', '1320000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '2610000', '2640000', '', '2026-04-11 13:08:33', '2026-04-13 15:29:15', 'pending', '0000-00-00 00:00:00'),
(39, 'DANSARKI/001', 'Fasino Check PRIDE 141y', '874200', '902400', '1', 'N/A', 'N/A', 'N/A', 'N/A', '874200', '902400', '', '2026-04-13 08:52:35', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(40, 'DANSARKI/001', 'Regency TR PRIDE 178y', '1103600', '1139200', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1103600', '1139200', '', '2026-04-13 08:59:32', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(41, 'DANSARKI/001', 'Regency TR PRIDE 174y', '1078800', '1113600', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1078800', '1113600', '', '2026-04-13 09:00:53', '2026-04-13 09:16:15', 'pending', '0000-00-00 00:00:00'),
(42, 'DANSARKI/001', 'TR GOLD PRIDE 196y', '1293600', '1332800', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1293600', '1332800', '', '2026-04-13 09:02:46', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(43, 'DANSARKI/001', 'Vayana 02 PRIDE 155y', '961000', '992000', '1', 'N/A', 'N/A', 'N/A', 'N/A', '961000', '992000', '', '2026-04-13 09:04:18', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(44, 'DANSARKI/001', 'Fasino Check PRIDE 154y', '954800', '985600', '1', 'N/A', 'N/A', 'N/A', 'N/A', '954800', '985600', '', '2026-04-13 09:05:40', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(45, 'DANSARKI/001', 'TR GOLD PRIDE 204y', '1346400', '1387200', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1346400', '1387200', '', '2026-04-13 09:07:34', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(46, 'DANSARKI/001', 'Regency TR PRIDE 198y', '1227600', '1267200', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1227600', '1267200', '', '2026-04-13 09:08:49', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(47, 'DANSARKI/001', 'Regency TR PRIDE 195y', '1209000', '1248000', '0', 'N/A', 'N/A', 'N/A', 'N/A', '1209000', '1248000', '', '2026-04-13 09:10:08', '2026-04-13 09:16:43', 'pending', '0000-00-00 00:00:00'),
(48, 'DANSARKI/001', 'Vayana 02 PRIDE 146y', '905200', '934400', '1', 'N/A', 'N/A', 'N/A', 'N/A', '905200', '934400', '', '2026-04-13 09:13:59', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(49, 'DANSARKI/001', 'Regency TR PRIDE 199y', '1233800', '1273600', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1233800', '1273600', '', '2026-04-13 15:09:14', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(50, 'DANSARKI/001', 'Lycra Tanish PRIDE 150y', '930000', '960000', '2', 'N/A', 'N/A', 'N/A', 'N/A', '1860000', '1920000', '', '2026-04-13 15:13:50', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(51, 'DANSARKI/001', 'Sonet PRIDE 100y', '620000', '650000', '1', 'N/A', 'N/A', 'N/A', '2', '1860000', '1950000', '', '2026-04-13 15:16:01', '2026-05-02 04:55:47', 'pending', '0000-00-00 00:00:00'),
(52, 'DANSARKI/001', 'Sonet PRIDE 98y', '607600', '637000', '1', 'N/A', 'N/A', 'N/A', 'N/A', '607600', '637000', '', '2026-04-13 15:17:30', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(53, 'DANSARKI/001', 'Leebay PRIDE 100y', '620000', '650000', '2', 'N/A', 'N/A', 'N/A', 'N/A', '1240000', '1300000', '', '2026-04-13 15:18:42', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(54, 'DANSARKI/001', 'Regency TR PRIDE 200y', '1240000', '1280000', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1240000', '1280000', '', '2026-04-13 15:19:48', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(55, 'DANSARKI/001', 'Ethnic PRIDE 150y', '930000', '960000', '1', 'N/A', 'N/A', 'N/A', 'N/A', '930000', '960000', '', '2026-04-13 15:21:04', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(56, 'DANSARKI/001', 'Ethnic PRIDE 186y', '1153200', '1190400', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1153200', '1190400', '', '2026-04-13 15:22:17', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(57, 'DANSARKI/001', 'Turkish TR PRIDE 71y', '440200', '461500', '1', 'N/A', 'N/A', 'N/A', 'N/A', '440200', '461500', '', '2026-04-13 15:24:57', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(58, 'DANSARKI/001', 'Dedication PRIDE 120y', '744000', '780000', '1', 'N/A', 'N/A', 'N/A', '0', '744000', '780000', '', '2026-04-13 15:26:33', '2026-05-02 04:56:36', 'pending', '0000-00-00 00:00:00'),
(59, 'DANSARKI/001', 'Dedication PRIDE 129y', '799800', '838500', '1', 'N/A', 'N/A', 'N/A', 'N/A', '799800', '838500', '', '2026-04-13 15:27:25', '0000-00-00 00:00:00', 'pending', '0000-00-00 00:00:00'),
(60, 'DANSARKI/001', 'Testing', '0', '1000', '70', '0', '0', '100', '30', '0', '100000', NULL, '2026-04-18 12:27:42', '2026-04-18 12:52:26', 'pending', NULL),
(61, 'DANSARKI/001', 'Testing', '0', '100000', '10', '0', '0', '10', '0', '0', '1000000', NULL, '2026-05-05 15:45:18', NULL, 'pending', NULL),
(62, 'DANSARKI/001', 'Testing2', '0', '500', '10', '0', '0', '10', '0', '0', '5000', NULL, '2026-05-05 15:57:00', NULL, 'pending', NULL),
(63, 'DANSARKI/001', 'why', '0', '1000', '10', '0', '0', '10', '0', '0', '10000', NULL, '2026-05-06 05:26:52', NULL, 'pending', NULL),
(64, 'DANSARKI/001', 'zaga zaga', '0', '1000', '50', '0', '0', '50', '0', '0', '50000', NULL, '2026-05-06 05:36:54', NULL, 'pending', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `conca`
--
ALTER TABLE `conca`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `debt_cart`
--
ALTER TABLE `debt_cart`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deposit_history`
--
ALTER TABLE `deposit_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `expense`
--
ALTER TABLE `expense`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `facility`
--
ALTER TABLE `facility`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outstand`
--
ALTER TABLE `outstand`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `purchase_deposit_history`
--
ALTER TABLE `purchase_deposit_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `purchase_history`
--
ALTER TABLE `purchase_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `conca`
--
ALTER TABLE `conca`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `debt_cart`
--
ALTER TABLE `debt_cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `deposit_history`
--
ALTER TABLE `deposit_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `expense`
--
ALTER TABLE `expense`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `facility`
--
ALTER TABLE `facility`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=160;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `outstand`
--
ALTER TABLE `outstand`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `purchase_deposit_history`
--
ALTER TABLE `purchase_deposit_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_history`
--
ALTER TABLE `purchase_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
