<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="学生姓名" prop="studentName">
        <el-input
          v-model="queryParams.studentName"
          placeholder="请输入学生姓名"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="体检批次" prop="batchId">
        <el-select v-model="queryParams.batchId" placeholder="请选择批次" clearable style="width: 220px">
          <el-option
            v-for="b in batchOptions"
            :key="b.id"
            :label="b.batchName"
            :value="b.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 140px">
          <el-option
            v-for="dict in ch_appoint_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
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
          v-hasPermi="['health:appointment:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['health:appointment:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['health:appointment:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="appointmentList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="预约ID" align="center" prop="id" width="80" />
      <el-table-column label="学号" align="center" prop="studentNo" width="110" />
      <el-table-column label="学生姓名" align="center" prop="studentName" width="100" />
      <el-table-column label="体检批次" align="center" prop="batchName" min-width="180" show-overflow-tooltip />
      <el-table-column label="体检日期" align="center" prop="examDate" width="110">
        <template #default="scope">
          <span>{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="预约提交时间" align="center" prop="appointmentTime" width="165">
        <template #default="scope">
          <span>{{ parseTime(scope.row.appointmentTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="95">
        <template #default="scope">
          <dict-tag :options="ch_appoint_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="审核人" align="center" prop="auditUserName" width="100" />
      <el-table-column label="审核时间" align="center" prop="auditTime" width="165">
        <template #default="scope">
          <span>{{ parseTime(scope.row.auditTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="审核备注" align="center" prop="auditRemark" min-width="140" show-overflow-tooltip />
      <el-table-column label="操作" align="center" width="200" class-name="small-padding fixed-width">
        <template #default="scope">
          <template v-if="scope.row.status === '0'">
            <el-button link type="success" icon="Check" @click="handlePass(scope.row)" v-hasPermi="['health:appointment:edit']">通过</el-button>
            <el-button link type="danger" icon="Close" @click="handleReject(scope.row)" v-hasPermi="['health:appointment:edit']">拒绝</el-button>
          </template>
          <template v-else>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['health:appointment:remove']">删除</el-button>
          </template>
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

    <!-- 添加或修改体检预约对话框 -->
    <el-dialog :title="title" v-model="open" width="540px" append-to-body>
      <el-form ref="appointmentRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="学生" prop="studentId">
          <el-select v-model="form.studentId" placeholder="请选择学生" filterable style="width: 100%">
            <el-option
              v-for="s in studentOptions"
              :key="s.id"
              :label="s.studentNo + '  ' + s.studentName"
              :value="s.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="体检批次" prop="batchId">
          <el-select v-model="form.batchId" placeholder="请选择体检批次" filterable style="width: 100%">
            <el-option
              v-for="b in batchOptions"
              :key="b.id"
              :label="batchLabel(b)"
              :value="b.id"
              :disabled="batchDisabled(b)"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <div style="color:#909399;font-size:12px;line-height:1.6">
        说明：预约提交后状态为「待审核」，审核人与审核时间由系统记录，不接受手工填写。
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 拒绝预约对话框 -->
    <el-dialog title="拒绝预约" v-model="rejectOpen" width="480px" append-to-body>
      <el-form label-width="90px">
        <el-form-item label="学生">
          <span>{{ rejectForm.studentName }}</span>
        </el-form-item>
        <el-form-item label="审核备注" required>
          <el-input v-model="rejectForm.auditRemark" type="textarea" :rows="4"
                    placeholder="请说明拒绝原因，学生需要据此修改后重新预约" maxlength="200" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="danger" @click="submitReject">确认拒绝</el-button>
          <el-button @click="rejectOpen = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Appointment">
import { listAppointment, getAppointment, delAppointment, addAppointment, updateAppointment, auditAppointment } from "@/api/health/appointment"
import { listStudent } from "@/api/health/student"
import { listExamBatch } from "@/api/health/examBatch"

const { proxy } = getCurrentInstance()
const { ch_appoint_status } = useDict('ch_appoint_status')

const appointmentList = ref([])
const studentOptions = ref([])
const batchOptions = ref([])
const open = ref(false)
const rejectOpen = ref(false)
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
    studentName: undefined,
    batchId: undefined,
    status: undefined,
  },
  rules: {
    studentId: [
      { required: true, message: "请选择学生", trigger: "change" }
    ],
    batchId: [
      { required: true, message: "请选择体检批次", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

const rejectForm = reactive({ id: null, studentName: "", auditRemark: "" })

/** 查询体检预约列表 */
function getList() {
  loading.value = true
  listAppointment(queryParams.value).then(response => {
    appointmentList.value = response.rows
    total.value = response.total
    loading.value = false
  })
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

/** 批次下拉文案：把「未开放 / 已满 / 已结束」直接写出来，不用学生猜 */
function batchLabel(b) {
  const date = b.examDate ? proxy.parseTime(b.examDate, '{y}-{m}-{d}') : ''
  const cap = b.capacity || 0
  const booked = b.bookedCount || 0
  let tail
  if (b.status === '2') tail = '已结束'
  else if (b.status === '0') tail = '未开放'
  else if (booked >= cap) tail = '已满'
  else tail = '余 ' + (cap - booked) + ' 位'
  return b.batchName + '（' + date + ' · ' + tail + '）'
}

/** 只有「预约中且还有余量」的批次才能选 */
function batchDisabled(b) {
  return b.status !== '1' || (b.bookedCount || 0) >= (b.capacity || 0)
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
    remark: null
  }
  proxy.resetForm("appointmentRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  queryParams.value.batchId = undefined
  queryParams.value.status = undefined
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
  title.value = "添加体检预约"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getAppointment(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改体检预约"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["appointmentRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateAppointment(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addAppointment(form.value).then(() => {
          proxy.$modal.msgSuccess("新增成功，状态为待审核")
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 审核通过 */
function handlePass(row) {
  proxy.$modal.confirm('确认通过「' + (row.studentName || row.studentNo) + '」的体检预约？').then(function () {
    return auditAppointment({ id: row.id, status: '1' })
  }).then(() => {
    getList()
    loadOptions()
    proxy.$modal.msgSuccess("审核通过")
  }).catch(() => {})
}

/** 打开拒绝弹窗 */
function handleReject(row) {
  rejectForm.id = row.id
  rejectForm.studentName = (row.studentName || "") + " " + (row.studentNo || "")
  rejectForm.auditRemark = ""
  rejectOpen.value = true
}

/** 提交拒绝 */
function submitReject() {
  if (!rejectForm.auditRemark || !rejectForm.auditRemark.trim()) {
    proxy.$modal.msgWarning("请填写拒绝原因")
    return
  }
  auditAppointment({ id: rejectForm.id, status: '2', auditRemark: rejectForm.auditRemark.trim() }).then(() => {
    rejectOpen.value = false
    getList()
    proxy.$modal.msgSuccess("已拒绝该预约")
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _ids = row.id || ids.value
  proxy.$modal.confirm('是否确认删除体检预约编号为"' + _ids + '"的数据项？').then(function () {
    return delAppointment(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('health/appointment/export', {
    ...queryParams.value
  }, `appointment_${new Date().getTime()}.xlsx`)
}

loadOptions()
getList()
</script>
