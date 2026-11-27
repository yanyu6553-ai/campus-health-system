-- ============================================================
-- 校园学生体检与健康档案管理系统
-- 表4：体检预约表 ch_appointment
-- 设计要点：
--   1. uk_student_batch 联合唯一索引：一个学生对同一批次只能预约一次
--      （取消后重新预约怎么办？见文末说明）
--   2. status 用字典 ch_appoint_status：0待审核 1已通过 2已拒绝 3已取消
--   3. audit_by / audit_time / reject_reason 是审核环节的痕迹字段
-- ============================================================

drop table if exists ch_appointment;
create table ch_appointment (
  id            bigint(20)   not null auto_increment    comment '预约ID',
  student_id    bigint(20)   not null                   comment '学生ID（ch_student.id）',
  batch_id      bigint(20)   not null                   comment '批次ID（ch_exam_batch.id）',
  appoint_time  datetime     default null               comment '预约提交时间',
  status        char(1)      default '0'                comment '状态（0待审核 1已通过 2已拒绝 3已取消）',
  audit_by      varchar(64)  default ''                 comment '审核人',
  audit_time    datetime     default null               comment '审核时间',
  reject_reason varchar(255) default ''                 comment '拒绝原因',
  create_by     varchar(64)  default ''                 comment '创建者',
  create_time   datetime     default null               comment '创建时间',
  update_by     varchar(64)  default ''                 comment '更新者',
  update_time   datetime     default null               comment '更新时间',
  remark        varchar(500) default null               comment '备注',
  primary key (id),
  unique key uk_student_batch (student_id, batch_id),
  key idx_batch (batch_id),
  key idx_status (status)
) engine=innodb auto_increment=1 comment = '体检预约表';

-- ----------------------------
-- 字典：预约状态
-- ----------------------------
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
values ('预约状态', 'ch_appoint_status', '0', 'admin', sysdate(), '体检预约状态列表');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark) values
(1, '待审核', '0', 'ch_appoint_status', '', 'info',    'Y', '0', 'admin', sysdate(), '学生已提交，等待校医审核'),
(2, '已通过', '1', 'ch_appoint_status', '', 'success', 'N', '0', 'admin', sysdate(), '校医审核通过，可参加体检'),
(3, '已拒绝', '2', 'ch_appoint_status', '', 'danger',  'N', '0', 'admin', sysdate(), '校医审核拒绝，需填写原因'),
(4, '已取消', '3', 'ch_appoint_status', '', 'warning', 'N', '0', 'admin', sysdate(), '学生主动取消');

-- ----------------------------
-- 测试数据（3 条，覆盖 待审核 / 已通过 / 已拒绝 三种状态）
-- ----------------------------
insert into ch_appointment (student_id, batch_id, appoint_time, status, audit_by, audit_time, reject_reason, create_by, create_time) values
(1, 1, '2026-11-10 09:12:00', '0', '',          null,                  '',             'admin', sysdate()),
(2, 1, '2026-11-10 09:20:00', '1', '校医张医生', '2026-11-10 10:05:00', '',             'admin', sysdate()),
(3, 1, '2026-11-10 09:31:00', '2', '校医张医生', '2026-11-10 10:06:00', '血压异常需复查', 'admin', sysdate());

-- ============================================================
-- 【说明】为什么用 uk_student_batch 联合唯一索引
--   数据库层直接挡住"同一学生重复预约同一批次"，
--   跟 ch_student 的 uk_student_no、ch_exam_record 的 uk_student_date 是同一思路：
--   能交给数据库的约束，就不要指望代码不出错。
--
-- 【一个真实的坑，答辩可能会问】
--   有了唯一索引，学生"取消预约(3)后想重新预约"就会撞索引报错。
--   两种解法：
--     A. 取消时不改 status，而是物理删除这条记录（简单，但丢历史）
--     B. 取消后重新预约时，复用同一条记录：status 改回 0、重置 audit 字段
--   我们选 B，代码里做一次"查有没有旧记录"的判断。
--   → 这就是 Service 层要写的第一条业务规则。
-- ============================================================
