-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: campus_health
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ch_ai_assessment`
--

DROP TABLE IF EXISTS `ch_ai_assessment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ch_ai_assessment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `exam_record_id` bigint NOT NULL COMMENT '体检记录ID',
  `assess_status` char(1) COLLATE utf8mb4_general_ci DEFAULT '2' COMMENT '评估状态（0待评估 1评估中 2评估完成）',
  `risk_level` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '辅助风险等级（LOW/MEDIUM/HIGH）',
  `assessment_result` text COLLATE utf8mb4_general_ci COMMENT '评估摘要',
  `abnormal_items` text COLLATE utf8mb4_general_ci COMMENT '异常项目（JSON数组）',
  `suggestions` text COLLATE utf8mb4_general_ci COMMENT '健康建议（JSON数组）',
  `model_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模型名称',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ai_record` (`exam_record_id`),
  KEY `idx_ai_student` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='AI健康评估记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_ai_assessment`
--

LOCK TABLES `ch_ai_assessment` WRITE;
/*!40000 ALTER TABLE `ch_ai_assessment` DISABLE KEYS */;
INSERT INTO `ch_ai_assessment` VALUES (18,1,3,'2','LOW','本次体检未发现异常指标，各项健康数据总体处于正常范围，系统风险等级为低。','[]','[\"保持均衡饮食，控制总热量，多摄入蔬菜、水果和全谷物，适当减少盐和糖的摄入。\",\"坚持规律运动，每周至少进行150分钟中等强度有氧运动，并结合力量训练。\",\"保证充足睡眠，保持规律作息，避免长期熬夜。\"]','recursive/flint-v1.0:free','admin','2026-11-11 18:55:37','admin','2026-11-11 18:59:02','本报告仅供健康管理参考，不能代替医生的专业诊断'),(21,10,13,'2','HIGH','本次体检显示体重超重且血压偏高，系统判定为高风险，建议咨询医生并综合调整饮食、运动与作息。','[{\"item\":\"BMI\",\"value\":\"27.4\",\"reference\":\"成人参考 24-27.9（系统判定为超重）\",\"explanation\":\"数值略高于超重范围，通常提示体重需要进一步控制，可能增加心血管代谢风险。\"},{\"item\":\"血压\",\"value\":\"收缩压145 mmHg，舒张压92 mmHg\",\"reference\":\"收缩压 <140 mmHg，舒张压 <90 mmHg\",\"explanation\":\"血压数值均略高于参考范围，属于血压偏高，需要重视并建议复查。\"}]','[\"减少盐分摄入，避免高盐、高脂、高糖食物，控制总热量，增加蔬菜水果和膳食纤维摄入。\",\"进行规律有氧运动，如每周至少150分钟中等强度运动，如快走、游泳或骑行，同时控制体重。\",\"保证规律作息，7-8小时睡眠，避免熬夜；监测血压和体重，必要时咨询专业医生。\"]','recursive/flint-v1.0:free','admin','2026-11-11 18:58:58','',NULL,'本报告仅供健康管理参考，不能代替医生的专业诊断'),(22,11,14,'2','MEDIUM','学生体检显示体重超标，BMI 为 26.6，超出成人正常范围 24-27.9，属于中风险，需要加强锻炼和饮食控制。','[{\"item\":\"BMI\",\"value\":\"26.6\",\"reference\":\"24-27.9 (成人参考)\",\"explanation\":\"BMI 26.6 高于正常成年人范围 24-27.9，说明体重略高于理想水平，需要通过更多运动和适度减肥来降低风险。\"}]','[\"每天至少 30 分钟有氧运动（如快走、慢跑或骑自行车），帮助消耗多余热量。\",\"合理控制饮食，多吃蔬菜、水果、全谷物，少吃油腻、高盐食物，并考虑咨询专业医生获取个性化指导。\",\"保持规律作息，每晚保证 7-8 小时睡眠，确保身体恢复和代谢正常。\"]','liquid/lfm-3-1.7b:free','admin','2026-11-11 22:29:35','',NULL,'本报告仅供健康管理参考，不能代替医生的专业诊断'),(25,1,1,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(26,1,2,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(27,2,4,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(28,2,5,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(29,3,6,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(30,4,7,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(31,5,8,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(32,6,9,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(33,7,10,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(34,8,11,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(35,9,12,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(36,12,15,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(37,13,16,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(38,14,17,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(39,15,18,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(40,16,19,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(41,17,20,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(42,18,21,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(43,19,22,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(44,20,23,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(45,21,24,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(46,22,25,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(47,23,26,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(48,24,27,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(49,25,28,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(50,26,29,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务'),(51,1,30,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-11 23:13:47','',NULL,'历史体检记录补建待评估任务');
/*!40000 ALTER TABLE `ch_ai_assessment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ch_appointment`
--

DROP TABLE IF EXISTS `ch_appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ch_appointment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `student_id` bigint NOT NULL COMMENT '学生ID（ch_student.id）',
  `batch_id` bigint NOT NULL COMMENT '批次ID（ch_exam_batch.id）',
  `appoint_time` datetime DEFAULT NULL COMMENT '预约提交时间',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0待审核 1已通过 2已拒绝 3已取消）',
  `audit_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '审核人',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `reject_reason` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '拒绝原因',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_batch` (`student_id`,`batch_id`),
  KEY `idx_batch` (`batch_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='体检预约表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_appointment`
--

LOCK TABLES `ch_appointment` WRITE;
/*!40000 ALTER TABLE `ch_appointment` DISABLE KEYS */;
INSERT INTO `ch_appointment` VALUES (1,1,1,'2026-11-05 09:01:00','4','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:01:00','','2026-11-11 23:03:08',''),(2,2,1,'2026-11-05 09:02:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:02:00','',NULL,''),(3,3,1,'2026-11-05 09:03:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:03:00','',NULL,''),(4,4,1,'2026-11-05 09:04:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:04:00','',NULL,''),(5,5,1,'2026-11-05 09:05:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:05:00','',NULL,''),(6,6,1,'2026-11-05 09:06:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:06:00','',NULL,''),(7,7,1,'2026-11-05 09:07:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:07:00','',NULL,''),(8,8,1,'2026-11-05 09:08:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:08:00','',NULL,''),(9,9,1,'2026-11-05 09:09:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:09:00','',NULL,''),(10,10,1,'2026-11-05 09:10:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:10:00','',NULL,''),(11,11,1,'2026-11-05 09:11:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:11:00','',NULL,''),(12,12,1,'2026-11-05 09:12:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:12:00','',NULL,''),(13,13,1,'2026-11-05 09:13:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:13:00','',NULL,''),(14,14,1,'2026-11-05 09:14:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:14:00','',NULL,''),(15,15,1,'2026-11-05 09:15:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:15:00','',NULL,''),(16,16,1,'2026-11-05 09:16:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:16:00','',NULL,''),(17,17,1,'2026-11-05 09:17:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:17:00','',NULL,''),(18,18,1,'2026-11-05 09:18:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:18:00','',NULL,''),(19,19,1,'2026-11-05 09:19:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:19:00','',NULL,''),(20,20,1,'2026-11-05 09:20:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:20:00','',NULL,''),(21,21,1,'2026-11-05 09:21:00','1','校医张医生','2026-11-05 15:00:00','','admin','2026-11-05 09:21:00','',NULL,''),(22,22,2,'2026-11-06 10:22:00','1','校医张医生','2026-11-06 16:00:00','','admin','2026-11-06 10:22:00','',NULL,''),(23,23,2,'2026-11-06 10:23:00','1','校医张医生','2026-11-06 16:00:00','','admin','2026-11-06 10:23:00','',NULL,''),(24,24,2,'2026-11-06 10:24:00','1','校医张医生','2026-11-06 16:00:00','','admin','2026-11-06 10:24:00','',NULL,''),(25,25,2,'2026-11-06 10:25:00','1','校医张医生','2026-11-06 16:00:00','','admin','2026-11-06 10:25:00','',NULL,''),(26,26,2,'2026-11-06 10:26:00','1','校医张医生','2026-11-06 16:00:00','','admin','2026-11-06 10:26:00','',NULL,''),(27,1,3,'2026-11-10 08:30:00','4','doctor01','2026-11-11 22:45:41','','admin','2026-11-10 08:30:00','','2026-11-11 22:45:40',''),(28,2,3,'2026-11-11 22:45:58','0','doctor01','2026-11-11 22:45:58','','admin','2026-11-10 08:45:00','student02','2026-11-11 22:46:04',''),(29,3,3,'2026-11-10 09:10:00','0','',NULL,'','admin','2026-11-10 09:10:00','',NULL,''),(30,4,3,'2026-11-10 09:20:00','0','',NULL,'','admin','2026-11-10 09:20:00','',NULL,''),(31,5,3,'2026-11-09 14:00:00','1','校医张医生','2026-11-10 09:00:00','','admin','2026-11-09 14:00:00','',NULL,''),(32,6,3,'2026-11-09 14:20:00','1','校医张医生','2026-11-10 09:05:00','','admin','2026-11-09 14:20:00','',NULL,''),(33,7,3,'2026-11-10 10:00:00','2','校医张医生','2026-11-10 11:00:00','该时段名额已满，请改约其他批次','admin','2026-11-10 10:00:00','',NULL,''),(34,8,3,'2026-11-10 10:30:00','3','',NULL,'','admin','2026-11-10 10:30:00','',NULL,'学生自行取消');
/*!40000 ALTER TABLE `ch_appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ch_exam_batch`
--

DROP TABLE IF EXISTS `ch_exam_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ch_exam_batch` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '批次ID',
  `batch_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次名称',
  `exam_date` date DEFAULT NULL COMMENT '体检日期',
  `location` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '体检地点',
  `capacity` int DEFAULT '0' COMMENT '名额上限',
  `booked_count` int DEFAULT '0' COMMENT '已预约人数',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0未开始 1预约中 2已结束）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_batch_name` (`batch_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='体检批次表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_exam_batch`
--

LOCK TABLES `ch_exam_batch` WRITE;
/*!40000 ALTER TABLE `ch_exam_batch` DISABLE KEYS */;
INSERT INTO `ch_exam_batch` VALUES (1,'2026年秋季体检第一批','2026-11-08','校医院体检中心',100,21,'2','admin','2026-11-11 18:31:03','',NULL,NULL),(2,'2026年秋季体检补检批次','2026-11-09','校医院体检中心',5,5,'2','admin','2026-11-11 18:31:03','',NULL,NULL),(3,'2026年秋季体检第二批','2026-11-25','校医院体检中心',200,3,'1','admin','2026-11-11 18:31:03','',NULL,NULL);
/*!40000 ALTER TABLE `ch_exam_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ch_exam_item`
--

DROP TABLE IF EXISTS `ch_exam_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ch_exam_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '项目ID',
  `item_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目编码（唯一）',
  `item_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目名称',
  `category` char(1) COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '项目分类（字典 ch_exam_category）',
  `unit` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '计量单位',
  `field_key` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '对应体检记录字段名（用于异常判定取值）',
  `reference_min` decimal(10,2) DEFAULT NULL COMMENT '参考下限（空表示不限）',
  `reference_max` decimal(10,2) DEFAULT NULL COMMENT '参考上限（空表示不限）',
  `abnormal_rule` char(1) COLLATE utf8mb4_general_ci DEFAULT '3' COMMENT '异常判定（0高于上限 1低于下限 2超出任一 3仅展示）',
  `description` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '项目说明',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0启用 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_item_code` (`item_code`),
  KEY `idx_field_key` (`field_key`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='体检项目表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_exam_item`
--

LOCK TABLES `ch_exam_item` WRITE;
/*!40000 ALTER TABLE `ch_exam_item` DISABLE KEYS */;
INSERT INTO `ch_exam_item` VALUES (1,'HGT-HEIGHT','身高','1','cm','height',NULL,NULL,'3','生长发育指标，单独一个数值没有正常/异常之分，仅记录','0','admin','2026-11-11 22:13:04','',NULL,''),(2,'HGT-WEIGHT','体重','1','kg','weight',NULL,NULL,'3','需结合身高计算 BMI 才有判断意义，体重本身不单独判定','0','admin','2026-11-11 22:13:04','',NULL,''),(3,'HGT-BMI','BMI','1','kg/m²','bmi',18.50,23.90,'0','中国成人标准：偏低<18.5 正常18.5-23.9 超重24-27.9 肥胖≥28；超上限判为异常','0','admin','2026-11-11 22:13:04','admin','2026-11-11 22:19:48',''),(4,'CIR-SBP','收缩压','2','mmHg','systolic_pressure',90.00,139.00,'0','成人参考 90-139mmHg，≥140 判为偏高','0','admin','2026-11-11 22:13:04','',NULL,''),(5,'CIR-DBP','舒张压','2','mmHg','diastolic_pressure',60.00,89.00,'0','成人参考 60-89mmHg，≥90 判为偏高','0','admin','2026-11-11 22:13:04','',NULL,''),(6,'CIR-PULSE','脉搏','2','次/分','pulse_rate',60.00,100.00,'3','成人静息参考 60-100次/分；运动后偏高属正常，默认仅展示不判定','0','admin','2026-11-11 22:13:04','',NULL,''),(7,'EYE-VL','左眼视力','3','','vision_left',5.00,NULL,'3','对数视力表 5.0 为正常；近视矫正情况因人而异，默认仅展示不判定','0','admin','2026-11-11 22:13:04','',NULL,''),(8,'EYE-VR','右眼视力','3','','vision_right',5.00,NULL,'3','对数视力表 5.0 为正常；近视矫正情况因人而异，默认仅展示不判定','0','admin','2026-11-11 22:13:04','',NULL,'');
/*!40000 ALTER TABLE `ch_exam_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ch_exam_record`
--

DROP TABLE IF EXISTS `ch_exam_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ch_exam_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `student_id` bigint NOT NULL COMMENT '学生ID（关联ch_student.id）',
  `batch_id` bigint DEFAULT NULL,
  `exam_date` date DEFAULT NULL COMMENT '体检日期',
  `height` decimal(5,1) DEFAULT NULL COMMENT '身高(cm)',
  `weight` decimal(5,1) DEFAULT NULL COMMENT '体重(kg)',
  `bmi` decimal(4,1) DEFAULT NULL COMMENT 'BMI指数（自动计算）',
  `bmi_level` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT 'BMI等级（0偏低 1正常 2超重 3肥胖）',
  `systolic_pressure` int DEFAULT NULL COMMENT '收缩压(mmHg)',
  `diastolic_pressure` int DEFAULT NULL COMMENT '舒张压(mmHg)',
  `pulse_rate` int DEFAULT NULL COMMENT '脉搏(次/分)',
  `vision_left` decimal(3,1) DEFAULT NULL COMMENT '左眼视力',
  `vision_right` decimal(3,1) DEFAULT NULL COMMENT '右眼视力',
  `abnormal_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0',
  `record_status` char(1) COLLATE utf8mb4_general_ci DEFAULT '2' COMMENT '记录状态（0未登记 1录入中 2已完成）',
  `conclusion` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '体检小结',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_date` (`student_id`,`exam_date`),
  KEY `idx_er_batch` (`batch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='体检记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_exam_record`
--

LOCK TABLES `ch_exam_record` WRITE;
/*!40000 ALTER TABLE `ch_exam_record` DISABLE KEYS */;
INSERT INTO `ch_exam_record` VALUES (1,1,NULL,'2024-11-08',168.0,55.0,19.5,'1',112,72,74,5.0,4.9,'0','2','历年体检，各项指标正常','admin','2026-11-11 18:31:03','','2026-11-11 22:19:48',NULL),(2,1,NULL,'2025-11-08',169.0,60.0,21.0,'1',116,75,76,5.0,5.0,'0','2','历年体检，各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(3,1,1,'2026-11-08',170.0,65.0,22.5,'1',120,78,78,5.0,5.0,'0','2','各项指标正常，继续保持规律作息','admin','2026-11-11 18:31:03','',NULL,NULL),(4,2,NULL,'2025-11-08',160.0,64.0,25.0,'2',118,76,80,4.8,4.8,'1','2','体重略偏高，建议增加运动','admin','2026-11-11 18:31:03','',NULL,NULL),(5,2,1,'2026-11-08',160.0,75.0,29.3,'3',132,88,82,4.8,4.7,'1','2','BMI 偏高，建议控制饮食并加强锻炼','admin','2026-11-11 18:31:03','',NULL,NULL),(6,3,1,'2026-11-08',178.0,58.0,18.3,'0',115,74,70,4.9,4.9,'0','2','偏瘦，建议加强营养','admin','2026-11-11 18:31:03','',NULL,NULL),(7,4,1,'2026-11-08',175.0,82.0,26.8,'2',128,82,76,4.9,4.9,'1','2','超重，建议加强有氧运动','admin','2026-11-11 18:31:03','',NULL,NULL),(8,5,1,'2026-11-08',172.0,90.0,30.4,'3',135,86,84,4.9,4.9,'1','2','肥胖，建议控制饮食并逐步增加运动量','admin','2026-11-11 18:31:03','',NULL,NULL),(9,6,1,'2026-11-08',163.0,48.0,18.1,'0',108,68,72,4.9,4.9,'0','2','偏瘦，注意均衡饮食','admin','2026-11-11 18:31:03','',NULL,NULL),(10,7,1,'2026-11-08',180.0,78.0,24.1,'2',126,80,74,4.9,4.9,'1','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(11,8,1,'2026-11-08',168.0,70.0,24.8,'2',122,79,76,4.9,4.9,'1','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(12,9,1,'2026-11-08',170.0,68.0,23.5,'1',118,76,72,4.9,4.9,'0','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(13,10,1,'2026-11-08',176.0,85.0,27.4,'2',145,92,88,4.9,4.9,'1','2','血压偏高、超重，建议复查血压并控制体重','admin','2026-11-11 18:31:03','',NULL,NULL),(14,11,1,'2026-11-08',182.0,88.0,26.6,'2',130,84,78,4.9,4.9,'1','2','超重，建议加强锻炼','admin','2026-11-11 18:31:03','',NULL,NULL),(15,12,1,'2026-11-08',165.0,56.0,20.6,'1',110,70,70,4.9,4.9,'0','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(16,13,1,'2026-11-08',177.0,60.0,19.2,'1',142,90,80,4.9,4.9,'1','2','血压偏高，建议安静休息后复测','admin','2026-11-11 18:31:03','',NULL,NULL),(17,14,1,'2026-11-08',171.0,72.0,24.6,'2',120,78,74,4.9,4.9,'1','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(18,15,1,'2026-11-08',174.0,95.0,31.4,'3',138,88,86,4.9,4.9,'1','2','肥胖，建议到校医院营养门诊咨询','admin','2026-11-11 18:31:03','',NULL,NULL),(19,16,1,'2026-11-08',160.0,62.0,24.2,'2',116,74,76,4.9,4.9,'1','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(20,17,1,'2026-11-08',179.0,74.0,23.1,'1',124,80,72,4.9,4.9,'0','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(21,18,1,'2026-11-08',166.0,66.0,24.0,'1',118,76,74,4.9,4.9,'0','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(22,19,1,'2026-11-08',183.0,80.0,23.9,'1',128,82,78,4.9,4.9,'0','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(23,20,1,'2026-11-08',169.0,86.0,30.1,'3',133,86,84,4.9,4.9,'1','2','超重，建议控制饮食','admin','2026-11-11 18:31:03','',NULL,NULL),(24,21,1,'2026-11-08',172.0,71.0,24.0,'1',121,78,74,4.9,4.9,'0','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(25,22,2,'2026-11-09',170.0,84.0,29.1,'3',130,84,80,4.8,4.8,'1','2','超重，建议加强运动','admin','2026-11-11 18:31:03','',NULL,NULL),(26,23,2,'2026-11-09',175.0,93.0,30.4,'3',136,88,85,4.8,4.8,'1','2','肥胖，建议制定减重计划','admin','2026-11-11 18:31:03','',NULL,NULL),(27,24,2,'2026-11-09',168.0,69.0,24.4,'2',120,78,74,4.8,4.8,'1','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(28,25,2,'2026-11-09',176.0,73.0,23.6,'1',122,80,72,4.8,4.8,'0','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(29,26,2,'2026-11-09',164.0,60.0,22.3,'1',116,74,76,4.8,4.8,'0','2','各项指标正常','admin','2026-11-11 18:31:03','',NULL,NULL),(30,1,3,'2026-11-18',172.0,66.0,22.3,'1',118,76,72,5.0,5.0,'0','2','本次体检各项指标正常，建议保持规律作息','','2026-11-11 22:45:41','',NULL,NULL);
/*!40000 ALTER TABLE `ch_exam_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ch_health_archive`
--

DROP TABLE IF EXISTS `ch_health_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ch_health_archive` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `total_exam_count` int DEFAULT '0' COMMENT '体检次数',
  `last_exam_date` date DEFAULT NULL COMMENT '最近体检日期',
  `health_summary` text COMMENT '健康摘要',
  `archive_status` char(1) DEFAULT '0' COMMENT '档案状态（0正常 1存在异常）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='健康档案表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_health_archive`
--

LOCK TABLES `ch_health_archive` WRITE;
/*!40000 ALTER TABLE `ch_health_archive` DISABLE KEYS */;
INSERT INTO `ch_health_archive` VALUES (1,1,4,'2026-11-18','累计体检 4 次，最近一次 2026-11-18。BMI 22.3（正常）；血压 118/76 mmHg；脉搏 72 次/分；视力 5.0/5.0；本次未发现异常指标。体检小结：本次体检各项指标正常，建议保持规律作息','0','admin','2026-11-11 22:56:09','admin','2026-11-11 23:04:43',NULL),(2,2,2,'2026-11-08','累计体检 2 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(3,3,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(4,4,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(5,5,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(6,6,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(7,7,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(8,8,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(9,9,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(10,10,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(11,11,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(12,12,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(13,13,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(14,14,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(15,15,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(16,16,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(17,17,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(18,18,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(19,19,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(20,20,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(21,21,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(22,22,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(23,23,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(24,24,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09；最近一次存在异常指标','1','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(25,25,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL),(26,26,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09；最近一次各项指标正常','0','admin','2026-11-11 22:56:09','','2026-11-11 22:56:09',NULL);
/*!40000 ALTER TABLE `ch_health_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ch_student`
--

DROP TABLE IF EXISTS `ch_student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ch_student` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint DEFAULT NULL COMMENT '关联若依用户ID',
  `student_no` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '学号',
  `student_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `gender` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '性别（0男 1女 2未知）',
  `birthday` date DEFAULT NULL COMMENT '出生日期',
  `college` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '学院',
  `major` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '专业',
  `class_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '班级',
  `dept_id` bigint DEFAULT NULL COMMENT '归属部门（班级）',
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '联系电话',
  `enroll_year` varchar(4) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '入学年份',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_no` (`student_no`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='学生信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_student`
--

LOCK TABLES `ch_student` WRITE;
/*!40000 ALTER TABLE `ch_student` DISABLE KEYS */;
INSERT INTO `ch_student` VALUES (1,5,'20260001','张伟','0','2006-02-02','软件技术学院','软件技术','软件2401',120,'13810000137','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(2,6,'20260002','李娜','1','2006-03-03','软件技术学院','软件技术','软件2402',121,'13810000274','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(3,NULL,'20260003','王强','0','2006-04-04','计算机学院','计算机应用技术','计应2401',122,'13810000411','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(4,NULL,'20260004','刘洋','1','2006-05-05','信息工程学院','大数据技术','大数据2401',123,'13810000548','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(5,NULL,'20260005','陈静','0','2006-06-06','智能制造学院','机电一体化','机电2401',124,'13810000685','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(6,NULL,'20260006','杨帆','1','2006-07-07','软件技术学院','软件技术','软件2401',120,'13810000822','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(7,NULL,'20260007','赵敏','0','2006-08-08','软件技术学院','软件技术','软件2402',121,'13810000959','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(8,NULL,'20260008','黄磊','1','2006-09-09','计算机学院','计算机应用技术','计应2401',122,'13810001096','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(9,NULL,'20260009','周鑫','0','2006-10-10','信息工程学院','大数据技术','大数据2401',123,'13810001233','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(10,NULL,'20260010','吴倩','1','2006-11-11','智能制造学院','机电一体化','机电2401',124,'13810001370','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(11,NULL,'20260011','徐鹏','0','2006-12-12','软件技术学院','软件技术','软件2401',120,'13810001507','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(12,NULL,'20260012','孙悦','1','2006-01-13','软件技术学院','软件技术','软件2402',121,'13810001644','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(13,NULL,'20260013','马超','0','2006-02-14','计算机学院','计算机应用技术','计应2401',122,'13810001781','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(14,NULL,'20260014','朱婷','1','2006-03-15','信息工程学院','大数据技术','大数据2401',123,'13810001918','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(15,NULL,'20260015','胡军','0','2006-04-16','智能制造学院','机电一体化','机电2401',124,'13810002055','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(16,NULL,'20260016','郭雪','1','2006-05-17','软件技术学院','软件技术','软件2401',120,'13810002192','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(17,NULL,'20260017','何俊','0','2006-06-18','软件技术学院','软件技术','软件2402',121,'13810002329','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(18,NULL,'20260018','高峰','1','2006-07-19','计算机学院','计算机应用技术','计应2401',122,'13810002466','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(19,NULL,'20260019','林琳','0','2006-08-20','信息工程学院','大数据技术','大数据2401',123,'13810002603','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(20,NULL,'20260020','罗浩','1','2006-09-21','智能制造学院','机电一体化','机电2401',124,'13810002740','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(21,NULL,'20260021','梁爽','0','2006-10-22','软件技术学院','软件技术','软件2401',120,'13810002877','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(22,NULL,'20260022','宋涛','1','2006-11-23','软件技术学院','软件技术','软件2402',121,'13810003014','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(23,NULL,'20260023','唐颖','0','2006-12-24','计算机学院','计算机应用技术','计应2401',122,'13810003151','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(24,NULL,'20260024','许诺','1','2006-01-25','信息工程学院','大数据技术','大数据2401',123,'13810003288','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(25,NULL,'20260025','韩雨','0','2006-02-26','智能制造学院','机电一体化','机电2401',124,'13810003425','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(26,NULL,'20260026','冯磊','1','2006-03-27','软件技术学院','软件技术','软件2401',120,'13810003562','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(27,NULL,'20260027','邓佳','0','2006-04-01','软件技术学院','软件技术','软件2402',121,'13810003699','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(28,NULL,'20260028','曹阳','1','2006-05-02','计算机学院','计算机应用技术','计应2401',122,'13810003836','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL);
/*!40000 ALTER TABLE `ch_student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) COLLATE utf8mb4_general_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int DEFAULT '1' COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
INSERT INTO `gen_table` VALUES (1,'ch_student','学生信息表',NULL,NULL,'Student','crud','element-plus','com.ruoyi.health','health','student','学生信息','ruoyi',1,'0','/','{\"genView\":\"0\",\"parentMenuId\":2000}','admin','2026-11-10 20:36:17','','2026-11-10 20:46:18',NULL),(2,'ch_exam_record','体检记录表',NULL,NULL,'ExamRecord','crud','element-plus','com.ruoyi.health','health','examRecord','体检记录','shang',1,'0','/','{\"genView\":\"0\",\"parentMenuId\":2000}','admin','2026-11-10 23:36:09','','2026-11-11 16:15:13',NULL),(3,'ch_exam_batch','体检批次表',NULL,NULL,'ExamBatch','crud','element-plus','com.ruoyi.health','health','examBatch','体检批次','shang',1,'0','/','{\"genView\":\"0\",\"parentMenuId\":2000}','admin','2026-11-11 16:20:12','','2026-11-11 16:22:45',NULL),(4,'ch_appointment','体检预约表',NULL,NULL,'Appointment','crud','element-plus','com.ruoyi.health','health','appointment','体检预约','shang',1,'0','/','{\"genView\":\"0\",\"parentMenuId\":2000}','admin','2026-11-11 16:30:54','','2026-11-11 16:38:26',NULL);
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) COLLATE utf8mb4_general_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
INSERT INTO `gen_table_column` VALUES (1,1,'id','主键','bigint','Long','id','1','1','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(2,1,'user_id','关联若依用户ID','bigint','Long','userId','0','0','0','1','1','1','0','EQ','input','',2,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(3,1,'student_no','学号','varchar(30)','String','studentNo','0','0','1','1','1','1','1','EQ','input','',3,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(4,1,'student_name','姓名','varchar(50)','String','studentName','0','0','1','1','1','1','1','LIKE','input','',4,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(5,1,'gender','性别（0男 1女 2未知）','char(1)','String','gender','0','0','0','1','1','1','0','EQ','input','',5,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(6,1,'birthday','出生日期','date','Date','birthday','0','0','0','1','1','1','0','EQ','datetime','',6,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(7,1,'college','学院','varchar(100)','String','college','0','0','0','1','1','1','1','EQ','input','',7,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(8,1,'major','专业','varchar(100)','String','major','0','0','0','1','1','1','1','EQ','input','',8,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(9,1,'class_name','班级','varchar(100)','String','className','0','0','0','1','1','1','1','LIKE','input','',9,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(10,1,'phone','联系电话','varchar(20)','String','phone','0','0','0','1','1','1','1','EQ','input','',10,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(11,1,'status','状态（0正常 1停用）','char(1)','String','status','0','0','0','1','1','1','0','EQ','radio','',11,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(12,1,'create_by','创建者','varchar(64)','String','createBy','0','0','0','1',NULL,NULL,NULL,'EQ','input','',12,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(13,1,'create_time','创建时间','datetime','Date','createTime','0','0','0','1',NULL,NULL,NULL,'EQ','datetime','',13,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(14,1,'update_by','更新者','varchar(64)','String','updateBy','0','0','0','1','1',NULL,NULL,'EQ','input','',14,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(15,1,'update_time','更新时间','datetime','Date','updateTime','0','0','0','1','1',NULL,NULL,'EQ','datetime','',15,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(16,1,'remark','备注','varchar(500)','String','remark','0','0','0','1','1','1',NULL,'EQ','textarea','',16,'admin','2026-11-10 20:36:17','','2026-11-10 20:46:18'),(17,2,'id','记录ID','bigint','Long','id','1','1','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(18,2,'student_id','学生ID（关联ch_student.id）','bigint','Long','studentId','0','0','1','1','1','1','1','EQ','input','',2,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(19,2,'exam_date','体检日期','date','Date','examDate','0','0','0','1','1','1','1','EQ','datetime','',3,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(20,2,'height','身高(cm)','decimal(5,1)','BigDecimal','height','0','0','0','1','1','1','0','EQ','input','',4,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(21,2,'weight','体重(kg)','decimal(5,1)','BigDecimal','weight','0','0','0','1','1','1','0','EQ','input','',5,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(22,2,'bmi','BMI指数（自动计算）','decimal(4,1)','BigDecimal','bmi','0','0','0','0','0','1','0','EQ','input','',6,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(23,2,'bmi_level','BMI等级（0偏低 1正常 2超重 3肥胖）','char(1)','String','bmiLevel','0','0','0','0','0','1','0','EQ','select','ch_bmi_level',7,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(24,2,'systolic_pressure','收缩压(mmHg)','int','Long','systolicPressure','0','0','0','1','1','1','0','EQ','input','',8,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(25,2,'diastolic_pressure','舒张压(mmHg)','int','Long','diastolicPressure','0','0','0','1','1','1','0','EQ','input','',9,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(26,2,'pulse_rate','脉搏(次/分)','int','Long','pulseRate','0','0','0','1','1','1','0','EQ','input','',10,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(27,2,'vision_left','左眼视力','decimal(3,1)','BigDecimal','visionLeft','0','0','0','1','1','1','0','EQ','input','',11,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(28,2,'vision_right','右眼视力','decimal(3,1)','BigDecimal','visionRight','0','0','0','1','1','1','0','EQ','input','',12,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(29,2,'conclusion','体检小结','varchar(200)','String','conclusion','0','0','0','1','1','1','0','EQ','textarea','',13,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(30,2,'create_by','创建者','varchar(64)','String','createBy','0','0','0','1',NULL,NULL,NULL,'EQ','input','',14,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(31,2,'create_time','创建时间','datetime','Date','createTime','0','0','0','1',NULL,NULL,NULL,'EQ','datetime','',15,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(32,2,'update_by','更新者','varchar(64)','String','updateBy','0','0','0','1','1',NULL,NULL,'EQ','input','',16,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(33,2,'update_time','更新时间','datetime','Date','updateTime','0','0','0','1','1',NULL,NULL,'EQ','datetime','',17,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(34,2,'remark','备注','varchar(500)','String','remark','0','0','0','1','1','1',NULL,'EQ','textarea','',18,'admin','2026-11-10 23:36:09','','2026-11-11 16:15:13'),(35,3,'id','批次ID','bigint','Long','id','1','1','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(36,3,'batch_name','批次名称','varchar(100)','String','batchName','0','0','1','1','1','1','1','LIKE','input','',2,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(37,3,'exam_date','体检日期','date','Date','examDate','0','0','0','1','1','1','1','EQ','datetime','',3,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(38,3,'location','体检地点','varchar(100)','String','location','0','0','0','1','1','1','1','EQ','input','',4,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(39,3,'capacity','名额上限','int','Long','capacity','0','0','0','1','1','1','1','EQ','input','',5,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(40,3,'booked_count','已预约人数','int','Long','bookedCount','0','0','0','1','1','1','1','EQ','input','',6,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(41,3,'status','状态（0未开始 1预约中 2已结束）','char(1)','String','status','0','0','0','1','1','1','1','EQ','select','',7,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(42,3,'create_by','创建者','varchar(64)','String','createBy','0','0','0','1',NULL,NULL,NULL,'EQ','input','',8,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(43,3,'create_time','创建时间','datetime','Date','createTime','0','0','0','1',NULL,NULL,NULL,'EQ','datetime','',9,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(44,3,'update_by','更新者','varchar(64)','String','updateBy','0','0','0','1','1',NULL,NULL,'EQ','input','',10,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(45,3,'update_time','更新时间','datetime','Date','updateTime','0','0','0','1','1',NULL,NULL,'EQ','datetime','',11,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(46,3,'remark','备注','varchar(500)','String','remark','0','0','0','1','1','1',NULL,'EQ','textarea','',12,'admin','2026-11-11 16:20:12','','2026-11-11 16:22:45'),(47,4,'id','预约ID','bigint','Long','id','1','1','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(48,4,'student_id','学生ID（ch_student.id）','bigint','Long','studentId','0','0','1','1','1','1','1','EQ','input','',2,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(49,4,'batch_id','批次ID（ch_exam_batch.id）','bigint','Long','batchId','0','0','1','1','1','1','1','EQ','input','',3,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(50,4,'appoint_time','预约提交时间','datetime','Date','appointTime','0','0','0','0','1','1','1','EQ','datetime','',4,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(51,4,'status','状态（0待审核 1已通过 2已拒绝 3已取消）','char(1)','String','status','0','0','0','1','1','1','1','EQ','select','ch_appoint_status',5,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(52,4,'audit_by','审核人','varchar(64)','String','auditBy','0','0','0','0','0','1','1','EQ','input','',6,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(53,4,'audit_time','审核时间','datetime','Date','auditTime','0','0','0','0','0','1','1','EQ','datetime','',7,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(54,4,'reject_reason','拒绝原因','varchar(255)','String','rejectReason','0','0','0','0','0','1','1','EQ','textarea','',8,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(55,4,'create_by','创建者','varchar(64)','String','createBy','0','0','0','0',NULL,NULL,NULL,'EQ','input','',9,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(56,4,'create_time','创建时间','datetime','Date','createTime','0','0','0','0',NULL,NULL,NULL,'EQ','datetime','',10,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(57,4,'update_by','更新者','varchar(64)','String','updateBy','0','0','0','0','1',NULL,NULL,'EQ','input','',11,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(58,4,'update_time','更新时间','datetime','Date','updateTime','0','0','0','0','1',NULL,NULL,'EQ','datetime','',12,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26'),(59,4,'remark','备注','varchar(500)','String','remark','0','0','0','0','1','1',NULL,'EQ','textarea','',13,'admin','2026-11-11 16:30:54','','2026-11-11 16:38:26');
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-11-10 17:10:46','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-11-10 17:10:46','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-11-10 17:10:46','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-11-10 17:10:46','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2026-11-10 17:10:46','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-11-10 17:10:46','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2026-11-10 17:10:46','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2026-11-10 17:10:46','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框'),(9,'用户管理-密码字符范围','sys.account.chrtype','0','Y','admin','2026-11-10 17:10:46','',NULL,'默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','若依科技',0,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(101,100,'0,100','深圳总公司',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(102,100,'0,100','长沙分公司',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(103,101,'0,100,101','研发部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(104,101,'0,100,101','市场部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(105,101,'0,100,101','测试部门',3,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(106,101,'0,100,101','财务部门',4,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(107,101,'0,100,101','运维部门',5,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-11-10 17:10:45','',NULL),(110,100,'0,100','校医院',1,'王医生','07558800101','clinic@campus.edu.cn','0','0','admin','2026-11-11 22:39:42','',NULL),(111,100,'0,100','软件学院',2,'李老师','07558800202','soft@campus.edu.cn','0','0','admin','2026-11-11 22:39:42','',NULL),(120,111,'0,100,111','软件2401',1,'李老师','','','0','0','admin','2026-11-11 22:56:09','',NULL),(121,111,'0,100,111','软件2402',2,'','','','0','0','admin','2026-11-11 22:56:09','',NULL),(122,111,'0,100,111','计应2401',3,'','','','0','0','admin','2026-11-11 22:56:09','',NULL),(123,111,'0,100,111','大数据2401',4,'','','','0','0','admin','2026-11-11 22:56:09','',NULL),(124,111,'0,100,111','机电2401',5,'','','','0','0','admin','2026-11-11 22:56:09','',NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2026-11-10 17:10:46','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2026-11-10 17:10:46','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-11-10 17:10:46','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-11-10 17:10:46','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-11-10 17:10:46','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-11-10 17:10:46','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-11-10 17:10:46','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-11-10 17:10:46','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-11-10 17:10:46','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-11-10 17:10:46','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-11-10 17:10:46','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-11-10 17:10:46','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-11-10 17:10:46','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-11-10 17:10:46','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-11-10 17:10:46','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-11-10 17:10:46','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-11-10 17:10:46','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-11-10 17:10:46','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-11-10 17:10:46','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-11-10 17:10:46','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-11-10 17:10:46','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-11-10 17:10:46','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-11-10 17:10:46','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-11-10 17:10:46','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-11-10 17:10:46','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-11-10 17:10:46','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-11-10 17:10:46','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-11-10 17:10:46','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-11-10 17:10:46','',NULL,'停用状态'),(100,1,'男','0','ch_sex','','default','Y','0','admin','2026-11-10 20:58:24','',NULL,'男生'),(101,2,'女','1','ch_sex','','default','N','0','admin','2026-11-10 20:58:24','',NULL,'女生'),(102,1,'偏低','0','ch_bmi_level','','warning','N','0','admin','2026-11-10 23:32:38','',NULL,'BMI<18.5'),(103,2,'正常','1','ch_bmi_level','','success','Y','0','admin','2026-11-10 23:32:38','',NULL,'18.5-23.9'),(104,3,'超重','2','ch_bmi_level','','primary','N','0','admin','2026-11-10 23:32:38','',NULL,'24-27.9'),(105,4,'肥胖','3','ch_bmi_level','','danger','N','0','admin','2026-11-10 23:32:38','',NULL,'>=28'),(106,1,'未开始','0','ch_batch_status','','info','N','0','admin','2026-11-11 16:19:52','',NULL,'尚未开放预约'),(107,2,'预约中','1','ch_batch_status','','primary','Y','0','admin','2026-11-11 16:19:52','',NULL,'可正常预约'),(108,3,'已结束','2','ch_batch_status','','danger','N','0','admin','2026-11-11 16:19:52','',NULL,'已停止预约'),(109,1,'待审核','0','ch_appoint_status','','info','Y','0','admin','2026-11-11 16:30:38','',NULL,'学生已提交，等待校医审核'),(110,2,'已预约','1','ch_appoint_status','','primary','N','0','admin','2026-11-11 16:30:38','',NULL,'校医审核通过，可参加体检'),(111,3,'已拒绝','2','ch_appoint_status','','danger','N','0','admin','2026-11-11 16:30:38','',NULL,'校医审核拒绝，需填写原因'),(112,4,'已取消','3','ch_appoint_status','','warning','N','0','admin','2026-11-11 16:30:38','',NULL,'学生主动取消'),(113,1,'低风险','LOW','ch_risk_level','','success','Y','0','admin','2026-11-11 18:25:00','',NULL,'指标均在参考范围内'),(114,2,'中风险','MEDIUM','ch_risk_level','','warning','N','0','admin','2026-11-11 18:25:00','',NULL,'存在单项指标偏离'),(115,3,'高风险','HIGH','ch_risk_level','','danger','N','0','admin','2026-11-11 18:25:00','',NULL,'存在多项异常或明显偏离'),(116,1,'一般检查','1','ch_exam_category','','primary','Y','0','admin','2026-11-11 22:13:04','',NULL,'身高、体重、BMI'),(117,2,'循环系统','2','ch_exam_category','','success','N','0','admin','2026-11-11 22:13:04','',NULL,'血压、脉搏'),(118,3,'眼科','3','ch_exam_category','','warning','N','0','admin','2026-11-11 22:13:04','',NULL,'视力'),(119,9,'其他','9','ch_exam_category','','info','N','0','admin','2026-11-11 22:13:04','',NULL,'其他检查项目'),(120,1,'高于上限算异常','0','ch_abnormal_rule','','danger','Y','0','admin','2026-11-11 22:13:04','',NULL,'如血压、BMI'),(121,2,'低于下限算异常','1','ch_abnormal_rule','','warning','N','0','admin','2026-11-11 22:13:04','',NULL,'如血红蛋白偏低'),(122,3,'超出上下限算异常','2','ch_abnormal_rule','','danger','N','0','admin','2026-11-11 22:13:04','',NULL,'偏差两个方向都算异常'),(123,4,'仅展示不判定','3','ch_abnormal_rule','','info','N','0','admin','2026-11-11 22:13:04','',NULL,'需结合人群/年龄判断的项目'),(125,5,'已完成','4','ch_appoint_status','','success','N','0','admin','2026-11-11 22:39:42','',NULL,'已录入体检记录，流程结束'),(126,1,'未登记','0','ch_record_status','','warning','N','0','admin','2026-11-11 22:56:09','',NULL,''),(127,2,'录入中','1','ch_record_status','','info','N','0','admin','2026-11-11 22:56:09','',NULL,''),(128,3,'已完成','2','ch_record_status','','success','Y','0','admin','2026-11-11 22:56:09','',NULL,''),(129,1,'待评估','0','ch_assess_status','','warning','N','0','admin','2026-11-11 22:56:09','',NULL,''),(130,2,'评估中','1','ch_assess_status','','info','N','0','admin','2026-11-11 22:56:09','',NULL,''),(131,3,'评估完成','2','ch_assess_status','','success','Y','0','admin','2026-11-11 22:56:09','',NULL,''),(132,1,'正常','0','ch_archive_status','','success','Y','0','admin','2026-11-11 22:56:09','',NULL,''),(133,2,'存在异常','1','ch_archive_status','','danger','N','0','admin','2026-11-11 22:56:09','',NULL,'');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2026-11-10 17:10:46','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2026-11-10 17:10:46','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2026-11-10 17:10:46','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2026-11-10 17:10:46','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2026-11-10 17:10:46','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2026-11-10 17:10:46','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2026-11-10 17:10:46','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2026-11-10 17:10:46','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2026-11-10 17:10:46','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2026-11-10 17:10:46','',NULL,'登录状态列表'),(100,'学生性别','ch_sex','0','admin','2026-11-10 20:58:24','',NULL,'学生性别列表'),(101,'BMI等级','ch_bmi_level','0','admin','2026-11-10 23:32:38','',NULL,'体检BMI等级列表'),(102,'体检批次状态','ch_batch_status','0','admin','2026-11-11 16:19:52','',NULL,'体检批次状态列表'),(103,'预约状态','ch_appoint_status','0','admin','2026-11-11 16:30:38','',NULL,'体检预约状态列表'),(104,'AI辅助风险等级','ch_risk_level','0','admin','2026-11-11 18:25:00','',NULL,'AI健康评估输出的辅助风险等级'),(105,'体检项目分类','ch_exam_category','0','admin','2026-11-11 22:13:04','',NULL,'体检项目分类列表'),(106,'体检异常判定方式','ch_abnormal_rule','0','admin','2026-11-11 22:13:04','',NULL,'体检项目异常判定方向'),(107,'体检记录状态','ch_record_status','0','admin','2026-11-11 22:56:09','',NULL,'未登记/录入中/已完成'),(108,'AI评估状态','ch_assess_status','0','admin','2026-11-11 22:56:09','',NULL,'待评估/评估中/评估完成'),(109,'健康档案状态','ch_archive_status','0','admin','2026-11-11 22:56:09','',NULL,'正常/存在异常');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2026-11-10 17:10:46','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2026-11-10 17:10:46','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2026-11-10 17:10:46','',NULL,''),(100,'关闭过期体检批次','SYSTEM','examBatchTask.closeExpiredBatches','0 0 1 * * ?','3','1','0','admin','2026-11-11 17:05:34','',NULL,'体检日期已过且状态为预约中的批次，自动置为已结束');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
INSERT INTO `sys_job_log` VALUES (1,'关闭过期体检批次','SYSTEM','examBatchTask.closeExpiredBatches','关闭过期体检批次 总共耗时：11毫秒','0','','2026-11-11 17:08:17','2026-11-11 17:08:17','2026-11-11 17:08:17'),(2,'关闭过期体检批次','SYSTEM','examBatchTask.closeExpiredBatches','关闭过期体检批次 总共耗时：3毫秒','0','','2026-11-11 17:08:35','2026-11-11 17:08:35','2026-11-11 17:08:34');
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (100,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','1','验证码错误','2026-11-10 17:11:57'),(101,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 17:12:12'),(102,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-10 17:14:25'),(103,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-10 20:34:25'),(104,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 20:50:41'),(105,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 20:50:46'),(106,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 20:52:10'),(107,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 20:56:42'),(108,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 20:58:46'),(109,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 21:09:03'),(110,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 21:09:09'),(111,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 21:09:43'),(112,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-10 23:35:35'),(113,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-10 23:50:44'),(114,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-11 16:10:44'),(115,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:19:04'),(116,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:26:49'),(117,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:40:52'),(118,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:41:52'),(119,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:43:19'),(120,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:44:21'),(121,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','退出成功','2026-11-11 16:46:52'),(122,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-11 16:46:57'),(123,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','1','验证码已失效','2026-11-11 16:48:16'),(124,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','1','验证码错误','2026-11-11 16:48:31'),(125,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:48:44'),(126,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:50:28'),(127,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:50:42'),(128,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:50:53'),(129,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:54:24'),(130,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 16:58:40'),(131,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 17:08:16'),(132,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 17:08:34'),(133,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 17:24:45'),(134,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 17:25:33'),(135,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-11 17:28:22'),(136,'admin','127.0.0.1','内网IP','WorkBuddy 5.9.3','Windows 10.0','0','登录成功','2026-11-11 17:43:31'),(137,'admin','127.0.0.1','内网IP','WorkBuddy 5.9.3','Windows 10.0','1','验证码已失效','2026-11-11 17:48:59'),(138,'admin','127.0.0.1','内网IP','WorkBuddy 5.9.3','Windows 10.0','0','登录成功','2026-11-11 17:49:03'),(139,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','1','验证码已失效','2026-11-11 17:52:37'),(140,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-11 17:52:40'),(141,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','1','验证码错误','2026-11-11 17:58:36'),(142,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 17:58:59'),(143,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 17:59:23'),(144,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:13:07'),(145,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:20:31'),(146,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:20:41'),(147,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:29:40'),(148,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:31:22'),(149,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:33:14'),(150,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:33:26'),(151,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:38:40'),(152,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:39:28'),(153,'admin','127.0.0.1','内网IP','WorkBuddy 5.9.3','Windows 10.0','1','验证码已失效','2026-11-11 18:39:30'),(154,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:40:34'),(155,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:42:41'),(156,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:44:59'),(157,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:49:28'),(158,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:50:13'),(159,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:51:28'),(160,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:53:27'),(161,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:54:07'),(162,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:55:54'),(163,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 18:56:46'),(164,'admin','127.0.0.1','内网IP','WorkBuddy 5.9.3','Windows 10.0','0','登录成功','2026-11-11 18:59:35'),(165,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-11 19:00:03'),(166,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-11 22:05:52'),(167,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','1','验证码错误','2026-11-11 22:18:17'),(168,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:18:22'),(169,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:18:36'),(170,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:18:55'),(171,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:19:46'),(172,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','0','登录成功','2026-11-11 22:20:20'),(173,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:20:38'),(174,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:26:22'),(175,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:27:10'),(176,'student01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:45:39'),(177,'doctor01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:45:40'),(178,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:45:41'),(179,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:45:41'),(180,'student02','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:45:57'),(181,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:45:58'),(182,'doctor01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:45:58'),(183,'teacher01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:45:58'),(184,'admin','127.0.0.1','内网IP','WorkBuddy 5.9.3','Windows 10.0','0','登录成功','2026-11-11 22:46:50'),(185,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:54:04'),(186,'teacher01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:54:04'),(187,'student01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 22:54:05'),(188,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:03:01'),(189,'teacher01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:03:01'),(190,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:03:08'),(191,'teacher01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:03:08'),(192,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:03:57'),(193,'teacher01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:03:58'),(194,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','1','验证码已失效','2026-11-11 23:04:02'),(195,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:04:41'),(196,'teacher01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:04:42'),(197,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:04:50'),(198,'doctor01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:04:50'),(199,'teacher01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:04:51'),(200,'student01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:04:51'),(201,'admin','127.0.0.1','内网IP','WorkBuddy 5.9.3','Windows 10.0','1','验证码错误','2026-11-11 23:08:53'),(202,'admin','127.0.0.1','内网IP','WorkBuddy 5.9.3','Windows 10.0','0','登录成功','2026-11-11 23:08:57'),(203,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:13:32'),(204,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:14:43'),(205,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:24:59'),(206,'student01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:24:59'),(207,'student02','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:25:00'),(208,'admin','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:25:06'),(209,'student01','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:25:06'),(210,'student02','127.0.0.1','内网IP','Python-urllib 3.13','','0','登录成功','2026-11-11 23:25:06');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2070 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,5,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-11-10 17:10:45','',NULL,'系统管理目录'),(2,'系统监控',0,6,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-11-10 17:10:45','',NULL,'系统监控目录'),(3,'系统工具',0,7,'tool',NULL,'','',1,0,'M','0','0','','tool','admin','2026-11-10 17:10:45','',NULL,'系统工具目录'),(4,'若依官网',0,8,'http://ruoyi.vip',NULL,'','',0,0,'M','1','0','','guide','admin','2026-11-10 17:10:45','',NULL,'若依官网地址'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-11-10 17:10:45','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-11-10 17:10:45','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-11-10 17:10:45','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2026-11-10 17:10:45','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2026-11-10 17:10:45','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-11-10 17:10:45','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-11-10 17:10:45','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2026-11-10 17:10:45','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2026-11-10 17:10:45','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2026-11-10 17:10:45','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2026-11-10 17:10:45','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2026-11-10 17:10:45','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2026-11-10 17:10:45','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2026-11-10 17:10:45','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2026-11-10 17:10:45','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2026-11-10 17:10:45','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2026-11-10 17:10:45','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2026-11-10 17:10:45','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-11-10 17:10:45','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-11-10 17:10:45','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-11-10 17:10:45','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-11-10 17:10:45','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-11-10 17:10:45','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-11-10 17:10:45','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-11-10 17:10:45','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-11-10 17:10:45','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2026-11-10 17:10:45','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2026-11-10 17:10:45','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2026-11-10 17:10:45','',NULL,''),(2001,'学生信息管理',2055,1,'info','health/student/index',NULL,'',1,0,'C','0','0','health:student:list','#','admin','2026-11-10 20:49:32','',NULL,'学生信息菜单'),(2002,'学生信息查询',2001,1,'#','',NULL,'',1,0,'F','0','0','health:student:query','#','admin','2026-11-10 20:49:32','',NULL,''),(2003,'学生信息新增',2001,2,'#','',NULL,'',1,0,'F','0','0','health:student:add','#','admin','2026-11-10 20:49:32','',NULL,''),(2004,'学生信息修改',2001,3,'#','',NULL,'',1,0,'F','0','0','health:student:edit','#','admin','2026-11-10 20:49:32','',NULL,''),(2005,'学生信息删除',2001,4,'#','',NULL,'',1,0,'F','0','0','health:student:remove','#','admin','2026-11-10 20:49:32','',NULL,''),(2006,'学生信息导出',2001,5,'#','',NULL,'',1,0,'F','0','0','health:student:export','#','admin','2026-11-10 20:49:32','',NULL,''),(2013,'体检登记管理',2056,4,'registration','health/examRecord/index',NULL,'',1,0,'C','0','0','health:examRecord:list','#','admin','2026-11-10 23:42:53','',NULL,'体检记录菜单'),(2014,'体检记录查询',2013,1,'#','',NULL,'',1,0,'F','0','0','health:examRecord:query','#','admin','2026-11-10 23:42:53','',NULL,''),(2015,'体检记录新增',2013,2,'#','',NULL,'',1,0,'F','0','0','health:examRecord:add','#','admin','2026-11-10 23:42:53','',NULL,''),(2016,'体检记录修改',2013,3,'#','',NULL,'',1,0,'F','0','0','health:examRecord:edit','#','admin','2026-11-10 23:42:53','',NULL,''),(2017,'体检记录删除',2013,4,'#','',NULL,'',1,0,'F','0','0','health:examRecord:remove','#','admin','2026-11-10 23:42:53','',NULL,''),(2018,'体检记录导出',2013,5,'#','',NULL,'',1,0,'F','0','0','health:examRecord:export','#','admin','2026-11-10 23:42:53','',NULL,''),(2019,'体检批次管理',2056,2,'batch','health/examBatch/index',NULL,'',1,0,'C','0','0','health:examBatch:list','#','admin','2026-11-11 16:23:36','',NULL,'体检批次菜单'),(2020,'体检批次查询',2019,1,'#','',NULL,'',1,0,'F','0','0','health:examBatch:query','#','admin','2026-11-11 16:23:36','',NULL,''),(2021,'体检批次新增',2019,2,'#','',NULL,'',1,0,'F','0','0','health:examBatch:add','#','admin','2026-11-11 16:23:36','',NULL,''),(2022,'体检批次修改',2019,3,'#','',NULL,'',1,0,'F','0','0','health:examBatch:edit','#','admin','2026-11-11 16:23:36','',NULL,''),(2023,'体检批次删除',2019,4,'#','',NULL,'',1,0,'F','0','0','health:examBatch:remove','#','admin','2026-11-11 16:23:36','',NULL,''),(2024,'体检批次导出',2019,5,'#','',NULL,'',1,0,'F','0','0','health:examBatch:export','#','admin','2026-11-11 16:23:36','',NULL,''),(2037,'体检预约管理',2056,3,'appointment','health/appointment/index',NULL,'',1,0,'C','0','0','health:appointment:list','#','admin','2026-11-11 16:41:04','',NULL,'体检预约菜单'),(2038,'体检预约查询',2037,1,'#','',NULL,'',1,0,'F','0','0','health:appointment:query','#','admin','2026-11-11 16:41:04','',NULL,''),(2039,'体检预约新增',2037,2,'#','',NULL,'',1,0,'F','0','0','health:appointment:add','#','admin','2026-11-11 16:41:04','',NULL,''),(2040,'体检预约修改',2037,3,'#','',NULL,'',1,0,'F','0','0','health:appointment:edit','#','admin','2026-11-11 16:41:04','',NULL,''),(2041,'体检预约删除',2037,4,'#','',NULL,'',1,0,'F','0','0','health:appointment:remove','#','admin','2026-11-11 16:41:04','',NULL,''),(2042,'体检预约导出',2037,5,'#','',NULL,'',1,0,'F','0','0','health:appointment:export','#','admin','2026-11-11 16:41:04','',NULL,''),(2043,'个人健康档案',2057,1,'my','health/archive/index',NULL,'',1,0,'C','0','0','health:archive:query','documentation','admin','2026-11-11 18:11:56','',NULL,'学生健康档案（最新指标/历史记录/BMI趋势）'),(2044,'智能健康管理',0,3,'ai',NULL,NULL,'',1,0,'M','0','0','','education','admin','2026-11-11 18:25:00','admin','2026-11-11 19:00:39','AI智能健康评估目录'),(2045,'AI健康评估',2044,1,'assessment','health/ai/index',NULL,'',1,0,'C','0','0','health:ai:list','education','admin','2026-11-11 18:33:02','',NULL,'AI健康评估菜单'),(2046,'AI评估查询',2045,1,'',NULL,NULL,'',1,0,'F','0','0','health:ai:query','#','admin','2026-11-11 18:33:02','',NULL,''),(2047,'AI评估生成',2045,2,'',NULL,NULL,'',1,0,'F','0','0','health:ai:assess','#','admin','2026-11-11 18:33:02','',NULL,''),(2048,'AI评估删除',2045,3,'',NULL,NULL,'',1,0,'F','0','0','health:ai:remove','#','admin','2026-11-11 18:33:02','',NULL,''),(2049,'体检项目管理',2056,1,'item','health/examItem/index','','',1,0,'C','0','0','health:examItem:list','component','admin','2026-11-11 22:13:04','',NULL,'体检项目菜单'),(2050,'体检项目查询',2049,1,'#','','','',1,0,'F','0','0','health:examItem:query','#','admin','2026-11-11 22:13:04','',NULL,''),(2051,'体检项目新增',2049,2,'#','','','',1,0,'F','0','0','health:examItem:add','#','admin','2026-11-11 22:13:04','',NULL,''),(2052,'体检项目修改',2049,3,'#','','','',1,0,'F','0','0','health:examItem:edit','#','admin','2026-11-11 22:13:04','',NULL,''),(2053,'体检项目删除',2049,4,'#','','','',1,0,'F','0','0','health:examItem:remove','#','admin','2026-11-11 22:13:04','',NULL,''),(2054,'体检项目导出',2049,5,'#','','','',1,0,'F','0','0','health:examItem:export','#','admin','2026-11-11 22:13:04','',NULL,''),(2055,'学生管理',0,0,'studentManage','','','',1,0,'M','0','0','','user','admin','2026-11-11 22:25:20','',NULL,'学生信息分组'),(2056,'体检管理',0,1,'examManage','','','',1,0,'M','0','0','','documentation','admin','2026-11-11 22:25:20','',NULL,'体检业务分组'),(2057,'健康档案',0,2,'archiveManage','','','',1,0,'M','0','0','','peoples','admin','2026-11-11 22:25:20','',NULL,'健康档案分组'),(2058,'数据统计',0,4,'statistics','','','',1,0,'M','0','0','','chart','admin','2026-11-11 22:25:20','',NULL,'统计分组'),(2059,'学生信息导入',2055,2,'import','health/student/import','','',1,0,'C','0','0','health:student:import','upload','admin','2026-11-11 22:25:20','',NULL,'Excel 批量导入'),(2060,'历史体检记录',2057,2,'history','health/examRecord/history','','',1,0,'C','0','0','health:examRecord:list','time-range','admin','2026-11-11 22:25:20','',NULL,'只读查询历年体检结果'),(2061,'异常指标管理',2057,3,'abnormal','health/abnormal/index','','',1,0,'C','0','0','health:examRecord:list','warning','admin','2026-11-11 22:25:20','',NULL,'按体检项目参考范围筛出的异常记录'),(2062,'AI评估报告',2044,2,'report','health/ai/report','','',1,0,'C','0','0','health:ai:list','form','admin','2026-11-11 22:25:20','',NULL,'按学生查看AI健康评估报告'),(2063,'体检完成情况',2058,1,'complete','health/statistics/complete','','',1,0,'C','0','0','health:stats:list','chart','admin','2026-11-11 22:25:20','',NULL,'完成率与批次预约进度'),(2064,'健康数据统计',2058,2,'health','health/statistics/health','','',1,0,'C','0','0','health:stats:list','monitor','admin','2026-11-11 22:25:20','',NULL,'BMI分布与异常比例'),(2065,'我的健康',0,0,'myHealth',NULL,'','',1,0,'M','0','0','','peoples','admin','2026-11-11 22:39:42','',NULL,'学生自助入口：只看得到自己的数据'),(2066,'我的体检预约',2065,1,'appointment','health/my/appointment','','',1,0,'C','0','0','health:my:appointment','date','admin','2026-11-11 22:39:42','',NULL,'查看批次、提交预约、取消预约'),(2067,'我的健康档案',2065,2,'archive','health/my/archive','','',1,0,'C','0','0','health:my:archive','documentation','admin','2026-11-11 22:39:42','',NULL,'个人档案与历年体检趋势'),(2068,'我的体检记录',2065,3,'records','health/my/records','','',1,0,'C','0','0','health:my:records','list','admin','2026-11-11 22:39:42','',NULL,'历次体检明细与异常指标'),(2069,'我的AI报告',2065,4,'ai','health/my/ai','','',1,0,'C','0','0','health:my:ai','education','admin','2026-11-11 23:23:28','',NULL,'学生查看自己的AI健康评估报告');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2026-11-10 17:10:46','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2026-11-10 17:10:46','',NULL,'管理员'),(3,'若依开源框架介绍','1',_binary '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">若依官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">若依文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>','0','admin','2026-11-10 17:10:46','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice_read`
--

DROP TABLE IF EXISTS `sys_notice_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice_read` (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`),
  UNIQUE KEY `uk_user_notice` (`user_id`,`notice_id`) COMMENT '同一用户同一公告只记录一次'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='公告已读记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice_read`
--

LOCK TABLES `sys_notice_read` WRITE;
/*!40000 ALTER TABLE `sys_notice_read` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notice_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=292 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'代码生成',6,'com.ruoyi.generator.controller.GenController.importTableSave()','POST',1,'admin','研发部门','/tool/gen/importTable','127.0.0.1','内网IP','{\"tables\":\"ch_student\",\"tplWebType\":\"element-plus\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 20:36:17',108),(101,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"student\",\"className\":\"Student\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键\",\"columnId\":1,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:36:17\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联若依用户ID\",\"columnId\":2,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:36:17\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"StudentNo\",\"columnComment\":\"学号\",\"columnId\":3,\"columnName\":\"student_no\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:36:17\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"studentNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"StudentName\",\"columnComment\":\"姓名\",\"columnId\":4,\"columnName\":\"student_name\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:36:17\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"stude','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 20:43:21',90),(102,'菜单管理',1,'com.ruoyi.web.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"nested\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"健康管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"health\",\"status\":\"0\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 20:46:07',18),(103,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"student\",\"className\":\"Student\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键\",\"columnId\":1,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:36:17\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-11-10 20:43:21\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联若依用户ID\",\"columnId\":2,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:36:17\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-11-10 20:43:21\",\"usableColumn\":false},{\"capJavaField\":\"StudentNo\",\"columnComment\":\"学号\",\"columnId\":3,\"columnName\":\"student_no\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:36:17\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"studentNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-11-10 20:43:21\",\"usableColumn\":false},{\"capJavaField\":\"StudentName\",\"columnComment\":\"姓名\",\"columnId\":4,\"columnName\":\"student_name\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:36:17\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 20:46:18',37),(104,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"Student\"}',NULL,0,NULL,'2026-11-10 20:46:26',192),(105,'学生信息',1,'com.ruoyi.health.controller.StudentController.add()','POST',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"birthday\":\"2026-11-03\",\"className\":\"a\'w\'d\",\"college\":\"da\'wa\",\"createTime\":\"2026-11-10 20:54:03\",\"gender\":\"男\",\"major\":\"a\'d\'w\",\"params\":{},\"phone\":\"a\'d\'w\",\"studentName\":\"达娃大\",\"studentNo\":\"阿达我发\"} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Table \'campus_health.student\' doesn\'t exist\r\n### The error may exist in URL [jar:nested:/E:/Users/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-health-3.9.2.jar!/mapper/health/StudentMapper.xml]\r\n### The error may involve com.ruoyi.health.mapper.StudentMapper.insertStudent-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into Student          ( student_no,             student_name,             gender,             birthday,             college,             major,             class_name,             phone,                                       create_time )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,                                       ? )\r\n### Cause: java.sql.SQLSyntaxErrorException: Table \'campus_health.student\' doesn\'t exist\n; bad SQL grammar []','2026-11-10 20:54:04',164),(106,'学生信息',1,'com.ruoyi.health.controller.StudentController.add()','POST',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"birthday\":\"2026-11-03\",\"className\":\"a\'w\'d\",\"college\":\"da\'wa\",\"createTime\":\"2026-11-10 20:54:08\",\"gender\":\"男\",\"major\":\"a\'d\'w\",\"params\":{},\"phone\":\"a\'d\'w\",\"studentName\":\"达娃大\",\"studentNo\":\"阿达我发\"} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Table \'campus_health.student\' doesn\'t exist\r\n### The error may exist in URL [jar:nested:/E:/Users/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-health-3.9.2.jar!/mapper/health/StudentMapper.xml]\r\n### The error may involve com.ruoyi.health.mapper.StudentMapper.insertStudent-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into Student          ( student_no,             student_name,             gender,             birthday,             college,             major,             class_name,             phone,                                       create_time )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,                                       ? )\r\n### Cause: java.sql.SQLSyntaxErrorException: Table \'campus_health.student\' doesn\'t exist\n; bad SQL grammar []','2026-11-10 20:54:08',3),(107,'学生信息',1,'com.ruoyi.health.controller.StudentController.add()','POST',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"birthday\":\"2026-11-03\",\"className\":\"a\'w\'d\",\"college\":\"da\'wa\",\"createTime\":\"2026-11-10 20:54:18\",\"gender\":\"男\",\"major\":\"a\'d\'w\",\"params\":{},\"phone\":\"a\'d\'w\",\"studentName\":\"达娃大\",\"studentNo\":\"阿达我发\"} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Table \'campus_health.student\' doesn\'t exist\r\n### The error may exist in URL [jar:nested:/E:/Users/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-health-3.9.2.jar!/mapper/health/StudentMapper.xml]\r\n### The error may involve com.ruoyi.health.mapper.StudentMapper.insertStudent-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into Student          ( student_no,             student_name,             gender,             birthday,             college,             major,             class_name,             phone,                                       create_time )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,                                       ? )\r\n### Cause: java.sql.SQLSyntaxErrorException: Table \'campus_health.student\' doesn\'t exist\n; bad SQL grammar []','2026-11-10 20:54:18',5),(108,'学生信息',1,'com.ruoyi.health.controller.StudentController.add()','POST',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"className\":\"24软件技术1班\",\"college\":\"信息工程学院\",\"createTime\":\"2026-11-10 20:56:42\",\"gender\":\"0\",\"id\":4,\"major\":\"软件技术\",\"params\":{},\"phone\":\"13800000000\",\"status\":\"0\",\"studentName\":\"测试插入\",\"studentNo\":\"TEST001\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 20:56:42',41),(109,'学生信息',1,'com.ruoyi.health.controller.StudentController.add()','POST',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"birthday\":\"2026-10-26\",\"createTime\":\"2026-11-10 20:59:31\",\"gender\":\"0\",\"id\":5,\"params\":{},\"studentName\":\"123\",\"studentNo\":\"123\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 20:59:31',5),(110,'学生信息',3,'com.ruoyi.health.controller.StudentController.remove()','DELETE',1,'admin','研发部门','/health/student/5','127.0.0.1','内网IP','[5] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 20:59:35',7),(111,'学生信息',1,'com.ruoyi.health.controller.StudentController.add()','POST',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"className\":\"测试班\",\"gender\":\"0\",\"params\":{},\"studentName\":\"重复测试\",\"studentNo\":\"20260001\"} ',NULL,1,'学号 20260001 已存在，请勿重复录入','2026-11-10 21:09:43',71),(112,'学生信息',1,'com.ruoyi.health.controller.StudentController.add()','POST',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"className\":\"测试班\",\"createTime\":\"2026-11-10 21:09:43\",\"gender\":\"1\",\"id\":6,\"params\":{},\"status\":\"0\",\"studentName\":\"正常测试\",\"studentNo\":\"20260099\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 21:09:43',64),(113,'代码生成',6,'com.ruoyi.generator.controller.GenController.importTableSave()','POST',1,'admin','研发部门','/tool/gen/importTable','127.0.0.1','内网IP','{\"tables\":\"ch_exam_record\",\"tplWebType\":\"element-plus\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 23:36:09',106),(114,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"examRecord\",\"className\":\"ChExamRecord\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"记录ID\",\"columnId\":17,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"StudentId\",\"columnComment\":\"学生ID（关联ch_student.id）\",\"columnId\":18,\"columnName\":\"student_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"studentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ExamDate\",\"columnComment\":\"体检日期\",\"columnId\":19,\"columnName\":\"exam_date\",\"columnType\":\"date\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"examDate\",\"javaType\":\"Date\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Height\",\"columnComment\":\"身高(cm)\",\"columnId\":20,\"columnName\":\"height\",\"columnType\":\"decimal(5,1)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 23:41:09',85),(115,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"ch_exam_record\"}',NULL,0,NULL,'2026-11-10 23:41:22',205),(116,'体检记录',1,'com.ruoyi.health.controller.ChExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"bmi\":21.4,\"bmiLevel\":\"1\",\"createTime\":\"2026-11-10 23:50:44\",\"diastolicPressure\":76,\"examDate\":\"2026-11-11\",\"height\":175,\"id\":4,\"params\":{},\"pulseRate\":72,\"studentId\":1,\"systolicPressure\":118,\"visionLeft\":5.0,\"visionRight\":5.0,\"weight\":65.5} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 23:50:44',47),(117,'体检记录',1,'com.ruoyi.health.controller.ChExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"bmi\":26.4,\"bmiLevel\":\"2\",\"createTime\":\"2026-11-10 23:50:44\",\"examDate\":\"2026-11-11\",\"height\":172,\"id\":5,\"params\":{},\"studentId\":2,\"weight\":78} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 23:50:44',8),(118,'体检记录',1,'com.ruoyi.health.controller.ChExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"bmi\":81.3,\"bmiLevel\":\"3\",\"conclusion\":\"12334\",\"createTime\":\"2026-11-10 23:51:46\",\"diastolicPressure\":123,\"examDate\":\"2026-10-29\",\"height\":123,\"id\":6,\"params\":{},\"pulseRate\":123,\"studentId\":123,\"systolicPressure\":123,\"visionLeft\":2,\"visionRight\":3,\"weight\":123} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 23:51:46',11),(119,'体检记录',3,'com.ruoyi.health.controller.ChExamRecordController.remove()','DELETE',1,'admin','研发部门','/health/examRecord/6','127.0.0.1','内网IP','[6] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 23:52:02',4),(120,'体检记录',2,'com.ruoyi.health.controller.ChExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"bmi\":26.4,\"bmiLevel\":\"2\",\"createBy\":\"\",\"createTime\":\"2026-11-10 23:50:44\",\"examDate\":\"2026-11-11\",\"height\":172,\"id\":5,\"params\":{},\"studentId\":2,\"systolicPressure\":123,\"updateBy\":\"\",\"updateTime\":\"2026-11-10 23:52:07\",\"weight\":78} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 23:52:07',7),(121,'学生信息',2,'com.ruoyi.health.controller.StudentController.edit()','PUT',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"birthday\":\"2007-03-15\",\"className\":\"24软件技术1班\",\"college\":\"信息工程学院\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:26:59\",\"gender\":\"0\",\"id\":1,\"major\":\"软件技术\",\"params\":{},\"phone\":\"13800000001\",\"remark\":\"演示数据\",\"status\":\"1\",\"studentName\":\"张同学\",\"studentNo\":\"20260001\",\"updateBy\":\"\",\"updateTime\":\"2026-11-10 23:54:44\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 23:54:45',7),(122,'学生信息',2,'com.ruoyi.health.controller.StudentController.edit()','PUT',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"birthday\":\"2007-03-15\",\"className\":\"24软件技术1班\",\"college\":\"信息工程学院\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 20:26:59\",\"gender\":\"0\",\"id\":1,\"major\":\"软件技术\",\"params\":{},\"phone\":\"13800000001\",\"remark\":\"演示数据\",\"status\":\"0\",\"studentName\":\"张同学\",\"studentNo\":\"20260001\",\"updateBy\":\"\",\"updateTime\":\"2026-11-10 23:54:48\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-10 23:54:48',7),(123,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"examRecord\",\"className\":\"ExamRecord\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"记录ID\",\"columnId\":17,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-11-10 23:41:09\",\"usableColumn\":false},{\"capJavaField\":\"StudentId\",\"columnComment\":\"学生ID（关联ch_student.id）\",\"columnId\":18,\"columnName\":\"student_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"studentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-11-10 23:41:09\",\"usableColumn\":false},{\"capJavaField\":\"ExamDate\",\"columnComment\":\"体检日期\",\"columnId\":19,\"columnName\":\"exam_date\",\"columnType\":\"date\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"examDate\",\"javaType\":\"Date\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-11-10 23:41:09\",\"usableColumn\":false},{\"capJavaField\":\"Height\",\"columnComment\":\"身高(cm)\",\"columnId\":20,\"columnName\":\"height\",\"columnType\":\"decimal(5,1)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:11:41',102),(124,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"ch_exam_record\"}',NULL,0,NULL,'2026-11-11 16:11:44',201),(125,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"examRecord\",\"className\":\"ExamRecord\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"记录ID\",\"columnId\":17,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 16:11:40\",\"usableColumn\":false},{\"capJavaField\":\"StudentId\",\"columnComment\":\"学生ID（关联ch_student.id）\",\"columnId\":18,\"columnName\":\"student_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"studentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 16:11:40\",\"usableColumn\":false},{\"capJavaField\":\"ExamDate\",\"columnComment\":\"体检日期\",\"columnId\":19,\"columnName\":\"exam_date\",\"columnType\":\"date\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"examDate\",\"javaType\":\"Date\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 16:11:40\",\"usableColumn\":false},{\"capJavaField\":\"Height\",\"columnComment\":\"身高(cm)\",\"columnId\":20,\"columnName\":\"height\",\"columnType\":\"decimal(5,1)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:36:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:15:13',55),(126,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"ch_exam_record\"}',NULL,0,NULL,'2026-11-11 16:15:16',55),(127,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"bmi\":21.4,\"bmiLevel\":\"1\",\"createTime\":\"2026-11-11 16:19:04\",\"examDate\":\"2026-11-12\",\"height\":175,\"id\":7,\"params\":{},\"studentId\":3,\"weight\":65.5} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:19:04',47),(128,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"examDate\":\"2026-11-13\",\"height\":175,\"params\":{},\"studentId\":3} ',NULL,1,'身高和体重不能为空','2026-11-11 16:19:04',5),(129,'代码生成',6,'com.ruoyi.generator.controller.GenController.importTableSave()','POST',1,'admin','研发部门','/tool/gen/importTable','127.0.0.1','内网IP','{\"tables\":\"ch_exam_batch\",\"tplWebType\":\"element-plus\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:20:12',91),(130,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"examBatch\",\"className\":\"ExamBatch\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"批次ID\",\"columnId\":35,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:20:12\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"BatchName\",\"columnComment\":\"批次名称\",\"columnId\":36,\"columnName\":\"batch_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:20:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"batchName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ExamDate\",\"columnComment\":\"体检日期\",\"columnId\":37,\"columnName\":\"exam_date\",\"columnType\":\"date\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:20:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"examDate\",\"javaType\":\"Date\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Location\",\"columnComment\":\"体检地点\",\"columnId\":38,\"columnName\":\"location\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:20:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"java','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:22:45',73),(131,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"ch_exam_batch\"}',NULL,0,NULL,'2026-11-11 16:22:49',182),(132,'体检批次',1,'com.ruoyi.health.controller.ExamBatchController.add()','POST',1,'admin','研发部门','/health/examBatch','127.0.0.1','内网IP','{\"batchName\":\"测试批次-临时\",\"capacity\":50,\"createTime\":\"2026-11-11 16:26:49\",\"examDate\":\"2026-12-01\",\"id\":4,\"location\":\"校医院三楼\",\"params\":{},\"status\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:26:49',27),(133,'代码生成',6,'com.ruoyi.generator.controller.GenController.importTableSave()','POST',1,'admin','研发部门','/tool/gen/importTable','127.0.0.1','内网IP','{\"tables\":\"ch_appointment\",\"tplWebType\":\"element-plus\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:30:54',85),(134,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"appointment \",\"className\":\"Appointment\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"预约ID\",\"columnId\":47,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:30:54\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"StudentId\",\"columnComment\":\"学生ID（ch_student.id）\",\"columnId\":48,\"columnName\":\"student_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:30:54\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"studentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"BatchId\",\"columnComment\":\"批次ID（ch_exam_batch.id）\",\"columnId\":49,\"columnName\":\"batch_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:30:54\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"batchId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"AppointTime\",\"columnComment\":\"预约提交时间\",\"columnId\":50,\"columnName\":\"appoint_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:30:54\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":false,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:38:26',80),(135,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"ch_appointment\"}',NULL,0,NULL,'2026-11-11 16:38:35',186),(136,'代码生成',8,'com.ruoyi.generator.controller.GenController.download()','GET',1,'admin','研发部门','/tool/gen/download/ch_appointment','127.0.0.1','内网IP','{}',NULL,0,NULL,'2026-11-11 16:40:52',43),(137,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":2,\"createTime\":\"2026-11-11 16:43:19\",\"id\":4,\"params\":{},\"status\":\"0\",\"studentId\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:43:19',26),(138,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.edit()','PUT',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-10\",\"auditBy\":\"\",\"batchId\":1,\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:30:38\",\"id\":1,\"params\":{},\"rejectReason\":\"\",\"status\":\"1\",\"studentId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 16:47:06\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:47:06',5),(139,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.edit()','PUT',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-10\",\"auditBy\":\"\",\"batchId\":1,\"createBy\":\"admin\",\"createTime\":\"2026-11-11 16:30:38\",\"id\":1,\"params\":{},\"rejectReason\":\"\",\"status\":\"0\",\"studentId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 16:47:15\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:47:15',7),(140,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11\",\"batchId\":3,\"createTime\":\"2026-11-11 16:48:45\",\"id\":5,\"params\":{},\"status\":\"0\",\"studentId\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:48:45',21),(141,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11\",\"batchId\":3,\"params\":{},\"status\":\"0\",\"studentId\":1} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 16:48:45',0),(142,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11\",\"auditBy\":\"黑客\",\"batchId\":3,\"createTime\":\"2026-11-11 16:48:45\",\"id\":6,\"params\":{},\"status\":\"0\",\"studentId\":2} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:48:45',16),(143,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11\",\"batchId\":3,\"params\":{},\"status\":\"0\"} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 16:48:45',1),(144,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:29\",\"batchId\":3,\"createTime\":\"2026-11-11 16:50:29\",\"id\":4,\"params\":{},\"status\":\"0\",\"studentId\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:50:29',60),(145,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:29\",\"batchId\":3,\"params\":{},\"status\":\"0\",\"studentId\":1} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 16:50:29',9),(146,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:29\",\"batchId\":3,\"createTime\":\"2026-11-11 16:50:29\",\"id\":5,\"params\":{},\"status\":\"0\",\"studentId\":2} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:50:29',19),(147,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ',NULL,1,'请选择学生','2026-11-11 16:50:29',1),(148,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:29\",\"batchId\":3,\"params\":{},\"status\":\"0\",\"studentId\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:50:29',9),(149,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:42\",\"batchId\":3,\"createTime\":\"2026-11-11 16:50:42\",\"id\":4,\"params\":{},\"status\":\"0\",\"studentId\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:50:42',10),(150,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:42\",\"batchId\":3,\"params\":{},\"status\":\"0\",\"studentId\":1} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 16:50:42',3),(151,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:42\",\"batchId\":3,\"createTime\":\"2026-11-11 16:50:42\",\"id\":5,\"params\":{},\"status\":\"0\",\"studentId\":2} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:50:42',8),(152,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ',NULL,1,'请选择学生','2026-11-11 16:50:42',1),(153,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:42\",\"batchId\":3,\"params\":{},\"status\":\"0\",\"studentId\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:50:42',7),(154,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:53\",\"batchId\":3,\"createTime\":\"2026-11-11 16:50:53\",\"id\":4,\"params\":{},\"status\":\"0\",\"studentId\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:50:53',6),(155,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:53\",\"batchId\":3,\"params\":{},\"status\":\"0\",\"studentId\":1} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 16:50:53',3),(156,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:53\",\"batchId\":3,\"createTime\":\"2026-11-11 16:50:53\",\"id\":5,\"params\":{},\"status\":\"0\",\"studentId\":2} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:50:53',7),(157,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ',NULL,1,'请选择学生','2026-11-11 16:50:53',0),(158,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:50:53\",\"batchId\":3,\"params\":{},\"status\":\"0\",\"studentId\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:50:53',6),(159,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'admin','研发部门','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":1,\"params\":{},\"status\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:54:25',41),(160,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'admin','研发部门','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":1,\"params\":{},\"status\":\"1\"} ',NULL,1,'该预约已审核或已取消，请勿重复操作','2026-11-11 16:54:25',10),(161,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'admin','研发部门','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":3,\"params\":{},\"status\":\"1\"} ',NULL,1,'该预约已审核或已取消，请勿重复操作','2026-11-11 16:54:25',8),(162,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:54:25\",\"batchId\":3,\"createTime\":\"2026-11-11 16:54:25\",\"id\":4,\"params\":{},\"status\":\"0\",\"studentId\":2} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:54:25',9),(163,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'admin','研发部门','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":4,\"params\":{},\"status\":\"2\"} ',NULL,1,'拒绝预约必须填写拒绝原因','2026-11-11 16:54:25',3),(164,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'admin','研发部门','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":4,\"params\":{},\"rejectReason\":\"血压偏高建议复查\",\"status\":\"2\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:54:25',10),(165,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 16:54:25\",\"batchId\":2,\"createTime\":\"2026-11-11 16:54:25\",\"id\":5,\"params\":{},\"status\":\"0\",\"studentId\":3} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:54:25',7),(166,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'admin','研发部门','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":5,\"params\":{},\"status\":\"1\"} ',NULL,1,'该体检批次名额已满，无法通过，请改为拒绝并提示学生改约其他批次','2026-11-11 16:54:25',7),(167,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.edit()','PUT',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"id\":5,\"params\":{},\"updateTime\":\"2026-11-11 16:54:26\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:54:26',3),(168,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'admin','研发部门','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":5,\"params\":{},\"status\":\"9\"} ',NULL,1,'审核结果不合法','2026-11-11 16:54:26',2),(169,'体检批次',1,'com.ruoyi.health.controller.ExamBatchController.add()','POST',1,'admin','研发部门','/health/examBatch','127.0.0.1','内网IP','{\"batchName\":\"测试-已结束\",\"capacity\":10,\"params\":{},\"status\":\"2\"} ',NULL,1,'新建批次不能是「已结束」状态','2026-11-11 16:58:40',27),(170,'体检批次',1,'com.ruoyi.health.controller.ExamBatchController.add()','POST',1,'admin','研发部门','/health/examBatch','127.0.0.1','内网IP','{\"batchName\":\"测试-正常\",\"capacity\":10,\"createTime\":\"2026-11-11 16:58:40\",\"id\":5,\"params\":{}} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 16:58:40',13),(171,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{},\"studentId\":1} ',NULL,1,'该批次尚未开放预约','2026-11-11 17:08:16',43),(172,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{},\"studentId\":1} ',NULL,1,'该批次已结束，无法预约','2026-11-11 17:08:17',10),(173,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":2,\"params\":{},\"studentId\":1} ',NULL,1,'该批次名额已满，请选择其他批次','2026-11-11 17:08:17',9),(174,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 17:08:17\",\"batchId\":1,\"params\":{},\"status\":\"0\",\"studentId\":1} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 17:08:17',24),(175,'定时任务',2,'com.ruoyi.quartz.controller.SysJobController.run()','PUT',1,'admin','研发部门','/monitor/job/run','127.0.0.1','内网IP','{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:08:17',31),(176,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{},\"studentId\":1} ',NULL,1,'该批次尚未开放预约','2026-11-11 17:08:34',4),(177,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{},\"studentId\":1} ',NULL,1,'该批次已结束，无法预约','2026-11-11 17:08:34',3),(178,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"batchId\":2,\"params\":{},\"studentId\":1} ',NULL,1,'该批次名额已满，请选择其他批次','2026-11-11 17:08:34',4),(179,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.add()','POST',1,'admin','研发部门','/health/appointment','127.0.0.1','内网IP','{\"appointTime\":\"2026-11-11 17:08:34\",\"batchId\":1,\"createTime\":\"2026-11-11 17:08:34\",\"id\":4,\"params\":{},\"status\":\"0\",\"studentId\":7} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:08:34',13),(180,'定时任务',2,'com.ruoyi.quartz.controller.SysJobController.run()','PUT',1,'admin','研发部门','/monitor/job/run','127.0.0.1','内网IP','{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:08:34',4),(181,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-11-10 20:46:07\",\"icon\":\"nested\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"健康管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"health\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:28:55',30),(182,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"bmi\":26.4,\"bmiLevel\":\"2\",\"createBy\":\"\",\"createTime\":\"2026-11-10 23:50:44\",\"examDate\":\"2026-11-11\",\"height\":172,\"id\":5,\"params\":{},\"studentId\":20260001,\"systolicPressure\":123,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 17:56:16\",\"weight\":78} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:56:16',19),(183,'体检记录',3,'com.ruoyi.health.controller.ExamRecordController.remove()','DELETE',1,'admin','研发部门','/health/examRecord/5','127.0.0.1','内网IP','[5] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:57:09',9),(184,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":31.0,\"bmiLevel\":\"3\",\"createTime\":\"2026-11-11 17:58:59\",\"diastolicPressure\":80,\"examDate\":\"2026-11-11\",\"height\":175,\"params\":{},\"studentId\":1,\"systolicPressure\":120,\"weight\":95} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1-2026-11-11\' for key \'ch_exam_record.uk_student_date\'\r\n### The error may exist in URL [jar:nested:/E:/Users/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-health-3.9.2.jar!/mapper/health/ExamRecordMapper.xml]\r\n### The error may involve com.ruoyi.health.mapper.ExamRecordMapper.insertExamRecord-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into ch_exam_record          ( student_id,             batch_id,             exam_date,             height,             weight,             bmi,             bmi_level,             systolic_pressure,             diastolic_pressure,                                                    abnormal_flag,                                       create_time )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,                                                    ?,                                       ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1-2026-11-11\' for key \'ch_exam_record.uk_student_date\'\n; Duplicate entry \'1-2026-11-11\' for key \'ch_exam_record.uk_student_date\'','2026-11-11 17:58:59',175),(185,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"batchId\":1,\"bmi\":20.8,\"bmiLevel\":\"1\",\"createTime\":\"2026-11-11 17:58:59\",\"diastolicPressure\":70,\"examDate\":\"2026-11-11\",\"height\":170,\"id\":9,\"params\":{},\"studentId\":2,\"systolicPressure\":110,\"weight\":60} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:58:59',7),(186,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":20.1,\"bmiLevel\":\"1\",\"createTime\":\"2026-11-11 17:58:59\",\"diastolicPressure\":95,\"examDate\":\"2026-11-11\",\"height\":180,\"id\":10,\"params\":{},\"studentId\":3,\"systolicPressure\":150,\"weight\":65} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:58:59',16),(187,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":31.0,\"bmiLevel\":\"3\",\"createTime\":\"2026-11-11 17:59:23\",\"diastolicPressure\":80,\"examDate\":\"2026-11-12\",\"height\":175,\"id\":6,\"params\":{},\"studentId\":1,\"systolicPressure\":120,\"weight\":95} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:59:23',6),(188,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"batchId\":1,\"bmi\":20.8,\"bmiLevel\":\"1\",\"createTime\":\"2026-11-11 17:59:23\",\"diastolicPressure\":70,\"examDate\":\"2026-11-12\",\"height\":170,\"id\":7,\"params\":{},\"studentId\":2,\"systolicPressure\":110,\"weight\":60} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:59:23',9),(189,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":20.1,\"bmiLevel\":\"1\",\"createTime\":\"2026-11-11 17:59:23\",\"diastolicPressure\":95,\"examDate\":\"2026-11-12\",\"height\":180,\"id\":8,\"params\":{},\"studentId\":3,\"systolicPressure\":150,\"weight\":65} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:59:23',7),(190,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"batchId\":1,\"bmi\":21.2,\"bmiLevel\":\"1\",\"diastolicPressure\":80,\"examDate\":\"2026-11-12\",\"height\":175,\"id\":6,\"params\":{},\"studentId\":1,\"systolicPressure\":120,\"updateTime\":\"2026-11-11 17:59:23\",\"weight\":65} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 17:59:23',0),(191,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"examDate\":\"2026-11-12\",\"height\":175,\"params\":{},\"studentId\":1} ',NULL,1,'身高和体重不能为空','2026-11-11 17:59:23',0),(192,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":29.3,\"bmiLevel\":\"3\",\"conclusion\":\"体重超标，建议复查\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:32:38\",\"diastolicPressure\":88,\"examDate\":\"2026-11-10\",\"height\":160,\"id\":2,\"params\":{},\"pulseRate\":80,\"studentId\":2,\"systolicPressure\":132,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 18:08:04\",\"visionLeft\":4.6,\"visionRight\":4.5,\"weight\":75} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 18:08:04',4),(193,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"batchId\":2,\"bmi\":17.9,\"bmiLevel\":\"0\",\"conclusion\":\"偏瘦，注意营养\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:32:38\",\"diastolicPressure\":70,\"examDate\":\"2026-11-09\",\"height\":180,\"id\":3,\"params\":{},\"pulseRate\":68,\"studentId\":3,\"systolicPressure\":110,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 18:08:09\",\"visionLeft\":5.1,\"visionRight\":5.1,\"weight\":58} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 18:08:09',5),(194,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"batchId\":3,\"bmi\":21.4,\"bmiLevel\":\"1\",\"createBy\":\"\",\"createTime\":\"2026-11-10 23:50:44\",\"diastolicPressure\":76,\"examDate\":\"2026-11-11\",\"height\":175,\"id\":4,\"params\":{},\"pulseRate\":72,\"studentId\":1,\"systolicPressure\":118,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 18:08:14\",\"visionLeft\":5,\"visionRight\":5,\"weight\":65.5} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 18:08:14',8),(195,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"batchId\":1,\"bmi\":21.4,\"bmiLevel\":\"1\",\"conclusion\":\"各项指标正常\",\"createBy\":\"admin\",\"createTime\":\"2026-11-10 23:32:38\",\"diastolicPressure\":76,\"examDate\":\"2026-11-10\",\"height\":175,\"id\":1,\"params\":{},\"pulseRate\":72,\"studentId\":1,\"systolicPressure\":118,\"updateBy\":\"\",\"updateTime\":\"2026-11-11 18:08:20\",\"visionLeft\":5,\"visionRight\":4.8,\"weight\":65.5} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 18:08:20',4),(196,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/61','127.0.0.1','内网IP','61 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压是心脏收缩泵血时血管内的压力。你的数值142略高于参考上限140，说明测量时血管压力偏高，可能与紧张、刚运动完、睡眠不足或体重等因素有关，单次偏高不能直接说明有问题，但需要复测确认。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"90 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压是心脏放松时血管内的压力。你的数值90正好处于参考上限，属于偏高范围，同样需要安静休息后复测，排除测量误差或临时因素。\\\"}]\",\"assessmentResult\":\"总体BMI和脉搏正常，但血压两次测量均偏高，需复测监测并关注生活方式。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:29:44\",\"examDate\":\"2026-11-08\",\"examRecordId\":61,\"id\":1,\"modelName\":\"deepseek-chat\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"suggestions\":\"[\\\"建议在安静休息5-10分钟后、避免咖啡因和剧烈运动的情况下，于不同日期的同一时段复测血压2-3次，并记录数值供校医或医生参考。\\\",\\\"饮食上减少高盐食物（如腌制食品、方便面、外卖重口味菜），每日食盐尽量控制在5克以内，多吃新鲜蔬菜水果和全谷物。\\\",\\\"保持规律运动，每周进行3-5次中等强度有氧运动（如快走、慢跑、游泳），每次30分钟左右，避免久坐。\\\",\\\"保证充足睡眠，建议每天睡7-9小时，减少熬夜，学习间隙适当放松，避免长期精神紧张。\\\",\\\"若复测血压仍持续偏高，或出现头晕、头痛等不适，应及时咨询校医或到医院进一步检查。\\\"]\"}}',0,NULL,'2026-11-11 18:29:44',3691),(197,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/61','127.0.0.1','内网IP','61 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压是心脏收缩把血打出去时血管里的压力。这次142比参考上限略高，说明测量时血管压力偏大；一次偏高不一定代表有问题，可能与紧张、刚运动完、没休息好有关，但需要安静休息后复测确认。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"90 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压是心脏放松时血管里的压力。这次90正好在参考上限，属于偏高边缘，同样需要复测；如果多次测量都偏高，应请医生进一步评估。\\\"}]\",\"assessmentResult\":\"体重与BMI在正常范围，但血压两次测量均偏高，需复测监测并关注日常饮食、运动与作息。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:29:44\",\"examDate\":\"2026-11-08\",\"examRecordId\":61,\"id\":1,\"modelName\":\"deepseek-chat\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"suggestions\":\"[\\\"在安静环境下休息5-10分钟后复测血压，建议不同日期测量2-3次并记录数值，测量前避免剧烈运动、咖啡因和情绪紧张。\\\",\\\"饮食上减少高盐食物（如腌制品、方便面、重口味外卖），多吃蔬菜水果和清淡食物，少喝含糖饮料。\\\",\\\"保持规律运动，每周进行3-5次中等强度有氧运动（如快走、慢跑、骑车），每次30分钟左右，避免久坐。\\\",\\\"保证充足睡眠，尽量不熬夜，学习间隙适当放松，减少持续紧张状态。\\\",\\\"视力左眼4.9略低于正常参考，右眼数据缺失，建议补测右眼视力并注意用眼休息；如复测血压仍偏高，请咨询专业医生。\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 18:29:47\"}}',0,NULL,'2026-11-11 18:29:47',2823),(198,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/75','127.0.0.1','内网IP','75 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"31.8\\\",\\\"reference\\\":\\\"成人参考 ≥28 为肥胖\\\",\\\"explanation\\\":\\\"BMI是用身高和体重算出的一个数值，用来粗略反映体重是否超标。31.8属于肥胖范围，说明当前体重相对身高偏重较多，日常可能更容易感到累，长期偏重也会给心脏和血管增加负担。\\\"},{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"150 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压是心脏收缩把血打出去时血管里的压力。150比参考上限高，说明血管承受的压力偏大，需要留意。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"95 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"referenceNote\\\":\\\"\\\",\\\"explanation\\\":\\\"舒张压是心脏放松时血管里的压力。95比参考上限高，同样说明血管在放松状态下压力也偏大。\\\"}]\",\"assessmentResult\":\"该学生身高170cm、体重92kg，BMI为31.8，属于肥胖范围，同时收缩压150mmHg、舒张压95mmHg均偏高，提示体重和血压方面存在需要关注的健康风险。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:29:51\",\"examDate\":\"2026-10-01\",\"examRecordId\":75,\"id\":2,\"modelName\":\"deepseek-chat\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":3,\"studentName\":\"王同学\",\"studentNo\":\"20260003\",\"suggestions\":\"[\\\"饮食方面：减少油炸食品、含糖饮料、零食和外卖的频率，主食适当粗细搭配，每餐多吃蔬菜，肉类选择瘦肉、鱼、蛋、豆制品，控制总量、细嚼慢咽，避免暴饮暴食。\\\",\\\"运动方面：从低强度开始，如快走、慢跑、游泳、骑车，每周累计150分钟以上中等强度运动，可分次进行；同时减少久坐，每坐1小时起身活动几分钟。运动应循序渐进，避免突然剧烈运动。\\\",\\\"作息方面：保证每天7至9小时睡眠，尽量固定入睡和起床时间，少熬夜；学习间隙注意放松，减少长时间看屏幕。\\\",\\\"监测方面：建议定期复测体重、BMI和血压，记录变化趋势；测量血压前静坐休息几分钟，避免刚运动完或情绪激动时测量。\\\",\\\"如复测血压仍持续偏高，或出现头晕、头痛、心慌等不适，建议尽早到校医院或正规医疗机构咨询专业医生，由医生进一步评估。\\\",\\\"视力数据本次未提供，无法评估，建议按学校安排补充检查。\\\"]\"}}',0,NULL,'2026-11-11 18:29:50',3446),(199,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/999999','127.0.0.1','内网IP','999999 ',NULL,1,'体检记录不存在，无法生成评估','2026-11-11 18:29:50',9),(200,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压是心脏收缩泵血时血管内的压力。本次142 mmHg高于参考上限，系统判定为偏高，可能受紧张、运动后、休息不足等因素影响，建议安静休息后复测确认。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"90 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压是心脏舒张放松时血管内的压力。本次90 mmHg达到参考上限，系统判定为偏高，同样建议安静休息后复测，排除临时因素。\\\"}]\",\"assessmentResult\":\"该学生BMI正常，但血压偏高，需安静休息后复测，并结合日常调整观察。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:31:26\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":1,\"modelName\":\"deepseek-chat\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"复测血压：在安静环境坐下休息5-10分钟后复测，避免刚运动、喝咖啡或情绪紧张时测量，可连续几天在固定时间测量并记录。\\\",\\\"饮食调整：减少高盐食物（如腌制食品、方便面、外卖重口味菜），每日盐摄入尽量控制；多吃蔬菜水果，少喝含糖饮料。\\\",\\\"规律运动：每周进行至少3-5次中等强度运动（如快走、慢跑、骑车、跳绳），每次30分钟左右，运动后注意放松。\\\",\\\"作息管理：保证每天7-9小时睡眠，避免熬夜；学习间隙适当起身活动，减少长时间久坐。\\\",\\\"视力关注：左右眼视力均为4.9，低于正常5.0参考，建议注意用眼休息，每用眼40分钟远眺放松，必要时到眼科检查。\\\",\\\"如复测血压仍持续偏高，或伴有头痛、头晕等不适，建议咨询专业医生进一步评估。\\\"]\"}}',0,NULL,'2026-11-11 18:31:25',3341),(201,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压是心脏收缩把血打出去时血管承受的压力。142比参考上限略高，说明测量时血管压力偏大，可能和紧张、刚运动完、休息不够有关，也可能提示血压需要持续关注，单次偏高不能直接说明有问题，建议安静休息后复测。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"90 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压是心脏放松时血管里的压力。90正好在参考上限，属于偏高边缘，同样需要休息后复测确认，不能仅凭一次结果下结论。\\\"}]\",\"assessmentResult\":\"总体BMI和视力在正常范围，但血压两次测量均偏高，需安静休息后复测并关注日常血压管理。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:31:26\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":1,\"modelName\":\"deepseek-chat\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"复测血压：测量前静坐休息5-10分钟，不说话、不玩手机，袖带与心脏同高，连续测2-3次取平均值，并记录时间和数值。\\\",\\\"饮食清淡：减少咸菜、腌制品、方便面、外卖重口味食物，每日食盐尽量控制在5克以内，多吃新鲜蔬菜水果和全谷物。\\\",\\\"规律运动：每周至少5天进行30分钟左右中等强度运动（如快走、慢跑、骑车、跳绳），避免久坐，每节课后起身活动。\\\",\\\"作息规律：保证每天7-9小时睡眠，少熬夜，减少含糖饮料和浓茶咖啡，学习压力大时注意放松。\\\",\\\"视力保护：左右眼均为4.9，注意用眼距离和时长，每用眼40分钟远眺休息，定期复查视力。\\\",\\\"如复测血压仍持续偏高，或出现头晕、头痛等不适，建议到校医院或正规医疗机构咨询专业医生。\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 18:31:29\"}}',0,NULL,'2026-11-11 18:31:29',3300),(202,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"27.4\\\",\\\"reference\\\":\\\"成人参考 24-27.9 为超重\\\",\\\"explanation\\\":\\\"BMI 是用身高和体重算出的体型指标，27.4 说明相对于 176 cm 的身高，体重偏重一些，属于超重范围，日常可通过饮食和运动慢慢调整。\\\"},{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"145 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压是心脏收缩把血打出去时血管承受的压力，145 比参考上限高，说明这次测量时血压偏高，可能和紧张、刚运动完、体重偏重等有关，需要安静休息后复查确认。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"92 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压是心脏放松时血管里的压力，92 略高于参考上限，同样提示血压偏高，建议按校医建议复查血压。\\\"}]\",\"assessmentResult\":\"本次体检显示体重指数达到超重范围、血压两次测量均偏高，需要重视并通过生活方式调整和复查来跟进。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:31:33\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":2,\"modelName\":\"deepseek-chat\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"饮食上减少咸菜、腌制品、方便面、外卖重口味食物，做菜少放盐和酱油，少喝含糖饮料，多吃蔬菜、水果、全谷物和瘦肉、豆制品，晚餐不过饱。\\\",\\\"运动上每周至少 5 天进行 30 分钟以上中等强度活动，如快走、慢跑、骑车、跳绳，从每天 20 分钟开始逐步增加，避免久坐，每坐 1 小时起身活动几分钟。\\\",\\\"作息上保证每天 7-8 小时睡眠，尽量固定入睡和起床时间，少熬夜，睡前 1 小时减少看手机。\\\",\\\"按校医建议在安静状态下复查血压，复查前避免剧烈运动、喝咖啡浓茶和情绪紧张，如多次测量仍偏高应咨询专业医生。\\\",\\\"定期关注体重变化，可每周固定时间称一次体重，以每月缓慢下降为目标，不采取过度节食。\\\",\\\"视力左 4.9、右 4.9 略低于常见 5.0 参考，本次未列为系统异常，建议注意用眼休息、保持读写距离，如看远模糊可进一步检查。\\\"]\"}}',0,NULL,'2026-11-11 18:31:33',4143),(203,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/999999','127.0.0.1','内网IP','999999 ',NULL,1,'体检记录不存在，无法生成评估','2026-11-11 18:31:33',0),(204,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/3','127.0.0.1','内网IP','3 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[]\",\"assessmentResult\":\"本次体检各项指标均在正常范围内，未发现异常，整体健康状况良好。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:33:28\",\"examDate\":\"2026-11-08\",\"examRecordId\":3,\"id\":3,\"modelName\":\"deepseek-chat\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"LOW\",\"studentId\":1,\"studentName\":\"张伟\",\"studentNo\":\"20260001\",\"suggestions\":\"[\\\"饮食上保持均衡，每天摄入足量蔬菜水果和优质蛋白，控制高油高糖零食和含糖饮料，三餐规律不暴饮暴食。\\\",\\\"运动上每周累计进行至少150分钟中等强度有氧运动，如快走、慢跑、跳绳、球类活动，并可每周安排2至3次力量练习，运动前后注意热身和拉伸。\\\",\\\"作息上保证每天约8小时睡眠，尽量固定入睡和起床时间，减少熬夜，连续用眼40分钟左右远眺休息，保持正确读写姿势以维护现有良好视力。\\\",\\\"日常注意监测自身感受，保持规律饮水，避免长时间久坐，课间多起身活动。\\\"]\"}}',0,NULL,'2026-11-11 18:33:28',1837),(205,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"27.4\\\",\\\"reference\\\":\\\"成人参考 24-27.9 为超重\\\",\\\"explanation\\\":\\\"BMI 是身高和体重算出的体型指标，27.4 属于超重范围，说明体重相对身高偏高，长期可能增加心血管负担，可通过饮食和运动逐步调整。\\\"},{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"145 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压是心脏收缩时血管内的压力，145 高于参考上限，提示血压偏高，一次测量不能说明问题，建议在安静状态下多次复查。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"92 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压是心脏舒张时血管内的压力，92 略高于参考上限，同样提示血压偏高，需结合复查结果判断。\\\"}]\",\"assessmentResult\":\"该学生存在超重和血压偏高两项异常指标，需要关注并建议复查血压、控制体重。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:33:31\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":4,\"modelName\":\"deepseek-chat\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"饮食上减少高盐、高油、高糖食物，少吃腌制食品和含糖饮料，多吃蔬菜、水果和全谷物，控制每餐主食量。\\\",\\\"每周进行至少150分钟中等强度运动，如快走、慢跑、游泳，可分次进行，避免久坐，每节课后起身活动。\\\",\\\"保持规律作息，保证每天7-8小时睡眠，减少熬夜，学习间隙注意放松，避免长期精神紧张。\\\",\\\"建议在安静休息5分钟后多次测量血压并记录，若复查仍偏高，及时到校医院或正规医疗机构咨询专业医生。\\\",\\\"定期监测体重和BMI变化，设定循序渐进的小目标，避免快速减重。\\\"]\"}}',0,NULL,'2026-11-11 18:33:31',2581),(206,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ',NULL,1,'AI 服务调用失败，请稍后重试：404: Not Found','2026-11-11 18:38:41',1337),(207,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ',NULL,1,'AI 服务调用失败，请稍后重试：404: Not Found','2026-11-11 18:38:41',255),(208,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ',NULL,1,'AI 服务调用失败，请稍后重试：404: Not Found','2026-11-11 18:38:42',197),(209,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/999999','127.0.0.1','内网IP','999999 ',NULL,1,'体检记录不存在，无法生成评估','2026-11-11 18:38:42',4),(210,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ',NULL,1,'AI 服务调用失败，请稍后重试：401: User not found.','2026-11-11 18:39:29',1306),(211,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ',NULL,1,'AI 服务调用失败，请稍后重试：401: User not found.','2026-11-11 18:39:29',88),(212,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ',NULL,1,'AI 服务调用失败，请稍后重试：401: User not found.','2026-11-11 18:39:30',89),(213,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/999999','127.0.0.1','内网IP','999999 ',NULL,1,'体检记录不存在，无法生成评估','2026-11-11 18:39:30',4),(214,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"您的收缩压略高于正常范围，表明心脏收缩时血管内的压力较高，可能增加心血管负担。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"90 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"您的舒张压达到偏高水平，表示心脏舒张时血管内的压力较高，也提示可能存在血压升高问题。\\\"}]\",\"assessmentResult\":\"体检显示血压偏高，其他指标正常。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:40:39\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":5,\"modelName\":\"cohere/north-mini-code:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断。\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"保持低钠饮食，减少加工食品和盐分摄入。\\\",\\\"每周进行150分钟中等强度的有氧运动，如快走或骑自行车。\\\",\\\"控制体重，保持适度运动和健康饮食。\\\",\\\"保证充足睡眠，避免过度紧张和疲劳。\\\",\\\"限制酒精摄入，戒烟限烟。\\\",\\\"定期监测血压，必要时咨询专业医生。\\\"]\"}}',0,NULL,'2026-11-11 18:40:39',4765),(215,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压是心脏收缩时的血压压力，系统判定偏高说明它超过了理想水平，可能对心血管健康产生轻微影响。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"90 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压是心脏放松时的血压压力，系统判定偏高意味着它接近或超出理想范围，长期高舒张压有增加心血管负担的风险。\\\"}]\",\"assessmentResult\":\"学生体检结果表明身高177cm、体重60kg、BMI 19.2为正常，但收缩压142mmHg和舒张压90mmHg均偏高，属于血压异常，需要注意休息后复测并保持健康生活方式。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:40:39\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":5,\"modelName\":\"liquid/lfm-3-1.7b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"每天保证7-8小时的高质量睡眠，避免熬夜和过度疲劳。\\\",\\\"每日控制盐分摄入，少吃加工食品和高钠饮料，多喝水。\\\",\\\"每周安排至少150分钟的中等强度有氧运动，如快走、骑行或跳绳。\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 18:41:05\"}}',0,NULL,'2026-11-11 18:41:05',26232),(216,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"27.4\\\",\\\"reference\\\":\\\"成人参考 24-27.9（超重）\\\",\\\"explanation\\\":\\\"BMI 27.4 超过正常上限 27.9，属于超重，可能增加肥胖相关健康风险。\\\"},{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"145 mmHg\\\",\\\"reference\\\":\\\"参考 <140 mmHg（偏高）\\\",\\\"explanation\\\":\\\"收缩压 145 mmHg 高于正常阈值 140 mmHg，属于偏高的血压，可能加重心血管负担。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"92 mmHg\\\",\\\"reference\\\":\\\"参考 <90 mmHg（偏高）\\\",\\\"explanation\\\":\\\"舒张压 92 mmHg 高于正常阈值 90 mmHg，同样属于偏高的血压，增加心脏负荷。\\\"}]\",\"assessmentResult\":\"学生体检显示体重超重、收缩压和舒张压均偏高，需要加强体重控制和血压管理，并建议及时复查血压。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:41:23\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":6,\"modelName\":\"liquid/lfm-3-1.7b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"每天至少150分钟进行中等强度有氧运动（如快走、慢跑或骑行），帮助降低血压并促进体重管理。\\\",\\\"每日多吃蔬菜水果，减少高盐、高油食物的摄入，以控制体重和改善血压。\\\",\\\"保证每晚7-8小时的高质量睡眠，避免熬夜和过度用屏幕，提升心肺功能。\\\"]\"}}',0,NULL,'2026-11-11 18:41:22',17563),(217,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/999999','127.0.0.1','内网IP','999999 ',NULL,1,'体检记录不存在，无法生成评估','2026-11-11 18:41:22',10),(218,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"血压数值略高于正常参考范围，系统已判定为异常指标。\\\"}]\",\"assessmentResult\":\"学生血压偏高，需关注血压控制及生活习惯调整。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:43:02\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":7,\"modelName\":\"liquid/lfm-2.5-2.6b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"减少高盐、高脂食物的摄入，增加新鲜蔬果的摄取。\\\",\\\"每周进行适度有氧运动，如快走或慢跑，帮助降低血压。\\\",\\\"保证充足睡眠，避免熬夜，以维持正常血压。\\\"]\"}}',0,NULL,'2026-11-11 18:43:01',19746),(219,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"系统判定为偏高，表示血压稍高于正常参考范围\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"90 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"系统判定为偏高，略高于正常参考范围\\\"}]\",\"assessmentResult\":\"学生体检中发现血压偏高指标，需关注心血管健康状况\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:43:02\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":7,\"modelName\":\"liquid/lfm-2.5-2.6b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"减少盐分摄入，增加富含钾的水果和蔬菜，帮助调节血压\\\",\\\"坚持每周至少150分钟的中等强度有氧运动，如快走或骑行\\\",\\\"保证7-8小时睡眠，遵循医生建议的安静休息\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 18:43:18\"}}',0,NULL,'2026-11-11 18:43:18',16115),(220,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"27.4\\\",\\\"reference\\\":\\\"24-27.9\\\",\\\"explanation\\\":\\\"BMI值为27.4，属于超重范围，意味着体重相对身高偏高，可能增加心血管和代谢健康风险。\\\"},{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"145 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压145 mmHg高于正常值，表示心脏收缩时对血管的压力偏高，需关注心血管健康。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"92 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压92 mmHg高于正常值，表示心脏舒张时血管压力偏高，可能与整体血压管理相关。\\\"}]\",\"assessmentResult\":\"学生体检显示BMI超重和血压偏高，需加强体重管理与血压监测。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:43:58\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":8,\"modelName\":\"dots-studio/dots-3-note-preview:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"饮食：控制每日热量摄入，减少高盐、高糖和高脂食物，增加蔬菜、水果和全谷物，保持均衡营养。\\\",\\\"运动：每周进行至少150分钟中等强度有氧运动，如快走、慢跑或游泳，结合力量训练以帮助控制体重。\\\",\\\"作息：保证每晚7-9小时规律睡眠，避免熬夜，减少压力，维持生物钟稳定以支持整体健康。\\\"]\"}}',0,NULL,'2026-11-11 18:43:58',40093),(221,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/999999','127.0.0.1','内网IP','999999 ',NULL,1,'体检记录不存在，无法生成评估','2026-11-11 18:43:58',11),(222,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ',NULL,1,'AI 服务调用失败，请稍后重试：Error reading response','2026-11-11 18:45:59',60013),(223,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/3','127.0.0.1','内网IP','3 ',NULL,1,'AI 服务调用失败，请稍后重试：Error reading response','2026-11-11 18:47:01',62308),(224,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"27.4\\\",\\\"reference\\\":\\\"24-27.9\\\",\\\"explanation\\\":\\\"体重指数偏高，意味着体重相对于身高超标，可能增加身体负担，如关节压力或代谢风险。\\\"},{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"145 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压偏高，表示心脏收缩时对血管的压力较大，长期可能影响心血管健康。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"92 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压偏高，表示心脏舒张时血管的压力也较大，需关注血管弹性。\\\"}]\",\"assessmentResult\":\"该学生体检数据显示超重和血压偏高，需加强日常健康管理。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:49:58\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":9,\"modelName\":\"dots-studio/dots-3-note-preview:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"饮食方面：控制总热量摄入，减少高盐、高糖和高脂肪食物，增加蔬菜、水果、全谷物和优质蛋白质，如鱼、豆类。\\\",\\\"运动方面：每周进行至少150分钟中等强度有氧运动，如快走、慢跑或游泳，结合力量训练以控制体重。\\\",\\\"作息方面：保证每天7-8小时高质量睡眠，避免熬夜，通过放松活动管理压力，如冥想或深呼吸。\\\"]\"}}',0,NULL,'2026-11-11 18:49:57',29459),(225,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/3','127.0.0.1','内网IP','3 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[]\",\"assessmentResult\":\"各项体检指标均在正常范围，整体健康状况良好。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:50:08\",\"examDate\":\"2026-11-08\",\"examRecordId\":3,\"id\":10,\"modelName\":\"nvidia/nemotron-3.5-super-vl:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"LOW\",\"studentId\":1,\"studentName\":\"张伟\",\"studentNo\":\"20260001\",\"suggestions\":\"[\\\"每天按时吃三餐，每餐摄入不少于一拳头的蔬菜，减少含糖饮料和油炸食品。\\\",\\\"每周进行3至5次中等强度有氧运动，如快走、慢跑或球类运动，每次坚持30分钟以上。\\\",\\\"每晚尽量在23点前入睡，保证7至8小时睡眠，避免熬夜和长时间连续使用电子产品。\\\"]\"}}',0,NULL,'2026-11-11 18:50:07',10010),(226,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"在心跳时血压升高，超过正常值，对心脏负荷较大。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"90 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"心跳间歇时血压仍偏高，超出正常下限，说明整体血压水平不够低。\\\"}]\",\"assessmentResult\":\"学生身高与体重正常，BMI在18.5-23.9正常范围内，但系统检测到血压（收缩压142 mmHg、舒张压90 mmHg）偏高，建议静息后复测并关注血压管理。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:50:38\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":11,\"modelName\":\"liquid/lfm-3-1.7b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"确保每晚7-8小时高质量睡眠，睡前避免咖啡因、酒精及电子屏幕。\\\",\\\"每日控制盐分摄入在2000毫克以下，优先选择蔬菜、水果、全谷物而减少加工食品。\\\",\\\"每周安排至少150分钟中等强度有氧运动（如快走、骑行或游泳），并适当加入力量训练。\\\",\\\"静息后再次测量血压，记录变化趋势；如连续两天仍偏高，请及时咨询体检科医生。\\\"]\"}}',0,NULL,'2026-11-11 18:50:38',24736),(227,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":\\\"142 mmHg\\\",\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压是心脏收缩时对血管壁的压力，142 mmHg略高于正常上限，可能与紧张、疲劳或生活习惯有关，需安静休息后复测确认。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":\\\"90 mmHg\\\",\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压是心脏舒张时血管中的压力，90 mmHg达到偏高边界，提示血管持续受压，建议结合收缩压复测评估。\\\"}]\",\"assessmentResult\":\"该学生身高体重正常、BMI和视力均在正常范围，但收缩压和舒张压偏高，未提供血糖血脂等其他指标，建议重点关注血压并复测。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:50:38\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":11,\"modelName\":\"nvidia/nemotron-3.5-super-vl:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断；未提供血糖、血脂等其他检验指标，无法对其进行健康评估。\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"饮食上采用清淡低盐饮食，每日食盐摄入建议不超过5克，减少腌制食品、油炸食品和咸零食，多吃新鲜蔬菜与水果。\\\",\\\"运动上每周进行3至5次中等强度有氧运动，如快走、慢跑或游泳，每次30分钟以上，避免剧烈运动后立即测量血压。\\\",\\\"作息上保证每天7至8小时睡眠，避免熬夜，测量血压前安静坐息5至10分钟，避免测前饮用浓茶、咖啡或吸烟。\\\",\\\"若安静休息后复测血压仍持续偏高，建议尽快咨询专业医生进行进一步评估。\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 18:51:12\"}}',0,NULL,'2026-11-11 18:51:11',33869),(228,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":27.4,\\\"reference\\\":\\\"成人正常范围约24-27.9（超重区间）\\\",\\\"explanation\\\":\\\"BMI数值表示身高与体重的关系，27.4高于推荐的健康范围，说明体重可能过多。\\\"},{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":145,\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"血压的最高压力，145 mmHg高于理想值，意味着心脏需要更努力地泵血。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":92,\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"血压的最低压力，92 mmHg高于理想值，同样提示心血管负荷增加。\\\"}]\",\"assessmentResult\":\"学生体重略超标且血压偏高，属于轻度风险，需要复查血压并控制体重。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:51:24\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":12,\"modelName\":\"liquid/lfm-3-1.7b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"每天多喝水，限制盐分摄入，选择全谷物、蔬菜水果为主食，少吃加工食品。\\\",\\\"每周至少150分钟中等强度有氧运动（如快走、骑车），并每周两次进行全身力量训练。\\\",\\\"保证每晚7-9小时高质量睡眠，保持固定作息时间，睡前避免电子屏幕。\\\",\\\"定期复查血压，并在医生指导下控制体重，必要时调整饮食和运动计划。\\\"]\"}}',0,NULL,'2026-11-11 18:51:24',12416),(229,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/999999','127.0.0.1','内网IP','999999 ',NULL,1,'体检记录不存在，无法生成评估','2026-11-11 18:51:24',12),(230,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":27.4,\\\"reference\\\":\\\"成人参考 24-27.9\\\",\\\"explanation\\\":\\\"BMI 超过正常范围，说明体重在身高下略高于推荐水平，可能增加心血管风险。\\\"},{\\\"item\\\":\\\"收缩压\\\",\\\"value\\\":145,\\\"reference\\\":\\\"<140 mmHg\\\",\\\"explanation\\\":\\\"收缩压高于正常值，长期高血压对心脏有负担。\\\"},{\\\"item\\\":\\\"舒张压\\\",\\\"value\\\":92,\\\"reference\\\":\\\"<90 mmHg\\\",\\\"explanation\\\":\\\"舒张压也高于正常值，影响血流分布。\\\"}]\",\"assessmentResult\":\"学生体检显示体重超重、血压偏高，属于轻度异常，需要通过控制体重和血压来降低健康风险。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:52:01\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":13,\"modelName\":\"liquid/lfm-3-1.7b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"每天保证7-9小时的高质量睡眠，避免熬夜和过度劳累。\\\",\\\"采用均衡饮食，减少盐分摄入，多吃蔬菜、水果、全谷物，并控制每日食用量。\\\",\\\"每周进行至少150分钟的中等强度有氧运动（如快走、慢跑），并加入力量训练。\\\",\\\"定期监测血压和体重，必要时就医获取专业指导。\\\"]\"}}',0,NULL,'2026-11-11 18:52:01',32061),(231,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/3','127.0.0.1','内网IP','3 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[]\",\"assessmentResult\":\"本次体检各项指标（BMI、血压、脉搏、视力）均在正常范围内，未发现异常，整体健康状况良好。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:52:06\",\"examDate\":\"2026-11-08\",\"examRecordId\":3,\"id\":14,\"modelName\":\"baidu/ernie-5.5-flash-preview:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"LOW\",\"studentId\":1,\"studentName\":\"张伟\",\"studentNo\":\"20260001\",\"suggestions\":\"[\\\"饮食：保持均衡膳食，每日摄入足量蔬菜水果、优质蛋白（鱼、蛋、奶、豆制品）和全谷物，控制油、盐、糖的摄入，规律三餐不暴饮暴食。\\\",\\\"运动：每周累计至少150分钟中等强度有氧运动（如快走、慢跑、游泳、骑行），并搭配每周2次左右的力量训练，运动前充分热身。\\\",\\\"作息：保持规律作息，每天保证7-9小时睡眠，避免熬夜；注意用眼卫生，遵循20-20-20原则（每用眼20分钟远眺20秒、看20英尺外），定期做眼保健操以维护视力。\\\"]\"}}',0,NULL,'2026-11-11 18:52:06',5438),(232,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"血压\\\",\\\"value\\\":\\\"收缩压142 mmHg，舒张压90 mmHg\\\",\\\"reference\\\":\\\"<140/<90 mmHg\\\",\\\"explanation\\\":\\\"收缩压和舒张压数值高于参考范围，系统判定为血压偏高，属于需要重视的异常指标。\\\"}]\",\"assessmentResult\":\"本次体检血压指标偏高，系统判定为中风险，提示需要关注血压管理。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:53:44\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":15,\"modelName\":\"recursive/flint-v1.0:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"安静休息后复测血压，必要时咨询医生；同时采取低盐饮食，减少腌制食品和加工肉。\\\",\\\"规律运动：每周进行3-5次中等强度运动，如快走或慢跑，每次约30分钟。\\\",\\\"保证作息：保证7-9小时睡眠，保持固定作息，避免长期熬夜。\\\"]\"}}',0,NULL,'2026-11-11 18:53:43',15469),(233,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"血压\\\",\\\"value\\\":\\\"收缩压142 mmHg / 舒张压90 mmHg\\\",\\\"reference\\\":\\\"收缩压 <140 mmHg / 舒张压 <90 mmHg\\\",\\\"explanation\\\":\\\"血压偏高，两项参考值都超出范围，可能与近期情绪、休息不足、饮食或遗传等因素有关，不能作为疾病诊断。\\\"}]\",\"assessmentResult\":\"本次体检中血压偏高，系统判定为中风险。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:53:44\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":15,\"modelName\":\"recursive/flint-v1.0:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"测量前静坐休息5分钟后复测血压，并记录测量时间、坐姿和数值。\\\",\\\"减少盐分摄入，避免高盐饮食和加工食品，控制每日食盐摄入。\\\",\\\"规律进行中等强度运动，如每周至少150分钟快走等，并保证充足睡眠。\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 18:53:53\"}}',0,NULL,'2026-11-11 18:53:53',9679),(234,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"27.4\\\",\\\"reference\\\":\\\"24-27.9\\\",\\\"explanation\\\":\\\"体重指标偏高，属于超重范围。\\\"},{\\\"item\\\":\\\"血压\\\",\\\"value\\\":\\\"145/92 mmHg\\\",\\\"reference\\\":\\\"<140/90 mmHg\\\",\\\"explanation\\\":\\\"血压数值偏高，可能增加心血管疾病风险。\\\"}]\",\"assessmentResult\":\"体重超重且血压偏高，存在多项健康风险。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:54:03\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":16,\"modelName\":\"nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"调整饮食结构，减少高热量、高盐食物摄入，多吃蔬菜水果。\\\",\\\"每周保证至少150分钟中等强度运动，如快走、骑自行车或游泳。\\\",\\\"保持规律作息，每天睡眠7-8小时，避免熬夜。\\\",\\\"定期复查血压，必要时及时就医。\\\"]\"}}',0,NULL,'2026-11-11 18:54:03',9890),(235,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/999999','127.0.0.1','内网IP','999999 ',NULL,1,'体检记录不存在，无法生成评估','2026-11-11 18:54:03',14),(236,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"27.4\\\",\\\"reference\\\":\\\"成人参考 24-27.9（超重）\\\",\\\"explanation\\\":\\\"BMI 27.4 超过正常上限，属于超重状态，体重过大可能增加心血管风险。\\\"},{\\\"item\\\":\\\"血压\\\",\\\"value\\\":\\\"145/92 mmHg\\\",\\\"reference\\\":\\\"<140/90 mmHg\\\",\\\"explanation\\\":\\\"收缩压145 mmHg和舒张压92 mmHg都高于正常阈值，属于偏高血压，需要复查并控制。\\\"}]\",\"assessmentResult\":\"本次体检显示学生超重（BMI 27.4）且血压偏高（收缩压145 mmHg、舒张压92 mmHg），共计2项异常，风险等级为高。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:54:31\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":17,\"modelName\":\"liquid/lfm-3-1.7b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"每天至少30分钟的中等强度有氧运动（如快步走或骑车），并每周加入两次力量训练。\\\",\\\"每日减少盐分摄入，选择全谷物、蔬菜水果为主的饮食，避免高糖、高油食品。\\\",\\\"保证每晚7-9小时的高质量睡眠，保持固定作息，避免熬夜。\\\",\\\"定期复查血压和体重，必要时就医专业医生进行进一步评估。\\\"]\"}}',0,NULL,'2026-11-11 18:54:31',23519),(237,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/3','127.0.0.1','内网IP','3 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[]\",\"assessmentResult\":\"本次体检未发现异常指标，系统风险等级为 LOW，各项健康数据总体处于正常范围。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:55:37\",\"examDate\":\"2026-11-08\",\"examRecordId\":3,\"id\":18,\"modelName\":\"recursive/flint-v1.0:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"LOW\",\"studentId\":1,\"studentName\":\"张伟\",\"studentNo\":\"20260001\",\"suggestions\":\"[\\\"保持规律作息，建议每天在同一时间上床和起床，避免长期熬夜。\\\",\\\"均衡饮食，控制总热量，多吃蔬菜、水果和全谷物，适量摄入优质蛋白，减少高糖高脂食物。\\\",\\\"进行中等强度有氧运动，如快走、慢跑或游泳，每周至少150分钟，同时结合力量训练或拉伸。\\\",\\\"保持健康体重，规律监测体重和腰围，并关注体重变化趋势。\\\",\\\"如出现头痛、视力明显下降、心悸、呼吸困难等不适，及时咨询专业医生。\\\"]\"}}',0,NULL,'2026-11-11 18:55:36',65627),(238,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"血压\\\",\\\"value\\\":\\\"收缩压142 mmHg, 舒张压90 mmHg\\\",\\\"reference\\\":\\\"收缩压<140 mmHg, 舒张压<90 mmHg\\\",\\\"explanation\\\":\\\"血压偏高表示心脏泵血时对血管壁的压力较大，可能提示心血管系统负担增加，但单次测量可能受情绪、活动等因素影响，建议结合多次测量评估。\\\"}]\",\"assessmentResult\":\"该学生体检结果显示血压偏高，风险等级为中，需通过日常健康管理关注血压变化。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:56:21\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":19,\"modelName\":\"dots-studio/dots-3-note-preview:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"饮食：减少高盐、高脂肪食物摄入，每日食盐量控制在5克以下，多食用新鲜蔬菜、水果和全谷物，以帮助稳定血压。\\\",\\\"运动：每周进行至少150分钟的中等强度有氧运动，如快走、慢跑或游泳，避免剧烈运动和长时间久坐。\\\",\\\"作息：保证每日7-8小时高质量睡眠，避免熬夜，保持规律作息，同时管理压力，如通过冥想或深呼吸放松。\\\",\\\"建议在安静休息后复测血压，若持续偏高，应咨询专业医生进行进一步评估。\\\"]\"}}',0,NULL,'2026-11-11 18:56:20',26123),(239,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/16','127.0.0.1','内网IP','16 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"血压\\\",\\\"value\\\":\\\"收缩压142 mmHg，舒张压90 mmHg\\\",\\\"reference\\\":\\\"收缩压<140 mmHg，舒张压<90 mmHg\\\",\\\"explanation\\\":\\\"血压数值高于参考范围，提示血压偏高，需要安静休息后复测，不能诊断为高血压病症。\\\"}]\",\"assessmentResult\":\"本次体检未见其他异常，系统判定血压偏高，属于中风险。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:56:21\",\"examDate\":\"2026-11-08\",\"examRecordId\":16,\"id\":19,\"modelName\":\"recursive/flint-v1.0:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":13,\"studentName\":\"马超\",\"studentNo\":\"20260013\",\"suggestions\":\"[\\\"低盐饮食，减少食盐摄入，可适量多吃新鲜蔬果。\\\",\\\"规律有氧运动，如每周至少150分钟中等强度运动，避免一次性剧烈运动。\\\",\\\"保证规律作息和睡眠，避免熬夜，安静休息后复测血压。\\\",\\\"若复测血压仍偏高或出现头晕、胸闷等症状，应及时咨询专业医生。\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 18:56:33\"}}',0,NULL,'2026-11-11 18:56:32',12181),(240,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"27.4\\\",\\\"reference\\\":\\\"24-27.9（超重范围）\\\",\\\"explanation\\\":\\\"BMI 是体重与身高的比值，27.4 表明体重偏重，可能增加健康风险。\\\"},{\\\"item\\\":\\\"血压\\\",\\\"value\\\":\\\"145/92 mmHg\\\",\\\"reference\\\":\\\"收缩压 <140 mmHg，舒张压 <90 mmHg\\\",\\\"explanation\\\":\\\"血压高于正常范围，提示循环系统负担较重，需引起重视。\\\"}]\",\"assessmentResult\":\"体检结果显示学生存在超重和血压偏高两项异常指标，风险等级较高。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:56:37\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":20,\"modelName\":\"cohere/north-mini-code:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"采取低钠、低饱和脂肪的均衡饮食，有助于控制体重和降低血压。\\\",\\\"每周进行至少 150 分钟中等强度运动（如快走、骑车），帮助减重和改善心血管健康。\\\",\\\"保持规律作息，保证每天 7-8 小时睡眠，并定期自测血压。\\\"]\"}}',0,NULL,'2026-11-11 18:56:37',4643),(241,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/999999','127.0.0.1','内网IP','999999 ',NULL,1,'体检记录不存在，无法生成评估','2026-11-11 18:56:37',5),(242,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/13','127.0.0.1','内网IP','13 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"27.4\\\",\\\"reference\\\":\\\"成人参考 24-27.9（系统判定为超重）\\\",\\\"explanation\\\":\\\"数值略高于超重范围，通常提示体重需要进一步控制，可能增加心血管代谢风险。\\\"},{\\\"item\\\":\\\"血压\\\",\\\"value\\\":\\\"收缩压145 mmHg，舒张压92 mmHg\\\",\\\"reference\\\":\\\"收缩压 <140 mmHg，舒张压 <90 mmHg\\\",\\\"explanation\\\":\\\"血压数值均略高于参考范围，属于血压偏高，需要重视并建议复查。\\\"}]\",\"assessmentResult\":\"本次体检显示体重超重且血压偏高，系统判定为高风险，建议咨询医生并综合调整饮食、运动与作息。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:58:58\",\"examDate\":\"2026-11-08\",\"examRecordId\":13,\"id\":21,\"modelName\":\"recursive/flint-v1.0:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"HIGH\",\"studentId\":10,\"studentName\":\"吴倩\",\"studentNo\":\"20260010\",\"suggestions\":\"[\\\"减少盐分摄入，避免高盐、高脂、高糖食物，控制总热量，增加蔬菜水果和膳食纤维摄入。\\\",\\\"进行规律有氧运动，如每周至少150分钟中等强度运动，如快走、游泳或骑行，同时控制体重。\\\",\\\"保证规律作息，7-8小时睡眠，避免熬夜；监测血压和体重，必要时咨询专业医生。\\\"]\"}}',0,NULL,'2026-11-11 18:58:57',131601),(243,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/3','127.0.0.1','内网IP','3 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[]\",\"assessmentResult\":\"本次体检未发现异常指标，各项健康数据总体处于正常范围，系统风险等级为低。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:55:37\",\"examDate\":\"2026-11-08\",\"examRecordId\":3,\"id\":18,\"modelName\":\"recursive/flint-v1.0:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"LOW\",\"studentId\":1,\"studentName\":\"张伟\",\"studentNo\":\"20260001\",\"suggestions\":\"[\\\"保持均衡饮食，控制总热量，多摄入蔬菜、水果和全谷物，适当减少盐和糖的摄入。\\\",\\\"坚持规律运动，每周至少进行150分钟中等强度有氧运动，并结合力量训练。\\\",\\\"保证充足睡眠，保持规律作息，避免长期熬夜。\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 18:59:02\"}}',0,NULL,'2026-11-11 18:59:01',3865),(244,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-11-11 18:25:00\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2044,\"menuName\":\"智能健康管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"ai\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 19:00:39',21),(245,'保存菜单排序',2,'com.ruoyi.web.controller.system.SysMenuController.updateSort()','PUT',1,'admin','研发部门','/system/menu/updateSort','127.0.0.1','内网IP','{\"menuIds\":\"1,2,3,4\",\"orderNums\":\"2,3,4,5\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 19:01:26',8),(246,'体检项目',1,'com.ruoyi.health.controller.ExamItemController.add()','POST',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"0\",\"category\":\"9\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 22:18:23\",\"description\":\"接口实测用，稍后删除\",\"fieldKey\":\"pulse_rate\",\"id\":9,\"itemCode\":\"TEST-001\",\"itemName\":\"测试项目\",\"params\":{},\"referenceMax\":20,\"referenceMin\":10,\"status\":\"0\",\"unit\":\"个\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:23',27),(247,'体检项目',1,'com.ruoyi.health.controller.ExamItemController.add()','POST',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"0\",\"category\":\"9\",\"description\":\"接口实测用，稍后删除\",\"fieldKey\":\"pulse_rate\",\"itemCode\":\"TEST-001\",\"itemName\":\"重复编码测试\",\"params\":{},\"referenceMax\":20,\"referenceMin\":10,\"status\":\"0\",\"unit\":\"个\"} ',NULL,1,'项目编码「TEST-001」已存在，请换一个','2026-11-11 22:18:23',5),(248,'体检项目',1,'com.ruoyi.health.controller.ExamItemController.add()','POST',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"0\",\"category\":\"9\",\"description\":\"接口实测用，稍后删除\",\"fieldKey\":\"pulse_rate\",\"itemCode\":\"TEST-002\",\"itemName\":\"测试项目\",\"params\":{},\"referenceMax\":10,\"referenceMin\":30,\"status\":\"0\",\"unit\":\"个\"} ',NULL,1,'参考下限不能大于参考上限','2026-11-11 22:18:23',5),(249,'体检项目',2,'com.ruoyi.health.controller.ExamItemController.edit()','PUT',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"3\",\"category\":\"9\",\"description\":\"接口实测用，稍后删除\",\"fieldKey\":\"pulse_rate\",\"id\":9,\"itemCode\":\"TEST-001\",\"itemName\":\"测试项目-已修改\",\"params\":{},\"referenceMax\":20,\"referenceMin\":10,\"status\":\"0\",\"unit\":\"个\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 22:18:23\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:23',9),(250,'体检项目',3,'com.ruoyi.health.controller.ExamItemController.remove()','DELETE',1,'admin','研发部门','/health/examItem/9','127.0.0.1','内网IP','[9] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:23',7),(251,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"bmi\":19.5,\"bmiLevel\":\"1\",\"conclusion\":\"历年体检，各项指标正常\",\"diastolicPressure\":72,\"examDate\":\"2024-11-08\",\"height\":168.0,\"id\":1,\"params\":{},\"pulseRate\":74,\"studentId\":1,\"systolicPressure\":112,\"updateTime\":\"2026-11-11 22:18:36\",\"visionLeft\":5.0,\"visionRight\":4.9,\"weight\":55.0} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:36',16),(252,'体检项目',2,'com.ruoyi.health.controller.ExamItemController.edit()','PUT',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"0\",\"category\":\"1\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 22:13:04\",\"description\":\"中国成人标准：偏低<18.5 正常18.5-23.9 超重24-27.9 肥胖≥28；超上限判为异常\",\"fieldKey\":\"bmi\",\"id\":3,\"itemCode\":\"HGT-BMI\",\"itemName\":\"BMI\",\"params\":{},\"referenceMax\":20,\"referenceMin\":18.5,\"remark\":\"\",\"status\":\"0\",\"unit\":\"kg/m²\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 22:18:36\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:36',8),(253,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"bmi\":19.5,\"bmiLevel\":\"1\",\"conclusion\":\"历年体检，各项指标正常\",\"diastolicPressure\":72,\"examDate\":\"2024-11-08\",\"height\":168.0,\"id\":1,\"params\":{},\"pulseRate\":74,\"studentId\":1,\"systolicPressure\":112,\"updateTime\":\"2026-11-11 22:18:36\",\"visionLeft\":5.0,\"visionRight\":4.9,\"weight\":55.0} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:36',7),(254,'体检项目',2,'com.ruoyi.health.controller.ExamItemController.edit()','PUT',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"0\",\"category\":\"1\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 22:13:04\",\"description\":\"中国成人标准：偏低<18.5 正常18.5-23.9 超重24-27.9 肥胖≥28；超上限判为异常\",\"fieldKey\":\"bmi\",\"id\":3,\"itemCode\":\"HGT-BMI\",\"itemName\":\"BMI\",\"params\":{},\"referenceMax\":20,\"referenceMin\":18.5,\"remark\":\"\",\"status\":\"1\",\"unit\":\"kg/m²\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 22:18:36\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:36',9),(255,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"bmi\":19.5,\"bmiLevel\":\"1\",\"conclusion\":\"历年体检，各项指标正常\",\"diastolicPressure\":72,\"examDate\":\"2024-11-08\",\"height\":168.0,\"id\":1,\"params\":{},\"pulseRate\":74,\"studentId\":1,\"systolicPressure\":112,\"updateTime\":\"2026-11-11 22:18:36\",\"visionLeft\":5.0,\"visionRight\":4.9,\"weight\":55.0} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:36',6),(256,'体检项目',2,'com.ruoyi.health.controller.ExamItemController.edit()','PUT',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"0\",\"category\":\"1\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 22:13:04\",\"description\":\"中国成人标准：偏低<18.5 正常18.5-23.9 超重24-27.9 肥胖≥28；超上限判为异常\",\"fieldKey\":\"bmi\",\"id\":3,\"itemCode\":\"HGT-BMI\",\"itemName\":\"BMI\",\"params\":{},\"referenceMax\":23.9,\"referenceMin\":18.5,\"remark\":\"\",\"status\":\"0\",\"unit\":\"kg/m²\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 22:18:36\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:36',10),(257,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"bmi\":19.5,\"bmiLevel\":\"1\",\"conclusion\":\"历年体检，各项指标正常\",\"diastolicPressure\":72,\"examDate\":\"2024-11-08\",\"height\":168.0,\"id\":1,\"params\":{},\"pulseRate\":74,\"studentId\":1,\"systolicPressure\":112,\"updateTime\":\"2026-11-11 22:18:36\",\"visionLeft\":5.0,\"visionRight\":4.9,\"weight\":55.0} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:18:36',6),(258,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"bmi\":19.5,\"bmiLevel\":\"1\",\"conclusion\":\"历年体检，各项指标正常\",\"diastolicPressure\":72,\"examDate\":\"2024-11-08\",\"height\":168.0,\"id\":1,\"params\":{},\"pulseRate\":74,\"studentId\":1,\"systolicPressure\":112,\"updateTime\":\"2026-11-11 22:19:47\",\"visionLeft\":5.0,\"visionRight\":4.9,\"weight\":55.0} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:19:47',74),(259,'体检项目',2,'com.ruoyi.health.controller.ExamItemController.edit()','PUT',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"0\",\"category\":\"1\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 22:13:04\",\"description\":\"中国成人标准：偏低<18.5 正常18.5-23.9 超重24-27.9 肥胖≥28；超上限判为异常\",\"fieldKey\":\"bmi\",\"id\":3,\"itemCode\":\"HGT-BMI\",\"itemName\":\"BMI\",\"params\":{},\"referenceMax\":19.0,\"referenceMin\":18.5,\"remark\":\"\",\"status\":\"0\",\"unit\":\"kg/m²\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 22:19:47\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:19:47',18),(260,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"bmi\":19.5,\"bmiLevel\":\"1\",\"conclusion\":\"历年体检，各项指标正常\",\"diastolicPressure\":72,\"examDate\":\"2024-11-08\",\"height\":168.0,\"id\":1,\"params\":{},\"pulseRate\":74,\"studentId\":1,\"systolicPressure\":112,\"updateTime\":\"2026-11-11 22:19:47\",\"visionLeft\":5.0,\"visionRight\":4.9,\"weight\":55.0} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:19:47',18),(261,'体检项目',2,'com.ruoyi.health.controller.ExamItemController.edit()','PUT',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"0\",\"category\":\"1\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 22:13:04\",\"description\":\"中国成人标准：偏低<18.5 正常18.5-23.9 超重24-27.9 肥胖≥28；超上限判为异常\",\"fieldKey\":\"bmi\",\"id\":3,\"itemCode\":\"HGT-BMI\",\"itemName\":\"BMI\",\"params\":{},\"referenceMax\":19.0,\"referenceMin\":18.5,\"remark\":\"\",\"status\":\"1\",\"unit\":\"kg/m²\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 22:19:47\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:19:47',9),(262,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"bmi\":19.5,\"bmiLevel\":\"1\",\"conclusion\":\"历年体检，各项指标正常\",\"diastolicPressure\":72,\"examDate\":\"2024-11-08\",\"height\":168.0,\"id\":1,\"params\":{},\"pulseRate\":74,\"studentId\":1,\"systolicPressure\":112,\"updateTime\":\"2026-11-11 22:19:47\",\"visionLeft\":5.0,\"visionRight\":4.9,\"weight\":55.0} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:19:47',10),(263,'体检项目',2,'com.ruoyi.health.controller.ExamItemController.edit()','PUT',1,'admin','研发部门','/health/examItem','127.0.0.1','内网IP','{\"abnormalRule\":\"0\",\"category\":\"1\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 22:13:04\",\"description\":\"中国成人标准：偏低<18.5 正常18.5-23.9 超重24-27.9 肥胖≥28；超上限判为异常\",\"fieldKey\":\"bmi\",\"id\":3,\"itemCode\":\"HGT-BMI\",\"itemName\":\"BMI\",\"params\":{},\"referenceMax\":23.9,\"referenceMin\":18.5,\"remark\":\"\",\"status\":\"0\",\"unit\":\"kg/m²\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-11 22:19:47\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:19:47',7),(264,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"bmi\":19.5,\"bmiLevel\":\"1\",\"conclusion\":\"历年体检，各项指标正常\",\"diastolicPressure\":72,\"examDate\":\"2024-11-08\",\"height\":168.0,\"id\":1,\"params\":{},\"pulseRate\":74,\"studentId\":1,\"systolicPressure\":112,\"updateTime\":\"2026-11-11 22:19:47\",\"visionLeft\":5.0,\"visionRight\":4.9,\"weight\":55.0} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:19:47',8),(265,'学生信息',6,'com.ruoyi.health.controller.StudentController.importData()','POST',1,'admin','研发部门','/health/student/importData','127.0.0.1','内网IP','{\"updateSupport\":\"false\"}','{\"msg\":\"恭喜您，数据已全部导入成功！共 2 条：<br/>1、学号 TEST2026001（测试甲）导入成功<br/>2、学号 TEST2026002（测试乙）导入成功\",\"code\":200}',0,NULL,'2026-11-11 22:26:23',128),(266,'学生信息',6,'com.ruoyi.health.controller.StudentController.importData()','POST',1,'admin','研发部门','/health/student/importData','127.0.0.1','内网IP','{\"updateSupport\":\"false\"}',NULL,1,'导入完成：成功 0 条，失败 2 条。失败明细：<br/>学号 TEST2026001 已存在，未导入<br/>学号 TEST2026002 已存在，未导入','2026-11-11 22:26:23',21),(267,'学生信息',6,'com.ruoyi.health.controller.StudentController.importData()','POST',1,'admin','研发部门','/health/student/importData','127.0.0.1','内网IP','{\"updateSupport\":\"true\"}','{\"msg\":\"恭喜您，数据已全部导入成功！共 2 条：<br/>1、学号 TEST2026001（测试甲）更新成功<br/>2、学号 TEST2026002（测试乙）更新成功\",\"code\":200}',0,NULL,'2026-11-11 22:26:23',28),(268,'学生信息',3,'com.ruoyi.health.controller.StudentController.remove()','DELETE',1,'admin','研发部门','/health/student/29,30','127.0.0.1','内网IP','[29,30] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:26:24',9),(269,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/14','127.0.0.1','内网IP','14 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"26.6\\\",\\\"reference\\\":\\\"24-27.9 (成人参考)\\\",\\\"explanation\\\":\\\"BMI 26.6 高于正常成年人范围 24-27.9，说明体重略高于理想水平，需要通过更多运动和适度减肥来降低风险。\\\"}]\",\"assessmentResult\":\"学生体检显示体重超标，BMI 为 26.6，超出成人正常范围 24-27.9，属于中风险，需要加强锻炼和饮食控制。\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 22:29:35\",\"examDate\":\"2026-11-08\",\"examRecordId\":14,\"id\":22,\"modelName\":\"liquid/lfm-3-1.7b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":11,\"studentName\":\"徐鹏\",\"studentNo\":\"20260011\",\"suggestions\":\"[\\\"每天至少 30 分钟有氧运动（如快走、慢跑或骑自行车），帮助消耗多余热量。\\\",\\\"合理控制饮食，多吃蔬菜、水果、全谷物，少吃油腻、高盐食物，并考虑咨询专业医生获取个性化指导。\\\",\\\"保持规律作息，每晚保证 7-8 小时睡眠，确保身体恢复和代谢正常。\\\"]\"}}',0,NULL,'2026-11-11 22:29:34',20496),(270,'体检记录',5,'com.ruoyi.health.controller.ExamRecordController.export()','POST',1,'admin','研发部门','/health/examRecord/export','127.0.0.1','内网IP','{\"pageSize\":\"10\",\"abnormalFlag\":\"1\",\"pageNum\":\"1\"}',NULL,0,NULL,'2026-11-11 22:30:09',38),(271,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.apply()','POST',1,'student01','软件学院','/health/appointment/apply','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 22:45:40',27),(272,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.apply()','POST',1,'student01','软件学院','/health/appointment/apply','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 22:45:40',12),(273,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.apply()','POST',1,'student01','软件学院','/health/appointment/apply','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{},\"status\":\"1\",\"studentId\":2} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 22:45:40',13),(274,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'doctor01','校医院','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":27,\"params\":{},\"status\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:45:40',21),(275,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'doctor01','校医院','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"0\",\"batchId\":3,\"bmi\":22.3,\"bmiLevel\":\"1\",\"conclusion\":\"测试录入\",\"createTime\":\"2026-11-11 22:45:40\",\"diastolicPressure\":76,\"examDate\":\"2026-11-18\",\"height\":172,\"id\":30,\"params\":{},\"pulseRate\":72,\"studentId\":1,\"systolicPressure\":118,\"visionLeft\":5.0,\"visionRight\":5.0,\"weight\":66} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:45:40',22),(276,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.cancel()','PUT',1,'student01','软件学院','/health/appointment/cancel/34','127.0.0.1','内网IP','34 ',NULL,1,'只能取消自己的预约','2026-11-11 22:45:41',8),(277,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.apply()','POST',1,'student02','软件学院','/health/appointment/apply','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ',NULL,1,'该学生已预约此批次，请勿重复提交','2026-11-11 22:45:57',6),(278,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.cancel()','PUT',1,'student02','软件学院','/health/appointment/cancel/28','127.0.0.1','内网IP','28 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:45:57',10),(279,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.cancel()','PUT',1,'student02','软件学院','/health/appointment/cancel/28','127.0.0.1','内网IP','28 ',NULL,1,'该预约已取消，无需重复操作','2026-11-11 22:45:57',5),(280,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.apply()','POST',1,'student02','软件学院','/health/appointment/apply','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:45:58',10),(281,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'doctor01','校医院','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":28,\"params\":{},\"status\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:45:58',7),(282,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.cancel()','PUT',1,'student02','软件学院','/health/appointment/cancel/28','127.0.0.1','内网IP','28 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 22:45:58',10),(283,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":28.4,\"bmiLevel\":\"3\",\"conclusion\":\"验收测试数据\",\"createTime\":\"2026-11-11 23:03:08\",\"diastolicPressure\":95,\"examDate\":\"2026-11-11\",\"height\":170,\"id\":31,\"params\":{},\"pulseRate\":82,\"recordStatus\":\"1\",\"remark\":\"basic_upgrade 验收\",\"studentId\":1,\"systolicPressure\":145,\"visionLeft\":4.8,\"visionRight\":4.9,\"weight\":82} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 23:03:08',46),(284,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":28.4,\"bmiLevel\":\"3\",\"conclusion\":\"验收测试数据\",\"diastolicPressure\":95,\"examDate\":\"2026-11-11\",\"height\":170,\"id\":31,\"params\":{},\"pulseRate\":82,\"recordStatus\":\"2\",\"remark\":\"basic_upgrade 验收\",\"studentId\":1,\"systolicPressure\":145,\"updateTime\":\"2026-11-11 23:03:08\",\"visionLeft\":4.8,\"visionRight\":4.9,\"weight\":82} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 23:03:08',23),(285,'体检记录',3,'com.ruoyi.health.controller.ExamRecordController.remove()','DELETE',1,'admin','研发部门','/health/examRecord/31','127.0.0.1','内网IP','[31] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 23:03:08',19),(286,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":28.4,\"bmiLevel\":\"3\",\"conclusion\":\"验收测试数据\",\"createTime\":\"2026-11-11 23:03:58\",\"diastolicPressure\":95,\"examDate\":\"2026-11-11\",\"height\":170,\"id\":32,\"params\":{},\"pulseRate\":82,\"recordStatus\":\"1\",\"remark\":\"basic_upgrade 验收\",\"studentId\":1,\"systolicPressure\":145,\"visionLeft\":4.8,\"visionRight\":4.9,\"weight\":82} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 23:03:58',57),(287,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":28.4,\"bmiLevel\":\"3\",\"conclusion\":\"验收测试数据\",\"diastolicPressure\":95,\"examDate\":\"2026-11-11\",\"height\":170,\"id\":32,\"params\":{},\"pulseRate\":82,\"recordStatus\":\"2\",\"remark\":\"basic_upgrade 验收\",\"studentId\":1,\"systolicPressure\":145,\"updateTime\":\"2026-11-11 23:03:58\",\"visionLeft\":4.8,\"visionRight\":4.9,\"weight\":82} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 23:03:58',19),(288,'体检记录',3,'com.ruoyi.health.controller.ExamRecordController.remove()','DELETE',1,'admin','研发部门','/health/examRecord/32','127.0.0.1','内网IP','[32] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 23:03:58',16),(289,'体检记录',1,'com.ruoyi.health.controller.ExamRecordController.add()','POST',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":28.4,\"bmiLevel\":\"3\",\"conclusion\":\"验收测试数据\",\"createTime\":\"2026-11-11 23:04:42\",\"diastolicPressure\":95,\"examDate\":\"2026-11-11\",\"height\":170,\"id\":33,\"params\":{},\"pulseRate\":82,\"recordStatus\":\"1\",\"remark\":\"basic_upgrade 验收\",\"studentId\":1,\"systolicPressure\":145,\"visionLeft\":4.8,\"visionRight\":4.9,\"weight\":82} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 23:04:42',64),(290,'体检记录',2,'com.ruoyi.health.controller.ExamRecordController.edit()','PUT',1,'admin','研发部门','/health/examRecord','127.0.0.1','内网IP','{\"abnormalFlag\":\"1\",\"batchId\":1,\"bmi\":28.4,\"bmiLevel\":\"3\",\"conclusion\":\"验收测试数据\",\"diastolicPressure\":95,\"examDate\":\"2026-11-11\",\"height\":170,\"id\":33,\"params\":{},\"pulseRate\":82,\"recordStatus\":\"2\",\"remark\":\"basic_upgrade 验收\",\"studentId\":1,\"systolicPressure\":145,\"updateTime\":\"2026-11-11 23:04:42\",\"visionLeft\":4.8,\"visionRight\":4.9,\"weight\":82} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 23:04:42',24),(291,'体检记录',3,'com.ruoyi.health.controller.ExamRecordController.remove()','DELETE',1,'admin','研发部门','/health/examRecord/33','127.0.0.1','内网IP','[33] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-11 23:04:43',27);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2026-11-10 17:10:45','',NULL,''),(2,'se','项目经理',2,'0','admin','2026-11-10 17:10:45','',NULL,''),(3,'hr','人力资源',3,'0','admin','2026-11-10 17:10:45','',NULL,''),(4,'user','普通员工',4,'0','admin','2026-11-10 17:10:45','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2026-11-10 17:10:45','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',1,1,'0','0','admin','2026-11-10 17:10:45','',NULL,'普通角色'),(100,'校医','doctor',3,'1',1,1,'0','0','admin','2026-11-11 22:39:42','',NULL,'体检项目、批次、预约审核、体检登记、档案与AI评估'),(101,'辅导员','counselor',4,'3',1,1,'0','0','admin','2026-11-11 22:39:42','',NULL,'只读：查看学生信息、预约情况、健康档案与统计，不能增删改'),(102,'学生','student',5,'5',1,1,'0','0','admin','2026-11-11 22:39:42','',NULL,'仅本人：我的预约、我的档案、我的体检记录');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (2,100),(2,101),(2,105);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (2,1),(2,2),(2,3),(2,4),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,115),(2,116),(2,117),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060),(100,2001),(100,2002),(100,2003),(100,2004),(100,2005),(100,2006),(100,2013),(100,2014),(100,2015),(100,2016),(100,2017),(100,2018),(100,2019),(100,2020),(100,2021),(100,2022),(100,2023),(100,2024),(100,2037),(100,2038),(100,2039),(100,2040),(100,2041),(100,2042),(100,2043),(100,2044),(100,2045),(100,2046),(100,2047),(100,2048),(100,2049),(100,2050),(100,2051),(100,2052),(100,2053),(100,2054),(100,2055),(100,2056),(100,2057),(100,2059),(100,2060),(100,2061),(100,2062),(100,2063),(100,2064),(101,2001),(101,2002),(101,2006),(101,2014),(101,2018),(101,2019),(101,2020),(101,2024),(101,2037),(101,2038),(101,2042),(101,2043),(101,2055),(101,2056),(101,2057),(101,2058),(101,2060),(101,2061),(101,2063),(101,2064),(102,2065),(102,2066),(102,2067),(102,2068),(102,2069);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) COLLATE utf8mb4_general_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '密码',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','若依','00','ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-11 23:25:06','2026-11-10 17:10:45','admin','2026-11-10 17:10:45','',NULL,'管理员'),(2,105,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-10 17:10:45','2026-11-10 17:10:45','admin','2026-11-10 17:10:45','',NULL,'测试员'),(3,110,'doctor01','王医生','00','doctor01@campus.edu.cn','13900000001','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-11 23:04:51',NULL,'admin','2026-11-11 22:39:42','',NULL,'演示账号：校医'),(4,120,'teacher01','李老师','00','teacher01@campus.edu.cn','13900000002','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-11 23:04:51',NULL,'admin','2026-11-11 22:39:42','',NULL,'演示账号：辅导员'),(5,120,'student01','张伟','00','student01@campus.edu.cn','13810000137','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-11 23:25:07',NULL,'admin','2026-11-11 22:39:42','',NULL,'演示账号：学生（20260001 张伟）'),(6,121,'student02','李娜','00','student02@campus.edu.cn','13810000274','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-11 23:25:07',NULL,'admin','2026-11-11 22:39:42','',NULL,'演示账号：学生（20260002 李娜）');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,2),(3,100),(4,101),(5,102),(6,102);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-11 23:35:46
