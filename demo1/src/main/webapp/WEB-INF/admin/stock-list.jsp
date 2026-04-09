<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存管理 - 图书馆管理系统</title>
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

        .toolbar {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .search-form {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .search-form input {
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 8px 12px;
            font-size: 14px;
        }

        .search-form input:focus {
            border-color: #667eea;
            outline: none;
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

        .data-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
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

        .book-info {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .book-title {
            font-weight: 600;
            color: #2d3436;
            font-size: 14px;
        }

        .book-isbn {
            font-size: 12px;
            color: #999;
            font-family: monospace;
        }

        .qty-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            border-radius: 20px;
            background: #f8f9fa;
            font-size: 13px;
        }

        .qty-available {
            color: #667eea;
            font-weight: 600;
        }

        .qty-total {
            color: #999;
        }

        .status-indicator {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 5px;
        }

        .status-in-stock {
            background: #28a745;
        }

        .status-low-stock {
            background: #ffc107;
        }

        .status-out-of-stock {
            background: #dc3545;
        }

        .location-tag {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1976d2;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .layui-btn-xs {
            padding: 4px 10px;
            font-size: 12px;
            border-radius: 4px;
            margin: 0 2px;
        }

        .layui-btn {
            border-radius: 6px;
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

        .layui-layer-title {
            background: linear-gradient(135deg, #667eea, #764ba2) !important;
            color: white !important;
            font-weight: 600;
        }

        .layui-form-label {
            width: 100px;
        }

        .layui-input-block {
            margin-left: 130px;
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

        .adjust-type-selector {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin: 20px 0;
        }

        .adjust-option {
            flex: 1;
            padding: 20px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .adjust-option:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .adjust-option.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, #e8eaff, #d6d9ff);
        }

        .adjust-icon {
            font-size: 32px;
            display: block;
            margin-bottom: 8px;
        }

        .adjust-label {
            font-weight: 600;
            color: #2d3436;
        }
    </style>
</head>
<body>
<div class="header">
    <h2>📦 库存管理</h2>
    <div style="font-size: 13px; opacity: 0.9;">
        📊 管理图书库存与位置
    </div>
</div>

<div class="main-container">
    <div class="toolbar">
        <button class="layui-btn layui-btn-normal" id="addStockBtn">➕ 新增库存</button>

        <form class="layui-form search-form" onsubmit="return false;">
            <input type="text" name="bookTitle" placeholder="🔍 图书名称" class="layui-input">
            <button class="layui-btn layui-btn-primary" id="searchBtn">查询</button>
        </form>
    </div>

    <div class="data-card">
        <div class="table-container">
            <table class="layui-table" id="stockTable">
                <thead>
                    <tr>
                        <th width="80">ID</th>
                        <th width="300">图书信息</th>
                        <th width="120">存放位置</th>
                        <th width="150">库存数量</th>
                        <th width="120">最后入库时间</th>
                        <th width="180">操作</th>
                    </tr>
                </thead>
                <tbody id="stockList"></tbody>
            </table>
        </div>

        <div id="pagination" class="pagination"></div>
    </div>
</div>

<script>
var layer, laypage;
var currentPage = 1;

function loadStocks(page) {
    const params = {
        page: page,
        limit: 10,
        bookTitle: $('input[name="bookTitle"]').val()
    };

    $.get('/admin/stock/list', params, function(res) {
        if(res.code === 0) {
            const tbody = $('#stockList');
            tbody.empty();

            if(res.data && res.data.length > 0) {
                res.data.forEach(function(stock) {
                    var statusClass = 'status-in-stock';
                    var statusText = '充足';

                    if(stock.availableQty == 0) {
                        statusClass = 'status-out-of-stock';
                        statusText = '缺货';
                    } else if(stock.availableQty <= 2) {
                        statusClass = 'status-low-stock';
                        statusText = '紧张';
                    }

                    var row = '<tr>' +
                        '<td style="text-align:center; color: #999;">' + stock.id + '</td>' +
                        '<td>' +
                            '<div class="book-info">' +
                                '<span class="book-title">📖 ' + stock.bookTitle + '</span>' +
                                '<span class="book-isbn">ISBN: ' + stock.isbn + '</span>' +
                            '</div>' +
                        '</td>' +
                        '<td><span class="location-tag">📍 ' + stock.locationCode + '</span></td>' +
                        '<td>' +
                            '<div class="qty-badge">' +
                                '<span class="status-indicator ' + statusClass + '"></span>' +
                                '<span class="qty-available">可借：' + stock.availableQty + '</span>' +
                                '<span style="color: #ddd;">|</span>' +
                                '<span class="qty-total">总数：' + stock.totalQty + '</span>' +
                            '</div>' +
                        '</td>' +
                        '<td style="text-align:center; color: #666;">' + formatDate(stock.lastInDate) + '</td>' +
                        '<td style="text-align:center;">' +
                            '<button class="layui-btn layui-btn-sm" onclick="showAdjustPanel(' + stock.id + ')" style="background: linear-gradient(135deg, #667eea, #764ba2); border: none;">🔄 调整</button>' +
                            '<button class="layui-btn layui-btn-sm layui-btn-danger" onclick="deleteStock(' + stock.id + ')">🗑️ 删除</button>' +
                        '</td>' +
                    '</tr>';
                    tbody.append(row);
                });
            } else {
                tbody.append('<tr><td colspan="6"><div class="empty-state"><i>📦</i>暂无库存数据</div></td></tr>');
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
                        loadStocks(currentPage);
                    }
                }
            });
        }
    }).fail(function(xhr, status, error) {
        console.error('获取库存数据失败:', error);
        $('#stockList').html('<tr><td colspan="6"><div class="empty-state" style="color: red;">❌ 数据加载失败，请检查网络连接</div></td></tr>');
    });
}

function showAddStockForm() {
    layer.open({
        type: 1,
        title: '➕ 新增库存',
        area: ['550px', '450px'],
        content: '<form class="layui-form" style="padding: 25px;" onsubmit="return false;">' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label"><span style="color: red;">*</span> 选择图书</label>' +
                '<div class="layui-input-block">' +
                    '<select name="bookId" required lay-verify="required" class="layui-input" id="bookSelect">' +
                        '<option value="">请选择图书</option>' +
                    '</select>' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label"><span style="color: red;">*</span> 位置</label>' +
                '<div class="layui-input-block">' +
                    '<select name="locationId" required lay-verify="required" class="layui-input" id="locationSelect">' +
                        '<option value="">请选择位置</option>' +
                    '</select>' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label"><span style="color: red;">*</span> 数量</label>' +
                '<div class="layui-input-block">' +
                    '<input type="number" name="totalQty" required lay-verify="required" min="1" value="1" class="layui-input">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label"><span style="color: red;">*</span> 入库日期</label>' +
                '<div class="layui-input-block">' +
                    '<input type="date" name="lastInDate" required lay-verify="required" class="layui-input" value="' + new Date().toISOString().split('T')[0] + '">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item" style="text-align: center; margin-top: 30px;">' +
                '<button class="layui-btn save-btn" type="button" style="background: linear-gradient(135deg, #667eea, #764ba2); border: none; padding: 10px 40px;">💾 保存</button>' +
                '<button type="reset" class="layui-btn layui-btn-primary" style="padding: 10px 40px; margin-left: 15px;">↩️ 重置</button>' +
            '</div>' +
        '</form>',
        success: function(layero, index){
            loadBooksAndLocations();

            setTimeout(function(){
                layui.form.render('select');
            }, 100);

            layero.find('.save-btn').click(function(){
                const formData = {};
                layero.find('input,select,textarea').each(function(){
                    const $this = $(this);
                    formData[$this.attr('name')] = $this.val();
                });

                $.ajax({
                    url: '/admin/stock/add',
                    type: 'POST',
                    data: formData,
                    dataType: 'json',
                    success: function(res) {
                        if(res.code === 0) {
                            layer.msg('✅ ' + (res.msg || '添加成功'), {icon: 1, time: 1500});
                            layer.close(index);
                            loadStocks(currentPage);
                        } else {
                            layer.msg('❌ ' + (res.msg || '添加失败'), {icon: 2});
                        }
                    },
                    error: function(xhr, status, error) {
                        console.log('请求错误详情:', xhr.responseText);
                        layer.msg('❌ 网络错误或服务器异常', {icon: 2});
                    }
                });
            });
        }
    });
}

window.showAdjustPanel = function(stockId) {
    layer.open({
        type: 1,
        title: '🔄 调整库存',
        area: ['450px', '380px'],
        content: '<div class="layui-form" style="padding: 25px;">' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">调整类型</label>' +
                '<div class="layui-input-block">' +
                    '<div class="adjust-type-selector">' +
                        '<div class="adjust-option selected" data-value="in">' +
                            '<span class="adjust-icon">📥</span>' +
                            '<span class="adjust-label">入库</span>' +
                        '</div>' +
                        '<div class="adjust-option" data-value="out">' +
                            '<span class="adjust-icon">📤</span>' +
                            '<span class="adjust-label">出库</span>' +
                        '</div>' +
                    '</div>' +
                    '<input type="hidden" name="adjustType" value="in">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">调整数量</label>' +
                '<div class="layui-input-block">' +
                    '<input type="number" name="quantity" min="1" value="1" class="layui-input" style="font-size: 16px; padding: 10px;">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item" style="text-align: center; margin-top: 30px;">' +
                '<button class="layui-btn confirm-adjust" type="button" style="background: linear-gradient(135deg, #667eea, #764ba2); border: none; padding: 10px 40px;">✅ 确认调整</button>' +
                '<button type="button" class="layui-btn layui-btn-primary cancel-adjust" style="padding: 10px 40px; margin-left: 15px;">✖ 取消</button>' +
            '</div>' +
        '</div>',
        success: function(layero, index){
            $('.adjust-option').click(function(){
                $('.adjust-option').removeClass('selected');
                $(this).addClass('selected');
                layero.find('input[name="adjustType"]').val($(this).data('value'));
            });

            layero.find('.confirm-adjust').click(function(){
                const adjustType = layero.find('input[name="adjustType"]').val();
                const quantity = parseInt(layero.find('input[name="quantity"]').val());

                if(isNaN(quantity) || quantity <= 0) {
                    layer.msg('❌ 请输入有效的数量', {icon: 2});
                    return;
                }

                const change = adjustType === 'in' ? quantity : -quantity;

                $.ajax({
                    url: '/admin/stock/adjust/' + stockId + '/' + change,
                    type: 'PUT',
                    dataType: 'json',
                    success: function(res) {
                        if(res.code === 0) {
                            layer.msg('✅ ' + (res.msg || '调整成功'), {icon: 1, time: 1500});
                            layer.close(index);
                            loadStocks(currentPage);
                        } else {
                            layer.msg('❌ ' + (res.msg || '调整失败'), {icon: 2});
                        }
                    },
                    error: function() {
                        layer.msg('❌ 网络错误', {icon: 2});
                    }
                });
            });

            layero.find('.cancel-adjust').click(function(){
                layer.close(index);
            });
        }
    });
};

window.deleteStock = function(id) {
    layer.confirm('⚠️ 确定要删除该库存记录吗？此操作不可恢复！', {
        icon: 3,
        title: '警告',
        btn: ['确认删除', '取消']
    }, function(index){
        $.ajax({
            url: '/admin/stock/delete/' + id,
            type: 'DELETE',
            dataType: 'json',
            success: function(res) {
                if(res.code === 0) {
                    layer.msg('✅ ' + (res.msg || '删除成功'), {icon: 1, time: 1500});
                    loadStocks(currentPage);
                } else {
                    layer.msg('❌ ' + (res.msg || '删除失败'), {icon: 2});
                }
            },
            error: function() {
                layer.msg('❌ 网络错误', {icon: 2});
            }
        });
        layer.close(index);
    });
};

function loadBooksAndLocations() {
    $.get('/admin/book/data', {page: 1, limit: 100, bookTitle: ''}, function(res) {
        if(res.code === 0) {
            const select = $('#bookSelect');
            select.empty();
            select.append('<option value="">请选择图书</option>');
            res.data.forEach(function(book) {
                select.append('<option value="' + book.id + '">' + book.title + '</option>');
            });
        }
    });

    $.get('/admin/location/list', {}, function(res) {
        if(res.code === 0) {
            const select = $('#locationSelect');
            select.empty();
            select.append('<option value="">请选择位置</option>');
            res.data.forEach(function(location) {
                select.append('<option value="' + location.id + '">' + location.positionCode + '</option>');
            });
        }
    });
}

function formatDate(dateString) {
    if(!dateString) return '';
    const date = new Date(dateString);
    return date.getFullYear() + '-' +
           String(date.getMonth() + 1).padStart(2, '0') + '-' +
           String(date.getDate()).padStart(2, '0');
}

$(document).ready(function(){
    $('#searchBtn').click(function(){
        currentPage = 1;
        loadStocks(currentPage);
    });

    $('#addStockBtn').click(function(){
        showAddStockForm();
    });

    loadStocks(currentPage);
});

layui.use(['layer', 'laypage'], function(){
    layer = layui.layer;
    laypage = layui.laypage;
});
</script>
</body>
</html>
