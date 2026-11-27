import request from '@/utils/request'

// 查询体检项目列表
export function listExamItem(query) {
  return request({
    url: '/health/examItem/list',
    method: 'get',
    params: query
  })
}

// 查询全部启用的体检项目（体检登记页取参考范围用）
export function listEnabledExamItem() {
  return request({
    url: '/health/examItem/enabled',
    method: 'get'
  })
}

// 查询体检项目详细
export function getExamItem(id) {
  return request({
    url: '/health/examItem/' + id,
    method: 'get'
  })
}

// 新增体检项目
export function addExamItem(data) {
  return request({
    url: '/health/examItem',
    method: 'post',
    data: data
  })
}

// 修改体检项目
export function updateExamItem(data) {
  return request({
    url: '/health/examItem',
    method: 'put',
    data: data
  })
}

// 删除体检项目
export function delExamItem(id) {
  return request({
    url: '/health/examItem/' + id,
    method: 'delete'
  })
}
