import request from '@/utils/request'

// 查询AI健康评估列表
export function listAiAssessment(query) {
  return request({
    url: '/health/ai/list',
    method: 'get',
    params: query
  })
}

// 按体检记录查询已生成的评估结果
export function getAiAssessmentByRecord(examRecordId) {
  return request({
    url: '/health/ai/byRecord/' + examRecordId,
    method: 'get'
  })
}

// 查询AI健康评估详细
export function getAiAssessment(id) {
  return request({
    url: '/health/ai/' + id,
    method: 'get'
  })
}

// 对体检记录生成AI评估
// 大模型分析需要数秒到数十秒，单独放宽超时（默认 10 秒会直接失败）
// 免费路由偶发失败时后端会重试，最多三次，所以这里留足 4 分钟
export function assessHealth(examRecordId) {
  return request({
    url: '/health/ai/assess/' + examRecordId,
    method: 'post',
    timeout: 240000
  })
}

// 删除AI健康评估
export function delAiAssessment(id) {
  return request({
    url: '/health/ai/' + id,
    method: 'delete'
  })
}
