/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.18-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: testlink
-- ------------------------------------------------------
-- Server version	10.11.18-MariaDB-ubu2204

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
-- Current Database: `testlink`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testlink` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `testlink`;

--
-- Table structure for table `assignment_status`
--

DROP TABLE IF EXISTS `assignment_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignment_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assignment_status`
--

LOCK TABLES `assignment_status` WRITE;
/*!40000 ALTER TABLE `assignment_status` DISABLE KEYS */;
INSERT INTO `assignment_status` VALUES
(1,'open'),
(2,'closed'),
(3,'completed'),
(4,'todo_urgent'),
(5,'todo');
/*!40000 ALTER TABLE `assignment_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assignment_types`
--

DROP TABLE IF EXISTS `assignment_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignment_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fk_table` varchar(30) DEFAULT '',
  `description` varchar(100) NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assignment_types`
--

LOCK TABLES `assignment_types` WRITE;
/*!40000 ALTER TABLE `assignment_types` DISABLE KEYS */;
INSERT INTO `assignment_types` VALUES
(1,'testplan_tcversions','testcase_execution'),
(2,'tcversions','testcase_review');
/*!40000 ALTER TABLE `assignment_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attachments`
--

DROP TABLE IF EXISTS `attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `attachments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fk_id` int(10) unsigned NOT NULL DEFAULT 0,
  `fk_table` varchar(250) DEFAULT '',
  `title` varchar(250) DEFAULT '',
  `description` varchar(250) DEFAULT '',
  `file_name` varchar(250) NOT NULL DEFAULT '',
  `file_path` varchar(250) DEFAULT '',
  `file_size` int(11) NOT NULL DEFAULT 0,
  `file_type` varchar(250) NOT NULL DEFAULT '',
  `date_added` timestamp NOT NULL DEFAULT current_timestamp(),
  `content` longblob DEFAULT NULL,
  `compression_type` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `attachments_idx1` (`fk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachments`
--

LOCK TABLES `attachments` WRITE;
/*!40000 ALTER TABLE `attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `baseline_l1l2_context`
--

DROP TABLE IF EXISTS `baseline_l1l2_context`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `baseline_l1l2_context` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `testplan_id` int(10) unsigned NOT NULL DEFAULT 0,
  `platform_id` int(10) unsigned NOT NULL DEFAULT 0,
  `being_exec_ts` timestamp NOT NULL,
  `end_exec_ts` timestamp NOT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `udx1` (`testplan_id`,`platform_id`,`creation_ts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `baseline_l1l2_context`
--

LOCK TABLES `baseline_l1l2_context` WRITE;
/*!40000 ALTER TABLE `baseline_l1l2_context` DISABLE KEYS */;
/*!40000 ALTER TABLE `baseline_l1l2_context` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `baseline_l1l2_details`
--

DROP TABLE IF EXISTS `baseline_l1l2_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `baseline_l1l2_details` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `context_id` int(10) unsigned NOT NULL,
  `top_tsuite_id` int(10) unsigned NOT NULL DEFAULT 0,
  `child_tsuite_id` int(10) unsigned NOT NULL DEFAULT 0,
  `status` char(1) DEFAULT NULL,
  `qty` int(10) unsigned NOT NULL DEFAULT 0,
  `total_tc` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `udx1` (`context_id`,`top_tsuite_id`,`child_tsuite_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `baseline_l1l2_details`
--

LOCK TABLES `baseline_l1l2_details` WRITE;
/*!40000 ALTER TABLE `baseline_l1l2_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `baseline_l1l2_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `builds`
--

DROP TABLE IF EXISTS `builds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `builds` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `testplan_id` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL DEFAULT 'undefined',
  `notes` text DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `is_open` tinyint(1) NOT NULL DEFAULT 1,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `release_date` date DEFAULT NULL,
  `closed_on_date` date DEFAULT NULL,
  `commit_id` varchar(64) DEFAULT NULL,
  `tag` varchar(64) DEFAULT NULL,
  `branch` varchar(64) DEFAULT NULL,
  `release_candidate` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`testplan_id`,`name`),
  KEY `testplan_id` (`testplan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Available builds';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `builds`
--

LOCK TABLES `builds` WRITE;
/*!40000 ALTER TABLE `builds` DISABLE KEYS */;
INSERT INTO `builds` VALUES
(1,74,'Build-2026-07-19','Initial baseline build ΓÇö all 20 test cases from Home Page and Arby\\\'s suites.',1,1,NULL,'2026-07-19 16:12:11','2026-07-19',NULL,NULL,NULL,NULL,NULL),
(2,75,'Build-2026-07-19','Initial build for Home Page test execution.',1,1,NULL,'2026-07-19 16:18:39','2026-07-19',NULL,NULL,NULL,NULL,NULL),
(3,76,'Build-2026-07-19','Initial build for Arby\\\'s test execution.',1,1,NULL,'2026-07-19 16:18:42','2026-07-19',NULL,NULL,NULL,NULL,NULL),
(4,76,'Build-2026-07-20','Automated Selenium/TestNG run ΓÇö Arby\\\'s full suite (TC-A-01..09 + TC-B-01..12). All 21 tests passed.',1,1,NULL,'2026-07-19 19:53:17','2026-07-19',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `builds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cfield_build_design_values`
--

DROP TABLE IF EXISTS `cfield_build_design_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cfield_build_design_values` (
  `field_id` int(10) NOT NULL DEFAULT 0,
  `node_id` int(10) NOT NULL DEFAULT 0,
  `value` varchar(4000) NOT NULL DEFAULT '',
  PRIMARY KEY (`field_id`,`node_id`),
  KEY `idx_cfield_build_design_values` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cfield_build_design_values`
--

LOCK TABLES `cfield_build_design_values` WRITE;
/*!40000 ALTER TABLE `cfield_build_design_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `cfield_build_design_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cfield_design_values`
--

DROP TABLE IF EXISTS `cfield_design_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cfield_design_values` (
  `field_id` int(10) NOT NULL DEFAULT 0,
  `node_id` int(10) NOT NULL DEFAULT 0,
  `value` varchar(4000) NOT NULL DEFAULT '',
  PRIMARY KEY (`field_id`,`node_id`),
  KEY `idx_cfield_design_values` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cfield_design_values`
--

LOCK TABLES `cfield_design_values` WRITE;
/*!40000 ALTER TABLE `cfield_design_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `cfield_design_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cfield_execution_values`
--

DROP TABLE IF EXISTS `cfield_execution_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cfield_execution_values` (
  `field_id` int(10) NOT NULL DEFAULT 0,
  `execution_id` int(10) NOT NULL DEFAULT 0,
  `testplan_id` int(10) NOT NULL DEFAULT 0,
  `tcversion_id` int(10) NOT NULL DEFAULT 0,
  `value` varchar(4000) NOT NULL DEFAULT '',
  PRIMARY KEY (`field_id`,`execution_id`,`testplan_id`,`tcversion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cfield_execution_values`
--

LOCK TABLES `cfield_execution_values` WRITE;
/*!40000 ALTER TABLE `cfield_execution_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `cfield_execution_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cfield_node_types`
--

DROP TABLE IF EXISTS `cfield_node_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cfield_node_types` (
  `field_id` int(10) NOT NULL DEFAULT 0,
  `node_type_id` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`field_id`,`node_type_id`),
  KEY `idx_custom_fields_assign` (`node_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cfield_node_types`
--

LOCK TABLES `cfield_node_types` WRITE;
/*!40000 ALTER TABLE `cfield_node_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `cfield_node_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cfield_testplan_design_values`
--

DROP TABLE IF EXISTS `cfield_testplan_design_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cfield_testplan_design_values` (
  `field_id` int(10) NOT NULL DEFAULT 0,
  `link_id` int(10) NOT NULL DEFAULT 0 COMMENT 'point to testplan_tcversion id',
  `value` varchar(4000) NOT NULL DEFAULT '',
  PRIMARY KEY (`field_id`,`link_id`),
  KEY `idx_cfield_tplan_design_val` (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cfield_testplan_design_values`
--

LOCK TABLES `cfield_testplan_design_values` WRITE;
/*!40000 ALTER TABLE `cfield_testplan_design_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `cfield_testplan_design_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cfield_testprojects`
--

DROP TABLE IF EXISTS `cfield_testprojects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cfield_testprojects` (
  `field_id` int(10) unsigned NOT NULL DEFAULT 0,
  `testproject_id` int(10) unsigned NOT NULL DEFAULT 0,
  `display_order` smallint(5) unsigned NOT NULL DEFAULT 1,
  `location` smallint(5) unsigned NOT NULL DEFAULT 1,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `required` tinyint(1) NOT NULL DEFAULT 0,
  `required_on_design` tinyint(1) NOT NULL DEFAULT 0,
  `required_on_execution` tinyint(1) NOT NULL DEFAULT 0,
  `monitorable` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`field_id`,`testproject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cfield_testprojects`
--

LOCK TABLES `cfield_testprojects` WRITE;
/*!40000 ALTER TABLE `cfield_testprojects` DISABLE KEYS */;
/*!40000 ALTER TABLE `cfield_testprojects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `codetrackers`
--

DROP TABLE IF EXISTS `codetrackers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `codetrackers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` int(10) DEFAULT 0,
  `cfg` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codetrackers_uidx1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codetrackers`
--

LOCK TABLES `codetrackers` WRITE;
/*!40000 ALTER TABLE `codetrackers` DISABLE KEYS */;
/*!40000 ALTER TABLE `codetrackers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_fields`
--

DROP TABLE IF EXISTS `custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_fields` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `label` varchar(64) NOT NULL DEFAULT '' COMMENT 'label to display on user interface',
  `type` smallint(6) NOT NULL DEFAULT 0,
  `possible_values` varchar(4000) NOT NULL DEFAULT '',
  `default_value` varchar(4000) NOT NULL DEFAULT '',
  `valid_regexp` varchar(255) NOT NULL DEFAULT '',
  `length_min` int(10) NOT NULL DEFAULT 0,
  `length_max` int(10) NOT NULL DEFAULT 0,
  `show_on_design` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT '1=> show it during specification design',
  `enable_on_design` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT '1=> user can write/manage it during specification design',
  `show_on_execution` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT '1=> show it during test case execution',
  `enable_on_execution` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT '1=> user can write/manage it during test case execution',
  `show_on_testplan_design` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `enable_on_testplan_design` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_custom_fields_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_fields`
--

LOCK TABLES `custom_fields` WRITE;
/*!40000 ALTER TABLE `custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `db_version`
--

DROP TABLE IF EXISTS `db_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_version` (
  `version` varchar(50) NOT NULL DEFAULT 'unknown',
  `upgrade_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `db_version`
--

LOCK TABLES `db_version` WRITE;
/*!40000 ALTER TABLE `db_version` DISABLE KEYS */;
INSERT INTO `db_version` VALUES
('DB 1.9.20','2026-07-18 16:24:26','TestLink 1.9.20 Raijin');
/*!40000 ALTER TABLE `db_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` int(10) unsigned NOT NULL DEFAULT 0,
  `log_level` smallint(5) unsigned NOT NULL DEFAULT 0,
  `source` varchar(45) DEFAULT NULL,
  `description` text NOT NULL,
  `fired_at` int(10) unsigned NOT NULL DEFAULT 0,
  `activity` varchar(45) DEFAULT NULL,
  `object_id` int(10) unsigned DEFAULT NULL,
  `object_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transaction_id` (`transaction_id`),
  KEY `fired_at` (`fired_at`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES
(1,1,16,'GUI','O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:10:\"172.19.0.1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}',1784391892,'LOGIN',1,'users'),
(2,2,16,'GUI - Test Project ID : 1','O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_testproject_created\";s:6:\"params\";a:1:{i:0;s:26:\"Inspire Brands Franchising\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}',1784391905,'CREATE',1,'testprojects'),
(3,3,16,'GUI','O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:18:\"audit_login_failed\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:10:\"172.19.0.1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}',1784392027,'LOGIN_FAILED',1,'users'),
(4,4,16,'GUI - Test Project ID : 1','O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:10:\"172.19.0.1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}',1784392069,'LOGIN',1,'users'),
(5,5,16,'GUI - Test Project ID : 1','O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:10:\"172.19.0.1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}',1784477424,'LOGIN',1,'users'),
(6,6,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784477652,'PHP',0,NULL),
(7,7,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784477652,'PHP',0,NULL),
(8,8,32,'GUI - Test Project ID : 1','string \'img_title_remove_platform\' is not localized for locale \'en_GB\' ',1784477661,'LOCALIZATION',0,NULL),
(9,8,32,'GUI - Test Project ID : 1','string \'remove_plat_msgbox_msg\' is not localized for locale \'en_GB\' ',1784477661,'LOCALIZATION',0,NULL),
(10,8,32,'GUI - Test Project ID : 1','string \'remove_plat_msgbox_title\' is not localized for locale \'en_GB\' ',1784477661,'LOCALIZATION',0,NULL),
(11,9,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784477672,'PHP',0,NULL),
(12,10,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784477672,'PHP',0,NULL),
(13,11,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784477702,'PHP',0,NULL),
(14,12,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784477702,'PHP',0,NULL),
(15,13,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784477733,'PHP',0,NULL),
(16,14,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784477733,'PHP',0,NULL),
(17,15,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 130',1784477950,'PHP',0,NULL),
(18,15,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$itemID - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 152',1784477950,'PHP',0,NULL),
(19,15,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index:  - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 302',1784477950,'PHP',0,NULL),
(20,16,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784477988,'PHP',0,NULL),
(21,17,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784478029,'PHP',0,NULL),
(22,18,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784478029,'PHP',0,NULL),
(23,19,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784482327,'PHP',0,NULL),
(24,20,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784482328,'PHP',0,NULL),
(25,21,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784482349,'PHP',0,NULL),
(26,22,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784482349,'PHP',0,NULL),
(27,23,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 130',1784482370,'PHP',0,NULL),
(28,23,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$itemID - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 152',1784482370,'PHP',0,NULL),
(29,23,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index:  - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 302',1784482370,'PHP',0,NULL),
(30,24,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784482408,'PHP',0,NULL),
(31,25,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784482408,'PHP',0,NULL),
(32,26,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784482435,'PHP',0,NULL),
(33,27,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784484479,'PHP',0,NULL),
(34,28,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784484479,'PHP',0,NULL),
(35,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(36,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(37,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(38,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(39,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(40,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(41,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(42,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(43,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(44,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(45,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(46,29,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486469,'PHP',0,NULL),
(47,30,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784486503,'PHP',0,NULL),
(48,31,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784486503,'PHP',0,NULL),
(49,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(50,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(51,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(52,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(53,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(54,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(55,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(56,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(57,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(58,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(59,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(60,32,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784486521,'PHP',0,NULL),
(61,33,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784486549,'PHP',0,NULL),
(62,34,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784486549,'PHP',0,NULL),
(63,35,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784486564,'PHP',0,NULL),
(64,36,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784489291,'PHP',0,NULL),
(65,37,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784489291,'PHP',0,NULL),
(66,38,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784489822,'PHP',0,NULL),
(67,39,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/2b1de5006292f6abcd8786b9f344d891e0723436_0.file.containerView.tpl.php - Line 123',1784489823,'PHP',0,NULL),
(68,40,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index: size - in /var/www/html/gui/templates_c/5ae255f9e8adee3b23c994195805d74968bd0264_0.file.inc_filter_panel.tpl.php - Line 351',1784489834,'PHP',0,NULL),
(69,41,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 130',1784490382,'PHP',0,NULL),
(70,41,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$itemID - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 152',1784490382,'PHP',0,NULL),
(71,41,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index:  - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 302',1784490382,'PHP',0,NULL),
(72,42,16,'GUI - Test Project ID : 1','O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:20:\"audit_testplan_saved\";s:6:\"params\";a:2:{i:0;s:26:\"Inspire Brands Franchising\";i:1;s:23:\"Arby\'s Brand Page Tests\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}',1784490387,'SAVE',76,'testplans'),
(73,43,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784490437,'PHP',0,NULL),
(74,44,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784490442,'PHP',0,NULL),
(75,45,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784490449,'PHP',0,NULL),
(76,46,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 130',1784490472,'PHP',0,NULL),
(77,46,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$itemID - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 152',1784490472,'PHP',0,NULL),
(78,46,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index:  - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 302',1784490472,'PHP',0,NULL),
(79,47,16,'GUI - Test Project ID : 1','O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:20:\"audit_testplan_saved\";s:6:\"params\";a:2:{i:0;s:26:\"Inspire Brands Franchising\";i:1;s:23:\"Arby\'s Brand Page Tests\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}',1784490552,'SAVE',76,'testplans'),
(80,48,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$uploadOp - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 130',1784490554,'PHP',0,NULL),
(81,48,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined property: stdClass::$itemID - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 152',1784490554,'PHP',0,NULL),
(82,48,2,'GUI - Test Project ID : 1','E_NOTICE\nUndefined index:  - in /var/www/html/gui/templates_c/dc265c149d5503210aced4195901ff501ef2c66c_0.file.planEdit.tpl.php - Line 302',1784490554,'PHP',0,NULL),
(83,49,2,'GUI','E_NOTICE\nUndefined index: keywords - in /var/www/html/lib/functions/testplan.class.php - Line 7096',1784490977,'PHP',0,NULL),
(84,49,2,'GUI','E_NOTICE\nUndefined index: keywords - in /var/www/html/lib/functions/testplan.class.php - Line 7126',1784490977,'PHP',0,NULL),
(85,50,2,'GUI','E_NOTICE\nUndefined variable: nst - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491185,'PHP',0,NULL),
(86,50,2,'GUI','E_WARNING\nInvalid argument supplied for foreach() - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491185,'PHP',0,NULL),
(87,51,2,'GUI','E_NOTICE\nUndefined variable: nst - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(88,51,2,'GUI','E_WARNING\nInvalid argument supplied for foreach() - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(89,52,2,'GUI','E_NOTICE\nUndefined variable: nst - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(90,52,2,'GUI','E_WARNING\nInvalid argument supplied for foreach() - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(91,53,2,'GUI','E_NOTICE\nUndefined variable: nst - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(92,54,2,'GUI','E_NOTICE\nUndefined variable: nst - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(93,53,2,'GUI','E_WARNING\nInvalid argument supplied for foreach() - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(94,55,2,'GUI','E_NOTICE\nUndefined variable: nst - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(95,54,2,'GUI','E_WARNING\nInvalid argument supplied for foreach() - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(96,55,2,'GUI','E_WARNING\nInvalid argument supplied for foreach() - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(97,56,2,'GUI','E_NOTICE\nUndefined variable: nst - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(98,56,2,'GUI','E_WARNING\nInvalid argument supplied for foreach() - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(99,57,2,'GUI','E_NOTICE\nUndefined variable: nst - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(100,57,2,'GUI','E_WARNING\nInvalid argument supplied for foreach() - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(101,58,2,'GUI','E_NOTICE\nUndefined variable: nst - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(102,58,2,'GUI','E_WARNING\nInvalid argument supplied for foreach() - in /var/www/html/lib/api/xmlrpc/v1/xmlrpc.class.php - Line 2449',1784491186,'PHP',0,NULL),
(103,59,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491273,'PHP',0,NULL),
(104,60,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491279,'PHP',0,NULL),
(105,61,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491286,'PHP',0,NULL),
(106,62,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491287,'PHP',0,NULL),
(107,63,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491292,'PHP',0,NULL),
(108,64,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491293,'PHP',0,NULL),
(109,65,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491294,'PHP',0,NULL),
(110,66,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491304,'PHP',0,NULL),
(111,67,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491307,'PHP',0,NULL),
(112,68,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491308,'PHP',0,NULL),
(113,69,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491308,'PHP',0,NULL),
(114,70,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491309,'PHP',0,NULL),
(115,71,2,'GUI - Test Project ID : 1','E_NOTICE\nTrying to access array offset on value of type null - in /var/www/html/gui/templates_c/32916e4d428edb29e8817b6c6726333e0ff51ffe_0.file.inc_exec_show_tc_exec.tpl.php - Line 244',1784491315,'PHP',0,NULL),
(116,72,16,'GUI - Test Project ID : 1','O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:10:\"172.19.0.1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}',1784958394,'LOGIN',1,'users'),
(117,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(118,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(119,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(120,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(121,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(122,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(123,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(124,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(125,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(126,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(127,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL),
(128,73,2,'GUI','E_WARNING\nUse of undefined constant full - assumed \'full\' (this will throw an Error in a future version of PHP) - in /var/www/html/lib/functions/testsuite.class.php - Line 883',1784999227,'PHP',0,NULL);
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `exec_by_date_time`
--

DROP TABLE IF EXISTS `exec_by_date_time`;
/*!50001 DROP VIEW IF EXISTS `exec_by_date_time`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `exec_by_date_time` AS SELECT
 NULL AS `testplan_name`,
 NULL AS `yyyy_mm_dd`,
 NULL AS `yyyy_mm`,
 NULL AS `hh`,
 NULL AS `hour`,
 NULL AS `id`,
 NULL AS `build_id`,
 NULL AS `tester_id`,
 NULL AS `execution_ts`,
 NULL AS `status`,
 NULL AS `testplan_id`,
 NULL AS `tcversion_id`,
 NULL AS `tcversion_number`,
 NULL AS `platform_id`,
 NULL AS `execution_type`,
 NULL AS `execution_duration`,
 NULL AS `notes` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `execution_bugs`
--

DROP TABLE IF EXISTS `execution_bugs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `execution_bugs` (
  `execution_id` int(10) unsigned NOT NULL DEFAULT 0,
  `bug_id` varchar(64) NOT NULL DEFAULT '0',
  `tcstep_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`execution_id`,`bug_id`,`tcstep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `execution_bugs`
--

LOCK TABLES `execution_bugs` WRITE;
/*!40000 ALTER TABLE `execution_bugs` DISABLE KEYS */;
/*!40000 ALTER TABLE `execution_bugs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `execution_tcsteps`
--

DROP TABLE IF EXISTS `execution_tcsteps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `execution_tcsteps` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `execution_id` int(10) unsigned NOT NULL DEFAULT 0,
  `tcstep_id` int(10) unsigned NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `execution_tcsteps_idx1` (`execution_id`,`tcstep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `execution_tcsteps`
--

LOCK TABLES `execution_tcsteps` WRITE;
/*!40000 ALTER TABLE `execution_tcsteps` DISABLE KEYS */;
/*!40000 ALTER TABLE `execution_tcsteps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `execution_tcsteps_wip`
--

DROP TABLE IF EXISTS `execution_tcsteps_wip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `execution_tcsteps_wip` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tcstep_id` int(10) unsigned NOT NULL DEFAULT 0,
  `testplan_id` int(10) unsigned NOT NULL DEFAULT 0,
  `platform_id` int(10) unsigned NOT NULL DEFAULT 0,
  `build_id` int(10) unsigned NOT NULL DEFAULT 0,
  `tester_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `execution_tcsteps_wip_idx1` (`tcstep_id`,`testplan_id`,`platform_id`,`build_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `execution_tcsteps_wip`
--

LOCK TABLES `execution_tcsteps_wip` WRITE;
/*!40000 ALTER TABLE `execution_tcsteps_wip` DISABLE KEYS */;
/*!40000 ALTER TABLE `execution_tcsteps_wip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `executions`
--

DROP TABLE IF EXISTS `executions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `executions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `build_id` int(10) NOT NULL DEFAULT 0,
  `tester_id` int(10) unsigned DEFAULT NULL,
  `execution_ts` datetime DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  `testplan_id` int(10) unsigned NOT NULL DEFAULT 0,
  `tcversion_id` int(10) unsigned NOT NULL DEFAULT 0,
  `tcversion_number` smallint(5) unsigned NOT NULL DEFAULT 1,
  `platform_id` int(10) unsigned NOT NULL DEFAULT 0,
  `execution_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 -> manual, 2 -> automated',
  `execution_duration` decimal(6,2) DEFAULT NULL COMMENT 'NULL will be considered as NO DATA Provided by user',
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `executions_idx1` (`testplan_id`,`tcversion_id`,`platform_id`,`build_id`),
  KEY `executions_idx2` (`execution_type`),
  KEY `executions_idx3` (`tcversion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `executions`
--

LOCK TABLES `executions` WRITE;
/*!40000 ALTER TABLE `executions` DISABLE KEYS */;
INSERT INTO `executions` VALUES
(1,4,1,'2026-07-19 19:59:45','p',76,44,1,0,2,NULL,'PASSED ΓÇö Automated Selenium/TestNG run Build-2026-07-20. Tests run: 21, Failures: 0.'),
(2,4,1,'2026-07-19 19:59:46','p',76,53,1,0,2,NULL,'PASSED ΓÇö Automated Selenium/TestNG run Build-2026-07-20. Tests run: 21, Failures: 0.'),
(3,4,1,'2026-07-19 19:59:46','p',76,50,1,0,2,NULL,'PASSED ΓÇö Automated Selenium/TestNG run Build-2026-07-20. Tests run: 21, Failures: 0.'),
(4,4,1,'2026-07-19 19:59:46','p',76,58,1,0,2,NULL,'PASSED ΓÇö Automated Selenium/TestNG run Build-2026-07-20. Tests run: 21, Failures: 0.'),
(5,4,1,'2026-07-19 19:59:46','p',76,47,1,0,2,NULL,'PASSED ΓÇö Automated Selenium/TestNG run Build-2026-07-20. Tests run: 21, Failures: 0.'),
(6,4,1,'2026-07-19 19:59:46','p',76,61,1,0,2,NULL,'PASSED ΓÇö Automated Selenium/TestNG run Build-2026-07-20. Tests run: 21, Failures: 0.'),
(7,4,1,'2026-07-19 19:59:46','p',76,72,1,0,2,NULL,'PASSED ΓÇö Automated Selenium/TestNG run Build-2026-07-20. Tests run: 21, Failures: 0.'),
(8,4,1,'2026-07-19 19:59:46','p',76,69,1,0,2,NULL,'PASSED ΓÇö Automated Selenium/TestNG run Build-2026-07-20. Tests run: 21, Failures: 0.'),
(9,4,1,'2026-07-19 19:59:46','p',76,64,1,0,2,NULL,'PASSED ΓÇö Automated Selenium/TestNG run Build-2026-07-20. Tests run: 21, Failures: 0.');
/*!40000 ALTER TABLE `executions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `testproject_id` int(10) unsigned NOT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `ipaddress` varchar(255) NOT NULL,
  `content` text DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `modification_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `inventory_idx1` (`testproject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuetrackers`
--

DROP TABLE IF EXISTS `issuetrackers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `issuetrackers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` int(10) DEFAULT 0,
  `cfg` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `issuetrackers_uidx1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuetrackers`
--

LOCK TABLES `issuetrackers` WRITE;
/*!40000 ALTER TABLE `issuetrackers` DISABLE KEYS */;
/*!40000 ALTER TABLE `issuetrackers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keywords`
--

DROP TABLE IF EXISTS `keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `keywords` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `keyword` varchar(100) NOT NULL DEFAULT '',
  `testproject_id` int(10) unsigned NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `keyword_testproject_id` (`keyword`,`testproject_id`),
  KEY `testproject_id` (`testproject_id`),
  KEY `keyword` (`keyword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keywords`
--

LOCK TABLES `keywords` WRITE;
/*!40000 ALTER TABLE `keywords` DISABLE KEYS */;
/*!40000 ALTER TABLE `keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `latest_exec_by_context`
--

DROP TABLE IF EXISTS `latest_exec_by_context`;
/*!50001 DROP VIEW IF EXISTS `latest_exec_by_context`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `latest_exec_by_context` AS SELECT
 NULL AS `tcversion_id`,
 NULL AS `testplan_id`,
 NULL AS `build_id`,
 NULL AS `platform_id`,
 NULL AS `id` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `latest_exec_by_testplan`
--

DROP TABLE IF EXISTS `latest_exec_by_testplan`;
/*!50001 DROP VIEW IF EXISTS `latest_exec_by_testplan`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `latest_exec_by_testplan` AS SELECT
 NULL AS `tcversion_id`,
 NULL AS `testplan_id`,
 NULL AS `id` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `latest_exec_by_testplan_plat`
--

DROP TABLE IF EXISTS `latest_exec_by_testplan_plat`;
/*!50001 DROP VIEW IF EXISTS `latest_exec_by_testplan_plat`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `latest_exec_by_testplan_plat` AS SELECT
 NULL AS `tcversion_id`,
 NULL AS `testplan_id`,
 NULL AS `platform_id`,
 NULL AS `id` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `latest_req_version`
--

DROP TABLE IF EXISTS `latest_req_version`;
/*!50001 DROP VIEW IF EXISTS `latest_req_version`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `latest_req_version` AS SELECT
 NULL AS `req_id`,
 NULL AS `version` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `latest_req_version_id`
--

DROP TABLE IF EXISTS `latest_req_version_id`;
/*!50001 DROP VIEW IF EXISTS `latest_req_version_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `latest_req_version_id` AS SELECT
 NULL AS `req_id`,
 NULL AS `version`,
 NULL AS `req_version_id` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `latest_rspec_revision`
--

DROP TABLE IF EXISTS `latest_rspec_revision`;
/*!50001 DROP VIEW IF EXISTS `latest_rspec_revision`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `latest_rspec_revision` AS SELECT
 NULL AS `req_spec_id`,
 NULL AS `testproject_id`,
 NULL AS `revision` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `latest_tcase_version_id`
--

DROP TABLE IF EXISTS `latest_tcase_version_id`;
/*!50001 DROP VIEW IF EXISTS `latest_tcase_version_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `latest_tcase_version_id` AS SELECT
 NULL AS `testcase_id`,
 NULL AS `version`,
 NULL AS `tcversion_id` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `latest_tcase_version_number`
--

DROP TABLE IF EXISTS `latest_tcase_version_number`;
/*!50001 DROP VIEW IF EXISTS `latest_tcase_version_number`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `latest_tcase_version_number` AS SELECT
 NULL AS `testcase_id`,
 NULL AS `version` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `milestones`
--

DROP TABLE IF EXISTS `milestones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `milestones` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `testplan_id` int(10) unsigned NOT NULL DEFAULT 0,
  `target_date` date NOT NULL,
  `start_date` date DEFAULT NULL,
  `a` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `b` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `c` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL DEFAULT 'undefined',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_testplan_id` (`name`,`testplan_id`),
  KEY `testplan_id` (`testplan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `milestones`
--

LOCK TABLES `milestones` WRITE;
/*!40000 ALTER TABLE `milestones` DISABLE KEYS */;
/*!40000 ALTER TABLE `milestones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_types`
--

DROP TABLE IF EXISTS `node_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `node_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL DEFAULT 'testproject',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_types`
--

LOCK TABLES `node_types` WRITE;
/*!40000 ALTER TABLE `node_types` DISABLE KEYS */;
INSERT INTO `node_types` VALUES
(1,'testproject'),
(2,'testsuite'),
(3,'testcase'),
(4,'testcase_version'),
(5,'testplan'),
(6,'requirement_spec'),
(7,'requirement'),
(8,'requirement_version'),
(9,'testcase_step'),
(10,'requirement_revision'),
(11,'requirement_spec_revision'),
(12,'build'),
(13,'platform'),
(14,'user');
/*!40000 ALTER TABLE `node_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nodes_hierarchy`
--

DROP TABLE IF EXISTS `nodes_hierarchy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `nodes_hierarchy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `node_type_id` int(10) unsigned NOT NULL DEFAULT 1,
  `node_order` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pid_m_nodeorder` (`parent_id`,`node_order`),
  KEY `nodes_hierarchy_node_type_id` (`node_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nodes_hierarchy`
--

LOCK TABLES `nodes_hierarchy` WRITE;
/*!40000 ALTER TABLE `nodes_hierarchy` DISABLE KEYS */;
INSERT INTO `nodes_hierarchy` VALUES
(1,'Inspire Brands Franchising',NULL,1,1),
(2,'Home Page Tests',1,2,0),
(3,'Brand Pages',1,2,0),
(4,'Arby\'s',3,2,0),
(5,'TC-H-01 Verify home page loads and URL is correct',2,3,0),
(6,'',5,4,0),
(7,'',6,9,0),
(8,'',6,9,0),
(9,'TC-H-02 Verify hero heading \'Anything is Possible\' is displayed',2,3,0),
(10,'',9,4,0),
(11,'',10,9,0),
(12,'TC-H-03 Verify hero heading text is exactly \'Anything is Possible\'',2,3,0),
(13,'',12,4,0),
(14,'',13,9,0),
(15,'TC-H-04 Verify hero \'GET STARTED\' CTA button is displayed',2,3,0),
(16,'',15,4,0),
(17,'',16,9,0),
(18,'TC-H-05 Verify clicking \'GET STARTED\' navigates to franchise enquiry form',2,3,0),
(19,'',18,4,0),
(20,'',19,9,0),
(21,'',19,9,0),
(22,'TC-H-06 Verify \'Grow with Inspire\'s Iconic Brands\' section is visible',2,3,0),
(23,'',22,4,0),
(24,'',23,9,0),
(25,'TC-H-07 Verify \'Our Brands\' navigation menu contains Arby\'s',2,3,0),
(26,'',25,4,0),
(27,'',26,9,0),
(28,'',26,9,0),
(29,'TC-H-08 Verify Arby\'s brand link navigates to the Arby\'s page',2,3,0),
(30,'',29,4,0),
(31,'',30,9,0),
(32,'TC-H-09 Verify page footer is displayed with company name',2,3,0),
(33,'',32,4,0),
(34,'',33,9,0),
(35,'',33,9,0),
(36,'TC-H-10 Verify LinkedIn link is present in the footer',2,3,0),
(37,'',36,4,0),
(38,'',37,9,0),
(39,'',37,9,0),
(40,'TC-H-11 Verify \'How do I become a franchisee?\' section is present',2,3,0),
(41,'',40,4,0),
(42,'',41,9,0),
(43,'TC-A-01 Verify page title contains \'Arby\'s\'',4,3,0),
(44,'',43,4,0),
(45,'',44,9,0),
(46,'TC-A-02 Verify hero heading reads \'Franchise with Arby\'s\'',4,3,0),
(47,'',46,4,0),
(48,'',47,9,0),
(49,'TC-A-03 Verify \'Why Arby\'s?\' section heading is displayed',4,3,0),
(50,'',49,4,0),
(51,'',50,9,0),
(52,'TC-A-04 Verify award recognitions are listed (Entrepreneur, Top Food, Franchise 500)',4,3,0),
(53,'',52,4,0),
(54,'',53,9,0),
(55,'',53,9,0),
(56,'',53,9,0),
(57,'TC-A-05 Verify liquid assets requirement of $500,000 is displayed',4,3,0),
(58,'',57,4,0),
(59,'',58,9,0),
(60,'TC-A-06 Verify net worth requirement of $1,000,000 is displayed',4,3,0),
(61,'',60,4,0),
(62,'',61,9,0),
(63,'TC-A-07 Verify all three restaurant formats are displayed (Free Standing, Endcap, Small Format)',4,3,0),
(64,'',63,4,0),
(65,'',64,9,0),
(66,'',64,9,0),
(67,'',64,9,0),
(68,'TC-A-08 Verify \'Anything is possible with Arby\'s\' section is displayed',4,3,0),
(69,'',68,4,0),
(70,'',69,9,0),
(71,'TC-A-09 Verify restaurant count factoid \'3,500 restaurants\' is displayed',4,3,0),
(72,'',71,4,0),
(73,'',72,9,0),
(74,'Inspire Brands - Full Regression Suite',1,5,0),
(75,'Home Page Tests',1,5,0),
(76,'Arby\'s Brand Page Tests',1,5,0),
(78,'Common Brand Page Tests',3,2,2),
(83,'TC-B-03 Verify hero GET STARTED CTA is displayed',78,3,0),
(85,'TC-B-01 Verify brand page loads at expected URL',78,3,0),
(93,'',83,4,0),
(97,'',93,9,0),
(99,'',85,4,0),
(102,'',99,9,0);
/*!40000 ALTER TABLE `nodes_hierarchy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `object_keywords`
--

DROP TABLE IF EXISTS `object_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `object_keywords` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fk_id` int(10) unsigned NOT NULL DEFAULT 0,
  `fk_table` varchar(30) DEFAULT '',
  `keyword_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `udx01_object_keywords` (`fk_id`,`fk_table`,`keyword_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object_keywords`
--

LOCK TABLES `object_keywords` WRITE;
/*!40000 ALTER TABLE `object_keywords` DISABLE KEYS */;
/*!40000 ALTER TABLE `object_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platforms`
--

DROP TABLE IF EXISTS `platforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `platforms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `testproject_id` int(10) unsigned NOT NULL,
  `notes` text NOT NULL,
  `enable_on_design` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `enable_on_execution` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_platforms` (`testproject_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platforms`
--

LOCK TABLES `platforms` WRITE;
/*!40000 ALTER TABLE `platforms` DISABLE KEYS */;
/*!40000 ALTER TABLE `platforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugins`
--

DROP TABLE IF EXISTS `plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `basename` varchar(100) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 0,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugins`
--

LOCK TABLES `plugins` WRITE;
/*!40000 ALTER TABLE `plugins` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugins_configuration`
--

DROP TABLE IF EXISTS `plugins_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugins_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `testproject_id` int(11) NOT NULL,
  `config_key` varchar(255) NOT NULL,
  `config_type` int(11) NOT NULL,
  `config_value` varchar(255) NOT NULL,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugins_configuration`
--

LOCK TABLES `plugins_configuration` WRITE;
/*!40000 ALTER TABLE `plugins_configuration` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugins_configuration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `req_coverage`
--

DROP TABLE IF EXISTS `req_coverage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `req_coverage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `req_id` int(10) NOT NULL,
  `req_version_id` int(10) NOT NULL,
  `testcase_id` int(10) NOT NULL,
  `tcversion_id` int(10) NOT NULL,
  `link_status` int(11) NOT NULL DEFAULT 1,
  `is_active` int(11) NOT NULL DEFAULT 1,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `review_requester_id` int(10) unsigned DEFAULT NULL,
  `review_request_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `req_coverage_full_link` (`req_id`,`req_version_id`,`testcase_id`,`tcversion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='relation test case version ** requirement version';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `req_coverage`
--

LOCK TABLES `req_coverage` WRITE;
/*!40000 ALTER TABLE `req_coverage` DISABLE KEYS */;
/*!40000 ALTER TABLE `req_coverage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `req_monitor`
--

DROP TABLE IF EXISTS `req_monitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `req_monitor` (
  `req_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `testproject_id` int(11) NOT NULL,
  PRIMARY KEY (`req_id`,`user_id`,`testproject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `req_monitor`
--

LOCK TABLES `req_monitor` WRITE;
/*!40000 ALTER TABLE `req_monitor` DISABLE KEYS */;
/*!40000 ALTER TABLE `req_monitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `req_relations`
--

DROP TABLE IF EXISTS `req_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `req_relations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source_id` int(10) unsigned NOT NULL,
  `destination_id` int(10) unsigned NOT NULL,
  `relation_type` smallint(5) unsigned NOT NULL DEFAULT 1,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `req_relations`
--

LOCK TABLES `req_relations` WRITE;
/*!40000 ALTER TABLE `req_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `req_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `req_revisions`
--

DROP TABLE IF EXISTS `req_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `req_revisions` (
  `parent_id` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `revision` smallint(5) unsigned NOT NULL DEFAULT 1,
  `req_doc_id` varchar(64) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `scope` text DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT 'V',
  `type` char(1) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `is_open` tinyint(1) NOT NULL DEFAULT 1,
  `expected_coverage` int(10) NOT NULL DEFAULT 1,
  `log_message` text DEFAULT NULL,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifier_id` int(10) unsigned DEFAULT NULL,
  `modification_ts` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `req_revisions_uidx1` (`parent_id`,`revision`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `req_revisions`
--

LOCK TABLES `req_revisions` WRITE;
/*!40000 ALTER TABLE `req_revisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `req_revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `req_specs`
--

DROP TABLE IF EXISTS `req_specs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `req_specs` (
  `id` int(10) unsigned NOT NULL,
  `testproject_id` int(10) unsigned NOT NULL,
  `doc_id` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `req_spec_uk1` (`doc_id`,`testproject_id`),
  KEY `testproject_id` (`testproject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Dev. Documents (e.g. System Requirements Specification)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `req_specs`
--

LOCK TABLES `req_specs` WRITE;
/*!40000 ALTER TABLE `req_specs` DISABLE KEYS */;
/*!40000 ALTER TABLE `req_specs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `req_specs_revisions`
--

DROP TABLE IF EXISTS `req_specs_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `req_specs_revisions` (
  `parent_id` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `revision` smallint(5) unsigned NOT NULL DEFAULT 1,
  `doc_id` varchar(64) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `scope` text DEFAULT NULL,
  `total_req` int(10) NOT NULL DEFAULT 0,
  `status` int(10) unsigned DEFAULT 1,
  `type` char(1) DEFAULT NULL,
  `log_message` text DEFAULT NULL,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifier_id` int(10) unsigned DEFAULT NULL,
  `modification_ts` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `req_specs_revisions_uidx1` (`parent_id`,`revision`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `req_specs_revisions`
--

LOCK TABLES `req_specs_revisions` WRITE;
/*!40000 ALTER TABLE `req_specs_revisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `req_specs_revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `req_versions`
--

DROP TABLE IF EXISTS `req_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `req_versions` (
  `id` int(10) unsigned NOT NULL,
  `version` smallint(5) unsigned NOT NULL DEFAULT 1,
  `revision` smallint(5) unsigned NOT NULL DEFAULT 1,
  `scope` text DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT 'V',
  `type` char(1) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `is_open` tinyint(1) NOT NULL DEFAULT 1,
  `expected_coverage` int(10) NOT NULL DEFAULT 1,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifier_id` int(10) unsigned DEFAULT NULL,
  `modification_ts` datetime NOT NULL DEFAULT current_timestamp(),
  `log_message` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `req_versions`
--

LOCK TABLES `req_versions` WRITE;
/*!40000 ALTER TABLE `req_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `req_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reqmgrsystems`
--

DROP TABLE IF EXISTS `reqmgrsystems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `reqmgrsystems` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` int(10) DEFAULT 0,
  `cfg` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reqmgrsystems_uidx1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reqmgrsystems`
--

LOCK TABLES `reqmgrsystems` WRITE;
/*!40000 ALTER TABLE `reqmgrsystems` DISABLE KEYS */;
/*!40000 ALTER TABLE `reqmgrsystems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirements`
--

DROP TABLE IF EXISTS `requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirements` (
  `id` int(10) unsigned NOT NULL,
  `srs_id` int(10) unsigned NOT NULL,
  `req_doc_id` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `requirements_req_doc_id` (`srs_id`,`req_doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirements`
--

LOCK TABLES `requirements` WRITE;
/*!40000 ALTER TABLE `requirements` DISABLE KEYS */;
/*!40000 ALTER TABLE `requirements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rights`
--

DROP TABLE IF EXISTS `rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rights` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rights_descr` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rights`
--

LOCK TABLES `rights` WRITE;
/*!40000 ALTER TABLE `rights` DISABLE KEYS */;
INSERT INTO `rights` VALUES
(53,'cfield_assignment'),
(18,'cfield_management'),
(17,'cfield_view'),
(51,'codetracker_management'),
(52,'codetracker_view'),
(56,'delete_frozen_tcversion'),
(22,'events_mgt'),
(54,'exec_assign_testcases'),
(36,'exec_delete'),
(35,'exec_edit_notes'),
(49,'exec_ro_access'),
(41,'exec_testcases_assigned_to_me'),
(31,'issuetracker_management'),
(32,'issuetracker_view'),
(29,'keyword_assignment'),
(9,'mgt_modify_key'),
(12,'mgt_modify_product'),
(11,'mgt_modify_req'),
(7,'mgt_modify_tc'),
(48,'mgt_plugins'),
(16,'mgt_testplan_create'),
(30,'mgt_unfreeze_req'),
(13,'mgt_users'),
(20,'mgt_view_events'),
(8,'mgt_view_key'),
(10,'mgt_view_req'),
(6,'mgt_view_tc'),
(21,'mgt_view_usergroups'),
(50,'monitor_requirement'),
(24,'platform_management'),
(25,'platform_view'),
(26,'project_inventory_management'),
(27,'project_inventory_view'),
(33,'reqmgrsystem_management'),
(34,'reqmgrsystem_view'),
(28,'req_tcase_link_management'),
(14,'role_management'),
(19,'system_configuration'),
(47,'testcase_freeze'),
(43,'testplan_add_remove_platforms'),
(2,'testplan_create_build'),
(1,'testplan_execute'),
(3,'testplan_metrics'),
(40,'testplan_milestone_overview'),
(4,'testplan_planning'),
(45,'testplan_set_urgent_testcases'),
(46,'testplan_show_testcases_newest_versions'),
(37,'testplan_unlink_executed_testcases'),
(44,'testplan_update_linked_testcase_versions'),
(5,'testplan_user_role_assignment'),
(55,'testproject_add_remove_keywords_executed_tcversions'),
(38,'testproject_delete_executed_testcases'),
(39,'testproject_edit_executed_testcases'),
(42,'testproject_metrics_dashboard'),
(23,'testproject_user_role_assignment'),
(15,'user_role_assignment');
/*!40000 ALTER TABLE `rights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_assignments`
--

DROP TABLE IF EXISTS `risk_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `risk_assignments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `testplan_id` int(10) unsigned NOT NULL DEFAULT 0,
  `node_id` int(10) unsigned NOT NULL DEFAULT 0,
  `risk` char(1) NOT NULL DEFAULT '2',
  `importance` char(1) NOT NULL DEFAULT 'M',
  PRIMARY KEY (`id`),
  UNIQUE KEY `risk_assignments_tplan_node_id` (`testplan_id`,`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_assignments`
--

LOCK TABLES `risk_assignments` WRITE;
/*!40000 ALTER TABLE `risk_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `risk_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_rights`
--

DROP TABLE IF EXISTS `role_rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_rights` (
  `role_id` int(10) NOT NULL DEFAULT 0,
  `right_id` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`role_id`,`right_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_rights`
--

LOCK TABLES `role_rights` WRITE;
/*!40000 ALTER TABLE `role_rights` DISABLE KEYS */;
INSERT INTO `role_rights` VALUES
(4,3),
(4,6),
(4,7),
(4,8),
(4,9),
(4,10),
(4,11),
(4,28),
(4,29),
(4,30),
(4,50),
(5,3),
(5,6),
(5,8),
(6,1),
(6,2),
(6,3),
(6,6),
(6,7),
(6,8),
(6,9),
(6,11),
(6,25),
(6,27),
(6,28),
(6,29),
(6,30),
(6,50),
(7,1),
(7,3),
(7,6),
(7,8),
(8,1),
(8,2),
(8,3),
(8,4),
(8,5),
(8,6),
(8,7),
(8,8),
(8,9),
(8,10),
(8,11),
(8,12),
(8,13),
(8,14),
(8,15),
(8,16),
(8,17),
(8,18),
(8,19),
(8,20),
(8,21),
(8,22),
(8,23),
(8,24),
(8,25),
(8,26),
(8,27),
(8,28),
(8,29),
(8,30),
(8,31),
(8,32),
(8,33),
(8,34),
(8,35),
(8,36),
(8,37),
(8,38),
(8,39),
(8,40),
(8,41),
(8,42),
(8,43),
(8,44),
(8,45),
(8,46),
(8,47),
(8,48),
(8,50),
(8,51),
(8,52),
(8,53),
(8,54),
(9,1),
(9,2),
(9,3),
(9,4),
(9,5),
(9,6),
(9,7),
(9,8),
(9,9),
(9,10),
(9,11),
(9,15),
(9,16),
(9,24),
(9,25),
(9,26),
(9,27),
(9,28),
(9,29),
(9,30),
(9,47),
(9,50);
/*!40000 ALTER TABLE `role_rights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_rights_roles_descr` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
(1,'<reserved system role 1>',NULL),
(2,'<reserved system role 2>',NULL),
(3,'<no rights>',NULL),
(4,'test designer',NULL),
(5,'guest',NULL),
(6,'senior tester',NULL),
(7,'tester',NULL),
(8,'admin',NULL),
(9,'leader',NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tcsteps`
--

DROP TABLE IF EXISTS `tcsteps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcsteps` (
  `id` int(10) unsigned NOT NULL,
  `step_number` int(11) NOT NULL DEFAULT 1,
  `actions` text DEFAULT NULL,
  `expected_results` text DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `execution_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 -> manual, 2 -> automated',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tcsteps`
--

LOCK TABLES `tcsteps` WRITE;
/*!40000 ALTER TABLE `tcsteps` DISABLE KEYS */;
INSERT INTO `tcsteps` VALUES
(7,1,'<p>Navigate to the Inspire Brands Franchising home page.</p>','<p>Page loads without error.</p>',1,2),
(8,2,'<p>Read the current URL from the browser.</p>','<p>URL contains <strong>franchising.inspirebrands.com</strong>.</p>',1,2),
(11,1,'<p>Check visibility of the hero section heading.</p>','<p>Hero heading <strong>Anything is Possible</strong> is visible on the page.</p>',1,2),
(14,1,'<p>Read the text of the hero section heading element.</p>','<p>Heading text contains <strong>Anything is Possible</strong> (exact match to AppConstants.HOME_HERO_HEADING).</p>',1,2),
(17,1,'<p>Check visibility of the GET STARTED button in the hero section.</p>','<p><strong>GET STARTED</strong> button is visible in the hero section.</p>',1,2),
(20,1,'<p>Click the <strong>GET STARTED</strong> button in the hero section.</p>','<p>Browser navigates to a URL containing the franchise enquiry form path (AppConstants.FRANCHISE_FORM_PATH).</p>',1,2),
(21,2,'<p>Verify the resulting URL.</p>','<p>URL contains the expected franchise form path.</p>',1,2),
(24,1,'<p>Check visibility of the brands section heading on the home page.</p>','<p><strong>Grow with Inspire\'s Iconic Brands</strong> section heading is visible.</p>',1,2),
(27,1,'<p>Open the <strong>Our Brands</strong> dropdown menu in the navigation.</p>','<p>Dropdown opens successfully.</p>',1,2),
(28,2,'<p>Check that Arby\'s is listed in the dropdown options.</p>','<p><strong>Arby\'s</strong> is present in the Our Brands dropdown.</p>',1,2),
(31,1,'<p>Click the Arby\'s brand link in the home page body (not the nav dropdown).</p>','<p>Browser navigates to a URL containing <strong>/arbys</strong>.</p>',1,2),
(34,1,'<p>Scroll to the footer and check its visibility.</p>','<p>Footer is visible on the page.</p>',1,2),
(35,2,'<p>Check for the company name text in the footer.</p>','<p>Footer displays <strong>INSPIRE BRANDS FRANCHISING</strong>.</p>',1,2),
(38,1,'<p>Check for the LinkedIn link element in the footer.</p>','<p>LinkedIn link is present in the footer.</p>',1,2),
(39,2,'<p>Read the href attribute of the LinkedIn link.</p>','<p>href contains <strong>linkedin.com</strong> (AppConstants.FOOTER_LINKEDIN_URL).</p>',1,2),
(42,1,'<p>Locate and check the visibility of the \'How do I become a franchisee?\' section.</p>','<p><strong>How do I become a franchisee?</strong> section is visible on the home page.</p>',1,2),
(45,1,'<p>Read the page title text from the Arby\'s brand page.</p>','<p>Page title contains the text <strong>Arby</strong>.</p>',1,2),
(48,1,'<p>Read the hero heading text from the Arby\'s brand page.</p>','<p>Hero heading contains both <strong>Franchise with</strong> and <strong>Arby</strong>.</p>',1,2),
(51,1,'<p>Locate and check visibility of the <strong>Why Arby\'s?</strong> section heading.</p>','<p>\'Why Arby\'s?\' heading is visible on the page.</p>',1,2),
(54,1,'<p>Check visibility of the <strong>Entrepreneur</strong> award text.</p>','<p>Entrepreneur award text is visible.</p>',1,2),
(55,2,'<p>Check visibility of the <strong>Top Food Franchise</strong> award text.</p>','<p>Top Food Franchise award text is visible.</p>',1,2),
(56,3,'<p>Check visibility of the <strong>Franchise 500</strong> award text.</p>','<p>Franchise 500 award text is visible.</p>',1,2),
(59,1,'<p>Locate the qualification/financial requirements section and check for the $500,000 liquid assets figure.</p>','<p>Liquid assets requirement of <strong>$500,000</strong> is visible on the page.</p>',1,2),
(62,1,'<p>Locate the qualification/financial requirements section and check for the $1,000,000 net worth figure.</p>','<p>Net worth requirement of <strong>$1,000,000</strong> is visible on the page.</p>',1,2),
(65,1,'<p>Check visibility of the <strong>Free Standing</strong> format label.</p>','<p>\'Free Standing\' format label is visible.</p>',1,2),
(66,2,'<p>Check visibility of the <strong>Endcap</strong> format label.</p>','<p>\'Endcap\' format label is visible.</p>',1,2),
(67,3,'<p>Check visibility of the <strong>Small Format</strong> label.</p>','<p>\'Small Format\' label is visible.</p>',1,2),
(70,1,'<p>Locate and check visibility of the <strong>Anything is possible with Arby\'s</strong> section.</p>','<p>\'Anything is possible with Arby\'s\' section is visible on the page.</p>',1,2),
(73,1,'<p>Locate and check visibility of the restaurant count factoid on the Arby\'s page.</p>','<p><strong>3,500 restaurants</strong> factoid text is visible on the page.</p>',1,2),
(97,1,'Open the brand page and check the hero CTA.','GET STARTED button is visible in the hero section.',1,2),
(102,1,'Open the target brand page.','The current URL contains the expected brand page path.',1,2);
/*!40000 ALTER TABLE `tcsteps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tcversions`
--

DROP TABLE IF EXISTS `tcversions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcversions` (
  `id` int(10) unsigned NOT NULL,
  `tc_external_id` int(10) unsigned DEFAULT NULL,
  `version` smallint(5) unsigned NOT NULL DEFAULT 1,
  `layout` smallint(5) unsigned NOT NULL DEFAULT 1,
  `status` smallint(5) unsigned NOT NULL DEFAULT 1,
  `summary` text DEFAULT NULL,
  `preconditions` text DEFAULT NULL,
  `importance` smallint(5) unsigned NOT NULL DEFAULT 2,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `updater_id` int(10) unsigned DEFAULT NULL,
  `modification_ts` datetime NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `is_open` tinyint(1) NOT NULL DEFAULT 1,
  `execution_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 -> manual, 2 -> automated',
  `estimated_exec_duration` decimal(6,2) DEFAULT NULL COMMENT 'NULL will be considered as NO DATA Provided by user',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tcversions`
--

LOCK TABLES `tcversions` WRITE;
/*!40000 ALTER TABLE `tcversions` DISABLE KEYS */;
INSERT INTO `tcversions` VALUES
(6,1,1,1,7,'<p>Verify the Inspire Brands Franchising home page loads successfully and the URL contains the expected domain.</p>','<p>Browser is open. No prior navigation.</p>',3,1,'2026-07-19 16:09:59',NULL,'2026-07-19 16:09:59',1,1,2,NULL),
(10,2,1,1,7,'<p>Verify the hero section heading \'Anything is Possible\' is displayed on the home page.</p>','<p>Home page is open.</p>',3,1,'2026-07-19 16:10:04',NULL,'2026-07-19 16:10:04',1,1,2,NULL),
(13,3,1,1,7,'<p>Verify the hero heading text value exactly matches the expected constant \'Anything is Possible\'.</p>','<p>Home page is open.</p>',2,1,'2026-07-19 16:10:09',NULL,'2026-07-19 16:10:09',1,1,2,NULL),
(16,4,1,1,7,'<p>Verify the \'GET STARTED\' call-to-action button is visible in the hero section of the home page.</p>','<p>Home page is open.</p>',3,1,'2026-07-19 16:10:14',NULL,'2026-07-19 16:10:14',1,1,2,NULL),
(19,5,1,1,7,'<p>Verify that clicking the GET STARTED button navigates the user to the franchise enquiry form.</p>','<p>Home page is open.</p>',3,1,'2026-07-19 16:10:19',NULL,'2026-07-19 16:10:19',1,1,2,NULL),
(23,6,1,1,7,'<p>Verify the \'Grow with Inspire\'s Iconic Brands\' section is visible on the home page.</p>','<p>Home page is open.</p>',2,1,'2026-07-19 16:10:23',NULL,'2026-07-19 16:10:23',1,1,2,NULL),
(26,7,1,1,7,'<p>Verify that the \'Our Brands\' navigation dropdown menu contains the Arby\'s brand entry.</p>','<p>Home page is open.</p>',2,1,'2026-07-19 16:10:29',NULL,'2026-07-19 16:10:29',1,1,2,NULL),
(30,8,1,1,7,'<p>Verify that clicking the Arby\'s brand link on the home page body navigates to the Arby\'s franchise page.</p>','<p>Home page is open.</p>',2,1,'2026-07-19 16:10:34',NULL,'2026-07-19 16:10:34',1,1,2,NULL),
(33,9,1,1,7,'<p>Verify the page footer is visible and displays the company name \'INSPIRE BRANDS FRANCHISING\'.</p>','<p>Home page is open.</p>',2,1,'2026-07-19 16:10:40',NULL,'2026-07-19 16:10:40',1,1,2,NULL),
(37,10,1,1,7,'<p>Verify the LinkedIn social media link is present in the footer and points to linkedin.com.</p>','<p>Home page is open.</p>',1,1,'2026-07-19 16:10:46',NULL,'2026-07-19 16:10:46',1,1,2,NULL),
(41,11,1,1,7,'<p>Verify the \'How do I become a franchisee?\' informational section is present and visible on the home page.</p>','<p>Home page is open.</p>',2,1,'2026-07-19 16:10:50',NULL,'2026-07-19 16:10:50',1,1,2,NULL),
(44,12,1,1,7,'<p>Verify the Arby\'s franchising page title contains \'Arby\'s\'.</p>','<p>Browser is on the Arby\'s franchising page: https://www.franchising.inspirebrands.com/arbys</p>',3,1,'2026-07-19 16:11:01',NULL,'2026-07-19 16:11:01',1,1,2,NULL),
(47,13,1,1,7,'<p>Verify the hero section heading on the Arby\'s page reads \'Franchise with Arby\'s\'.</p>','<p>Browser is on the Arby\'s franchising page.</p>',3,1,'2026-07-19 16:11:06',NULL,'2026-07-19 16:11:06',1,1,2,NULL),
(50,14,1,1,7,'<p>Verify the \'Why Arby\'s?\' section heading is displayed on the Arby\'s franchising page.</p>','<p>Browser is on the Arby\'s franchising page.</p>',2,1,'2026-07-19 16:11:11',NULL,'2026-07-19 16:11:11',1,1,2,NULL),
(53,15,1,1,7,'<p>Verify all three award recognitions (Entrepreneur, Top Food Franchise, Franchise 500) are displayed on the Arby\'s page.</p>','<p>Browser is on the Arby\'s franchising page.</p>',2,1,'2026-07-19 16:11:17',NULL,'2026-07-19 16:11:17',1,1,2,NULL),
(58,16,1,1,7,'<p>Verify the $500,000 minimum liquid assets requirement is displayed in the Arby\'s franchising qualification section.</p>','<p>Browser is on the Arby\'s franchising page.</p>',2,1,'2026-07-19 16:11:22',NULL,'2026-07-19 16:11:22',1,1,2,NULL),
(61,17,1,1,7,'<p>Verify the $1,000,000 minimum net worth requirement is displayed in the Arby\'s franchising qualification section.</p>','<p>Browser is on the Arby\'s franchising page.</p>',2,1,'2026-07-19 16:11:27',NULL,'2026-07-19 16:11:27',1,1,2,NULL),
(64,18,1,1,7,'<p>Verify all three Arby\'s restaurant format options (Free Standing, Endcap, Small Format) are displayed on the page.</p>','<p>Browser is on the Arby\'s franchising page.</p>',2,1,'2026-07-19 16:11:34',NULL,'2026-07-19 16:11:34',1,1,2,NULL),
(69,19,1,1,7,'<p>Verify the \'Anything is possible with Arby\'s\' motivational section is displayed on the Arby\'s franchising page.</p>','<p>Browser is on the Arby\'s franchising page.</p>',2,1,'2026-07-19 16:11:40',NULL,'2026-07-19 16:11:40',1,1,2,NULL),
(72,20,1,1,7,'<p>Verify the \'3,500 restaurants\' factoid is displayed on the Arby\'s franchising page.</p>','<p>Browser is on the Arby\'s franchising page.</p>',2,1,'2026-07-19 16:11:44',NULL,'2026-07-19 16:11:44',1,1,2,NULL),
(93,25,1,1,7,'<p>Verify the hero GET STARTED call-to-action button is displayed.</p>','',2,1,'2026-07-19 18:41:07',NULL,'2026-07-19 18:41:07',1,1,2,NULL),
(99,27,1,1,7,'<p>Verify the brand page loads successfully at its expected URL.</p>','',2,1,'2026-07-19 18:41:07',NULL,'2026-07-19 18:41:07',1,1,2,NULL);
/*!40000 ALTER TABLE `tcversions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `tcversions_without_keywords`
--

DROP TABLE IF EXISTS `tcversions_without_keywords`;
/*!50001 DROP VIEW IF EXISTS `tcversions_without_keywords`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `tcversions_without_keywords` AS SELECT
 NULL AS `testcase_id`,
 NULL AS `id` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tcversions_without_platforms`
--

DROP TABLE IF EXISTS `tcversions_without_platforms`;
/*!50001 DROP VIEW IF EXISTS `tcversions_without_platforms`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `tcversions_without_platforms` AS SELECT
 NULL AS `testcase_id`,
 NULL AS `id` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `testcase_keywords`
--

DROP TABLE IF EXISTS `testcase_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testcase_keywords` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `testcase_id` int(10) unsigned NOT NULL DEFAULT 0,
  `tcversion_id` int(10) unsigned NOT NULL DEFAULT 0,
  `keyword_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx01_testcase_keywords` (`testcase_id`,`tcversion_id`,`keyword_id`),
  KEY `idx02_testcase_keywords` (`tcversion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testcase_keywords`
--

LOCK TABLES `testcase_keywords` WRITE;
/*!40000 ALTER TABLE `testcase_keywords` DISABLE KEYS */;
/*!40000 ALTER TABLE `testcase_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testcase_platforms`
--

DROP TABLE IF EXISTS `testcase_platforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testcase_platforms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `testcase_id` int(10) unsigned NOT NULL DEFAULT 0,
  `tcversion_id` int(10) unsigned NOT NULL DEFAULT 0,
  `platform_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx01_testcase_platform` (`testcase_id`,`tcversion_id`,`platform_id`),
  KEY `idx02_testcase_platform` (`tcversion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testcase_platforms`
--

LOCK TABLES `testcase_platforms` WRITE;
/*!40000 ALTER TABLE `testcase_platforms` DISABLE KEYS */;
/*!40000 ALTER TABLE `testcase_platforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testcase_relations`
--

DROP TABLE IF EXISTS `testcase_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testcase_relations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source_id` int(10) unsigned NOT NULL,
  `destination_id` int(10) unsigned NOT NULL,
  `link_status` tinyint(1) NOT NULL DEFAULT 1,
  `relation_type` smallint(5) unsigned NOT NULL DEFAULT 1,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testcase_relations`
--

LOCK TABLES `testcase_relations` WRITE;
/*!40000 ALTER TABLE `testcase_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `testcase_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testcase_script_links`
--

DROP TABLE IF EXISTS `testcase_script_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testcase_script_links` (
  `tcversion_id` int(10) unsigned NOT NULL DEFAULT 0,
  `project_key` varchar(64) NOT NULL,
  `repository_name` varchar(64) NOT NULL,
  `code_path` varchar(255) NOT NULL,
  `branch_name` varchar(64) DEFAULT NULL,
  `commit_id` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`tcversion_id`,`project_key`,`repository_name`,`code_path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testcase_script_links`
--

LOCK TABLES `testcase_script_links` WRITE;
/*!40000 ALTER TABLE `testcase_script_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `testcase_script_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testplan_platforms`
--

DROP TABLE IF EXISTS `testplan_platforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testplan_platforms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `testplan_id` int(10) unsigned NOT NULL,
  `platform_id` int(10) unsigned NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_testplan_platforms` (`testplan_id`,`platform_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Connects a testplan with platforms';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testplan_platforms`
--

LOCK TABLES `testplan_platforms` WRITE;
/*!40000 ALTER TABLE `testplan_platforms` DISABLE KEYS */;
/*!40000 ALTER TABLE `testplan_platforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testplan_tcversions`
--

DROP TABLE IF EXISTS `testplan_tcversions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testplan_tcversions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `testplan_id` int(10) unsigned NOT NULL DEFAULT 0,
  `tcversion_id` int(10) unsigned NOT NULL DEFAULT 0,
  `node_order` int(10) unsigned NOT NULL DEFAULT 1,
  `urgency` smallint(5) NOT NULL DEFAULT 2,
  `platform_id` int(10) unsigned NOT NULL DEFAULT 0,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `testplan_tcversions_tplan_tcversion` (`testplan_id`,`tcversion_id`,`platform_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testplan_tcversions`
--

LOCK TABLES `testplan_tcversions` WRITE;
/*!40000 ALTER TABLE `testplan_tcversions` DISABLE KEYS */;
INSERT INTO `testplan_tcversions` VALUES
(1,74,6,1,2,0,1,'2026-07-19 16:12:15'),
(2,74,10,1,2,0,1,'2026-07-19 16:12:19'),
(3,74,13,1,2,0,1,'2026-07-19 16:12:22'),
(4,74,16,1,2,0,1,'2026-07-19 16:12:25'),
(5,74,19,1,2,0,1,'2026-07-19 16:12:28'),
(6,74,23,1,2,0,1,'2026-07-19 16:12:31'),
(7,74,26,1,2,0,1,'2026-07-19 16:12:34'),
(8,74,30,1,2,0,1,'2026-07-19 16:12:37'),
(9,74,33,1,2,0,1,'2026-07-19 16:12:40'),
(10,74,37,1,2,0,1,'2026-07-19 16:12:43'),
(11,74,41,1,2,0,1,'2026-07-19 16:12:47'),
(12,74,44,1,2,0,1,'2026-07-19 16:12:49'),
(13,74,47,1,2,0,1,'2026-07-19 16:12:52'),
(14,74,50,1,2,0,1,'2026-07-19 16:12:56'),
(15,74,53,1,2,0,1,'2026-07-19 16:12:59'),
(16,74,58,1,2,0,1,'2026-07-19 16:13:03'),
(17,74,61,1,2,0,1,'2026-07-19 16:13:06'),
(18,74,64,1,2,0,1,'2026-07-19 16:13:09'),
(19,74,69,1,2,0,1,'2026-07-19 16:13:12'),
(20,74,72,1,2,0,1,'2026-07-19 16:13:14'),
(21,75,6,1,2,0,1,'2026-07-19 16:18:47'),
(22,75,10,1,2,0,1,'2026-07-19 16:18:51'),
(23,75,13,1,2,0,1,'2026-07-19 16:18:54'),
(24,75,16,1,2,0,1,'2026-07-19 16:18:57'),
(25,75,19,1,2,0,1,'2026-07-19 16:18:59'),
(26,75,23,1,2,0,1,'2026-07-19 16:19:02'),
(27,75,26,1,2,0,1,'2026-07-19 16:19:05'),
(28,75,30,1,2,0,1,'2026-07-19 16:19:09'),
(29,75,33,1,2,0,1,'2026-07-19 16:19:12'),
(30,75,37,1,2,0,1,'2026-07-19 16:19:14'),
(31,75,41,1,2,0,1,'2026-07-19 16:19:19'),
(32,76,44,1,2,0,1,'2026-07-19 16:19:22'),
(33,76,47,1,2,0,1,'2026-07-19 16:19:26'),
(34,76,50,1,2,0,1,'2026-07-19 16:19:28'),
(35,76,53,1,2,0,1,'2026-07-19 16:19:31'),
(36,76,58,1,2,0,1,'2026-07-19 16:19:34'),
(37,76,61,1,2,0,1,'2026-07-19 16:19:37'),
(38,76,64,1,2,0,1,'2026-07-19 16:19:41'),
(39,76,69,1,2,0,1,'2026-07-19 16:19:44'),
(40,76,72,1,2,0,1,'2026-07-19 16:19:47');
/*!40000 ALTER TABLE `testplan_tcversions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testplans`
--

DROP TABLE IF EXISTS `testplans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testplans` (
  `id` int(10) unsigned NOT NULL,
  `testproject_id` int(10) unsigned NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `is_open` tinyint(1) NOT NULL DEFAULT 1,
  `is_public` tinyint(1) NOT NULL DEFAULT 1,
  `api_key` varchar(64) NOT NULL DEFAULT '829a2ded3ed0829a2dedd8ab81dfa2c77e8235bc3ed0d8ab81dfa2c77e8235bc',
  PRIMARY KEY (`id`),
  UNIQUE KEY `testplans_api_key` (`api_key`),
  KEY `testplans_testproject_id_active` (`testproject_id`,`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testplans`
--

LOCK TABLES `testplans` WRITE;
/*!40000 ALTER TABLE `testplans` DISABLE KEYS */;
INSERT INTO `testplans` VALUES
(74,1,'&lt;p&gt;Full regression suite covering Home Page (TC-H-01 to TC-H-11) and Arby\'s brand page (TC-A-01 to TC-A-09). Automated via Selenium/TestNG.&lt;/p&gt;',1,1,1,'045d81ea5acf65546ada667e1dc28ec408770c8620febeb07204f2e916f31947'),
(75,1,'&lt;p&gt;Test plan covering all home page user journeys (TC-H-01 to TC-H-11). Automated via Selenium/TestNG.&lt;/p&gt;',1,1,1,'68fc40a0008950213c7dcf5205922a036a080ab4e5b4147d68b9e873ba53bbb8'),
(76,1,'<p>&lt;p&gt;Test plan covering all Arby&#39;s franchising page tests (TC-A-01 to TC-A-09). Automated via Selenium/TestNG.&lt;/p&gt;</p>',1,1,1,'e7a8cda5c767d7d39bddacd431912e8cdccf76e4aacbcf0da5d2e3d638956d3c');
/*!40000 ALTER TABLE `testplans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testproject_codetracker`
--

DROP TABLE IF EXISTS `testproject_codetracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testproject_codetracker` (
  `testproject_id` int(10) unsigned NOT NULL,
  `codetracker_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`testproject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testproject_codetracker`
--

LOCK TABLES `testproject_codetracker` WRITE;
/*!40000 ALTER TABLE `testproject_codetracker` DISABLE KEYS */;
/*!40000 ALTER TABLE `testproject_codetracker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testproject_issuetracker`
--

DROP TABLE IF EXISTS `testproject_issuetracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testproject_issuetracker` (
  `testproject_id` int(10) unsigned NOT NULL,
  `issuetracker_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`testproject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testproject_issuetracker`
--

LOCK TABLES `testproject_issuetracker` WRITE;
/*!40000 ALTER TABLE `testproject_issuetracker` DISABLE KEYS */;
/*!40000 ALTER TABLE `testproject_issuetracker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testproject_reqmgrsystem`
--

DROP TABLE IF EXISTS `testproject_reqmgrsystem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testproject_reqmgrsystem` (
  `testproject_id` int(10) unsigned NOT NULL,
  `reqmgrsystem_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`testproject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testproject_reqmgrsystem`
--

LOCK TABLES `testproject_reqmgrsystem` WRITE;
/*!40000 ALTER TABLE `testproject_reqmgrsystem` DISABLE KEYS */;
/*!40000 ALTER TABLE `testproject_reqmgrsystem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testprojects`
--

DROP TABLE IF EXISTS `testprojects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testprojects` (
  `id` int(10) unsigned NOT NULL,
  `notes` text DEFAULT NULL,
  `color` varchar(12) NOT NULL DEFAULT '#9BD',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `option_reqs` tinyint(1) NOT NULL DEFAULT 0,
  `option_priority` tinyint(1) NOT NULL DEFAULT 0,
  `option_automation` tinyint(1) NOT NULL DEFAULT 0,
  `options` text DEFAULT NULL,
  `prefix` varchar(16) NOT NULL,
  `tc_counter` int(10) unsigned NOT NULL DEFAULT 0,
  `is_public` tinyint(1) NOT NULL DEFAULT 1,
  `issue_tracker_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `code_tracker_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `reqmgr_integration_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `api_key` varchar(64) NOT NULL DEFAULT '0d8ab81dfa2c77e8235bc829a2ded3edfa2c78235bc829a27eded3ed0d8ab81d',
  PRIMARY KEY (`id`),
  UNIQUE KEY `testprojects_prefix` (`prefix`),
  UNIQUE KEY `testprojects_api_key` (`api_key`),
  KEY `testprojects_id_active` (`id`,`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testprojects`
--

LOCK TABLES `testprojects` WRITE;
/*!40000 ALTER TABLE `testprojects` DISABLE KEYS */;
INSERT INTO `testprojects` VALUES
(1,'','',1,0,0,0,'O:8:\"stdClass\":4:{s:19:\"requirementsEnabled\";i:0;s:19:\"testPriorityEnabled\";i:1;s:17:\"automationEnabled\";i:1;s:16:\"inventoryEnabled\";i:0;}','IBF',32,1,0,0,0,'06618cbe8253dcbe5cc82af3533a04e0796cad36a5783b2f3c3f53e10b4828db');
/*!40000 ALTER TABLE `testprojects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testsuites`
--

DROP TABLE IF EXISTS `testsuites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testsuites` (
  `id` int(10) unsigned NOT NULL,
  `details` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testsuites`
--

LOCK TABLES `testsuites` WRITE;
/*!40000 ALTER TABLE `testsuites` DISABLE KEYS */;
INSERT INTO `testsuites` VALUES
(2,'Tests covering critical user journeys on the Inspire Brands Franchising home page (TC-H-01 to TC-H-11).'),
(3,'Container suite for all brand-specific page tests.'),
(4,'Tests covering the Arby\'s franchising page (TC-A-01 to TC-A-09). Inherits 12 common brand tests (TC-B-01 to TC-B-12) from AbstractBrandTest.'),
(78,'Shared TCs TC-B-01 to TC-B-12 inherited by every brand test class via AbstractBrandTest');
/*!40000 ALTER TABLE `testsuites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `text_templates`
--

DROP TABLE IF EXISTS `text_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `text_templates` (
  `id` int(10) unsigned NOT NULL,
  `type` smallint(5) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `template_data` text DEFAULT NULL,
  `author_id` int(10) unsigned DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  UNIQUE KEY `idx_text_templates` (`type`,`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Global Project Templates';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `text_templates`
--

LOCK TABLES `text_templates` WRITE;
/*!40000 ALTER TABLE `text_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `text_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entry_point` varchar(45) NOT NULL DEFAULT '',
  `start_time` int(10) unsigned NOT NULL DEFAULT 0,
  `end_time` int(10) unsigned NOT NULL DEFAULT 0,
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `session_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES
(1,'/login.php',1784391892,1784391892,1,'2daccb3c2c96f92933b73a1ace34f83e'),
(2,'/lib/project/projectEdit.php',1784391905,1784391906,1,'2daccb3c2c96f92933b73a1ace34f83e'),
(3,'/login.php',1784392027,1784392027,0,NULL),
(4,'/login.php',1784392069,1784392069,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(5,'/login.php',1784477424,1784477424,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(6,'/lib/testcases/listTestCases.php',1784477652,1784477652,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(7,'/lib/testcases/archiveData.php',1784477652,1784477652,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(8,'/lib/testcases/archiveData.php',1784477661,1784477661,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(9,'/lib/testcases/listTestCases.php',1784477672,1784477672,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(10,'/lib/testcases/archiveData.php',1784477672,1784477672,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(11,'/lib/testcases/listTestCases.php',1784477702,1784477702,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(12,'/lib/testcases/archiveData.php',1784477702,1784477702,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(13,'/lib/testcases/listTestCases.php',1784477733,1784477733,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(14,'/lib/testcases/archiveData.php',1784477733,1784477733,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(15,'/lib/plan/planEdit.php',1784477950,1784477950,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(16,'/lib/execute/execSetResults.php',1784477988,1784477988,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(17,'/lib/testcases/listTestCases.php',1784478029,1784478029,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(18,'/lib/testcases/archiveData.php',1784478029,1784478029,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(19,'/lib/testcases/listTestCases.php',1784482327,1784482327,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(20,'/lib/testcases/archiveData.php',1784482328,1784482328,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(21,'/lib/testcases/archiveData.php',1784482349,1784482349,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(22,'/lib/testcases/listTestCases.php',1784482349,1784482349,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(23,'/lib/plan/planEdit.php',1784482370,1784482370,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(24,'/lib/testcases/listTestCases.php',1784482408,1784482408,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(25,'/lib/testcases/archiveData.php',1784482408,1784482408,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(26,'/lib/plan/planAddTCNavigator.php',1784482435,1784482435,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(27,'/lib/testcases/listTestCases.php',1784484479,1784484479,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(28,'/lib/testcases/archiveData.php',1784484479,1784484479,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(29,'/lib/api/xmlrpc/v1/xmlrpc.php',1784486469,1784486469,1,''),
(30,'/lib/testcases/listTestCases.php',1784486503,1784486503,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(31,'/lib/testcases/archiveData.php',1784486503,1784486503,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(32,'/lib/api/xmlrpc/v1/xmlrpc.php',1784486521,1784486521,1,''),
(33,'/lib/testcases/listTestCases.php',1784486549,1784486549,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(34,'/lib/testcases/archiveData.php',1784486549,1784486549,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(35,'/lib/testcases/listTestCases.php',1784486564,1784486564,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(36,'/lib/testcases/listTestCases.php',1784489291,1784489291,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(37,'/lib/testcases/archiveData.php',1784489291,1784489291,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(38,'/lib/testcases/listTestCases.php',1784489822,1784489822,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(39,'/lib/testcases/archiveData.php',1784489823,1784489823,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(40,'/lib/testcases/listTestCases.php',1784489834,1784489834,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(41,'/lib/plan/planEdit.php',1784490382,1784490382,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(42,'/lib/plan/planEdit.php',1784490387,1784490387,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(43,'/lib/execute/execSetResults.php',1784490437,1784490437,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(44,'/lib/execute/execSetResults.php',1784490442,1784490442,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(45,'/lib/execute/execSetResults.php',1784490449,1784490449,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(46,'/lib/plan/planEdit.php',1784490472,1784490472,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(47,'/lib/plan/planEdit.php',1784490552,1784490552,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(48,'/lib/plan/planEdit.php',1784490554,1784490554,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(49,'/lib/api/xmlrpc/v1/xmlrpc.php',1784490977,1784490977,1,''),
(50,'/lib/api/xmlrpc/v1/xmlrpc.php',1784491185,1784491185,1,''),
(51,'/lib/api/xmlrpc/v1/xmlrpc.php',1784491186,1784491186,1,''),
(52,'/lib/api/xmlrpc/v1/xmlrpc.php',1784491186,1784491186,1,''),
(53,'/lib/api/xmlrpc/v1/xmlrpc.php',1784491186,1784491186,1,''),
(54,'/lib/api/xmlrpc/v1/xmlrpc.php',1784491186,1784491186,1,''),
(55,'/lib/api/xmlrpc/v1/xmlrpc.php',1784491186,1784491186,1,''),
(56,'/lib/api/xmlrpc/v1/xmlrpc.php',1784491186,1784491186,1,''),
(57,'/lib/api/xmlrpc/v1/xmlrpc.php',1784491186,1784491186,1,''),
(58,'/lib/api/xmlrpc/v1/xmlrpc.php',1784491186,1784491186,1,''),
(59,'/lib/execute/execSetResults.php',1784491273,1784491273,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(60,'/lib/execute/execSetResults.php',1784491279,1784491279,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(61,'/lib/execute/execSetResults.php',1784491286,1784491286,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(62,'/lib/execute/execSetResults.php',1784491287,1784491287,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(63,'/lib/execute/execSetResults.php',1784491292,1784491292,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(64,'/lib/execute/execSetResults.php',1784491293,1784491293,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(65,'/lib/execute/execSetResults.php',1784491294,1784491294,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(66,'/lib/execute/execSetResults.php',1784491304,1784491304,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(67,'/lib/execute/execSetResults.php',1784491307,1784491307,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(68,'/lib/execute/execSetResults.php',1784491308,1784491308,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(69,'/lib/execute/execSetResults.php',1784491308,1784491308,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(70,'/lib/execute/execSetResults.php',1784491309,1784491309,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(71,'/lib/execute/execSetResults.php',1784491315,1784491315,1,'129f8b2ba2455d2846ea5754d14c39d5'),
(72,'/login.php',1784958394,1784958394,1,'91a98cabb6473d622181db22d071e3cf'),
(73,'/lib/api/xmlrpc/v1/xmlrpc.php',1784999227,1784999227,1,'');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `tsuites_tree_depth_2`
--

DROP TABLE IF EXISTS `tsuites_tree_depth_2`;
/*!50001 DROP VIEW IF EXISTS `tsuites_tree_depth_2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `tsuites_tree_depth_2` AS SELECT
 NULL AS `prefix`,
 NULL AS `testproject_name`,
 NULL AS `level1_name`,
 NULL AS `level2_name`,
 NULL AS `testproject_id`,
 NULL AS `level1_id`,
 NULL AS `level2_id` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_assignments`
--

DROP TABLE IF EXISTS `user_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_assignments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(10) unsigned NOT NULL DEFAULT 1,
  `feature_id` int(10) unsigned NOT NULL DEFAULT 0,
  `user_id` int(10) unsigned DEFAULT 0,
  `build_id` int(10) unsigned DEFAULT 0,
  `deadline_ts` datetime DEFAULT NULL,
  `assigner_id` int(10) unsigned DEFAULT 0,
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` int(10) unsigned DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `user_assignments_feature_id` (`feature_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_assignments`
--

LOCK TABLES `user_assignments` WRITE;
/*!40000 ALTER TABLE `user_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_group`
--

DROP TABLE IF EXISTS `user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_group` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_group`
--

LOCK TABLES `user_group` WRITE;
/*!40000 ALTER TABLE `user_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_group_assign`
--

DROP TABLE IF EXISTS `user_group_assign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_group_assign` (
  `usergroup_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `idx_user_group_assign` (`usergroup_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_group_assign`
--

LOCK TABLES `user_group_assign` WRITE;
/*!40000 ALTER TABLE `user_group_assign` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_group_assign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_testplan_roles`
--

DROP TABLE IF EXISTS `user_testplan_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_testplan_roles` (
  `user_id` int(10) NOT NULL DEFAULT 0,
  `testplan_id` int(10) NOT NULL DEFAULT 0,
  `role_id` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`,`testplan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_testplan_roles`
--

LOCK TABLES `user_testplan_roles` WRITE;
/*!40000 ALTER TABLE `user_testplan_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_testplan_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_testproject_roles`
--

DROP TABLE IF EXISTS `user_testproject_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_testproject_roles` (
  `user_id` int(10) NOT NULL DEFAULT 0,
  `testproject_id` int(10) NOT NULL DEFAULT 0,
  `role_id` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`,`testproject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_testproject_roles`
--

LOCK TABLES `user_testproject_roles` WRITE;
/*!40000 ALTER TABLE `user_testproject_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_testproject_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `login` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `role_id` int(10) unsigned NOT NULL DEFAULT 0,
  `email` varchar(100) NOT NULL DEFAULT '',
  `first` varchar(50) NOT NULL DEFAULT '',
  `last` varchar(50) NOT NULL DEFAULT '',
  `locale` varchar(10) NOT NULL DEFAULT 'en_GB',
  `default_testproject_id` int(10) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `script_key` varchar(32) DEFAULT NULL,
  `cookie_string` varchar(64) NOT NULL DEFAULT '',
  `auth_method` varchar(10) DEFAULT '',
  `creation_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `expiration_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_login` (`login`),
  UNIQUE KEY `users_cookie_string` (`cookie_string`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='User information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'admin','$2y$10$kGlzfBgeRebSRfIiNuY1LeuYHjQCmF3fywmzfkc638KH.p0BW21eW',8,'','Testlink','Administrator','en_GB',NULL,1,'f005acf9cb7758f6d49dc87e04c6ab5c','4b9de515ac7432bdea84d09d9587788336fac85039658748b55053fba20ae3ea','','2026-07-18 16:24:26',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'testlink'
--

--
-- Current Database: `testlink`
--

USE `testlink`;

--
-- Final view structure for view `exec_by_date_time`
--

/*!50001 DROP VIEW IF EXISTS `exec_by_date_time`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `exec_by_date_time` AS (select `NHTPL`.`name` AS `testplan_name`,date_format(`E`.`execution_ts`,'%Y-%m-%d') AS `yyyy_mm_dd`,date_format(`E`.`execution_ts`,'%Y-%m') AS `yyyy_mm`,date_format(`E`.`execution_ts`,'%H') AS `hh`,date_format(`E`.`execution_ts`,'%k') AS `hour`,`E`.`id` AS `id`,`E`.`build_id` AS `build_id`,`E`.`tester_id` AS `tester_id`,`E`.`execution_ts` AS `execution_ts`,`E`.`status` AS `status`,`E`.`testplan_id` AS `testplan_id`,`E`.`tcversion_id` AS `tcversion_id`,`E`.`tcversion_number` AS `tcversion_number`,`E`.`platform_id` AS `platform_id`,`E`.`execution_type` AS `execution_type`,`E`.`execution_duration` AS `execution_duration`,`E`.`notes` AS `notes` from ((`executions` `E` join `testplans` `TPL` on(`TPL`.`id` = `E`.`testplan_id`)) join `nodes_hierarchy` `NHTPL` on(`NHTPL`.`id` = `TPL`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `latest_exec_by_context`
--

/*!50001 DROP VIEW IF EXISTS `latest_exec_by_context`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `latest_exec_by_context` AS select `executions`.`tcversion_id` AS `tcversion_id`,`executions`.`testplan_id` AS `testplan_id`,`executions`.`build_id` AS `build_id`,`executions`.`platform_id` AS `platform_id`,max(`executions`.`id`) AS `id` from `executions` group by `executions`.`tcversion_id`,`executions`.`testplan_id`,`executions`.`build_id`,`executions`.`platform_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `latest_exec_by_testplan`
--

/*!50001 DROP VIEW IF EXISTS `latest_exec_by_testplan`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `latest_exec_by_testplan` AS select `executions`.`tcversion_id` AS `tcversion_id`,`executions`.`testplan_id` AS `testplan_id`,max(`executions`.`id`) AS `id` from `executions` group by `executions`.`tcversion_id`,`executions`.`testplan_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `latest_exec_by_testplan_plat`
--

/*!50001 DROP VIEW IF EXISTS `latest_exec_by_testplan_plat`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `latest_exec_by_testplan_plat` AS select `executions`.`tcversion_id` AS `tcversion_id`,`executions`.`testplan_id` AS `testplan_id`,`executions`.`platform_id` AS `platform_id`,max(`executions`.`id`) AS `id` from `executions` group by `executions`.`tcversion_id`,`executions`.`testplan_id`,`executions`.`platform_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `latest_req_version`
--

/*!50001 DROP VIEW IF EXISTS `latest_req_version`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `latest_req_version` AS select `RQ`.`id` AS `req_id`,max(`RQV`.`version`) AS `version` from ((`nodes_hierarchy` `NHRQV` join `requirements` `RQ` on(`RQ`.`id` = `NHRQV`.`parent_id`)) join `req_versions` `RQV` on(`RQV`.`id` = `NHRQV`.`id`)) group by `RQ`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `latest_req_version_id`
--

/*!50001 DROP VIEW IF EXISTS `latest_req_version_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `latest_req_version_id` AS select `LRQVN`.`req_id` AS `req_id`,`LRQVN`.`version` AS `version`,`REQV`.`id` AS `req_version_id` from ((`latest_req_version` `LRQVN` join `nodes_hierarchy` `NHRQV` on(`NHRQV`.`parent_id` = `LRQVN`.`req_id`)) join `req_versions` `REQV` on(`REQV`.`id` = `NHRQV`.`id` and `REQV`.`version` = `LRQVN`.`version`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `latest_rspec_revision`
--

/*!50001 DROP VIEW IF EXISTS `latest_rspec_revision`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `latest_rspec_revision` AS select `RSR`.`parent_id` AS `req_spec_id`,`RS`.`testproject_id` AS `testproject_id`,max(`RSR`.`revision`) AS `revision` from (`req_specs_revisions` `RSR` join `req_specs` `RS` on(`RS`.`id` = `RSR`.`parent_id`)) group by `RSR`.`parent_id`,`RS`.`testproject_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `latest_tcase_version_id`
--

/*!50001 DROP VIEW IF EXISTS `latest_tcase_version_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `latest_tcase_version_id` AS select `LTCVN`.`testcase_id` AS `testcase_id`,`LTCVN`.`version` AS `version`,`TCV`.`id` AS `tcversion_id` from ((`latest_tcase_version_number` `LTCVN` join `nodes_hierarchy` `NHTCV` on(`NHTCV`.`parent_id` = `LTCVN`.`testcase_id`)) join `tcversions` `TCV` on(`TCV`.`id` = `NHTCV`.`id` and `TCV`.`version` = `LTCVN`.`version`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `latest_tcase_version_number`
--

/*!50001 DROP VIEW IF EXISTS `latest_tcase_version_number`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `latest_tcase_version_number` AS select `NH_TC`.`id` AS `testcase_id`,max(`TCV`.`version`) AS `version` from ((`nodes_hierarchy` `NH_TC` join `nodes_hierarchy` `NH_TCV` on(`NH_TCV`.`parent_id` = `NH_TC`.`id`)) join `tcversions` `TCV` on(`NH_TCV`.`id` = `TCV`.`id`)) group by `NH_TC`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `tcversions_without_keywords`
--

/*!50001 DROP VIEW IF EXISTS `tcversions_without_keywords`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `tcversions_without_keywords` AS select `NHTCV`.`parent_id` AS `testcase_id`,`NHTCV`.`id` AS `id` from `nodes_hierarchy` `NHTCV` where `NHTCV`.`node_type_id` = 4 and !exists(select 1 from `testcase_keywords` `TCK` where `TCK`.`tcversion_id` = `NHTCV`.`id` limit 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `tcversions_without_platforms`
--

/*!50001 DROP VIEW IF EXISTS `tcversions_without_platforms`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `tcversions_without_platforms` AS select `NHTCV`.`parent_id` AS `testcase_id`,`NHTCV`.`id` AS `id` from `nodes_hierarchy` `NHTCV` where `NHTCV`.`node_type_id` = 4 and !exists(select 1 from `testcase_platforms` `TCPL` where `TCPL`.`tcversion_id` = `NHTCV`.`id` limit 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `tsuites_tree_depth_2`
--

/*!50001 DROP VIEW IF EXISTS `tsuites_tree_depth_2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `tsuites_tree_depth_2` AS select `TPRJ`.`prefix` AS `prefix`,`NHTPRJ`.`name` AS `testproject_name`,`NHTS_L1`.`name` AS `level1_name`,`NHTS_L2`.`name` AS `level2_name`,`NHTPRJ`.`id` AS `testproject_id`,`NHTS_L1`.`id` AS `level1_id`,`NHTS_L2`.`id` AS `level2_id` from (((`testprojects` `TPRJ` join `nodes_hierarchy` `NHTPRJ` on(`TPRJ`.`id` = `NHTPRJ`.`id`)) left join `nodes_hierarchy` `NHTS_L1` on(`NHTS_L1`.`parent_id` = `NHTPRJ`.`id`)) left join `nodes_hierarchy` `NHTS_L2` on(`NHTS_L2`.`parent_id` = `NHTS_L1`.`id`)) where `NHTPRJ`.`node_type_id` = 1 and `NHTS_L1`.`node_type_id` = 2 and `NHTS_L2`.`node_type_id` = 2 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-25 17:09:13
