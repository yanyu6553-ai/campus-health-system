<template>
  <div class="app-container">
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="这里的参考范围会直接用于体检登记的异常判定"
      description="体检登记保存时，后端按「对应字段」取到学生的实测值，再和这里的上下限比较，超出范围就把这条记录标记为异常。改完范围后重新保存该次体检记录即可看到判定变化。"
    />

    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="项目名称" prop="itemName">
        <el-input
          v-model="queryParams.itemName"
          placeholder="请输入项目名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="项目编码" prop="itemCode">
        <el-input
          v-model="queryParams.itemCode"
          placeholder="请输入项目编码"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="项目分类" prop="category">
        <el-select v-model="queryParams.category" placeholder="请选择分类" clearable style="width: 160px">
          <el-option
            v-for="dict in ch_exam_category"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 140px">
          <el-option
            v-for="dict in sys_normal_disable"
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
          v-hasPermi="['health:examItem:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['health:examItem:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['health:examItem:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['health:examItem:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="examItemList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="项目编码" align="center" prop="itemCode" width="130" />
      <el-table-column label="项目名称" align="center" prop="itemName" width="110" />
      <el-table-column label="项目分类" align="center" prop="category" width="110">
        <template #default="scope">
          <dict-tag :options="ch_exam_category" :value="scope.row.category"/>
        </template>
      </el-table-column>
      <el-table-column label="参考范围" align="center" width="160">
        <template #default="scope">
          <span>{{ rangeText(scope.row) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="异常判定" align="center" prop="abnormalRule" width="150">
        <template #default="scope">
          <dict-tag :options="ch_abnormal_rule" :value="scope.row.abnormalRule"/>
        </template>
      </el-table-column>
      <el-table-column label="对应字段" align="center" prop="fieldKey" width="170">
        <template #default="scope">
          <span class="field-key">{{ scope.row.fieldKey || '—' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="90">
        <template #default="scope">
          <dict-tag :options="sys_normal_disable" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="项目说明" align="center" prop="description" show-overflow-tooltip />
      <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['health:examItem:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['health:examItem:remove']">删除</el-button>
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

    <!-- 添加或修改体检项目对话框 -->
    <el-dialog :title="title" v-model="open" width="720px" append-to-body>
      <el-form ref="examItemRef" :model="form" :rules="rules" label-width="110px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="项目编码" prop="itemCode">
              <el-input v-model="form.itemCode" placeholder="如 HGT-BMI，保存后不建议再改" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目名称" prop="itemName">
              <el-input v-model="form.itemName" placeholder="如 BMI" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目分类" prop="category">
              <el-select v-model="form.category" placeholder="请选择分类" style="width: 100%">
                <el-option
                  v-for="dict in ch_exam_category"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="计量单位" prop="unit">
              <el-input v-model="form.unit" placeholder="如 mmHg、kg/m²，无单位可留空" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="对应字段" prop="fieldKey">
              <el-select v-model="form.fieldKey" placeholder="选择这个项目对应体检记录里的哪个字段" clearable style="width: 100%">
                <el-option
                  v-for="item in fieldOptions"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
              <div class="form-tip">异常判定靠这个字段取实测值；留空或选「仅展示」的项目不参与判定</div>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="参考下限" prop="referenceMin">
              <el-input-number
                v-model="form.referenceMin"
                :precision="2"
                :controls="false"
                placeholder="不限就留空"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="参考上限" prop="referenceMax">
              <el-input-number
                v-model="form.referenceMax"
                :precision="2"
                :controls="false"
                placeholder="不限就留空"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="异常判定" prop="abnormalRule">
              <el-radio-group v-model="form.abnormalRule">
                <el-radio
                  v-for="dict in ch_abnormal_rule"
                  :key="dict.value"
                  :value="dict.value"
                >{{ dict.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="项目说明" prop="description">
              <el-input v-model="form.description" type="textarea" placeholder="建议写清参考标准的适用人群，如「中国成人标准」" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio
                  v-for="dict in sys_normal_disable"
                  :key="dict.value"
                  :value="dict.value"
                >{{ dict.label }}</el-radio>
              </el-radio-group>
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

<script setup name="ExamItem">
import { listExamItem, getExamItem, delExamItem, addExamItem, updateExamItem } from "@/api/health/examItem"

const { proxy } = getCurrentInstance()
const { ch_exam_category, ch_abnormal_rule, sys_normal_disable } = useDict('ch_exam_category', 'ch_abnormal_rule', 'sys_normal_disable')

const examItemList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")

/** 体检记录里可被配置驱动的字段，写死在这里是为了防止填错字段名（拼错了就一直取不到值、永远不判异常） */
const fieldOptions = [
  { value: 'height', label: 'height（身高 cm）' },
  { value: 'weight', label: 'weight（体重 kg）' },
  { value: 'bmi', label: 'bmi（BMI 指数）' },
  { value: 'systolic_pressure', label: 'systolic_pressure（收缩压 mmHg）' },
  { value: 'diastolic_pressure', label: 'diastolic_pressure（舒张压 mmHg）' },
  { value: 'heart_rate', label: 'heart_rate（心率 次/分）' },
  { value: 'vision_left', label: 'vision_left（左眼视力）' },
  { value: 'vision_right', label: 'vision_right（右眼视力）' }
]

/** 参考上下限的合法性：填反了会让所有数据都被判成异常 */
function validateRange(rule, value, callback) {
  const { referenceMin, referenceMax } = form.value
  if (referenceMin != null && referenceMax != null && Number(referenceMin) > Number(referenceMax)) {
    callback(new Error("参考下限不能大于参考上限"))
  } else {
    callback()
  }
}

/** 判定方式和参考范围的配套校验：选了「高于上限」却没填上限，这条规则等于没生效 */
function validateRule(rule, value, callback) {
  const { referenceMin, referenceMax } = form.value
  if (value === '0' && referenceMax == null) {
    callback(new Error("选「高于上限算异常」时必须填写参考上限"))
  } else if (value === '1' && referenceMin == null) {
    callback(new Error("选「低于下限算异常」时必须填写参考下限"))
  } else if (value === '2' && (referenceMin == null || referenceMax == null)) {
    callback(new Error("选「超出上下限算异常」时上下限都要填"))
  } else {
    callback()
  }
}

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    itemName: undefined,
    itemCode: undefined,
    category: undefined,
    status: undefined,
  },
  rules: {
    itemCode: [
      { required: true, message: "项目编码不能为空", trigger: "blur" }
    ],
    itemName: [
      { required: true, message: "项目名称不能为空", trigger: "blur" }
    ],
    category: [
      { required: true, message: "项目分类不能为空", trigger: "change" }
    ],
    abnormalRule: [
      { required: true, message: "请选择异常判定方式", trigger: "change" },
      { validator: validateRule, trigger: "change" }
    ],
    referenceMin: [
      { validator: validateRange, trigger: "blur" }
    ],
    referenceMax: [
      { validator: validateRange, trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 参考范围的显示：只填一边就显示成 ≥ / ≤，两边都空就是不设范围 */
function rangeText(row) {
  const min = row.referenceMin
  const max = row.referenceMax
  const unit = row.unit ? ' ' + row.unit : ''
  if (min == null && max == null) return '不设范围'
  if (min == null) return '≤ ' + max + unit
  if (max == null) return '≥ ' + min + unit
  return min + ' ~ ' + max + unit
}

/** 查询体检项目列表 */
function getList() {
  loading.value = true
  listExamItem(queryParams.value).then(response => {
    examItemList.value = response.rows
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
    itemCode: null,
    itemName: null,
    category: '1',
    unit: null,
    fieldKey: null,
    referenceMin: null,
    referenceMax: null,
    abnormalRule: '3',
    description: null,
    status: '0'
  }
  proxy.resetForm("examItemRef")
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
  title.value = "添加体检项目"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getExamItem(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改体检项目"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["examItemRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateExamItem(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addExamItem(form.value).then(() => {
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
  proxy.$modal.confirm('是否确认删除体检项目编号为"' + _ids + '"的数据项？').then(function() {
    return delExamItem(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('health/examItem/export', {
    ...queryParams.value
  }, `examItem_${new Date().getTime()}.xlsx`)
}

getList()
</script>

<style scoped>
.form-tip {
  font-size: 12px;
  color: #909399;
  line-height: 1.4;
}
.field-key {
  font-family: Consolas, Monaco, monospace;
  font-size: 12px;
  color: #606266;
}
</style>
