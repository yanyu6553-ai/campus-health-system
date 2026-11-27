# 校园学生体检与健康档案管理系统

基于若依（RuoYi-Vue）二次开发的校园健康管理平台，面向高校校医院与学工部门，覆盖 **学生档案 → 体检批次 → 体检登记 → 健康档案 → AI 健康评估 → 预约管理** 的完整业务闭环。

> 本项目为课程设计 / 团队协作项目，在若依开源框架基础上完成了健康管理业务模块的设计与开发。

---

## 一、功能概览

### 业务模块

| 模块 | 说明 |
|---|---|
| **学生档案管理** | 学生信息增删改查、Excel 批量导入导出、账号打通、按班级隔离数据 |
| **体检项目管理** | 体检项配置（身高、体重、血压、视力、心率等）与正常值范围维护 |
| **体检批次管理** | 按学期/年级组织批次，支持批量生成待检记录、定时任务自动推进 |
| **体检记录登记** | 单项数据录入、批量录入、历史记录追溯、异常项自动标记 |
| **健康档案** | 汇总学生历次体检数据，形成个人健康档案视图 |
| **AI 健康评估** | 调用大模型生成个性化健康解释与建议（详见下文「AI 模块设计」） |
| **预约管理** | 学生提交体检预约，校医审核，支持审批流 |
| **数据统计** | 体检完成率统计、健康状况分布图表（ECharts） |

### 角色与权限

系统设计三类业务角色 + 若依内置管理员，功能权限（`@PreAuthorize`）与数据权限（`@DataScope`）双重控制：

| 角色 | role_key | 数据范围 | 核心职责 |
|---|---|---|---|
| 超级管理员 | `admin` | 全部 | 系统配置、用户与角色管理 |
| **校医** | `doctor` | 全校数据 | 体检项目/批次管理、预约审核、体检登记、档案与 AI 评估 |
| **辅导员** | `counselor` | 本班数据 | 只读查看学生信息、预约情况、健康档案与统计，不可增删改 |
| **学生** | `student` | 仅本人 | 我的预约、我的档案、我的体检记录、我的 AI 报告 |

---

## 二、技术栈

### 后端

| 技术 | 版本 | 用途 |
|---|---|---|
| Java | 17 | 开发语言 |
| Spring Boot | 4.1.0 | 应用框架 |
| MyBatis (mybatis-spring-boot) | 4.1.0 | ORM 持久层 |
| MySQL | 8.x | 关系型数据库 |
| Druid | 1.2.28 | 数据库连接池 + SQL 监控 |
| Spring AI | 2.0.0 | 大模型调用（ChatClient） |
| JWT (jjwt) | 0.9.1 | 无状态认证 |
| Quartz | — | 定时任务调度（体检批次自动推进、AI 评估补偿） |
| Apache POI | — | Excel 导入导出 |
| FastJSON2 | — | JSON 解析 |

### 前端

| 技术 | 版本 | 用途 |
|---|---|---|
| Vue | 3.5.26 | 前端框架（组合式 API） |
| Vite | 6.4.1 | 构建工具 |
| Element Plus | 2.13.1 | UI 组件库 |
| Pinia | 3.0.4 | 状态管理 |
| Vue Router | — | 路由与菜单驱动 |
| Axios | 1.13.2 | HTTP 请求 |
| ECharts | 5.6.0 | 数据可视化 |

### 项目结构

