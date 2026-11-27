-- ============================================================
-- 基础能力补齐脚本（可重复执行）
--   1. ch_student 增加 dept_id（数据权限）、enroll_year（入学年份）
--   2. ch_exam_record 增加 record_status（未登记/录入中/已完成）
--   3. ch_ai_assessment 增加 assess_status（待评估/评估中/评估完成）
--   4. 新建 ch_health_archive 健康档案表（设计文档 3.2 第 8 张表）
--   5. 新增 3 组数据字典
--   6. 按班级建部门，回填学生归属，配置辅导员数据范围
--   7. 回填历史数据
-- ============================================================

-- ---------- 0. 幂等加列工具 ----------
DROP PROCEDURE IF EXISTS add_column_if_absent;
DELIMITER $$
CREATE PROCEDURE add_column_if_absent(IN p_table VARCHAR(64), IN p_column VARCHAR(64), IN p_ddl VARCHAR(500))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = DATABASE() AND table_name = p_table AND column_name = p_column) THEN
        SET @ddl = CONCAT('ALTER TABLE ', p_table, ' ADD COLUMN ', p_column, ' ', p_ddl);
        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

CALL add_column_if_absent('ch_student', 'dept_id', 'BIGINT NULL COMMENT ''归属部门（班级）'' AFTER class_name');
CALL add_column_if_absent('ch_student', 'enroll_year', 'VARCHAR(4) NULL COMMENT ''入学年份'' AFTER phone');
CALL add_column_if_absent('ch_exam_record', 'record_status', 'CHAR(1) DEFAULT ''2'' COMMENT ''记录状态（0未登记 1录入中 2已完成）'' AFTER abnormal_flag');
CALL add_column_if_absent('ch_ai_assessment', 'assess_status', 'CHAR(1) DEFAULT ''2'' COMMENT ''评估状态（0待评估 1评估中 2评估完成）'' AFTER exam_record_id');

DROP PROCEDURE IF EXISTS add_column_if_absent;

-- ---------- 1. 健康档案表 ----------
CREATE TABLE IF NOT EXISTS ch_health_archive (
    id               BIGINT(20)  NOT NULL AUTO_INCREMENT COMMENT '主键',
    student_id       BIGINT(20)  NOT NULL COMMENT '学生ID',
    total_exam_count INT(11)     DEFAULT 0 COMMENT '体检次数',
    last_exam_date   DATE        DEFAULT NULL COMMENT '最近体检日期',
    health_summary   TEXT        COMMENT '健康摘要',
    archive_status   CHAR(1)     DEFAULT '0' COMMENT '档案状态（0正常 1存在异常）',
    create_by        VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time      DATETIME    DEFAULT NULL COMMENT '创建时间',
    update_by        VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time      DATETIME    DEFAULT NULL COMMENT '更新时间',
    remark           VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (id),
    UNIQUE KEY uk_student (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康档案表';

-- ---------- 2. 数据字典 ----------
INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
SELECT '体检记录状态', 'ch_record_status', '0', 'admin', NOW(), '未登记/录入中/已完成'
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'ch_record_status');

INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
SELECT 'AI评估状态', 'ch_assess_status', '0', 'admin', NOW(), '待评估/评估中/评估完成'
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'ch_assess_status');

INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
SELECT '健康档案状态', 'ch_archive_status', '0', 'admin', NOW(), '正常/存在异常'
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'ch_archive_status');

INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '未登记', '0', 'ch_record_status', '', 'warning', 'N', '0', 'admin', NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'ch_record_status' AND dict_value = '0');
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '录入中', '1', 'ch_record_status', '', 'info', 'N', '0', 'admin', NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'ch_record_status' AND dict_value = '1');
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 3, '已完成', '2', 'ch_record_status', '', 'success', 'Y', '0', 'admin', NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'ch_record_status' AND dict_value = '2');

INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '待评估', '0', 'ch_assess_status', '', 'warning', 'N', '0', 'admin', NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'ch_assess_status' AND dict_value = '0');
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '评估中', '1', 'ch_assess_status', '', 'info', 'N', '0', 'admin', NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'ch_assess_status' AND dict_value = '1');
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 3, '评估完成', '2', 'ch_assess_status', '', 'success', 'Y', '0', 'admin', NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'ch_assess_status' AND dict_value = '2');

INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 1, '正常', '0', 'ch_archive_status', '', 'success', 'Y', '0', 'admin', NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'ch_archive_status' AND dict_value = '0');
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 2, '存在异常', '1', 'ch_archive_status', '', 'danger', 'N', '0', 'admin', NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'ch_archive_status' AND dict_value = '1');

-- ---------- 3. 班级部门 + 学生归属 ----------
INSERT INTO sys_dept (dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
SELECT 120, 111, '0,100,111', '软件2401', 1, '李老师', '', '', '0', '0', 'admin', NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 120);
INSERT INTO sys_dept (dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
SELECT 121, 111, '0,100,111', '软件2402', 2, '', '', '', '0', '0', 'admin', NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 121);
INSERT INTO sys_dept (dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
SELECT 122, 111, '0,100,111', '计应2401', 3, '', '', '', '0', '0', 'admin', NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 122);
INSERT INTO sys_dept (dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
SELECT 123, 111, '0,100,111', '大数据2401', 4, '', '', '', '0', '0', 'admin', NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 123);
INSERT INTO sys_dept (dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
SELECT 124, 111, '0,100,111', '机电2401', 5, '', '', '', '0', '0', 'admin', NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 124);

-- 学生按班级归到对应部门（已归属的不覆盖）
UPDATE ch_student s
JOIN sys_dept d ON d.dept_name = s.class_name AND d.dept_id BETWEEN 120 AND 124
SET s.dept_id = d.dept_id
WHERE s.dept_id IS NULL;

-- 辅导员绑定「软件2401」班，角色数据范围改为「本部门数据权限」
UPDATE sys_user SET dept_id = 120 WHERE user_name = 'teacher01';
UPDATE sys_role SET data_scope = '3' WHERE role_key = 'counselor';

-- 学生账号的部门跟随本人班级（学生端只看本人，不依赖部门，这里只为数据一致）
UPDATE sys_user u JOIN ch_student s ON s.user_id = u.user_id
SET u.dept_id = s.dept_id
WHERE s.dept_id IS NOT NULL;

-- ---------- 4. 历史数据回填 ----------
UPDATE ch_exam_record SET record_status = '2' WHERE record_status IS NULL OR record_status = '';
UPDATE ch_ai_assessment SET assess_status = '2' WHERE assess_status IS NULL OR assess_status = '';

-- 回填档案快照：次数、最近日期、摘要、状态（后续保存体检记录时由后端重算覆盖）
INSERT INTO ch_health_archive (student_id, total_exam_count, last_exam_date, health_summary, archive_status, create_by, create_time, update_time)
SELECT t.student_id,
       t.cnt,
       t.last_date,
       CONCAT('累计体检 ', t.cnt, ' 次，最近一次 ', DATE_FORMAT(t.last_date, '%Y-%m-%d'), '；',
              CASE WHEN t.last_abnormal = '1' THEN '最近一次存在异常指标' ELSE '最近一次各项指标正常' END),
       t.last_abnormal,
       'admin', NOW(), NOW()
FROM (
    SELECT r.student_id,
           COUNT(*)                                    AS cnt,
           MAX(r.exam_date)                            AS last_date,
           SUBSTRING_INDEX(GROUP_CONCAT(r.abnormal_flag ORDER BY r.exam_date DESC, r.id DESC), ',', 1) AS last_abnormal
    FROM ch_exam_record r
    GROUP BY r.student_id
) t
ON DUPLICATE KEY UPDATE
    total_exam_count = VALUES(total_exam_count),
    last_exam_date   = VALUES(last_exam_date),
    health_summary   = VALUES(health_summary),
    archive_status   = VALUES(archive_status),
    update_time      = VALUES(update_time);

-- 入学年份：按班级名的年级段推（软件2401 -> 2024），已在页面填过的不覆盖
UPDATE ch_student
SET enroll_year = CONCAT('20', LEFT(REGEXP_SUBSTR(class_name, '[0-9]{4}'), 2))
WHERE (enroll_year IS NULL OR enroll_year = '')
  AND class_name REGEXP '[0-9]{4}$';
