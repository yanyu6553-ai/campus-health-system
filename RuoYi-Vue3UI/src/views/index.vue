<template>
  <div class="app-container dashboard">
    <div class="page-head">
      <div>
        <div class="page-title">{{ isSelf ? '我的健康概览' : '校园学生体检与健康档案管理系统' }}</div>
        <div class="page-sub">
          {{ isSelf ? '只显示你本人的体检与预约数据' : '数据概览' }} · {{ today }}
        </div>
      </div>
      <el-button icon="Refresh" @click="loadData">刷新数据</el-button>
    </div>

    <!-- ============ 学生视角：只有自己的数据，看不到全校统计 ============ -->
    <template v-if="isSelf">
      <el-card shadow="never" class="self-head">
        <div class="self-profile">
          <div class="avatar">{{ (self.student.studentName || '?').slice(0, 1) }}</div>
          <div>
            <div class="self-name">
              {{ self.student.studentName || '未绑定学生档案' }}
              <el-tag v-if="self.latest" :type="self.latest.abnormalFlag === '1' ? 'danger' : 'success'" size="small">
                {{ self.latest.abnormalFlag === '1' ? '最近一次体检存在异常指标' : '最近一次体检指标正常' }}
              </el-tag>
              <el-tag v-else type="info" size="small">尚未体检</el-tag>
            </div>
            <div class="self-sub">
              学号 {{ self.student.studentNo || '-' }} · {{ self.student.className || '-' }}
              · 最近体检 {{ self.latest ? parseTime(self.latest.examDate, '{y}-{m}-{d}') : '暂无' }}
            </div>
          </div>
        </div>
      </el-card>

      <el-row :gutter="16" class="card-row">
        <el-col :xs="12" :sm="8" v-for="card in selfCards" :key="card.key">
          <div class="stat-card" :class="card.tone">
            <div class="stat-icon">
              <el-icon :size="22"><component :is="card.icon" /></el-icon>
            </div>
            <div class="stat-body">
              <div class="stat-label">{{ card.label }}</div>
              <div class="stat-value">{{ card.value }}<span v-if="card.unit" class="stat-unit">{{ card.unit }}</span></div>
              <div class="stat-hint">{{ card.hint }}</div>
            </div>
          </div>
        </el-col>
      </el-row>

      <el-row :gutter="16">
        <el-col :xs="24" :md="10">
          <el-card shadow="never" class="chart-card">
            <template #header>
              <div class="card-head"><span>最近一次体检指标</span></div>
            </template>
            <div v-if="self.latest" class="self-metrics">
              <div class="self-metric" v-for="m in selfMetrics" :key="m.label">
                <div class="self-metric-label">{{ m.label }}</div>
                <div class="self-metric-value">{{ m.value }}<span class="self-metric-unit">{{ m.unit }}</span></div>
              </div>
            </div>
            <el-empty v-else description="还没有体检数据" />
          </el-card>
        </el-col>
        <el-col :xs="24" :md="14">
          <el-card shadow="never" class="chart-card">
            <template #header>
              <div class="card-head">
                <span>我的预约</span>
                <el-link type="primary" :underline="false" @click="goMyAppointment">去预约 / 查看</el-link>
              </div>
            </template>
            <el-table :data="self.appointments" size="small">
              <el-table-column label="体检批次" prop="batchName" min-width="150" show-overflow-tooltip />
              <el-table-column label="体检日期" width="110" align="center">
                <template #default="scope">{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</template>
              </el-table-column>
              <el-table-column label="状态" width="100" align="center">
                <template #default="scope">
                  <dict-tag :options="ch_appoint_status" :value="scope.row.status" />
                </template>
              </el-table-column>
              <template #empty>
                <span class="text-muted">还没有预约记录</span>
              </template>
            </el-table>
          </el-card>
        </el-col>
      </el-row>
    </template>

    <!-- ============ 管理视角：全校数据 ============ -->
    <template v-else>
    <!-- 文档 2.1 要 5 张卡，用 CSS grid 均分，比 el-col 的 24 栅格除不尽更好控制 -->
    <div class="stat-grid">
      <div class="stat-card" :class="card.tone" v-for="card in cards" :key="card.key">
        <div class="stat-icon">
          <el-icon :size="22"><component :is="card.icon" /></el-icon>
        </div>
        <div class="stat-body">
          <div class="stat-label">{{ card.label }}</div>
          <div class="stat-value">
            {{ card.value }}<span v-if="card.unit" class="stat-unit">{{ card.unit }}</span>
          </div>
          <div class="stat-hint">{{ card.hint }}</div>
        </div>
      </div>
    </div>

    <el-row :gutter="16">
      <el-col :xs="24" :md="14">
        <el-card shadow="never" class="chart-card">
          <template #header>
            <div class="card-head">
              <span>体检项目分布</span>
              <span class="card-head-hint">各项目判定为异常的学生人数（去重）</span>
            </div>
          </template>
          <div ref="itemChartRef" class="chart-box"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="10">
        <el-card shadow="never" class="chart-card">
          <template #header>
            <div class="card-head">
              <span>BMI 等级分布</span>
              <span class="card-head-hint">共 {{ bmiTotal }} 份体检记录</span>
            </div>
          </template>
          <div ref="bmiChartRef" class="chart-box"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-card shadow="never" class="chart-card">
      <template #header>
        <div class="card-head">
          <span>各批次预约进度</span>
          <span class="card-head-hint">已预约 / 名额上限</span>
        </div>
      </template>
      <div ref="batchChartRef" class="chart-box chart-box-tall"></div>
    </el-card>

    <el-card shadow="never" class="table-card">
      <template #header>
        <div class="card-head">
          <span>最近预约记录</span>
          <el-link type="primary" :underline="false" @click="goAppointment">查看全部</el-link>
        </div>
      </template>
      <el-table :data="recentAppointments" size="small">
        <el-table-column label="学号" prop="studentNo" width="120" />
        <el-table-column label="学生姓名" prop="studentName" width="110" />
        <el-table-column label="体检批次" prop="batchName" show-overflow-tooltip />
        <el-table-column label="提交时间" width="170">
          <template #default="scope">{{ parseTime(scope.row.appointmentTime) }}</template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="scope">
            <dict-tag :options="ch_appoint_status" :value="scope.row.status" />
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    </template>
  </div>
