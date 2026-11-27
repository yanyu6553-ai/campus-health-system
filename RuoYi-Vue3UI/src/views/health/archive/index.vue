<template>
  <div class="app-container">
    <el-row :gutter="16">
      <!-- 左侧：学生列表 -->
      <el-col :span="6">
        <el-card shadow="never" class="student-card">
          <template #header>
            <div class="card-header">
              <span>学生列表</span>
              <el-tag size="small" type="info">{{ filteredStudents.length }} 人</el-tag>
            </div>
          </template>
          <el-input v-model="keyword" placeholder="搜索姓名 / 学号" prefix-icon="Search" clearable style="margin-bottom: 10px" />
          <div class="student-list">
            <div
              v-for="s in filteredStudents"
              :key="s.id"
              class="student-item"
              :class="{ active: s.id === currentStudentId }"
              @click="selectStudent(s.id)"
            >
              <div class="student-name">
                <span>{{ s.studentName }}</span>
                <el-tag size="small" :type="s.gender === '0' ? 'primary' : 'danger'" effect="plain">
                  {{ s.gender === '0' ? '男' : '女' }}
                </el-tag>
              </div>
              <div class="student-no">{{ s.studentNo }} · {{ s.className || s.major || '未分班' }}</div>
            </div>
            <el-empty v-if="filteredStudents.length === 0" description="没有匹配的学生" :image-size="60" />
          </div>
        </el-card>
      </el-col>

      <!-- 右侧：档案详情 -->
      <el-col :span="18">
        <template v-if="currentStudentId">
          <!-- 基本信息 + 最新指标 -->
          <el-card shadow="never" style="margin-bottom: 16px">
            <template #header>
              <div class="card-header">
                <span>{{ archive.student ? archive.student.studentName + ' 的健康档案' : '健康档案' }}</span>
                <div class="header-right">
                  <el-tag v-if="latest" :type="latest.abnormalFlag === '1' ? 'danger' : 'success'">
                    {{ latest.abnormalFlag === '1' ? '最新体检：异常' : '最新体检：正常' }}
                  </el-tag>
                  <el-button
                    v-if="latest"
                    type="primary"
                    size="small"
                    @click="handleAiAssess"
                  >AI 智能评估</el-button>
                </div>
              </div>
            </template>
            <el-descriptions v-if="archive.student" :column="3" border size="small" style="margin-bottom: 14px">
              <el-descriptions-item label="学号">{{ archive.student.studentNo }}</el-descriptions-item>
              <el-descriptions-item label="学院">{{ archive.student.college || '-' }}</el-descriptions-item>
              <el-descriptions-item label="班级">{{ archive.student.className || '-' }}</el-descriptions-item>
            </el-descriptions>

            <!-- 档案快照：来自 ch_health_archive，体检记录一变就重算 -->
            <div v-if="archive.archive" class="archive-summary">
              <el-tag size="small" :type="archive.archive.archiveStatus === '1' ? 'danger' : 'success'">
                {{ archive.archive.archiveStatus === '1' ? '档案状态：存在异常' : '档案状态：正常' }}
              </el-tag>
              <span class="archive-summary-text">{{ archive.archive.healthSummary }}</span>
              <span class="archive-summary-meta">
                体检 {{ archive.archive.totalExamCount }} 次
                <template v-if="archive.archive.lastExamDate"> · 最近 {{ parseTime(archive.archive.lastExamDate, '{y}-{m}-{d}') }}</template>
              </span>
            </div>

            <el-empty v-if="!latest" description="该学生暂无体检记录" :image-size="80" />
            <template v-else>
              <el-row :gutter="12">
                <el-col :span="4" v-for="m in latestMetrics" :key="m.label">
                  <div class="metric-box">
                    <div class="metric-label">{{ m.label }}</div>
                    <div class="metric-value" :class="{ danger: m.danger }">{{ m.value }}<span class="metric-unit">{{ m.unit }}</span></div>
                    <div class="metric-sub" v-if="m.sub">{{ m.sub }}</div>
                  </div>
                </el-col>
              </el-row>
              <div class="latest-date">数据来自最近一次体检：{{ parseTime(latest.examDate, '{y}-{m}-{d}') }}（{{ latest.batchName || '未关联批次' }}）</div>
            </template>
          </el-card>

          <!-- BMI 趋势 -->
          <el-card shadow="never" style="margin-bottom: 16px" v-if="records.length > 0">
            <template #header><span>BMI 趋势（24 为超重线，28 为肥胖线）</span></template>
            <div ref="trendChart" class="trend-chart"></div>
          </el-card>

          <!-- 历年记录 -->
          <el-card shadow="never" v-if="records.length > 0">
            <template #header><span>历年体检记录（{{ records.length }} 条）</span></template>
            <el-table :data="records" size="small" border>
              <el-table-column label="体检日期" align="center" prop="examDate" width="100">
                <template #default="scope">
                  <span>{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</span>
                </template>
              </el-table-column>
              <el-table-column label="体检批次" align="center" prop="batchName" min-width="130" />
              <el-table-column label="身高(cm)" align="center" prop="height" width="80" />
              <el-table-column label="体重(kg)" align="center" prop="weight" width="80" />
              <el-table-column label="BMI" align="center" prop="bmi" width="70" />
              <el-table-column label="等级" align="center" prop="bmiLevel" width="80">
                <template #default="scope">
                  <dict-tag :options="ch_bmi_level" :value="scope.row.bmiLevel"/>
                </template>
              </el-table-column>
              <el-table-column label="血压(mmHg)" align="center" width="110">
                <template #default="scope">
                  <span>{{ scope.row.systolicPressure || '-' }} / {{ scope.row.diastolicPressure || '-' }}</span>
                </template>
              </el-table-column>
              <el-table-column label="心率" align="center" prop="heartRate" width="70" />
              <el-table-column label="视力(L/R)" align="center" width="90">
                <template #default="scope">
                  <span>{{ scope.row.visionLeft || '-' }} / {{ scope.row.visionRight || '-' }}</span>
                </template>
              </el-table-column>
              <el-table-column label="异常" align="center" width="70">
                <template #default="scope">
                  <el-tag size="small" :type="scope.row.abnormalFlag === '1' ? 'danger' : 'success'">
                    {{ scope.row.abnormalFlag === '1' ? '异常' : '正常' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="体检小结" align="center" prop="conclusion" min-width="140" show-overflow-tooltip />
            </el-table>
          </el-card>

          <!-- AI 评估记录：文档 2.6 要求「查看健康评估记录」，之前只显示最近一次，这里补齐全部历史 -->
          <el-card shadow="never" style="margin-top: 16px" v-if="aiHistory.length > 0">
            <template #header>
              <div class="card-header">
                <span>AI 健康评估记录（{{ aiHistory.length }} 条）</span>
                <span class="card-head-hint">按生成时间倒序，点「查看」可回看当时的报告内容</span>
              </div>
            </template>
            <el-table :data="aiHistory" size="small" border>
              <el-table-column label="生成时间" width="150" align="center">
                <template #default="scope">
                  <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}') }}</span>
                </template>
              </el-table-column>
              <el-table-column label="对应体检日期" width="120" align="center">
                <template #default="scope">
                  <span>{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</span>
                </template>
              </el-table-column>
              <el-table-column label="风险等级" width="100" align="center">
                <template #default="scope">
                  <el-tag size="small" :type="riskTypeOf(scope.row.riskLevel)">
                    {{ riskTextOf(scope.row.riskLevel) }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="评估摘要" prop="assessmentResult" min-width="240" show-overflow-tooltip />
              <el-table-column label="模型" prop="modelName" width="140" show-overflow-tooltip />
              <el-table-column label="操作" width="90" align="center">
                <template #default="scope">
                  <el-button link type="primary" icon="View" @click="viewAiReport(scope.row)">查看</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </template>
        <el-card v-else shadow="never">
          <el-empty description="请从左侧选择一位学生查看健康档案" />
        </el-card>
      </el-col>
    </el-row>

    <!-- AI 智能评估报告 -->
    <el-dialog v-model="aiVisible" title="AI 智能健康评估" width="720px" append-to-body>
      <div v-loading="aiLoading" element-loading-text="大模型正在分析体检数据，请稍候..." style="min-height: 160px">
        <template v-if="aiReport">
          <div class="ai-head">
            <el-tag :type="riskType" size="large" effect="dark">{{ riskText }}</el-tag>
            <span class="ai-summary">{{ aiReport.assessmentResult }}</span>
          </div>

          <template v-if="aiAbnormal.length > 0">
            <div class="ai-section-title">异常指标解释</div>
            <div class="ai-item" v-for="(it, idx) in aiAbnormal" :key="idx">
              <div class="ai-item-title">
                {{ it.item }}
                <span class="ai-item-value">{{ it.value }}</span>
                <span class="ai-item-ref">参考 {{ it.reference }}</span>
              </div>
              <div class="ai-item-body">{{ it.explanation }}</div>
            </div>
          </template>

          <template v-if="aiSuggest.length > 0">
            <div class="ai-section-title">健康建议</div>
            <ol class="ai-suggest">
              <li v-for="(s, idx) in aiSuggest" :key="idx">{{ s }}</li>
            </ol>
          </template>

          <el-alert
            type="warning"
            :closable="false"
            show-icon
            style="margin-top: 14px"
            :title="aiReport.remark || '本报告仅供健康管理参考，不能代替医生的专业诊断'"
          />
          <div class="ai-meta">
            模型：{{ aiReport.modelName || '-' }}
            <span class="ai-meta-sep">|</span>
            生成时间：{{ parseTime(aiReport.updateTime || aiReport.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}
          </div>
        </template>
        <el-empty v-else-if="!aiLoading" description="该体检记录还没有评估结果，点击下方按钮生成" :image-size="70" />
      </div>
      <template #footer>
        <el-button @click="aiVisible = false">关闭</el-button>
        <el-button type="primary" :loading="aiLoading" @click="runAiAssess">
          {{ aiReport ? '重新生成' : '生成评估' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Archive">
import * as echarts from "echarts"
import { parseTime } from "@/utils/ruoyi"
import { listStudent } from "@/api/health/student"
import { getArchive } from "@/api/health/archive"
import { assessHealth, getAiAssessmentByRecord, listAiAssessment } from "@/api/health/ai"

const { proxy } = getCurrentInstance()
const { ch_bmi_level } = useDict('ch_bmi_level')

const keyword = ref("")
const students = ref([])
const currentStudentId = ref(null)
const archive = ref({})
const records = ref([])
const latest = ref(null)

const trendChart = ref(null)
let chartInstance = null

/** ===== AI 智能评估 ===== */
const aiVisible = ref(false)
const aiLoading = ref(false)
const aiReport = ref(null)
/** 该学生历次评估记录（文档 2.6「查看健康评估记录」） */
const aiHistory = ref([])

/** 异常指标（后端存的是 JSON 字符串，这里解析成数组给模板用） */
const aiAbnormal = computed(() => {
  try { return JSON.parse(aiReport.value?.abnormalItems || "[]") } catch (e) { return [] }
})
const aiSuggest = computed(() => {
  try { return JSON.parse(aiReport.value?.suggestions || "[]") } catch (e) { return [] }
})
const riskText = computed(() =>
  ({ LOW: "低风险", MEDIUM: "中风险", HIGH: "高风险" })[aiReport.value?.riskLevel] || "-")
const riskType = computed(() =>
  ({ LOW: "success", MEDIUM: "warning", HIGH: "danger" })[aiReport.value?.riskLevel] || "info")

/** 列表里每行都要判风险等级，抽成函数，避免模板里写一长串三元 */
function riskTextOf(level) {
  return ({ LOW: "低风险", MEDIUM: "中风险", HIGH: "高风险" })[level] || "-"
}
function riskTypeOf(level) {
  return ({ LOW: "success", MEDIUM: "warning", HIGH: "danger" })[level] || "info"
}

/** 查该学生的全部 AI 评估记录（后端按 studentId 过滤，已完成的才展示内容） */
function loadAiHistory(studentId) {
  listAiAssessment({ studentId, pageNum: 1, pageSize: 100 }).then(res => {
    aiHistory.value = (res.rows || []).filter(item => item.assessStatus === '2')
  }).catch(() => { aiHistory.value = [] })
}

/** 点「查看」直接回看某一条历史报告 */
function viewAiReport(row) {
  aiReport.value = row
  aiVisible.value = true
}

/** 打开评估弹窗：已有结果直接展示，没有才调模型生成（模型调用要等几秒） */
function handleAiAssess() {
  if (!latest.value) return
  aiReport.value = null
  aiVisible.value = true
  aiLoading.value = true
  getAiAssessmentByRecord(latest.value.id).then(res => {
    aiLoading.value = false
    if (res.data) {
      aiReport.value = res.data
    } else {
      runAiAssess()
    }
  }).catch(() => { aiLoading.value = false })
}

/** 调用大模型生成评估 */
function runAiAssess() {
  if (!latest.value) return
  aiLoading.value = true
  assessHealth(latest.value.id).then(res => {
    aiReport.value = res.data
    proxy.$modal.msgSuccess("AI 评估已生成")
    // 生成成功后历史列表要跟着多一条
    loadAiHistory(currentStudentId.value)
  }).finally(() => { aiLoading.value = false })
}

/** 左侧学生按关键字本地过滤 */
const filteredStudents = computed(() => {
  const k = keyword.value.trim()
  if (!k) return students.value
  return students.value.filter(s =>
    (s.studentName || "").includes(k) || (s.studentNo || "").includes(k)
  )
})

/** 最新指标卡片数据 */
const latestMetrics = computed(() => {
  if (!latest.value) return []
  const r = latest.value
  const abnormalPressure = (r.systolicPressure != null && r.systolicPressure >= 140) ||
      (r.diastolicPressure != null && r.diastolicPressure >= 90)
  return [
    { label: "身高", value: r.height ?? '-', unit: " cm" },
    { label: "体重", value: r.weight ?? '-', unit: " kg" },
    { label: "BMI", value: r.bmi ?? '-', unit: "", sub: bmiLevelText(r.bmiLevel), danger: ["2", "3"].includes(r.bmiLevel) },
    { label: "收缩压", value: r.systolicPressure ?? '-', unit: " mmHg", danger: abnormalPressure },
    { label: "舒张压", value: r.diastolicPressure ?? '-', unit: " mmHg", danger: abnormalPressure },
    { label: "心率", value: r.heartRate ?? '-', unit: " 次/分" }
  ]
})

function bmiLevelText(level) {
  return ({ "0": "偏低", "1": "正常", "2": "超重", "3": "肥胖" })[level] || ""
}

function loadStudents() {
  listStudent({ pageNum: 1, pageSize: 999 }).then(res => {
    students.value = res.rows || []
    // 默认选中第一位学生
    if (students.value.length > 0) {
      selectStudent(students.value[0].id)
    }
  })
}

function selectStudent(studentId) {
  currentStudentId.value = studentId
  aiHistory.value = []
  getArchive(studentId).then(res => {
    archive.value = res.data || {}
    records.value = archive.value.records || []
    latest.value = archive.value.latest || null
    nextTick(renderTrendChart)
  })
  loadAiHistory(studentId)
}

/** BMI 趋势折线图 */
function renderTrendChart() {
  if (!trendChart.value || records.value.length === 0) return
  if (!chartInstance) {
    chartInstance = echarts.init(trendChart.value)
    window.addEventListener("resize", () => chartInstance && chartInstance.resize())
  }
  const dates = records.value.map(r => parseTime(r.examDate, "{y}-{m}-{d}"))
  const values = records.value.map(r => Number(r.bmi) || 0)
  chartInstance.setOption({
    tooltip: { trigger: "axis" },
    grid: { left: 40, right: 20, top: 20, bottom: 30 },
    xAxis: { type: "category", data: dates },
    yAxis: { type: "value", min: (v) => Math.max(0, Math.floor(v.min - 2)), name: "BMI" },
    series: [{
      name: "BMI",
      type: "line",
      data: values,
      smooth: true,
      symbolSize: 7,
      lineStyle: { width: 3, color: "#409EFF" },
      itemStyle: { color: "#409EFF" },
      areaStyle: { color: "rgba(64, 158, 255, 0.12)" },
      markLine: {
        silent: true,
        symbol: "none",
        lineStyle: { type: "dashed", color: "#E6A23C" },
        label: { position: "end", formatter: "{b}" },
        data: [
          { yAxis: 24, name: "超重线", label: { formatter: "超重 24", position: "insideStartTop" } },
          { yAxis: 28, name: "肥胖线", label: { formatter: "肥胖 28", position: "insideStartTop" } }
        ]
      }
    }]
  }, true)
  chartInstance.resize()
}

loadStudents()
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.header-right {
  display: flex;
  align-items: center;
  gap: 10px;
}
.card-head-hint {
  font-size: 12px;
  color: #909399;
}
/* ===== AI 评估报告 ===== */
.ai-head {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
}
.ai-summary {
  flex: 1;
  line-height: 1.7;
  color: #303133;
  font-size: 14px;
}
.ai-section-title {
  margin: 16px 0 8px;
  padding-left: 8px;
  font-weight: 600;
  font-size: 14px;
  color: #303133;
  border-left: 3px solid var(--el-color-primary);
}
.ai-item {
  background: #fafafa;
  border-radius: 6px;
  padding: 10px 12px;
  margin-bottom: 8px;
}
.ai-item-title {
  font-weight: 600;
  font-size: 13px;
  color: #303133;
  margin-bottom: 5px;
}
.ai-item-value {
  color: #f56c6c;
  margin-left: 8px;
}
.ai-item-ref {
  color: #909399;
  margin-left: 8px;
  font-weight: 400;
  font-size: 12px;
}
.ai-item-body {
  font-size: 13px;
  line-height: 1.75;
  color: #606266;
}
.ai-suggest {
  margin: 0;
  padding-left: 20px;
  font-size: 13px;
  line-height: 1.9;
  color: #606266;
}
.ai-meta {
  margin-top: 10px;
  font-size: 12px;
  color: #909399;
}
.ai-meta-sep {
  margin: 0 6px;
}
.student-card :deep(.el-card__body) {
  padding: 12px;
}
.student-list {
  max-height: 640px;
  overflow-y: auto;
}
.student-item {
  padding: 9px 10px;
  border-radius: 6px;
  cursor: pointer;
  margin-bottom: 4px;
}
.student-item:hover {
  background: #f5f7fa;
}
.student-item.active {
  background: var(--el-color-primary-light-9);
}
.student-name {
  font-weight: 600;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.student-no {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}
.metric-box {
  background: #f8f9fb;
  border-radius: 8px;
  padding: 12px 8px;
  text-align: center;
  margin-bottom: 8px;
}
.metric-label {
  font-size: 12px;
  color: #909399;
}
.metric-value {
  font-size: 22px;
  font-weight: 700;
  margin-top: 4px;
}
.metric-value.danger {
  color: var(--el-color-danger);
}
.metric-unit {
  font-size: 12px;
  font-weight: 400;
  color: #909399;
}
.metric-sub {
  font-size: 12px;
  margin-top: 2px;
  color: #67c23a;
}
.metric-sub:empty {
  display: none;
}
.latest-date {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
}
.trend-chart {
  height: 280px;
  width: 100%;
}
</style>

<style scoped>
.archive-summary {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 10px 12px;
  margin-bottom: 14px;
  background: #f5f7fa;
  border-radius: 4px;
  line-height: 1.7;
}
.archive-summary-text {
  flex: 1;
  color: #303133;
  font-size: 13px;
}
.archive-summary-meta {
  color: #909399;
  font-size: 12px;
  white-space: nowrap;
}
</style>
