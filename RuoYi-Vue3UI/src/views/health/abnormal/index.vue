<template>
  <div class="app-container">
    <el-alert
      type="warning"
      :closable="false"
      show-icon
      class="mb8"
      title="异常是按「体检项目」里配置的参考范围判定的"
      description="改体检项目的上下限或判定方式，这里的结果会跟着变。指标异常只是提示，不等于疾病诊断，需由校医判断。"
    />

    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="学生姓名" prop="studentName">
        <el-input v-model="queryParams.studentName" placeholder="支持模糊查询" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="体检日期" prop="examDate">
        <el-date-picker
          v-model="queryParams.examDate"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="选择日期"
          clearable
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="16" class="mb8">
      <el-col :xs="24" :sm="8">
        <div class="stat">
          <div class="stat-label">异常记录总数</div>
          <div class="stat-value danger">{{ total }}</div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="8">
        <div class="stat">
          <div class="stat-label">涉及学生</div>
          <div class="stat-value">{{ studentCount }}</div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="8">
        <div class="stat">
          <div class="stat-label">参与判定的项目数</div>
          <div class="stat-value">{{ judgedItems.length }}</div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="recordList">
      <el-table-column label="学生" align="center" width="110" prop="studentName" />
      <el-table-column label="体检日期" align="center" width="110">
        <template #default="scope">
          <span>{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="BMI" align="center" width="90">
        <template #default="scope">
          <span class="value">{{ scope.row.bmi }}</span>
          <dict-tag :options="ch_bmi_level" :value="scope.row.bmiLevel" style="margin-left: 6px" />
        </template>
      </el-table-column>
      <el-table-column label="血压(mmHg)" align="center" width="120">
        <template #default="scope">
          <span class="value">{{ scope.row.systolicPressure }} / {{ scope.row.diastolicPressure }}</span>
        </template>
      </el-table-column>
      <el-table-column label="异常指标" align="left" min-width="360">
        <template #default="scope">
          <template v-if="reasonsOf(scope.row).length">
            <el-tag
              v-for="(r, i) in reasonsOf(scope.row)"
              :key="i"
              type="danger"
              effect="plain"
              size="small"
              class="reason-tag"
            >{{ r }}</el-tag>
          </template>
          <span v-else class="muted">—</span>
        </template>
      </el-table-column>
      <el-table-column label="体检小结" align="center" prop="conclusion" min-width="140" show-overflow-tooltip />
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script setup name="AbnormalItem">
import { listExamRecord } from "@/api/health/examRecord"
import { listEnabledExamItem } from "@/api/health/examItem"

const { proxy } = getCurrentInstance()
const { ch_bmi_level } = useDict('ch_bmi_level')

const recordList = ref([])
const items = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)
const studentCount = computed(() => new Set(recordList.value.map(r => r.studentId)).size)

/** 后端 field_key 是下划线命名，返回的 JSON 是驼峰，这里做一次对照 */
const FIELD_MAP = {
  height: 'height',
  weight: 'weight',
  bmi: 'bmi',
  systolic_pressure: 'systolicPressure',
  diastolic_pressure: 'diastolicPressure',
  heart_rate: 'heartRate',
  vision_left: 'visionLeft',
  vision_right: 'visionRight'
}

/** 只有会参与判定的项目（规则不是「仅展示」）才值得列出来 */
const judgedItems = computed(() => items.value.filter(i => i.abnormalRule !== '3'))

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    abnormalFlag: '1',
    studentName: undefined,
    examDate: undefined
  }
})

const { queryParams } = toRefs(data)

function getList() {
  loading.value = true
  listExamRecord(queryParams.value).then(response => {
    recordList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

/** 拉取启用的体检项目，用来把"异常"翻译成"哪一项、超了多少" */
function loadItems() {
  listEnabledExamItem().then(response => {
    items.value = response.data || []
  })
}

function rangeText(item) {
  const min = item.referenceMin
  const max = item.referenceMax
  const unit = item.unit ? ' ' + item.unit : ''
  if (min == null && max == null) return '不设范围'
  if (min == null) return '≤ ' + max + unit
  if (max == null) return '≥ ' + min + unit
  return min + ' ~ ' + max + unit
}

/**
 * 计算某条记录的异常项说明。
 * 判定逻辑和后端 ExamRecordServiceImpl 保持一致：规则 0 高、1 低、2 双边、3 不判。
 */
function reasonsOf(row) {
  const list = []
  for (const item of judgedItems.value) {
    const prop = FIELD_MAP[item.fieldKey]
    if (!prop) continue
    const value = row[prop]
    if (value == null || value === '') continue

    const min = item.referenceMin
    const max = item.referenceMax
    const over = max != null && Number(value) > Number(max)
    const under = min != null && Number(value) < Number(min)

    let hit = false
    if (item.abnormalRule === '0') hit = over
    else if (item.abnormalRule === '1') hit = under
    else if (item.abnormalRule === '2') hit = over || under

    if (hit) {
      const unit = item.unit ? item.unit : ''
      list.push(`${item.itemName} ${value}${unit} ${over ? '偏高' : '偏低'}（参考 ${rangeText(item)}）`)
    }
  }
  return list
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

function handleExport() {
  proxy.download('health/examRecord/export', {
    ...queryParams.value
  }, `异常指标_${new Date().getTime()}.xlsx`)
}

loadItems()
getList()
</script>

<style scoped>
.stat {
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 6px;
  padding: 14px 18px;
}
.stat-label {
  color: #909399;
  font-size: 13px;
}
.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin-top: 4px;
}
.stat-value.danger {
  color: #f56c6c;
}
.value {
  font-weight: 600;
}
.reason-tag {
  margin: 2px 6px 2px 0;
}
.muted {
  color: #c0c4cc;
}
</style>
