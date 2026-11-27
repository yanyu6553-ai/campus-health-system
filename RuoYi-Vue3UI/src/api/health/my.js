import request from '@/utils/request'

/**
 * 学生端接口
 *
 * 这里所有方法都不传 studentId —— 后端根据登录态（token）反查学生档案，
 * 前端即使想查别人也查不到，这是"学生不能查看他人档案"的实现方式。
 */

/** 我的预约记录 */
export function listMyAppointments() {
  return request({
    url: '/health/appointment/my',
    method: 'get'
  })
}

/** 可预约的批次（只返回预约中的） */
export function listOpenBatches() {
  return request({
    url: '/health/examBatch/open',
    method: 'get'
  })
}

/** 提交预约，只需 batchId */
export function applyAppointment(data) {
  return request({
    url: '/health/appointment/apply',
    method: 'post',
    data: data
  })
}

/** 取消我的预约 */
export function cancelMyAppointment(id) {
  return request({
    url: '/health/appointment/cancel/' + id,
    method: 'put'
  })
}

/** 我的健康档案（学生信息 + 最新指标 + 历史记录） */
export function getMyArchive() {
  return request({
    url: '/health/archive/my',
    method: 'get'
  })
}

/** 我的体检记录 */
export function listMyRecords() {
  return request({
    url: '/health/examRecord/my',
    method: 'get'
  })
}

/** 我的 AI 健康评估报告（含待评估/评估中/已完成） */
export function listMyAiAssessment() {
  return request({
    url: '/health/ai/my',
    method: 'get'
  })
}
