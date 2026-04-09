<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>我的消息 - 教师中心</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/css/layui.css">
    <style>
        body { padding: 15px; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }

        /* 顶部导航 */
        .page-header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .page-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            display: flex;
            align-items: center;
        }
        .page-title i { margin-right: 10px; font-size: 28px; color: #1E9FFF; }

        /* 统计卡片 */
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
        }
        .stat-card.total::before { background: linear-gradient(to bottom, #1E9FFF, #00d2ff); }
        .stat-card.unread::before { background: linear-gradient(to bottom, #FF5722, #ff7849); }

        .stat-icon {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 48px;
            opacity: 0.15;
        }
        .stat-title {
            color: #666;
            font-size: 14px;
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            line-height: 1;
        }
        .stat-value.total {
            background: linear-gradient(135deg, #1E9FFF 0%, #00d2ff 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .stat-value.unread {
            background: linear-gradient(135deg, #FF5722 0%, #ff7849 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .stat-subtitle {
            font-size: 12px;
            color: #999;
            margin-top: 8px;
        }

        /* 搜索区域 */
        .search-box {
            padding: 20px;
            background: white;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .search-box .layui-form-label { width: 80px; font-weight: 500; }
        .search-box .layui-input-inline { width: 160px; }
        .search-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
            display: flex;
            align-items: center;
        }
        .search-title i { margin-right: 8px; color: #1E9FFF; }

        /* 消息列表 */
        .layui-card {
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        .layui-card-header {
            font-weight: bold;
            font-size: 16px;
            padding: 18px 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-bottom: 2px solid #1E9FFF;
            display: flex;
            align-items: center;
        }
        .layui-card-header i { margin-right: 10px; color: #1E9FFF; }

        .layui-table-cell {
            padding: 14px 15px;
            line-height: 22px;
        }
        .message-row {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .message-row:hover {
            background-color: #f8f9fa !important;
            transform: scale(1.002);
        }
        .message-row.unread {
            background: linear-gradient(90deg, rgba(30,159,255,0.08) 0%, rgba(255,255,255,0) 100%);
            border-left: 4px solid #1E9FFF;
            font-weight: 500;
        }
        .message-row.unread:hover {
            background: linear-gradient(90deg, rgba(30,159,255,0.15) 0%, rgba(255,255,255,0) 100%);
        }

        .message-type-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .type-overdue {
            background: linear-gradient(135deg, #FF5722 0%, #ff7849 100%);
            color: white;
        }
        .type-renew {
            background: linear-gradient(135deg, #1E9FFF 0%, #00d2ff 100%);
            color: white;
        }
        .type-fine {
            background: linear-gradient(135deg, #FFB800 0%, #ffd045 100%);
            color: white;
        }
        .type-system {
            background: linear-gradient(135deg, #5FB878 0%, #78d493 100%);
            color: white;
        }

        /* 按钮样式 */
        .layui-btn {
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        .layui-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .layui-btn-normal {
            background: linear-gradient(135deg, #5FB878 0%, #78d493 100%);
        }
        .layui-btn-warm {
            background: linear-gradient(135deg, #FFB800 0%, #ffd045 100%);
        }

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state i {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 20px;
        }
        .empty-state p {
            font-size: 16px;
            margin-top: 10px;
        }

        /* 加载更多提示 */
        .load-more-tip {
            text-align: center;
            padding: 20px;
            color: #999;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="layui-fluid">
    <!-- 页面标题 -->
    <div class="page-header">
        <div class="page-title">
            <i class="layui-icon layui-icon-notice"></i>
            我的消息
        </div>
        <div>
            <button type="button" class="layui-btn layui-btn-sm layui-btn-normal" onclick="refreshData()">
                <i class="layui-icon layui-icon-refresh"></i> 刷新
            </button>
            <button type="button" class="layui-btn layui-btn-sm layui-btn-warm" onclick="markAllAsRead()">
                <i class="layui-icon layui-icon-ok-circle"></i> 全部已读
            </button>
        </div>
    </div>

    <!-- 统计卡片 -->
    <div class="layui-row layui-col-space15" style="margin-bottom: 20px;">
        <div class="layui-col-md6">
            <div class="stat-card total">
                <div class="stat-title">全部消息</div>
                <div class="stat-value total" id="totalCount">0</div>
                <div class="stat-subtitle">共收到消息</div>
                <i class="layui-icon stat-icon">📧</i>
            </div>
        </div>
        <div class="layui-col-md6">
            <div class="stat-card unread">
                <div class="stat-title">未读消息</div>
                <div class="stat-value unread" id="unreadCount">0</div>
                <div class="stat-subtitle">待查看消息</div>
                <i class="layui-icon stat-icon">🔔</i>
            </div>
        </div>
    </div>

    <!-- 搜索栏 -->
    <div class="search-box">
        <div class="search-title">
            <i class="layui-icon layui-icon-search"></i>
            筛选条件
        </div>
        <form class="layui-form">
            <div class="layui-inline">
                <label class="layui-form-label">类型</label>
                <div class="layui-input-inline">
                    <select name="type" id="type">
                        <option value="">全部类型</option>
                        <option value="overdue">📅 逾期提醒</option>
                        <option value="renew">🔄 续借通知</option>
                        <option value="fine">💰 罚款通知</option>
                        <option value="system">📢 系统消息</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-inline">
                    <select name="status" id="status">
                        <option value="">全部状态</option>
                        <option value="0">🔴 未读</option>
                        <option value="1">⚪ 已读</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <button type="button" class="layui-btn layui-btn-sm" id="searchBtn">
                    <i class="layui-icon layui-icon-search"></i> 搜索
                </button>
                <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" onclick="resetSearch()">
                    <i class="layui-icon layui-icon-refresh"></i> 重置
                </button>
            </div>
        </form>
    </div>

    <!-- 消息列表 -->
    <div class="layui-card">
        <div class="layui-card-header">
            <i class="layui-icon layui-icon-list"></i>
            消息列表
        </div>
        <div class="layui-card-body">
            <table id="messageTable" lay-filter="messageTable"></table>
        </div>
    </div>
</div>

<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/layui/2.9.8/layui.js"></script>
<script>
    layui.use(['table', 'layer', 'util'], function(){
        var table = layui.table;
        var layer = layui.layer;
        var util = layui.util;
        var $ = layui.$;

        // 渲染表格
        table.render({
            elem: '#messageTable',
            url: '/teacher/message/list',
            method: 'get',
            page: { curr: 1, limit: 10, limits: [10, 20, 50, 100] },
            limit: 10,
            cols: [[
                {field: 'type', title: '类型', width: 120, templet: function(d){
                        var typeMap = {
                            'overdue': '<span class="message-type-badge type-overdue">📅 逾期提醒</span>',
                            'renew': '<span class="message-type-badge type-renew">🔄 续借通知</span>',
                            'fine': '<span class="message-type-badge type-fine">💰 罚款通知</span>',
                            'system': '<span class="message-type-badge type-system">📢 系统消息</span>'
                        };
                        return typeMap[d.type] || '<span class="message-type-badge">未知</span>';
                    }},
                {field: 'title', title: '标题', minWidth: 250, templet: function(d){
                        var icon = '';
                        switch(d.type){
                            case 'overdue': icon = '📅'; break;
                            case 'renew': icon = '🔄'; break;
                            case 'fine': icon = '💰'; break;
                            default: icon = '📢';
                        }
                        return '<div style="display: flex; align-items: center;">' +
                               '<span style="margin-right: 8px;">' + icon + '</span>' +
                               '<span style="' + (d.status === 0 ? 'font-weight: bold;' : '') + '">' + d.title + '</span>' +
                               (d.status === 0 ? '<span class="layui-badge-dot" style="margin-left: 8px;"></span>' : '') +
                               '</div>';
                    }},
                {field: 'content', title: '内容摘要', minWidth: 400, templet: function(d){
                        var content = d.content || '';
                        if(content.length > 80) {
                            content = content.substring(0, 80) + '...';
                        }
                        return '<span style="color: #666;">' + content + '</span>';
                    }},
                {field: 'status', title: '状态', width: 90, templet: function(d){
                        return d.status === 0 ?
                            '<span class="layui-badge layui-bg-orange">未读</span>' :
                            '<span class="layui-badge layui-bg-gray">已读</span>';
                    }},
                {field: 'createTime', title: '发送时间', width: 170, templet: function(d){
                        if(!d.createTime) return '';
                        var date = new Date(d.createTime);
                        var now = new Date();
                        var diff = now - date;

                        if(diff < 60000) return '<span style="color: #FF5722;">刚刚</span>';
                        if(diff < 3600000) return Math.floor(diff / 60000) + '<span style="color: #666;">分钟前</span>';
                        if(diff < 86400000) return Math.floor(diff / 3600000) + '<span style="color: #666;">小时前</span>';
                        if(diff < 604800000) return Math.floor(diff / 86400000) + '<span style="color: #666;">天前</span>';
                        return util.toDateString(date, 'yyyy-MM-dd HH:mm');
                    }},
                {title: '操作', width: 120, toolbar: '#barDemo'}
            ]],
            skin: 'line',
            even: true,
            autoHeight: false,
            done: function(res, curr, count){
                if(res.code === 0){
                    $('#totalCount').text(res.count);
                    // 标记未读行样式
                    $('.layui-table-body tr').each(function(){
                        var dataIndex = $(this).attr('data-index');
                        var rowData = res.data[dataIndex];
                        if(rowData && rowData.status === 0){
                            $(this).addClass('message-row unread');
                        }
                    });
                } else {
                    layer.msg('加载失败：' + (res.msg || '未知错误'), {icon: 2});
                }
            }
        });

        // 监听行点击
        var isProcessing = false;

        table.on('row(messageTable)', function(obj){
            if(isProcessing) return;

            var data = obj.data;

            // 只有未读时才调用
            if(data.status === 0){
                isProcessing = true;

                // 先更新本地状态
                data.status = 1;
                $(this).removeClass('message-row unread');

                // 异步标记为已读
                $.post('/teacher/message/read/' + data.id, function(res){
                    if(res.code === 0){
                        loadCounts();
                        setTimeout(function(){
                            table.reload('messageTable');
                        }, 500);
                    } else {
                        layer.msg('操作失败：' + res.msg, {icon: 2});
                        data.status = 0;
                    }
                    isProcessing = false;
                }).fail(function(xhr){
                    console.error('标记失败:', xhr.responseText);
                    layer.msg('网络错误，请稍后重试', {icon: 2});
                    data.status = 0;
                    isProcessing = false;
                });
            }

            // 显示详情
            showMessageDetail(data);
        });

        // 工具条事件
        table.on('tool(messageTable)', function(obj){
            var data = obj.data;
            var layEvent = obj.event;

            if(layEvent === 'detail'){
                showMessageDetail(data);
            }
        });
    });

    // 显示详情
    function showMessageDetail(message){
        var iconType = '';
        var gradient = '';
        switch(message.type){
            case 'overdue':
                iconType = '📅';
                gradient = 'linear-gradient(135deg, #FF5722 0%, #ff7849 100%)';
                break;
            case 'renew':
                iconType = '🔄';
                gradient = 'linear-gradient(135deg, #1E9FFF 0%, #00d2ff 100%)';
                break;
            case 'fine':
                iconType = '💰';
                gradient = 'linear-gradient(135deg, #FFB800 0%, #ffd045 100%)';
                break;
            default:
                iconType = '📢';
                gradient = 'linear-gradient(135deg, #5FB878 0%, #78d493 100%)';
        }

        layer.open({
            type: 1,
            title: '<span style="background: ' + gradient + '; -webkit-background-clip: text; -webkit-text-fill-color: transparent;">' + iconType + ' ' + message.title + '</span>',
            area: ['650px', '450px'],
            shade: 0.3,
            shadeClose: true,
            content: '<div style="padding: 25px; line-height: 1.8;">' +
                '<div style="background: #f8f9fa; padding: 20px; border-radius: 8px; border-left: 4px solid #1E9FFF;">' +
                '<p style="color: #333; font-size: 15px; margin: 0;">' + message.content + '</p>' +
                '</div>' +
                '<div style="margin-top: 20px; padding-top: 15px; border-top: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">' +
                '<div style="color: #999; font-size: 13px;">' +
                '<i class="layui-icon layui-icon-date" style="margin-right: 5px;"></i>' +
                '发送时间：' + message.createTime +
                '</div>' +
                '<div>' +
                (message.status === 0 ?
                    '<span class="layui-badge layui-bg-orange">未读</span>' :
                    '<span class="layui-badge layui-bg-gray">已读</span>') +
                '</div>' +
                '</div>'
        });
    }

    // 搜索
    layui.use(['table', 'layer', 'jquery'], function(){
        var $ = layui.jquery;
        var table = layui.table;

        $('#searchBtn').on('click', function(){
            var status = $('#status').val();
            var type = $('#type').val();

            table.reload('messageTable', {
                where: {
                    type: type || null,
                    status: status || null
                },
                page: { curr: 1 }
            });
        });
    });

    // 全部标为已读
    window.markAllAsRead = function(){
        layer.confirm('<i class="layui-icon layui-icon-question"></i> 确定要将所有消息标为已读吗？', {
            icon: 3,
            title: '提示',
            btn: ['确定', '取消']
        }, function(index){
            $.post('/teacher/message/read-all', function(res){
                if(res.code === 0){
                    layer.msg('✅ ' + (res.message || '操作成功'), {icon: 1});
                    loadCounts();
                    layui.table.reload('messageTable');
                } else {
                    layer.msg('❌ 操作失败：' + res.msg, {icon: 2});
                }
                layer.close(index);
            });
        });
    };

    // 重置搜索
    window.resetSearch = function(){
        $('#type').val('');
        $('#status').val('');
        layui.table.reload('messageTable', {
            where: {},
            page: { curr: 1 }
        });
    };

    // 刷新数据
    window.refreshData = function(){
        layer.msg('正在刷新...', {icon: 16, time: 500});
        loadCounts();
        layui.table.reload('messageTable');
    };

    // 加载统计数量
    function loadCounts(){
        $.get('/teacher/message/count', function(res){
            if(res.code === 0 && res.data){
                $('#totalCount').text(res.data.total || 0);
                $('#unreadCount').text(res.data.unread || 0);
                document.title = '我的消息 (' + (res.data.unread || 0) + ')';

                // 同步到首页的红点
                if(top !== self && res.data.unread > 0){
                    top.$('#unreadDot').show();
                }
            }
        });
    }

    $(document).ready(function(){
        loadCounts();
    });
</script>

<!-- 工具模板 -->
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="detail">
        <i class="layui-icon layui-icon-read"></i> 查看
    </a>
</script>
</body>
</html>
