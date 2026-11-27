-- ----------------------------
-- 学生端「我的AI报告」菜单
-- ----------------------------
-- 背景：设计文档 2.7 要求「学生或授权校医查看评估报告」，4.1 第 11 步是「学生查看个人体检结果和建议」。
--       学生角色原本只有 我的体检预约/我的健康档案/我的体检记录 三个菜单，看不到 AI 评估结果。
-- 说明：可重复执行（where not exists 去重）；只授给学生角色(102)，不放开 health:ai:list 这类全校权限。
-- ----------------------------

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '我的AI报告', 2065, 4, 'ai', 'health/my/ai', '', 1, 0, 'C', '0', '0', 'health:my:ai', 'education', 'admin', sysdate(), '', null, '学生查看自己的AI健康评估报告'
from dual
where not exists (
    select 1 from (select menu_id, parent_id, path from sys_menu) t
    where t.parent_id = 2065 and t.path = 'ai'
);

set @myAiMenu := (select menu_id from sys_menu where parent_id = 2065 and path = 'ai' order by menu_id limit 1);

insert into sys_role_menu (role_id, menu_id)
select 102, @myAiMenu from dual
where @myAiMenu is not null
  and not exists (
      select 1 from (select role_id, menu_id from sys_role_menu) t
      where t.role_id = 102 and t.menu_id = @myAiMenu
  );
