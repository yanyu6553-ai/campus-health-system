import request from '@/utils/request'

// 查询体检预约列表
export function listAppointment(query) {
  return request({
    url: '/health/appointment/list',
    method: 'get',
    params: query
  })
}

// 查询体检预约详细
export function getAppointment(id) {
  return request({
    url: '/health/appointment/' + id,
    method: 'get'
  })
}

// 新增体检预约
export function addAppointment(data) {
  return request({
    url: '/health/appointment',
    method: 'post',
    data: data
  })
}

// 修改体检预约
export function updateAppointment(data) {
  return request({
    url: '/health/appointment',
    method: 'put',
    data: data
  })
}

// 审核体检预约（status=1 通过，status=2 拒绝）
export function auditAppointment(data) {
  return request({
    url: '/health/appointment/audit',
    method: 'put',
    data: data
  })
}

// 删除体检预约
export function delAppointment(id) {
  return request({
    url: '/health/appointment/' + id,
    method: 'delete'
  })
}
