-- =====================================================================
-- 校园学生体检与健康档案管理系统 数据库初始化脚本
-- 数据库：campus_health（MySQL 8.0+，utf8mb4 / InnoDB）
-- 内容：建库语句 + 38 张表结构 + 初始数据与演示数据
-- 生成日期：2026-11-12（与线上运行库结构逐表核对一致）
-- 配套文档：《项目需求设计文档.docx》《数据库设计文档.docx》
--
-- 导入方式（任选其一）：
--   1) 命令行：mysql -u root -p < campus_health.sql
--   2) Navicat / IDEA Database：新建连接后直接运行本文件
--   3) Docker：挂载到 mysql:8.0 容器的 /docker-entrypoint-initdb.d/，
--      首次启动自动执行（本项目阿里云部署即此方式）
--
-- 注意：本脚本含 DROP TABLE IF EXISTS，重复导入会重建表并清空数据！
-- 导入后默认账号 admin/admin123；学生新账号初始密码 123456。
-- =====================================================================

CREATE DATABASE IF NOT EXISTS `campus_health` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE `campus_health`;
-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: campus_health
-- ------------------------------------------------------
-- Server version	8.0.39

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
  `assess_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '2' COMMENT '评估状态（0待评估 1评估中 2评估完成）',
  `risk_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '辅助风险等级（LOW/MEDIUM/HIGH）',
  `assessment_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '评估摘要',
  `abnormal_items` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常项目（JSON数组）',
  `suggestions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '健康建议（JSON数组）',
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模型名称',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ai_record` (`exam_record_id`),
  KEY `idx_ai_student` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='AI健康评估记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_ai_assessment`
--

