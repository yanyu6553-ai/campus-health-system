-- =====================================================================
-- 修复：学生端「我的体检预约」「我的AI报告」页面打不开
--
-- 原因：RuoYi-Vue3 前端路由的 name 是后端按菜单 path 首字母大写生成的。
--       「体检预约管理」path=appointment  → name=Appointment
--       「我的体检预约」path=appointment  → name=Appointment   ← 撞车
--       vue-router 遇到同名路由会把先注册的那条删掉，
--       结果 /myHealth/appointment 这条路由直接消失，页面白屏/404。
--       「我的AI报告」path=ai 与「智能健康管理」目录 path=/ai 同理，name 都是 Ai。
--
-- 修法：把学生端这两条菜单的 path 改成独一无二的，路由 name 自然就不撞了。
--       只改 path，component 不动，页面文件不用改，后端也不用重新编译。
-- =====================================================================

UPDATE sys_menu SET path = 'myAppointment', update_by = 'admin', update_time = NOW()
WHERE menu_id = 2066;

UPDATE sys_menu SET path = 'myAi', update_by = 'admin', update_time = NOW()
WHERE menu_id = 2069;

-- 校验：下面这条应该查不出任何重复（0 行）
SELECT path, COUNT(*) AS c, GROUP_CONCAT(CONCAT(menu_id, ':', menu_name)) AS items
FROM sys_menu
WHERE menu_type = 'C'
GROUP BY path
HAVING c > 1;
