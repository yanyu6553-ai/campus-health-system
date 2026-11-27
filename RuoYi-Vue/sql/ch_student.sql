-- ----------------------------
-- 学生信息表 ch_student
-- 说明：这是本项目第一张业务表，字段与设计文档 3.3 表1 一致
-- ----------------------------
drop table if exists ch_student;
create table ch_student (
  id              bigint(20)      not null auto_increment    comment '主键',
  user_id         bigint(20)      default null               comment '关联若依用户ID',
  student_no      varchar(30)     not null                   comment '学号',
  student_name    varchar(50)     not null                   comment '姓名',
  gender          char(1)         default '0'                comment '性别（0男 1女 2未知）',
  birthday        date            default null               comment '出生日期',
  college         varchar(100)    default ''                 comment '学院',
  major           varchar(100)    default ''                 comment '专业',
  class_name      varchar(100)    default ''                 comment '班级',
  phone           varchar(20)     default ''                 comment '联系电话',
  status          char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by       varchar(64)     default ''                 comment '创建者',
  create_time     datetime                                   comment '创建时间',
  update_by       varchar(64)     default ''                 comment '更新者',
  update_time     datetime                                   comment '更新时间',
  remark          varchar(500)    default null               comment '备注',
  primary key (id),
  unique key uk_student_no (student_no)
) engine=innodb auto_increment=1 comment = '学生信息表';

-- ----------------------------
-- 演示数据（答辩演示用，可自行增删）
-- ----------------------------
insert into ch_student (student_no, student_name, gender, birthday, college, major, class_name, phone, status, create_by, create_time, remark)
values ('20260001', '张同学', '0', '2007-03-15', '信息工程学院', '软件技术', '24软件技术1班', '13800000001', '0', 'admin', sysdate(), '演示数据'),
       ('20260002', '李同学', '1', '2007-07-22', '信息工程学院', '软件技术', '24软件技术1班', '13800000002', '0', 'admin', sysdate(), '演示数据'),
       ('20260003', '王同学', '0', '2006-11-08', '机电工程学院', '数控技术', '24数控技术2班', '13800000003', '0', 'admin', sysdate(), '演示数据');
