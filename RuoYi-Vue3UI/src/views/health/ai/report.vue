<template>
  <div class="app-container">
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="AI 报告是「辅助说明」，不是诊断"
      description="系统先按体检项目的参考范围判定异常并给出风险等级，再把脱敏后的指标交给大模型解释。报告里不含姓名、学号，大模型也不会判断学生是否患病。"
    />

    <!-- 报告概览：按风险等级分组，点卡片直接筛选 -->
    <el-row :gutter="12" class="mb8">
      <el-col :xs="12" :sm="6" v-for="card in statCards" :key="card.key">
        <div
          class="stat-card"
          :class="[card.cls, { active: queryParams.riskLevel === card.key }]"
          @click="filterByRisk(card.key)"
        >
          <div class="stat-label">{{ card.label }}</div>
          <div class="stat-value">
            {{ card.value }}<span class="stat-unit">份</span>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="学生姓名" prop="studentName">
        <el-input v-model="queryParams.studentName" placeholder="支持模糊查询" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="学号" prop="studentNo">
        <el-input v-model="queryParams.studentNo" placeholder="支持模糊查询" clearable style="width: 160px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="风险等级" prop="riskLevel">
        <el-select v-model="queryParams.riskLevel" placeholder="全部" clearable style="width: 140px">
          <el-option v-for="dict in ch_risk_level" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 报告卡片流 -->
    <div v-loading="loading" class="report-grid">
      <div v-for="row in reportList" :key="row.id" class="report-card" @click="handleView(row)">
        <div class="rc-head">
          <span class="rc-name">{{ row.studentName || '—' }}</span>
          <span class="rc-no">{{ row.studentNo }}</span>
          <dict-tag :options="ch_risk_level" :value="row.riskLevel" />
        </div>
        <div class="rc-meta">
          <span>体检日期 {{ parseTime(row.examDate, '{y}-{m}-{d}') }}</span>
        </div>
        <div class="rc-summary">{{ row.assessmentResult || '（无摘要）' }}</div>
        <div class="rc-foot">
          <span class="rc-time">生成于 {{ parseTime(row.updateTime || row.createTime, '{y}-{m}-{d} {h}:{i}') }}</span>
          <el-button link type="primary" icon="View" @click.stop="handleView(row)">查看报告</el-button>
        </div>
      </div>
      <div v-if="!loading && reportList.length === 0" class="grid-empty">
        <el-empty description="暂无已生成的评估报告" />
      </div>
    </div>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 报告详情 -->
    <el-drawer v-model="open" title="AI 健康评估报告" size="640px">
      <div v-if="report" class="report">
        <div class="report-head">
          <div class="report-title">{{ report.studentName }} · {{ parseTime(report.examDate, '{y}-{m}-{d}') }}</div>
          <dict-tag :options="ch_risk_level" :value="report.riskLevel" />
        </div>

        <div class="section">
          <div class="section-title">总体结论</div>
          <div class="summary">{{ report.assessmentResult || '（无）' }}</div>
        </div>

        <div class="section">
          <div class="section-title">异常指标解释</div>
          <el-table v-if="abnormalItems.length" :data="abnormalItems" size="small" border>
            <el-table-column label="指标" prop="item" width="100" />
            <el-table-column label="实测值" prop="value" width="90" />
            <el-table-column label="参考范围" prop="reference" width="120" />
            <el-table-column label="解释" prop="explanation" min-width="200" />
          </el-table>
          <div v-else class="muted">本次未发现异常指标</div>
        </div>

        <div class="section">
          <div class="section-title">健康建议</div>
          <ul v-if="suggestions.length" class="suggestions">
            <li v-for="(s, i) in suggestions" :key="i">{{ s }}</li>
          </ul>
          <div v-else class="muted">（无）</div>
        </div>

        <div class="section">
          <div class="section-title">说明</div>
          <div class="notice">{{ report.remark || '本报告仅供健康管理参考，不能代替医生的专业诊断。' }}</div>
          <div class="meta">
            生成模型：{{ report.modelName || '—' }}<br />
            生成时间：{{ parseTime(report.updateTime || report.createTime) }}
          </div>
        </div>

        <div class="report-actions">
          <el-button type="primary" icon="Printer" @click="handlePrint">打印 / 另存为 PDF</el-button>
          <el-button icon="Close" @click="open = false">关闭</el-button>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup name="AiReport">
