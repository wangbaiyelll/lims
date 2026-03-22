<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <style>
        body { padding: 20px; }
        .toolbar { margin-bottom: 20px; }
        .search-form { display: flex; gap: 10px; margin-bottom: 20px; }
        .layui-table { margin-top: 15px; }
        .adjust-panel {
            padding: 15px;
            background: #f8f8f8;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .adjust-input {
            width: 100px;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div class="layui-container">
    <h2>📦 库存管理</h2>

    <div class="toolbar layui-form">
        <button class="layui-btn layui-btn-normal" id="addStockBtn">新增库存</button>
    </div>

    <form class="layui-form search-form" onsubmit="return false;">
        <input type="text" name="bookTitle" placeholder="图书名称" class="layui-input" style="width: 150px;">
        <button class="layui-btn layui-btn-primary" id="searchBtn">查询</button>
    </form>

    <table class="layui-table" id="stockTable">
        <thead>
        <tr>
            <th>图书信息</th>
            <th>位置</th>
            <th>总数量</th>
            <th>可用数量</th>
            <th>最后入库时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="stockList"></tbody>
    </table>

    <div id="pagination" style="text-align: center; margin-top: 20px;"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script>
    layui.use(['layer', 'laypage'], function(){
        var layer = layui.layer;
        var laypage = layui.laypage;

        let currentPage = 1;

        // 初始化表格数据
        loadStocks(currentPage);

        // 查询按钮点击事件
        $('#searchBtn').click(function(){
            currentPage = 1;
            loadStocks(currentPage);
        });

        // 新增库存按钮
        $('#addStockBtn').click(function(){
            showAddStockForm();
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
                    loadStocks(currentPage);
                }
            }
        });

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

                    res.data.forEach(stock => {
                        tbody.append(\`
                            <tr>
                                <td>
                                    <strong>\${stock.bookTitle}</strong><br>
                                    ISBN: \${stock.isbn}
                                </td>
                                <td>\${stock.locationCode}</td>
                                <td>\${stock.totalQty}</td>
                                <td>\${stock.availableQty}</td>
                                <td>\${formatDate(stock.lastInDate)}</td>
                                <td>
                                    <button class="layui-btn layui-btn-xs" onclick="showAdjustPanel(\${stock.id})">调整</button>
                                    <button class="layui-btn layui-btn-danger layui-btn-xs" onclick="deleteStock(\${stock.id})">删除</button>
                                </td>
                            </tr>
                        \`);
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

        function showAddStockForm() {
            layer.open({
                type: 1,
                title: '新增库存',
                area: ['500px', '400px'],
                content: \`
                    <form class="layui-form" style="padding: 20px;" onsubmit="return false;">
                        <div class="layui-form-item">
                            <label class="layui-form-label">选择图书</label>
                            <div class="layui-input-block">
                                <select name="bookId" required lay-verify="required" class="layui-input" id="bookSelect">
                                    <option value="">请选择图书</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">位置</label>
                            <div class="layui-input-block">
                                <select name="locationId" required lay-verify="required" class="layui-input" id="locationSelect">
                                    <option value="">请选择位置</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">数量</label>
                            <div class="layui-input-block">
                                <input type="number" name="totalQty" required lay-verify="required" min="1" value="1" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item" style="text-align: center;">
                            <button class="layui-btn" lay-submit lay-filter="saveStock">保存</button>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </form>
                \`,
                success: function(layero, index){
                    // 加载图书和位置数据
                    loadBooksAndLocations();

                    // 表单提交事件
                    layui.form.on('submit(saveStock)', function(data){
                        $.ajax({
                            url: '/admin/stock/add',
                            type: 'POST',
                            data: data.field,
                            dataType: 'json',
                            success: function(res) {
                                if(res.code === 0) {
                                    layer.msg(res.msg || '添加成功', {icon: 1});
                                    layer.close(index);
                                    loadStocks(currentPage);
                                } else {
                                    layer.msg(res.msg || '添加失败', {icon: 2});
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

        function showAdjustPanel(stockId) {
            layer.open({
                type: 1,
                title: '调整库存',
                area: ['400px', '300px'],
                content: \`
                    <div class="layui-form" style="padding: 20px;">
                        <div class="layui-form-item">
                            <label class="layui-form-label">调整类型</label>
                            <div class="layui-input-block">
                                <input type="radio" name="adjustType" value="in" title="入库" checked>
                                <input type="radio" name="adjustType" value="out" title="出库">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">数量</label>
                            <div class="layui-input-block">
                                <input type="number" name="quantity" min="1" value="1" class="layui-input adjust-input">
                            </div>
                        </div>
                        <div class="layui-form-item" style="text-align: center;">
                            <button class="layui-btn" id="confirmAdjust">确认调整</button>
                            <button type="button" class="layui-btn layui-btn-primary" onclick="layer.closeAll()">取消</button>
                        </div>
                    </div>
                \`,
                success: function(layero, index){
                    $('#confirmAdjust').click(function(){
                        const adjustType = layero.find('input[name="adjustType"]:checked').val();
                        const quantity = parseInt(layero.find('input[name="quantity"]').val());

                        if(isNaN(quantity) || quantity <= 0) {
                            layer.msg('请输入有效的数量', {icon: 2});
                            return;
                        }

                        const change = adjustType === 'in' ? quantity : -quantity;

                        $.ajax({
                            url: '/admin/stock/adjust/' + stockId + '/' + change,
                            type: 'PUT',
                            dataType: 'json',
                            success: function(res) {
                                if(res.code === 0) {
                                    layer.msg(res.msg || '调整成功', {icon: 1});
                                    layer.close(index);
                                    loadStocks(currentPage);
                                } else {
                                    layer.msg(res.msg || '调整失败', {icon: 2});
                                }
                            },
                            error: function() {
                                layer.msg('网络错误', {icon: 2});
                            }
                        });
                    });
                }
            });
        }

        function deleteStock(id) {
            layer.confirm('确定要删除该库存记录吗？', {
                icon: 3,
                title: '提示'
            }, function(index){
                $.ajax({
                    url: '/admin/stock/delete/' + id,
                    type: 'DELETE',
                    dataType: 'json',
                    success: function(res) {
                        if(res.code === 0) {
                            layer.msg(res.msg || '删除成功', {icon: 1});
                            loadStocks(currentPage);
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

        function loadBooksAndLocations() {
            // 加载图书数据
            $.get('/admin/book/data', {page: 1, limit: 100}, function(res) {
                if(res.code === 0) {
                    const select = $('#bookSelect');
                    select.empty();
                    select.append('<option value="">请选择图书</option>');
                    res.data.forEach(book => {
                        select.append(\`<option value="\${book.id}">\${book.title}</option>\`);
                    });
                }
            });

            // 加载位置数据
            $.get('/admin/location/data', {page: 1, limit: 100}, function(res) {
                if(res.code === 0) {
                    const select = $('#locationSelect');
                    select.empty();
                    select.append('<option value="">请选择位置</option>');
                    res.data.forEach(location => {
                        select.append(\`<option value="\${location.id}">\${location.positionCode}</option>\`);
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
    });
</script>
</body>
</html>
