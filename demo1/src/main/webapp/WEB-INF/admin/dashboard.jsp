<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>数据统计 - 图书馆管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.css">
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
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

        .refresh-info {
            font-size: 13px;
            opacity: 0.9;
        }

        .refresh-info i { margin-right: 5px; }

        .main-container { max-width: 1400px; margin: 0 auto; padding: 30px; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
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

        .chart-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .chart-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .chart-title {
            font-size: 18px;
            font-weight: 600;
            color: #2d3436;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .hot-books-table {
            width: 100%;
        }

        .hot-books-table td {
            padding: 12px 8px;
            border-bottom: 1px solid #f0f0f0;
        }

        .rank-badge {
            display: inline-block;
            width: 24px;
            height: 24px;
            line-height: 24px;
            text-align: center;
            border-radius: 50%;
            background: #f0f0f0;
            color: #666;
            font-size: 12px;
            font-weight: bold;
        }

        .rank-badge.top1 { background: linear-gradient(135deg, #fbbf24, #f59e0b); color: white; }
        .rank-badge.top2 { background: linear-gradient(135deg, #9ca3af, #6b7280); color: white; }
        .rank-badge.top3 { background: linear-gradient(135deg, #d97706, #b45309); color: white; }

        .book-title {
            font-weight: 500;
            color: #2d3436;
        }

        .borrow-count {
            color: #667eea;
            font-weight: 600;
        }

        .loading {
            text-align: center;
            padding: 40px;
            color: #999;
        }
    </style>
</head>
<body>
<div class="header">
    <h2>📊 数据统计分析</h2>
    <div class="refresh-info">
        <i>🕐</i>最后更新：<span id="lastUpdateTime">--</span>
    </div>
</div>

<div class="main-container">
    <div class="stats-grid">
        <div class="stats-card">
            <div class="stats-icon">📖</div>
            <div class="stats-number" id="todayBorrow">0</div>
            <div class="stats-label">今日借书量</div>
        </div>

        <div class="stats-card">
            <div class="stats-icon">📚</div>
            <div class="stats-number" id="todayReturn">0</div>
            <div class="stats-label">今日还书量</div>
        </div>

        <div class="stats-card">
            <div class="stats-icon">📝</div>
            <div class="stats-number" id="totalBorrowing">0</div>
            <div class="stats-label">当前借阅总数</div>
        </div>

        <div class="stats-card">
            <div class="stats-icon">⏰</div>
            <div class="stats-number" id="totalOverdue">0</div>
            <div class="stats-label">逾期未还总数</div>
        </div>
    </div>

    <div class="chart-grid">
        <div class="chart-card">
            <div class="chart-title">📈 近 7 天借阅趋势</div>
            <div id="trendChart" style="height: 350px;"></div>
        </div>

        <div class="chart-card">
            <div class="chart-title">🔥 热门图书排行榜 TOP10</div>
            <table class="hot-books-table">
                <tbody id="hotBooksList"></tbody>
            </table>
        </div>
    </div>
</div>

<script>
var trendChart = null;

function loadDashboard() {
    // 更新最后更新时间
    var now = new Date();
    $('#lastUpdateTime').text(formatDateTime(now));

    // 加载统计数据
    $.get('/admin/dashboard/data', function(res) {
        if(res.code === 0 && res.data) {
            animateValue('todayBorrow', parseInt($('#todayBorrow').text()) || 0, res.data.todayBorrowCount || 0);
            animateValue('todayReturn', parseInt($('#todayReturn').text()) || 0, res.data.todayReturnCount || 0);
            animateValue('totalBorrowing', parseInt($('#totalBorrowing').text()) || 0, res.data.totalBorrowing || 0);
            animateValue('totalOverdue', parseInt($('#totalOverdue').text()) || 0, res.data.totalOverdue || 0);
        }
    });

    // 加载趋势图
    $.get('/admin/dashboard/trend', function(res) {
        if(res.code === 0 && res.data && res.data.length > 0) {
            var dates = [];
            var borrows = [];
            var returns = [];

            for(var i = 0; i < res.data.length; i++) {
                dates.push(res.data[i].date);
                borrows.push(res.data[i].borrowCount);
                returns.push(res.data[i].returnCount);
            }

            if(!trendChart) {
                trendChart = echarts.init(document.getElementById('trendChart'));
            }

            trendChart.setOption({
                tooltip: {
                    trigger: 'axis',
                    backgroundColor: 'rgba(255, 255, 255, 0.9)',
                    borderColor: '#eee',
                    textStyle: { color: '#666' }
                },
                legend: {
                    data: ['借书量', '还书量'],
                    bottom: 0
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '10%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    data: dates,
                    axisLine: { lineStyle: { color: '#ddd' } },
                    axisLabel: { color: '#666' }
                },
                yAxis: {
                    type: 'value',
                    splitLine: { lineStyle: { color: '#f0f0f0' } },
                    axisLabel: { color: '#666' }
                },
                series: [
                    {
                        name: '借书量',
                        type: 'line',
                        smooth: true,
                        data: borrows,
                        itemStyle: { color: '#667eea' },
                        areaStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(102, 126, 234, 0.3)'
                            }, {
                                offset: 1,
                                color: 'rgba(102, 126, 234, 0.01)'
                            }])
                        }
                    },
                    {
                        name: '还书量',
                        type: 'line',
                        smooth: true,
                        data: returns,
                        itemStyle: { color: '#f093fb' },
                        areaStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(240, 147, 251, 0.3)'
                            }, {
                                offset: 1,
                                color: 'rgba(240, 147, 251, 0.01)'
                            }])
                        }
                    }
                ]
            });
        }
    });

    // 加载热门图书
    $.get('/admin/dashboard/hotBooks', function(res) {
        if(res.code === 0 && res.data) {
            var html = '';
            for(var i = 0; i < res.data.length; i++) {
                var rankClass = '';
                if(i === 0) rankClass = 'top1';
                else if(i === 1) rankClass = 'top2';
                else if(i === 2) rankClass = 'top3';

                html += '<tr>' +
                    '<td width="50"><span class="rank-badge ' + rankClass + '">' + (i+1) + '</span></td>' +
                    '<td><span class="book-title">' + res.data[i].title + '</span></td>' +
                    '<td width="120" align="right"><span class="borrow-count">' + res.data[i].borrowCount + ' 次</span></td>' +
                    '</tr>';
            }
            $('#hotBooksList').html(html);
        }
    });
}

function animateValue(id, start, end) {
    if(start === end) return;
    var range = end - start;
    var current = start;
    var increment = end > start ? 1 : -1;
    var stepTime = Math.abs(Math.floor(300 / range));
    if(stepTime < 50) stepTime = 50;

    var timer = setInterval(function() {
        current += increment;
        $('#' + id).text(current);
        if (current == end) {
            clearInterval(timer);
        }
    }, stepTime);
}

function formatDateTime(date) {
    var year = date.getFullYear();
    var month = ('0' + (date.getMonth() + 1)).slice(-2);
    var day = ('0' + date.getDate()).slice(-2);
    var hours = ('0' + date.getHours()).slice(-2);
    var minutes = ('0' + date.getMinutes()).slice(-2);
    var seconds = ('0' + date.getSeconds()).slice(-2);
    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
}

$(document).ready(function() {
    loadDashboard();
    // 每 30 秒自动刷新
    setInterval(loadDashboard, 30000);

    // 窗口大小改变时重新渲染图表
    $(window).resize(function() {
        if(trendChart) {
            trendChart.resize();
        }
    });
});
</script>
</body>
</html>