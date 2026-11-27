<template>
  <div class="app-container">
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="评估任务台"
      description="每登记一条体检记录都会自动生成一条「待评估」任务。在这里查看评估进度、对待评估的记录发起大模型分析；已生成的报告可在「AI评估报告」中按风险等级阅览。"
    />

    <!-- 评估进度：点一下按状态筛选 -->
    <div class="status-bar mb8">
      <div
        v-for="tab in statusTabs"
        :key="tab.label"
        class="status-tab"
        :class="{ active: queryParams.assessStatus === tab.value }"
        @click="filterByStatus(tab.value)"
      >
        <span class="status-dot" :class="tab.cls"></span>
        <span class="status-label">{{ tab.label }}</span>
        <span class="status-count">{{ tab.count }}</span>
      </div>
    </div>

    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="学生姓名" prop="studentName">
        <el-input
          v-model="queryParams.studentName"
          placeholder="请输入学生姓名"
          clearable
          style="width: 180px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="风险等级" prop="riskLevel">
        <el-select v-model="queryParams.riskLevel" placeholder="全部" clearable style="width: 140px">
          <el-option label="低风险" value="LOW" />
          <el-option label="中风险" value="MEDIUM" />
          <el-option label="高风险" value="HIGH" />
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

    <el-table v-loading="loading" :data="aiList">
      <el-table-column label="学生" align="center" width="180">
        <template #default="scope">
          <span>{{ scope.row.studentNo }}</span>
          <span style="margin-left: 6px; font-weight: 600">{{ scope.row.studentName || '-' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="体检日期" align="center" width="110">
        <template #default="scope">
          <span>{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="评估状态" align="center" width="100">
        <template #default="scope">
          <dict-tag :options="ch_assess_status" :value="scope.row.assessStatus || '2'" />
        </template>
      </el-table-column>
      <el-table-column label="风险等级" align="center" width="110">
        <template #default="scope">
          <el-tag :type="riskType(scope.row.riskLevel)" effect="dark">
            {{ riskText(scope.row.riskLevel) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="评估摘要" align="left" min-width="280">
        <template #default="scope">
          <span v-if="scope.row.assessmentResult" class="ellipsis" :title="scope.row.assessmentResult">
            {{ scope.row.assessmentResult }}
          </span>
          <span v-else class="muted">{{ scope.row.assessStatus === '1' ? '模型分析中…' : '尚未生成' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="模型" align="center" width="180">
        <template #default="scope">
          <span v-if="scope.row.modelName">{{ scope.row.modelName }}</span>
          <span v-else class="muted">—</span>
        </template>
      </el-table-column>
      <el-table-column label="生成时间" align="center" width="165">
        <template #default="scope">
          <span>{{ parseTime(scope.row.updateTime || scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button v-if="scope.row.assessStatus === '2'" link type="primary" @click="handleView(scope.row)">查看报告</el-button>
          <el-button v-else-if="scope.row.assessStatus === '0'" link type="primary" @click="handleAssess(scope.row)">生成评估</el-button>
          <el-button v-else link type="info" disabled>评估中…</el-button>
          <el-button link type="danger" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 报告详情 -->
    <el-dialog v-model="viewVisible" title="AI 健康评估报告" width="720px" append-to-body>
      <template v-if="current">
        <div class="ai-head">
          <el-tag :type="riskType(current.riskLevel)" size="large" effect="dark">
            {{ riskText(current.riskLevel) }}
          </el-tag>
          <span class="ai-summary">{{ current.assessmentResult }}</span>
        </div>

        <template v-if="currentAbnormal.length > 0">
          <div class="ai-section-title">异常指标解释</div>
          <div class="ai-item" v-for="(it, idx) in currentAbnormal" :key="idx">
            <div class="ai-item-title">
              {{ it.item }}
              <span class="ai-item-value">{{ it.value }}</span>
              <span class="ai-item-ref">参考 {{ it.reference }}</span>
            </div>
            <div class="ai-item-body">{{ it.explanation }}</div>
          </div>
        </template>

        <template v-if="currentSuggest.length > 0">
          <div class="ai-section-title">健康建议</div>
          <ol class="ai-suggest">
            <li v-for="(s, idx) in currentSuggest" :key="idx">{{ s }}</li>
          </ol>
        </template>

        <el-alert
          type="warning"
          :closable="false"
          show-icon
          style="margin-top: 14px"
          :title="current.remark || '本报告仅供健康管理参考，不能代替医生的专业诊断'"
        />
        <div class="ai-meta">
          学生：{{ current.studentNo }} {{ current.studentName }}
          <span class="ai-meta-sep">|</span>
          体检日期：{{ parseTime(current.examDate, '{y}-{m}-{d}') }}
          <span class="ai-meta-sep">|</span>
          模型：{{ current.modelName || '-' }}
        </div>
      </template>
      <template #footer>
        <el-button @click="viewVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="AiAssessment">
import { listAiAssessment, delAiAssessment, assessHealth } from "@/api/health/ai"

const { proxy } = getCurrentInstance()

const aiList = ref([])
const { ch_assess_status } = useDict('ch_assess_status')
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)
const viewVisible = ref(false)
const current = ref(null)

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    studentName: undefined,
    riskLevel: undefined
  }
})
const { queryParams } = toRefs(data)

/** 各评估状态的条数，用于顶部进度条 */
const counts = reactive({ all: 0, '0': 0, '1': 0, '2': 0 })
const statusTabs = computed(() => [
  { label: '全部', value: undefined, count: counts.all, cls: 'd-all' },
  { label: '待评估', value: '0', count: counts['0'], cls: 'd-wait' },
  { label: '评估中', value: '1', count: counts['1'], cls: 'd-doing' },
  { label: '已完成', value: '2', count: counts['2'], cls: 'd-done' }
])

const currentAbnormal = computed(() => {
  try { return JSON.parse(current.value?.abnormalItems || "[]") } catch (e) { return [] }
})
const currentSuggest = computed(() => {
  try { return JSON.parse(current.value?.suggestions || "[]") } catch (e) { return [] }
})

function riskText(level) {
  return ({ LOW: "低风险", MEDIUM: "中风险", HIGH: "高风险" })[level] || "-"
}
function riskType(level) {
  return ({ LOW: "success", MEDIUM: "warning", HIGH: "danger" })[level] || "info"
}

function getList() {
  loading.value = true
  listAiAssessment(queryParams.value).then(res => {
    aiList.value = res.rows || []
    total.value = res.total || 0
  }).finally(() => { loading.value = false })
}

/** 四个状态各取一次 total（pageSize=1），拼接出顶部进度 */
function getCounts() {
  const base = { pageNum: 1, pageSize: 1, studentName: queryParams.value.studentName, riskLevel: queryParams.value.riskLevel }
  const tasks = [
    listAiAssessment({ ...base }).then(r => { counts.all = r.total || 0 }),
    listAiAssessment({ ...base, assessStatus: '0' }).then(r => { counts['0'] = r.total || 0 }),
    listAiAssessment({ ...base, assessStatus: '1' }).then(r => { counts['1'] = r.total || 0 }),
    listAiAssessment({ ...base, assessStatus: '2' }).then(r => { counts['2'] = r.total || 0 })
  ]
  Promise.all(tasks).catch(() => {})
}

function filterByStatus(status) {
  queryParams.value.assessStatus = status
  queryParams.value.pageNum = 1
  getList()
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
  getCounts()
}

function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

/** 对待评估的记录发起一次模型调用 */
function handleAssess(row) {
  proxy.$modal.confirm('将对这条体检记录生成 AI 健康评估，需要数秒到数十秒，是否继续？').then(() => {
    loading.value = true
    return assessHealth(row.examRecordId)
  }).then(() => {
    proxy.$modal.msgSuccess("评估已生成")
    getList()
    getCounts()
  }).catch(() => {}).finally(() => {
    loading.value = false
  })
}

function handleView(row) {
  current.value = row
  viewVisible.value = true
}

function handleDelete(row) {
  proxy.$modal.confirm('确认删除该条 AI 评估记录吗？').then(() => {
    return delAiAssessment(row.id)
  }).then(() => {
    getList()
    getCounts()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

getList()
getCounts()
</script>

<style scoped>
.status-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}
.status-tab {
  display: flex;
  align-items: center;
  gap: 6px;
  min-width: 132px;
  padding: 9px 14px;
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
}
.status-tab:hover {
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
}
.status-tab.active {
  border-color: #409eff;
  background: #f2f8ff;
}
.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  display: inline-block;
}
.d-all { background: #409eff; }
.d-wait { background: #909399; }
.d-doing { background: #e6a23c; }
.d-done { background: #67c23a; }
.status-label {
  font-size: 13px;
  color: #606266;
}
.status-count {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin-left: auto;
}
.ellipsis {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.muted {
  color: #c0c4cc;
}

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
</style>
