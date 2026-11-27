-- ----------------------------
-- 体检批次表 ch_exam_batch
-- 设计说明：
-- 1. capacity 是名额上限，booked_count 是已预约数（冗余字段，为了查剩余名额时不用 count 全表）
-- 2. 名额校验必须"先查后改"，并且用事务包住，否则并发下会超卖（答辩重点）
-- 3. status 用数据字典 ch_batch_status：0未开始 1预约中 2已结束
-- ----------------------------
drop table if exists ch_exam_batch;
create table ch_exam_batch (
  id           bigint(20)   not null auto_increment    comment '批次ID',
  batch_name   varchar(100) not null                   comment '批次名称',
  exam_date    date                                    comment '体检日期',
  location     varchar(100)                            comment '体检地点',
  capacity     int(5)       default 0                  comment '名额上限',
  booked_count int(5)       default 0                  comment '已预约人数',
  status       char(1)      default '0'                comment '状态（0未开始 1预约中 2已结束）',
  create_by    varchar(64)  default ''                 comment '创建者',
  create_time  datetime                                comment '创建时间',
  update_by    varchar(64)  default ''                 comment '更新者',
  update_time  datetime                                comment '更新时间',
  remark       varchar(500) default null               comment '备注',
  primary key (id),
  unique key uk_batch_name (batch_name)
) engine=innodb auto_increment=1 comment = '体检批次表';

-- ----------------------------
-- 初始测试数据（故意让第二批只剩 2 个名额，方便演示"名额满了被拒绝"）
-- ----------------------------
insert into ch_exam_batch values(1, '2026年秋季体检第一批', '2026-11-20', '校医院一楼', 100, 3, '1', 'admin', sysdate(), '', null, '面向24软件技术1班');
insert into ch_exam_batch values(2, '2026年秋季体检第二批', '2026-11-21', '校医院一楼', 5,   3, '1', 'admin', sysdate(), '', null, '名额紧张，用于演示满额拒绝');
insert into ch_exam_batch values(3, '2026年秋季体检第三批', '2026-11-25', '体育馆',     200, 0, '0', 'admin', sysdate(), '', null, '尚未开放预约');

-- ----------------------------
-- 批次状态业务字典
-- ----------------------------
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark) values('体检批次状态', 'ch_batch_status', '0', 'admin', sysdate(), '体检批次状态列表');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark) values
(1, '未开始', '0', 'ch_batch_status', '', 'info',    'N', '0', 'admin', sysdate(), '尚未开放预约'),
(2, '预约中', '1', 'ch_batch_status', '', 'primary', 'Y', '0', 'admin', sysdate(), '可正常预约'),
(3, '已结束', '2', 'ch_batch_status', '', 'danger',  'N', '0', 'admin', sysdate(), '已停止预约');
