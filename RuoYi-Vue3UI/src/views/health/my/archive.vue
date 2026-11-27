<template>
  <div class="app-container" v-loading="loading">
    <el-card shadow="never" class="mb8">
      <div class="profile">
        <div class="avatar">{{ (student.studentName || '?').slice(0, 1) }}</div>
        <div class="profile-main">
          <div class="profile-name">
            {{ student.studentName || '未绑定学生档案' }}
            <el-tag v-if="latest" :type="latest.abnormalFlag === '1' ? 'danger' : 'success'" size="small">
              {{ latest.abnormalFlag === '1' ? '本次体检存在异常指标' : '本次体检指标正常' }}
            </el-tag>
            <el-tag v-else type="info" size="small">尚无体检记录</el-tag>
          </div>
          <div class="profile-sub">
            <span>学号：{{ student.studentNo || '-' }}</span>
            <el-divider direction="vertical" />
            <span>{{ student.college || '-' }} · {{ student.major || '-' }} · {{ student.className || '-' }}</span>
            <el-divider direction="vertical" />
            <span>累计体检 {{ records.length }} 次</span>
          </div>
        </div>
      </div>
    </el-card>

    <el-row :gutter="16" v-if="latest">
      <el-col :xs="12" :sm="8" :md="4" v-for="item in metricCards" :key="item.label">
        <div class="metric">
          <div class="metric-label">{{ item.label }}</div>
          <div class="metric-value">
            {{ item.value }}<span class="metric-unit">{{ item.unit }}</span>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-card shadow="never" class="mb8 mt16">
      <template #header>
        <div class="card-head">
          <span>历年指标趋势</span>
          <span class="card-head-hint">按体检日期从早到晚</span>
        </div>
      </template>
      <div ref="trendRef" class="chart-box"></div>
    </el-card>

    <el-card shadow="never">
      <template #header>
        <div class="card-head">
          <span>历史体检记录</span>
          <span class="card-head-hint">共 {{ records.length }} 条</span>
        </div>
      </template>
      <el-table :data="records" size="small">
        <el-table-column label="体检日期" align="center" width="120">
          <template #default="scope">{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</template>
        </el-table-column>
        <el-table-column label="批次" prop="batchName" min-width="150" show-overflow-tooltip />
        <el-table-column label="身高(cm)" align="center" prop="height" width="90" />
        <el-table-column label="体重(kg)" align="center" prop="weight" width="90" />
        <el-table-column label="BMI" align="center" prop="bmi" width="80" />
        <el-table-column label="BMI等级" align="center" width="100">
          <template #default="scope">
            <dict-tag :options="ch_bmi_level" :value="scope.row.bmiLevel" />
          </template>
        </el-table-column>
        <el-table-column label="血压(mmHg)" align="center" width="120">
          <template #default="scope">{{ scope.row.systolicPressure }} / {{ scope.row.diastolicPressure }}</template>
        </el-table-column>
        <el-table-column label="视力(左/右)" align="center" width="110">
          <template #default="scope">{{ scope.row.visionLeft }} / {{ scope.row.visionRight }}</template>
        </el-table-column>
        <el-table-column label="结论" align="center" width="90">
          <template #default="scope">
            <el-tag v-if="scope.row.abnormalFlag === '1'" type="danger" size="small">异常</el-tag>
            <el-tag v-else type="success" size="small">正常</el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup name="MyArchive">
import * as echarts from 'echarts'
import { getMyArchive } from '@/api/health/my'

const { proxy } = getCurrentInstance()
const { ch_bmi_level } = useDict('ch_bmi_level')

const loading = ref(false)
const student = ref({})
const latest = ref(null)
const records = ref([])
const trendRef = ref(null)
let trendChart = null

