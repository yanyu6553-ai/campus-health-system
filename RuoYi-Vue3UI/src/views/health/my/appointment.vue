<template>
  <div class="app-container">
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="这里只显示你本人的预约记录"
      description="预约提交后状态为「待审核」，校医通过后会变成「已预约」；体检完成后自动变为「已完成」。体检当天请带学生证按时到场。"
    />

    <el-card shadow="never" class="section">
      <template #header>
        <div class="section-head">
          <span>可预约的体检批次</span>
          <span class="section-hint">仅显示校医已开放预约的批次</span>
        </div>
      </template>

      <el-table v-loading="batchLoading" :data="openBatches" size="default">
        <el-table-column label="批次名称" prop="batchName" min-width="180" show-overflow-tooltip />
        <el-table-column label="体检日期" align="center" width="120">
          <template #default="scope">{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</template>
        </el-table-column>
        <el-table-column label="体检地点" prop="location" min-width="150" show-overflow-tooltip />
        <el-table-column label="名额" align="center" width="150">
          <template #default="scope">
            <span :class="{ 'text-danger': isFull(scope.row) }">
              {{ scope.row.bookedCount || 0 }} / {{ scope.row.capacity || 0 }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="剩余名额" align="center" width="100">
          <template #default="scope">{{ remainOf(scope.row) }}</template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="120">
          <template #default="scope">
            <el-button
              type="primary"
              link
              :disabled="isFull(scope.row) || isBooked(scope.row.id)"
              @click="handleApply(scope.row)"
            >
              {{ applyLabel(scope.row) }}
            </el-button>
          </template>
        </el-table-column>
        <template #empty>
          <el-empty description="当前没有开放的体检批次，请等校医发布" />
        </template>
      </el-table>
    </el-card>

    <el-card shadow="never" class="section">
      <template #header>
        <div class="section-head">
          <span>我的预约记录</span>
          <el-button icon="Refresh" size="small" @click="loadAll">刷新</el-button>
        </div>
      </template>

      <el-table v-loading="loading" :data="myAppointments">
        <el-table-column label="体检批次" prop="batchName" min-width="180" show-overflow-tooltip />
        <el-table-column label="体检日期" align="center" width="120">
          <template #default="scope">{{ parseTime(scope.row.examDate, '{y}-{m}-{d}') }}</template>
        </el-table-column>
        <el-table-column label="提交时间" align="center" width="170">
          <template #default="scope">{{ parseTime(scope.row.appointmentTime) }}</template>
        </el-table-column>
        <el-table-column label="状态" align="center" width="110">
          <template #default="scope">
            <dict-tag :options="ch_appoint_status" :value="scope.row.status" />
          </template>
        </el-table-column>
        <el-table-column label="审核人" align="center" width="110" prop="auditUserName" />
        <el-table-column label="审核备注" prop="auditRemark" min-width="160" show-overflow-tooltip />
        <el-table-column label="操作" align="center" width="100">
          <template #default="scope">
            <el-button
              v-if="scope.row.status === '0' || scope.row.status === '1'"
              type="danger"
              link
              @click="handleCancel(scope.row)"
            >
              取消预约
            </el-button>
            <span v-else class="text-muted">—</span>
          </template>
        </el-table-column>
        <template #empty>
          <el-empty description="你还没有预约记录" />
        </template>
      </el-table>
    </el-card>
  </div>
</template>

<script setup name="MyAppointment">
import { listMyAppointments, listOpenBatches, applyAppointment, cancelMyAppointment } from '@/api/health/my'

const { proxy } = getCurrentInstance()
const { ch_appoint_status } = useDict('ch_appoint_status')

const loading = ref(false)
const batchLoading = ref(false)
const myAppointments = ref([])
const openBatches = ref([])

/**
 * 批次ID -> 我在这个批次上的预约状态
 * 0待审核 / 1已预约 / 4已完成 这三种都不该再点"预约"，所以一起记下来置灰
 * 2已拒绝 / 3已取消 可以重新预约，故意不放进来（后端会复用旧记录改回待审核）
 */
const myBatchStatus = computed(() => {
  const map = {}
  ;(myAppointments.value || []).forEach(item => {
    if (['0', '1', '4'].includes(item.status)) {
      map[item.batchId] = item.status
    }
  })
  return map
})

function isBooked(batchId) {
  return myBatchStatus.value[batchId] !== undefined
}

/** 按钮文案：已完成的写"已完成"，别跟"已预约"混为一谈 */
function applyLabel(batch) {
  const status = myBatchStatus.value[batch.id]
  if (status === '4') return '已完成'
  if (status !== undefined) return '已预约'
  return isFull(batch) ? '名额已满' : '预约'
}

function isFull(batch) {
  return Number(batch.bookedCount || 0) >= Number(batch.capacity || 0)
}

function remainOf(batch) {
  return Math.max(Number(batch.capacity || 0) - Number(batch.bookedCount || 0), 0)
}

function getMy() {
  loading.value = true
  listMyAppointments().then(res => {
    myAppointments.value = res.data || []
  }).finally(() => {
    loading.value = false
  })
}

function getOpenBatches() {
  batchLoading.value = true
  listOpenBatches().then(res => {
    openBatches.value = res.data || []
  }).finally(() => {
    batchLoading.value = false
  })
}

function loadAll() {
  getMy()
  getOpenBatches()
}

/** 提交预约：二次确认，避免误点 */
function handleApply(batch) {
  proxy.$modal.confirm(`确认预约「${batch.batchName}」吗？提交后需要校医审核。`).then(() => {
    return applyAppointment({ batchId: batch.id })
  }).then(() => {
    proxy.$modal.msgSuccess('预约已提交，请等待校医审核')
    loadAll()
  }).catch(() => {})
}

/** 取消预约：已通过的会释放名额，所以必须让用户确认 */
function handleCancel(row) {
  const tip = row.status === '1'
    ? `取消后名额会释放给其他同学，确认取消「${row.batchName}」的预约吗？`
    : `确认取消「${row.batchName}」的预约吗？`
  proxy.$modal.confirm(tip).then(() => {
    return cancelMyAppointment(row.id)
  }).then(() => {
    proxy.$modal.msgSuccess('已取消预约')
    loadAll()
  }).catch(() => {})
}

loadAll()
</script>

<style scoped>
.section {
  margin-bottom: 16px;
}

.section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
}

.section-hint {
  font-size: 12px;
  color: var(--el-text-color-placeholder);
}

.text-danger {
  color: var(--el-color-danger);
}

.text-muted {
  color: var(--el-text-color-placeholder);
}
</style>
