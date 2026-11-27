-- =====================================================================
-- 校园健康管理系统 —— 角色、演示账号与学生身份绑定
-- 对应设计文档：1.4 系统角色设计、4.3 不同角色看到不同菜单、T02/T13 权限隔离
--
-- 说明：
--   1. 密码统一 admin123（BCrypt 哈希与 admin 账号一致），演示后请修改
--   2. 脚本可重复执行：先清理再写入，不会产生重复数据
--   3. 学生账号通过 ch_student.user_id 绑定，后端据此判定"我是谁"，
--      前端传什么 studentId 都不作数
-- =====================================================================
USE campus_health;

-- ---------------------------------------------------------------------
-- 一、部门（校医、辅导员、学生都需要归属部门，否则用户管理页显示为空）
-- ---------------------------------------------------------------------
DELETE FROM sys_dept WHERE dept_id IN (110, 111);

INSERT INTO sys_dept (dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
VALUES (110, 100, '0,100', '校医院',     1, '王医生', '07558800101', 'clinic@campus.edu.cn', '0', '0', 'admin', NOW()),
       (111, 100, '0,100', '软件学院',   2, '李老师', '07558800202', 'soft@campus.edu.cn',   '0', '0', 'admin', NOW());

-- ---------------------------------------------------------------------
-- 二、角色：校医 / 辅导员 / 学生（管理员和普通角色是若依自带的）
-- ---------------------------------------------------------------------
DELETE FROM sys_role WHERE role_id IN (100, 101, 102);

INSERT INTO sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
VALUES (100, '校医',   'doctor',    3, '1', 1, 1, '0', '0', 'admin', NOW(), '体检项目、批次、预约审核、体检登记、档案与AI评估'),
       (101, '辅导员', 'counselor', 4, '1', 1, 1, '0', '0', 'admin', NOW(), '只读：查看学生信息、预约情况、健康档案与统计，不能增删改'),
       (102, '学生',   'student',   5, '5', 1, 1, '0', '0', 'admin', NOW(), '仅本人：我的预约、我的档案、我的体检记录');

-- ---------------------------------------------------------------------
-- 三、演示账号
-- ---------------------------------------------------------------------
DELETE FROM sys_user_role WHERE user_id IN (3, 4, 5, 6);
DELETE FROM sys_user      WHERE user_id IN (3, 4, 5, 6);

INSERT INTO sys_user (user_id, dept_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, create_by, create_time, remark)
VALUES
(3, 110, 'doctor01',  '王医生',      '00', 'doctor01@campus.edu.cn',  '13900000001', '0', '',
 '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', 'admin', NOW(), '演示账号：校医'),
(4, 111, 'teacher01', '李老师',      '00', 'teacher01@campus.edu.cn', '13900000002', '1', '',
 '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', 'admin', NOW(), '演示账号：辅导员'),
(5, 111, 'student01', '张伟',        '00', 'student01@campus.edu.cn', '13810000137', '0', '',
 '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', 'admin', NOW(), '演示账号：学生（20260001 张伟）'),
(6, 111, 'student02', '李娜',        '00', 'student02@campus.edu.cn', '13810000274', '1', '',
 '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', 'admin', NOW(), '演示账号：学生（20260002 李娜）');

INSERT INTO sys_user_role (user_id, role_id)
VALUES (3, 100), (4, 101), (5, 102), (6, 102);

-- ---------------------------------------------------------------------
-- 四、学生身份绑定：ch_student.user_id 指向系统账号
--     这是"学生只能看自己数据"的根基 —— 后端从登录态取 userId 反查学生，
--     而不是相信前端传来的 studentId
-- ---------------------------------------------------------------------
UPDATE ch_student SET user_id = 5 WHERE student_no = '20260001';
UPDATE ch_student SET user_id = 6 WHERE student_no = '20260002';

-- ---------------------------------------------------------------------
-- 五、菜单：新增"我的健康"分组（学生自助入口）
--     文档 4.3 是管理端菜单树；学生端需要一个只属于自己数据的分组，
--     否则学生点进"体检预约管理"看到的就是全校数据
-- ---------------------------------------------------------------------
DELETE FROM sys_role_menu WHERE menu_id BETWEEN 2065 AND 2068;
DELETE FROM sys_menu      WHERE menu_id BETWEEN 2065 AND 2068;

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
VALUES
(2065, '我的健康',     0,    0, 'myHealth',      NULL, '', '', 1, 0, 'M', '0', '0', '',                    'peoples', 'admin', NOW(), '学生自助入口：只看得到自己的数据'),
(2066, '我的体检预约', 2065, 1, 'appointment',   'health/my/appointment', '', '', 1, 0, 'C', '0', '0', 'health:my:appointment', 'date',    'admin', NOW(), '查看批次、提交预约、取消预约'),
(2067, '我的健康档案', 2065, 2, 'archive',       'health/my/archive',     '', '', 1, 0, 'C', '0', '0', 'health:my:archive',     'documentation', 'admin', NOW(), '个人档案与历年体检趋势'),
(2068, '我的体检记录', 2065, 3, 'records',       'health/my/records',     '', '', 1, 0, 'C', '0', '0', 'health:my:records',     'list',    'admin', NOW(), '历次体检明细与异常指标');

-- ---------------------------------------------------------------------
-- 六、角色菜单授权
-- ---------------------------------------------------------------------
DELETE FROM sys_role_menu WHERE role_id IN (100, 101, 102);

-- 校医：全部业务权限（目录 + 页面 + 按钮），但不含学生端的"我的健康"
--       页面和按钮都以 perms 为 health: 开头为特征，一次性覆盖，避免漏配按钮
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 100, menu_id FROM sys_menu
WHERE menu_id IN (2055, 2056, 2057, 2044)
   OR (perms LIKE 'health:%' AND perms NOT LIKE 'health:my:%');

-- 辅导员：只读。目录 + 页面 + 只有 list/query/export 三类按钮
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 101, menu_id FROM sys_menu
WHERE menu_id IN (2055, 2056, 2057, 2058, 2001, 2019, 2037, 2043, 2060, 2061, 2063, 2064)
   OR (menu_type = 'F' AND perms IN (
        'health:student:query', 'health:student:export',
        'health:examBatch:query', 'health:examBatch:export',
        'health:appointment:query', 'health:appointment:export',
        'health:examRecord:query', 'health:examRecord:export'));

-- 学生：只有"我的健康"这一组，没有系统管理、没有全校统计
INSERT INTO sys_role_menu (role_id, menu_id)
VALUES (102, 2065), (102, 2066), (102, 2067), (102, 2068);

-- ---------------------------------------------------------------------
-- 七、预约状态字典补"已完成"
--     文档 4.2 要求 5 种状态：待审核 / 已预约 / 已完成 / 已取消 / 已拒绝
-- ---------------------------------------------------------------------
DELETE FROM sys_dict_data WHERE dict_type = 'ch_appoint_status' AND dict_value = '4';

UPDATE sys_dict_data SET dict_label = '已预约', dict_sort = 2, list_class = 'primary'
WHERE dict_type = 'ch_appoint_status' AND dict_value = '1';

INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
VALUES (5, '已完成', '4', 'ch_appoint_status', '', 'success', 'N', '0', 'admin', NOW(), '已录入体检记录，流程结束');

-- ---------------------------------------------------------------------
-- 八、校验输出
-- ---------------------------------------------------------------------
SELECT '--- 角色 ---' AS step;
SELECT role_id, role_name, role_key, data_scope FROM sys_role WHERE role_id IN (100, 101, 102);

SELECT '--- 账号 ---' AS step;
SELECT u.user_id, u.user_name, u.nick_name, d.dept_name, r.role_key
FROM sys_user u
LEFT JOIN sys_dept d ON d.dept_id = u.dept_id
LEFT JOIN sys_user_role ur ON ur.user_id = u.user_id
LEFT JOIN sys_role r ON r.role_id = ur.role_id
WHERE u.user_id IN (3, 4, 5, 6);

SELECT '--- 学生绑定 ---' AS step;
SELECT id, student_no, student_name, user_id FROM ch_student WHERE user_id > 0;

SELECT '--- 各角色菜单数 ---' AS step;
SELECT role_id, COUNT(*) AS menu_count FROM sys_role_menu WHERE role_id IN (100, 101, 102) GROUP BY role_id;