LOCK TABLES `ch_ai_assessment` WRITE;
/*!40000 ALTER TABLE `ch_ai_assessment` DISABLE KEYS */;
INSERT INTO `ch_ai_assessment` VALUES (1,1,1,'0',NULL,NULL,NULL,NULL,NULL,'system','2024-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(2,1,2,'0',NULL,NULL,NULL,NULL,NULL,'system','2025-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(3,2,4,'0',NULL,NULL,NULL,NULL,NULL,'system','2025-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(4,1,3,'2','LOW','本次体检未发现异常指标，各项健康数据总体处于正常范围，系统风险等级为低。','[]','[\"保持均衡饮食，控制总热量，多摄入蔬菜、水果和全谷物，适当减少盐和糖的摄入。\",\"坚持规律运动，每周至少进行150分钟中等强度有氧运动，并结合力量训练。\",\"保证充足睡眠，保持规律作息，避免长期熬夜。\"]','recursive/flint-v1.0:free','system','2026-11-08 17:05:00','doctor01','2026-11-11 23:20:00','评估报告已生成'),(5,2,5,'2','MEDIUM','本次体检共判定1项异常，BMI 提示肥胖，系统风险等级为中风险。','[{\"item\":\"BMI\",\"value\":\"29.3\",\"reference\":\"≥28（成人肥胖参考）\",\"explanation\":\"BMI 偏高，属于系统判定为肥胖范围，提示体重与身高比例较大，不能据此诊断学生是否患病。\"}]','[\"减少精制糖和高脂高糖食物摄入，增加蔬菜、水果、全谷物和适量优质蛋白摄入。\",\"坚持规律有氧运动，如每周至少150分钟中等强度运动，并可配合力量训练。\",\"保证充足睡眠，控制饮食总量，定期监测体重和其他健康指标。\",\"若出现胸痛、气短、心悸等明显症状，应及时咨询专业医生。\"]','recursive/flint-v1.0:free','system','2026-11-08 17:05:00','admin','2026-11-12 16:09:35','本报告仅供健康管理参考，不能代替医生的专业诊断'),(6,3,6,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(7,4,7,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(8,5,8,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(9,6,9,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(10,7,10,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(11,8,11,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(12,9,12,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(13,10,13,'2','HIGH','本次体检显示体重超重且血压偏高，系统判定为高风险，建议咨询医生并综合调整饮食、运动与作息。','[{\"item\":\"BMI\",\"value\":\"27.4\",\"reference\":\"成人参考 24-27.9（系统判定为超重）\",\"explanation\":\"数值略高于超重范围，通常提示体重需要进一步控制，可能增加心血管代谢风险。\"},{\"item\":\"血压\",\"value\":\"收缩压145 mmHg，舒张压92 mmHg\",\"reference\":\"收缩压 <140 mmHg，舒张压 <90 mmHg\",\"explanation\":\"血压数值均略高于参考范围，属于血压偏高，需要重视并建议复查。\"}]','[\"减少盐分摄入，避免高盐、高脂、高糖食物，控制总热量，增加蔬菜水果和膳食纤维摄入。\",\"进行规律有氧运动，如每周至少150分钟中等强度运动，如快走、游泳或骑行，同时控制体重。\",\"保证规律作息，7-8小时睡眠，避免熬夜；监测血压和体重，必要时咨询专业医生。\"]','recursive/flint-v1.0:free','system','2026-11-08 17:05:00','doctor01','2026-11-11 23:20:00','评估报告已生成'),(14,11,14,'2','MEDIUM','学生体检显示体重超标，BMI 为 26.6，超出成人正常范围 24-27.9，属于中风险，需要加强锻炼和饮食控制。','[{\"item\":\"BMI\",\"value\":\"26.6\",\"reference\":\"24-27.9 (成人参考)\",\"explanation\":\"BMI 26.6 高于正常成年人范围 24-27.9，说明体重略高于理想水平，需要通过更多运动和适度减肥来降低风险。\"}]','[\"每天至少 30 分钟有氧运动（如快走、慢跑或骑自行车），帮助消耗多余热量。\",\"合理控制饮食，多吃蔬菜、水果、全谷物，少吃油腻、高盐食物，并考虑咨询专业医生获取个性化指导。\",\"保持规律作息，每晚保证 7-8 小时睡眠，确保身体恢复和代谢正常。\"]','liquid/lfm-3-1.7b:free','system','2026-11-08 17:05:00','doctor01','2026-11-11 23:20:00','评估报告已生成'),(15,12,15,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(16,13,16,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(17,14,17,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(18,15,18,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(19,16,19,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(20,17,20,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(21,18,21,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(22,19,22,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(23,20,23,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(24,21,24,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-08 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(25,22,25,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-09 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(26,23,26,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-09 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(27,24,27,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-09 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(28,25,28,'0',NULL,NULL,NULL,NULL,NULL,'system','2026-11-09 17:05:00','',NULL,'登记体检记录时自动生成待评估任务'),(29,26,29,'2','LOW','本次体检所有指标均在正常范围内，未发现异常，整体风险等级为低。','[]','[\"以均衡饮食为主，确保每天摄入足够的蔬菜、水果和全谷物，限制高盐、高油、高糖食物。\",\"每日进行至少30分钟的中等强度有氧运动（如快走、慢跑或骑行），帮助维持心率和体重。\",\"保证每晚7-9小时的高质量睡眠，固定起床时间，避免睡前使用电子设备导致失眠。\"]','liquid/lfm-3-1.7b:free','system','2026-11-09 17:05:00','admin','2026-11-12 14:09:26','本报告仅供健康管理参考，不能代替医生的专业诊断');
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
  `appointment_time` datetime DEFAULT NULL COMMENT '预约提交时间',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0待审核 1已通过 2已拒绝 3已取消）',
  `audit_user` bigint DEFAULT NULL COMMENT '审核人员（sys_user.user_id）',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `audit_remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核备注（拒绝时说明原因）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_batch` (`student_id`,`batch_id`),
  KEY `idx_batch` (`batch_id`),
  KEY `idx_status` (`status`),
  KEY `idx_audit_user` (`audit_user`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='体检预约表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_appointment`
--

LOCK TABLES `ch_appointment` WRITE;
/*!40000 ALTER TABLE `ch_appointment` DISABLE KEYS */;
INSERT INTO `ch_appointment` VALUES (1,1,1,'2026-11-05 09:00:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:00:00','doctor01','2026-11-05 15:00:00',NULL),(2,2,1,'2026-11-05 09:02:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:02:00','doctor01','2026-11-05 15:00:00',NULL),(3,3,1,'2026-11-05 09:04:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:04:00','doctor01','2026-11-05 15:00:00',NULL),(4,4,1,'2026-11-05 09:06:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:06:00','doctor01','2026-11-05 15:00:00',NULL),(5,5,1,'2026-11-05 09:08:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:08:00','doctor01','2026-11-05 15:00:00',NULL),(6,6,1,'2026-11-05 09:10:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:10:00','doctor01','2026-11-05 15:00:00',NULL),(7,7,1,'2026-11-05 09:12:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:12:00','doctor01','2026-11-05 15:00:00',NULL),(8,8,1,'2026-11-05 09:14:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:14:00','doctor01','2026-11-05 15:00:00',NULL),(9,9,1,'2026-11-05 09:16:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:16:00','doctor01','2026-11-05 15:00:00',NULL),(10,10,1,'2026-11-05 09:18:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:18:00','doctor01','2026-11-05 15:00:00',NULL),(11,11,1,'2026-11-05 09:20:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:20:00','doctor01','2026-11-05 15:00:00',NULL),(12,12,1,'2026-11-05 09:22:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:22:00','doctor01','2026-11-05 15:00:00',NULL),(13,13,1,'2026-11-05 09:24:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:24:00','doctor01','2026-11-05 15:00:00',NULL),(14,14,1,'2026-11-05 09:26:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:26:00','doctor01','2026-11-05 15:00:00',NULL),(15,15,1,'2026-11-05 09:28:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:28:00','doctor01','2026-11-05 15:00:00',NULL),(16,16,1,'2026-11-05 09:30:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:30:00','doctor01','2026-11-05 15:00:00',NULL),(17,17,1,'2026-11-05 09:32:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:32:00','doctor01','2026-11-05 15:00:00',NULL),(18,18,1,'2026-11-05 09:34:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:34:00','doctor01','2026-11-05 15:00:00',NULL),(19,19,1,'2026-11-05 09:36:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:36:00','doctor01','2026-11-05 15:00:00',NULL),(20,20,1,'2026-11-05 09:38:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:38:00','doctor01','2026-11-05 15:00:00',NULL),(21,21,1,'2026-11-05 09:40:00','4',3,'2026-11-05 15:00:00','审核通过','student','2026-11-05 09:40:00','doctor01','2026-11-05 15:00:00',NULL),(22,22,2,'2026-11-06 10:00:00','4',3,'2026-11-06 15:30:00','审核通过','student','2026-11-06 10:00:00','doctor01','2026-11-06 15:30:00',NULL),(23,23,2,'2026-11-06 10:03:00','4',3,'2026-11-06 15:30:00','审核通过','student','2026-11-06 10:03:00','doctor01','2026-11-06 15:30:00',NULL),(24,24,2,'2026-11-06 10:06:00','4',3,'2026-11-06 15:30:00','审核通过','student','2026-11-06 10:06:00','doctor01','2026-11-06 15:30:00',NULL),(25,25,2,'2026-11-06 10:09:00','4',3,'2026-11-06 15:30:00','审核通过','student','2026-11-06 10:09:00','doctor01','2026-11-06 15:30:00',NULL),(26,26,2,'2026-11-06 10:12:00','4',3,'2026-11-06 15:30:00','审核通过','student','2026-11-06 10:12:00','doctor01','2026-11-06 15:30:00',NULL),(27,2,3,'2026-11-11 09:00:00','0',NULL,NULL,NULL,'student','2026-11-11 09:00:00',NULL,NULL,NULL),(28,3,3,'2026-11-11 09:03:00','0',NULL,NULL,NULL,'student','2026-11-11 09:03:00',NULL,NULL,NULL),(29,4,3,'2026-11-11 09:06:00','0',NULL,NULL,NULL,'student','2026-11-11 09:06:00',NULL,NULL,NULL),(30,5,3,'2026-11-11 09:09:00','0',NULL,NULL,NULL,'student','2026-11-11 09:09:00',NULL,NULL,NULL),(31,6,3,'2026-11-11 09:12:00','0',NULL,NULL,NULL,'student','2026-11-11 09:12:00',NULL,NULL,NULL),(32,7,3,'2026-11-11 09:15:00','0',NULL,NULL,NULL,'student','2026-11-11 09:15:00',NULL,NULL,NULL),(33,8,3,'2026-11-11 09:18:00','0',NULL,NULL,NULL,'student','2026-11-11 09:18:00',NULL,NULL,NULL),(34,9,3,'2026-11-11 09:21:00','0',NULL,NULL,NULL,'student','2026-11-11 09:21:00',NULL,NULL,NULL),(35,10,3,'2026-11-11 09:24:00','0',NULL,NULL,NULL,'student','2026-11-11 09:24:00',NULL,NULL,NULL),(36,11,3,'2026-11-11 09:27:00','0',NULL,NULL,NULL,'student','2026-11-11 09:27:00',NULL,NULL,NULL),(37,12,3,'2026-11-11 09:30:00','0',NULL,NULL,NULL,'student','2026-11-11 09:30:00',NULL,NULL,NULL),(38,13,3,'2026-11-11 09:33:00','0',NULL,NULL,NULL,'student','2026-11-11 09:33:00',NULL,NULL,NULL),(39,14,3,'2026-11-10 14:00:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:00:00','doctor01','2026-11-10 17:00:00',NULL),(40,15,3,'2026-11-10 14:03:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:03:00','doctor01','2026-11-10 17:00:00',NULL),(41,16,3,'2026-11-10 14:06:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:06:00','doctor01','2026-11-10 17:00:00',NULL),(42,17,3,'2026-11-10 14:09:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:09:00','doctor01','2026-11-10 17:00:00',NULL),(43,18,3,'2026-11-10 14:12:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:12:00','doctor01','2026-11-10 17:00:00',NULL),(44,19,3,'2026-11-10 14:15:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:15:00','doctor01','2026-11-10 17:00:00',NULL),(45,20,3,'2026-11-10 14:18:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:18:00','doctor01','2026-11-10 17:00:00',NULL),(46,21,3,'2026-11-10 14:21:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:21:00','doctor01','2026-11-10 17:00:00',NULL),(47,22,3,'2026-11-10 14:24:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:24:00','doctor01','2026-11-10 17:00:00',NULL),(48,23,3,'2026-11-10 14:27:00','1',3,'2026-11-10 17:00:00','审核通过','student','2026-11-10 14:27:00','doctor01','2026-11-10 17:00:00',NULL),(49,24,3,'2026-11-11 10:05:00','2',3,'2026-11-11 11:00:00','证件照模糊，请重新上传后再次预约','student','2026-11-11 10:05:00','doctor01','2026-11-11 11:00:00',NULL),(50,25,3,'2026-11-11 10:20:00','3',NULL,NULL,NULL,'student','2026-11-11 10:20:00','student','2026-11-11 18:30:00','学生自行取消'),(52,1,3,'2026-11-12 15:47:36','1',1,'2026-11-12 15:53:21','','','2026-11-12 15:47:21','student01','2026-11-12 15:53:21',NULL);
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
  `batch_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次名称',
  `start_time` datetime DEFAULT NULL COMMENT '批次开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '批次结束时间',
  `exam_date` date DEFAULT NULL COMMENT '体检日期',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '体检地点',
  `capacity` int DEFAULT '0' COMMENT '名额上限',
  `booked_count` int DEFAULT '0' COMMENT '已预约人数',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0未开始 1预约中 2已结束）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_batch_name` (`batch_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='体检批次表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_exam_batch`
--

LOCK TABLES `ch_exam_batch` WRITE;
/*!40000 ALTER TABLE `ch_exam_batch` DISABLE KEYS */;
INSERT INTO `ch_exam_batch` VALUES (1,'2026年秋季体检第一批','2026-11-08 08:00:00','2026-11-08 17:00:00','2026-11-08','校医院体检中心',100,21,'2','admin','2026-11-11 18:31:03','',NULL,'已完成 21 人体检，另有 79 个名额未使用'),(2,'2026年秋季体检补检批次','2026-11-09 08:00:00','2026-11-09 17:00:00','2026-11-09','校医院体检中心',30,5,'2','admin','2026-11-11 18:31:03','',NULL,'补检批次，5 人全部完成'),(3,'2026年秋季体检第二批','2026-11-25 08:00:00','2026-11-25 17:00:00','2026-11-25','校医院体检中心',200,11,'1','admin','2026-11-11 18:31:03','','2026-11-12 15:59:11','预约中：11 人已通过（占名额），12 人待审核（审核通过才占名额），另有 1 人已拒绝、1 人已取消');
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
  `item_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目编码（唯一）',
  `item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目名称',
  `category` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '项目分类（字典 ch_exam_category）',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '计量单位',
  `field_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '对应体检记录字段名（用于异常判定取值）',
  `reference_min` decimal(10,2) DEFAULT NULL COMMENT '参考下限（空表示不限）',
  `reference_max` decimal(10,2) DEFAULT NULL COMMENT '参考上限（空表示不限）',
  `abnormal_rule` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '3' COMMENT '异常判定（0高于上限 1低于下限 2超出任一 3仅展示）',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '项目说明',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0启用 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
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
INSERT INTO `ch_exam_item` VALUES (1,'HGT-HEIGHT','身高','1','cm','height',NULL,NULL,'3','生长发育指标，单独一个数值没有正常/异常之分，仅记录','0','admin','2026-11-11 22:13:04','',NULL,''),(2,'HGT-WEIGHT','体重','1','kg','weight',NULL,NULL,'3','需结合身高计算 BMI 才有判断意义，体重本身不单独判定','0','admin','2026-11-11 22:13:04','',NULL,''),(3,'HGT-BMI','BMI','1','kg/m²','bmi',18.50,23.90,'0','中国成人标准：偏低<18.5 正常18.5-23.9 超重24-27.9 肥胖≥28；超上限判为异常','0','admin','2026-11-11 22:13:04','admin','2026-11-11 22:19:48',''),(4,'CIR-SBP','收缩压','2','mmHg','systolic_pressure',90.00,139.00,'0','成人参考 90-139mmHg，≥140 判为偏高','0','admin','2026-11-11 22:13:04','',NULL,''),(5,'CIR-DBP','舒张压','2','mmHg','diastolic_pressure',60.00,89.00,'0','成人参考 60-89mmHg，≥90 判为偏高','0','admin','2026-11-11 22:13:04','',NULL,''),(6,'CIR-PULSE','脉搏','2','次/分','heart_rate',60.00,100.00,'3','成人静息参考 60-100次/分；运动后偏高属正常，默认仅展示不判定','0','admin','2026-11-11 22:13:04','',NULL,''),(7,'EYE-VL','左眼视力','3','','vision_left',5.00,NULL,'3','对数视力表 5.0 为正常；近视矫正情况因人而异，默认仅展示不判定','0','admin','2026-11-11 22:13:04','',NULL,''),(8,'EYE-VR','右眼视力','3','','vision_right',5.00,NULL,'3','对数视力表 5.0 为正常；近视矫正情况因人而异，默认仅展示不判定','0','admin','2026-11-11 22:13:04','',NULL,'');
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
  `bmi_level` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT 'BMI等级（0偏低 1正常 2超重 3肥胖）',
  `systolic_pressure` int DEFAULT NULL COMMENT '收缩压(mmHg)',
  `diastolic_pressure` int DEFAULT NULL COMMENT '舒张压(mmHg)',
  `heart_rate` int DEFAULT NULL COMMENT '心率(次/分)',
  `vision_left` decimal(3,1) DEFAULT NULL COMMENT '左眼视力',
  `vision_right` decimal(3,1) DEFAULT NULL COMMENT '右眼视力',
  `abnormal_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0',
  `record_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '2' COMMENT '记录状态（0未登记 1录入中 2已完成）',
  `conclusion` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '体检小结',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `examiner_id` bigint DEFAULT NULL COMMENT '体检人员（sys_user.user_id）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_date` (`student_id`,`exam_date`),
  KEY `idx_er_batch` (`batch_id`),
  KEY `idx_examiner` (`examiner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='体检记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_exam_record`
--

LOCK TABLES `ch_exam_record` WRITE;
/*!40000 ALTER TABLE `ch_exam_record` DISABLE KEYS */;
INSERT INTO `ch_exam_record` VALUES (1,1,NULL,'2024-11-08',168.0,55.0,19.5,'1',112,72,74,5.0,4.9,'0','2','历年体检，各项指标正常','admin','2024-11-08 16:20:00','doctor01','2024-11-08 16:20:00','系统上线前历史体检记录（无关联批次）',3),(2,1,NULL,'2025-11-08',169.0,60.0,21.0,'1',116,75,76,5.0,5.0,'0','2','历年体检，各项指标正常','admin','2025-11-08 16:20:00','doctor01','2025-11-08 16:20:00','系统上线前历史体检记录（无关联批次）',3),(3,1,1,'2026-11-08',170.0,65.0,22.5,'1',120,78,78,5.0,5.0,'0','2','各项指标正常，继续保持规律作息','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(4,2,NULL,'2025-11-08',160.0,64.0,25.0,'2',118,76,80,4.8,4.8,'1','2','体重略偏高，建议增加运动','admin','2025-11-08 16:20:00','doctor01','2025-11-08 16:20:00','系统上线前历史体检记录（无关联批次）',3),(5,2,1,'2026-11-08',160.0,75.0,29.3,'3',132,88,82,4.8,4.7,'1','2','BMI 偏高，建议控制饮食并加强锻炼','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(6,3,1,'2026-11-08',178.0,58.0,18.3,'0',115,74,70,4.9,4.9,'0','2','偏瘦，建议加强营养','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(7,4,1,'2026-11-08',175.0,82.0,26.8,'2',128,82,76,4.9,4.9,'1','2','超重，建议加强有氧运动','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(8,5,1,'2026-11-08',172.0,90.0,30.4,'3',135,86,84,4.9,4.9,'1','2','肥胖，建议控制饮食并逐步增加运动量','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(9,6,1,'2026-11-08',163.0,48.0,18.1,'0',108,68,72,4.9,4.9,'0','2','偏瘦，注意均衡饮食','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(10,7,1,'2026-11-08',180.0,78.0,24.1,'2',126,80,74,4.9,4.9,'1','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(11,8,1,'2026-11-08',168.0,70.0,24.8,'2',122,79,76,4.9,4.9,'1','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(12,9,1,'2026-11-08',170.0,68.0,23.5,'1',118,76,72,4.9,4.9,'0','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(13,10,1,'2026-11-08',176.0,85.0,27.4,'2',145,92,88,4.9,4.9,'1','2','血压偏高、超重，建议复查血压并控制体重','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(14,11,1,'2026-11-08',182.0,88.0,26.6,'2',130,84,78,4.9,4.9,'1','2','超重，建议加强锻炼','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(15,12,1,'2026-11-08',165.0,56.0,20.6,'1',110,70,70,4.9,4.9,'0','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(16,13,1,'2026-11-08',177.0,60.0,19.2,'1',142,90,80,4.9,4.9,'1','2','血压偏高，建议安静休息后复测','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(17,14,1,'2026-11-08',171.0,72.0,24.6,'2',120,78,74,4.9,4.9,'1','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(18,15,1,'2026-11-08',174.0,95.0,31.4,'3',138,88,86,4.9,4.9,'1','2','肥胖，建议到校医院营养门诊咨询','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(19,16,1,'2026-11-08',160.0,62.0,24.2,'2',116,74,76,4.9,4.9,'1','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(20,17,1,'2026-11-08',179.0,74.0,23.1,'1',124,80,72,4.9,4.9,'0','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(21,18,1,'2026-11-08',166.0,66.0,24.0,'1',118,76,74,4.9,4.9,'0','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(22,19,1,'2026-11-08',183.0,80.0,23.9,'1',128,82,78,4.9,4.9,'0','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(23,20,1,'2026-11-08',169.0,86.0,30.1,'3',133,86,84,4.9,4.9,'1','2','超重，建议控制饮食','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(24,21,1,'2026-11-08',172.0,71.0,24.0,'1',121,78,74,4.9,4.9,'0','2','各项指标正常','admin','2026-11-08 16:20:00','doctor01','2026-11-08 16:20:00',NULL,3),(25,22,2,'2026-11-09',170.0,84.0,29.1,'3',130,84,80,4.8,4.8,'1','2','超重，建议加强运动','admin','2026-11-09 16:20:00','doctor01','2026-11-09 16:20:00',NULL,3),(26,23,2,'2026-11-09',175.0,93.0,30.4,'3',136,88,85,4.8,4.8,'1','2','肥胖，建议制定减重计划','admin','2026-11-09 16:20:00','doctor01','2026-11-09 16:20:00',NULL,3),(27,24,2,'2026-11-09',168.0,69.0,24.4,'2',120,78,74,4.8,4.8,'1','2','各项指标正常','admin','2026-11-09 16:20:00','doctor01','2026-11-09 16:20:00',NULL,3),(28,25,2,'2026-11-09',176.0,73.0,23.6,'1',122,80,72,4.8,4.8,'0','2','各项指标正常','admin','2026-11-09 16:20:00','doctor01','2026-11-09 16:20:00',NULL,3),(29,26,2,'2026-11-09',164.0,60.0,22.3,'1',116,74,76,4.8,4.8,'0','2','各项指标正常','admin','2026-11-09 16:20:00','doctor01','2026-11-09 16:20:00',NULL,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='健康档案表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_health_archive`
--

LOCK TABLES `ch_health_archive` WRITE;
/*!40000 ALTER TABLE `ch_health_archive` DISABLE KEYS */;
INSERT INTO `ch_health_archive` VALUES (1,1,3,'2026-11-08','累计体检 3 次，最近一次 2026-11-08。身高 170.0cm，体重 65.0kg，BMI 22.5（正常）；血压 120/78 mmHg；心率 78 次/分；视力 5.0/5.0。本次未发现异常指标。小结：各项指标正常，继续保持规律作息','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(2,2,2,'2026-11-08','累计体检 2 次，最近一次 2026-11-08。身高 160.0cm，体重 75.0kg，BMI 29.3（肥胖）；血压 132/88 mmHg；心率 82 次/分；视力 4.8/4.7。本次存在异常指标，建议复查并咨询校医。小结：BMI 偏高，建议控制饮食并加强锻炼','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(3,3,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 178.0cm，体重 58.0kg，BMI 18.3（偏低）；血压 115/74 mmHg；心率 70 次/分；视力 4.9/4.9。本次未发现异常指标。小结：偏瘦，建议加强营养','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(4,4,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 175.0cm，体重 82.0kg，BMI 26.8（超重）；血压 128/82 mmHg；心率 76 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：超重，建议加强有氧运动','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(5,5,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 172.0cm，体重 90.0kg，BMI 30.4（肥胖）；血压 135/86 mmHg；心率 84 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：肥胖，建议控制饮食并逐步增加运动量','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(6,6,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 163.0cm，体重 48.0kg，BMI 18.1（偏低）；血压 108/68 mmHg；心率 72 次/分；视力 4.9/4.9。本次未发现异常指标。小结：偏瘦，注意均衡饮食','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(7,7,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 180.0cm，体重 78.0kg，BMI 24.1（超重）；血压 126/80 mmHg；心率 74 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：各项指标正常','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(8,8,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 168.0cm，体重 70.0kg，BMI 24.8（超重）；血压 122/79 mmHg；心率 76 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：各项指标正常','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(9,9,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 170.0cm，体重 68.0kg，BMI 23.5（正常）；血压 118/76 mmHg；心率 72 次/分；视力 4.9/4.9。本次未发现异常指标。小结：各项指标正常','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(10,10,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 176.0cm，体重 85.0kg，BMI 27.4（超重）；血压 145/92 mmHg；心率 88 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：血压偏高、超重，建议复查血压并控制体重','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(11,11,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 182.0cm，体重 88.0kg，BMI 26.6（超重）；血压 130/84 mmHg；心率 78 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：超重，建议加强锻炼','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(12,12,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 165.0cm，体重 56.0kg，BMI 20.6（正常）；血压 110/70 mmHg；心率 70 次/分；视力 4.9/4.9。本次未发现异常指标。小结：各项指标正常','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(13,13,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 177.0cm，体重 60.0kg，BMI 19.2（正常）；血压 142/90 mmHg；心率 80 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：血压偏高，建议安静休息后复测','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(14,14,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 171.0cm，体重 72.0kg，BMI 24.6（超重）；血压 120/78 mmHg；心率 74 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：各项指标正常','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(15,15,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 174.0cm，体重 95.0kg，BMI 31.4（肥胖）；血压 138/88 mmHg；心率 86 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：肥胖，建议到校医院营养门诊咨询','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(16,16,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 160.0cm，体重 62.0kg，BMI 24.2（超重）；血压 116/74 mmHg；心率 76 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：各项指标正常','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(17,17,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 179.0cm，体重 74.0kg，BMI 23.1（正常）；血压 124/80 mmHg；心率 72 次/分；视力 4.9/4.9。本次未发现异常指标。小结：各项指标正常','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(18,18,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 166.0cm，体重 66.0kg，BMI 24.0（正常）；血压 118/76 mmHg；心率 74 次/分；视力 4.9/4.9。本次未发现异常指标。小结：各项指标正常','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(19,19,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 183.0cm，体重 80.0kg，BMI 23.9（正常）；血压 128/82 mmHg；心率 78 次/分；视力 4.9/4.9。本次未发现异常指标。小结：各项指标正常','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(20,20,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 169.0cm，体重 86.0kg，BMI 30.1（肥胖）；血压 133/86 mmHg；心率 84 次/分；视力 4.9/4.9。本次存在异常指标，建议复查并咨询校医。小结：超重，建议控制饮食','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(21,21,1,'2026-11-08','累计体检 1 次，最近一次 2026-11-08。身高 172.0cm，体重 71.0kg，BMI 24.0（正常）；血压 121/78 mmHg；心率 74 次/分；视力 4.9/4.9。本次未发现异常指标。小结：各项指标正常','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(22,22,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09。身高 170.0cm，体重 84.0kg，BMI 29.1（肥胖）；血压 130/84 mmHg；心率 80 次/分；视力 4.8/4.8。本次存在异常指标，建议复查并咨询校医。小结：超重，建议加强运动','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(23,23,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09。身高 175.0cm，体重 93.0kg，BMI 30.4（肥胖）；血压 136/88 mmHg；心率 85 次/分；视力 4.8/4.8。本次存在异常指标，建议复查并咨询校医。小结：肥胖，建议制定减重计划','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(24,24,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09。身高 168.0cm，体重 69.0kg，BMI 24.4（超重）；血压 120/78 mmHg；心率 74 次/分；视力 4.8/4.8。本次存在异常指标，建议复查并咨询校医。小结：各项指标正常','1','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(25,25,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09。身高 176.0cm，体重 73.0kg，BMI 23.6（正常）；血压 122/80 mmHg；心率 72 次/分；视力 4.8/4.8。本次未发现异常指标。小结：各项指标正常','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(26,26,1,'2026-11-09','累计体检 1 次，最近一次 2026-11-09。身高 164.0cm，体重 60.0kg，BMI 22.3（正常）；血压 116/74 mmHg；心率 76 次/分；视力 4.8/4.8。本次未发现异常指标。小结：各项指标正常','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(27,27,0,NULL,'暂无体检记录，完成首次体检后自动生成健康摘要','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL),(28,28,0,NULL,'暂无体检记录，完成首次体检后自动生成健康摘要','0','admin','2026-11-11 09:00:00','doctor01','2026-11-11 09:00:00',NULL);
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
  `student_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学号',
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '性别（0男 1女 2未知）',
  `birthday` date DEFAULT NULL COMMENT '出生日期',
  `college` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '学院',
  `major` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '专业',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '班级',
  `dept_id` bigint DEFAULT NULL COMMENT '归属部门（班级）',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '联系电话',
  `enroll_year` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '入学年份',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_no` (`student_no`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='学生信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ch_student`
--

LOCK TABLES `ch_student` WRITE;
/*!40000 ALTER TABLE `ch_student` DISABLE KEYS */;
INSERT INTO `ch_student` VALUES (1,5,'20260001','张伟','0','2006-02-02','软件技术学院','软件技术','软件2401',120,'13810000137','2024','0','admin','2026-11-11 18:31:03','','2026-11-12 16:08:46',NULL),(2,6,'20260002','李娜','1','2006-03-03','软件技术学院','软件技术','软件2402',121,'13810000274','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(3,NULL,'20260003','王强','0','2006-04-04','计算机学院','计算机应用技术','计应2401',122,'13810000411','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(4,NULL,'20260004','刘洋','1','2006-05-05','信息工程学院','大数据技术','大数据2401',123,'13810000548','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(5,NULL,'20260005','陈静','0','2006-06-06','智能制造学院','机电一体化','机电2401',124,'13810000685','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(6,NULL,'20260006','杨帆','1','2006-07-07','软件技术学院','软件技术','软件2401',120,'13810000822','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(7,NULL,'20260007','赵敏','0','2006-08-08','软件技术学院','软件技术','软件2402',121,'13810000959','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(8,NULL,'20260008','黄磊','1','2006-09-09','计算机学院','计算机应用技术','计应2401',122,'13810001096','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(9,NULL,'20260009','周鑫','0','2006-10-10','信息工程学院','大数据技术','大数据2401',123,'13810001233','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(10,NULL,'20260010','吴倩','1','2006-11-11','智能制造学院','机电一体化','机电2401',124,'13810001370','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(11,NULL,'20260011','徐鹏','0','2006-12-12','软件技术学院','软件技术','软件2401',120,'13810001507','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(12,NULL,'20260012','孙悦','1','2006-01-13','软件技术学院','软件技术','软件2402',121,'13810001644','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(13,NULL,'20260013','马超','0','2006-02-14','计算机学院','计算机应用技术','计应2401',122,'13810001781','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(14,NULL,'20260014','朱婷','1','2006-03-15','信息工程学院','大数据技术','大数据2401',123,'13810001918','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(15,NULL,'20260015','胡军','0','2006-04-16','智能制造学院','机电一体化','机电2401',124,'13810002055','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(16,NULL,'20260016','郭雪','1','2006-05-17','软件技术学院','软件技术','软件2401',120,'13810002192','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(17,NULL,'20260017','何俊','0','2006-06-18','软件技术学院','软件技术','软件2402',121,'13810002329','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(18,NULL,'20260018','高峰','1','2006-07-19','计算机学院','计算机应用技术','计应2401',122,'13810002466','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(19,NULL,'20260019','林琳','0','2006-08-20','信息工程学院','大数据技术','大数据2401',123,'13810002603','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(20,NULL,'20260020','罗浩','1','2006-09-21','智能制造学院','机电一体化','机电2401',124,'13810002740','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(21,NULL,'20260021','梁爽','0','2006-10-22','软件技术学院','软件技术','软件2401',120,'13810002877','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(22,NULL,'20260022','宋涛','1','2006-11-23','软件技术学院','软件技术','软件2402',121,'13810003014','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(23,NULL,'20260023','唐颖','0','2006-12-24','计算机学院','计算机应用技术','计应2401',122,'13810003151','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(24,NULL,'20260024','许诺','1','2006-01-25','信息工程学院','大数据技术','大数据2401',123,'13810003288','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(25,NULL,'20260025','韩雨','0','2006-02-26','智能制造学院','机电一体化','机电2401',124,'13810003425','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(26,NULL,'20260026','冯磊','1','2006-03-27','软件技术学院','软件技术','软件2401',120,'13810003562','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(27,NULL,'20260027','邓佳','0','2006-04-01','软件技术学院','软件技术','软件2402',121,'13810003699','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL),(28,NULL,'20260028','曹阳','1','2006-05-02','计算机学院','计算机应用技术','计应2401',122,'13810003836','2024','0','admin','2026-11-11 18:31:03','',NULL,NULL);
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
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int DEFAULT '1' COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
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
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日历名称',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时区',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否接受恢复执行',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否接受恢复执行',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '悲观锁名称',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '实例名称',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
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
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日程表名称',
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
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
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
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
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
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
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
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
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
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注信息',
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
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
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
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (1,'student01','127.0.0.1','内网IP','Hacker','Hacker','0','登录成功','2026-11-12 14:09:33'),(2,'student01','127.0.0.1','内网IP','Hacker','Hacker','0','登录成功','2026-11-12 14:12:15'),(3,'admin','127.0.0.1','内网IP','Hacker','Hacker','0','登录成功','2026-11-12 14:12:15'),(4,'teacher01','127.0.0.1','内网IP','Hacker','Hacker','0','登录成功','2026-11-12 14:12:31'),(5,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 14:27:54'),(6,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','退出成功','2026-11-12 14:53:13'),(7,'student01','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 14:53:33'),(8,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 14:54:06'),(9,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 15:33:20'),(10,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','退出成功','2026-11-12 15:37:33'),(11,'20260001','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:37:55'),(12,'20260001','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:38:11'),(13,'20260001','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:39:32'),(14,'student01','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 15:39:46'),(15,'student01','127.0.0.1','内网IP','Edge 157','Windows >=10','0','退出成功','2026-11-12 15:48:14'),(16,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:49:06'),(17,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:49:48'),(18,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:49:56'),(19,'admin123','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:50:43'),(20,'admin123','127.0.0.1','内网IP','Edge 157','Windows >=10','1','验证码错误','2026-11-12 15:50:57'),(21,'admin123','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:51:02'),(22,'admin123','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:51:17'),(23,'admin','127.0.0.1','内网IP','QoderCN 0.5.7','Windows 10.0','1','验证码已失效','2026-11-12 15:51:42'),(24,'admin','127.0.0.1','内网IP','QoderCN 0.5.7','Windows 10.0','0','登录成功','2026-11-12 15:51:48'),(25,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 15:51:58'),(26,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','退出成功','2026-11-12 15:56:16'),(27,'student01','127.0.0.1','内网IP','Edge 157','Windows >=10','1','用户不存在/密码错误','2026-11-12 15:56:30'),(28,'student01','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 15:56:47'),(29,'student01','127.0.0.1','内网IP','Edge 157','Windows >=10','0','退出成功','2026-11-12 15:57:25'),(30,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 15:57:36'),(31,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','退出成功','2026-11-12 16:04:52'),(32,'doctor01','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 16:05:03'),(33,'doctor01','127.0.0.1','内网IP','Edge 157','Windows >=10','0','退出成功','2026-11-12 16:05:39'),(34,'teacher01','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 16:05:42'),(35,'teacher01','127.0.0.1','内网IP','Edge 157','Windows >=10','0','退出成功','2026-11-12 16:05:56'),(36,'admin','127.0.0.1','内网IP','Edge 157','Windows >=10','0','登录成功','2026-11-12 16:06:08'),(37,'admin','127.0.0.1','内网IP','Hacker','Hacker','0','登录成功','2026-11-12 16:14:18');
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
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2070 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,5,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-11-10 17:10:45','',NULL,'系统管理目录'),(2,'系统监控',0,6,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-11-10 17:10:45','',NULL,'系统监控目录'),(3,'系统工具',0,7,'tool',NULL,'','',1,0,'M','0','0','','tool','admin','2026-11-10 17:10:45','',NULL,'系统工具目录'),(4,'若依官网',0,8,'http://ruoyi.vip',NULL,'','',0,0,'M','1','0','','guide','admin','2026-11-10 17:10:45','',NULL,'若依官网地址'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-11-10 17:10:45','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-11-10 17:10:45','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-11-10 17:10:45','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2026-11-10 17:10:45','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2026-11-10 17:10:45','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-11-10 17:10:45','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-11-10 17:10:45','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2026-11-10 17:10:45','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2026-11-10 17:10:45','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2026-11-10 17:10:45','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2026-11-10 17:10:45','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2026-11-10 17:10:45','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2026-11-10 17:10:45','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2026-11-10 17:10:45','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2026-11-10 17:10:45','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2026-11-10 17:10:45','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2026-11-10 17:10:45','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2026-11-10 17:10:45','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-11-10 17:10:45','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-11-10 17:10:45','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-11-10 17:10:45','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-11-10 17:10:45','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-11-10 17:10:45','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-11-10 17:10:45','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-11-10 17:10:45','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-11-10 17:10:45','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-11-10 17:10:45','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-11-10 17:10:45','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2026-11-10 17:10:45','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2026-11-10 17:10:45','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2026-11-10 17:10:45','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2026-11-10 17:10:45','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2026-11-10 17:10:45','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2026-11-10 17:10:45','',NULL,''),(2001,'学生信息管理',2055,1,'info','health/student/index',NULL,'',1,0,'C','0','0','health:student:list','people','admin','2026-11-10 20:49:32','admin','2026-11-12 16:13:41','学生信息菜单'),(2002,'学生信息查询',2001,1,'#','',NULL,'',1,0,'F','0','0','health:student:query','#','admin','2026-11-10 20:49:32','',NULL,''),(2003,'学生信息新增',2001,2,'#','',NULL,'',1,0,'F','0','0','health:student:add','#','admin','2026-11-10 20:49:32','',NULL,''),(2004,'学生信息修改',2001,3,'#','',NULL,'',1,0,'F','0','0','health:student:edit','#','admin','2026-11-10 20:49:32','',NULL,''),(2005,'学生信息删除',2001,4,'#','',NULL,'',1,0,'F','0','0','health:student:remove','#','admin','2026-11-10 20:49:32','',NULL,''),(2006,'学生信息导出',2001,5,'#','',NULL,'',1,0,'F','0','0','health:student:export','#','admin','2026-11-10 20:49:32','',NULL,''),(2013,'体检登记管理',2056,4,'registration','health/examRecord/index',NULL,'',1,0,'C','0','0','health:examRecord:list','edit','admin','2026-11-10 23:42:53','admin','2026-11-12 16:13:41','体检记录菜单'),(2014,'体检记录查询',2013,1,'#','',NULL,'',1,0,'F','0','0','health:examRecord:query','#','admin','2026-11-10 23:42:53','',NULL,''),(2015,'体检记录新增',2013,2,'#','',NULL,'',1,0,'F','0','0','health:examRecord:add','#','admin','2026-11-10 23:42:53','',NULL,''),(2016,'体检记录修改',2013,3,'#','',NULL,'',1,0,'F','0','0','health:examRecord:edit','#','admin','2026-11-10 23:42:53','',NULL,''),(2017,'体检记录删除',2013,4,'#','',NULL,'',1,0,'F','0','0','health:examRecord:remove','#','admin','2026-11-10 23:42:53','',NULL,''),(2018,'体检记录导出',2013,5,'#','',NULL,'',1,0,'F','0','0','health:examRecord:export','#','admin','2026-11-10 23:42:53','',NULL,''),(2019,'体检批次管理',2056,2,'batch','health/examBatch/index',NULL,'',1,0,'C','0','0','health:examBatch:list','date-range','admin','2026-11-11 16:23:36','admin','2026-11-12 16:13:41','体检批次菜单'),(2020,'体检批次查询',2019,1,'#','',NULL,'',1,0,'F','0','0','health:examBatch:query','#','admin','2026-11-11 16:23:36','',NULL,''),(2021,'体检批次新增',2019,2,'#','',NULL,'',1,0,'F','0','0','health:examBatch:add','#','admin','2026-11-11 16:23:36','',NULL,''),(2022,'体检批次修改',2019,3,'#','',NULL,'',1,0,'F','0','0','health:examBatch:edit','#','admin','2026-11-11 16:23:36','',NULL,''),(2023,'体检批次删除',2019,4,'#','',NULL,'',1,0,'F','0','0','health:examBatch:remove','#','admin','2026-11-11 16:23:36','',NULL,''),(2024,'体检批次导出',2019,5,'#','',NULL,'',1,0,'F','0','0','health:examBatch:export','#','admin','2026-11-11 16:23:36','',NULL,''),(2037,'体检预约管理',2056,3,'appointment','health/appointment/index',NULL,'',1,0,'C','0','0','health:appointment:list','date','admin','2026-11-11 16:41:04','admin','2026-11-12 16:13:41','体检预约菜单'),(2038,'体检预约查询',2037,1,'#','',NULL,'',1,0,'F','0','0','health:appointment:query','#','admin','2026-11-11 16:41:04','',NULL,''),(2039,'体检预约新增',2037,2,'#','',NULL,'',1,0,'F','0','0','health:appointment:add','#','admin','2026-11-11 16:41:04','',NULL,''),(2040,'体检预约修改',2037,3,'#','',NULL,'',1,0,'F','0','0','health:appointment:edit','#','admin','2026-11-11 16:41:04','',NULL,''),(2041,'体检预约删除',2037,4,'#','',NULL,'',1,0,'F','0','0','health:appointment:remove','#','admin','2026-11-11 16:41:04','',NULL,''),(2042,'体检预约导出',2037,5,'#','',NULL,'',1,0,'F','0','0','health:appointment:export','#','admin','2026-11-11 16:41:04','',NULL,''),(2043,'个人健康档案',2057,1,'my','health/archive/index',NULL,'',1,0,'C','0','0','health:archive:query','documentation','admin','2026-11-11 18:11:56','',NULL,'学生健康档案（最新指标/历史记录/BMI趋势）'),(2044,'智能健康管理',0,3,'ai',NULL,NULL,'',1,0,'M','0','0','','education','admin','2026-11-11 18:25:00','admin','2026-11-11 19:00:39','AI智能健康评估目录'),(2045,'AI健康评估',2044,1,'assessment','health/ai/index',NULL,'',1,0,'C','0','0','health:ai:list','education','admin','2026-11-11 18:33:02','',NULL,'AI健康评估菜单'),(2046,'AI评估查询',2045,1,'',NULL,NULL,'',1,0,'F','0','0','health:ai:query','#','admin','2026-11-11 18:33:02','',NULL,''),(2047,'AI评估生成',2045,2,'',NULL,NULL,'',1,0,'F','0','0','health:ai:assess','#','admin','2026-11-11 18:33:02','',NULL,''),(2048,'AI评估删除',2045,3,'',NULL,NULL,'',1,0,'F','0','0','health:ai:remove','#','admin','2026-11-11 18:33:02','',NULL,''),(2049,'体检项目管理',2056,1,'item','health/examItem/index','','',1,0,'C','0','0','health:examItem:list','component','admin','2026-11-11 22:13:04','',NULL,'体检项目菜单'),(2050,'体检项目查询',2049,1,'#','','','',1,0,'F','0','0','health:examItem:query','#','admin','2026-11-11 22:13:04','',NULL,''),(2051,'体检项目新增',2049,2,'#','','','',1,0,'F','0','0','health:examItem:add','#','admin','2026-11-11 22:13:04','',NULL,''),(2052,'体检项目修改',2049,3,'#','','','',1,0,'F','0','0','health:examItem:edit','#','admin','2026-11-11 22:13:04','',NULL,''),(2053,'体检项目删除',2049,4,'#','','','',1,0,'F','0','0','health:examItem:remove','#','admin','2026-11-11 22:13:04','',NULL,''),(2054,'体检项目导出',2049,5,'#','','','',1,0,'F','0','0','health:examItem:export','#','admin','2026-11-11 22:13:04','',NULL,''),(2055,'学生管理',0,0,'studentManage','','','',1,0,'M','0','0','','user','admin','2026-11-11 22:25:20','',NULL,'学生信息分组'),(2056,'体检管理',0,1,'examManage','','','',1,0,'M','0','0','','documentation','admin','2026-11-11 22:25:20','',NULL,'体检业务分组'),(2057,'健康档案',0,2,'archiveManage','','','',1,0,'M','0','0','','peoples','admin','2026-11-11 22:25:20','',NULL,'健康档案分组'),(2058,'数据统计',0,4,'statistics','','','',1,0,'M','0','0','','chart','admin','2026-11-11 22:25:20','',NULL,'统计分组'),(2059,'学生信息导入',2055,2,'import','health/student/import','','',1,0,'C','0','0','health:student:import','upload','admin','2026-11-11 22:25:20','',NULL,'Excel 批量导入'),(2060,'历史体检记录',2057,2,'history','health/examRecord/history','','',1,0,'C','0','0','health:examRecord:list','time-range','admin','2026-11-11 22:25:20','',NULL,'只读查询历年体检结果'),(2061,'异常指标管理',2057,3,'abnormal','health/abnormal/index','','',1,0,'C','0','0','health:examRecord:list','warning','admin','2026-11-11 22:25:20','',NULL,'按体检项目参考范围筛出的异常记录'),(2062,'AI评估报告',2044,2,'report','health/ai/report','','',1,0,'C','0','0','health:ai:list','form','admin','2026-11-11 22:25:20','',NULL,'按学生查看AI健康评估报告'),(2063,'体检完成情况',2058,1,'complete','health/statistics/complete','','',1,0,'C','0','0','health:stats:list','chart','admin','2026-11-11 22:25:20','',NULL,'完成率与批次预约进度'),(2064,'健康数据统计',2058,2,'health','health/statistics/health','','',1,0,'C','0','0','health:stats:list','monitor','admin','2026-11-11 22:25:20','',NULL,'BMI分布与异常比例'),(2065,'我的健康',0,0,'myHealth',NULL,'','',1,0,'M','0','0','','peoples','admin','2026-11-11 22:39:42','',NULL,'学生自助入口：只看得到自己的数据'),(2066,'我的体检预约',2065,1,'myAppointment','health/my/appointment','','',1,0,'C','0','0','health:my:appointment','date','admin','2026-11-11 22:39:42','admin','2026-11-12 14:00:59','查看批次、提交预约、取消预约'),(2067,'我的健康档案',2065,2,'archive','health/my/archive','','',1,0,'C','0','0','health:my:archive','documentation','admin','2026-11-11 22:39:42','',NULL,'个人档案与历年体检趋势'),(2068,'我的体检记录',2065,3,'records','health/my/records','','',1,0,'C','0','0','health:my:records','list','admin','2026-11-11 22:39:42','',NULL,'历次体检明细与异常指标'),(2069,'我的AI报告',2065,4,'myAi','health/my/ai','','',1,0,'C','0','0','health:my:ai','education','admin','2026-11-11 23:23:28','admin','2026-11-12 14:00:59','学生查看自己的AI健康评估报告');
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
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='公告已读记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice_read`
--

LOCK TABLES `sys_notice_read` WRITE;
/*!40000 ALTER TABLE `sys_notice_read` DISABLE KEYS */;
INSERT INTO `sys_notice_read` VALUES (1,3,1,'2026-11-12 15:35:58'),(2,2,1,'2026-11-12 15:35:58'),(3,1,1,'2026-11-12 15:35:58');
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
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (1,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/29','127.0.0.1','内网IP','29 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[]\",\"assessStatus\":\"2\",\"assessmentResult\":\"本次体检所有指标均在正常范围内，未发现异常，整体风险等级为低。\",\"createBy\":\"system\",\"createTime\":\"2026-11-09 17:05:00\",\"examDate\":\"2026-11-09\",\"examRecordId\":29,\"id\":29,\"modelName\":\"liquid/lfm-3-1.7b:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"LOW\",\"studentId\":26,\"studentName\":\"冯磊\",\"studentNo\":\"20260026\",\"suggestions\":\"[\\\"以均衡饮食为主，确保每天摄入足够的蔬菜、水果和全谷物，限制高盐、高油、高糖食物。\\\",\\\"每日进行至少30分钟的中等强度有氧运动（如快走、慢跑或骑行），帮助维持心率和体重。\\\",\\\"保证每晚7-9小时的高质量睡眠，固定起床时间，避免睡前使用电子设备导致失眠。\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-12 14:09:26\"}}',0,NULL,'2026-11-12 14:09:26',9975),(2,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.apply()','POST',1,'student01','软件2401','/health/appointment/apply','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 14:17:58',24),(3,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.cancel()','PUT',1,'student01','软件2401','/health/appointment/cancel/51','127.0.0.1','内网IP','51 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 14:19:56',22),(4,'学生信息',2,'com.ruoyi.health.controller.StudentController.edit()','PUT',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"birthday\":\"2006-02-02\",\"className\":\"软件2401\",\"college\":\"软件技术学院\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:31:03\",\"deptId\":120,\"enrollYear\":\"2024\",\"gender\":\"1\",\"id\":1,\"major\":\"软件技术\",\"params\":{},\"phone\":\"13810000137\",\"status\":\"0\",\"studentName\":\"张伟\",\"studentNo\":\"20260001\",\"updateBy\":\"\",\"updateTime\":\"2026-11-12 14:50:40\",\"userId\":5} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 14:50:41',71),(5,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.apply()','POST',1,'student01','软件2401','/health/appointment/apply','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 15:47:21',75),(6,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.cancel()','PUT',1,'student01','软件2401','/health/appointment/cancel/52','127.0.0.1','内网IP','52 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 15:47:25',27),(7,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.apply()','POST',1,'student01','软件2401','/health/appointment/apply','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 15:47:30',25),(8,'体检预约',2,'com.ruoyi.health.controller.AppointmentController.cancel()','PUT',1,'student01','软件2401','/health/appointment/cancel/52','127.0.0.1','内网IP','52 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 15:47:32',20),(9,'体检预约',1,'com.ruoyi.health.controller.AppointmentController.apply()','POST',1,'student01','软件2401','/health/appointment/apply','127.0.0.1','内网IP','{\"batchId\":3,\"params\":{}} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 15:47:36',26),(10,'体检预约审核',2,'com.ruoyi.health.controller.AppointmentController.audit()','PUT',1,'admin','研发部门','/health/appointment/audit','127.0.0.1','内网IP','{\"id\":52,\"params\":{},\"status\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 15:53:20',20),(11,'体检批次',2,'com.ruoyi.health.controller.ExamBatchController.edit()','PUT',1,'admin','研发部门','/health/examBatch','127.0.0.1','内网IP','{\"batchName\":\"2026年秋季体检第二批\",\"bookedCount\":11,\"capacity\":200,\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:31:03\",\"endTime\":\"2026-11-25 17:00:00\",\"examDate\":\"2026-11-25\",\"id\":3,\"location\":\"校医院体检中心\",\"params\":{},\"remark\":\"预约中：11 人已通过（占名额），12 人待审核（审核通过才占名额），另有 1 人已拒绝、1 人已取消\",\"startTime\":\"2026-11-25 08:00:00\",\"status\":\"1\",\"updateBy\":\"\",\"updateTime\":\"2026-11-12 15:59:11\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 15:59:11',19),(12,'学生信息',2,'com.ruoyi.health.controller.StudentController.edit()','PUT',1,'admin','研发部门','/health/student','127.0.0.1','内网IP','{\"birthday\":\"2006-02-02\",\"className\":\"软件2401\",\"college\":\"软件技术学院\",\"createBy\":\"admin\",\"createTime\":\"2026-11-11 18:31:03\",\"deptId\":120,\"enrollYear\":\"2024\",\"gender\":\"0\",\"id\":1,\"major\":\"软件技术\",\"params\":{},\"phone\":\"13810000137\",\"status\":\"0\",\"studentName\":\"张伟\",\"studentNo\":\"20260001\",\"updateBy\":\"\",\"updateTime\":\"2026-11-12 16:08:45\",\"userId\":5} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-12 16:08:45',12),(13,'AI健康评估',1,'com.ruoyi.health.controller.AiAssessmentController.assess()','POST',1,'admin','研发部门','/health/ai/assess/5','127.0.0.1','内网IP','5 ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"abnormalItems\":\"[{\\\"item\\\":\\\"BMI\\\",\\\"value\\\":\\\"29.3\\\",\\\"reference\\\":\\\"≥28（成人肥胖参考）\\\",\\\"explanation\\\":\\\"BMI 偏高，属于系统判定为肥胖范围，提示体重与身高比例较大，不能据此诊断学生是否患病。\\\"}]\",\"assessStatus\":\"2\",\"assessmentResult\":\"本次体检共判定1项异常，BMI 提示肥胖，系统风险等级为中风险。\",\"createBy\":\"system\",\"createTime\":\"2026-11-08 17:05:00\",\"examDate\":\"2026-11-08\",\"examRecordId\":5,\"id\":5,\"modelName\":\"recursive/flint-v1.0:free\",\"params\":{},\"remark\":\"本报告仅供健康管理参考，不能代替医生的专业诊断\",\"riskLevel\":\"MEDIUM\",\"studentId\":2,\"studentName\":\"李娜\",\"studentNo\":\"20260002\",\"suggestions\":\"[\\\"减少精制糖和高脂高糖食物摄入，增加蔬菜、水果、全谷物和适量优质蛋白摄入。\\\",\\\"坚持规律有氧运动，如每周至少150分钟中等强度运动，并可配合力量训练。\\\",\\\"保证充足睡眠，控制饮食总量，定期监测体重和其他健康指标。\\\",\\\"若出现胸痛、气短、心悸等明显症状，应及时咨询专业医生。\\\"]\",\"updateBy\":\"admin\",\"updateTime\":\"2026-11-12 16:09:35\"}}',0,NULL,'2026-11-12 16:09:35',8410);
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
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
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
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
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
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','若依','00','ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-12 16:14:18','2026-11-10 17:10:45','admin','2026-11-10 17:10:45','',NULL,'管理员'),(2,105,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-10 17:10:45','2026-11-10 17:10:45','admin','2026-11-10 17:10:45','',NULL,'测试员'),(3,110,'doctor01','王医生','00','doctor01@campus.edu.cn','13900000001','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-12 16:05:03',NULL,'admin','2026-11-11 22:39:42','',NULL,'演示账号：校医'),(4,120,'teacher01','李老师','00','teacher01@campus.edu.cn','13900000002','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-12 16:05:43',NULL,'admin','2026-11-11 22:39:42','',NULL,'演示账号：辅导员'),(5,120,'student01','张伟','00','student01@campus.edu.cn','13810000137','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-12 15:56:48',NULL,'admin','2026-11-11 22:39:42','',NULL,'演示账号：学生（20260001 张伟）'),(6,121,'student02','李娜','00','student02@campus.edu.cn','13810000274','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-11 23:25:07',NULL,'admin','2026-11-11 22:39:42','',NULL,'演示账号：学生（20260002 李娜）');
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

--
-- Dumping routines for database 'campus_health'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-12 16:46:52