</template>

<script setup name="Index">
import * as echarts from 'echarts'
import { getDashboardSummary } from '@/api/health/dashboard'
import { useRouter } from 'vue-router'

const { proxy } = getCurrentInstance()
const router = useRouter()
const { ch_appoint_status, ch_bmi_level } = useDict('ch_appoint_status', 'ch_bmi_level')

const bmiChartRef = ref(null)
const itemChartRef = ref(null)
const batchChartRef = ref(null)
let bmiChart = null
let itemChart = null
let batchChart = null

const today = new Date().toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })

const summary = reactive({
  scope: 'admin',
  studentTotal: 0,
  examinedCount: 0,
  notExaminedCount: 0,
  pendingAuditCount: 0,
  todayAppointmentCount: 0,
  approvedCount: 0,
  abnormalCount: 0,
  completeRate: 0,
  bmiDistribution: [],
  itemAbnormal: [],
  batchProgress: [],
  recentAppointments: []
})

/** 学生视角的专属数据：由后端返回 scope=self 时填充 */
const self = reactive({
  student: {},
  latest: null,
  records: [],
  appointments: [],
  examCount: 0,
  todoCount: 0
})

const isSelf = computed(() => summary.scope === 'self')

/** 学生的三个卡片：体检次数、待办预约、异常状态 */
const selfCards = computed(() => [
  {
    key: 'examCount',
    label: '累计体检',
    value: self.examCount,
    unit: '次',
    hint: self.latest ? `最近 ${proxy.parseTime(self.latest.examDate, '{y}-{m}-{d}')}` : '还没有体检记录',
    icon: 'Document',
    tone: 'tone-blue'
  },
  {
    key: 'todo',
    label: '进行中的预约',
    value: self.todoCount,
    unit: '条',
    hint: self.todoCount > 0 ? '待审核或待体检' : '暂无待办',
    icon: 'Clock',
    tone: 'tone-amber'
  },
  {
    key: 'abnormal',
    label: '最近体检结论',
    value: self.latest ? (self.latest.abnormalFlag === '1' ? '异常' : '正常') : '—',
    unit: '',
    hint: '按体检项目参考范围自动判定',
    icon: 'Warning',
    tone: self.latest && self.latest.abnormalFlag === '1' ? 'tone-red' : 'tone-green'
  }
])

