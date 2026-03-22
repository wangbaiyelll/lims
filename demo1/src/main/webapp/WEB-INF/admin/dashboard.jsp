<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仪表盘</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.css">
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
</head>
<body>
<div class="layui-container" style="margin-top: 20px;">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md3">
            <div class="card">
                <div class="card-title">今日借书量</div>
                <div class="card-value" id="todayBorrow">0</div>
            </div>
        </div>
        <div class="layui-col-md3">
            <div class="card">
                <div class="card-title">今日还书量</div>
                <div class="card-value" id="todayReturn">0</div>
            </div>
        </div>
        <div class="layui-col-md3">
            <div class="card">
                <div class="card-title">当前借阅总数</div>
                <div class="card-value" id="totalBorrowing">0</div>
            </div>
        </div>
        <div class="layui-col-md3">
            <div class="card">
                <div class="card-title">逾期未还总数</div>
                <div class="card-value" id="totalOverdue">0</div>
            </div>
        </div>
        <div class="layui-col-md6">
            <div class="card">
                <div class="card-title">近7天借阅趋势</div>
                <div id="trendChart" style="height: 300px;"></div>
            </div>
        </div>
        <div class="layui-col-md6">
            <div class="card">
                <div class="card-title">热门图书排行榜 TOP10</div>
                <div id="hotBooks" style="height: 300px; overflow-y: auto;">
                    <table class="layui-table" lay-skin="nob">
                        <tbody id="hotBooksList"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 加载数据大屏数据
    function loadDashboard() {
        $.get('/admin/dashboard/data', function(res) {
            if(res.code === 0) {
                $('#todayBorrow').text(res.data.todayBorrowCount);
                $('#todayReturn').text(res.data.todayReturnCount);
                $('#totalBorrowing').text(res.data.totalBorrowing);
                $('#totalOverdue').text(res.data.totalOverdue);
            }
        });

        // 加载趋势图
        $.get('/admin/dashboard/trend', function(res) {
            if(res.code === 0) {
                var dates = res.data.map(item => item.date);
                var borrows = res.data.map(item => item.borrowCount);
                var returns = res.data.map(item => item.returnCount);

                var chart = echarts.init(document.getElementById('trendChart'));
                chart.setOption({
                    tooltip: { trigger: 'axis' },
                    legend: { data: ['借书量', '还书量'] },
                    xAxis: { type: 'category', data: dates },
                    yAxis: { type: 'value' },
                    series: [
                        { name: '借书量', type: 'line', data: borrows, smooth: true, lineStyle: { color: '#5FB878' } },
                        { name: '还书量', type: 'line', data: returns, smooth: true, lineStyle: { color: '#FFB800' } }
                    ]
                });
            }
        });

        // 加载热门图书
        $.get('/admin/dashboard/hotBooks', function(res) {
            if(res.code === 0) {
                var html = '';
                res.data.forEach(function(book, index) {
                    html += '<tr><td style="width:50px">' + (index+1) + '</td><td>' + book.title + '</td><td style="width:80px">借阅' + book.borrowCount + '次</td></tr>';
                });
                $('#hotBooksList').html(html);
            }
        });
    }

    $(document).ready(function() {
        loadDashboard();
        setInterval(loadDashboard, 30000);
    });
</script>
</body>
</html>