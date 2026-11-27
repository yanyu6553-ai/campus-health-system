<template>
  <div class="app-container">
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="异常人数口径"
      description="BMI 达到超重/肥胖，或收缩压 ≥140、舒张压 ≥90 的学生数（按学生去重）。这是指标层面的提示，不是疾病诊断。"
    />

    <el-row :gutter="16" class="mb8">
      <el-col :xs="12" :sm="8">
        <div class="stat">
          <div class="stat-label">已体检学生</div>
          <div class="stat-value">{{ summary.examinedCount ?? 0 }}<span class="unit">人</span></div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="8">
        <div class="stat">
          <div class="stat-label">存在异常指标</div>
          <div class="stat-value danger">{{ summary.abnormalCount ?? 0 }}<span class="unit">人</span></div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="8">
        <div class="stat">
          <div class="stat-label">异常比例</div>
          <div class="stat-value warning">{{ abnormalRate }}<span class="unit">%</span></div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="16">
      <el-col :xs="24" :md="12">
        <el-card shadow="never" class="panel">
          <template #header><span class="panel-title">BMI 等级分布</span></template>
          <div ref="bmiChartRef" class="chart"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="12">
        <el-card shadow="never" class="panel">
          <template #header><span class="panel-title">分布明细</span></template>
          <el-table :data="bmiRows" size="small">
            <el-table-column label="BMI 等级" align="center" width="120">
              <template #default="scope">
                <dict-tag v-if="scope.row.level !== '9'" :options="ch_bmi_level" :value="scope.row.level" />
                <el-tag v-else type="info" size="small">未录入</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="人数" align="center" prop="num" width="90" />
            <el-table-column label="占比" align="center">
              <template #default="scope">{{ scope.row.percent }}%</template>
            </el-table-column>
            <el-table-column label="说明" prop="desc" min-width="180" show-overflow-tooltip />
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="HealthStatistics">
import * as echarts from 'echarts'
import { getDashboardSummary } from "@/api/health/dashboard"

const { ch_bmi_level } = useDict('ch_bmi_level')

const summary = ref({})
const bmiChartRef = ref(null)
let bmiChart = null

/** 字典里查不到时用兜底文案，避免图上出现空白 */
const LEVEL_DESC = {
  '0': 'BMI < 18.5，偏瘦',
  '1': '18.5 ~ 23.9，正常',
  '2': '24 ~ 27.9，超重',
  '3': '≥ 28，肥胖',
  '9': '本次未录入 BMI'
}

const LEVEL_NAME = {
  '0': '偏低',
  '1': '正常',
  '2': '超重',
  '3': '肥胖',
  '9': '未录入'
}

const bmiRows = computed(() => {
  const list = summary.value.bmiDistribution || []
  const totalNum = list.reduce((sum, it) => sum + Number(it.num || 0), 0)
  return list.map(it => {
    const level = String(it.bmiLevel)
    return {
      level,
      num: it.num,
      percent: totalNum === 0 ? 0 : Math.round(Number(it.num) * 1000 / totalNum) / 10,
      desc: LEVEL_DESC[level] || ''
    }
  })
})

const abnormalRate = computed(() => {
  const examined = Number(summary.value.examinedCount || 0)
  const abnormal = Number(summary.value.abnormalCount || 0)
  if (examined === 0) return 0
  return Math.round(abnormal * 1000 / examined) / 10
})

function renderChart() {
  if (!bmiChartRef.value) return
  if (!bmiChart) bmiChart = echarts.init(bmiChartRef.value)
  const colors = { '0': '#e6a23c', '1': '#67c23a', '2': '#409eff', '3': '#f56c6c', '9': '#c0c4cc' }
  const data = (summary.value.bmiDistribution || []).map(it => {
    const level = String(it.bmiLevel)
    return { value: it.num, name: LEVEL_NAME[level] || level, itemStyle: { color: colors[level] || '#909399' } }
  })
  bmiChart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}：{c} 人次（{d}%）' },
    legend: { bottom: 0 },
    series: [{
      type: 'pie',
      radius: '62%',
      itemStyle: { borderColor: '#fff', borderWidth: 2 },
      label: { formatter: '{b}\n{c}' },
      data
    }]
  })
}

function handleResize() {
  bmiChart && bmiChart.resize()
}

function loadData() {
  getDashboardSummary().then(response => {
    summary.value = response.data || {}
    renderChart()
  })
}

onMounted(() => {
  loadData()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  bmiChart && bmiChart.dispose()
  bmiChart = null
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
.stat-value.danger { color: #f56c6c; }
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