/** 最近一次体检的六项指标 */
const selfMetrics = computed(() => {
  const r = self.latest
  if (!r) return []
  return [
    { label: '身高', value: r.height ?? '-', unit: 'cm' },
    { label: '体重', value: r.weight ?? '-', unit: 'kg' },
    { label: 'BMI', value: r.bmi ?? '-', unit: '' },
    { label: '血压', value: `${r.systolicPressure ?? '-'}/${r.diastolicPressure ?? '-'}`, unit: 'mmHg' },
    { label: '心率', value: r.heartRate ?? '-', unit: '次/分' },
    { label: '视力', value: `${r.visionLeft ?? '-'}/${r.visionRight ?? '-'}`, unit: '' }
  ]
})

const recentAppointments = computed(() => summary.recentAppointments || [])

const bmiTotal = computed(() =>
  (summary.bmiDistribution || []).reduce((sum, item) => sum + Number(item.num || 0), 0)
)

/** 统计卡片：数据一变，卡片跟着变；顺序对齐设计文档 2.1 的 8 项指标 */
const cards = computed(() => [
  {
    key: 'student',
    label: '学生总数',
    value: summary.studentTotal,
    unit: '人',
    hint: '状态为「正常」的在册学生',
    icon: 'User',
    tone: 'tone-blue'
  },
  {
    key: 'examined',
    label: '已完成体检',
    value: summary.examinedCount,
    unit: '人',
    hint: `完成率 ${summary.completeRate}%`,
    icon: 'CircleCheck',
    tone: 'tone-green'
  },
  {
    key: 'notExamined',
    label: '未完成体检',
    value: summary.notExaminedCount,
    unit: '人',
    // 独立成卡而不是塞进别人的副标题：这是校医下一步要催的对象，得一眼看到
    hint: '还没提交体检记录的学生',
    icon: 'Clock',
    tone: 'tone-gray'
  },
  {
    key: 'today',
    label: '今日预约',
    value: summary.todayAppointmentCount,
    unit: '人',
    // 待审核数放在提示里：操作上最需要盯的就是它，但首页主数字按文档给"今日预约"
    hint: `待审核 ${summary.pendingAuditCount} 条 · 已通过 ${summary.approvedCount} 条`,
    icon: 'Calendar',
    tone: 'tone-amber'
  },
  {
    key: 'abnormal',
    label: '异常指标人数',
    value: summary.abnormalCount,
    unit: '人',
    hint: 'BMI 超标或血压偏高',
    icon: 'Warning',
    tone: 'tone-red'
  }
])

/** 拉取看板数据：后端按角色决定返回全校数据还是仅本人数据 */
function loadData() {
  getDashboardSummary().then(res => {
    Object.assign(summary, res.data || {})
    if (summary.scope === 'self') {
      // 学生视角：填个人数据，不画全校图表
      self.student = summary.student || {}
      self.latest = summary.latest || null
      self.records = summary.records || []
      self.appointments = summary.appointments || []
      self.examCount = summary.examCount || 0
      self.todoCount = summary.todoCount || 0
      return
    }
    renderItemChart()
    renderBmiChart()
    renderBatchChart()
  })
}