```
campus-health-system/
├── RuoYi-Vue/                      # 后端（Maven 多模块）
│   ├── ruoyi-admin/                # 启动模块 + 配置文件
│   ├── ruoyi-common/               # 通用工具、注解、异常
│   ├── ruoyi-framework/            # 框架核心（Security、DataScope 切面）
│   ├── ruoyi-system/               # 系统管理（用户、角色、部门、菜单）
│   ├── ruoyi-quartz/               # 定时任务
│   ├── ruoyi-generator/            # 代码生成器
│   ├── ruoyi-health/               # ★ 健康管理业务模块
│   ├── sql/                        # 各业务表建表脚本
│   └── docs/                       # 设计文档
├── RuoYi-Vue3UI/                   # 前端（Vue3 + Vite）
│   └── src/
│       ├── api/health/             # 业务接口封装
│       └── views/health/           # 业务页面
├── sql/campus_health.sql           # 完整数据库脚本（建库即用）
├── 交付文档/
└── 使用说明.md
```

---

## 三、数据库设计

### 业务表（7 张）

| 表名 | 说明 |
|---|---|
| `ch_student` | 学生档案，关联若依用户、含部门字段用于数据权限 |
| `ch_exam_item` | 体检项目定义（项目名、单位、正常值范围） |
| `ch_exam_batch` | 体检批次（批次名、时间范围、适用年级） |
| `ch_exam_record` | 体检记录（学生 + 批次 + 项目 + 实测值 + 是否异常） |
| `ch_health_archive` | 健康档案（学生健康汇总视图） |
| `ch_appointment` | 预约申请（学生提交、校医审核） |
| `ch_ai_assessment` | AI 评估结果（风险等级、模型回答、模型名、生成时间） |

> 另复用若依内置的 `sys_user` / `sys_role` / `sys_dept` / `sys_menu` 等系统表。

---

## 四、核心设计

### 1. 学生管理：三个「借力」

不重复造轮子，把若依已有能力用在业务上：

- **借用户体系做登录** —— 新增学生时可勾选「同时创建登录账号」，后端自动调用 `ISysUserService` 建号，账号 = 学号，初始密码 BCrypt 加密，绑定 `student` 角色与班级部门
- **借部门树做数据隔离** —— 班级映射为部门，`ch_student` 增加 `dept_id` 字段，查询方法标注 `@DataScope(deptAlias = "s")`，辅导员只能看到本班学生
- **借登录态做身份锚点** —— 学生端 `selectCurrentStudent()` 从 `SecurityUtils.getUserId()` 反查档案，**前端传入的 studentId 不参与查询**，从根源上杜绝越权

### 2. 权限：功能权限 + 数据权限双层

```java
// Controller 层：功能权限，一个按钮一个权限标识
@PreAuthorize("@ss.hasPermi('health:student:list')")
public TableDataInfo list(Student student) { ... }

// Service 层：数据权限，切面自动拼 SQL 条件
@DataScope(deptAlias = "s")
public List<Student> selectStudentList(Student student) { ... }
```

- 管理员 / 校医（`data_scope=1`）：全校数据，不加过滤
- 辅导员（`data_scope=4`）：本部门，追加 `and s.dept_id = xxx`
- 学生（`data_scope=5`）：仅本人，追加 `and s.create_by = 'xxx'`

### 3. 删除联动：防僵尸账号

删除学生时先收集关联的 `user_id`，再删学生 + 删账号，两道保护：

- 绝不删除 `admin`（`user_id = 1`）
- 账号若还绑定其他学生则跳过，避免误删

防止出现「学生删了但账号还在，学号被永久占用」的问题。

### 4. Excel 导入：逐行容错

- 空行自动跳过
- 学号查重：不存在则插入；已存在则按 `updateSupport` 参数决定覆盖或报错
- 性别、状态等字段缺省值兜底
- **一行出错不影响整批**，失败明细返回前端

---

## 五、AI 健康评估模块设计

这是本项目最具设计考量的部分。核心思路：**让大模型做它擅长的事（解释与建议），不让它做不该做的事（诊断）。**

### 四条设计原则

1. **异常判定在代码里，不在模型里**
   血压等指标是否异常由后端按固定阈值判定（收缩压 ≥ 140 mmHg、舒张压 ≥ 90 mmHg），模型不参与诊断。

