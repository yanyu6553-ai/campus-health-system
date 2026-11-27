-- ----------------------------
-- 体检项目表 ch_exam_item
-- 设计说明：
-- 1. 这张表是「指标配置表」，不再是简单的一张增删改查表 —— 它的参考范围直接驱动
--    体检登记的异常判定（见 ExamRecordServiceImpl.autoCalculate），改配置判定就变。
-- 2. field_key 记录「这个项目对应 ch_exam_record 表的哪个字段」。
--    体检记录用的是固定字段（height/weight/bmi/...），靠 field_key 把配置和真实数据对上，
--    这样配置改了名字、单位，也能知道该拿哪个字段的值去比。
-- 3. abnormal_rule 决定「往哪个方向算异常」：
--    0 高于上限算异常   1 低于下限算异常   2 超出上下限任一算异常   3 仅展示、不参与判定
--    像身高、体重、视力这类，没有一个通用的"正常范围"（要看年龄、矫正情况），
--    所以默认规则是 3，只展示不判定 —— 这也是设计文档 2.3 里强调的"不能把成人标准套给所有人"。
-- 4. 参考范围用 min/max 只适合数值型指标。以后要支持"阴性/阳性"这类文本指标，
--    再加一张规则表，不要往这张表里硬塞。
-- ----------------------------
drop table if exists ch_exam_item;
create table ch_exam_item (
  id            bigint(20)    not null auto_increment    comment '项目ID',
  item_code     varchar(50)   not null                   comment '项目编码（唯一）',
  item_name     varchar(100)  not null                   comment '项目名称',
  category      char(1)       default '1'                comment '项目分类（字典 ch_exam_category）',
  unit          varchar(20)   default ''                 comment '计量单位',
  field_key     varchar(50)   default ''                 comment '对应体检记录字段名（用于异常判定取值）',
  reference_min decimal(10,2)                            comment '参考下限（空表示不限）',
  reference_max decimal(10,2)                            comment '参考上限（空表示不限）',
  abnormal_rule char(1)       default '3'                comment '异常判定（0高于上限 1低于下限 2超出任一 3仅展示）',
  description   varchar(500)  default ''                 comment '项目说明',
  status        char(1)       default '0'                comment '状态（0启用 1停用）',
  create_by     varchar(64)   default ''                 comment '创建者',
  create_time   datetime                                 comment '创建时间',
  update_by     varchar(64)   default ''                 comment '更新者',
  update_time   datetime                                 comment '更新时间',
  remark        varchar(500)  default null               comment '备注',
  primary key (id),
  unique key uk_item_code (item_code),
  key idx_field_key (field_key)
) engine=innodb auto_increment=1 comment = '体检项目表';

-- ----------------------------
-- 初始体检项目（8 项，正好对应体检记录表的 8 个指标字段）
-- 说明：这里的参考范围是「成人常用参考值」，仅用于课程演示。
--      真实场景要按人群、年龄、性别拆分标准，不能一套范围打天下。
-- ----------------------------
insert into ch_exam_item
(id, item_code, item_name, category, unit, field_key, reference_min, reference_max, abnormal_rule, description, status, create_by, create_time, remark)
values
(1, 'HGT-HEIGHT', '身高',   '1', 'cm',     'height',             null,  null,  '3', '生长发育指标，单独一个数值没有正常/异常之分，仅记录',                     '0', 'admin', sysdate(), ''),
(2, 'HGT-WEIGHT', '体重',   '1', 'kg',     'weight',             null,  null,  '3', '需结合身高计算 BMI 才有判断意义，体重本身不单独判定',                     '0', 'admin', sysdate(), ''),
(3, 'HGT-BMI',    'BMI',    '1', 'kg/m²',  'bmi',                18.50, 23.90, '0', '中国成人标准：偏低<18.5 正常18.5-23.9 超重24-27.9 肥胖≥28；超上限判为异常', '0', 'admin', sysdate(), ''),
(4, 'CIR-SBP',    '收缩压', '2', 'mmHg',   'systolic_pressure',  90.00, 139.00,'0', '成人参考 90-139mmHg，≥140 判为偏高',                                    '0', 'admin', sysdate(), ''),
(5, 'CIR-DBP',    '舒张压', '2', 'mmHg',   'diastolic_pressure', 60.00, 89.00, '0', '成人参考 60-89mmHg，≥90 判为偏高',                                      '0', 'admin', sysdate(), ''),
(6, 'CIR-PULSE',  '脉搏',   '2', '次/分',  'pulse_rate',         60,    100,   '3', '成人静息参考 60-100次/分；运动后偏高属正常，默认仅展示不判定',            '0', 'admin', sysdate(), ''),
(7, 'EYE-VL',     '左眼视力','3', '',       'vision_left',        5.00,  null,  '3', '对数视力表 5.0 为正常；近视矫正情况因人而异，默认仅展示不判定',           '0', 'admin', sysdate(), ''),
(8, 'EYE-VR',     '右眼视力','3', '',       'vision_right',       5.00,  null,  '3', '对数视力表 5.0 为正常；近视矫正情况因人而异，默认仅展示不判定',           '0', 'admin', sysdate(), '');