/** 各体检项目的异常人数：横向条形，一眼看出最突出的指标 */
function renderItemChart() {
  if (!itemChartRef.value) return
  if (!itemChart) itemChart = echarts.init(itemChartRef.value)

  const list = summary.itemAbnormal || []
  const names = list.map(i => i.item)
  const nums = list.map(i => Number(i.num || 0))

  itemChart.setOption({
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' },
      formatter: params => `${params[0].name}：${params[0].value} 人存在异常`
    },
    grid: { left: 8, right: 52, top: 12, bottom: 8, containLabel: true },
    xAxis: { type: 'value', minInterval: 1, splitLine: { lineStyle: { type: 'dashed' } } },
    yAxis: { type: 'category', data: names, axisTick: { show: false }, inverse: true },
    series: [{
      type: 'bar',
      barWidth: 18,
      data: nums,
      itemStyle: { color: '#378ADD', borderRadius: [0, 4, 4, 0] },
      label: { show: true, position: 'right', formatter: '{c} 人', fontSize: 12, color: '#5F5E5A' }
    }]
  }, true)
}

/** 用字典把 bmi_level 转成中文，字典改了这里不用动 */
function bmiLabelOf(value) {
  const hit = (ch_bmi_level.value || []).find(d => String(d.value) === String(value))
  return hit ? hit.label : '未评估'
}

const BMI_COLORS = { '0': '#85B7EB', '1': '#97C459', '2': '#EF9F27', '3': '#E24B4A', '9': '#B4B2A9' }

/** BMI 分布饼图 */
function renderBmiChart() {
  if (!bmiChartRef.value) return
  if (!bmiChart) bmiChart = echarts.init(bmiChartRef.value)

  const data = (summary.bmiDistribution || []).map(item => {
    const key = String(item.bmiLevel)
    return {
      name: bmiLabelOf(key),
      value: Number(item.num || 0),
      itemStyle: { color: BMI_COLORS[key] || '#B4B2A9' }
    }
  })

  bmiChart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}：{c} 人（{d}%）' },
    legend: { bottom: 0, itemWidth: 10, itemHeight: 10 },
    series: [{
      type: 'pie',
      radius: ['45%', '68%'],
      center: ['50%', '45%'],
      avoidLabelOverlap: true,
      itemStyle: { borderColor: '#fff', borderWidth: 2, borderRadius: 4 },
      label: { formatter: '{b}\n{c}', fontSize: 12 },
      data: data.length ? data : [{ name: '暂无数据', value: 1, itemStyle: { color: '#E5E5E5' } }]
    }]
  }, true)
}

/** 各批次预约进度：已预约 + 剩余 堆叠成一条，一眼看出满没满 */
function renderBatchChart() {
  if (!batchChartRef.value) return
  if (!batchChart) batchChart = echarts.init(batchChartRef.value)

  const list = summary.batchProgress || []
  const names = list.map(item => item.batchName || '未命名批次')
  const booked = list.map(item => Number(item.bookedCount || 0))
  const remain = list.map(item => Math.max(Number(item.capacity || 0) - Number(item.bookedCount || 0), 0))

  batchChart.setOption({
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' },
      formatter: params => {
        const item = list[params[0].dataIndex] || {}
        return `${item.batchName}<br/>已预约：${item.bookedCount || 0}<br/>名额上限：${item.capacity || 0}`
      }
    },
    legend: { bottom: 0, itemWidth: 10, itemHeight: 10 },
    grid: { left: 8, right: 24, top: 16, bottom: 40, containLabel: true },
    xAxis: { type: 'value', splitLine: { lineStyle: { type: 'dashed' } } },
    yAxis: { type: 'category', data: names, axisTick: { show: false } },
    series: [
      { name: '已预约', type: 'bar', stack: 'total', barWidth: 16, itemStyle: { color: '#378ADD' }, data: booked },
      { name: '剩余名额', type: 'bar', stack: 'total', barWidth: 16, itemStyle: { color: '#E6F1FB', borderRadius: [0, 4, 4, 0] }, data: remain }
    ]
  }, true)
}

