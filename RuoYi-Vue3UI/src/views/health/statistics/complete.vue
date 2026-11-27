<template>
  <div class="app-container">
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="完成率口径"
      description="完成率 = 至少有一条体检记录的学生数 ÷ 在册学生数。一个学生做过多次体检只算「已完成」一次，所以分子按学生去重统计。"
    />

    <el-row :gutter="16" class="mb8">
      <el-col :xs="12" :sm="6" v-for="card in cards" :key="card.label">
        <div class="stat">
          <div class="stat-label">{{ card.label }}</div>
          <div class="stat-value" :class="card.tone">
            {{ card.value }}<span v-if="card.unit" class="unit">{{ card.unit }}</span>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="16">
      <el-col :xs="24" :md="10">
        <el-card shadow="never" class="panel">
          <template #header><span class="panel-title">体检完成情况</span></template>
          <div ref="rateChartRef" class="chart"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="14">
        <el-card shadow="never" class="panel">
          <template #header><span class="panel-title">各批次预约进度</span></template>
          <el-table :data="batchProgress" size="small">
            <el-table-column label="批次" prop="batchName" min-width="150" show-overflow-tooltip />
            <el-table-column label="状态" align="center" width="90">
              <template #default="scope">
                <dict-tag :options="ch_batch_status" :value="String(scope.row.status)" />
              </template>
            </el-table-column>
            <el-table-column label="已预约 / 上限" align="center" width="120">
              <template #default="scope">{{ scope.row.bookedCount }} / {{ scope.row.capacity }}</template>
            </el-table-column>
            <el-table-column label="进度" min-width="150">
              <template #default="scope">
                <el-progress
                  :percentage="percentOf(scope.row)"
                  :status="percentOf(scope.row) >= 100 ? 'exception' : ''"
                />
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="ExamComplete">
import * as echarts from 'echarts'
import { getDashboardSummary } from "@/api/health/dashboard"

const { ch_batch_status } = useDict('ch_batch_status')

const summary = ref({})
const batchProgress = ref([])
const rateChartRef = ref(null)
let rateChart = null

const cards = computed(() => [
  { label: "在册学生", value: summary.value.studentTotal ?? 0, unit: "人", tone: "" },
  { label: "已完成体检", value: summary.value.examinedCount ?? 0, unit: "人", tone: "success" },
  { label: "未完成体检", value: summary.value.notExaminedCount ?? 0, unit: "人", tone: "warning" },
  { label: "完成率", value: summary.value.completeRate ?? 0, unit: "%", tone: "primary" }
])

/** 预约进度：名额为 0 时给 0，避免除零 */
function percentOf(row) {
  const capacity = Number(row.capacity || 0)
  const booked = Number(row.bookedCount || 0)
  if (capacity <= 0) return 0
  return Math.min(Math.round(booked * 100 / capacity), 100)
}

function renderChart() {
  if (!rateChartRef.value) return
  if (!rateChart) rateChart = echarts.init(rateChartRef.value)
  const examined = summary.value.examinedCount || 0
  const notExamined = summary.value.notExaminedCount || 0
  rateChart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}：{c} 人（{d}%）' },
    legend: { bottom: 0 },
    series: [{
      type: 'pie',
      radius: ['48%', '70%'],
      avoidLabelOverlap: true,
      itemStyle: { borderColor: '#fff', borderWidth: 2 },
      label: { formatter: '{b}\n{c} 人' },
      data: [
        { value: examined, name: '已体检', itemStyle: { color: '#67c23a' } },
        { value: notExamined, name: '未体检', itemStyle: { color: '#e6a23c' } }
      ]
    }]
  })
}

function handleResize() {
  rateChart && rateChart.resize()
}

function loadData() {
  getDashboardSummary().then(response => {
    summary.value = response.data || {}
    batchProgress.value = response.data.batchProgress || []
    renderChart()
  })
}

onMounted(() => {
  loadData()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  rateChart && rateChart.dispose()
  rateChart = null
})
</script>

<style scoped>
.stat {
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 6px;
  padding: 16px 18px;
  margin-bottom: 8px;
}
.stat-label {
  color: #909399;
  font-size: 13px;
}
.stat-value {
  font-size: 26px;
  font-weight: 600;
  margin-top: 6px;
  color: #303133;
}
.stat-value.primary { color: #409eff; }
.stat-value.success { color: #67c23a; }
.stat-value.warning { color: #e6a23c; }
.unit {
  font-size: 14px;
  font-weight: 400;
  margin-left: 4px;
  color: #909399;
}
.panel {
  margin-bottom: 16px;
}
.panel-title {
  font-weight: 600;
}
.chart {
  height: 320px;
}
</style>
