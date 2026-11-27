-- =====================================================================
-- 校园健康管理系统 —— 业务数据"正常化"重建脚本
-- ---------------------------------------------------------------------
-- 目的：把测试过程中产生的脏数据整理成一套自洽、可演示的数据
--   1. 删除垃圾数据（无角色测试账号、乱填的学生、孤儿档案、孤儿评估任务）
--   2. 批次：过去两批 = 已结束，未来批次 = 预约中，容量/已约人数与真实预约数一致
--   3. 预约：过去批次的 26 条全部走到「已完成」；未来批次覆盖 待审核/已预约/已拒绝/已取消 四种状态
--   4. 健康档案：按体检记录重算（次数、最近日期、摘要、异常标记）
--   5. AI 评估任务：每条体检记录一条，保留已有 5 份报告，其余为待评估
--   6. 清空登录日志、操作日志、代码生成器残留
-- 执行方式（副本库验证过，可重复执行）：
--   mysql -uroot -p123456 campus_health < sql/rebuild_clean_data.sql
-- =====================================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------
-- 一、垃圾数据清理
-- ---------------------------------------------------------------------
-- 1.1 开号测试留下的无角色账号（20269999）
DELETE FROM sys_user_role WHERE user_id = 101;
DELETE FROM sys_user      WHERE user_id = 101;

-- 1.2 乱填的学生档案（学号 2403100121 / 姓名"撒谎那个号借"）
DELETE FROM ch_ai_assessment  WHERE student_id = 35;
DELETE FROM ch_appointment    WHERE student_id = 35;
DELETE FROM ch_exam_record    WHERE student_id = 35;
DELETE FROM ch_health_archive WHERE student_id = 35;
DELETE FROM ch_student        WHERE id = 35;

-- 1.3 孤儿数据（宿主记录/学生已被删除的）
DELETE a FROM ch_ai_assessment a
LEFT JOIN ch_exam_record r ON r.id = a.exam_record_id WHERE r.id IS NULL;

DELETE h FROM ch_health_archive h
LEFT JOIN ch_student s ON s.id = h.student_id WHERE s.id IS NULL;

-- ---------------------------------------------------------------------
-- 二、批次：容量与已约人数对齐真实预约
-- ---------------------------------------------------------------------
UPDATE ch_exam_batch
SET capacity = 100, booked_count = 21, status = '2',
    remark = '已完成 21 人体检，另有 79 个名额未使用'
WHERE id = 1;

UPDATE ch_exam_batch
SET capacity = 30, booked_count = 5, status = '2',
    remark = '补检批次，5 人全部完成'
WHERE id = 2;

UPDATE ch_exam_batch
SET capacity = 200, booked_count = 10, status = '1',
    remark = '预约中：10 人已通过（占名额），12 人待审核（审核通过才占名额），另有 1 人已拒绝、1 人已取消'
WHERE id = 3;

-- ---------------------------------------------------------------------
-- 三、预约：过去批次收尾为「已完成」，未来批次四种状态齐全
-- ---------------------------------------------------------------------
TRUNCATE TABLE ch_appointment;

INSERT INTO ch_appointment
 (id, student_id, batch_id, appointment_time, status, audit_user, audit_time, audit_remark, create_by, create_time, update_by, update_time, remark)
