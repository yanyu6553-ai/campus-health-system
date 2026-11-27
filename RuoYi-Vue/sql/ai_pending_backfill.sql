-- ----------------------------
-- 补建历史体检记录的 AI 待评估任务
-- ----------------------------
-- 背景：待评估任务是在「登记体检记录」时自动创建的（ExamRecordServiceImpl → createPendingTask），
--       而功能上线前已经存在的体检记录没有对应任务，导致「AI健康评估」页的待评估队列一直是 0。
-- 作用：为每条「已提交」（record_status <> '1'，排除暂存）且还没有 AI 任务的体检记录补一条待评估任务。
-- 说明：可重复执行（not exists 去重）；不会覆盖已有评估结果。
-- ----------------------------

insert into ch_ai_assessment (student_id, exam_record_id, assess_status, create_by, create_time, remark)
select r.student_id, r.id, '0', 'system', now(), '历史体检记录补建待评估任务'
from ch_exam_record r
where r.record_status <> '1'
  and not exists (select 1 from ch_ai_assessment a where a.exam_record_id = r.id);
