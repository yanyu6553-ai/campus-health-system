import request from '@/utils/request'

// 查询体检记录列表
export function listExamRecord(query) {
  return request({
    url: '/health/examRecord/list',
    method: 'get',
    params: query
  })
}

// 查询体检记录详细
export function getExamRecord(id) {
  return request({
    url: '/health/examRecord/' + id,
    method: 'get'
  })
}

// 新增体检记录
export function addExamRecord(data) {
  return request({
    url: '/health/examRecord',
    method: 'post',
    data: data
  })
}

// 修改体检记录
export function updateExamRecord(data) {
  return request({
    url: '/health/examRecord',
    method: 'put',
    data: data
  })
}

// 删除体检记录
export function delExamRecord(id) {
  return request({
    url: '/health/examRecord/' + id,
    method: 'delete'
  })
}
