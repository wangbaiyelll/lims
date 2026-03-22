<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理后台</title>
    <!-- 替换为本地资源 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <style>
        body { padding: 20px; }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .stats-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stats-number {
            font-size: 24px;
            font-weight: bold;
            color: #5FB878;
            margin: 10px 0;
        }
        .stats-label {
            color: #666;
            font-size: 14px;
        }
        .quick-links {
            margin-top: 30px;
        }
        .link-btn {
            width: 120px;
            margin: 10px;
        }
    </style>
</head>
<body>
<div class="layui-container">
    <div class="header">
        <h2>📚 图书管理系统 - 管理后台</h2>
        <div>
            <span>欢迎，${sessionScope.loginAdmin.realName}</span>
            <a href="/logout" style="margin-left: 20px;">退出登录</a>
        </div>
    </div>

    <div class="layui-row layui-col-space20">
        <div class="layui-col-md3">
            <div class="stats-card">
                <div class="stats-number" id="bookCount">0</div>
                <div class="stats-label">图书总数</div>
            </div>
        </div>
        <div class="layui-col-md3">
            <div class="stats-card">
                <div class="stats-number" id="borrowCount">0</div>
                <div class="stats-label">借阅总数</div>
            </div>
        </div>
        <div class="layui-col-md3">
            <div class="stats-card">
                <div class="stats-number" id="overdueCount">0</div>
                <div class="stats-label">逾期数量</div>
            </div>
        </div>
        <div class="layui-col-md3">
            <div class="stats-card">
                <div class="stats-number" id="fineCount">0</div>
                <div class="stats-label">待处理续借</div>
            </div>
        </div>
    </div>

    <div class="quick-links">
        <h3>快速入口</h3>
        <div class="layui-btn-container">
            <button class="layui-btn link-btn" onclick="goTo('/admin/book/list')">图书管理</button>
            <button class="layui-btn link-btn" onclick="goTo('/admin/stock-list')">库存管理</button>
            <button class="layui-btn link-btn" onclick="goTo('/borrow/renew/list')">续借审核</button>
            <button class="layui-btn link-btn" onclick="goTo('/admin/dashboard')">数据统计</button>
        </div>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>

<script>
// 添加错误检查
if (typeof $ === 'undefined') {
    console.error('jQuery未加载成功');
} else {
    $(document).ready(function() {
        console.log('jQuery已就绪');
        loadStats();
    });
}

function loadStats() {
    console.log('开始加载统计数据');

    $.get('/admin/book/data', {page: 1, limit: 10}, function(res) {
        console.log('图书数据响应:', res);
        $('#bookCount').text(res.count || 0);
    }).fail(function(xhr, status, error) {
        console.error('图书数据请求失败:', error);
    });

    $.get('/admin/borrow/data', {page: 1, limit: 10}, function(res) {
        console.log('借阅数据响应:', res);
        $('#borrowCount').text(res.count || 0);
    }).fail(function(xhr, status, error) {
        console.error('借阅数据请求失败:', error);
    });

    $.get('/admin/borrow/overdue', {page: 1, limit: 10}, function(res) {
        console.log('逾期数据响应:', res);
        $('#overdueCount').text(res.count || 0);
    }).fail(function(xhr, status, error) {
        console.error('逾期数据请求失败:', error);
    });

    $.get('/borrow/renew/data', {status: 0, page: 1, limit: 10}, function(res) {
        console.log('续借数据响应:', res);
        $('#fineCount').text(res.count || 0);
    }).fail(function(xhr, status, error) {
        console.error('续借数据请求失败:', error);
    });
}

function goTo(url) {
    window.location.href = url;
}
</script>
</body>
</html>
