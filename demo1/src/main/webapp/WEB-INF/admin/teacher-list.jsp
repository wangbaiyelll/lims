<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>教师管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
</head>
<body>
<div class="layui-container" style="margin-top: 20px;">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    <div class="layui-btn-group">
                        <button class="layui-btn layui-btn-sm" id="addBtn">新增教师</button>
                        <button class="layui-btn layui-btn-sm layui-btn-danger" id="batchDeleteBtn">批量删除</button>
                    </div>
                    <div class="layui-form" style="float: right;">
                        <div class="layui-input-inline">
                            <input type="text" name="keyword" id="keyword" placeholder="姓名/工号/用户名" class="layui-input">
                        </div>
                        <div class="layui-input-inline">
                            <select name="college" id="college">
                                <option value="">全部学院</option>
                                <option value="计算机学院">计算机学院</option>
                                <option value="软件学院">软件学院</option>
                                <option value="信息学院">信息学院</option>
                            </select>
                        </div>
                        <div class="layui-input-inline">
                            <select name="status" id="status">
                                <option value="">全部状态</option>
                                <option value="1">启用</option>
                                <option value="0">禁用</option>
                            </select>
                        </div>
                        <button class="layui-btn layui-btn-sm" id="searchBtn">搜索</button>
                    </div>
                </div>
                <div class="layui-card-body">
                    <table class="layui-table" id="teacherTable" lay-filter="teacherTable"></table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="actionBar">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="resetPwd">重置密码</a>
    {{# if(d.status == 1){ }}
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="disable">禁用</a>
    {{# } else { }}
    <a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="enable">启用</a>
    {{# } }}
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
</script>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script>
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;
        var form = layui.form;
        var layer = layui.layer;

        var tableIns = table.render({
            elem: '#teacherTable',
            url: '/admin/teacher/data',
            method: 'get',
            page: true,
            limit: 10,
            limits: [10, 20, 50],
            cols: [[
                {type: 'checkbox', width: 50},
                {field: 'id', title: 'ID', width: 60},
                {field: 'empNo', title: '工号', width: 120},
                {field: 'name', title: '姓名', width: 100},
                {field: 'username', title: '用户名', width: 120},
                {field: 'college', title: '学院', width: 150},
                {field: 'phone', title: '电话', width: 130},
                {field: 'email', title: '邮箱', width: 180},
                {field: 'status', title: '状态', width: 80, templet: function(d){
                        return d.status == 1 ? '<span style="color:green;">启用</span>' : '<span style="color:red;">禁用</span>';
                    }},
                {field: 'createTime', title: '创建时间', width: 160},
                {title: '操作', toolbar: '#actionBar', width: 200, fixed: 'right'}
            ]],
            where: {
                keyword: $('#keyword').val(),
                college: $('#college').val(),
                status: $('#status').val()
            }
        });

        $('#searchBtn').on('click', function(){
            tableIns.reload({
                where: {
                    keyword: $('#keyword').val(),
                    college: $('#college').val(),
                    status: $('#status').val()
                },
                page: {curr: 1}
            });
        });

        $('#addBtn').on('click', function(){
            layer.open({
                type: 1,
                title: '新增教师',
                area: ['500px', '500px'],
                content: $('#addForm').html(),
                success: function(layero, index){
                    form.render();
                },
                btn: ['保存', '取消'],
                yes: function(index, layero){
                    var data = {
                        username: layero.find('#username').val(),
                        password: layero.find('#password').val(),
                        empNo: layero.find('#empNo').val(),
                        name: layero.find('#name').val(),
                        college: layero.find('#college').val(),
                        phone: layero.find('#phone').val(),
                        email: layero.find('#email').val(),
                        hireDate: layero.find('#hireDate').val()
                    };
                    $.ajax({
                        url: '/admin/teacher/add',
                        type: 'POST',
                        data: data,
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('添加成功', {icon: 1});
                                tableIns.reload();
                                layer.close(index);
                            } else {
                                layer.msg(res.msg, {icon: 2});
                            }
                        }
                    });
                }
            });
        });

        table.on('tool(teacherTable)', function(obj){
            var data = obj.data;
            if(obj.event === 'edit'){
                layer.open({
                    type: 1,
                    title: '编辑教师',
                    area: ['500px', '500px'],
                    content: $('#editForm').html(),
                    success: function(layero, index){
                        layero.find('#id').val(data.id);
                        layero.find('#username').val(data.username);
                        layero.find('#empNo').val(data.empNo);
                        layero.find('#name').val(data.name);
                        layero.find('#college').val(data.college);
                        layero.find('#phone').val(data.phone);
                        layero.find('#email').val(data.email);
                        layero.find('#hireDate').val(data.hireDate);
                        form.render();
                    },
                    btn: ['保存', '取消'],
                    yes: function(index, layero){
                        var formData = {
                            id: layero.find('#id').val(),
                            username: layero.find('#username').val(),
                            empNo: layero.find('#empNo').val(),
                            name: layero.find('#name').val(),
                            college: layero.find('#college').val(),
                            phone: layero.find('#phone').val(),
                            email: layero.find('#email').val(),
                            hireDate: layero.find('#hireDate').val()
                        };
                        $.ajax({
                            url: '/admin/teacher/update',
                            type: 'PUT',
                            data: formData,
                            success: function(res){
                                if(res.code === 0){
                                    layer.msg('更新成功', {icon: 1});
                                    tableIns.reload();
                                    layer.close(index);
                                } else {
                                    layer.msg(res.msg, {icon: 2});
                                }
                            }
                        });
                    }
                });
            } else if(obj.event === 'resetPwd'){
                layer.confirm('确定要重置该教师的密码吗？', function(index){
                    $.ajax({
                        url: '/admin/teacher/resetPwd/' + data.id,
                        type: 'POST',
                        success: function(res){
                            if(res.code === 0){
                                layer.msg(res.msg, {icon: 1});
                            } else {
                                layer.msg(res.msg, {icon: 2});
                            }
                        }
                    });
                    layer.close(index);
                });
            } else if(obj.event === 'enable'){
                $.ajax({
                    url: '/admin/teacher/status/' + data.id + '/1',
                    type: 'PUT',
                    success: function(res){
                        if(res.code === 0){
                            layer.msg('启用成功', {icon: 1});
                            tableIns.reload();
                        } else {
                            layer.msg(res.msg, {icon: 2});
                        }
                    }
                });
            } else if(obj.event === 'disable'){
                $.ajax({
                    url: '/admin/teacher/status/' + data.id + '/0',
                    type: 'PUT',
                    success: function(res){
                        if(res.code === 0){
                            layer.msg('禁用成功', {icon: 1});
                            tableIns.reload();
                        } else {
                            layer.msg(res.msg, {icon: 2});
                        }
                    }
                });
            } else if(obj.event === 'delete'){
                layer.confirm('确定删除该教师吗？', function(index){
                    $.ajax({
                        url: '/admin/teacher/delete/' + data.id,
                        type: 'DELETE',
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('删除成功', {icon: 1});
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

<script type="text/html" id="addForm">
    <div style="padding: 20px;">
        <form class="layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-block"><input type="text" id="username" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block"><input type="password" id="password" class="layui-input" value="123456"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">工号</label>
                <div class="layui-input-block"><input type="text" id="empNo" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-block"><input type="text" id="name" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">学院</label>
                <div class="layui-input-block"><input type="text" id="college" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">电话</label>
                <div class="layui-input-block"><input type="text" id="phone" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-block"><input type="text" id="email" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">入职日期</label>
                <div class="layui-input-block"><input type="date" id="hireDate" class="layui-input"></div>
            </div>
        </form>
    </div>
</script>

<script type="text/html" id="editForm">
    <div style="padding: 20px;">
        <form class="layui-form">
            <input type="hidden" id="id">
            <div class="layui-form-item">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-block"><input type="text" id="username" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">工号</label>
                <div class="layui-input-block"><input type="text" id="empNo" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-block"><input type="text" id="name" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">学院</label>
                <div class="layui-input-block"><input type="text" id="college" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">电话</label>
                <div class="layui-input-block"><input type="text" id="phone" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-block"><input type="text" id="email" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">入职日期</label>
                <div class="layui-input-block"><input type="date" id="hireDate" class="layui-input"></div>
            </div>
        </form>
    </div>
</script>
</body>
</html>
