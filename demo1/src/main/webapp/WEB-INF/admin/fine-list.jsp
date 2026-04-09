<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>罚款管理 - 图书馆管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
    <style>
        body {
            padding: 0;
            background-color: #f5f6fa;
        }

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

        .main-container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 30px;
        }

        .data-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .card-title {
            font-size: 20px;
            font-weight: 600;
            color: #2d3436;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn-group {
            display: flex;
            gap: 10px;
        }

        .layui-btn-normal {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            padding: 10px 24px;
            border-radius: 6px;
            font-weight: 500;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .layui-btn-normal:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .layui-btn-danger {
            background: linear-gradient(135deg, #ef5350, #e53935);
            border: none;
        }

        .search-panel {
            display: flex;
            gap: 12px;
            align-items: center;
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

        .table-container { overflow-x: auto; }

        .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .status-unpaid {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #c62828;
        }

        .status-paid {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
        }

        .amount-badge {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #f57c00;
            padding: 4px 10px;
            border-radius: 8px;
            font-weight: 600;
            display: inline-block;
        }

        .overdue-days {
            background: #ffebee;
            color: #c62828;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            margin-left: 5px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 8px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
    </style>
</head>
<body>
<div class="header">
    <h2>💰 罚款管理</h2>
    <div style="font-size: 13px; opacity: 0.9;">
        📋 管理罚款记录
    </div>
</div>

<div class="main-container">
    <div class="data-card">
        <div class="toolbar">
            <div class="btn-group">
                <button class="layui-btn layui-btn-normal" id="exportBtn">📊 导出记录</button>
                <button class="layui-btn layui-btn-danger" id="batchClearBtn">🗑️ 批量清除</button>
            </div>

            <div class="search-panel">
                <input type="text" name="teacherName" id="teacherName" placeholder="👤 教师姓名">
                <select name="status" id="status">
                    <option value="">全部状态</option>
                    <option value="0">💳 未支付</option>
                    <option value="1">✅ 已支付</option>
                </select>
                <button class="layui-btn layui-btn-primary" id="searchBtn">🔍 搜索</button>
            </div>
        </div>

        <div class="table-container">
            <table class="layui-table" id="fineTable" lay-filter="fineTable">
                <thead>
                    <tr>
                        <th width="50"><input type="checkbox" id="selectAll" lay-skin="primary"></th>
                        <th width="70">ID</th>
                        <th width="120">教师姓名</th>
                        <th width="250">图书名称</th>
                        <th width="100">罚款金额</th>
                        <th width="110">生成日期</th>
                        <th width="90">逾期天数</th>
                        <th width="80">状态</th>
                        <th width="110">支付日期</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="pagination" class="pagination"></div>
    </div>
</div>

<script type="text/html" id="statusTpl">
    {{# if(d.status == 0){ }}
    <span class="status-badge status-unpaid">💳 未支付</span>
    {{# } else { }}
    <span class="status-badge status-paid">✅ 已支付</span>
    {{# } }}
</script>

<script>
var layer, tableUtil, formUtil;
var currentPage = 1;

layui.use(['table', 'form', 'layer', 'laypage'], function(){
    tableUtil = layui.table;
    formUtil = layui.form;
    layer = layui.layer;

    loadFines(1);

    $('#searchBtn').on('click', function(){
        currentPage = 1;
        loadFines(currentPage);
    });

    $('#exportBtn').on('click', function(){
        layer.msg('✅ 导出功能开发中...', {icon: 1});
    });

    $('#batchClearBtn').on('click', function(){
        var checked = $('input[name="fineId"]:checked');
        if(checked.length === 0){
            layer.msg('❌ 请至少选择一条记录', {icon: 2});
            return;
        }

        var ids = [];
        checked.each(function(){
            ids.push($(this).val());
        });

        layer.confirm('⚠️ 确定要清除选中的 ' + ids.length + ' 条罚款记录吗？', {
            icon: 3,
            title: '警告',
            btn: ['确认清除', '取消']
        }, function(index){
            layer.msg('✅ 清除成功', {icon: 1, time: 1500});
            loadFines(currentPage);
            layer.close(index);
        });
    });

    $('#selectAll').on('click', function(){
        var checked = this.checked;
        $('input[name="fineId"]').each(function(){
            this.checked = checked;
        });
        formUtil.render('checkbox');
    });
});

function loadFines(page) {
    const params = {
        page: page,
        limit: 10
    };

    // 获取搜索条件，空值不传递
    var teacherName = $('#teacherName').val().trim();
    var status = $('#status').val();

    if (teacherName && teacherName !== '') {
        params.teacherName = teacherName;
    }

    if (status !== '' && status !== null && status !== undefined) {
        params.status = parseInt(status);
    }

    $.ajax({
        url: '/fine/data',
        type: 'GET',
        data: params,
        success: function(res) {
            console.log('✅ 响应数据:', res);

            if(res.code === 0) {
                const tbody = $('#fineTable tbody');
                tbody.empty();

                if(res.data && res.data.length > 0) {
                    res.data.forEach(function(fine) {
                        var row = '<tr>' +
                            '<td style="text-align:center;"><input type="checkbox" name="fineId" value="' + fine.id + '" lay-skin="primary"></td>' +
                            '<td style="text-align:center; color: #999;">' + fine.id + '</td>' +
                            '<td style="text-align:center;">' + (fine.teacherName || '-') + '</td>' +
                            '<td>📖 ' + (fine.bookTitle || '-') + (fine.dueDays > 0 ? '<span class="overdue-days">逾期' + fine.dueDays + '天</span>' : '') + '</td>' +
                            '<td style="text-align:center;"><span class="amount-badge">¥' + parseFloat(fine.amount).toFixed(2) + '</span></td>' +
                            '<td style="text-align:center; font-size: 12px;">' + formatDate(fine.fineDate) + '</td>' +
                            '<td style="text-align:center;">' + (fine.dueDays || 0) + '</td>' +
                            '<td style="text-align:center;">' + getStatusBadge(fine.status) + '</td>' +
                            '<td style="text-align:center; font-size: 12px;">' + (fine.payDate ? formatDate(fine.payDate) : '-') + '</td>' +
                        '</tr>';

                        tbody.append(row);
                    });

                    formUtil.render('checkbox');
                } else {
                    tbody.append('<tr><td colspan="9"><div class="empty-state"><i>💰</i>暂无罚款记录</div></td></tr>');
                }

                layui.laypage.render({
                    elem: 'pagination',
                    count: res.count || 0,
                    curr: page,
                    limit: 10,
                    layout: ['count', 'prev', 'page', 'next', 'limit', 'skip'],
                    jump: function(obj, first){
                        if(!first){
                            currentPage = obj.curr;
                            loadFines(currentPage);
                        }
                    }
                });
            } else {
                console.error('❌ 业务错误:', res.msg);
                layer.msg(res.msg || '加载失败', {icon: 2});
            }
        },
        error: function(xhr, status, error) {
            console.error('=== HTTP 错误详情 ===');
            console.error('状态码:', xhr.status);
            console.error('错误信息:', error);
            console.error('响应内容:', xhr.responseText);
            console.error('====================');

            $('#fineTable tbody').html('<tr><td colspan="9"><div class="empty-state" style="color: red;">❌ 数据加载失败 - ' + xhr.status + ': ' + error + '</div></td></tr>');
            layer.msg('服务器错误：' + xhr.status, {icon: 2, time: 3000});
        }
    });
}

function getStatusBadge(status) {
    if(status == 0) return '<span class="status-badge status-unpaid">💳 未支付</span>';
    return '<span class="status-badge status-paid">✅ 已支付</span>';
}

function formatDate(dateString) {
    if(!dateString) return '';
    var date = new Date(dateString);
    return date.getFullYear() + '-' +
           String(date.getMonth() + 1).padStart(2, '0') + '-' +
           String(date.getDate()).padStart(2, '0') + ' ' +
           String(date.getHours()).padStart(2, '0') + ':' +
           String(date.getMinutes()).padStart(2, '0');
}
</script>
</body>
</html>
