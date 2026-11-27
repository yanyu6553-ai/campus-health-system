<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="学号" prop="studentNo">
        <el-input
          v-model="queryParams.studentNo"
          placeholder="请输入学号"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="姓名" prop="studentName">
        <el-input
          v-model="queryParams.studentName"
          placeholder="请输入姓名"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="学院" prop="college">
        <el-input
          v-model="queryParams.college"
          placeholder="请输入学院"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="专业" prop="major">
        <el-input
          v-model="queryParams.major"
          placeholder="请输入专业"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="班级" prop="className">
        <el-input
          v-model="queryParams.className"
          placeholder="请输入班级"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="联系电话" prop="phone">
        <el-input
          v-model="queryParams.phone"
          placeholder="请输入联系电话"
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
          v-hasPermi="['health:student:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['health:student:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['health:student:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['health:student:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="studentList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="学号" align="center" prop="studentNo" />
      <el-table-column label="姓名" align="center" prop="studentName" />
      <el-table-column label="性别" align="center" prop="gender">
        <template #default="scope">
          <dict-tag :options="ch_sex" :value="scope.row.gender"/>
        </template>
      </el-table-column>
      <el-table-column label="出生日期" align="center" prop="birthday" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.birthday, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="学院" align="center" prop="college" />
      <el-table-column label="专业" align="center" prop="major" />
      <el-table-column label="班级" align="center" prop="className" />
      <el-table-column label="入学年份" align="center" prop="enrollYear" width="90" />
      <el-table-column label="联系电话" align="center" prop="phone" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="sys_normal_disable" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click="handleDetail(scope.row)">详情</el-button>
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['health:student:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['health:student:remove']">删除</el-button>
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

    <!-- 添加或修改学生信息对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="studentRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <!--
              文档 2.2 的学生字段里没有"关联若依用户ID"，那是技术字段，不该让人填数字。
              已绑定的显示状态；没绑定的给一个勾选框，勾了由后端自动开号（账号＝学号）。
            -->
            <el-form-item label="登录账号">
              <template v-if="form.userId">
                <el-tag type="success" size="small">已绑定</el-tag>
                <span class="account-tip">学生可用学号自助登录</span>
              </template>
              <template v-else>
                <el-checkbox v-model="form.createAccount">
                  同时创建登录账号（账号＝学号，初始密码 123456）
                </el-checkbox>
              </template>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="学号" prop="studentNo">
              <el-input v-model="form.studentNo" placeholder="请输入学号" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="姓名" prop="studentName">
              <el-input v-model="form.studentName" placeholder="请输入姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="性别" prop="gender">
              <el-radio-group v-model="form.gender">
                <el-radio
                  v-for="dict in ch_sex"
                  :key="dict.value"
                  :value="dict.value"
                >{{ dict.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="出生日期" prop="birthday">
              <el-date-picker clearable
                v-model="form.birthday"
                type="date"
                value-format="YYYY-MM-DD"
                placeholder="请选择出生日期">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="学院" prop="college">
              <el-input v-model="form.college" placeholder="请输入学院" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="专业" prop="major">
              <el-input v-model="form.major" placeholder="请输入专业" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="班级" prop="className">
              <el-input v-model="form.className" placeholder="请输入班级" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="入学年份" prop="enrollYear">
              <el-input v-model="form.enrollYear" placeholder="如 2024" maxlength="4" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="联系电话" prop="phone">
              <el-input v-model="form.phone" placeholder="请输入联系电话" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
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

    <!-- 学生详情：基本资料 + 档案摘要 + 最近体检 -->
    <el-drawer v-model="detailOpen" title="学生详情" size="640px" append-to-body>
      <div v-loading="detailLoading">
        <el-descriptions v-if="detailStudent" :column="2" border size="small">
          <el-descriptions-item label="学号">{{ detailStudent.studentNo }}</el-descriptions-item>
          <el-descriptions-item label="姓名">{{ detailStudent.studentName }}</el-descriptions-item>
          <el-descriptions-item label="性别">
            <dict-tag :options="ch_sex" :value="detailStudent.gender" />
          </el-descriptions-item>
          <el-descriptions-item label="出生日期">{{ parseTime(detailStudent.birthday, '{y}-{m}-{d}') || '-' }}</el-descriptions-item>
          <el-descriptions-item label="学院">{{ detailStudent.college || '-' }}</el-descriptions-item>
          <el-descriptions-item label="专业">{{ detailStudent.major || '-' }}</el-descriptions-item>
          <el-descriptions-item label="班级">{{ detailStudent.className || '-' }}</el-descriptions-item>
          <el-descriptions-item label="入学年份">{{ detailStudent.enrollYear || '-' }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ detailStudent.phone || '-' }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <dict-tag :options="sys_normal_disable" :value="detailStudent.status" />
          </el-descriptions-item>
          <el-descriptions-item label="系统账号" :span="2">
            {{ detailStudent.userId ? '已绑定，学生可用学号登录' : '未绑定，不能自助登录（可在「修改」里勾选同时创建账号）' }}
          </el-descriptions-item>
        </el-descriptions>

        <div v-if="detailArchive" class="detail-block">
          <div class="detail-title">
            <span>健康档案</span>
            <el-tag size="small" :type="detailArchive.archiveStatus === '1' ? 'danger' : 'success'">
              {{ detailArchive.archiveStatus === '1' ? '存在异常' : '正常' }}
            </el-tag>
          </div>
          <div class="detail-summary">{{ detailArchive.healthSummary }}</div>
        </div>

        <div class="detail-block">
          <div class="detail-title"><span>最近体检记录</span></div>
          <el-table :data="detailRecords" size="small" empty-text="暂无体检记录">
            <el-table-column label="体检日期" align="center" width="105">
              <template #default="scope">{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</template>
            </el-table-column>
            <el-table-column label="BMI" align="center" prop="bmi" width="70" />
            <el-table-column label="血压" align="center" width="100">
              <template #default="scope">{{ scope.row.systolicPressure }}/{{ scope.row.diastolicPressure }}</template>
            </el-table-column>
            <el-table-column label="结果" align="center" width="80">
              <template #default="scope">
                <el-tag size="small" :type="scope.row.abnormalFlag === '1' ? 'danger' : 'success'">
                  {{ scope.row.abnormalFlag === '1' ? '异常' : '正常' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="小结" prop="conclusion" show-overflow-tooltip />
          </el-table>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup name="Student">
import { listStudent, getStudent, delStudent, addStudent, updateStudent } from "@/api/health/student"
import { getArchive } from "@/api/health/archive"

const { proxy } = getCurrentInstance()
const { ch_sex, sys_normal_disable } = proxy.useDict("ch_sex", "sys_normal_disable")

const studentList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const detailOpen = ref(false)
const detailLoading = ref(false)
const detailStudent = ref(null)
const detailArchive = ref(null)
const detailRecords = ref([])

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    studentNo: undefined,
    studentName: undefined,
    college: undefined,
    major: undefined,
    className: undefined,
    phone: undefined,
  },
  rules: {
    studentNo: [
      { required: true, message: "学号不能为空", trigger: "blur" }
    ],
    studentName: [
      { required: true, message: "姓名不能为空", trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询学生信息列表 */
function getList() {
  loading.value = true
  listStudent(queryParams.value).then(response => {
    studentList.value = response.rows
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
    userId: null,
    createAccount: false,
    studentNo: null,
    studentName: null,
    gender: null,
    birthday: null,
    college: null,
    major: null,
    className: null,
    enrollYear: null,
    phone: null,
    status: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("studentRef")
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

/** 详情：基本资料直接取行数据，档案摘要和体检记录再查一次 */
function handleDetail(row) {
  detailStudent.value = row
  detailArchive.value = null
  detailRecords.value = []
  detailOpen.value = true
  detailLoading.value = true
  getArchive(row.id).then(res => {
    detailArchive.value = res.data.archive
    // 最近在前，页面只展示 5 条，避免抽屉太长
    const list = (res.data.records || []).slice().reverse()
    detailRecords.value = list.slice(0, 5)
  }).finally(() => {
    detailLoading.value = false
  })
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加学生信息"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getStudent(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改学生信息"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["studentRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateStudent(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addStudent(form.value).then(() => {
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
  proxy.$modal.confirm('是否确认删除学生信息编号为"' + _ids + '"的数据项？').then(function() {
    return delStudent(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('health/student/export', {
    ...queryParams.value
  }, `student_${new Date().getTime()}.xlsx`)
}

getList()
</script>

<style scoped>
.detail-block {
  margin-top: 18px;
}
.account-tip {
  margin-left: 8px;
  font-size: 12px;
  color: var(--el-text-color-secondary);
}.detail-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  margin-bottom: 8px;
  color: #303133;
}
.detail-summary {
  padding: 10px 12px;
  background: #f5f7fa;
  border-radius: 4px;
  font-size: 13px;
  line-height: 1.7;
  color: #303133;
}
</style>
