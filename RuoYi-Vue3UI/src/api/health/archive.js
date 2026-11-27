import request from '@/utils/request'

// 获取学生健康档案（学生信息 + 最新指标 + 历史记录）
export function getArchive(studentId) {
  return request({
    url: '/health/archive/' + studentId,
    method: 'get'
  })
}
