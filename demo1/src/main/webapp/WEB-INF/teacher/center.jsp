<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>教师中心</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        .navbar {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 0 30px;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            height: 60px;
        }

        .navbar-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 100%;
        }

        .navbar-brand {
            font-size: 20px;
            font-weight: 700;
            color: #667eea;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .navbar-menu {
            display: flex;
            gap: 5px;
        }

        .navbar-item {
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            color: #555;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .navbar-item:hover {
            background: #f8f9fa;
            color: #667eea;
        }

        .navbar-item.active {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .main-container {
            max-width: 1200px;
            margin: 90px auto 30px;
            padding: 0 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .header h2 {
            margin: 0;
            color: #2d3436;
            font-size: 24px;
        }

        .layui-row {
            margin: 0;
        }

        .profile-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .profile-card h3 {
            margin: 0 0 20px 0;
            color: #667eea;
            font-size: 18px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
        }

        .profile-card p {
            margin: 12px 0;
            line-height: 1.8;
            color: #555;
        }

        .profile-card strong {
            color: #2d3436;
            font-weight: 600;
        }

        .borrowed-list {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .borrowed-list h3 {
            margin: 0 0 20px 0;
            color: #667eea;
            font-size: 18px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
        }

        .layui-table {
            margin: 0;
        }

        .layui-table thead tr {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .layui-table th {
            font-weight: 600;
            text-align: left;
        }

        .layui-table td {
            vertical-align: middle;
        }

        .status-tag {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .status-normal {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            color: white;
        }

        .status-overdue {
            background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
            color: white;
        }

        .status-returned {
            background: linear-gradient(135deg, #a8e6cf, #88d8b0);
            color: #2d3436;
        }

        .status-due-soon {
            background: linear-gradient(135deg, #ff9800, #ff5722);
            color: white;
            font-weight: bold;
            font-size: 13px;
            animation: pulse-warning 2s infinite;
            box-shadow: 0 2px 8px rgba(255, 87, 34, 0.4);
        }

        @keyframes pulse-warning {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.9; transform: scale(1.05); }
        }

        .layui-btn-xs {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
        }

        .layui-btn-xs:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a href="${pageContext.request.contextPath}/teacher/center" class="navbar-brand">
                <i class="layui-icon layui-icon-user"></i> 教师中心
            </a>
            <div class="navbar-menu">
                <a href="./center" class="navbar-item active">
                    <i class="layui-icon layui-icon-home"></i> 首页
                </a>
                <a href="./my-borrow" class="navbar-item">
                    <i class="layui-icon layui-icon-read"></i> 我的借阅
                </a>
                <a href="./my-fine" class="navbar-item">
                    <i class="layui-icon layui-icon-dialogue"></i> 我的罚款
                </a>
                <a href="./recommend" class="navbar-item">
                    <i class="layui-icon layui-icon-star"></i> 推荐图书
                </a>
                <a href="./message" class="navbar-item" id="messageLink">
                    <i class="layui-icon layui-icon-notice"></i> 我的消息
                    <span class="layui-badge-dot" id="unreadDot" style="display: none;"></span>
                </a>
                <a href="../logout" class="navbar-item">
                    <i class="layui-icon layui-icon-logout"></i> 退出
                </a>
            </div>
        </div>
    </nav>

    <div class="main-container">
        <div class="header">
            <h2>👋 欢迎回来，${sessionScope.loginTeacher.name}老师</h2>
            <a href="/logout" style="background: linear-gradient(135deg, #ff6b6b, #ee5a6f); color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: 500;">退出登录</a>
        </div>

        <div class="layui-row layui-col-space20">
            <div class="layui-col-md4">
                <div class="profile-card">
                    <h3>👤 个人信息</h3>
                    <p><strong>姓名：</strong>${sessionScope.loginTeacher.name}</p>
                    <p><strong>工号：</strong>${sessionScope.loginTeacher.empNo}</p>
                    <p><strong>学院：</strong>${sessionScope.loginTeacher.college}</p>
                    <p><strong>电话：</strong>${sessionScope.loginTeacher.phone}</p>
                    <p><strong>邮箱：</strong>${sessionScope.loginTeacher.email}</p>
                </div>
            </div>

            <div class="layui-col-md8">
                <div class="borrowed-list">
                    <h3>📖 当前借阅</h3>
                    <table class="layui-table">
                        <thead>
                            <tr>
                                <th>图书信息</th>
                                <th>借阅日期</th>
                                <th>应还日期</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="borrowList"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
    <script>
        var layer;

        layui.use(['layer'], function(){
            layer = layui.layer;

            $(document).ready(function() {
                const teacherId = ${sessionScope.loginTeacher != null ? sessionScope.loginTeacher.id : 0};

                if(teacherId === 0) {
                    $('#borrowList').html('<tr><td colspan="5" style="text-align:center; padding: 30px;">请先登录</td></tr>');
                    return;
                }

                // 加载未读消息数量
                loadUnreadMessageCount();

                loadBorrowRecords(teacherId);
            });

            // 加载未读消息数量
            function loadUnreadMessageCount(){
                $.get('../message/count', function(res){
                    if(res.code === 0 && res.data && res.data.unread > 0){
                        $('#unreadDot').show();
                        document.title = `教师中心 (${res.data.unread})`;
                    }
                });
            }

            function loadBorrowRecords(teacherId) {
                $.get('/borrow/my-borrows', {
                    teacherId: teacherId,
                    status: '',
                    page: 1,
                    limit: 10
                }, function(res) {
                    if(res.code === 0 && res.data && res.data.length > 0) {
                        const tbody = $('#borrowList');
                        tbody.empty();

                        // 检查是否有逾期未还的图书
                        let hasOverdue = false;
                        res.data.forEach(function(record) {
                            if (record.status === 3) {
                                hasOverdue = true;
                            }
                        });

                        res.data.forEach(function(record) {
                            // 计算剩余天数
                            let daysLeft = null;
                            if (record.dueDate) {
                                try {
                                    const dueDateStr = record.dueDate.toString();
                                    let dueDate;

                                    if (dueDateStr.includes('T')) {
                                        dueDate = new Date(dueDateStr);
                                        var year = dueDate.getFullYear();
                                        var month = dueDate.getMonth();
                                        var day = dueDate.getDate();
                                        dueDate = new Date(year, month, day, 23, 59, 59, 999);
                                    } else {
                                        const formattedDate = dueDateStr.replace(/-/g, '/');
                                        dueDate = new Date(formattedDate);
                                        dueDate.setHours(23, 59, 59, 999);
                                    }

                                    const now = new Date();
                                    now.setHours(0, 0, 0, 0);

                                    const diffTime = dueDate.getTime() - now.getTime();
                                    daysLeft = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                                } catch (e) {
                                    console.error('日期计算错误:', record.dueDate);
                                    daysLeft = null;
                                }
                            }

                            // 判断是否临期（3 天内）
                            const isDueSoon = daysLeft !== null && daysLeft >= 0 && daysLeft <= 3;
                            const isOverdue = daysLeft !== null && daysLeft < 0;

                            let statusClass = record.status === 3 ? 'status-overdue' : (record.status === 2 ? 'status-returned' : 'status-normal');
                            let statusText = record.status === 3 ? '逾期' : (record.status === 2 ? '已归还' : '正常');

                            // 如果是临期状态，使用特殊样式
                            if (isDueSoon && record.status === 1) {
                                statusClass = 'status-due-soon';
                                statusText = '⚠️ 临期 (' + daysLeft + '天)';
                            } else if (isOverdue && (record.status === 1 || record.status === 3)) {
                                statusClass = 'status-overdue';
                                const overdueDays = daysLeft < 0 ? -daysLeft : daysLeft;
                                statusText = '❌ 逾期 (' + overdueDays + '天)';
                            }

                            let actionButton = '<span style="color: #999; font-size: 13px;">-</span>';

                            // 如果有续借申请信息
                            if (record.renewalStatus !== undefined && record.renewalStatus !== null) {
                                if (record.renewalStatus === 0) {
                                    actionButton = '<span style="color: #ff9800; font-size: 13px; font-weight: 500;" title="等待管理员审核">⏳ 审核中</span>';
                                } else if (record.renewalStatus === 1) {
                                    actionButton = '<span style="color: #4CAF50; font-size: 13px; font-weight: 500;" title="✅ 审核已通过">' +
                                                   '✅ 已通过' +
                                                   (record.renewalAuditDate ? '<br><small style="color: #999;">' + formatDate(record.renewalAuditDate) + '</small>' : '') +
                                                   '</span>';
                                } else if (record.renewalStatus === 2) {
                                    const remark = record.renewalRemark || '无';
                                    actionButton = '<span style="color: #f44336; font-size: 13px; font-weight: 500;" title="❌ 审核被拒绝：' + remark + '">' +
                                                   '❌ 已拒绝<br><small style="color: #999; font-size: 11px;">' + remark + '</small></span>';
                                }
                            } else if (record.hasPendingRenewal) {
                                actionButton = '<span style="color: #ff9800; font-size: 13px; font-weight: 500;">⏳ 审核中</span>';
                            } else if (record.status === 3) {
                                actionButton = '<span style="color: #ff4500; font-size: 13px; font-weight: 500;">❌ 已逾期</span>';
                            } else if (record.status === 1) {
                                if (hasOverdue) {
                                    actionButton = '<span style="color: #ff4500; font-size: 13px;" title="有逾期未还图书，不能续借">❌ 有逾期不能续借</span>';
                                } else {
                                    actionButton = '<button class="layui-btn layui-btn-xs" onclick="window.renewBook(' + record.id + ')">申请续借</button>';
                                }
                            }

                            // 临期和逾期记录添加特殊背景样式
                            let rowStyle = '';
                            if (isDueSoon && record.status === 1) {
                                rowStyle = 'style="background: linear-gradient(135deg, #fff3e0, #ffebee); border-left: 4px solid #ff5722 !important;"';
                            } else if (isOverdue && (record.status === 1 || record.status === 3)) {
                                rowStyle = 'style="background: linear-gradient(135deg, #ffebee, #ffcdd2); border-left: 4px solid #f44336 !important;"';
                            }

                            const row = '<tr ' + rowStyle + '>' +
                                '<td style="font-size: 15px;"><strong>' + record.bookTitle + '</strong><br><small style="color: #999;">' + (record.author || '未知作者') + '</small></td>' +
                                '<td style="font-size: 15px;">' + formatDate(record.borrowDate) + '</td>' +
                                '<td style="font-size: 15px;">' + formatDate(record.dueDate) + '</td>' +
                                '<td><span class="status-tag ' + statusClass + '">' + statusText + '</span></td>' +
                                '<td style="min-width: 130px;">' + actionButton + '</td>' +
                                '</tr>';

                            tbody.append(row);
                        });
                    } else {
                        $('#borrowList').html('<tr><td colspan="5" style="text-align:center; padding: 30px; color: #999;">暂无借阅记录</td></tr>');
                    }
                }).fail(function(xhr, status, error) {
                    console.error('加载失败:', error);
                    $('#borrowList').html('<tr><td colspan="5" style="text-align:center; padding: 30px; color: #ff6b6b;">数据加载失败</td></tr>');
                });
            }

            window.renewBook = function(borrowId) {
                layer.confirm('确定要申请续借吗？', {
                    icon: 3,
                    title: '提示'
                }, function(index){
                    $.post('/borrow/applyRenew/' + borrowId, function(res) {
                        if(res.code === 0) {
                            layer.msg('✅ 续借申请已提交，请等待审核', {icon: 1});
                            setTimeout(function() {
                                location.reload();
                            }, 1500);
                        } else {
                            layer.msg(res.msg || '❌ 申请失败', {icon: 2});
                        }
                    }).fail(function() {
                        layer.msg('❌ 网络错误', {icon: 2});
                    });
                    layer.close(index);
                });
            };

            window.formatDate = function(dateString) {
                if(!dateString) return '';
                const date = new Date(dateString);
                return date.getFullYear() + '-' +
                       String(date.getMonth() + 1).padStart(2, '0') + '-' +
                       String(date.getDate()).padStart(2, '0');
            };
        });
    </script>
</body>
</html>
