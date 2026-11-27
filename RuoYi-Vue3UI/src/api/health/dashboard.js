import request from '@/utils/request'

// 首页数据看板汇总
export function getDashboardSummary() {
  return request({
    url: '/health/dashboard/summary',
    method: 'get'
  })
}