-- ----------------------------
-- 项目分类业务字典
-- ----------------------------
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
values('体检项目分类', 'ch_exam_category', '0', 'admin', sysdate(), '体检项目分类列表');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark) values
(1, '一般检查', '1', 'ch_exam_category', '', 'primary', 'Y', '0', 'admin', sysdate(), '身高、体重、BMI'),
(2, '循环系统', '2', 'ch_exam_category', '', 'success', 'N', '0', 'admin', sysdate(), '血压、脉搏'),
(3, '眼科',     '3', 'ch_exam_category', '', 'warning', 'N', '0', 'admin', sysdate(), '视力'),
(9, '其他',     '9', 'ch_exam_category', '', 'info',    'N', '0', 'admin', sysdate(), '其他检查项目');

-- ----------------------------
-- 异常判定方式业务字典（页面上显示成中文，比让用户看 0/1/2/3 友好）
-- ----------------------------
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
values('体检异常判定方式', 'ch_abnormal_rule', '0', 'admin', sysdate(), '体检项目异常判定方向');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark) values
(1, '高于上限算异常', '0', 'ch_abnormal_rule', '', 'danger',  'Y', '0', 'admin', sysdate(), '如血压、BMI'),
(2, '低于下限算异常', '1', 'ch_abnormal_rule', '', 'warning', 'N', '0', 'admin', sysdate(), '如血红蛋白偏低'),
(3, '超出上下限算异常', '2', 'ch_abnormal_rule', '', 'danger', 'N', '0', 'admin', sysdate(), '偏差两个方向都算异常'),
(4, '仅展示不判定',   '3', 'ch_abnormal_rule', '', 'info',    'N', '0', 'admin', sysdate(), '需结合人群/年龄判断的项目');

-- ----------------------------
-- 菜单：体检项目管理（挂在「校园健康」目录 2000 下面）
-- ----------------------------
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('体检项目', '2000', '3', 'examItem', 'health/examItem/index', '', 1, 0, 'C', '0', '0', 'health:examItem:list', 'component', 'admin', sysdate(), '', null, '体检项目菜单');

-- 按钮的父菜单ID = 刚插入的这条菜单
SELECT @parentId := LAST_INSERT_ID();

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('体检项目查询', @parentId, '1', '#', '', '', 1, 0, 'F', '0', '0', 'health:examItem:query',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('体检项目新增', @parentId, '2', '#', '', '', 1, 0, 'F', '0', '0', 'health:examItem:add',    '#', 'admin', sysdate(), '', null, '');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('体检项目修改', @parentId, '3', '#', '', '', 1, 0, 'F', '0', '0', 'health:examItem:edit',   '#', 'admin', sysdate(), '', null, '');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('体检项目删除', @parentId, '4', '#', '', '', 1, 0, 'F', '0', '0', 'health:examItem:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('体检项目导出', @parentId, '5', '#', '', '', 1, 0, 'F', '0', '0', 'health:examItem:export', '#', 'admin', sysdate(), '', null, '');
