<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的借阅</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/css/layui.css">
    <style>
        .layui-container {
            max-width: 1400px;
            margin-top: 30px;
            padding: 0 20px;
        }
        .layui-card {
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            border-radius: 12px;
            overflow: hidden;
        }
        .layui-card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-bottom: none;
            padding: 20px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .layui-card-header h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
        }
        .layui-form-select dl dd.layui-this {
            background-color: #667eea;
            color: white;
        }
        .status-pending {
            color: #ff9800;
            font-weight: 600;
        }
        .status-approved {
            color: #4CAF50;
            font-weight: 600;
        }
        .status-rejected {
            color: #f44336;
            font-weight: 600;
        }
        .renewal-info {
            font-size: 12px;
            color: #999;
            margin-top: 4px;
        }

        /* 临期提醒样式增强 */
        .due-soon-row {
            background: linear-gradient(135deg, #fff3e0 0%, #ffebee 100%) !important;
            border-left: 4px solid #ff5722 !important;
            transition: all 0.3s ease;
            font-weight: bold;
        }

        .due-soon-row:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(255, 87, 34, 0.3);
        }

        /* 逾期记录样式 */
        .overdue-row {
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%) !important;
            border-left: 4px solid #f44336 !important;
            transition: all 0.3s ease;
            font-weight: bold;
        }

        .overdue-row:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(244, 67, 54, 0.3);
        }

        .status-tag-due-soon {
            background: linear-gradient(135deg, #ff9800, #ff5722);
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            animation: pulse-warning 2s infinite;
            box-shadow: 0 2px 8px rgba(255, 87, 34, 0.4);
        }

        .status-tag-overdue {
            background: linear-gradient(135deg, #f44336, #e91e63);
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .status-tag-normal {
            background: linear-gradient(135deg, #4CAF50, #8BC34A);
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        @keyframes pulse-warning {
            0%, 100% {
                opacity: 1;
                transform: scale(1);
            }
            50% {
                opacity: 0.9;
                transform: scale(1.05);
            }
        }

        .layui-table-body tr:hover {
            animation: none !important;
        }

        /* 临期行样式 - 使用!important 强制应用 */
        .layui-table-view .layui-table tbody tr.due-soon td,
        .layui-table-view .layui-table tbody tr.due-soon td.layui-table-col-lmr,
        .layui-table-view .layui-table tbody tr.due-soon td.layui-table-col-lml {
            background: linear-gradient(135deg, #fff3e0, #ffebee) !important;
            border-left: 4px solid #ff5722 !important;
            font-weight: bold !important;
        }

        /* 表格样式优化 */
        .layui-table {
            font-size: 17px;
        }

        .layui-table th {
            font-weight: 600;
            color: #2c3e50;
            background: #f8f9fa;
            font-size: 18px;
            padding: 18px 15px;
        }

        .layui-table td {
            padding: 18px 15px;
            font-size: 17px;
            vertical-align: middle;
        }

        .layui-table tbody tr {
            height: 65px;
        }

        .layui-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* 操作按钮优化 */
        .layui-btn-danger {
            background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
            border: none;
        }

        .layui-btn-warm {
            background: linear-gradient(135deg, #ffa726, #fb8c00);
            border: none;
        }

        /* 统计信息 */
        .summary-stats {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .stat-card {
            flex: 1;
            min-width: 180px;
            background: white;
            padding: 25px 20px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border-left: 5px solid #667eea;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), transparent);
            border-radius: 0 0 0 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }

        .stat-card.borrowing {
            border-left-color: #3498db;
        }

        .stat-card.borrowing::before {
            background: linear-gradient(135deg, rgba(52, 152, 219, 0.1), transparent);
        }

        .stat-card.due-soon {
            border-left-color: #ff9800;
        }

        .stat-card.due-soon::before {
            background: linear-gradient(135deg, rgba(255, 152, 0, 0.1), transparent);
        }

        .stat-card.overdue {
            border-left-color: #f44336;
        }

        .stat-card.overdue::before {
            background: linear-gradient(135deg, rgba(244, 67, 54, 0.1), transparent);
        }

        .stat-card.returned {
            border-left-color: #4CAF50;
        }

        .stat-card.returned::before {
            background: linear-gradient(135deg, rgba(76, 175, 80, 0.1), transparent);
        }

        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 8px;
        }

        .stat-label {
            font-size: 14px;
            color: #7f8c8d;
            font-weight: 500;
        }

    </style>
</head>
<body>

<div class="layui-container">
    <!-- 统计卡片 -->
    <div class="summary-stats">
        <div class="stat-card">
            <div class="stat-number" id="totalBorrows">-</div>
            <div class="stat-label">📚 总借阅数</div>
        </div>
        <div class="stat-card borrowing">
            <div class="stat-number" id="borrowingCount">-</div>
            <div class="stat-label">📖 正在借阅</div>
        </div>
        <div class="stat-card due-soon">
            <div class="stat-number" id="dueSoonCount">-</div>
            <div class="stat-label">⚠️ 临期 (3 天内)</div>
        </div>
        <div class="stat-card overdue">
            <div class="stat-number" id="overdueCount">-</div>
            <div class="stat-label">❌ 已逾期</div>
        </div>
        <div class="stat-card returned">
            <div class="stat-number" id="returnedCount">-</div>
            <div class="stat-label">✅ 已归还</div>
        </div>
    </div>

    <div class="layui-card">
        <div class="layui-card-header">
            <h2>📖 我的借阅</h2>
            <div class="layui-form" style="display: flex; gap: 10px;">
                <div class="layui-input-inline" style="width: 150px; margin: 0;">
                    <select name="status" id="status">
                        <option value="">全部状态</option>
                        <option value="1">借阅中</option>
                        <option value="2">已归还</option>
                        <option value="3">逾期</option>
                    </select>
                </div>
                <button class="layui-btn layui-btn-sm" id="searchBtn" style="background: white; color: #667eea; border: 1px solid #667eea;">
                    <i class="layui-icon">&#xe615;</i> 搜索
                </button>
            </div>
        </div>
        <div class="layui-card-body">
            <table class="layui-table" id="borrowTable" lay-filter="borrowTable"></table>
        </div>
    </div>
</div>

<!-- 操作栏模板 -->
<script type="text/html" id="actionBar">
    {{#
        var hasOverdue = d.hasOverdueGlobal || false;
        console.log('🔍 模板渲染 - 图书:', d.bookTitle, '状态:', d.status, 'hasOverdueGlobal:', d.hasOverdueGlobal, 'hasOverdue:', hasOverdue);
    }}

    {{# if(d.status == 1 && !d.hasPendingRenewal && (!d.renewalStatus || d.renewalStatus === 0)) { }}
        {{# if(hasOverdue) { }}
            <span style="color: #ff4500; font-size: 13px;" title="有逾期未还图书，不能续借">❌ 有逾期不能续借</span>
        {{# } else { }}
            {{# var dueDateStr = d.dueDate.toString().replace(/-/g, '/'); }}
            {{# var dueDate = new Date(dueDateStr); }}
            {{# var now = new Date(); }}
            {{# dueDate.setHours(23, 59, 59, 999); }}
            {{# now.setHours(0, 0, 0, 0); }}
            {{# var daysLeft = Math.floor((dueDate - now) / (1000 * 60 * 60 * 24)); }}

            {{# if(daysLeft !== null && daysLeft >= 0 && daysLeft <= 3) { }}
                <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="renew">
                    <i class="layui-icon">&#xe605;</i> 紧急续借
                </button>
            {{# } else { }}
                <button class="layui-btn layui-btn-xs layui-btn-warm" lay-event="renew">
                    <i class="layui-icon">&#xe605;</i> 续借
                </button>
            {{# } }}
        {{# } }}
    {{# } else if(d.status === 3) { }}
        <span style="color: #ff4500; font-size: 13px;">❌ 已逾期，不能续借</span>
    {{# } else if(d.hasPendingRenewal || (d.renewalStatus === 0)) { }}
        <span style="color: #ff9800; font-size: 12px;">⏳ 审核中</span>
    {{# } else if(d.renewalStatus === 1) { }}
        <span style="color: #4CAF50; font-size: 12px;">✅ 已通过</span>
    {{# } else if(d.renewalStatus === 2) { }}
        <span style="color: #999; font-size: 12px;">已拒绝</span>
    {{# } else { }}
        <span style="color: #999; font-size: 12px;">-</span>
    {{# } }}
</script>

<!-- 状态模板 -->
<script type="text/html" id="statusTpl">
    {{# if(d.status === 3) { }}
        <span class="status-tag status-tag-overdue">逾期</span>
    {{# } else if(d.status === 2) { }}
        <span class="status-tag status-tag-returned">已归还</span>
    {{# } else { }}
        <span class="status-tag status-tag-normal">正常</span>
    {{# } }}
</script>

<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/layui.js"></script>
<script>
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;
        var layer = layui.layer;
        var form = layui.form;
        var $ = layui.$;

        // 辅助函数：计算剩余天数
        function calculateDaysLeft(dateString) {
            if (!dateString) return null;
            try {
                var dueDateStr = dateString.toString().trim();
                var dueDate = new Date(dueDateStr);
                var now = new Date();

                dueDate.setHours(23, 59, 59, 999);
                now.setHours(0, 0, 0, 0);

                var diffMs = dueDate - now;
                var daysLeft = Math.floor(diffMs / (1000 * 60 * 60 * 24));

                return daysLeft;
            } catch(e) {
                console.error('❌ 日期计算错误:', dateString);
                return null;
            }
        }

        // 判断是否临期（3 天内）
        function isDueSoon(record) {
            if (!record.dueDate || record.status === 2) {
                return false;
            }
            var daysLeft = calculateDaysLeft(record.dueDate);
            return daysLeft !== null && daysLeft >= 0 && daysLeft <= 3;
        }

        // 判断是否逾期
        function isOverdue(record) {
            if (!record.dueDate || record.status === 2) {
                return false;
            }
            var daysLeft = calculateDaysLeft(record.dueDate);
            return daysLeft !== null && daysLeft < 0;
        }

        // 更新统计显示
        function updateStats(stats) {
            $('#totalBorrows').text(stats.total);
            $('#borrowingCount').text(stats.borrowing);
            $('#dueSoonCount').text(stats.dueSoon);
            $('#overdueCount').text(stats.overdue);
            $('#returnedCount').text(stats.returned);
        }

        // 加载统计数据
        function loadStats() {
            const teacherId = ${sessionScope.loginTeacher != null ? sessionScope.loginTeacher.id : 0};

            $.ajax({
                url: '/borrow/my-borrows',
                type: 'get',
                data: {
                    page: 1,
                    limit: 1000,
                    teacherId: teacherId
                },
                success: function(res) {
                    if (res.code === 0 && res.data && res.data.length > 0) {
                        var stats = {
                            total: 0,
                            borrowing: 0,
                            dueSoon: 0,
                            overdue: 0,
                            returned: 0
                        };

                        stats.total = res.data.length;

                        res.data.forEach(function(record) {
                            if (record.status === 2) {
                                stats.returned++;
                            } else {
                                stats.borrowing++;

                                var daysLeft = calculateDaysLeft(record.dueDate);
                                if (daysLeft !== null) {
                                    if (daysLeft < 0) {
                                        stats.overdue++;
                                    } else if (daysLeft >= 0 && daysLeft <= 3) {
                                        stats.dueSoon++;
                                    }
                                }
                            }
                        });

                        updateStats(stats);
                    } else {
                        updateStats({total: 0, borrowing: 0, dueSoon: 0, overdue: 0, returned: 0});
                    }
                },
                error: function(xhr, status, error) {
                    console.error('❌ 统计加载失败:', error);
                    updateStats({total: 0, borrowing: 0, dueSoon: 0, overdue: 0, returned: 0});
                }
            });
        }

        var tableIns = table.render({
            elem: '#borrowTable',
            url: '/borrow/my-borrows',
            method: 'get',
            page: true,
            limit: 10,
            limits: [10, 20, 50, 100],
            height: 'full-200',
            cols: [[
                {field: 'id', title: 'ID', width: 90, sort: true},
                {field: 'bookTitle', title: '📚 书名', minWidth: 280},
                {field: 'borrowDate', title: '借书日期', width: 130, sort: true, templet: function(d) {
                    return d.borrowDate ? '<span style="color: #667eea; font-size: 16px;">' + d.borrowDate.substring(0, 10) + '</span>' : '';
                }},
                {field: 'dueDate', title: '应还日期', width: 170, sort: true, templet: function(d) {
                    if (!d.dueDate) return '';
                    var dateStr = d.dueDate.substring(0, 10);

                    // 逾期 - 橙红色
                    if (d.status === 3) {
                        return '<span style="color: #ff4500; font-weight: bold; font-size: 16px; background: #ffe5e0; padding: 8px 14px; border-radius: 8px; display: inline-block;">' + dateStr + '</span>';
                    }
                    // 临期（3 天内且未归还）- 鲜红色
                    else if (d.status === 1) {
                        var daysLeft = calculateDaysLeft(d.dueDate);
                        if (daysLeft !== null && daysLeft >= 0 && daysLeft <= 3) {
                            return '<span style="color: #d90429; font-weight: bold; font-size: 16px; background: #ffe0e6; padding: 8px 14px; border-radius: 8px; display: inline-block;">' + dateStr + '</span>';
                        }
                    }
                    // 正常
                    return '<span style="color: #28a745; font-size: 16px;">' + dateStr + '</span>';
                }},
                {field: 'returnDate', title: '归还日期', width: 130, templet: function(d) {
                    return d.returnDate ? '<span style="color: #28a745; font-size: 16px;">' + d.returnDate.substring(0, 10) + '</span>' : '<span style="color: #999; font-size: 16px;">-</span>';
                }},
                {field: 'status', title: '借阅状态', width: 150, templet: function(d) {
                    // 状态显示逻辑 - 与当前借阅一致
                    if (d.status === 3) {
                        return '<span class="status-tag" style="background: linear-gradient(135deg, #ff4500, #ff6347); color: white; padding: 8px 16px; border-radius: 8px; font-size: 15px; font-weight: 600; display: inline-block;">逾期</span>';
                    } else if (d.status === 2) {
                        return '<span class="status-tag" style="background: linear-gradient(135deg, #28a745, #20c997); color: white; padding: 8px 16px; border-radius: 8px; font-size: 15px; font-weight: 600; display: inline-block;">已归还</span>';
                    } else {
                        // 借阅中 - 需要判断是否临期
                        var daysLeft = calculateDaysLeft(d.dueDate);
                        if (daysLeft !== null && daysLeft >= 0 && daysLeft <= 3) {
                            return '<span class="status-tag" style="background: linear-gradient(135deg, #d90429, #ef233c); color: white; padding: 8px 16px; border-radius: 8px; font-size: 15px; font-weight: 600; display: inline-block; animation: pulse-warning 2s infinite;">⚠️ 临期 (' + daysLeft + '天)</span>';
                        } else {
                            return '<span class="status-tag" style="background: linear-gradient(135deg, #28a745, #51cf66); color: white; padding: 8px 16px; border-radius: 8px; font-size: 15px; font-weight: 600; display: inline-block;">正常</span>';
                        }
                    }
                }},
                {field: 'renewCount', title: '续借次数', width: 110, templet: function(d) {
                    return d.renewCount > 0 ? '<span style="color: #fd7e14; font-size: 16px; background: #fff3cd; padding: 6px 12px; border-radius: 8px; display: inline-block;">' + d.renewCount + '次</span>' : '<span style="color: #999; font-size: 16px; background: #f8f9fa; padding: 6px 12px; border-radius: 8px; display: inline-block;">0 次</span>';
                }},
                {title: '操作', toolbar: '#actionBar', width: 160, fixed: 'right'}
            ]],
            where: {
                teacherId: ${sessionScope.loginTeacher != null ? sessionScope.loginTeacher.id : 0}
            },
            skin: 'line',
            even: true,
            autoSort: false,
            parseData: function(res){
                // 在数据解析阶段就检查是否有逾期
                console.log('📊 parseData - 后端返回 hasAnyOverdue:', res.hasAnyOverdue);

                // 将 hasAnyOverdue 添加到每条记录中
                if(res.data && res.data.length > 0) {
                    res.data.forEach(function(record) {
                        record.hasOverdueGlobal = res.hasAnyOverdue || false;
                    });
                }

                return {
                    "code": res.code,
                    "msg": res.msg,
                    "count": res.count,
                    "data": res.data
                };
            },
            done: function(res, curr, count){
                console.log('✅ 表格数据加载完成，当前页记录数:', res.data.length);
                console.log('🔍 后端返回的 hasAnyOverdue:', res.hasAnyOverdue);

                // 使用后端返回的 hasAnyOverdue 标记
                window.hasOverdueRecord = res.hasAnyOverdue || false;

                console.log('📖 最终 hasOverdueRecord 值:', window.hasOverdueRecord);

                setTimeout(function(){
                    $('#borrowTable').next().find('.layui-table tbody tr').each(function(i){
                        var data = res.data[i];
                        if(data && data.dueDate){
                            var daysLeft = calculateDaysLeft(data.dueDate);

                            if((data.status === 1 || data.status === 3) && daysLeft !== null && daysLeft >= 0 && daysLeft <= 3){
                                $(this).addClass('due-soon-row');
                                $(this).css({
                                    'background': 'linear-gradient(135deg, #ffe0e6, #ffd6d6)',
                                    'border-left': '4px solid #d90429'
                                });
                            } else if (data.status === 3 || (daysLeft !== null && daysLeft < 0)) {
                                $(this).css({
                                    'background': 'linear-gradient(135deg, #ffe5e0, #ffd6d6)',
                                    'border-left': '4px solid #ff4500'
                                });
                            }
                        }
                    });
                }, 100);
            }
        });

        table.on('sort(borrowTable)', function(obj){
            tableIns.reload({
                initSort: obj,
                where: {
                    status: $('#status').val()
                }
            });
        });

        $('#searchBtn').on('click', function(){
            var selectedStatus = $('#status').val();

            tableIns.reload({
                where: {
                    status: selectedStatus,
                    teacherId: ${sessionScope.loginTeacher != null ? sessionScope.loginTeacher.id : 0}
                },
                page: {curr: 1}
            });
        });

        // 支持下拉框改变自动搜索
        $('#status').on('change', function(){
            $('#searchBtn').click();
        });

        table.on('tool(borrowTable)', function(obj){
            var data = obj.data;
            if(obj.event === 'renew'){
                layer.confirm('确定要为《' + data.bookTitle + '》申请续借吗？', {
                    icon: 3,
                    title: '<i class="layui-icon">&#xe605;</i> 续借申请',
                    btn: ['确定申请', '取消']
                }, function(index){
                    $.ajax({
                        url: '/borrow/applyRenew/' + data.id,
                        type: 'POST',
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('✅ 续借申请已提交，请等待审核', {icon: 1, time: 2000});
                                setTimeout(function() {
                                    tableIns.reload();
                                }, 1500);
                            } else {
                                layer.msg(res.msg || '❌ 申请失败', {icon: 2});
                            }
                        },
                        error: function() {
                            layer.msg('❌ 网络错误', {icon: 2});
                        }
                    });
                    layer.close(index);
                });
            }
        });

        loadStats();
    });
</script>
</body>
</html>
