<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>借阅管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
</head>
<body>
<div class="layui-container" style="margin-top: 20px;">
    <div class="layui-card">
        <div class="layui-card-header">
            <div class="layui-form" style="float: right;">
                <div class="layui-input-inline">
                    <input type="text" name="teacherName" id="teacherName" placeholder="教师姓名" class="layui-input">
                </div>
                <div class="layui-input-inline">
                    <input type="text" name="bookTitle" id="bookTitle" placeholder="书名" class="layui-input">
                </div>
                <div class="layui-input-inline">
                    <select name="status" id="status">
                        <option value="">全部状态</option>
                        <option value="1">借阅中</option>
                        <option value="2">已归还</option>
                        <option value="3">逾期</option>
                    </select>
                </div>
                <button class="layui-btn layui-btn-sm" id="searchBtn">搜索</button>
            </div>
        </div>
        <div class="layui-card-body">
            <table class="layui-table" id="borrowTable" lay-filter="borrowTable"></table>
        </div>
    </div>
</div>

<script type="text/html" id="statusTpl">
    {{# if(d.status == 1){ }}
    <span style="color:blue;">借阅中</span>
    {{# } else if(d.status == 2){ }}
    <span style="color:green;">已归还</span>
    {{# } else { }}
    <span style="color:red;">逾期</span>
    {{# } }}
</script>

<script type="text/html" id="actionBar">
    <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="renew">续借</a>
    <a class="layui-btn layui-btn-xs" lay-event="return">归还</a>
</script>

<script>
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;
        var layer = layui.layer;

        var tableIns = table.render({
            elem: '#borrowTable',
            url: '/admin/borrow/data',
            method: 'get',
            page: true,
            limit: 10,
            cols: [[
                {field: 'id', title: 'ID', width: 80},
                {field: 'teacherName', title: '借阅人', width: 100},
                {field: 'bookTitle', title: '书名', width: 200},
                {field: 'borrowDate', title: '借书日期', width: 110},
                {field: 'dueDate', title: '应还日期', width: 110},
                {field: 'returnDate', title: '实际归还', width: 110},
                {field: 'status', title: '状态', width: 80, templet: '#statusTpl'},
                {field: 'renewCount', title: '续借次数', width: 80},
                {title: '操作', toolbar: '#actionBar', width: 120}
            ]],
            where: {
                teacherName: $('#teacherName').val(),
                bookTitle: $('#bookTitle').val(),
                status: $('#status').val()
            }
        });

        $('#searchBtn').on('click', function(){
            tableIns.reload({
                where: {
                    teacherName: $('#teacherName').val(),
                    bookTitle: $('#bookTitle').val(),
                    status: $('#status').val()
                },
                page: {curr: 1}
            });
        });

        table.on('tool(borrowTable)', function(obj){
            var data = obj.data;
            if(obj.event === 'return'){
                layer.confirm('确定归还《' + data.bookTitle + '》吗？', function(index){
                    $.ajax({
                        url: '/return/doReturn/' + data.id,
                        type: 'POST',
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('还书成功', {icon: 1});
                                tableIns.reload();
                            } else {
                                layer.msg(res.msg, {icon: 2});
                            }
                        }
                    });
                    layer.close(index);
                });
            } else if(obj.event === 'renew'){
                layer.confirm('确定为《' + data.bookTitle + '》申请续借吗？', function(index){
                    $.ajax({
                        url: '/borrow/applyRenew/' + data.id,
                        type: 'POST',
                        success: function(res){
                            if(res.code === 0){
                                layer.msg(res.msg, {icon: 1});
                                tableIns.reload();
                            } else {
                                layer.msg(res.msg, {icon: 2});
                            }
                        }
                    });
                    layer.close(index);
                });
            }
        });
    });
</script>
</body>
</html>
