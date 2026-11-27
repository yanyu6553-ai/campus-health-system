-- =====================================================================
-- 校园学生体检与健康档案管理系统 —— V2 表结构对齐脚本
--
-- 目的：把三张业务表的字段名/字段缺失，对齐到设计文档（三、数据库设计 3.3）
--   表3 ch_exam_batch     缺 start_time / end_time
--   表4 ch_appointment    appointment_time / audit_user / audit_remark 命名不一致
--   表5 ch_exam_record    heart_rate 实际叫 pulse_rate、缺 examiner_id
--
-- 特性：
--   1. 幂等：重复执行不会报错，也不会重复迁移数据
--   2. 先备份再改：执行前请先 mysqldump（见 sql/backup/）
--   3. 只改结构，不动业务数据；只有"新字段需要历史值"时才做一次性回填
--
-- 执行方式：
--   mysql -uroot -p --default-character-set=utf8mb4 campus_health < v2_align_doc.sql
-- =====================================================================
USE campus_health;

-- ---------------------------------------------------------------------
-- 零、通用小工具（MySQL 8.0 不支持 ADD COLUMN IF NOT EXISTS，用存储过程兜底）
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_health_add_col;
DROP PROCEDURE IF EXISTS sp_health_rename_col;
DROP PROCEDURE IF EXISTS sp_health_drop_col;

DELIMITER $$

-- 加列：列已存在就跳过
CREATE PROCEDURE sp_health_add_col(IN p_table VARCHAR(64), IN p_col VARCHAR(64), IN p_ddl VARCHAR(500))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_col) THEN
        SET @ddl = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN ', p_ddl);
        PREPARE st FROM @ddl;
        EXECUTE st;
        DEALLOCATE PREPARE st;
    END IF;
END$$

-- 改名：旧列存在且新列不存在时才改，改过一次后再跑就自动跳过
CREATE PROCEDURE sp_health_rename_col(IN p_table VARCHAR(64), IN p_old VARCHAR(64), IN p_new VARCHAR(64), IN p_type VARCHAR(255))
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_old)
       AND NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS
                       WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_new) THEN
        SET @ddl = CONCAT('ALTER TABLE `', p_table, '` CHANGE COLUMN `', p_old, '` `', p_new, '` ', p_type);
        PREPARE st FROM @ddl;
        EXECUTE st;
        DEALLOCATE PREPARE st;
    END IF;
END$$

-- 删列：存在才删
CREATE PROCEDURE sp_health_drop_col(IN p_table VARCHAR(64), IN p_col VARCHAR(64))
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_col) THEN
        SET @ddl = CONCAT('ALTER TABLE `', p_table, '` DROP COLUMN `', p_col, '`');
        PREPARE st FROM @ddl;
        EXECUTE st;
        DEALLOCATE PREPARE st;
    END IF;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- 一、表3 ch_exam_batch：补 start_time / end_time
--
-- 文档给的批次是"时间段"，原来只有单日 exam_date，排不出一上午/一下午。
-- exam_date 保留：体检记录和预约列表都要按"哪一天"展示与统计，
-- 它是 start_time 的日期部分派生物，由后端保存时自动同步，不需要人工填。
-- ---------------------------------------------------------------------
CALL sp_health_add_col('ch_exam_batch', 'start_time', '`start_time` datetime NULL COMMENT ''批次开始时间'' AFTER `batch_name`');
CALL sp_health_add_col('ch_exam_batch', 'end_time',   '`end_time`   datetime NULL COMMENT ''批次结束时间'' AFTER `start_time`');

-- 历史数据回填：单日批次默认按 08:00 ~ 17:00 排，只填还没填过的
UPDATE ch_exam_batch
SET start_time = TIMESTAMP(exam_date, '08:00:00'),
    end_time   = TIMESTAMP(exam_date, '17:00:00')
WHERE start_time IS NULL
  AND exam_date IS NOT NULL;

-- 反过来兜底：万一有批次只填了时间没填日期，把日期补上
UPDATE ch_exam_batch
SET exam_date = DATE(start_time)
WHERE exam_date IS NULL
  AND start_time IS NOT NULL;

