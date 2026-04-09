NEW_FILE_CODE
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>操作日志 - 管理员中心</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/css/layui.css">
    <style>
        body { padding: 20px; background: #f5f5f5; }
        .layui-container { max-width: 1400px; }
        .layui-card { box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
        .layui-card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-size: 18px;
            font-weight: bold;
        }
        .operation-type {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .op-add { background: #e3fcef; color: #00a854; }
        .op-update { background: #e6f7ff; color: #1890ff; }
        .op-delete { background: #fff1f0; color: #f5222d; }
        .op-audit { background: #fff7e6; color: #fa8c16; }
        .target-badge {
            background: #f0f2f5;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            color: #666;
        }
    </style>
</head>
<body>
<div class="layui-container">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    📝 操作日志列表
                    <c:if test="${sessionScope.loginAdmin.username != 'admin'}">
                        <span style="font-size: 14px; opacity: 0.8; margin-left: 10px;">(仅显示我的操作)</span>
                    </c:if>
                </div>
                <div class="layui-card-body">
                    <!-- 筛选工具栏 -->
                    <div class="layui-form" style="margin-bottom: 20px;">
                        <div class="layui-form-item">
                            <label class="layui-form-label">目标类型</label>
                            <div class="layui-input-inline">
                                <select name="targetType" id="targetType">
                                    <option value="">全部</option>
                                    <option value="BOOK">图书</option>
                                    <option value="TEACHER">教师</option>
                                    <option value="BORROW">借阅</option>
                                    <option value="FINE">罚款</option>
                                    <option value="CATEGORY">分类</option>
                                    <option value="STOCK">库存</option>
                                    <option value="LOCATION">位置</option>
                                </select>
                            </div>
                            <button class="layui-btn layui-btn-normal" id="searchBtn">
                                <i class="layui-icon layui-icon-search"></i> 搜索
                            </button>
                        </div>
                    </div>

                    <!-- 表格 -->
                    <table id="logTable" lay-filter="logTable"></table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="operationTpl">
    {{#  if(d.operation === '新增') { }}
    <span class="operation-type op-add">➕ 新增</span>
    {{#  } else if(d.operation === '修改') { }}
    <span class="operation-type op-update">✏️ 修改</span>
    {{#  } else if(d.operation === '删除') { }}
    <span class="operation-type op-delete">🗑️ 删除</span>
    {{#  } else if(d.operation === '审核') { }}
    <span class="operation-type op-audit">📋 审核</span>
    {{#  } else { }}
    <span class="operation-type">{{ d.operation }}</span>
    {{#  } }}
</script>

<script type="text/html" id="targetTpl">
    <span class="target-badge">{{ d.targetType }}</span>
    <span style="margin-left: 8px;">{{ d.targetName || 'ID:' + d.targetId }}</span>
</script>

<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/layui.js"></script>
<script>
    layui.use(['table', 'laydate'], function(){
        var table = layui.table;
        var $ = layui.$;

        // 渲染表格
        var tableIns = table.render({
            elem: '#logTable',
            url: '/admin/log/data',
            page: {
                curr: 1,
                limit: 20,
                limits: [20, 50, 100]
            },
            cols: [[
                {field: 'id', title: 'ID', width: 80, sort: true},
                {field: 'adminName', title: '操作员', width: 120},
                {field: 'operation', title: '操作类型', width: 120, templet: '#operationTpl'},
                {field: 'targetType', title: '目标类型', width: 100, templet: '#targetTpl'},
                {field: 'targetId', title: '目标 ID', width: 90},
                {field: 'targetName', title: '目标名称', width: 200},
                {field: 'createTime', title: '操作时间', width: 180, sort: true}
            ]],
            skin: 'line',
            even: true,
            autoSort: false,
            done: function(res, curr, count){
                console.log('日志加载完成:', res.data.length);
            }
        });

        // 搜索功能
        $('#searchBtn').on('click', function(){
            var targetType = $('#targetType').val();

            tableIns.reload({
                where: {
                    targetType: targetType
                },
                page: {curr: 1}
            });
        });
    });
</script>
</body>
</html>
