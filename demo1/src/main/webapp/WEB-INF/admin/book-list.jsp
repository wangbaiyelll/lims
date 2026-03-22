<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
</head>
<body>
<div class="layui-container">
    <h2>📚 图书管理</h2>

    <div class="toolbar layui-form">
        <button class="layui-btn layui-btn-normal" id="addBookBtn">新增图书</button>
    </div>

    <form class="layui-form search-form" onsubmit="return false;">
        <input type="text" name="title" placeholder="图书名称" class="layui-input" style="width: 150px;">
        <input type="text" name="author" placeholder="作者" class="layui-input" style="width: 120px;">
        <input type="text" name="isbn" placeholder="ISBN" class="layui-input" style="width: 180px;">
        <select name="categoryId" class="layui-input" style="width: 120px;">
            <option value="">全部分类</option>
        </select>
        <button class="layui-btn layui-btn-primary" id="searchBtn">查询</button>
    </form>

    <table class="layui-table" id="bookTable">
        <thead>
            <tr>
                <th>ID</th>
                <th>ISBN</th>
                <th>图书名称</th>
                <th>作者</th>
                <th>出版社</th>
                <th>分类</th>
                <th>库存</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody id="bookList"></tbody>
    </table>

    <div id="pagination" style="text-align: center; margin-top: 20px;"></div>
</div>

<script>
    layui.use(['layer', 'laypage'], function(){
        var layer = layui.layer;
        var laypage = layui.laypage;

        let currentPage = 1;

        // 加载分类数据
        loadCategories();

        // 初始化表格数据
        loadBooks(currentPage);

        // 查询按钮点击事件
        $('#searchBtn').click(function(){
            currentPage = 1;
            loadBooks(currentPage);
        });

        // 新增图书按钮
        $('#addBookBtn').click(function(){
            showEditForm();
        });

        // 分页组件
        laypage.render({
            elem: 'pagination',
            count: 0,
            limit: 10,
            layout: ['count', 'prev', 'page', 'next', 'limit', 'skip'],
            jump: function(obj, first){
                if(!first){
                    currentPage = obj.curr;
                    loadBooks(currentPage);
                }
            }
        });

        function loadCategories() {
            $.get('/admin/category/data', function(res) {
                if(res.code === 0) {
                    const select = $('select[name="categoryId"]');
                    res.data.forEach(function(cat) {
                        select.append('<option value="' + cat.id + '">' + cat.name + '</option>');
                    });
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

                    res.data.forEach(function(book) {
                        var statusClass = book.status === 1 ? 'status-normal' : 'status-disabled';
                        var statusText = book.status === 1 ? '正常' : '禁用';

                        var row = '<tr>' +
                            '<td>' + book.id + '</td>' +
                            '<td>' + book.isbn + '</td>' +
                            '<td>' + book.title + '</td>' +
                            '<td>' + book.author + '</td>' +
                            '<td>' + book.publisher + '</td>' +
                            '<td>' + (book.categoryName || '-') + '</td>' +
                            '<td>可借:' + (book.availableQty || 0) + ', 总数:' + (book.totalQty || 0) + '</td>' +
                            '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>' +
                            '<td>' +
                                '<button class="layui-btn layui-btn-xs" onclick="editBook(' + book.id + ')">编辑</button>' +
                                '<button class="layui-btn layui-btn-danger layui-btn-xs" onclick="deleteBook(' + book.id + ')">删除</button>' +
                            '</td>' +
                            '</tr>';

                        tbody.append(row);
                    });

                    // 更新分页
                    laypage.render({
                        elem: 'pagination',
                        count: res.count,
                        curr: page,
                        limit: 10
                    });
                }
            });
        }

        function showEditForm(id) {
            layer.open({
                type: 1,
                title: id ? '编辑图书' : '新增图书',
                area: ['600px', '500px'],
                content: '<form class="layui-form" style="padding: 20px;" onsubmit="return false;">' +
                    '<input type="hidden" name="id" value="' + (id || '') + '">' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">ISBN</label>' +
                        '<div class="layui-input-block">' +
                            '<input type="text" name="isbn" required lay-verify="required" placeholder="请输入ISBN" class="layui-input" value="">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">图书名称</label>' +
                        '<div class="layui-input-block">' +
                            '<input type="text" name="title" required lay-verify="required" placeholder="请输入图书名称" class="layui-input" value="">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">作者</label>' +
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
                        '<label class="layui-form-label">价格</label>' +
                        '<div class="layui-input-block">' +
                            '<input type="number" name="price" step="0.01" placeholder="请输入价格" class="layui-input" value="">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">分类</label>' +
                        '<div class="layui-input-block">' +
                            '<select name="categoryId" required lay-verify="required" class="layui-input">' +
                                '<option value="">请选择分类</option>' +
                            '</select>' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">简介</label>' +
                        '<div class="layui-input-block">' +
                            '<textarea name="summary" placeholder="请输入图书简介" class="layui-textarea"></textarea>' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item" style="text-align: center;">' +
                        '<button class="layui-btn" lay-submit lay-filter="saveBook">保存</button>' +
                        '<button type="reset" class="layui-btn layui-btn-primary">重置</button>' +
                    '</div>' +
                '</form>',
                success: function(layero, index){
                    // 加载分类选项
                    $.get('/admin/category/data', function(res) {
                        if(res.code === 0) {
                            const select = layero.find('select[name="categoryId"]');
                            res.data.forEach(function(cat) {
                                select.append('<option value="' + cat.id + '">' + cat.name + '</option>');
                            });
                        }
                    });

                    // 如果是编辑模式，加载现有数据
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
                            }
                        });
                    }

                    // 表单提交事件
                    layui.form.on('submit(saveBook)', function(data){
                        const url = data.field.id ? '/admin/book/update' : '/admin/book/add';
                        const method = data.field.id ? 'PUT' : 'POST';

                        $.ajax({
                            url: url,
                            type: method,
                            data: data.field,
                            dataType: 'json',
                            success: function(res) {
                                if(res.code === 0) {
                                    layer.msg(res.msg || '操作成功', {icon: 1});
                                    layer.close(index);
                                    loadBooks(currentPage);
                                } else {
                                    layer.msg(res.msg || '操作失败', {icon: 2});
                                }
                            },
                            error: function() {
                                layer.msg('网络错误', {icon: 2});
                            }
                        });

                        return false;
                    });
                }
            });
        }

        function editBook(id) {
            showEditForm(id);
        }

        function deleteBook(id) {
            layer.confirm('确定要删除该图书吗？', {
                icon: 3,
                title: '提示'
            }, function(index){
                $.ajax({
                    url: '/admin/book/delete/' + id,
                    type: 'DELETE',
                    dataType: 'json',
                    success: function(res) {
                        if(res.code === 0) {
                            layer.msg(res.msg || '删除成功', {icon: 1});
                            loadBooks(currentPage);
                        } else {
                            layer.msg(res.msg || '删除失败', {icon: 2});
                        }
                    },
                    error: function() {
                        layer.msg('网络错误', {icon: 2});
                    }
                });
                layer.close(index);
            });
        }
    });
</script>
</body>
</html>

