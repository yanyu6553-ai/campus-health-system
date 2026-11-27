<template>
  <div class="app-container" v-loading="loading">
    <el-row :gutter="16" class="mb8">
      <el-col :xs="24" :sm="8">
        <div class="stat">
          <div class="stat-label">体检次数</div>
          <div class="stat-value">{{ records.length }}<span class="stat-unit">次</span></div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="8">
        <div class="stat">
          <div class="stat-label">最近体检日期</div>
          <div class="stat-value small">{{ lastExamDate || '暂无' }}</div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="8">
        <div class="stat">
          <div class="stat-label">异常记录</div>
          <div class="stat-value" :class="{ danger: abnormalCount > 0 }">
            {{ abnormalCount }}<span class="stat-unit">次</span>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-card shadow="never">
      <template #header>
        <div class="card-head">
          <span>我的体检记录</span>
          <span class="card-head-hint">只能看到自己的记录</span>
        </div>
      </template>

      <el-table :data="records">
        <el-table-column label="体检日期" align="center" width="120">
          <template #default="scope">{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</template>
        </el-table-column>
        <el-table-column label="批次" prop="batchName" min-width="160" show-overflow-tooltip />
        <el-table-column label="身高(cm)" align="center" prop="height" width="90" />
        <el-table-column label="体重(kg)" align="center" prop="weight" width="90" />
        <el-table-column label="BMI" align="center" prop="bmi" width="80" />
        <el-table-column label="BMI等级" align="center" width="100">
          <template #default="scope">
            <dict-tag :options="ch_bmi_level" :value="scope.row.bmiLevel" />
          </template>
        </el-table-column>
        <el-table-column label="血压(mmHg)" align="center" width="130">
          <template #default="scope">{{ scope.row.systolicPressure }} / {{ scope.row.diastolicPressure }}</template>
        </el-table-column>
        <el-table-column label="心率" align="center" prop="heartRate" width="80" />
        <el-table-column label="视力(左/右)" align="center" width="110">
          <template #default="scope">{{ scope.row.visionLeft }} / {{ scope.row.visionRight }}</template>
        </el-table-column>
        <el-table-column label="结论" align="center" width="90">
          <template #default="scope">
            <el-tag v-if="scope.row.abnormalFlag === '1'" type="danger" size="small">异常</el-tag>
            <el-tag v-else type="success" size="small">正常</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="备注" prop="conclusion" min-width="160" show-overflow-tooltip />
        <template #empty>
          <el-empty description="还没有体检记录，完成体检后校医会录入" />
        </template>
      </el-table>
    </el-card>

    <el-alert
      type="warning"
      :closable="false"
      show-icon
      class="mt16"
      title="数据说明"
      description="异常标记由系统按「体检项目」里配置的参考范围自动判定，仅供参考。如对结果有疑问，请联系校医院复检，不要自行据此判断健康状况。"
    />
  </div>
</template>

<script setup name="MyRecords">
import { listMyRecords } from '@/api/health/my'

const { proxy } = getCurrentInstance()
const { ch_bmi_level } = useDict('ch_bmi_level')

const loading = ref(false)
const records = ref([])

const abnormalCount = computed(() => records.value.filter(r => r.abnormalFlag === '1').length)

const lastExamDate = computed(() => {
  if (!records.value.length) return ''
  return proxy.parseTime(records.value[0].examDate, '{y}-{m}-{d}')
})

function getList() {
  loading.value = true
  listMyRecords().then(res => {
    records.value = res.data || []
  }).finally(() => {
    loading.value = false
  })
}

getList()
</script>

<style scoped>
.stat {
  padding: 16px 18px;
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 10px;
  background: var(--el-bg-color);
  margin-bottom: 8px;
}

.stat-label {
  font-size: 12px;
  color: var(--el-text-color-secondary);
}

.stat-value {
  font-size: 22px;
  font-weight: 500;
  color: var(--el-text-color-primary);
  margin-top: 4px;
}

.stat-value.small {
  font-size: 18px;
}

.stat-value.danger {
  color: var(--el-color-danger);
}

.stat-unit {
  font-size: 12px;
  font-weight: 400;
  color: var(--el-text-color-placeholder);
  margin-left: 3px;
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
