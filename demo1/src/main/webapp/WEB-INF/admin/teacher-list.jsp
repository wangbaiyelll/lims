<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>教师管理 - 图书馆管理系统</title>
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

        .teacher-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .teacher-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

        .teacher-details {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .teacher-name {
            font-weight: 600;
            color: #2d3436;
        }

        .teacher-emp {
            font-size: 12px;
            color: #999;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .status-enable {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
        }

        .status-disable {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #c62828;
        }

        .action-btn {
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
            margin: 0 2px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            font-weight: 500;
        }

        .btn-edit {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .btn-reset {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #f57c00;
        }

        .btn-delete {
            background: linear-gradient(135deg, #ef5350, #e53935);
            color: white;
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
    </style>
</head>
<body>
<div class="header">
    <h2>👨‍🏫 教师管理</h2>
    <div style="font-size: 13px; opacity: 0.9;">
        📋 管理教师账户信息
    </div>
</div>

<div class="main-container">
    <div class="data-card">
        <div class="toolbar">
            <div class="btn-group">
                <button class="layui-btn layui-btn-normal" id="addBtn">➕ 新增教师</button>
                <button class="layui-btn layui-btn-danger" id="batchDeleteBtn">🗑️ 批量删除</button>
            </div>

            <div class="search-panel">
                <input type="text" name="keyword" id="keyword" placeholder="🔍 姓名/工号/用户名">
                <select name="college" id="college">
                    <option value="">全部学院</option>
                    <option value="计算机学院">计算机学院</option>
                    <option value="软件学院">软件学院</option>
                    <option value="信息学院">信息学院</option>
                </select>
                <select name="status" id="status">
                    <option value="">全部状态</option>
                    <option value="1">✅ 启用</option>
                    <option value="0">❌ 禁用</option>
                </select>
                <button class="layui-btn layui-btn-primary" id="searchBtn">搜索</button>
            </div>
        </div>

        <div class="table-container">
            <table class="layui-table" id="teacherTable" lay-filter="teacherTable">
                <thead>
                    <tr>
                        <th width="50"><input type="checkbox" id="selectAll" lay-skin="primary"></th>
                        <th width="70">ID</th>
                        <th width="200">教师信息</th>
                        <th width="120">工号</th>
                        <th width="120">用户名</th>
                        <th width="150">学院</th>
                        <th width="130">电话</th>
                        <th width="180">邮箱</th>
                        <th width="80">状态</th>
                        <th width="160">创建时间</th>
                        <th width="220">操作</th>
                    </tr>
                </thead>
                <tbody id="teacherList"></tbody>
            </table>
        </div>

        <div id="pagination" class="pagination"></div>
    </div>
</div>

<script>
var layer, tableUtil, formUtil;
var currentPage = 1;

function loadTeachers(page) {
    const params = {
        page: page,
        limit: 10,
        keyword: $('#keyword').val(),
        college: $('#college').val(),
        status: $('#status').val()
    };

    $.get('/admin/teacher/data', params, function(res) {
        if(res.code === 0 && res.data) {
            const tbody = $('#teacherList');
            tbody.empty();

            if(res.data.length > 0) {
                res.data.forEach(function(teacher) {
                    var actionButtons = '<button class="action-btn btn-edit" onclick="editTeacher(' + teacher.id + ')">✏️ 编辑</button>' +
                        '<button class="action-btn btn-reset" onclick="resetPwd(' + teacher.id + ', \'' + teacher.name.replace(/'/g, "\\'") + '\')">🔑 重置密码</button>' +
                        (teacher.status == 1 ?
                            '<button class="action-btn" style="background: #ffebee; color: #c62828;" onclick="toggleStatus(' + teacher.id + ', 0)">⛔ 禁用</button>' :
                            '<button class="action-btn" style="background: #e8f5e9; color: #2e7d32;" onclick="toggleStatus(' + teacher.id + ', 1)">✅ 启用</button>') +
                        '<button class="action-btn btn-delete" onclick="deleteTeacher(' + teacher.id + ')">🗑️ 删除</button>';

                    var row = '<tr>' +
                        '<td style="text-align:center;"><input type="checkbox" name="teacherId" value="' + teacher.id + '" lay-skin="primary"></td>' +
                        '<td style="text-align:center; color: #999;">' + teacher.id + '</td>' +
                        '<td>' +
                            '<div class="teacher-info">' +
                                '<div class="teacher-avatar">' + teacher.name.charAt(0) + '</div>' +
                                '<div class="teacher-details">' +
                                    '<span class="teacher-name">' + teacher.name + '</span>' +
                                    '<span class="teacher-emp">' + (teacher.empNo || '-') + '</span>' +
                                '</div>' +
                            '</div>' +
                        '</td>' +
                        '<td style="text-align:center; font-family: monospace;">' + (teacher.empNo || '-') + '</td>' +
                        '<td style="text-align:center;">' + teacher.username + '</td>' +
                        '<td style="text-align:center; color: #666;">' + (teacher.college || '-') + '</td>' +
                        '<td style="text-align:center;">' + (teacher.phone || '-') + '</td>' +
                        '<td style="text-align:center; font-size: 12px;">' + (teacher.email || '-') + '</td>' +
                        '<td style="text-align:center;">' + getStatusBadge(teacher.status) + '</td>' +
                        '<td style="text-align:center; font-size: 12px;">' + formatDate(teacher.createTime) + '</td>' +
                        '<td style="text-align:center;">' + actionButtons + '</td>' +
                    '</tr>';

                    tbody.append(row);
                });

                if(formUtil) {
                    formUtil.render('checkbox');
                }
            } else {
                tbody.append('<tr><td colspan="11"><div class="empty-state"><i>👨‍🏫</i>暂无教师数据</div></td></tr>');
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
                        loadTeachers(currentPage);
                    }
                }
            });
        }
    }).fail(function(xhr, status, error) {
        console.error('获取教师数据失败:', error);
        $('#teacherList').html('<tr><td colspan="11"><div class="empty-state" style="color: red;">❌ 数据加载失败</div></td></tr>');
    });
}

function getStatusBadge(status) {
    if(status == 1) return '<span class="status-badge status-enable">✅ 启用</span>';
    return '<span class="status-badge status-disable">❌ 禁用</span>';
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

function editTeacher(id) {
    $.ajax({
        url: '/admin/teacher/edit/' + id,
        type: 'GET',
        success: function(res){
            if(res.code === 0 && res.data) {
                showEditForm(res.data);
            } else {
                layer.msg('❌ 获取教师信息失败', {icon: 2});
            }
        },
        error: function(){
            layer.msg('❌ 网络错误', {icon: 2});
        }
    });
}

function resetPwd(id, name) {
    layer.confirm('🔑 确定要重置教师 "' + name + '" 的密码吗？', {
        icon: 3,
        title: '重置密码确认',
        btn: ['确定重置', '取消']
    }, function(index){
        $.ajax({
            url: '/admin/teacher/resetPwd/' + id,
            type: 'POST',
            success: function(res){
                if(res.code === 0){
                    layer.msg('✅ 密码重置成功', {icon: 1, time: 2000});
                } else {
                    layer.msg('❌ 重置失败', {icon: 2});
                }
            },
            error: function(){
                layer.msg('❌ 网络错误', {icon: 2});
            }
        });
        layer.close(index);
    });
}

function toggleStatus(id, status) {
    var action = status == 1 ? '启用' : '禁用';
    layer.confirm('⚠️ 确定要' + action + '该教师吗？', {
        icon: 3,
        title: '确认操作',
        btn: ['确定', '取消']
    }, function(index){
        $.ajax({
            url: '/admin/teacher/status/' + id + '/' + status,
            type: 'PUT',
            success: function(res){
                if(res.code === 0){
                    layer.msg('✅ ' + action + '成功', {icon: 1, time: 1500});
                    loadTeachers(currentPage);
                } else {
                    layer.msg('❌ ' + action + '失败', {icon: 2});
                }
            },
            error: function(){
                layer.msg('❌ 网络错误', {icon: 2});
            }
        });
        layer.close(index);
    });
}

function deleteTeacher(id) {
    layer.confirm('⚠️ 确定要删除该教师吗？此操作不可恢复！', {
        icon: 3,
        title: '警告',
        btn: ['确认删除', '取消']
    }, function(index){
        $.ajax({
            url: '/admin/teacher/delete/' + id,
            type: 'DELETE',
            success: function(res){
                if(res.code === 0){
                    layer.msg('✅ 删除成功', {icon: 1, time: 1500});
                    loadTeachers(currentPage);
                } else {
                    layer.msg('❌ 删除失败', {icon: 2});
                }
            },
            error: function(){
                layer.msg('❌ 网络错误', {icon: 2});
            }
        });
        layer.close(index);
    });
}

function showEditForm(teacher) {
    layer.open({
        type: 1,
        title: '✏️ 编辑教师',
        area: ['600px', '550px'],
        content: '<form class="layui-form" style="padding: 25px;" onsubmit="return false;">' +
            '<input type="hidden" name="id" value="' + teacher.id + '">' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">用户名</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="username" class="layui-input" value="' + teacher.username + '">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">工号</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="empNo" class="layui-input" value="' + teacher.empNo + '">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">姓名</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="name" class="layui-input" value="' + teacher.name + '">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">学院</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="college" class="layui-input" value="' + teacher.college + '">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">电话</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="phone" class="layui-input" value="' + (teacher.phone || '') + '">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">邮箱</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="email" class="layui-input" value="' + (teacher.email || '') + '">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">入职日期</label>' +
                '<div class="layui-input-block">' +
                    '<input type="date" name="hireDate" class="layui-input" value="' + (teacher.hireDate ? teacher.hireDate.split('T')[0] : '') + '">' +
                '</div>' +
            '</div>' +
        '</form>',
        success: function(layero, index){
            if(formUtil) formUtil.render();
        },
        btn: ['💾 保存', '✖ 取消'],
        yes: function(index, layero){
            var formData = {};
            layero.find('input,select,textarea').each(function(){
                formData[$(this).attr('name')] = $(this).val();
            });

            $.ajax({
                url: '/admin/teacher/update',
                type: 'PUT',
                data: formData,
                success: function(res){
                    if(res.code === 0){
                        layer.msg('✅ 更新成功', {icon: 1, time: 1500});
                        loadTeachers(currentPage);
                        layer.close(index);
                    } else {
                        layer.msg('❌ ' + (res.msg || '更新失败'), {icon: 2});
                    }
                },
                error: function(){
                    layer.msg('❌ 网络错误', {icon: 2});
                }
            });
        }
    });
}

function showAddForm() {
    layer.open({
        type: 1,
        title: '➕ 新增教师',
        area: ['600px', '600px'],
        content: '<form class="layui-form" style="padding: 25px;" onsubmit="return false;">' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label"><span style="color: red;">*</span> 用户名</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="username" required lay-verify="required" class="layui-input" placeholder="请输入用户名">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label"><span style="color: red;">*</span> 密码</label>' +
                '<div class="layui-input-block">' +
                    '<input type="password" name="password" required lay-verify="required" class="layui-input" value="123456" placeholder="默认密码 123456">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label"><span style="color: red;">*</span> 工号</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="empNo" required lay-verify="required" class="layui-input" placeholder="请输入工号">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label"><span style="color: red;">*</span> 姓名</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="name" required lay-verify="required" class="layui-input" placeholder="请输入姓名">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">学院</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="college" class="layui-input" placeholder="请输入学院">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">电话</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="phone" class="layui-input" placeholder="请输入电话">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">邮箱</label>' +
                '<div class="layui-input-block">' +
                    '<input type="text" name="email" class="layui-input" placeholder="请输入邮箱">' +
                '</div>' +
            '</div>' +
            '<div class="layui-form-item">' +
                '<label class="layui-form-label">入职日期</label>' +
                '<div class="layui-input-block">' +
                    '<input type="date" name="hireDate" class="layui-input">' +
                '</div>' +
            '</div>' +
        '</form>',
        btn: ['💾 保存', '✖ 取消'],
        yes: function(index, layero){
            var formData = {};
            layero.find('input,select,textarea').each(function(){
                formData[$(this).attr('name')] = $(this).val();
            });

            $.ajax({
                url: '/admin/teacher/add',
                type: 'POST',
                data: formData,
                success: function(res){
                    if(res.code === 0){
                        layer.msg('✅ 添加成功', {icon: 1, time: 1500});
                        loadTeachers(currentPage);
                        layer.close(index);
                    } else {
                        layer.msg('❌ ' + (res.msg || '添加失败'), {icon: 2});
                    }
                },
                error: function(){
                    layer.msg('❌ 网络错误', {icon: 2});
                }
            });
        }
    });
}

$(document).ready(function(){
    layui.use(['table', 'form', 'layer', 'laypage'], function(){
        tableUtil = layui.table;
        formUtil = layui.form;
        layer = layui.layer;

        $('#searchBtn').on('click', function(){
            currentPage = 1;
            loadTeachers(currentPage);
        });

        $('#addBtn').on('click', function(){
            showAddForm();
        });

        $('#batchDeleteBtn').on('click', function(){
            var checked = $('input[name="teacherId"]:checked');
            if(checked.length === 0){
                layer.msg('❌ 请至少选择一名教师', {icon: 2});
                return;
            }

            var ids = [];
            checked.each(function(){
                ids.push($(this).val());
            });

            layer.confirm('⚠️ 确定要删除选中的 ' + ids.length + ' 名教师吗？此操作不可恢复！', {
                icon: 3,
                title: '警告',
                btn: ['确认删除', '取消']
            }, function(index){
                $.ajax({
                    url: '/admin/teacher/batchDelete',
                    type: 'DELETE',
                    data: {ids: ids.join(',')},
                    success: function(res){
                        if(res.code === 0){
                            layer.msg('✅ ' + (res.msg || '删除成功'), {icon: 1, time: 1500});
                            loadTeachers(currentPage);
                        } else {
                            layer.msg('❌ ' + (res.msg || '删除失败'), {icon: 2});
                        }
                    },
                    error: function(){
                        layer.msg('❌ 网络错误', {icon: 2});
                    }
                });
                layer.close(index);
            });
        });

        $('#selectAll').on('click', function(){
            var checked = this.checked;
            $('input[name="teacherId"]').each(function(){
                this.checked = checked;
            });
            if(formUtil) formUtil.render('checkbox');
        });

        loadTeachers(currentPage);
    });
});
</script>
</body>
</html>
