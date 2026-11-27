-- =====================================================================
-- 重置演示数据：把张伟（student01）在「批次3」的状态清干净，让预约流程能演示
--
-- 为什么需要：11-11 22:45 给张伟录了一条体检记录（id=30），批次填的是批次3，
--   但体检日期填 2026-11-18，而批次3 的体检日是 2026-11-25（还没到）。
--   录体检记录会自动把对应预约改成「已完成」，于是：
--     · 学生端按钮变灰显示"已预约"，点不动
--     · 强行调接口 -> "该学生已预约此批次，请勿重复提交"
--     · 连"取消预约"也不行 -> "体检已完成，不能取消预约"
--
-- 做三件事：删掉那条日期对不上的体检记录、删掉张伟批次3 的预约、把批次3 已预约数还回去。
-- 注意：执行后要调一次体检记录的"修改"接口，让系统自己重算健康档案快照
--       （档案里的累计次数/最近体检日期/摘要是后端算出来的，SQL 改不了）。
-- =====================================================================

-- ① 删掉那条误录的体检记录（batch_id=3 但 exam_date=2026-11-18）
DELETE FROM ch_exam_record WHERE id = 30 AND student_id = 1 AND batch_id = 3;

-- ② 删掉张伟在批次3 的预约记录（状态4 已完成）
DELETE FROM ch_appointment WHERE id = 27 AND student_id = 1 AND batch_id = 3;

-- ③ 名额还回去：这条预约此前是"已完成"，占着 1 个名额
UPDATE ch_exam_batch SET booked_count = booked_count - 1 WHERE id = 3 AND booked_count > 0;

-- 校验
SELECT id, student_id, batch_id, status FROM ch_appointment WHERE student_id = 1;
SELECT id, booked_count, capacity FROM ch_exam_batch WHERE id = 3;