import { listAiAssessment, getAiAssessment } from "@/api/health/ai"

const { proxy } = getCurrentInstance()
const { ch_risk_level } = useDict('ch_risk_level')

const reportList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)
const open = ref(false)
const report = ref(null)
/** 各风险等级的报告份数（total 用于「已生成报告」总数，不随筛选变化） */
const stats = reactive({ total: 0, LOW: 0, MEDIUM: 0, HIGH: 0 })

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 12,
    studentName: undefined,
    studentNo: undefined,
    riskLevel: undefined,
    // 报告页只看「已生成」，待评估/评估中的任务在「AI健康评估」里处理
    assessStatus: '2'
  }
})

const { queryParams } = toRefs(data)

const statCards = computed(() => [
  { key: undefined, label: '已生成报告', value: stats.total, cls: 'c-total' },
  { key: 'LOW', label: '低风险', value: stats.LOW, cls: 'c-low' },
  { key: 'MEDIUM', label: '中风险', value: stats.MEDIUM, cls: 'c-medium' },
  { key: 'HIGH', label: '高风险', value: stats.HIGH, cls: 'c-high' }
])

const abnormalItems = computed(() => parseArray(report.value && report.value.abnormalItems))
const suggestions = computed(() => parseArray(report.value && report.value.suggestions))

function parseArray(text) {
  if (!text) return []
  try {
    const arr = JSON.parse(text)
    return Array.isArray(arr) ? arr : []
  } catch (e) {
    return []
  }
}

function getList() {
  loading.value = true
  listAiAssessment(queryParams.value).then(response => {
    reportList.value = response.rows
    total.value = response.total
  }).finally(() => {
    loading.value = false
  })
}

/** 各风险的份数：并行取四次分页只拿 total */
function getStats() {
  const base = { pageNum: 1, pageSize: 1, assessStatus: '2' }
  listAiAssessment({ ...base }).then(r => { stats.total = r.total || 0 }).catch(() => {})
  const levels = ['LOW', 'MEDIUM', 'HIGH']
  Promise.all(levels.map(level => listAiAssessment({ ...base, riskLevel: level }).catch(() => ({ total: 0 }))))
    .then(res => {
      levels.forEach((level, i) => { stats[level] = res[i].total || 0 })
    })
}

function filterByRisk(key) {
  queryParams.value.riskLevel = key
  queryParams.value.pageNum = 1
  getList()
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm("queryRef")
  queryParams.value.riskLevel = undefined
  handleQuery()
}

function handleView(row) {
  getAiAssessment(row.id).then(response => {
    report.value = response.data
    open.value = true
  })
}

