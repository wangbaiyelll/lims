<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理后台 - 图书馆管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
    <style>
        body { padding: 0; background-color: #f5f6fa; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; }

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

        .header-user { display: flex; align-items: center; gap: 15px; }
        .header-user span { font-size: 14px; opacity: 0.9; }
        .logout-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s;
        }
        .logout-btn:hover { background: rgba(255,255,255,0.3); }

        .main-container { max-width: 1400px; margin: 0 auto; padding: 30px; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stats-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
        }

        .stats-card:nth-child(1)::before { background: linear-gradient(to bottom, #667eea, #764ba2); }
        .stats-card:nth-child(2)::before { background: linear-gradient(to bottom, #f093fb, #f5576c); }
        .stats-card:nth-child(3)::before { background: linear-gradient(to bottom, #4facfe, #00f2fe); }
        .stats-card:nth-child(4)::before { background: linear-gradient(to bottom, #43e97b, #38f9d7); }

        .stats-icon {
            font-size: 32px;
            margin-bottom: 10px;
        }

        .stats-number {
            font-size: 36px;
            font-weight: bold;
            color: #2d3436;
            margin: 10px 0;
        }

        .stats-label {
            color: #636e72;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #2d3436;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .function-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }

        .function-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            text-decoration: none;
            display: block;
            color: inherit;
        }

        .function-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .function-icon {
            font-size: 40px;
            margin-bottom: 12px;
        }

        .function-name {
            font-size: 16px;
            font-weight: 500;
            color: #2d3436;
        }

        .function-desc {
            font-size: 12px;
            color: #b2bec3;
            margin-top: 8px;
        }
    </style>
</head>
<body>
<div class="header">
    <h2>📚 图书馆管理系统</h2>
    <div class="header-user">
        <span>欢迎，${sessionScope.loginAdmin.name}</span>
        <a href="/logout" class="logout-btn">退出登录</a>
    </div>
</div>

<div class="main-container">
    <div class="stats-grid">
        <div class="stats-card">
            <div class="stats-icon">📖</div>
            <div class="stats-number" id="bookCount">0</div>
            <div class="stats-label">图书总数</div>
        </div>
        <div class="stats-card">
            <div class="stats-icon">📝</div>
            <div class="stats-number" id="borrowCount">0</div>
            <div class="stats-label">借阅总数</div>
        </div>
        <div class="stats-card">
            <div class="stats-icon">⏰</div>
            <div class="stats-number" id="overdueCount">0</div>
            <div class="stats-label">逾期数量</div>
        </div>
        <div class="stats-card">
            <div class="stats-icon">✅</div>
            <div class="stats-number" id="pendingRenewCount">0</div>
            <div class="stats-label">待审核续借</div>
        </div>
    </div>

    <div class="section-title">
        <span>🚀 快速入口</span>
    </div>

    <div class="function-grid">
        <a href="/admin/book/list" class="function-card">
            <div class="function-icon">📚</div>
            <div class="function-name">图书管理</div>
            <div class="function-desc">管理图书信息</div>
        </a>

        <a href="/admin/stock-list" class="function-card">
            <div class="function-icon">📦</div>
            <div class="function-name">库存管理</div>
            <div class="function-desc">管理图书库存</div>
        </a>

        <a href="/admin/borrow/list" class="function-card">
            <div class="function-icon">📝</div>
            <div class="function-name">借阅管理</div>
            <div class="function-desc">查看借阅记录</div>
        </a>

        <a href="/admin/log/list" class="function-card">
            <div class="function-icon">📋</div>
            <div class="function-name">操作日志</div>
            <div class="function-desc">查看所有操作记录</div>
        </a>

        <a href="/borrow/renew/list" class="function-card">
            <div class="function-icon">🔄</div>
            <div class="function-name">续借审核</div>
            <div class="function-desc">审批续借申请</div>
        </a>

        <a href="/admin/fine/list" class="function-card">
            <div class="function-icon">💰</div>
            <div class="function-name">罚款管理</div>
            <div class="function-desc">处理逾期罚款</div>
        </a>

        <a href="/admin/teacher/list" class="function-card">
            <div class="function-icon">👨‍🏫</div>
            <div class="function-name">教师管理</div>
            <div class="function-desc">管理教师账户</div>
        </a>

        <a href="/admin/dashboard" class="function-card">
            <div class="function-icon">📊</div>
            <div class="function-name">数据统计</div>
            <div class="function-desc">数据统计分析</div>
        </a>
    </div>
</div>

<script>
$(document).ready(function() {
    loadStats();
});

function loadStats() {
    $.get('/admin/book/data', {page: 1, limit: 10}, function(res) {
        $('#bookCount').text(res.count || 0);
    });

    $.get('/admin/borrow/data', {page: 1, limit: 10}, function(res) {
        $('#borrowCount').text(res.count || 0);
    });

    $.get('/admin/borrow/overdue', {page: 1, limit: 10}, function(res) {
        $('#overdueCount').text(res.count || 0);
    });

    $.get('/borrow/renew/data', {status: 0, page: 1, limit: 10}, function(res) {
        $('#pendingRenewCount').text(res.count || 0);
    });
}
</script>
</body>
</html>