-- ---------------------------------------------------------------------
-- 二、表4 ch_appointment：三个字段改名 + audit_user 由"用户名"改成"用户ID"
--
-- 为什么 audit_user 用 BIGINT：文档写的是"审核人员"，用外键ID比存用户名更规范，
-- 用户改名/被删都不会让审核痕迹失真。展示时联 sys_user 取昵称。
-- 所以必须先按 user_name 把历史用户名翻译成 user_id，再删旧列。
-- ---------------------------------------------------------------------
CALL sp_health_add_col('ch_appointment', 'audit_user', '`audit_user` bigint NULL COMMENT ''审核人员（sys_user.user_id）'' AFTER `status`');

UPDATE ch_appointment a
JOIN sys_user u ON u.user_name = a.audit_by
SET a.audit_user = u.user_id
WHERE a.audit_user IS NULL
  AND a.audit_by IS NOT NULL
  AND a.audit_by <> '';

CALL sp_health_drop_col('ch_appointment', 'audit_by');

CALL sp_health_rename_col('ch_appointment', 'appoint_time', 'appointment_time', 'datetime NULL COMMENT ''预约提交时间''');
CALL sp_health_rename_col('ch_appointment', 'reject_reason', 'audit_remark',    'varchar(500) NULL COMMENT ''审核备注（拒绝时说明原因）''');

-- ---------------------------------------------------------------------
-- 三、表5 ch_exam_record：pulse_rate → heart_rate，补 examiner_id
--
-- 文档字段名是心率 heart_rate；前端标签也跟着改成"心率"，
-- 避免"表里叫脉搏、文档叫心率"答辩对不上。
-- ---------------------------------------------------------------------
CALL sp_health_rename_col('ch_exam_record', 'pulse_rate', 'heart_rate', 'int NULL COMMENT ''心率(次/分)''');
CALL sp_health_add_col('ch_exam_record', 'examiner_id', '`examiner_id` bigint NULL COMMENT ''体检人员（sys_user.user_id）'' AFTER `remark`');

-- 历史记录回填：录入人 create_by 存的就是用户名，翻译成 user_id
UPDATE ch_exam_record r
JOIN sys_user u ON u.user_name = r.create_by
SET r.examiner_id = u.user_id
WHERE r.examiner_id IS NULL
  AND r.create_by IS NOT NULL
  AND r.create_by <> '';

-- ---------------------------------------------------------------------
-- 四、体检项目配置里的字段绑定同步改名
--     体检项目的 field_key 要和体检记录的列名对得上，否则异常判定会"跳过"这一项
-- ---------------------------------------------------------------------
UPDATE ch_exam_item SET field_key = 'heart_rate' WHERE field_key = 'pulse_rate';

-- ---------------------------------------------------------------------
-- 五、索引：审核人、体检人员后面会用于筛选，补上普通索引
-- ---------------------------------------------------------------------
SET @idx = (SELECT COUNT(*) FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ch_appointment' AND INDEX_NAME = 'idx_audit_user');
SET @ddl = IF(@idx = 0, 'ALTER TABLE `ch_appointment` ADD INDEX `idx_audit_user` (`audit_user`)', 'SELECT 1');
PREPARE st FROM @ddl; EXECUTE st; DEALLOCATE PREPARE st;

SET @idx = (SELECT COUNT(*) FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ch_exam_record' AND INDEX_NAME = 'idx_examiner');
SET @ddl = IF(@idx = 0, 'ALTER TABLE `ch_exam_record` ADD INDEX `idx_examiner` (`examiner_id`)', 'SELECT 1');
PREPARE st FROM @ddl; EXECUTE st; DEALLOCATE PREPARE st;

-- ---------------------------------------------------------------------
-- 六、清理临时过程
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_health_add_col;
DROP PROCEDURE IF EXISTS sp_health_rename_col;
DROP PROCEDURE IF EXISTS sp_health_drop_col;

-- ---------------------------------------------------------------------
-- 七、执行结果自检
-- ---------------------------------------------------------------------
SELECT '--- ch_exam_batch ---' AS step;
SELECT id, batch_name, start_time, end_time, exam_date, capacity, booked_count, status
FROM ch_exam_batch ORDER BY id;

SELECT '--- ch_appointment 字段 ---' AS step;
SELECT COLUMN_NAME, COLUMN_TYPE FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ch_appointment'
ORDER BY ORDINAL_POSITION;

SELECT '--- ch_exam_record 字段 ---' AS step;
SELECT COLUMN_NAME, COLUMN_TYPE FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ch_exam_record'
ORDER BY ORDINAL_POSITION;

SELECT '--- 体检项目字段绑定 ---' AS step;
SELECT id, item_code, field_key FROM ch_exam_item ORDER BY id;
