<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>推荐图书</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
</head>
<body>
<div class="layui-container" style="margin-top: 20px;">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    <span style="font-size: 16px; font-weight: bold;">📚 猜你喜欢</span>
                    <span style="margin-left: 20px; color: #999;">基于您的借阅历史推荐</span>
                </div>
                <div class="layui-card-body" id="personalRecommend">
                    <div style="text-align: center; padding: 50px;">加载中...</div>
                </div>
            </div>
        </div>
    </div>

    <div class="layui-row" style="margin-top: 20px;">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    <span style="font-size: 16px; font-weight: bold;">🔥 热门推荐</span>
                    <span style="margin-left: 20px; color: #999;">全校借阅最多的图书</span>
                </div>
                <div class="layui-card-body" id="hotRecommend">
                    <div style="text-align: center; padding: 50px;">加载中...</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script>
    layui.use(['layer'], function(){
        var layer = layui.layer;

        // 加载个性化推荐
        $.get('/teacher/recommend/data', function(res){
            if(res.code === 0 && res.data.length > 0){
                var html = '<div class="layui-row">';
                res.data.forEach(function(book){
                    html += '<div class="layui-col-md3" style="margin-bottom: 15px;">';
                    html += '<div class="layui-card" style="height: 200px;">';
                    html += '<div class="layui-card-header">' + book.title + '</div>';
                    html += '<div class="layui-card-body">';
                    html += '<p>作者：' + book.author + '</p>';
                    html += '<p>出版社：' + book.publisher + '</p>';
                    html += '<p>价格：¥' + book.price + '</p>';
                    html += '<p>可借：' + (book.availableQty || 0) + '本</p>';
                    html += '<button class="layui-btn layui-btn-xs borrowBtn" data-id="' + book.id + '">立即借阅</button>';
                    html += '</div></div></div>';
                });
                html += '</div>';
                $('#personalRecommend').html(html);
            } else {
                $('#personalRecommend').html('<div style="text-align: center; padding: 50px; color: #999;">暂无推荐，多借阅一些图书吧~</div>');
            }

            // 绑定借阅按钮事件
            $('.borrowBtn').click(function(){
                var bookId = $(this).data('id');
                layer.prompt({
                    title: '选择馆藏位置',
                    formType: 2,
                    value: 'A-01-01',
                    area: ['400px', '150px']
                }, function(locationCode, index){
                    layer.close(index);
                    $.ajax({
                        url: '/borrow/doBorrow',
                        type: 'POST',
                        data: {bookId: bookId, locationCode: locationCode},
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('借书成功', {icon: 1});
                            } else {
                                layer.msg(res.msg, {icon: 2});
                            }
                        }
                    });
                });
            });
        });

        // 加载热门图书
        $.get('/admin/book/popular', {limit: 8}, function(res){
            if(res.code === 0 && res.data.length > 0){
                var html = '<div class="layui-row">';
                res.data.forEach(function(book){
                    html += '<div class="layui-col-md3" style="margin-bottom: 15px;">';
                    html += '<div class="layui-card" style="height: 200px;">';
                    html += '<div class="layui-card-header">' + book.title + '</div>';
                    html += '<div class="layui-card-body">';
                    html += '<p>作者：' + book.author + '</p>';
                    html += '<p>借阅次数：' + (book.borrowCount || 0) + '次</p>';
                    html += '<p>可借：' + (book.availableQty || 0) + '本</p>';
                    html += '<button class="layui-btn layui-btn-xs hotBorrowBtn" data-id="' + book.id + '">立即借阅</button>';
                    html += '</div></div></div>';
                });
                html += '</div>';
                $('#hotRecommend').html(html);

                $('.hotBorrowBtn').click(function(){
                    var bookId = $(this).data('id');
                    layer.prompt({
                        title: '选择馆藏位置',
                        formType: 2,
                        value: 'A-01-01',
                        area: ['400px', '150px']
                    }, function(locationCode, index){
                        layer.close(index);
                        $.ajax({
                            url: '/borrow/doBorrow',
                            type: 'POST',
                            data: {bookId: bookId, locationCode: locationCode},
                            success: function(res){
                                if(res.code === 0){
                                    layer.msg('借书成功', {icon: 1});
                                } else {
                                    layer.msg(res.msg, {icon: 2});
                                }
                            }
                        });
                    });
                });
            } else {
                $('#hotRecommend').html('<div style="text-align: center; padding: 50px; color: #999;">暂无热门图书</div>');
            }
        });
    });
</script>

<style>
    .borrowBtn, .hotBorrowBtn {
        margin-top: 10px;
    }
</style>
</body>
</html>