-- ---------------------------------------------------------------------
-- 清理「体检记录已被删除」的 AI 评估任务（孤儿任务）
-- ---------------------------------------------------------------------
-- 现象：AI健康评估页里有些任务「体检日期」是空的、学生姓名也可能是空，
--       点「生成评估」就报「体检记录不存在，无法生成评估」。
-- 原因：任务是在登记体检记录时自动建的，后来体检记录被删了（清理演示数据、
--       删测试账号连带删记录），任务却没有跟着删，成了永远生成不出结果的死任务。
-- 处理：建表时没有外键约束，只能靠比对来清理。可重复执行。
-- 备份：sql/backup/ai_assessment_orphan_before.txt（清理前留档）
-- ---------------------------------------------------------------------
USE campus_health;

-- 先看看要删哪些（数量应为 0 表示已清理干净）
SELECT a.id, a.student_id, a.exam_record_id, s.student_no, s.student_name
FROM ch_ai_assessment a
LEFT JOIN ch_exam_record r ON r.id = a.exam_record_id
LEFT JOIN ch_student s ON s.id = a.student_id
WHERE r.id IS NULL;

DELETE a FROM ch_ai_assessment a
LEFT JOIN ch_exam_record r ON r.id = a.exam_record_id
WHERE r.id IS NULL;

-- 顺带把「学生档案也被删了」的任务一起清掉（学生不存在，报告也没人看）
DELETE a FROM ch_ai_assessment a
LEFT JOIN ch_student s ON s.id = a.student_id
WHERE s.id IS NULL;

SELECT COUNT(*) AS 剩余任务数 FROM ch_ai_assessment;
