<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书管理 - 图书馆管理系统</title>
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

        .search-form input, .search-form select {
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 8px 12px;
            font-size: 14px;
        }

        .search-form input:focus, .search-form select:focus {
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
            padding: 12px 8px;
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

        .status-normal {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
        }

        .status-disabled {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
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
    </style>
</head>
<body>
<div class="header">
    <h2>📚 图书管理</h2>
    <div style="font-size: 13px; opacity: 0.9;">
        📖 管理图书馆所有藏书
    </div>
</div>

<div class="main-container">
    <div class="toolbar">
        <button class="layui-btn layui-btn-normal" id="addBookBtn">➕ 新增图书</button>

        <form class="layui-form search-form" onsubmit="return false;">
            <input type="text" name="title" placeholder="图书名称" class="layui-input">
            <input type="text" name="author" placeholder="作者" class="layui-input">
            <input type="text" name="isbn" placeholder="ISBN" class="layui-input">
            <select name="categoryId" class="layui-input">
                <option value="">全部分类</option>
            </select>
            <button class="layui-btn layui-btn-primary" id="searchBtn">🔍 查询</button>
        </form>
    </div>

    <div class="data-card">
        <div class="table-container">
            <table class="layui-table" id="bookTable">
                <thead>
                    <tr>
                        <th width="60">ID</th>
                        <th width="150">ISBN</th>
                        <th>图书名称</th>
                        <th>作者</th>
                        <th>出版社</th>
                        <th width="100">分类</th>
                        <th width="120">库存</th>
                        <th width="80">状态</th>
                        <th width="180">操作</th>
                    </tr>
                </thead>
                <tbody id="bookList"></tbody>
            </table>
        </div>

        <div id="pagination" class="pagination"></div>
    </div>
</div>

<script>
layui.use(['layer', 'laypage', 'form'], function(){
    var layer = layui.layer;
    var laypage = layui.laypage;
    var form = layui.form;

    let currentPage = 1;

    function loadCategories() {
        $.get('/admin/category/list', function(res) {
            if(res.code === 0) {
                const select = $('select[name="categoryId"]');
                select.empty().append('<option value="">全部分类</option>');
                res.data.forEach(function(cat) {
                    select.append('<option value="' + cat.id + '">' + cat.name + '</option>');
                });
                form.render('select');
            }
        });
    }

    function loadBooks(page) {
        const params = {
            page: page,
            limit: 10,
            title: $('input[name="title"]').val(),
            author: $('input[name="author"]').val(),
            isbn: $('input[name="isbn"]').val(),
            categoryId: $('select[name="categoryId"]').val()
        };

        $.get('/admin/book/data', params, function(res) {
            if(res.code === 0) {
                const tbody = $('#bookList');
                tbody.empty();

                if(res.data && res.data.length > 0) {
                    res.data.forEach(function(book) {
                        var statusClass = book.status === 1 ? 'status-normal' : 'status-disabled';
                        var statusText = book.status === 1 ? '正常' : '禁用';

                        var row = '<tr>' +
                            '<td style="text-align:center; color: #999;">' + book.id + '</td>' +
                            '<td style="text-align:center; font-family: monospace;">' + book.isbn + '</td>' +
                            '<td style="text-align:left; padding-left: 15px; font-weight: 500;">' + book.title + '</td>' +
                            '<td style="text-align:left; padding-left: 15px;">' + book.author + '</td>' +
                            '<td style="text-align:left; padding-left: 15px; color: #666;">' + (book.publisher || '-') + '</td>' +
                            '<td style="text-align:center; color: #666;">' + (book.categoryName || '-') + '</td>' +
                            '<td style="text-align:center;"><span style="color: #667eea; font-weight: 500;">' + (book.availableQty || 0) + '</span> / <span style="color: #999;">' + (book.totalQty || 0) + '</span></td>' +
                            '<td style="text-align:center;"><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>' +
                            '<td style="text-align:center;">' +
                                '<button class="layui-btn layui-btn-sm" onclick="editBook(' + book.id + ')" style="background: linear-gradient(135deg, #667eea, #764ba2); border: none;">✏️ 编辑</button>' +
                                '<button class="layui-btn layui-btn-sm layui-btn-danger" onclick="deleteBook(' + book.id + ')">🗑️ 删除</button>' +
                            '</td>' +
                        '</tr>';

                        tbody.append(row);
                    });
                } else {
                    tbody.append('<tr><td colspan="9"><div class="empty-state"><i>📚</i>暂无图书数据</div></td></tr>');
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
                            loadBooks(currentPage);
                        }
                    }
                });
            }
        }).fail(function(xhr, status, error) {
            console.error('获取图书数据失败:', error);
            $('#bookList').html('<tr><td colspan="9"><div class="empty-state" style="color: red;">❌ 数据加载失败，请检查网络连接</div></td></tr>');
        });
    }

    window.editBook = function(id) {
        showEditForm(id);
    };

    window.deleteBook = function(id) {
        layer.confirm('确定要删除该图书吗？此操作不可恢复！', {
            icon: 3,
            title: '⚠️ 警告',
            btn: ['确认删除', '取消']
        }, function(index){
            $.ajax({
                url: '/admin/book/delete/' + id,
                type: 'DELETE',
                dataType: 'json',
                success: function(res) {
                    if(res.code === 0) {
                        layer.msg('✅ ' + (res.msg || '删除成功'), {icon: 1, time: 1500});
                        loadBooks(currentPage);
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

    $(document).ready(function(){
        loadCategories();
        loadBooks(currentPage);

        $('#searchBtn').click(function(){
            currentPage = 1;
            loadBooks(currentPage);
        });

        $('.search-form').on('submit', function(){
            currentPage = 1;
            loadBooks(currentPage);
            return false;
        });

        $('#addBookBtn').click(function(){
            showEditForm();
        });

        function showEditForm(id) {
            layer.open({
                type: 1,
                title: id ? '✏️ 编辑图书' : '➕ 新增图书',
                area: ['650px', '550px'],
                content: '<form class="layui-form" style="padding: 25px;" onsubmit="return false;">' +
                    '<input type="hidden" name="id" value="' + (id || '') + '">' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label"><span style="color: red;">*</span> ISBN</label>' +
                        '<div class="layui-input-block">' +
                            '<input type="text" name="isbn" required lay-verify="required" placeholder="请输入 ISBN 编号" class="layui-input" value="">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label"><span style="color: red;">*</span> 图书名称</label>' +
                        '<div class="layui-input-block">' +
                            '<input type="text" name="title" required lay-verify="required" placeholder="请输入图书名称" class="layui-input" value="">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label"><span style="color: red;">*</span> 作者</label>' +
                        '<div class="layui-input-block">' +
                            '<input type="text" name="author" required lay-verify="required" placeholder="请输入作者" class="layui-input" value="">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">出版社</label>' +
                        '<div class="layui-input-block">' +
                            '<input type="text" name="publisher" placeholder="请输入出版社" class="layui-input" value="">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">出版日期</label>' +
                        '<div class="layui-input-block">' +
                            '<input type="date" name="publishDate" class="layui-input" value="">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">价格 (元)</label>' +
                        '<div class="layui-input-block">' +
                            '<input type="number" name="price" step="0.01" placeholder="请输入价格" class="layui-input" value="">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label"><span style="color: red;">*</span> 分类</label>' +
                        '<div class="layui-input-block">' +
                            '<select name="categoryId" required lay-verify="required" class="layui-input">' +
                                '<option value="">请选择分类</option>' +
                            '</select>' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">简介</label>' +
                        '<div class="layui-input-block">' +
                            '<textarea name="summary" placeholder="请输入图书简介" class="layui-textarea" rows="3"></textarea>' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item" style="text-align: center; margin-top: 30px;">' +
                        '<button class="layui-btn save-btn" type="button" style="background: linear-gradient(135deg, #667eea, #764ba2); border: none; padding: 10px 40px;">💾 保存</button>' +
                        '<button type="reset" class="layui-btn layui-btn-primary" style="padding: 10px 40px; margin-left: 15px;">↩️ 重置</button>' +
                    '</div>' +
                '</form>',
                success: function(layero, index){
                    $.get('/admin/category/list', function(res) {
                        if(res.code === 0) {
                            const select = layero.find('select[name="categoryId"]');
                            select.empty();
                            res.data.forEach(function(cat) {
                                select.append('<option value="' + cat.id + '">' + cat.name + '</option>');
                            });
                            form.render('select');
                        }
                    });

                    if(id) {
                        $.get('/admin/book/edit/' + id, function(res) {
                            if(res.code === 0) {
                                const book = res.data;
                                layero.find('input[name="id"]').val(book.id);
                                layero.find('input[name="isbn"]').val(book.isbn);
                                layero.find('input[name="title"]').val(book.title);
                                layero.find('input[name="author"]').val(book.author);
                                layero.find('input[name="publisher"]').val(book.publisher);
                                if(book.publishDate) {
                                    layero.find('input[name="publishDate"]').val(new Date(book.publishDate).toISOString().substr(0, 10));
                                }
                                layero.find('input[name="price"]').val(book.price);
                                layero.find('select[name="categoryId"]').val(book.categoryId);
                                layero.find('textarea[name="summary"]').val(book.summary);
                                form.render('select');
                            }
                        });
                    }

                    layero.find('.save-btn').click(function(){
                        const formData = {};
                        layero.find('input,select,textarea').each(function(){
                            const $this = $(this);
                            formData[$this.attr('name')] = $this.val();
                        });

                        const url = formData.id ? '/admin/book/update' : '/admin/book/add';
                        const method = formData.id ? 'PUT' : 'POST';

                        $.ajax({
                            url: url,
                            type: method,
                            data: formData,
                            dataType: 'json',
                            success: function(res) {
                                if(res.code === 0) {
                                    layer.msg('✅ ' + (res.msg || '操作成功'), {icon: 1, time: 1500});
                                    layer.close(index);
                                    loadBooks(currentPage);
                                } else {
                                    layer.msg('❌ ' + (res.msg || '操作失败'), {icon: 2});
                                }
                            },
                            error: function() {
                                layer.msg('❌ 网络错误', {icon: 2});
                            }
                        });
                    });
                }
            });
        }
    });
});
</script>
</body>
</html>