/** 最新一次体检的关键指标卡片 */
const metricCards = computed(() => {
  const r = latest.value
  if (!r) return []
  return [
    { label: '身高', value: r.height ?? '-', unit: 'cm' },
    { label: '体重', value: r.weight ?? '-', unit: 'kg' },
    { label: 'BMI', value: r.bmi ?? '-', unit: '' },
    { label: '血压', value: `${r.systolicPressure ?? '-'}/${r.diastolicPressure ?? '-'}`, unit: 'mmHg' },
    { label: '心率', value: r.heartRate ?? '-', unit: '次/分' },
    { label: '视力(左/右)', value: `${r.visionLeft ?? '-'}/${r.visionRight ?? '-'}`, unit: '' }
  ]
})

function loadArchive() {
  loading.value = true
  getMyArchive().then(res => {
    const data = res.data || {}
    student.value = data.student || {}
    latest.value = data.latest || null
    records.value = data.records || []
    renderTrend()
  }).finally(() => {
    loading.value = false
  })
}

/** 趋势图：BMI 与体重两条线，直观看出变化 */
function renderTrend() {
  if (!trendRef.value) return
  if (!trendChart) trendChart = echarts.init(trendRef.value)

  const list = records.value || []
  const dates = list.map(r => proxy.parseTime(r.examDate, '{y}-{m}-{d}'))

  trendChart.setOption({
    tooltip: { trigger: 'axis' },
    legend: { bottom: 0, itemWidth: 12, itemHeight: 8 },
    grid: { left: 8, right: 20, top: 24, bottom: 44, containLabel: true },
    xAxis: { type: 'category', data: dates, boundaryGap: false },
    yAxis: [
      { type: 'value', name: 'BMI', splitLine: { lineStyle: { type: 'dashed' } } },
      { type: 'value', name: '体重(kg)', splitLine: { show: false } }
    ],
    series: [
      {
        name: 'BMI',
        type: 'line',
        smooth: true,
        symbolSize: 6,
        itemStyle: { color: '#378ADD' },
        areaStyle: { color: 'rgba(55,138,221,0.08)' },
        data: list.map(r => r.bmi)
      },
      {
        name: '体重(kg)',
        type: 'line',
        smooth: true,
        symbolSize: 6,
        yAxisIndex: 1,
        itemStyle: { color: '#EF9F27' },
        data: list.map(r => r.weight)
      }
    ]
  }, true)

  if (!dates.length) {
    trendChart.setOption({
      title: { text: '暂无体检数据', left: 'center', top: 'middle', textStyle: { fontSize: 13, color: '#999' } }
    })
  }
}

function handleResize() {
  trendChart && trendChart.resize()
}

onMounted(() => {
  loadArchive()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  trendChart && trendChart.dispose()
  trendChart = null
})
</script>

<style scoped>
.profile {
  display: flex;
  align-items: center;
  gap: 16px;
}

.avatar {
  width: 52px;
  height: 52px;
  border-radius: 50%;
  background: #e6f1fb;
  color: #185fa5;
  font-size: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.profile-name {
  font-size: 17px;
  font-weight: 500;
  color: var(--el-text-color-primary);
  display: flex;
  align-items: center;
  gap: 10px;
}

.profile-sub {
  font-size: 13px;
  color: var(--el-text-color-secondary);
  margin-top: 6px;
}

.metric {
  padding: 14px 16px;
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 10px;
  margin-bottom: 16px;
  background: var(--el-bg-color);
}

.metric-label {
  font-size: 12px;
  color: var(--el-text-color-secondary);
}

.metric-value {
  font-size: 20px;
  font-weight: 500;
  color: var(--el-text-color-primary);
  margin-top: 4px;
}

.metric-unit {
  font-size: 12px;
  font-weight: 400;
  color: var(--el-text-color-placeholder);
  margin-left: 3px;
}

.chart-box {
  width: 100%;
  height: 280px;
}

.card-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
}

.card-head-hint {
  font-size: 12px;
  color: var(--el-text-color-placeholder);
}

.mt16 {
  margin-top: 16px;
}
</style>
