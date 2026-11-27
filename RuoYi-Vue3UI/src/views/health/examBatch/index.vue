<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="批次名称" prop="batchName">
        <el-input
          v-model="queryParams.batchName"
          placeholder="请输入批次名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="体检日期" prop="examDate">
        <el-date-picker clearable
          v-model="queryParams.examDate"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择体检日期">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="体检地点" prop="location">
        <el-input
          v-model="queryParams.location"
          placeholder="请输入体检地点"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="名额上限" prop="capacity">
        <el-input
          v-model="queryParams.capacity"
          placeholder="请输入名额上限"
          clearable
          @keyup.enter="handleQuery"
        />
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
          v-hasPermi="['health:examBatch:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['health:examBatch:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['health:examBatch:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['health:examBatch:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="examBatchList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="批次ID" align="center" prop="id" />
      <el-table-column label="批次名称" align="center" prop="batchName" />
      <el-table-column label="体检日期" align="center" prop="examDate" width="120">
        <template #default="scope">
          <span>{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="时间段" align="center" width="180">
        <template #default="scope">
          <span v-if="scope.row.startTime">
            {{ parseTime(scope.row.startTime, '{h}:{i}') }} ~ {{ parseTime(scope.row.endTime, '{h}:{i}') }}
          </span>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="体检地点" align="center" prop="location" />
      <el-table-column label="名额上限" align="center" prop="capacity" />
      <el-table-column label="已预约人数" align="center" prop="bookedCount" />
      <el-table-column label="余量" align="center" width="100">
        <template #default="scope">
          <el-tag v-if="(scope.row.bookedCount || 0) >= (scope.row.capacity || 0)" type="danger" size="small">已满</el-tag>
          <span v-else>{{ (scope.row.capacity || 0) - (scope.row.bookedCount || 0) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="ch_batch_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['health:examBatch:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['health:examBatch:remove']">删除</el-button>
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

    <!-- 添加或修改体检批次对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="examBatchRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="批次名称" prop="batchName">
              <el-input v-model="form.batchName" placeholder="请输入批次名称" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="开始时间" prop="startTime">
              <el-date-picker clearable
                v-model="form.startTime"
                type="datetime"
                value-format="YYYY-MM-DD HH:mm:ss"
                placeholder="请选择批次开始时间"
                style="width: 100%">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="结束时间" prop="endTime">
              <el-date-picker clearable
                v-model="form.endTime"
                type="datetime"
                value-format="YYYY-MM-DD HH:mm:ss"
                placeholder="请选择批次结束时间"
                style="width: 100%">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="体检日期">
              <!-- 不需要手填：后端按开始时间自动推导，避免"开始时间 11-25、日期写 11-26"这种脏数据 -->
              <span class="auto-date">{{ form.examDate || '保存后由开始时间自动生成' }}</span>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="体检地点" prop="location">
              <el-input v-model="form.location" placeholder="请输入体检地点" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="名额上限" prop="capacity">
              <el-input v-model="form.capacity" placeholder="请输入名额上限" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <!-- 新增时没有「已结束」：批次刚建不可能就结束了，只有修改时才允许选 -->
                <el-radio
                  v-for="dict in statusOptions"
                  :key="dict.value"
                  :value="dict.value"
                >{{dict.label}}</el-radio>
              </el-radio-group>
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
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="ExamBatch">
import { listExamBatch, getExamBatch, delExamBatch, addExamBatch, updateExamBatch } from "@/api/health/examBatch"

const { proxy } = getCurrentInstance()
const { ch_batch_status } = useDict('ch_batch_status')

const examBatchList = ref([])
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
    batchName: undefined,
    examDate: undefined,
    location: undefined,
    capacity: undefined,
    bookedCount: undefined,
    status: undefined,
  },
  rules: {
    batchName: [
      { required: true, message: "批次名称不能为空", trigger: "blur" }
    ],
    startTime: [
      { required: true, message: "批次开始时间不能为空", trigger: "change" }
    ],
    endTime: [
      { required: true, message: "批次结束时间不能为空", trigger: "change" },
      { validator: validateEndTime, trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 结束时间必须晚于开始时间（后端也会校验，这里是为了让用户当场看到红字，不用等提交报错） */
function validateEndTime(rule, value, callback) {
  const { startTime, endTime } = form.value
  if (startTime && endTime && new Date(endTime) <= new Date(startTime)) {
    callback(new Error("结束时间必须晚于开始时间"))
  } else {
    callback()
  }
}

/** 是否编辑模式：表单里有 id 就是修改，没有就是新增 */
const isEdit = computed(() => form.value.id != null)

/** 新增时只给「未开始 / 预约中」，修改时才有「已结束」 */
const statusOptions = computed(() =>
  isEdit.value ? ch_batch_status.value : ch_batch_status.value.filter(d => d.value !== '2')
)

/** 查询体检批次列表 */
function getList() {
  loading.value = true
  listExamBatch(queryParams.value).then(response => {
    examBatchList.value = response.rows
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
    batchName: null,
    startTime: null,
    endTime: null,
    examDate: null,
    location: null,
    capacity: null,
    bookedCount: null,
    status: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("examBatchRef")
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
  // 新批次默认「未开始」，比空白更符合直觉
  form.value.status = "0"
  open.value = true
  title.value = "添加体检批次"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getExamBatch(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改体检批次"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["examBatchRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateExamBatch(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addExamBatch(form.value).then(() => {
          proxy.$modal.msgSuccess("新增成功")
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
  proxy.$modal.confirm('是否确认删除体检批次编号为"' + _ids + '"的数据项？').then(function() {
    return delExamBatch(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('health/examBatch/export', {
    ...queryParams.value
  }, `examBatch_${new Date().getTime()}.xlsx`)
}

getList()
</script>

<style scoped>
.auto-date {
  color: var(--el-text-color-placeholder);
  font-size: 13px;
}
</style>
