-- =============================================
-- 表8：AI 评估记录表 ch_ai_assessment
-- 对应设计文档 3.3 表7
-- 一条体检记录只保留一份评估结果（重复生成则覆盖，便于演示与追溯）
-- =============================================
drop table if exists ch_ai_assessment;
create table ch_ai_assessment (
  id                  bigint(20)      not null auto_increment    comment '主键',
  student_id          bigint(20)      not null                   comment '学生ID',
  exam_record_id      bigint(20)      not null                   comment '体检记录ID',
  risk_level          varchar(20)     default null               comment '辅助风险等级（LOW/MEDIUM/HIGH）',
  assessment_result   text                                       comment '评估摘要',
  abnormal_items      text                                       comment '异常项目（JSON数组）',
  suggestions         text                                       comment '健康建议（JSON数组）',
  model_name          varchar(100)    default null               comment '模型名称',
  create_by           varchar(64)     default ''                 comment '创建者',
  create_time         datetime                                   comment '创建时间',
  update_by           varchar(64)     default ''                 comment '更新者',
  update_time         datetime                                   comment '更新时间',
  remark              varchar(500)    default null               comment '备注',
  primary key (id),
  unique key uk_ai_record (exam_record_id),
  key idx_ai_student (student_id)
) engine=innodb auto_increment=1 comment = 'AI健康评估记录表';

-- =============================================
-- 字典：AI 辅助风险等级
-- =============================================
delete from sys_dict_data where dict_type = 'ch_risk_level';
delete from sys_dict_type where dict_type = 'ch_risk_level';

insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
values ('AI辅助风险等级', 'ch_risk_level', '0', 'admin', now(), 'AI健康评估输出的辅助风险等级');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
values
 (1, '低风险', 'LOW',    'ch_risk_level', '', 'success', 'Y', '0', 'admin', now(), '指标均在参考范围内'),
 (2, '中风险', 'MEDIUM', 'ch_risk_level', '', 'warning', 'N', '0', 'admin', now(), '存在单项指标偏离'),
 (3, '高风险', 'HIGH',   'ch_risk_level', '', 'danger',  'N', '0', 'admin', now(), '存在多项异常或明显偏离');

-- 菜单：智能健康管理 / AI健康评估（先查重，避免重复插入）
-- 说明：若已存在则不插入，可重复执行
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'AI健康评估', 0, 4, 'ai', null, 1, 0, 'M', '0', '0', null, 'education', 'admin', now(), '智能健康管理目录'
from dual where not exists (select 1 from (select * from sys_menu) t where t.menu_name = 'AI健康评估' and t.menu_type = 'M');