2. **数据脱敏后再发送**
   发给模型的数据不含姓名、学号等身份信息，只有生理指标与年龄段。

3. **风险等级由后端决定**
   根据异常项数量计算风险等级，**模型的回答只作参考**，避免模型自行拔高或降低风险。

4. **结果落库可追溯**
   评估结果写入 `ch_ai_assessment`，保留模型名称与生成时间，便于事后核查。

### 工程细节

```java
// 用 ObjectProvider 而非直接注入：模型密钥没配时不至于让整个应用启动失败，
// 只是「AI 评估」这一个功能不可用，其他业务模块照常运行
@Autowired
private ObjectProvider<ChatClient.Builder> chatClientBuilderProvider;
```

- **失败重试**：免费路由偶发落到劣质 provider 时，最多重试 3 次换一家
- **异步补偿**：通过 Quartz 定时任务扫描未完成评估的记录，补齐结果（`ExamBatchTask` / `ai_pending_backfill.sql`）
- **权限隔离**：校医可看全校 AI 报告（`health:ai:list`），学生仅能看自己的（`health:my:ai`），避免授权后泄露全校数据

---

## 六、快速开始

### 环境要求

- JDK 17+
- MySQL 8.0+
- Redis（若依默认依赖，用于缓存与 Token）
- Node.js 18+ / npm

### 后端启动

```bash
# 1. 建库并导入数据
mysql -u root -p -e "CREATE DATABASE campus_health DEFAULT CHARSET utf8mb4;"
mysql -u root -p campus_health < sql/campus_health.sql

# 2. 修改数据库连接（按需）
#    RuoYi-Vue/ruoyi-admin/src/main/resources/application-druid.yml

# 3. 打包运行
cd RuoYi-Vue
mvn clean package -DskipTests
java -jar ruoyi-admin/target/ruoyi-admin.jar
```

### 前端启动

```bash
cd RuoYi-Vue3UI
npm install
npm run dev
```

访问 `http://localhost:80`（默认若依前端端口，可改 `vite.config.js`）。

### 演示账号

| 角色 | 账号 | 说明 |
|---|---|---|
| 管理员 | `admin` | 若依默认 |
| 校医 | 见 `sql/roles_accounts.sql` | 体检全流程操作 |
| 辅导员 | 见 `sql/roles_accounts.sql` | 只读本班数据 |
| 学生 | `student01` / `student02` | 查看本人档案与 AI 报告 |

> 初始密码统一为若依默认值，具体以 `roles_accounts.sql` 内注释为准。

---

## 七、AI 配置说明

AI 功能依赖 Spring AI 的 OpenAI 兼容接口。在 `application.yml` 中配置：

```yaml
spring:
  ai:
    openai:
      base-url: https://api-inference.modelscope.cn/v1   # 或其他 OpenAI 兼容服务
      api-key: ${AI_API_KEY}
      chat:
        options:
          model: deepseek-ai/DeepSeek-V4.1-Flash-1017
```

**未配置密钥时系统仍可正常启动**，仅 AI 评估功能不可用（设计如此，见上文 `ObjectProvider` 说明）。

---

## 八、开发说明

- 本项目基于 **RuoYi-Vue**（MIT 协议）二次开发，保留了框架原有的系统管理、代码生成、定时任务等能力
- 业务代码集中在 `ruoyi-health` 模块，按 Controller / Service / Mapper / Domain 四层组织
- 数据库脚本按功能拆分在 `RuoYi-Vue/sql/` 下，`sql/campus_health.sql` 为完整初始化脚本

## 九、致谢

- [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) —— 优秀的开源后台管理框架
- [Spring AI](https://spring.io/projects/spring-ai) —— 大模型集成框架
- [Element Plus](https://element-plus.org/) / [Vue 3](https://cn.vuejs.org/) —— 前端技术栈

---

## License

本项目仅供学习交流使用。基于的 RuoYi-Vue 遵循 MIT 协议。