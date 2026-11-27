<template>
  <div class="app-container">
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="这里只看历史记录，不提供录入"
      description="录入/修改体检数据请到「体检管理 → 体检登记」。本页用于查询某个学生或某个批次的历年体检结果，支持导出后做对比。"
    />

    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="学生姓名" prop="studentName">
        <el-input v-model="queryParams.studentName" placeholder="支持模糊查询" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="体检批次" prop="batchId">
        <el-select v-model="queryParams.batchId" placeholder="全部批次" clearable style="width: 200px">
          <el-option v-for="b in batchOptions" :key="b.id" :label="b.batchName" :value="b.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="异常" prop="abnormalFlag">
        <el-select v-model="queryParams.abnormalFlag" placeholder="全部" clearable style="width: 120px">
          <el-option label="仅异常" value="1" />
          <el-option label="仅正常" value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

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
      <el-table-column label="批次" align="center" prop="batchName" min-width="150" show-overflow-tooltip />
      <el-table-column label="身高(cm)" align="center" prop="height" width="90" />
      <el-table-column label="体重(kg)" align="center" prop="weight" width="90" />
      <el-table-column label="BMI" align="center" prop="bmi" width="80" />
      <el-table-column label="BMI等级" align="center" width="100">
        <template #default="scope">
          <dict-tag :options="ch_bmi_level" :value="scope.row.bmiLevel" />
        </template>
      </el-table-column>
      <el-table-column label="血压(mmHg)" align="center" width="120">
        <template #default="scope">
          <span>{{ scope.row.systolicPressure }} / {{ scope.row.diastolicPressure }}</span>
        </template>
      </el-table-column>
      <el-table-column label="心率" align="center" prop="heartRate" width="80" />
      <el-table-column label="视力(左/右)" align="center" width="110">
        <template #default="scope">
          <span>{{ scope.row.visionLeft }} / {{ scope.row.visionRight }}</span>
        </template>
      </el-table-column>
      <el-table-column label="异常" align="center" width="80">
        <template #default="scope">
          <el-tag v-if="scope.row.abnormalFlag === '1'" type="danger" size="small">异常</el-tag>
          <el-tag v-else type="success" size="small">正常</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="体检小结" align="center" prop="conclusion" min-width="160" show-overflow-tooltip />
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

<script setup name="ExamRecordHistory">
import { listExamRecord } from "@/api/health/examRecord"
import { listExamBatch } from "@/api/health/examBatch"

const { proxy } = getCurrentInstance()
const { ch_bmi_level } = useDict('ch_bmi_level')

const recordList = ref([])
const batchOptions = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    studentName: undefined,
    batchId: undefined,
    abnormalFlag: undefined
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

/** 批次下拉：一次取够，批次数量本来就不多 */
function loadBatches() {
  listExamBatch({ pageNum: 1, pageSize: 100 }).then(response => {
    batchOptions.value = response.rows || []
  })
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
  }, `历史体检记录_${new Date().getTime()}.xlsx`)
}

loadBatches()
getList()
</script>