VALUES
-- 批次1（2026-11-08）1-21 号学生，全部已完成
 (1, 1, 1, '2026-11-05 09:00:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:00:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (2, 2, 1, '2026-11-05 09:02:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:02:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (3, 3, 1, '2026-11-05 09:04:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:04:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (4, 4, 1, '2026-11-05 09:06:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:06:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (5, 5, 1, '2026-11-05 09:08:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:08:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (6, 6, 1, '2026-11-05 09:10:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:10:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (7, 7, 1, '2026-11-05 09:12:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:12:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (8, 8, 1, '2026-11-05 09:14:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:14:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (9, 9, 1, '2026-11-05 09:16:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:16:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (10, 10, 1, '2026-11-05 09:18:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:18:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (11, 11, 1, '2026-11-05 09:20:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:20:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (12, 12, 1, '2026-11-05 09:22:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:22:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (13, 13, 1, '2026-11-05 09:24:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:24:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (14, 14, 1, '2026-11-05 09:26:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:26:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (15, 15, 1, '2026-11-05 09:28:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:28:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (16, 16, 1, '2026-11-05 09:30:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:30:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (17, 17, 1, '2026-11-05 09:32:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:32:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (18, 18, 1, '2026-11-05 09:34:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:34:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (19, 19, 1, '2026-11-05 09:36:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:36:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (20, 20, 1, '2026-11-05 09:38:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:38:00', 'doctor01', '2026-11-05 15:00:00', NULL),
 (21, 21, 1, '2026-11-05 09:40:00', '4', 3, '2026-11-05 15:00:00', '审核通过', 'student', '2026-11-05 09:40:00', 'doctor01', '2026-11-05 15:00:00', NULL),
-- 批次2（2026-11-09 补检）22-26 号学生，全部已完成
 (22, 22, 2, '2026-11-06 10:00:00', '4', 3, '2026-11-06 15:30:00', '审核通过', 'student', '2026-11-06 10:00:00', 'doctor01', '2026-11-06 15:30:00', NULL),
 (23, 23, 2, '2026-11-06 10:03:00', '4', 3, '2026-11-06 15:30:00', '审核通过', 'student', '2026-11-06 10:03:00', 'doctor01', '2026-11-06 15:30:00', NULL),
 (24, 24, 2, '2026-11-06 10:06:00', '4', 3, '2026-11-06 15:30:00', '审核通过', 'student', '2026-11-06 10:06:00', 'doctor01', '2026-11-06 15:30:00', NULL),
 (25, 25, 2, '2026-11-06 10:09:00', '4', 3, '2026-11-06 15:30:00', '审核通过', 'student', '2026-11-06 10:09:00', 'doctor01', '2026-11-06 15:30:00', NULL),
 (26, 26, 2, '2026-11-06 10:12:00', '4', 3, '2026-11-06 15:30:00', '审核通过', 'student', '2026-11-06 10:12:00', 'doctor01', '2026-11-06 15:30:00', NULL),
-- 批次3（2026-11-25）12 人待审核
 (27, 2, 3, '2026-11-11 09:00:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:00:00', NULL, NULL, NULL),
 (28, 3, 3, '2026-11-11 09:03:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:03:00', NULL, NULL, NULL),
 (29, 4, 3, '2026-11-11 09:06:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:06:00', NULL, NULL, NULL),
 (30, 5, 3, '2026-11-11 09:09:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:09:00', NULL, NULL, NULL),
 (31, 6, 3, '2026-11-11 09:12:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:12:00', NULL, NULL, NULL),
 (32, 7, 3, '2026-11-11 09:15:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:15:00', NULL, NULL, NULL),
 (33, 8, 3, '2026-11-11 09:18:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:18:00', NULL, NULL, NULL),
 (34, 9, 3, '2026-11-11 09:21:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:21:00', NULL, NULL, NULL),
 (35, 10, 3, '2026-11-11 09:24:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:24:00', NULL, NULL, NULL),
 (36, 11, 3, '2026-11-11 09:27:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:27:00', NULL, NULL, NULL),
 (37, 12, 3, '2026-11-11 09:30:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:30:00', NULL, NULL, NULL),
 (38, 13, 3, '2026-11-11 09:33:00', '0', NULL, NULL, NULL, 'student', '2026-11-11 09:33:00', NULL, NULL, NULL),
-- 批次3 10 人已通过
 (39, 14, 3, '2026-11-10 14:00:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:00:00', 'doctor01', '2026-11-10 17:00:00', NULL),
 (40, 15, 3, '2026-11-10 14:03:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:03:00', 'doctor01', '2026-11-10 17:00:00', NULL),
 (41, 16, 3, '2026-11-10 14:06:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:06:00', 'doctor01', '2026-11-10 17:00:00', NULL),
 (42, 17, 3, '2026-11-10 14:09:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:09:00', 'doctor01', '2026-11-10 17:00:00', NULL),
 (43, 18, 3, '2026-11-10 14:12:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:12:00', 'doctor01', '2026-11-10 17:00:00', NULL),
 (44, 19, 3, '2026-11-10 14:15:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:15:00', 'doctor01', '2026-11-10 17:00:00', NULL),
 (45, 20, 3, '2026-11-10 14:18:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:18:00', 'doctor01', '2026-11-10 17:00:00', NULL),
 (46, 21, 3, '2026-11-10 14:21:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:21:00', 'doctor01', '2026-11-10 17:00:00', NULL),
 (47, 22, 3, '2026-11-10 14:24:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:24:00', 'doctor01', '2026-11-10 17:00:00', NULL),
 (48, 23, 3, '2026-11-10 14:27:00', '1', 3, '2026-11-10 17:00:00', '审核通过', 'student', '2026-11-10 14:27:00', 'doctor01', '2026-11-10 17:00:00', NULL),
-- 批次3 被拒绝 / 已取消（不占名额）
 (49, 24, 3, '2026-11-11 10:05:00', '2', 3, '2026-11-11 11:00:00', '证件照模糊，请重新上传后再次预约', 'student', '2026-11-11 10:05:00', 'doctor01', '2026-11-11 11:00:00', NULL),
 (50, 25, 3, '2026-11-11 10:20:00', '3', NULL, NULL, NULL, 'student', '2026-11-11 10:20:00', 'student', '2026-11-11 18:30:00', '学生自行取消');

-- ---------------------------------------------------------------------
-- 四、体检记录：时间线与体检日期对齐（仅修时间，指标值保持原样）
-- ---------------------------------------------------------------------
-- 2024/2025 的记录是系统上线前的历史数据，不关联批次
UPDATE ch_exam_record SET remark = '系统上线前历史体检记录（无关联批次）' WHERE batch_id IS NULL;

UPDATE ch_exam_record
SET create_time = CONCAT(exam_date, ' 16:20:00'),
    update_time = CONCAT(exam_date, ' 16:20:00'),
    update_by   = 'doctor01',
    examiner_id = 3
WHERE exam_date IS NOT NULL;

-- ---------------------------------------------------------------------
-- 五、健康档案：按体检记录重算
-- ---------------------------------------------------------------------
TRUNCATE TABLE ch_health_archive;

INSERT INTO ch_health_archive
 (student_id, total_exam_count, last_exam_date, health_summary, archive_status, create_by, create_time, update_by, update_time, remark)
SELECT s.id,
       IFNULL(c.cnt, 0),
       lr.exam_date,
       CASE WHEN lr.id IS NULL
            THEN '暂无体检记录，完成首次体检后自动生成健康摘要'
            ELSE CONCAT(
                '累计体检 ', IFNULL(c.cnt, 0), ' 次，最近一次 ', DATE_FORMAT(lr.exam_date, '%Y-%m-%d'), '。',
                '身高 ', FORMAT(lr.height, 1), 'cm，体重 ', FORMAT(lr.weight, 1), 'kg，BMI ', FORMAT(lr.bmi, 1),
                '（', ELT(lr.bmi_level + 1, '偏低', '正常', '超重', '肥胖'), '）；',
                '血压 ', lr.systolic_pressure, '/', lr.diastolic_pressure, ' mmHg；心率 ', lr.heart_rate, ' 次/分；',
                '视力 ', lr.vision_left, '/', lr.vision_right, '。',
                CASE WHEN lr.abnormal_flag = '1' THEN '本次存在异常指标，建议复查并咨询校医。'
                     ELSE '本次未发现异常指标。' END,
                '小结：', IFNULL(lr.conclusion, ''))
       END,
       IFNULL(lr.abnormal_flag, '0'),
       'admin', '2026-11-11 09:00:00', 'doctor01', '2026-11-11 09:00:00', NULL
FROM ch_student s
LEFT JOIN (SELECT student_id, COUNT(*) cnt FROM ch_exam_record WHERE record_status = '2' GROUP BY student_id) c
       ON c.student_id = s.id
LEFT JOIN (SELECT * FROM (SELECT r.*, ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY exam_date DESC, id DESC) rn
                          FROM ch_exam_record r WHERE r.record_status = '2') t WHERE t.rn = 1) lr
       ON lr.student_id = s.id
ORDER BY s.id;

-- ---------------------------------------------------------------------
-- 六、AI 评估任务：每条记录一条，保留已有报告
-- ---------------------------------------------------------------------
CREATE TEMPORARY TABLE tmp_ai_done AS
SELECT exam_record_id, risk_level, assessment_result, abnormal_items, suggestions, model_name
FROM ch_ai_assessment WHERE assess_status = '2';

TRUNCATE TABLE ch_ai_assessment;

INSERT INTO ch_ai_assessment (student_id, exam_record_id, assess_status, create_by, create_time, remark)
SELECT r.student_id, r.id, '0', 'system', CONCAT(r.exam_date, ' 17:05:00'), '登记体检记录时自动生成待评估任务'
FROM ch_exam_record r
WHERE r.record_status = '2'
ORDER BY r.exam_date, r.id;

UPDATE ch_ai_assessment a
JOIN tmp_ai_done t ON t.exam_record_id = a.exam_record_id
SET a.assess_status     = '2',
    a.risk_level        = t.risk_level,
    a.assessment_result = t.assessment_result,
    a.abnormal_items    = t.abnormal_items,
    a.suggestions       = t.suggestions,
    a.model_name        = t.model_name,
    a.update_by         = 'doctor01',
    a.update_time       = '2026-11-11 23:20:00',
    a.remark            = '评估报告已生成';

DROP TEMPORARY TABLE tmp_ai_done;

-- ---------------------------------------------------------------------
-- 七、日志类数据清空（登录/操作/定时任务/代码生成器残留）
-- ---------------------------------------------------------------------
TRUNCATE TABLE sys_logininfor;
TRUNCATE TABLE sys_oper_log;
TRUNCATE TABLE sys_job_log;
TRUNCATE TABLE gen_table;
TRUNCATE TABLE gen_table_column;
TRUNCATE TABLE sys_notice_read;

SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- 八、校验输出
-- ---------------------------------------------------------------------
SELECT '--- 批次 ---' AS step;
SELECT id, batch_name, exam_date, capacity, booked_count, status FROM ch_exam_batch ORDER BY id;

SELECT '--- 预约状态分布 ---' AS step;
SELECT status, COUNT(*) c FROM ch_appointment GROUP BY status ORDER BY status;

SELECT '--- 数据一致性检查（都应为 0）---' AS step;
SELECT
  (SELECT COUNT(*) FROM ch_appointment a LEFT JOIN ch_student s ON s.id = a.student_id WHERE s.id IS NULL) AS 预约指向不存在学生,
  (SELECT COUNT(*) FROM ch_appointment a LEFT JOIN ch_exam_batch b ON b.id = a.batch_id WHERE b.id IS NULL) AS 预约指向不存在批次,
  (SELECT COUNT(*) FROM ch_ai_assessment a LEFT JOIN ch_exam_record r ON r.id = a.exam_record_id WHERE r.id IS NULL) AS 评估任务无记录,
  (SELECT COUNT(*) FROM ch_health_archive h LEFT JOIN ch_student s ON s.id = h.student_id WHERE s.id IS NULL) AS 档案无学生,
  (SELECT COUNT(*) FROM ch_appointment WHERE status = '4'
     AND NOT EXISTS (SELECT 1 FROM ch_exam_record r WHERE r.student_id = ch_appointment.student_id AND r.batch_id = ch_appointment.batch_id)) AS 已完成但没体检记录;

SELECT '--- 档案/任务数量 ---' AS step;
SELECT (SELECT COUNT(*) FROM ch_health_archive) AS 档案数,
       (SELECT COUNT(*) FROM ch_exam_record)    AS 体检记录数,
       (SELECT COUNT(*) FROM ch_ai_assessment)  AS 评估任务数,
       (SELECT COUNT(*) FROM ch_student)        AS 学生数;
