<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>借阅管理 - 图书馆管理系统</title>
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

        .status-borrowing {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1976d2;
        }

        .status-returned {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
        }

        .status-overdue {
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

        .btn-renew {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #f57c00;
        }

        .btn-renew:hover {
            background: linear-gradient(135deg, #ffe0b2, #ffcc80);
            transform: translateY(-1px);
        }

        .btn-return {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .btn-return:hover {
            background: linear-gradient(135deg, #764ba2, #667eea);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .overdue-tag {
            background: #ffebee;
            color: #c62828;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            margin-left: 5px;
        }

        .teacher-info {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .teacher-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 14px;
        }

        .book-title {
            font-weight: 600;
            color: #2d3436;
        }

        .date-cell {
            text-align: center;
            color: #666;
            font-size: 13px;
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
    <h2>📝 借阅管理</h2>
    <div style="font-size: 13px; opacity: 0.9;">
        📊 管理所有借阅记录
    </div>
</div>

<div class="main-container">
    <div class="data-card">
        <div class="search-panel">
            <input type="text" name="teacherName" id="teacherName" placeholder="👤 教师姓名">
            <input type="text" name="bookTitle" id="bookTitle" placeholder="📖 书名">
            <select name="status" id="status">
                <option value="">全部状态</option>
                <option value="1">📚 借阅中</option>
                <option value="2">✅ 已归还</option>
                <option value="3">⏰ 逾期</option>
            </select>
            <button class="layui-btn layui-btn-primary" id="searchBtn">🔍 搜索</button>
        </div>

        <div class="table-container">
            <table class="layui-table" id="borrowTable" lay-filter="borrowTable">
                <thead>
                    <tr>
                        <th width="70">ID</th>
                        <th width="180">借阅人</th>
                        <th>图书名称</th>
                        <th width="110">借书日期</th>
                        <th width="110">应还日期</th>
                        <th width="110">实际归还</th>
                        <th width="90">状态</th>
                        <th width="80">续借次数</th>
                        <th width="150">操作</th>
                    </tr>
                </thead>
                <tbody id="borrowList"></tbody>
            </table>
        </div>

        <div id="pagination" class="pagination"></div>
    </div>
</div>

<script type="text/html" id="statusTpl">
    {{# if(d.status == 1){ }}
    <span class="status-badge status-borrowing">📚 借阅中</span>
    {{# } else if(d.status == 2){ }}
    <span class="status-badge status-returned">✅ 已归还</span>
    {{# } else { }}
    <span class="status-badge status-overdue">⏰ 逾期</span>
    {{# } }}
</script>

<script type="text/html" id="actionBar">
    {{# if(d.status === 1 || d.status === 3){ }}
    <button class="action-btn btn-renew" onclick="renewBook({{d.id}}, '{{d.bookTitle}}')">🔄 续借</button>
    <button class="action-btn btn-return" onclick="returnBook({{d.id}}, '{{d.bookTitle}}')">📚 归还</button>
    {{# } else { }}
    <span style="color: #999; font-size: 12px;">已完成</span>
    {{# } }}
</script>

<script>
var layer, tableUtil;
var currentPage = 1;
var tableIns;

function loadBorrows(page) {
    const params = {
        page: page,
        limit: 10,
        teacherName: $('#teacherName').val(),
        bookTitle: $('#bookTitle').val(),
        status: $('#status').val()
    };

    $.get('/admin/borrow/data', params, function(res) {
        if(res.code === 0) {
            const tbody = $('#borrowList');
            tbody.empty();

            if(res.data && res.data.length > 0) {
                res.data.forEach(function(borrow) {
                    var overdueHtml = '';
                    if(borrow.overdue_days && borrow.overdue_days > 0 && borrow.status !== 2) {
                        overdueHtml = ' <span class="overdue-tag">逾期' + borrow.overdue_days + '天</span>';
                    }

                    var row = '<tr>' +
                        '<td style="text-align:center; color: #999;">' + borrow.id + '</td>' +
                        '<td>' +
                            '<div class="teacher-info">' +
                                '<div class="teacher-avatar">' + borrow.teacherName.charAt(0) + '</div>' +
                                '<div>' +
                                    '<div style="font-weight: 600;">' + borrow.teacherName + '</div>' +
                                    '<div style="font-size: 12px; color: #999;">' + (borrow.teacherEmail || '-') + '</div>' +
                                '</div>' +
                            '</div>' +
                        '</td>' +
                        '<td><span class="book-title">📖 ' + borrow.bookTitle + '</span>' + overdueHtml + '</td>' +
                        '<td class="date-cell">' + formatDate(borrow.borrowDate) + '</td>' +
                        '<td class="date-cell">' + formatDate(borrow.dueDate) + '</td>' +
                        '<td class="date-cell">' + (borrow.returnDate ? formatDate(borrow.returnDate) : '<span style="color: #999;">-</span>') + '</td>' +
                        '<td style="text-align:center;"><span template="#statusTpl">' + getStatusBadge(borrow.status) + '</span></td>' +
                        '<td style="text-align:center; color: #666;">' + (borrow.renewCount || 0) + '</td>' +
                        '<td style="text-align:center;" template="#actionBar">' + getActionButtons(borrow) + '</td>' +
                    '</tr>';

                    tbody.append(row);
                });
            } else {
                tbody.append('<tr><td colspan="9"><div class="empty-state"><i>📝</i>暂无借阅记录</div></td></tr>');
            }

            tableIns = tableUtil.render({
                elem: '#borrowTable',
                page: false,
                limit: 10,
                data: res.data
            });

            layui.laypage.render({
                elem: 'pagination',
                count: res.count || 0,
                curr: page,
                limit: 10,
                layout: ['count', 'prev', 'page', 'next', 'limit', 'skip'],
                jump: function(obj, first){
                    if(!first){
                        currentPage = obj.curr;
                        loadBorrows(currentPage);
                    }
                }
            });
        }
    }).fail(function(xhr, status, error) {
        console.error('获取借阅数据失败:', error);
        $('#borrowList').html('<tr><td colspan="9"><div class="empty-state" style="color: red;">❌ 数据加载失败，请检查网络连接</div></td></tr>');
    });
}

function getStatusBadge(status) {
    if(status == 1) return '<span class="status-badge status-borrowing">📚 借阅中</span>';
    if(status == 2) return '<span class="status-badge status-returned">✅ 已归还</span>';
    return '<span class="status-badge status-overdue">⏰ 逾期</span>';
}

function getActionButtons(borrow) {
    if(borrow.status === 1 || borrow.status === 3) {
        return '<button class="action-btn btn-renew" onclick="renewBook(' + borrow.id + ', \'' + borrow.bookTitle + '\')">🔄 续借</button>' +
               '<button class="action-btn btn-return" onclick="returnBook(' + borrow.id + ', \'' + borrow.bookTitle + '\')">📚 归还</button>';
    }
    return '<span style="color: #999; font-size: 12px;">已完成</span>';
}

function formatDate(dateString) {
    if(!dateString) return '';
    var date = new Date(dateString);
    return date.getFullYear() + '-' +
           String(date.getMonth() + 1).padStart(2, '0') + '-' +
           String(date.getDate()).padStart(2, '0');
}

window.renewBook = function(id, bookTitle) {
    layer.confirm('📚 确定为《' + bookTitle + '》申请续借吗？', {
        icon: 3,
        title: '续借确认',
        btn: ['确定续借', '取消']
    }, function(index){
        $.ajax({
            url: '/borrow/applyRenew/' + id,
            type: 'POST',
            success: function(res){
                if(res.code === 0){
                    layer.msg('✅ ' + (res.msg || '续借成功'), {icon: 1, time: 1500});
                    loadBorrows(currentPage);
                } else {
                    layer.msg('❌ ' + (res.msg || '续借失败'), {icon: 2});
                }
            },
            error: function(){
                layer.msg('❌ 网络错误', {icon: 2});
            }
        });
        layer.close(index);
    });
};

window.returnBook = function(id, bookTitle) {
    layer.confirm('📚 确定归还《' + bookTitle + '》吗？', {
        icon: 3,
        title: '归还确认',
        btn: ['确认归还', '取消']
    }, function(index){
        $.ajax({
            url: '/return/doReturn/' + id,
            type: 'POST',
            success: function(res){
                if(res.code === 0){
                    layer.msg('✅ ' + (res.msg || '还书成功'), {icon: 1, time: 1500});
                    loadBorrows(currentPage);
                } else {
                    layer.msg('❌ ' + (res.msg || '还书失败'), {icon: 2});
                }
            },
            error: function(){
                layer.msg('❌ 网络错误', {icon: 2});
            }
        });
        layer.close(index);
    });
};

$(document).ready(function(){
    layui.use(['layer', 'laypage'], function(){
        layer = layui.layer;
        tableUtil = layui.table;

        $('#searchBtn').on('click', function(){
            currentPage = 1;
            loadBorrows(currentPage);
        });

        loadBorrows(currentPage);
    });
});
</script>
</body>
</html>
