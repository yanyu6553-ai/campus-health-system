-- ----------------------------
-- 体检记录表 ch_exam_record
-- 设计说明：
-- 1. bmi、bmi_level 由后端 Service 自动计算，禁止前端传入（生成代码后要在页面配置里去掉这两个字段的编辑权限）
-- 2. uk_student_date 唯一索引：同一个学生同一天只能有一条体检记录
-- 3. bmi_level 采用中国成人标准：偏低<18.5 / 正常18.5-23.9 / 超重24-27.9 / 肥胖>=28
-- ----------------------------
drop table if exists ch_exam_record;
create table ch_exam_record (
  id                 bigint(20)      not null auto_increment    comment '记录ID',
  student_id         bigint(20)      not null                   comment '学生ID（关联ch_student.id）',
  exam_date          date                                       comment '体检日期',
  height             decimal(5,1)                               comment '身高(cm)',
  weight             decimal(5,1)                               comment '体重(kg)',
  bmi                decimal(4,1)                               comment 'BMI指数（自动计算）',
  bmi_level          char(1)         default '0'                comment 'BMI等级（0偏低 1正常 2超重 3肥胖）',
  systolic_pressure  int(3)                                     comment '收缩压(mmHg)',
  diastolic_pressure int(3)                                     comment '舒张压(mmHg)',
  pulse_rate         int(3)                                     comment '脉搏(次/分)',
  vision_left        decimal(3,1)                               comment '左眼视力',
  vision_right       decimal(3,1)                               comment '右眼视力',
  conclusion         varchar(200)                               comment '体检小结',
  create_by          varchar(64)     default ''                 comment '创建者',
  create_time        datetime                                   comment '创建时间',
  update_by          varchar(64)     default ''                 comment '更新者',
  update_time        datetime                                   comment '更新时间',
  remark             varchar(500)    default null               comment '备注',
  primary key (id),
  unique key uk_student_date (student_id, exam_date)
) engine=innodb auto_increment=1 comment = '体检记录表';

-- ----------------------------
-- 初始测试数据（学生ID对应 ch_student 表里的 1/2/3 号）
-- 65.5/(1.75*1.75)=21.4 正常   75.0/(1.60*1.60)=29.3 肥胖   58.0/(1.80*1.80)=17.9 偏低
-- ----------------------------
insert into ch_exam_record values(1, 1, '2026-11-10', 175.0, 65.5, 21.4, '1', 118, 76, 72, 5.0, 4.8, '各项指标正常', 'admin', sysdate(), '', null, null);
insert into ch_exam_record values(2, 2, '2026-11-10', 160.0, 75.0, 29.3, '3', 132, 88, 80, 4.6, 4.5, '体重超标，建议复查', 'admin', sysdate(), '', null, null);
insert into ch_exam_record values(3, 3, '2026-11-09', 180.0, 58.0, 17.9, '0', 110, 70, 68, 5.1, 5.1, '偏瘦，注意营养', 'admin', sysdate(), '', null, null);

-- ----------------------------
-- BMI等级业务字典（也可以自己在「字典管理」界面建，效果一样）
-- ----------------------------
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark) values('BMI等级', 'ch_bmi_level', '0', 'admin', sysdate(), '体检BMI等级列表');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark) values
(1, '偏低', '0', 'ch_bmi_level', '', 'warning',  'N', '0', 'admin', sysdate(), 'BMI<18.5'),
(2, '正常', '1', 'ch_bmi_level', '', 'success',  'Y', '0', 'admin', sysdate(), '18.5-23.9'),
(3, '超重', '2', 'ch_bmi_level', '', 'primary',  'N', '0', 'admin', sysdate(), '24-27.9'),
(4, '肥胖', '3', 'ch_bmi_level', '', 'danger',   'N', '0', 'admin', sysdate(), '>=28');
