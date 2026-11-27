<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <span class="card-title">学生信息批量导入</span>
      </template>

      <el-alert
        type="info"
        :closable="false"
        show-icon
        title="先下载模板，按表头填写后再上传"
        description="学号是唯一标识。不勾选「覆盖更新」时，库里已存在的学号会被跳过并提示；勾选后用 Excel 内容覆盖已有资料（不会影响该学生的体检记录）。"
      />

      <div class="toolbar">
        <el-button
          type="primary"
          plain
          icon="Download"
          @click="handleTemplate"
          v-hasPermi="['health:student:import']"
        >下载导入模板</el-button>
        <span class="tip">模板里的列就是学生表的字段，别改表头文字</span>
      </div>

      <el-upload
        ref="uploadRef"
        drag
        :limit="1"
        accept=".xlsx,.xls"
        :headers="headers"
        :action="uploadUrl"
        :data="{ updateSupport }"
        :auto-upload="false"
        :on-change="handleChange"
        :on-remove="handleRemove"
        :on-success="handleSuccess"
        :on-error="handleError"
        :on-exceed="handleExceed"
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
        <div class="el-upload__text">把 Excel 拖到这里，或<em>点击选择文件</em></div>
        <template #tip>
          <div class="el-upload__tip">仅支持 xls / xlsx，一次一个文件</div>
        </template>
      </el-upload>

      <div class="toolbar">
        <el-checkbox v-model="updateSupport">学号已存在时覆盖更新（不勾选则跳过该行）</el-checkbox>
        <el-button type="primary" :loading="uploading" @click="submitUpload">开始导入</el-button>
        <el-button v-if="result" @click="resetResult">清空结果</el-button>
      </div>

      <el-alert v-if="result" :type="resultType" :closable="false" class="result">
        <div v-html="result"></div>
      </el-alert>
    </el-card>
  </div>
</template>

<script setup name="StudentImport">
import { getToken } from '@/utils/auth'

const { proxy } = getCurrentInstance()

const uploadRef = ref(null)
const uploading = ref(false)
const updateSupport = ref(false)
const result = ref("")
const resultType = ref("success")

/**
 * 当前已选中的文件列表（Element Plus 的 el-upload 在 on-change 里给第二参数 files）
 * 为什么不写 uploadRef.value.uploadFiles：element-plus 2.13 的 el-upload 只对外暴露了
 * abort / submit / clearFiles / handleStart / handleRemove，压根没有 uploadFiles。
 * 拿它判断会一直是 undefined，"开始导入"就永远提示"请先选择文件"。
 */
const selectedFiles = ref([])

/** 上传地址：走 RuoYi 的代理前缀，开发环境是 /dev-api，生产环境是真实域名 */
const uploadUrl = import.meta.env.VITE_APP_BASE_API + "/health/student/importData"

/** 手动拼 Token：el-upload 走的是自己的请求，不经过封装的 request 工具 */
const headers = { Authorization: "Bearer " + getToken() }

/** 下载模板 */
function handleTemplate() {
  proxy.download("health/student/importTemplate", {}, `学生导入模板_${new Date().getTime()}.xlsx`)
}

// on-change 的第二个参数是当前完整文件列表，选一个文件就记一个
function handleChange(file, files) {
  selectedFiles.value = files || []
  result.value = ""
}

function handleRemove(file, files) {
  selectedFiles.value = files || []
  result.value = ""
}

/** 只允许一个文件，重复选择时提示 */
function handleExceed() {
  proxy.$modal.msgWarning("一次只能导入一个文件，请先移除已选文件")
}

function submitUpload() {
  if (selectedFiles.value.length === 0) {
    proxy.$modal.msgWarning("请先选择要导入的 Excel 文件")
    return
  }
  uploading.value = true
  uploadRef.value.submit()
}

/** 清空已选文件：clearFiles() 不会触发 on-change，得自己把列表一起清掉 */
function resetFiles() {
  selectedFiles.value = []
  uploadRef.value?.clearFiles()
}

function handleSuccess(response) {
  uploading.value = false
  // 后端成功时返回 code=200 + 带 <br/> 的明细文本
  if (response.code === 200) {
    resultType.value = "success"
    result.value = response.msg
    proxy.$modal.msgSuccess("导入完成")
  } else {
    resultType.value = "error"
    result.value = response.msg || "导入失败"
  }
  resetFiles()
}

function handleError(err) {
  uploading.value = false
  resultType.value = "error"
  // 后端用 ServiceException 抛出的失败明细在 err.message 里（HTTP 500 的 JSON）
  let msg = "导入失败，请检查文件格式"
  try {
    const body = JSON.parse(err.message)
    msg = body.msg || msg
  } catch (e) {
    msg = err.message || msg
  }
  result.value = msg
  resetFiles()
}

function resetResult() {
  result.value = ""
}
</script>

<style scoped>
.card-title {
  font-weight: 600;
}
.toolbar {
  margin: 16px 0;
  display: flex;
  align-items: center;
  gap: 12px;
}
.tip {
  color: #909399;
  font-size: 12px;
}
.result {
  margin-top: 8px;
  line-height: 1.7;
}
</style>
