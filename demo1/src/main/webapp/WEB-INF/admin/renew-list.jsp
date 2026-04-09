<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>续借审核 - 图书馆管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
    <style>
        body { padding: 0; background-color: #f5f6fa; }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 30px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h2 { margin: 0; font-size: 24px; font-weight: 600; }

        .main-container { max-width: 1600px; margin: 0 auto; padding: 30px; }

        .data-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .search-panel {
            display: flex;
            gap: 12px;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .search-panel input, .search-panel select {
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 8px 12px;
            font-size: 14px;
            min-width: 140px;
        }

        .search-panel input:focus, .search-panel select:focus {
            border-color: #667eea;
            outline: none;
        }

        .layui-btn-primary {
            border: 1px solid #d2d2d2;
            background: white;
            padding: 8px 20px;
            border-radius: 6px;
        }

        .layui-btn-primary:hover {
            border-color: #667eea;
            color: #667eea;
        }

        .table-container { overflow-x: auto; }

        .layui-table {
            border-collapse: separate;
            border-spacing: 0;
        }

        .layui-table thead th {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            color: #495057;
            font-weight: 600;
            padding: 14px 8px;
            border-bottom: 2px solid #dee2e6;
            font-size: 14px;
        }

        .layui-table tbody td {
            padding: 15px 8px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
            vertical-align: middle;
        }

        .layui-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .status-pending {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #f57c00;
        }

        .status-approved {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
        }

        .status-rejected {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #c62828;
        }

        .action-btn {
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 12px;
            margin: 0 2px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            font-weight: 500;
        }

        .btn-approve {
            background: linear-gradient(135deg, #2e7d32, #4caf50);
            color: white;
        }

        .btn-approve:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(46, 125, 50, 0.3);
        }

        .btn-reject {
            background: linear-gradient(135deg, #c62828, #e53935);
            color: white;
        }

        .btn-reject:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(198, 40, 40, 0.3);
        }

        .book-info {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .book-title {
            font-weight: 600;
            color: #2d3436;
        }

        .book-isbn {
            font-size: 12px;
            color: #999;
            font-family: monospace;
        }

        .teacher-info {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .teacher-name {
            font-weight: 600;
            color: #2d3436;
        }

        .teacher-emp {
            font-size: 12px;
            color: #999;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 8px;
        }

        .layui-laypage a, .layui-laypage span {
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            margin: 0 2px;
        }

        .layui-laypage .layui-laypage-curr .layui-laypage-em {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 6px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state i {
            font-size: 64px;
            display: block;
            margin-bottom: 20px;
            opacity: 0.3;
        }
    </style>
</head>
<body>
<div class="header">
    <h2>🔄 续借审核</h2>
    <div style="font-size: 13px; opacity: 0.9;">
        📋 审批续借申请
    </div>
</div>

<div class="main-container">
    <div class="data-card">
        <div class="search-panel">
            <input type="text" name="teacherName" id="teacherName" placeholder="👤 教师姓名">
            <input type="text" name="bookTitle" id="bookTitle" placeholder="📖 图书名称">
            <select name="status" id="status">
                <option value="">全部状态</option>
                <option value="0">⏳ 待审核</option>
                <option value="1">✅ 已通过</option>
                <option value="2">❌ 已拒绝</option>
            </select>
            <button class="layui-btn layui-btn-primary" id="searchBtn">🔍 搜索</button>
        </div>

        <div class="table-container">
            <table class="layui-table" id="renewTable">
                <thead>
                    <tr>
                        <th width="70">ID</th>
                        <th width="180">申请人</th>
                        <th width="280">图书信息</th>
                        <th width="160">申请时间</th>
                        <th width="100">状态</th>
                        <th width="150">操作</th>
                    </tr>
                </thead>
                <tbody id="renewList"></tbody>
            </table>
        </div>

        <div id="pagination" class="pagination"></div>
    </div>
</div>

<script>
var layer, laypage;
var currentPage = 1;

function loadRenewApplications(page) {
    const params = {
        page: page,
        limit: 10,
        teacherName: $('#teacherName').val(),
        bookTitle: $('#bookTitle').val(),
        status: $('select[name="status"]').val()
    };

    $.get('/borrow/renew/data', params, function(res) {
        if(res.code === 0) {
            const tbody = $('#renewList');
            tbody.empty();

            if(res.data && res.data.length > 0) {
                for(let i = 0; i < res.data.length; i++) {
                    const app = res.data[i];
                    const statusBadge = getStatusBadge(app.status);

                    let actionButtons = '<span style="color: #999; font-size: 12px;">已完成</span>';
                    if (app.status === 0) {
                        actionButtons = '<button class="action-btn btn-approve" onclick="approveRenew(' + app.id + ', \'' + app.bookTitle + '\')">✅ 通过</button>' +
                                      '<button class="action-btn btn-reject" onclick="rejectRenew(' + app.id + ', \'' + app.bookTitle + '\')">❌ 拒绝</button>';
                    }

                    const row = '<tr>' +
                        '<td style="text-align:center; color: #999;">' + app.id + '</td>' +
                        '<td>' +
                            '<div class="teacher-info">' +
                                '<span class="teacher-name">👤 ' + app.teacherName + '</span>' +
                                '<span class="teacher-emp">' + app.empNo + '</span>' +
                            '</div>' +
                        '</td>' +
                        '<td>' +
                            '<div class="book-info">' +
                                '<span class="book-title">📖 ' + app.bookTitle + '</span>' +
                                '<span class="book-isbn">ISBN: ' + app.isbn + '</span>' +
                            '</div>' +
                        '</td>' +
                        '<td style="text-align:center; color: #666;">' + formatDate(app.applyDate) + '</td>' +
                        '<td style="text-align:center;">' + statusBadge + '</td>' +
                        '<td style="text-align:center;">' + actionButtons + '</td>' +
                    '</tr>';

                    tbody.append(row);
                }
            } else {
                tbody.append('<tr><td colspan="6"><div class="empty-state"><i>🔄</i>暂无续借申请</div></td></tr>');
            }

            laypage.render({
                elem: 'pagination',
                count: res.count || 0,
                curr: page,
                limit: 10,
                layout: ['count', 'prev', 'page', 'next', 'limit', 'skip'],
                jump: function(obj, first){
                    if(!first){
                        currentPage = obj.curr;
                        loadRenewApplications(currentPage);
                    }
                }
            });
        }
    }).fail(function(xhr, status, error) {
        console.error('获取续借数据失败:', error);
        $('#renewList').html('<tr><td colspan="6"><div class="empty-state" style="color: red;">❌ 数据加载失败，请检查网络连接</div></td></tr>');
    });
}

function getStatusBadge(status) {
    if(status == 0) return '<span class="status-badge status-pending">⏳ 待审核</span>';
    if(status == 1) return '<span class="status-badge status-approved">✅ 已通过</span>';
    return '<span class="status-badge status-rejected">❌ 已拒绝</span>';
}

window.approveRenew = function(id, bookTitle) {
    layer.confirm('📚 确定要通过《' + bookTitle + '》的续借申请吗？', {
        icon: 3,
        title: '通过确认',
        btn: ['确定通过', '取消']
    }, function(index){
        auditRenew(id, 1, '');
        layer.close(index);
    });
};

window.rejectRenew = function(id, bookTitle) {
    layer.prompt({
        formType: 2,
        value: '',
        title: '请输入拒绝原因',
        area: ['400px', '150px']
    }, function(value, index){
        if(value.trim() === '') {
            layer.msg('❌ 请输入拒绝原因', {icon: 2});
            return;
        }
        auditRenew(id, 2, value);
        layer.close(index);
    });
};

function auditRenew(id, status, remark) {
    $.ajax({
        url: '/borrow/renew/audit/' + id,
        type: 'POST',
        data: {
            status: status,
            remark: remark
        },
        dataType: 'json',
        success: function(res) {
            if(res.code === 0) {
                layer.msg('✅ ' + (res.msg || '操作成功'), {icon: 1, time: 1500});
                loadRenewApplications(currentPage);
            } else {
                layer.msg('❌ ' + (res.msg || '操作失败'), {icon: 2});
            }
        },
        error: function() {
            layer.msg('❌ 网络错误', {icon: 2});
        }
    });
}

function formatDate(dateString) {
    if(!dateString) return '';
    const date = new Date(dateString);
    return date.getFullYear() + '-' +
           String(date.getMonth() + 1).padStart(2, '0') + '-' +
           String(date.getDate()).padStart(2, '0') + ' ' +
           String(date.getHours()).padStart(2, '0') + ':' +
           String(date.getMinutes()).padStart(2, '0');
}

$(document).ready(function(){
    layui.use(['layer', 'laypage'], function(){
        layer = layui.layer;
        laypage = layui.laypage;

        $('#searchBtn').on('click', function(){
            currentPage = 1;
            loadRenewApplications(currentPage);
        });

        loadRenewApplications(currentPage);
    });
});
</script>
</body>
</html>

