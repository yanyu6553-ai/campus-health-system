import request from '@/utils/request'

// 查询体检批次列表
export function listExamBatch(query) {
  return request({
    url: '/health/examBatch/list',
    method: 'get',
    params: query
  })
}

// 查询体检批次详细
export function getExamBatch(id) {
  return request({
    url: '/health/examBatch/' + id,
    method: 'get'
  })
}

// 新增体检批次
export function addExamBatch(data) {
  return request({
    url: '/health/examBatch',
    method: 'post',
    data: data
  })
}

// 修改体检批次
export function updateExamBatch(data) {
  return request({
    url: '/health/examBatch',
    method: 'put',
    data: data
  })
}

// 删除体检批次
export function delExamBatch(id) {
  return request({
    url: '/health/examBatch/' + id,
    method: 'delete'
  })
}
