<template>
  <div class="app-container" v-loading="loading">
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="AI 健康评估是辅助说明，不是诊断"
      description="系统先按体检项目的参考范围判断指标是否异常，再由大模型用通俗语言解释。报告不能代替医生的专业诊断，身体不适请及时就医。"
    />

    <!-- 概览 -->
    <div class="overview" v-if="list.length > 0">
      <div class="ov-item">
        <div class="ov-label">累计报告</div>
        <div class="ov-value">{{ list.length }}<span class="ov-unit">份</span></div>
      </div>
      <div class="ov-item">
        <div class="ov-label">待评估</div>
        <div class="ov-value ov-warn">{{ pendingCount }}<span class="ov-unit">份</span></div>
      </div>
      <div class="ov-item">
        <div class="ov-label">最近一次结论</div>
        <div class="ov-value">
          <el-tag v-if="latest" :type="riskType(latest.riskLevel)" effect="dark" size="large">
            {{ riskText(latest.riskLevel) }}
          </el-tag>
          <span v-else class="ov-muted">—</span>
        </div>
      </div>
    </div>

    <div class="report-grid" v-if="list.length > 0">
      <div
        v-for="row in list"
        :key="row.id"
        class="report-card"
        :class="{ clickable: row.assessStatus === '2' }"
        @click="row.assessStatus === '2' && handleView(row)"
      >
        <div class="rc-head">
          <span class="rc-date">{{ parseTime(row.examDate, '{y}-{m}-{d}') }} 体检</span>
          <dict-tag :options="ch_assess_status" :value="row.assessStatus || '2'" />
        </div>

        <div class="rc-body">
          <template v-if="row.assessStatus === '2'">
            <div class="rc-risk">
              <el-tag :type="riskType(row.riskLevel)" effect="dark">{{ riskText(row.riskLevel) }}</el-tag>
            </div>
            <div class="rc-summary">{{ row.assessmentResult || '（无摘要）' }}</div>
          </template>
          <template v-else-if="row.assessStatus === '1'">
            <div class="rc-hold">
              <el-icon class="is-loading"><Loading /></el-icon>
              校医正在生成评估报告，请稍后再来查看
            </div>
          </template>
          <template v-else>
            <div class="rc-hold">
              本次体检数据已登记，等待校医发起 AI 评估
            </div>
          </template>
        </div>

        <div class="rc-foot">
          <span class="rc-time">{{ row.assessStatus === '2' ? '生成于 ' + parseTime(row.updateTime || row.createTime, '{y}-{m}-{d}') : '' }}</span>
          <el-button v-if="row.assessStatus === '2'" link type="primary" icon="View" @click.stop="handleView(row)">
            查看报告
          </el-button>
        </div>
      </div>
    </div>

    <el-empty v-if="!loading && list.length === 0" description="还没有 AI 评估报告，完成体检后系统会自动生成" />

    <!-- 报告详情 -->
    <el-drawer v-model="open" title="我的 AI 健康评估报告" size="600px">
      <div v-if="current" class="report">
        <div class="report-head">
          <div class="report-title">{{ parseTime(current.examDate, '{y}-{m}-{d}') }} 体检</div>
          <el-tag :type="riskType(current.riskLevel)" effect="dark">{{ riskText(current.riskLevel) }}</el-tag>
        </div>

        <div class="section">
          <div class="section-title">总体结论</div>
          <div class="summary">{{ current.assessmentResult || '（无）' }}</div>
        </div>

        <div class="section">
          <div class="section-title">异常指标解释</div>
          <el-table v-if="abnormalItems.length" :data="abnormalItems" size="small" border>
            <el-table-column label="指标" prop="item" width="90" />
            <el-table-column label="实测值" prop="value" width="85" />
            <el-table-column label="参考范围" prop="reference" width="110" />
            <el-table-column label="解释" prop="explanation" min-width="190" />
          </el-table>
          <div v-else class="muted">本次未发现异常指标</div>
        </div>

        <div class="section">
          <div class="section-title">给你的建议</div>
          <ol v-if="suggestions.length" class="suggestions">
            <li v-for="(s, i) in suggestions" :key="i">{{ s }}</li>
          </ol>
          <div v-else class="muted">（无）</div>
        </div>

        <el-alert
          type="warning"
          :closable="false"
          show-icon
          class="notice"
          :title="current.remark || '本报告仅供健康管理参考，不能代替医生的专业诊断。'"
        />

        <div class="meta">报告生成模型：{{ current.modelName || '—' }}</div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup name="MyAiReport">
import { listMyAiAssessment } from '@/api/health/my'

const { ch_assess_status } = useDict('ch_assess_status')

const list = ref([])
const loading = ref(true)
const open = ref(false)
const current = ref(null)

const pendingCount = computed(() => list.value.filter(r => r.assessStatus !== '2').length)
const latest = computed(() => list.value.find(r => r.assessStatus === '2') || null)

const abnormalItems = computed(() => parseArray(current.value && current.value.abnormalItems))
const suggestions = computed(() => parseArray(current.value && current.value.suggestions))

function parseArray(text) {
  if (!text) return []
  try {
    const arr = JSON.parse(text)
    return Array.isArray(arr) ? arr : []
  } catch (e) {
    return []
  }
}

function riskText(level) {
  return ({ LOW: '低风险', MEDIUM: '中风险', HIGH: '高风险' })[level] || '—'
}

function riskType(level) {
  return ({ LOW: 'success', MEDIUM: 'warning', HIGH: 'danger' })[level] || 'info'
}

function getList() {
  loading.value = true
  listMyAiAssessment().then(res => {
    list.value = res.data || []
  }).finally(() => {
    loading.value = false
  })
}

function handleView(row) {
  current.value = row
  open.value = true
}

getList()
</script>

<style scoped>
.overview {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 16px;
}
.ov-item {
  flex: 1;
  min-width: 160px;
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  padding: 12px 16px;
}
.ov-label {
  font-size: 13px;
  color: #909399;
}
.ov-value {
  margin-top: 2px;
  font-size: 22px;
  font-weight: 600;
  color: #303133;
}
.ov-warn {
  color: #e6a23c;
}
.ov-unit {
  margin-left: 3px;
  font-size: 12px;
  font-weight: 400;
  color: #909399;
}
.ov-muted {
  color: #c0c4cc;
}

.report-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
  gap: 12px;
}
.report-card {
  display: flex;
  flex-direction: column;
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  padding: 14px 16px 10px;
  transition: all 0.2s;
}
.report-card.clickable {
  cursor: pointer;
}
.report-card.clickable:hover {
  border-color: #b3d8ff;
  box-shadow: 0 4px 14px rgba(64, 158, 255, 0.14);
  transform: translateY(-1px);
}
.rc-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.rc-date {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
}
.rc-body {
  flex: 1;
  padding: 10px 0;
}
.rc-risk {
  margin-bottom: 8px;
}
.rc-summary {
  font-size: 13px;
  line-height: 1.7;
  color: #606266;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.rc-hold {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: #909399;
  line-height: 1.7;
}
.rc-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 8px;
  border-top: 1px dashed #ebeef5;
  min-height: 30px;
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
  border-left: 3px solid var(--el-color-primary);
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
  margin-top: 18px;
}
.meta {
  margin-top: 10px;
  font-size: 12px;
  color: #909399;
}
.muted {
  color: #909399;
}
</style>