function esc(text) {
  return String(text == null ? '' : text)
    .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

/** 打印：单独开一个窗口，只保留报告正文，避免把菜单和侧边栏打出来 */
function handlePrint() {
  const r = report.value
  if (!r) return
  const riskText = ({ LOW: '低风险', MEDIUM: '中风险', HIGH: '高风险' })[r.riskLevel] || '—'
  const rows = abnormalItems.value.map(it => `
    <tr>
      <td>${esc(it.item)}</td><td>${esc(it.value)}</td><td>${esc(it.reference)}</td><td>${esc(it.explanation)}</td>
    </tr>`).join('')
  const list = suggestions.value.map(s => `<li>${esc(s)}</li>`).join('')
  const html = `<!DOCTYPE html><html><head><meta charset="utf-8"><title>AI健康评估报告</title>
  <style>
    body{font-family:"Microsoft YaHei",sans-serif;color:#303133;padding:32px 40px;line-height:1.7}
    h1{font-size:20px;margin:0 0 6px}
    .sub{color:#909399;font-size:13px;margin-bottom:20px}
    h2{font-size:15px;margin:22px 0 8px;padding-left:8px;border-left:3px solid #409eff}
    table{width:100%;border-collapse:collapse;font-size:13px}
    th,td{border:1px solid #dcdfe6;padding:6px 8px;text-align:left}
    th{background:#f5f7fa}
    .notice{background:#fdf6ec;color:#b88230;padding:10px 12px;font-size:13px;border-radius:4px}
    .foot{margin-top:24px;color:#909399;font-size:12px}
  </style></head><body>
  <h1>AI 健康评估报告</h1>
  <div class="sub">${esc(r.studentName)}（${esc(r.studentNo)}）· 体检日期 ${proxy.parseTime(r.examDate, '{y}-{m}-{d}')} · 风险等级 ${riskText}</div>
  <h2>总体结论</h2><p>${esc(r.assessmentResult || '（无）')}</p>
  <h2>异常指标解释</h2>
  ${rows ? `<table><thead><tr><th>指标</th><th>实测值</th><th>参考范围</th><th>解释</th></tr></thead><tbody>${rows}</tbody></table>` : '<p>本次未发现异常指标</p>'}
  <h2>健康建议</h2>${list ? `<ol>${list}</ol>` : '<p>（无）</p>'}
  <h2>说明</h2>
  <div class="notice">${esc(r.remark || '本报告仅供健康管理参考，不能代替医生的专业诊断。')}</div>
  <div class="foot">生成模型：${esc(r.modelName || '—')}　生成时间：${proxy.parseTime(r.updateTime || r.createTime)}</div>
  </body></html>`
  const win = window.open('', '_blank', 'width=900,height=1000')
  if (!win) {
    proxy.$modal.msgWarning('浏览器拦截了新窗口，请允许弹出窗口后重试')
    return
  }
  win.document.write(html)
  win.document.close()
  win.focus()
  setTimeout(() => win.print(), 300)
}

getList()
getStats()
</script>

<style scoped>
.stat-card {
  cursor: pointer;
  border: 1px solid #ebeef5;
  border-left-width: 4px;
  border-radius: 6px;
  padding: 12px 16px;
  background: #fff;
  transition: all 0.2s;
  margin-bottom: 8px;
}
.stat-card:hover {
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
}
.stat-card.active {
  border-color: #409eff;
  background: #f2f8ff;
}
.stat-label {
  font-size: 13px;
  color: #909399;
}
.stat-value {
  margin-top: 4px;
  font-size: 24px;
  font-weight: 600;
  color: #303133;
}
.stat-unit {
  margin-left: 3px;
  font-size: 12px;
  font-weight: 400;
  color: #909399;
}
.c-total { border-left-color: #409eff; }
.c-low { border-left-color: #67c23a; }
.c-medium { border-left-color: #e6a23c; }
.c-high { border-left-color: #f56c6c; }
.c-low .stat-value { color: #67c23a; }
.c-medium .stat-value { color: #e6a23c; }
.c-high .stat-value { color: #f56c6c; }

.report-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(330px, 1fr));
  gap: 12px;
  min-height: 120px;
}
.grid-empty {
  grid-column: 1 / -1;
}
.report-card {
  border: 1px solid #ebeef5;
  border-radius: 8px;
  padding: 14px 16px 10px;
  background: #fff;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  flex-direction: column;
}
.report-card:hover {
  border-color: #b3d8ff;
  box-shadow: 0 4px 14px rgba(64, 158, 255, 0.14);
  transform: translateY(-1px);
}
.rc-head {
  display: flex;
  align-items: center;
  gap: 8px;
}
.rc-name {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
}
.rc-no {
  font-size: 12px;
  color: #909399;
  flex: 1;
}
.rc-meta {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-top: 8px;
  font-size: 12px;
  color: #909399;
}
.rc-summary {
  margin-top: 8px;
  font-size: 13px;
  line-height: 1.65;
  color: #606266;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  min-height: 64px;
}
.rc-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 10px;
  padding-top: 8px;
  border-top: 1px dashed #ebeef5;
}
.rc-time {
  font-size: 12px;
  color: #c0c4cc;
}

.report-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-bottom: 12px;
  border-bottom: 1px solid #ebeef5;
}
.report-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}
.section {
  margin-top: 18px;
}
.section-title {
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
  padding-left: 8px;
  border-left: 3px solid #409eff;
}
.summary {
  background: #f5f7fa;
  border-radius: 4px;
  padding: 12px;
  line-height: 1.7;
  color: #303133;
}
.suggestions {
  margin: 0;
  padding-left: 20px;
  line-height: 1.9;
  color: #303133;
}
.notice {
  color: #e6a23c;
  background: #fdf6ec;
  border-radius: 4px;
  padding: 10px 12px;
  line-height: 1.6;
}
.meta {
  margin-top: 10px;
  color: #909399;
  font-size: 12px;
  line-height: 1.8;
}
.muted {
  color: #909399;
}
.report-actions {
  margin-top: 24px;
  padding-top: 14px;
  border-top: 1px solid #ebeef5;
  text-align: right;
}
</style>
