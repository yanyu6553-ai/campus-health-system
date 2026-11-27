<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="学生" prop="studentId">
        <el-select v-model="queryParams.studentId" placeholder="请选择学生" clearable filterable style="width: 180px">
          <el-option
            v-for="s in studentOptions"
            :key="s.id"
            :label="s.studentNo + ' ' + s.studentName"
            :value="s.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="批次" prop="batchId">
        <el-select v-model="queryParams.batchId" placeholder="请选择批次" clearable filterable style="width: 180px">
          <el-option
            v-for="b in batchOptions"
            :key="b.id"
            :label="b.batchName"
            :value="b.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="体检日期" prop="examDate">
        <el-date-picker clearable
          v-model="queryParams.examDate"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择体检日期">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="记录状态" prop="recordStatus">
        <el-select v-model="queryParams.recordStatus" placeholder="全部" clearable style="width: 140px">
          <el-option v-for="d in ch_record_status" :key="d.dictValue" :label="d.dictLabel" :value="d.dictValue" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['health:examRecord:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['health:examRecord:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['health:examRecord:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['health:examRecord:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="examRecordList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="记录ID" align="center" prop="id" width="70" />
      <el-table-column label="学生姓名" align="center" prop="studentName" />
      <el-table-column label="体检批次" align="center" prop="batchName" />
      <el-table-column label="体检日期" align="center" prop="examDate" width="100">
        <template #default="scope">
          <span>{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="身高(cm)" align="center" prop="height" />
      <el-table-column label="体重(kg)" align="center" prop="weight" />
      <el-table-column label="BMI指数" align="center" prop="bmi" />
      <el-table-column label="BMI等级" align="center" prop="bmiLevel">
        <template #default="scope">
          <dict-tag :options="ch_bmi_level" :value="scope.row.bmiLevel"/>
        </template>
      </el-table-column>
      <el-table-column label="收缩压(mmHg)" align="center" prop="systolicPressure" />
      <el-table-column label="舒张压(mmHg)" align="center" prop="diastolicPressure" />
      <el-table-column label="心率(次/分)" align="center" prop="heartRate" />
      <el-table-column label="左眼视力" align="center" prop="visionLeft" />
      <el-table-column label="右眼视力" align="center" prop="visionRight" />
      <el-table-column label="记录状态" align="center" prop="recordStatus" width="100">
        <template #default="scope">
          <dict-tag :options="ch_record_status" :value="scope.row.recordStatus" />
        </template>
      </el-table-column>
      <el-table-column label="异常标记" align="center" prop="abnormalFlag" width="90">
        <template #default="scope">
          <el-tag :type="scope.row.abnormalFlag === '1' ? 'danger' : 'success'">
            {{ scope.row.abnormalFlag === '1' ? '异常' : '正常' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="体检小结" align="center" prop="conclusion" />
      <el-table-column label="体检人员" align="center" prop="examinerName" width="100">
        <template #default="scope">
          <span>{{ scope.row.examinerName || '-' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['health:examRecord:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['health:examRecord:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改体检记录对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="examRecordRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="学生" prop="studentId">
              <el-select v-model="form.studentId" placeholder="请选择学生" filterable style="width: 100%">
                <el-option
                  v-for="s in studentOptions"
                  :key="s.id"
                  :label="s.studentNo + ' ' + s.studentName"
                  :value="s.id"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="体检批次" prop="batchId">
              <el-select v-model="form.batchId" placeholder="请选择体检批次（可选）" clearable filterable style="width: 100%">
                <el-option
                  v-for="b in batchOptions"
                  :key="b.id"
                  :label="b.batchName + '（' + parseTime(b.examDate, '{y}-{m}-{d}') + '）'"
                  :value="b.id"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="体检日期" prop="examDate">
              <el-date-picker clearable
                v-model="form.examDate"
                type="date"
                value-format="YYYY-MM-DD"
                placeholder="请选择体检日期">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="身高(cm)" prop="height">
              <el-input v-model="form.height" placeholder="请输入身高(cm)" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="体重(kg)" prop="weight">
              <el-input v-model="form.weight" placeholder="请输入体重(kg)" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="BMI 预估">
              <span class="bmi-preview">{{ bmiPreview }}</span>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="收缩压(mmHg)" prop="systolicPressure">
              <el-input v-model="form.systolicPressure" placeholder="请输入收缩压(mmHg)" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="舒张压(mmHg)" prop="diastolicPressure">
              <el-input v-model="form.diastolicPressure" placeholder="请输入舒张压(mmHg)" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="心率(次/分)" prop="heartRate">
              <el-input v-model="form.heartRate" placeholder="请输入心率(次/分)" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="左眼视力" prop="visionLeft">
              <el-input v-model="form.visionLeft" placeholder="请输入左眼视力" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="右眼视力" prop="visionRight">
              <el-input v-model="form.visionRight" placeholder="请输入右眼视力" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="体检小结" prop="conclusion">
              <el-input v-model="form.conclusion" type="textarea" placeholder="请输入内容" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm('2')">确 定</el-button>
          <el-button @click="submitForm('1')">暂 存</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
        <div class="dialog-tip">「暂存」表示数据还没录完，记录状态为「录入中」；确定保存为「已完成」。</div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="ExamRecord">
import { listExamRecord, getExamRecord, delExamRecord, addExamRecord, updateExamRecord } from "@/api/health/examRecord"
import { listStudent } from "@/api/health/student"
import { listExamBatch } from "@/api/health/examBatch"

const { proxy } = getCurrentInstance()
const { ch_bmi_level, ch_record_status } = useDict('ch_bmi_level', 'ch_record_status')

const examRecordList = ref([])
const studentOptions = ref([])
const batchOptions = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    studentId: undefined,
    batchId: undefined,
    examDate: undefined,
    recordStatus: undefined,
  },
  rules: {
    studentId: [
      { required: true, message: "学生ID不能为空", trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** BMI 实时预估：身高体重一填就出来，不用等保存后才知道算成多少 */
const bmiPreview = computed(() => {
  const h = parseFloat(form.value.height)
  const w = parseFloat(form.value.weight)
  if (!h || !w || h <= 0) {
    return "填写身高、体重后自动计算"
  }
  const bmi = w / Math.pow(h / 100, 2)
  let level = "正常"
  if (bmi < 18.5) level = "偏低"
  else if (bmi < 24) level = "正常"
  else if (bmi < 28) level = "超重"
  else level = "肥胖"
  return bmi.toFixed(1) + "（" + level + "）"
})

/** 查询体检记录列表 */
function getList() {
  loading.value = true
  listExamRecord(queryParams.value).then(response => {
    examRecordList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

/** 取消按钮 */
function cancel() {
  open.value = false
  reset()
}

/** 表单重置 */
function reset() {
  form.value = {
    id: null,
    studentId: null,
    batchId: null,
    examDate: null,
    height: null,
    weight: null,
    bmi: null,
    bmiLevel: null,
    systolicPressure: null,
    diastolicPressure: null,
    heartRate: null,
    visionLeft: null,
    visionRight: null,
    recordStatus: '2',
    conclusion: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("examRecordRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

/** 多选框选中数据 */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加体检记录"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getExamRecord(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改体检记录"
  })
}

/** 提交按钮：status 传 2 表示"确定"（已完成），传 1 表示"暂存"（录入中） */
function submitForm(status) {
  proxy.$refs["examRecordRef"].validate(valid => {
    if (valid) {
      form.value.recordStatus = status || '2'
      if (form.value.id != null) {
        updateExamRecord(form.value).then(() => {
          proxy.$modal.msgSuccess(status === '1' ? "已暂存，可稍后继续录入" : "修改成功")
          open.value = false
          getList()
        })
      } else {
        addExamRecord(form.value).then(() => {
          proxy.$modal.msgSuccess(status === '1' ? "已暂存，可稍后继续录入" : "新增成功")
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _ids = row.id || ids.value
  proxy.$modal.confirm('是否确认删除体检记录编号为"' + _ids + '"的数据项？').then(function() {
    return delExamRecord(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('health/examRecord/export', {
    ...queryParams.value
  }, `examRecord_${new Date().getTime()}.xlsx`)
}

/** 加载学生与批次下拉数据 */
function loadOptions() {
  listStudent({ pageNum: 1, pageSize: 999 }).then(res => {
    studentOptions.value = res.rows || []
  })
  listExamBatch({ pageNum: 1, pageSize: 999 }).then(res => {
    batchOptions.value = res.rows || []
  })
}

getList()
loadOptions()
</script>

<style scoped>
.bmi-preview {
  color: #409eff;
  font-weight: 600;
}
.dialog-tip {
  margin-top: 8px;
  font-size: 12px;
  color: #909399;
  text-align: center;
}
</style>
