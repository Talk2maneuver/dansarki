-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: dansarki
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facilityID` varchar(200) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') NOT NULL DEFAULT 'pending',
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (4,'DSK/001','admin','No. 123 testing street, Kano','0a2b03d6-6db7-11f1-a52a-8e4097374ddc','2026-06-21 21:20:34','2026-06-22 05:16:51','synced','2026-06-22 05:16:51',0);
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_branch_uuid` BEFORE INSERT ON `branch` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facilityID` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `staffID` varchar(200) NOT NULL,
  `stockID` int(11) NOT NULL,
  `item` varchar(200) NOT NULL,
  `price` varchar(200) NOT NULL,
  `quantity` varchar(200) NOT NULL,
  `subtotal` varchar(200) NOT NULL,
  `discount` varchar(200) DEFAULT '0',
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conca`
--

DROP TABLE IF EXISTS `conca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conca` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastID` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conca`
--

LOCK TABLES `conca` WRITE;
/*!40000 ALTER TABLE `conca` DISABLE KEYS */;
INSERT INTO `conca` VALUES (1,'2');
/*!40000 ALTER TABLE `conca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facilityID` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `name` varchar(200) NOT NULL,
  `phone` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `gender` varchar(200) NOT NULL,
  `address` varchar(200) NOT NULL,
  `creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `updation` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') NOT NULL DEFAULT 'pending',
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_customers_uuid` BEFORE INSERT ON `customers` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `debt_cart`
--

DROP TABLE IF EXISTS `debt_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `debt_cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `debt_cart`
--

LOCK TABLES `debt_cart` WRITE;
/*!40000 ALTER TABLE `debt_cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `debt_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deposit_history`
--

DROP TABLE IF EXISTS `deposit_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deposit_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerID` int(11) NOT NULL,
  `transaction_id` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `previous_balance` decimal(10,2) NOT NULL,
  `new_balance` decimal(10,2) NOT NULL,
  `deposit_date` datetime NOT NULL DEFAULT current_timestamp(),
  `processed_by` varchar(100) NOT NULL,
  `notes` text DEFAULT NULL,
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') NOT NULL DEFAULT 'pending',
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deposit_history`
--

LOCK TABLES `deposit_history` WRITE;
/*!40000 ALTER TABLE `deposit_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `deposit_history` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_deposit_history_uuid` BEFORE INSERT ON `deposit_history` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `expense`
--

DROP TABLE IF EXISTS `expense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `expense` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facilityID` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `item` varchar(200) NOT NULL,
  `price` varchar(200) NOT NULL,
  `type` varchar(11) DEFAULT NULL,
  `creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `updation` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') DEFAULT 'pending',
  `last_sync` timestamp NULL DEFAULT NULL,
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense`
--

LOCK TABLES `expense` WRITE;
/*!40000 ALTER TABLE `expense` DISABLE KEYS */;
/*!40000 ALTER TABLE `expense` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_expense_uuid` BEFORE INSERT ON `expense` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `facility`
--

DROP TABLE IF EXISTS `facility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `facility` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `last_stock_reset` date DEFAULT NULL,
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') NOT NULL DEFAULT 'pending',
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facility`
--

LOCK TABLES `facility` WRITE;
/*!40000 ALTER TABLE `facility` DISABLE KEYS */;
INSERT INTO `facility` VALUES (4,'DSK/001','1','Admin','admin@gmail.com','1234567890','Male','','admin','No 123 Testing street','Nigeria','Kano','','','','','Admin',1,'','','fd149fa1f2a2fee8d88bc1be14467a81','2025-06-17 15:16:03','2026-06-22 05:16:51','0000-00-00','0a4f57e6-6db7-11f1-a52a-8e4097374ddc','2026-06-21 21:20:34','2026-06-22 05:16:51','synced','2026-06-22 05:16:51',0),(6,'DSK/001','N/A','staff1','staff1@gmail.com','081234565789','Male','','admin','No 123 Testing street','','','','','','','Staff',1,'','','827ccb0eea8a706c4c34a16891f84e7b','2026-03-11 06:30:03','2026-06-22 05:16:51','0000-00-00','0a5032b3-6db7-11f1-a52a-8e4097374ddc','2026-06-21 21:20:34','2026-06-22 05:16:51','synced','2026-06-22 05:16:51',0);
/*!40000 ALTER TABLE `facility` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_facility_uuid` BEFORE INSERT ON `facility` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderID` varchar(255) NOT NULL,
  `stockID` int(11) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') NOT NULL DEFAULT 'pending',
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_order_items_uuid` BEFORE INSERT ON `order_items` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `sync_attempts` int(11) DEFAULT 0,
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_orders_uuid` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `outstand`
--

DROP TABLE IF EXISTS `outstand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outstand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facilityID` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `customerID` varchar(200) DEFAULT NULL,
  `staffID` varchar(200) NOT NULL,
  `Customer` varchar(200) NOT NULL,
  `staff` varchar(200) NOT NULL,
  `amount` varchar(200) NOT NULL,
  `balance` varchar(200) NOT NULL,
  `creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `updation` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') NOT NULL DEFAULT 'pending',
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outstand`
--

LOCK TABLES `outstand` WRITE;
/*!40000 ALTER TABLE `outstand` DISABLE KEYS */;
/*!40000 ALTER TABLE `outstand` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_outstand_uuid` BEFORE INSERT ON `outstand` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `purchase_deposit_history`
--

DROP TABLE IF EXISTS `purchase_deposit_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purchase_deposit_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchaseID` int(11) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `previous_balance` decimal(15,2) NOT NULL,
  `new_balance` decimal(15,2) NOT NULL,
  `processed_by` varchar(100) DEFAULT NULL,
  `deposit_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') NOT NULL DEFAULT 'pending',
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_deposit_history`
--

LOCK TABLES `purchase_deposit_history` WRITE;
/*!40000 ALTER TABLE `purchase_deposit_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_deposit_history` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_purchase_deposit_history_uuid` BEFORE INSERT ON `purchase_deposit_history` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `purchase_history`
--

DROP TABLE IF EXISTS `purchase_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purchase_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `purchase_date` datetime DEFAULT current_timestamp(),
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_status` enum('pending','synced','failed') NOT NULL DEFAULT 'pending',
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_history`
--

LOCK TABLES `purchase_history` WRITE;
/*!40000 ALTER TABLE `purchase_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_history` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_purchase_history_uuid` BEFORE INSERT ON `purchase_history` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rate_limits`
--

DROP TABLE IF EXISTS `rate_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rate_limits` (
  `ip` varchar(45) NOT NULL,
  `timestamp` int(11) NOT NULL,
  KEY `ip` (`ip`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rate_limits`
--

LOCK TABLES `rate_limits` WRITE;
/*!40000 ALTER TABLE `rate_limits` DISABLE KEYS */;
INSERT INTO `rate_limits` VALUES ('::1',1782103470),('::1',1782105411),('::1',1782105494);
/*!40000 ALTER TABLE `rate_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stocks`
--

DROP TABLE IF EXISTS `stocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `last_sync` timestamp NULL DEFAULT NULL,
  `uuid` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `sync_timestamp` timestamp NULL DEFAULT NULL,
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`),
  KEY `sync_status` (`sync_status`),
  KEY `deleted_flag` (`deleted_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stocks`
--

LOCK TABLES `stocks` WRITE;
/*!40000 ALTER TABLE `stocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `stocks` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tg_stocks_uuid` BEFORE INSERT ON `stocks` FOR EACH ROW BEGIN IF NEW.uuid IS NULL OR NEW.uuid = '' THEN SET NEW.uuid = UUID(); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sync_conflicts`
--

DROP TABLE IF EXISTS `sync_conflicts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_conflicts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `uuid` varchar(36) NOT NULL,
  `local_timestamp` timestamp NULL DEFAULT NULL,
  `server_timestamp` timestamp NULL DEFAULT NULL,
  `resolution` varchar(255) NOT NULL,
  `resolved_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `table_name` (`table_name`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_conflicts`
--

LOCK TABLES `sync_conflicts` WRITE;
/*!40000 ALTER TABLE `sync_conflicts` DISABLE KEYS */;
INSERT INTO `sync_conflicts` VALUES (1,'branch','0a2b03d6-6db7-11f1-a52a-8e4097374ddc','2026-06-21 21:20:34','2026-06-21 21:20:34','server_wins','2026-06-22 05:16:51'),(2,'facility','0a4f57e6-6db7-11f1-a52a-8e4097374ddc','2026-06-21 21:20:34','2026-06-21 21:20:34','server_wins','2026-06-22 05:16:51'),(3,'facility','0a5032b3-6db7-11f1-a52a-8e4097374ddc','2026-06-21 21:20:34','2026-06-21 21:20:34','server_wins','2026-06-22 05:16:51'),(4,'stocks','a10cb537-6df9-11f1-a52a-8e4097374ddc','2026-06-22 05:18:14',NULL,'local_wins','2026-06-22 05:18:14'),(5,'purchase_history','a10dac04-6df9-11f1-a52a-8e4097374ddc','2026-06-22 05:18:14',NULL,'local_wins','2026-06-22 05:18:14');
/*!40000 ALTER TABLE `sync_conflicts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_logs`
--

DROP TABLE IF EXISTS `sync_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `uuid` varchar(36) DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL,
  `message` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `table_name` (`table_name`),
  KEY `uuid` (`uuid`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_logs`
--

LOCK TABLES `sync_logs` WRITE;
/*!40000 ALTER TABLE `sync_logs` DISABLE KEYS */;
INSERT INTO `sync_logs` VALUES (1,'branch','0a2b03d6-6db7-11f1-a52a-8e4097374ddc','push','skipped','Successfully pushed to cloud','2026-06-22 05:16:51'),(2,'facility','0a4f57e6-6db7-11f1-a52a-8e4097374ddc','push','skipped','Successfully pushed to cloud','2026-06-22 05:16:51'),(3,'facility','0a5032b3-6db7-11f1-a52a-8e4097374ddc','push','skipped','Successfully pushed to cloud','2026-06-22 05:16:51'),(4,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:16:51'),(5,'stocks','a10cb537-6df9-11f1-a52a-8e4097374ddc','push','updated','Successfully pushed to cloud','2026-06-22 05:18:14'),(6,'purchase_history','a10dac04-6df9-11f1-a52a-8e4097374ddc','push','updated','Successfully pushed to cloud','2026-06-22 05:18:14'),(7,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:18:14'),(8,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:18:23'),(9,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:18:33'),(10,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:18:43'),(11,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:18:53'),(12,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:03'),(13,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:13'),(14,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:18'),(15,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:18'),(16,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:20'),(17,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:30'),(18,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:40'),(19,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:44'),(20,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:44'),(21,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:46'),(22,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:52'),(23,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:52'),(24,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:19:54'),(25,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:20:04'),(26,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:20:14'),(27,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:20:24'),(28,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:26:20'),(29,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:26:30'),(30,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:26:40'),(31,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:26:50'),(32,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:27:00'),(33,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:27:10'),(34,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:27:28'),(35,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:28:28'),(36,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:29:28'),(37,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:30:28'),(38,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:31:28'),(39,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:32:28'),(40,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:33:28'),(41,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:34:28'),(42,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:35:28'),(43,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:36:28'),(44,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:37:28'),(45,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:38:28'),(46,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:39:28'),(47,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:40:28'),(48,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:41:28'),(49,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:42:28'),(50,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:43:28'),(51,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:44:28'),(52,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:45:28'),(53,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:46:28'),(54,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:47:28'),(55,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:48:28'),(56,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:49:28'),(57,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:50:28'),(58,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:51:28'),(59,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:52:28'),(60,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:53:28'),(61,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:54:28'),(62,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:55:28'),(63,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:56:28'),(64,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:57:28'),(65,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:58:28'),(66,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 05:59:28'),(67,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:00:28'),(68,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:01:28'),(69,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:02:28'),(70,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:03:28'),(71,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:04:28'),(72,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:05:28'),(73,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:06:28'),(74,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:07:28'),(75,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:08:28'),(76,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:09:28'),(77,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:10:28'),(78,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:11:28'),(79,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:12:00'),(80,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:12:02'),(81,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:12:02'),(82,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:13:10'),(83,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:14:10'),(84,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:15:10'),(85,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:16:10'),(86,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:17:17'),(87,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:17:31'),(88,'all',NULL,'pull','failure','Pull failed with HTTP Code 301. Error: <!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://localhost/dansarki/api/sync?action=pull&amp;since=1970-01-01+00%3A00%3A00&amp;token=ds_sync_secure_token_5fb901c34aef82b\">here</a>.</p>\n<hr>\n<address>Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.0.30 Server at localhost Port 80</address>\n</body></html>\n','2026-06-22 06:17:41');
/*!40000 ALTER TABLE `sync_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_settings`
--

DROP TABLE IF EXISTS `sync_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_settings` (
  `key_name` varchar(100) NOT NULL,
  `val_value` text DEFAULT NULL,
  PRIMARY KEY (`key_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_settings`
--

LOCK TABLES `sync_settings` WRITE;
/*!40000 ALTER TABLE `sync_settings` DISABLE KEYS */;
INSERT INTO `sync_settings` VALUES ('auto_sync_enabled','1'),('last_sync_time','never');
/*!40000 ALTER TABLE `sync_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_settings` (
  `key_name` varchar(100) NOT NULL,
  `val_value` text DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`key_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-22  8:03:22
