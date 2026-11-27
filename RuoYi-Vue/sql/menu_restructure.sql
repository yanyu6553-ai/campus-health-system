-- ----------------------------
-- 菜单重组：按设计文档 4.3 的页面结构
-- ----------------------------
-- 重组前的状态（历史遗留）：
--   健康管理(2000)
--     ├ 学生信息 / 体检记录 / 体检批次 / 体检预约 / 健康档案 / 体检项目   ← 6 个不相干的模块挤在一个目录
--   智能健康管理(2044)
--     └ AI健康评估
--
-- 重组后：
--   学生管理    → 学生信息管理 / 学生信息导入
--   体检管理    → 体检项目管理 / 体检批次管理 / 体检预约管理 / 体检登记管理
--   健康档案    → 个人健康档案 / 历史体检记录 / 异常指标管理
--   智能健康管理 → AI健康评估 / AI评估报告
--   数据统计    → 体检完成情况 / 健康数据统计
--   系统管理    → （若依自带，不动）
--
-- 说明：首页不用建菜单，若依的固定路由里已经有「首页」，指向 views/index.vue（数据看板）。
-- ----------------------------

-- 1. 新建 4 个业务目录
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生管理', '0', '0', 'studentManage', '', '', 1, 0, 'M', '0', '0', '', 'user', 'admin', sysdate(), '', null, '学生信息分组');
set @studentDir := last_insert_id();

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('体检管理', '0', '1', 'examManage', '', '', 1, 0, 'M', '0', '0', '', 'documentation', 'admin', sysdate(), '', null, '体检业务分组');
set @examDir := last_insert_id();

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('健康档案', '0', '2', 'archiveManage', '', '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', sysdate(), '', null, '健康档案分组');
set @archiveDir := last_insert_id();

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('数据统计', '0', '4', 'statistics', '', '', 1, 0, 'M', '0', '0', '', 'chart', 'admin', sysdate(), '', null, '统计分组');
set @statsDir := last_insert_id();

-- 2. 把原有业务菜单挪到对应目录下（改 parent_id / path / 名称，菜单ID不变，按钮权限继续挂在原菜单上）
update sys_menu set parent_id = @studentDir, menu_name = '学生信息管理', path = 'info',  order_num = 1, icon = 'people'     where menu_id = 2001;
update sys_menu set parent_id = @examDir,    menu_name = '体检项目管理', path = 'item',  order_num = 1 where menu_id = 2049;
update sys_menu set parent_id = @examDir,    menu_name = '体检批次管理', path = 'batch', order_num = 2, icon = 'date-range' where menu_id = 2019;
update sys_menu set parent_id = @examDir,    menu_name = '体检预约管理', path = 'appointment', order_num = 3, icon = 'date' where menu_id = 2037;
update sys_menu set parent_id = @examDir,    menu_name = '体检登记管理', path = 'registration', order_num = 4, icon = 'edit' where menu_id = 2013;
update sys_menu set parent_id = @archiveDir, menu_name = '个人健康档案', path = 'my', order_num = 1 where menu_id = 2043;

-- 3. 新增缺失的页面菜单
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生信息导入', @studentDir, '2', 'import', 'health/student/import', '', 1, 0, 'C', '0', '0', 'health:student:import', 'upload', 'admin', sysdate(), '', null, 'Excel 批量导入');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('历史体检记录', @archiveDir, '2', 'history', 'health/examRecord/history', '', 1, 0, 'C', '0', '0', 'health:examRecord:list', 'time-range', 'admin', sysdate(), '', null, '只读查询历年体检结果');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('异常指标管理', @archiveDir, '3', 'abnormal', 'health/abnormal/index', '', 1, 0, 'C', '0', '0', 'health:examRecord:list', 'warning', 'admin', sysdate(), '', null, '按体检项目参考范围筛出的异常记录');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('AI评估报告', '2044', '2', 'report', 'health/ai/report', '', 1, 0, 'C', '0', '0', 'health:ai:list', 'form', 'admin', sysdate(), '', null, '按学生查看AI健康评估报告');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('体检完成情况', @statsDir, '1', 'complete', 'health/statistics/complete', '', 1, 0, 'C', '0', '0', 'health:stats:list', 'chart', 'admin', sysdate(), '', null, '完成率与批次预约进度');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('健康数据统计', @statsDir, '2', 'health', 'health/statistics/health', '', 1, 0, 'C', '0', '0', 'health:stats:list', 'monitor', 'admin', sysdate(), '', null, 'BMI分布与异常比例');

-- 4. 删掉已经空了的「健康管理」目录
delete from sys_role_menu where menu_id = 2000;
delete from sys_menu where menu_id = 2000;

-- 5. 顶层顺序整理：学生/体检/档案/智能/统计 在前，若依自带的放在后面
update sys_menu set order_num = '3' where menu_id = 2044;   -- 智能健康管理
update sys_menu set order_num = '5' where menu_id = 1;      -- 系统管理
update sys_menu set order_num = '6' where menu_id = 2;      -- 系统监控
update sys_menu set order_num = '7' where menu_id = 3;      -- 系统工具
-- 若依官网只是个外链，课程项目里没必要出现在菜单上（想恢复把它改回 visible=0 即可）
update sys_menu set order_num = '8', visible = '1' where menu_id = 4;
