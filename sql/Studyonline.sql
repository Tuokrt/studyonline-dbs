CREATE DATABASE  IF NOT EXISTS `studyonline` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `studyonline`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: studyonline
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `userName` varchar(255) NOT NULL,
                         `cellPhone` varchar(15) NOT NULL,
                         `userPassword` varchar(255) NOT NULL,
                         `userAvatar` varchar(255) DEFAULT NULL,
                         `createTime` datetime NOT NULL,
                         PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'arclamp','12345678901','123654',NULL,'2025-12-05 21:38:23');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
                            `id` int NOT NULL AUTO_INCREMENT,
                            `name` varchar(255) NOT NULL,
                            PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (4,'math');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
                           `id` int NOT NULL AUTO_INCREMENT,
                           `userId` int NOT NULL,
                           `studyStatusId` int NOT NULL,
                           `commentContent` text NOT NULL,
                           `createTime` datetime NOT NULL,
                           `userName` varchar(255) NOT NULL,
                           `userAvatar` varchar(255) DEFAULT NULL,
                           PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `everyday_status`
--

DROP TABLE IF EXISTS `everyday_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `everyday_status` (
                                   `id` int NOT NULL AUTO_INCREMENT,
                                   `userId` int NOT NULL,
                                   `todayStatus` int NOT NULL DEFAULT '0',
                                   `totalDay` int NOT NULL DEFAULT '0',
                                   `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `everyday_status`
--

LOCK TABLES `everyday_status` WRITE;
/*!40000 ALTER TABLE `everyday_status` DISABLE KEYS */;
INSERT INTO `everyday_status` VALUES (1,1,0,4,'2025-12-04 23:01:07');
/*!40000 ALTER TABLE `everyday_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_time`
--

DROP TABLE IF EXISTS `exam_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_time` (
                             `id` int NOT NULL AUTO_INCREMENT,
                             `userId` int NOT NULL,
                             `examName` varchar(255) NOT NULL,
                             `examTime` datetime NOT NULL,
                             `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_time`
--

LOCK TABLES `exam_time` WRITE;
/*!40000 ALTER TABLE `exam_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_time` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
                          `id` int NOT NULL AUTO_INCREMENT,
                          `adminId` int NOT NULL,
                          `title` varchar(255) NOT NULL,
                          `content` text NOT NULL,
                          `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (1,1,'Notice','Notice Content','2025-12-05 21:57:51');
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
                          `id` int NOT NULL AUTO_INCREMENT,
                          `userId` int NOT NULL,
                          `reportType` int NOT NULL,
                          `beReportedId` int NOT NULL,
                          `reportContent` text NOT NULL,
                          `photo` varchar(255) DEFAULT NULL,
                          `status` int NOT NULL,
                          `createTime` datetime NOT NULL,
                          `updateTime` datetime NOT NULL,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report`
--

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_plan`
--

DROP TABLE IF EXISTS `study_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_plan` (
                              `id` int NOT NULL AUTO_INCREMENT,
                              `userId` int NOT NULL,
                              `content` varchar(255) NOT NULL,
                              `status` int NOT NULL DEFAULT 0,
                              `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_plan`
--

LOCK TABLES `study_plan` WRITE;
/*!40000 ALTER TABLE `study_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `study_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_room`
--

DROP TABLE IF EXISTS `study_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_room` (
                              `id` int NOT NULL AUTO_INCREMENT,
                              `categoryId` int NOT NULL,
                              `userId` int NOT NULL,
                              `roomName` varchar(255) NOT NULL,
                              `roomDescride` text,
                              `roomCover` varchar(255) DEFAULT NULL,
                              `userCard` varchar(18) DEFAULT NULL,
                              `auditStatus` int NOT NULL DEFAULT '0' COMMENT '审核状态',
                              `openStatus` int NOT NULL DEFAULT '0' COMMENT '关闭状态',
                              `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_room`
--

LOCK TABLES `study_room` WRITE;
/*!40000 ALTER TABLE `study_room` DISABLE KEYS */;
INSERT INTO `study_room` VALUES (1,4,1,'数学学自习室','学数学','','111111111111111111',1,1,'2025-12-21 12:22:31');
/*!40000 ALTER TABLE `study_room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_status`
--

DROP TABLE IF EXISTS `study_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_status` (
                                `id` int NOT NULL AUTO_INCREMENT,
                                `userId` int NOT NULL,
                                `userName` varchar(255) NOT NULL,
                                `userAvatar` varchar(255) DEFAULT NULL,
                                `content` text NOT NULL,
                                `firstPhoto` varchar(255) DEFAULT NULL,
                                `secondPhoto` varchar(255) DEFAULT NULL,
                                `thirdPhoto` varchar(255) DEFAULT NULL,
                                `transmitCount` int NOT NULL DEFAULT '0',
                                `commentCount` int NOT NULL DEFAULT '0',
                                `likeCount` int NOT NULL DEFAULT '0',
                                `isLike` tinyint(1) NOT NULL DEFAULT '0',
                                `createTime` datetime NOT NULL,
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_status`
--

LOCK TABLES `study_status` WRITE;
/*!40000 ALTER TABLE `study_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `study_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `like_record`
--

DROP TABLE IF EXISTS `like_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `like_record` (
                             `id` int NOT NULL AUTO_INCREMENT,
                             `userId` int NOT NULL,
                             `studyStatusId` int NOT NULL,
                             `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `unique_like` (`userId`,`studyStatusId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `like_record`
--

LOCK TABLES `like_record` WRITE;
/*!40000 ALTER TABLE `like_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `like_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
                        `id` int NOT NULL AUTO_INCREMENT,
                        `userName` varchar(255) NOT NULL,
                        `cellPhone` varchar(20) NOT NULL,
                        `userPassword` varchar(255) NOT NULL DEFAULT 'psw',
                        `userAvatar` varchar(255) DEFAULT NULL,
                        `gender` int NOT NULL DEFAULT '0',
                        `exp` bigint NOT NULL DEFAULT '0',
                        `rank` int NOT NULL DEFAULT '1',
                        `studyTime` bigint NOT NULL DEFAULT '0',
                        `status` int NOT NULL DEFAULT '0',
                        `banDay` int NOT NULL DEFAULT '0',
                        `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'18826587307','18826587307','1234','user.webp',0,20820,21,1242093,0,0,'2025-12-05 23:01:07');
INSERT INTO `user` VALUES (2,'15024129024','15024129024','1234','user.webp',0,439,13,62,0,0,'2025-12-21 21:00:00');

/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'studyonline'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-21 21:00:47
