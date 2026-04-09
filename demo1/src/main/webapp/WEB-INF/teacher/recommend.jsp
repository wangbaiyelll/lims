<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>推荐图书 - 教师中心</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/css/layui.css">
    <style>
        body {
            padding: 20px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        /* 页面标题 */
        .page-header {
            background: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .page-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            display: flex;
            align-items: center;
        }
        .page-title i {
            margin-right: 12px;
            font-size: 28px;
            color: #1E9FFF;
        }
        .page-subtitle {
            margin-top: 10px;
            color: #666;
            font-size: 14px;
        }

        /* 推荐区域 */
        .recommend-section {
            margin-bottom: 25px;
        }
        .section-header {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .section-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            display: flex;
            align-items: center;
        }
        .section-title i { margin-right: 10px; font-size: 22px; }
        .section-desc {
            color: #666;
            font-size: 14px;
            margin-left: 15px;
            padding-left: 15px;
            border-left: 3px solid #1E9FFF;
        }

        /* 图书卡片 */
        .book-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            height: 280px;
            display: flex;
            flex-direction: column;
        }
        .book-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.15);
        }
        .book-header {
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .book-header.personal {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .book-header.hot {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .book-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .book-body {
            padding: 15px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .book-info {
            flex: 1;
            font-size: 13px;
            color: #666;
            line-height: 1.8;
        }
        .book-info p {
            margin: 5px 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .book-reason {
            margin-top: 10px;
            padding: 8px 12px;
            background: linear-gradient(135deg, #fef3f3 0%, #fff5f5 100%);
            border-left: 3px solid #FF5722;
            border-radius: 4px;
            font-size: 12px;
            color: #FF5722;
            font-weight: 500;
        }
        .book-reason i {
            margin-right: 5px;
        }
        .book-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #eee;
        }
        .stat-item {
            font-size: 12px;
            color: #999;
        }
        .stat-item strong {
            color: #1E9FFF;
            font-size: 16px;
            margin-left: 3px;
        }
        .stat-item.strong strong {
            color: #FF5722;
        }
        .borrow-btn {
            margin-top: 10px;
            width: 100%;
            border-radius: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: all 0.3s ease;
        }
        .borrow-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
        }

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .empty-state i {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 20px;
        }
        .empty-state p {
            font-size: 16px;
            color: #999;
        }

        /* 徽章 */
        .badge-reason {
            display: inline-block;
            padding: 3px 10px;
            background: linear-gradient(135deg, #FF5722 0%, #ff7849 100%);
            color: white;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>
<div class="layui-container" style="max-width: 1400px;">
    <!-- 页面标题 -->
    <div class="page-header">
        <div class="page-title">
            <i class="layui-icon layui-icon-read"></i>
            推荐图书
        </div>
        <div class="page-subtitle">
            💡 基于您的借阅历史和阅读偏好，为您精选优质图书
        </div>
    </div>

    <!-- 个性化推荐 -->
    <div class="recommend-section">
        <div class="section-header">
            <div class="section-title">
                <i class="layui-icon layui-icon-star" style="color: #FFB800;"></i>
                猜你喜欢
                <span class="section-desc">根据您的借阅历史智能推荐</span>
            </div>
        </div>
        <div class="layui-row layui-col-space20" id="personalRecommend">
            <div class="layui-col-md12">
                <div class="empty-state">
                    <i class="layui-icon layui-icon-loading layui-anim layui-anim-rotate layui-anim-loop"></i>
                    <p>正在为您加载推荐图书...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- 热门推荐 -->
    <div class="recommend-section">
        <div class="section-header">
            <div class="section-title">
                <i class="layui-icon layui-icon-fire" style="color: #FF5722;"></i>
                热门推荐
                <span class="section-desc">全校借阅次数最多的图书</span>
            </div>
        </div>
        <div class="layui-row layui-col-space20" id="hotRecommend">
            <div class="layui-col-md12">
                <div class="empty-state">
                    <i class="layui-icon layui-icon-loading layui-anim layui-anim-rotate layui-anim-loop"></i>
                    <p>正在加载热门图书...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/layui.js"></script>
<script>
    layui.use(['layer'], function(){
        var layer = layui.layer;
        var $ = layui.$;

        // 加载个性化推荐
        $.get('/teacher/recommend/data', function(res){
            if(res.code === 0 && res.data && res.data.length > 0){
                var html = '';
                res.data.forEach(function(book){
                    html += '<div class="layui-col-md3">';
                    html += '<div class="book-card">';
                    html += '<div class="book-header personal">';
                    html += '<div class="book-title">' + book.title + '</div>';
                    html += '<div style="font-size: 12px; opacity: 0.9;">📚 ' + book.author + '</div>';
                    html += '</div>';
                    html += '<div class="book-body">';
                    html += '<div class="book-info">';
                    html += '<p><i class="layui-icon layui-icon-engine" style="margin-right: 5px;"></i>出版社：' + (book.publisher || '未知') + '</p>';
                    html += '<p><i class="layui-icon layui-icon-rmb" style="margin-right: 5px;"></i>价格：¥' + (book.price || '0') + '</p>';
                    html += '<p><i class="layui-icon layui-icon-survey" style="margin-right: 5px;"></i>可借：<strong style="color: #5FB878;">' + (book.availableQty || 0) + '</strong> 本</p>';
                    html += '</div>';
                    html += '<div class="book-reason">';
                    html += '<i class="layui-icon layui-icon-about"></i>';
                    html += '推荐理由：您借阅过 ' + (book.categoryName || '相关') + ' 类图书';
                    html += '</div>';
                    html += '<button class="layui-btn layui-btn-sm borrow-btn" data-id="' + book.id + '">';
                    html += '<i class="layui-icon layui-icon-add-1"></i> 立即借阅';
                    html += '</button>';
                    html += '</div></div></div>';
                });
                $('#personalRecommend').html(html);
            } else {
                $('#personalRecommend').html('<div class="layui-col-md12"><div class="empty-state"><i class="layui-icon layui-icon-face-surprised"></i><p>暂无推荐，多借阅一些图书吧~</p></div></div>');
            }

            bindBorrowEvent('.borrow-btn');
        }).fail(function(){
            $('#personalRecommend').html('<div class="layui-col-md12"><div class="empty-state"><i class="layui-icon layui-icon-face-cry"></i><p>加载失败，请稍后重试</p></div></div>');
        });

        // 加载热门图书
        $.get('/teacher/book/popular', {limit: 8}, function(res){
            if(res.code === 0 && res.data && res.data.length > 0){
                var html = '';
                res.data.forEach(function(book, index){
                    html += '<div class="layui-col-md3">';
                    html += '<div class="book-card">';
                    html += '<div class="book-header hot">';
                    html += '<div style="display: flex; justify-content: space-between; align-items: center;">';
                    html += '<div class="book-title" style="flex: 1;">' + book.title + '</div>';
                    html += '<span class="badge-reason">🔥 TOP' + (index + 1) + '</span>';
                    html += '</div>';
                    html += '<div style="font-size: 12px; opacity: 0.9;">📚 ' + book.author + '</div>';
                    html += '</div>';
                    html += '<div class="book-body">';
                    html += '<div class="book-info">';
                    html += '<p><i class="layui-icon layui-icon-engine" style="margin-right: 5px;"></i>出版社：' + (book.publisher || '未知') + '</p>';
                    html += '<p><i class="layui-icon layui-icon-rmb" style="margin-right: 5px;"></i>价格：¥' + (book.price || '0') + '</p>';
                    html += '<p><i class="layui-icon layui-icon-survey" style="margin-right: 5px;"></i>可借：<strong style="color: #5FB878;">' + (book.availableQty || 0) + '</strong> 本</p>';
                    html += '</div>';
                    html += '<div class="book-stats">';
                    html += '<div class="stat-item strong">🔥 借阅：<strong>' + (book.borrowCount || 0) + '</strong> 次</div>';
                    html += '</div>';
                    html += '<button class="layui-btn layui-btn-sm borrow-btn" data-id="' + book.id + '">';
                    html += '<i class="layui-icon layui-icon-add-1"></i> 立即借阅';
                    html += '</button>';
                    html += '</div></div></div>';
                });
                $('#hotRecommend').html(html);
            } else {
                $('#hotRecommend').html('<div class="layui-col-md12"><div class="empty-state"><i class="layui-icon layui-icon-face-surprised"></i><p>暂无热门图书</p></div></div>');
            }

            bindBorrowEvent('.borrow-btn');
        }).fail(function(){
            $('#hotRecommend').html('<div class="layui-col-md12"><div class="empty-state"><i class="layui-icon layui-icon-face-cry"></i><p>加载失败，请稍后重试</p></div></div>');
        });

        // 绑定借阅事件
        function bindBorrowEvent(selector){
            $(selector).click(function(){
                var bookId = $(this).data('id');
                var bookTitle = $(this).closest('.book-card').find('.book-title').text().trim();

                layer.confirm('<i class="layui-icon layui-icon-book"></i> 确认借阅《' + bookTitle + '》吗？', {
                    icon: 3,
                    title: '借阅确认',
                    btn: ['确认借阅', '取消'],
                    shadeClose: true
                }, function(index){
                    layer.prompt({
                        title: '📍 选择馆藏位置',
                        formType: 2,
                        value: 'A-01-01',
                        area: ['400px', '150px'],
                        placeholder: '请输入馆藏位置编码'
                    }, function(locationCode, layerIndex){
                        layer.close(layerIndex);

                        // 显示加载提示
                        var loadIndex = layer.load(1, {
                            shade: [0.1, '#fff'],
                            time: 10000
                        });

                        // 先查询位置 ID
                        $.get('/teacher/location/getByCode', {code: locationCode}, function(locRes){
                            if(locRes.code === 0 && locRes.data){
                                var locationId = locRes.data.id;

                                // 使用位置 ID 进行借阅
                                $.ajax({
                                    url: '/borrow/doBorrow',
                                    type: 'POST',
                                    data: {bookId: bookId, locationId: locationId},
                                    success: function(res){
                                        layer.close(loadIndex);
                                        if(res.code === 0){
                                            layer.msg('✅ 借书成功', {icon: 1, time: 2000});
                                        } else {
                                            layer.msg('❌ ' + res.msg, {icon: 2, time: 3000});
                                        }
                                    },
                                    error: function(){
                                        layer.close(loadIndex);
                                        layer.msg('❌ 网络错误，请稍后重试', {icon: 2, time: 3000});
                                    }
                                });
                            } else {
                                layer.close(loadIndex);
                                layer.msg('❌ 位置编码不存在', {icon: 2, time: 3000});
                            }
                        });
                    });
                });
            });
        }
    });
</script>
</body>
</html>