function goAppointment() {
  router.push('/health/appointment')
}

function goMyAppointment() {
  router.push('/myHealth/appointment')
}

/** 窗口变化时图表跟着重算，否则会挤在一起 */
function handleResize() {
  bmiChart && bmiChart.resize()
  itemChart && itemChart.resize()
  batchChart && batchChart.resize()
}

onMounted(() => {
  loadData()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  bmiChart && bmiChart.dispose()
  itemChart && itemChart.dispose()
  batchChart && batchChart.dispose()
  bmiChart = null
  itemChart = null
  batchChart = null
})
</script>

<style scoped>
.dashboard {
  padding-bottom: 24px;
}

.page-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 18px;
}

.page-title {
  font-size: 20px;
  font-weight: 500;
  color: var(--el-text-color-primary);
  line-height: 1.4;
}

.page-sub {
  font-size: 13px;
  color: var(--el-text-color-secondary);
  margin-top: 4px;
}

.card-row {
  margin-bottom: 16px;
}

/* 5 张统计卡均分一行；窗口窄了自动折成两列，不会挤成一条 */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
  gap: 16px;
  margin-bottom: 16px;
}

.stat-card {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 18px;
  border-radius: 10px;
  border: 1px solid var(--el-border-color-lighter);
  background: var(--el-bg-color);
  height: 100%;
  box-sizing: border-box;
}

.stat-icon {
  width: 42px;
  height: 42px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.stat-body {
  min-width: 0;
}

.stat-label {
  font-size: 13px;
  color: var(--el-text-color-secondary);
}

.stat-value {
  font-size: 26px;
  font-weight: 500;
  line-height: 1.3;
  color: var(--el-text-color-primary);
}

.stat-unit {
  font-size: 13px;
  font-weight: 400;
  color: var(--el-text-color-secondary);
  margin-left: 3px;
}

.stat-hint {
  font-size: 12px;
  color: var(--el-text-color-placeholder);
  margin-top: 2px;
}

.tone-blue .stat-icon { background: #E6F1FB; color: #185FA5; }
.tone-green .stat-icon { background: #EAF3DE; color: #3B6D11; }
.tone-amber .stat-icon { background: #FAEEDA; color: #854F0B; }
.tone-red .stat-icon { background: #FCEBEB; color: #A32D2D; }
.tone-gray .stat-icon { background: #F1EFE8; color: #5F5E5A; }

.tone-red .stat-value { color: #A32D2D; }

.chart-card {
  margin-bottom: 16px;
}

.card-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  color: var(--el-text-color-primary);
}

.card-head-hint {
  font-size: 12px;
  color: var(--el-text-color-placeholder);
}

.chart-box {
  width: 100%;
  height: 280px;
}

/* 单独占一行的图表（批次进度），给条形留出更多横向空间 */
.chart-box-tall {
  height: 320px;
}

.table-card {
  margin-bottom: 8px;
}

/* 学生视角 */
.self-head {
  margin-bottom: 16px;
}

.self-profile {
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

.self-name {
  font-size: 17px;
  font-weight: 500;
  color: var(--el-text-color-primary);
  display: flex;
  align-items: center;
  gap: 10px;
}

.self-sub {
  font-size: 13px;
  color: var(--el-text-color-secondary);
  margin-top: 6px;
}

.self-metrics {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.self-metric {
  padding: 12px 14px;
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 8px;
}

.self-metric-label {
  font-size: 12px;
  color: var(--el-text-color-secondary);
}

.self-metric-value {
  font-size: 18px;
  font-weight: 500;
  color: var(--el-text-color-primary);
  margin-top: 4px;
}

.self-metric-unit {
  font-size: 12px;
  font-weight: 400;
  color: var(--el-text-color-placeholder);
  margin-left: 2px;
}

.text-muted {
  color: var(--el-text-color-placeholder);
  font-size: 13px;
}
</style>
