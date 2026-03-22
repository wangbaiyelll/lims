<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>续借审核</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <style>
        body { padding: 20px; }
        .toolbar { margin-bottom: 20px; }
        .search-form { display: flex; gap: 10px; margin-bottom: 20px; }
        .layui-table { margin-top: 15px; }
        .status-tag {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
        }
        .status-pending { background: #FFB800; color: white; }
        .status-approved { background: #5FB878; color: white; }
        .status-rejected { background: #FF5722; color: white; }
        .remark-panel {
            padding: 10px;
            background: #f8f8f8;
            border-radius: 5px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="layui-container">
    <h2>🔄 续借审核</h2>

    <form class="layui-form search-form" onsubmit="return false;">
        <input type="text" name="teacherName" placeholder="教师姓名" class="layui-input" style="width: 120px;">
        <input type="text" name="bookTitle" placeholder="图书名称" class="layui-input" style="width: 150px;">
        <select name="status" class="layui-input" style="width: 120px;">
            <option value="">全部状态</option>
            <option value="0">待审核</option>
            <option value="1">已通过</option>
            <option value="2">已拒绝</option>
        </select>
        <button class="layui-btn layui-btn-primary" id="searchBtn">查询</button>
    </form>

    <table class="layui-table" id="renewTable">
        <thead>
        <tr>
            <th>申请人</th>
            <th>图书信息</th>
            <th>申请时间</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="renewList"></tbody>
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
        loadRenewApplications(currentPage);

        // 查询按钮点击事件
        $('#searchBtn').click(function(){
            currentPage = 1;
            loadRenewApplications(currentPage);
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
                    loadRenewApplications(currentPage);
                }
            }
        });

        function loadRenewApplications(page) {
            const params = {
                page: page,
                limit: 10,
                teacherName: $('input[name="teacherName"]').val(),
                bookTitle: $('input[name="bookTitle"]').val(),
                status: $('select[name="status"]').val()
            };

            $.get('/borrow/renew/data', params, function(res) {
                if(res.code === 0) {
                    const tbody = $('#renewList');
                    tbody.empty();

                    res.data.forEach(app => {
                        const statusClass = getStatusClass(app.status);
                        const statusText = getStatusText(app.status);

                        tbody.append(\`
                            <tr>
                                <td>
                                    <strong>\${app.teacherName}</strong><br>
                                    \${app.empNo}
                                </td>
                                <td>
                                    <strong>\${app.bookTitle}</strong><br>
                                    ISBN: \${app.isbn}
                                </td>
                                <td>\${formatDate(app.applyDate)}</td>
                                <td><span class="status-tag \${statusClass}">\${statusText}</span></td>
                                <td>
                                    \${app.status === 0 ? \`
                                        <button class="layui-btn layui-btn-xs" onclick="approveRenew(\${app.id})">通过</button>
                                        <button class="layui-btn layui-btn-danger layui-btn-xs" onclick="rejectRenew(\${app.id})">拒绝</button>
                                    ` : '-'}
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

        function approveRenew(id) {
            layer.confirm('确定要通过此续借申请吗？', {
                icon: 3,
                title: '提示'
            }, function(index){
                auditRenew(id, 1, '');
                layer.close(index);
            });
        }

        function rejectRenew(id) {
            layer.prompt({
                formType: 2,
                value: '',
                title: '请输入拒绝原因',
                area: ['300px', '150px']
            }, function(value, index){
                if(value.trim() === '') {
                    layer.msg('请输入拒绝原因', {icon: 2});
                    return;
                }
                auditRenew(id, 2, value);
                layer.close(index);
            });
        }

        function auditRenew(id, status, remark) {
            $.ajax({
                url: '/borrow/renew/audit/' + id,
                type: 'POST',
                data: {
                    status: status,
                    remark: remark
                },
                dataType: 'json',
                success: function(res) {
                    if(res.code === 0) {
                        layer.msg(res.msg || '操作成功', {icon: 1});
                        loadRenewApplications(currentPage);
                    } else {
                        layer.msg(res.msg || '操作失败', {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('网络错误', {icon: 2});
                }
            });
        }

        function getStatusClass(status) {
            switch(status) {
                case 0: return 'status-pending';
                case 1: return 'status-approved';
                case 2: return 'status-rejected';
                default: return 'status-pending';
            }
        }

        function getStatusText(status) {
            switch(status) {
                case 0: return '待审核';
                case 1: return '已通过';
                case 2: return '已拒绝';
                default: return '待审核';
            }
        }

        function formatDate(dateString) {
            if(!dateString) return '';
            const date = new Date(dateString);
            return date.getFullYear() + '-' +
                   String(date.getMonth() + 1).padStart(2, '0') + '-' +
                   String(date.getDate()).padStart(2, '0') + ' ' +
                   String(date.getHours()).padStart(2, '0') + ':' +
                   String(date.getMinutes()).padStart(2, '0');
        }
    });
</script>
</body>
</html>

