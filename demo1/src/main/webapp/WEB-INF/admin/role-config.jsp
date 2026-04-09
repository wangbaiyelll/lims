NEW_FILE_CODE
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>权限配置 - ${role.roleName}</title>
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
        .permission-group {
            margin-bottom: 20px;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .permission-group-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #667eea;
            border-left: 4px solid #667eea;
            padding-left: 10px;
        }
        .permission-item {
            display: inline-block;
            margin-right: 20px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="layui-container">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    🔧 权限配置 - ${role.roleName}
                </div>
                <div class="layui-card-body">
                    <form class="layui-form" id="configForm">
                        <input type="hidden" name="id" value="${role.id}">

                        <!-- 图书管理权限 -->
                        <div class="permission-group">
                            <div class="permission-group-title">📚 图书管理</div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="book:list" title="查看图书列表" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="book:add" title="新增图书" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="book:update" title="修改图书" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="book:delete" title="删除图书" lay-skin="primary">
                            </div>
                        </div>

                        <!-- 借阅管理权限 -->
                        <div class="permission-group">
                            <div class="permission-group-title">📝 借阅管理</div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="borrow:list" title="查看借阅记录" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="borrow:add" title="办理借阅" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="borrow:audit" title="审核续借" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="borrow:return" title="处理归还" lay-skin="primary">
                            </div>
                        </div>

                        <!-- 教师管理权限 -->
                        <div class="permission-group">
                            <div class="permission-group-title">👨‍🏫 教师管理</div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="teacher:list" title="查看教师列表" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="teacher:add" title="新增教师" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="teacher:update" title="修改教师" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="teacher:status" title="启用/禁用" lay-skin="primary">
                            </div>
                        </div>

                        <!-- 库存管理权限 -->
                        <div class="permission-group">
                            <div class="permission-group-title">📦 库存管理</div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="stock:list" title="查看库存" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="stock:add" title="入库操作" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="stock:update" title="调整库存" lay-skin="primary">
                            </div>
                        </div>

                        <!-- 罚款管理权限 -->
                        <div class="permission-group">
                            <div class="permission-group-title">💰 罚款管理</div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="fine:list" title="查看罚款" lay-skin="primary">
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" name="permissions" value="fine:collect" title="收取罚款" lay-skin="primary">
                            </div>
                        </div>

                        <div class="layui-form-item" style="margin-top: 30px;">
                            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="saveConfig">
                                💾 保存配置
                            </button>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/layui.js"></script>
<script>
    layui.use(['form', 'layer'], function(){
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.$;

        // 当前角色的权限
        var currentPermissions = [];
        try {
            currentPermissions = JSON.parse('${role.permissionJson}') || [];
        } catch(e) {}

        // 勾选已有权限
        currentPermissions.forEach(function(perm){
            $('input[value="' + perm + '"]').prop('checked', true);
        });
        form.render('checkbox');

        // 提交保存
        form.on('submit(saveConfig)', function(data){
            var permissions = [];
            $('input[name="permissions"]:checked').each(function(){
                permissions.push($(this).val());
            });

            $.ajax({
                url: '/admin/role/config/save',
                type: 'POST',
                data: {
                    id: data.field.id,
                    permissions: JSON.stringify(permissions)
                },
                success: function(res){
                    if(res.code === 0){
                        layer.msg('保存成功', {
                            icon: 1,
                            time: 1500
                        }, function(){
                            window.location.href = '/admin/role/list';
                        });
                    } else {
                        layer.msg(res.msg || '保存失败');
                    }
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
