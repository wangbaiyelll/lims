NEW_FILE_CODE
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>角色管理 - 管理员中心</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/css/layui.css">
    <style>
        body { padding: 20px; background: #f5f5f5; }
        .layui-card { box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
        .layui-card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-size: 18px;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="layui-container">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    👥 角色管理
                </div>
                <div class="layui-card-body">
                    <button class="layui-btn layui-btn-normal" id="addRoleBtn">
                        <i class="layui-icon layui-icon-add-1"></i> 新增角色
                    </button>

                    <table id="roleTable" lay-filter="roleTable"></table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 表格操作列模板 -->
<script type="text/html" id="actionTpl">
    <a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="config">🔧 权限配置</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit">✏️ 编辑</a>
    {{# if(d.roleName !== '超级管理员') { }}
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">🗑️ 删除</a>
    {{# } }}
</script>

<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/layui.js"></script>
<script>
    layui.use(['table', 'layer', 'form'], function(){
        var table = layui.table;
        var layer = layui.layer;
        var form = layui.form;
        var $ = layui.$;

        // 渲染表格
        var tableIns = table.render({
            elem: '#roleTable',
            url: '/admin/role/data',
            cols: [[
                {field: 'id', title: 'ID', width: 80},
                {field: 'roleName', title: '角色名称', minWidth: 150},
                {field: 'permissionJson', title: '权限', minWidth: 300, templet: function(d){
                        if(d.permissionJson === '["*"]'){
                            return '<span style="color: #f5222d; font-weight: bold;">⭐ 超级管理员（所有权限）</span>';
                        }
                        try {
                            var perms = JSON.parse(d.permissionJson);
                            return '<span style="color: #1890ff;">' + perms.join(', ') + '</span>';
                        } catch(e) {
                            return d.permissionJson || '无';
                        }
                    }},
                {fixed: 'right', title: '操作', width: 250, toolbar: '#actionTpl'}
            ]],
            skin: 'line',
            done: function(res, curr, count){
                console.log('角色加载完成');
            }
        });

        // 新增角色
        $('#addRoleBtn').on('click', function(){
            layer.prompt({
                title: '输入角色名称',
                formType: 0
            }, function(roleName, index){
                $.ajax({
                    url: '/admin/role/add',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        roleName: roleName,
                        permissionJson: '[]'
                    }),
                    success: function(res){
                        if(res.code === 0){
                            layer.msg('添加成功');
                            tableIns.reload();
                        } else {
                            layer.msg(res.msg || '添加失败');
                        }
                    }
                });
                layer.close(index);
            });
        });

        // 监听工具条事件
        table.on('tool(roleTable)', function(obj){
            var data = obj.data;
            var event = obj.event;

            if(event === 'edit'){
                layer.prompt({
                    title: '修改角色名称',
                    value: data.roleName,
                    formType: 0
                }, function(value, index){
                    $.ajax({
                        url: '/admin/role/update',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            id: data.id,
                            roleName: value,
                            permissionJson: data.permissionJson
                        }),
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('修改成功');
                                tableIns.reload();
                            } else {
                                layer.msg(res.msg || '修改失败');
                            }
                        }
                    });
                    layer.close(index);
                });
            } else if(event === 'config'){
                // 跳转到权限配置页面
                window.location.href = '/admin/role/config/' + data.id;
            } else if(event === 'del'){
                layer.confirm('确定删除该角色吗？', function(index){
                    $.ajax({
                        url: '/admin/role/delete/' + data.id,
                        type: 'POST',
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('删除成功');
                                obj.del();
                            } else {
                                layer.msg(res.msg || '删除失败');
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
