<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的罚款</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <style>
        body {
            background-color: #f5f6fa;
            padding: 20px;
            font-size: 15px;
        }

        .layui-card {
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .layui-card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            font-size: 18px;
            height: 55px;
            line-height: 55px;
        }

        /* 搜索区域 - 调小 */
        .layui-form-select dl dd {
            font-size: 12px !important;
            padding: 7px 12px;
        }

        #status {
            font-size: 12px !important;
            height: 30px !important;
        }

        #searchBtn {
            font-size: 10px !important;
            padding: 0 10px !important;
            height: 30px !important;
            line-height: 28px !important;
        }

        /* 表格内容 - 调大 */
        .layui-table {
            font-size: 16px !important;
        }

        .layui-table td, .layui-table th {
            padding: 14px 12px;
            font-size: 16px !important;
        }

        .amount-cell {
            color: #ff6b6b;
            font-weight: bold;
            font-size: 17px !important;
        }

        .overdue-tag {
            background: #ffebee;
            color: #c62828;
            padding: 7px 13px;
            border-radius: 6px;
            font-size: 15px !important;
            font-weight: 600;
        }

        .status-badge {
            padding: 6px 13px;
            border-radius: 12px;
            font-size: 14px !important;
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="layui-container" style="margin-top: 20px; max-width: 1400px;">
    <div class="layui-card">
        <div class="layui-card-header">
            <span>💰 我的罚款</span>
            <div class="layui-form" style="float: right;">
                <div class="layui-input-inline" style="min-width: 140px; margin-right: 10px;">
                    <select name="status" id="status" lay-filter="statusSelect">
                        <option value="">全部状态</option>
                        <option value="0">💳 未支付</option>
                        <option value="1">✅ 已支付</option>
                    </select>
                </div>
                <button class="layui-btn layui-btn-normal layui-btn-sm" id="searchBtn">🔍 搜索</button>
            </div>
        </div>
        <div class="layui-card-body">
            <table class="layui-table" id="fineTable" lay-filter="fineTable"></table>
        </div>
    </div>
</div>

<script type="text/html" id="statusTpl">
    {{# if(d.status == 0){ }}
    <span class="status-badge" style="color: #ff6b6b; background: #ffebee;">💳 未支付</span>
    {{# } else { }}
    <span class="status-badge" style="color: #2e7d32; background: #e8f5e9;">✅ 已支付</span>
    {{# } }}
</script>

<script type="text/html" id="actionBar">
    {{# if(d.status == 0){ }}
        <button class="layui-btn layui-btn-xs layui-btn-normal" lay-event="pay">
            💳 立即支付
        </button>
    {{# } else if(d.status == 2){ }}
        <span style="color: #ff9800; font-size: 12px;" title="请先归还图书">⏳ 请先还书</span>
    {{# } else if(d.status == 1){ }}
        <span style="color: #999; font-size: 12px;">已完成</span>
    {{# } else { }}
        <span style="color: #999; font-size: 12px;">-</span>
    {{# } }}
</script>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script>
    layui.use(['table', 'layer'], function(){
        var table = layui.table;
        var layer = layui.layer;
        var $ = layui.$;

        // 初始化表格
        var tableIns = table.render({
            elem: '#fineTable',
            url: '/fine/my',
            method: 'get',
            page: true,
            limit: 10,
            height: 'full-280',
            skin: 'line',
            even: true,
            cols: [[
                {field: 'id', title: 'ID', width: 80, sort: true},
                {field: 'bookTitle', title: '📖 图书名称', width: 280},
                {field: 'amount', title: '💰 罚款金额 (元)', width: 160, sort: true, templet: function(d){
                    let amountText = '¥' + parseFloat(d.amount).toFixed(2);
                    if (d.bookPrice) {
                        amountText += '<br><span style="font-size:12px;color:#999;">(书本价格：¥' + parseFloat(d.bookPrice).toFixed(2) + ')</span>';
                    }
                    return '<span class="amount-cell">' + amountText + '</span>';
                }},
                {field: 'fineDate', title: '📅 生成日期', width: 140, templet: function(d){
                    if(!d.fineDate) return '-';
                    return d.fineDate.substring(0, 10);
                }},
                {field: 'dueDays', title: '⏱️ 逾期天数', width: 120, templet: function(d){
                    if(!d.dueDays || d.dueDays === 0) return '<span style="color: #999;">-</span>';
                    return '<span class="overdue-tag">' + d.dueDays + '天</span>';
                }},
                {field: 'status', title: '📊 状态', width: 160, templet: function(d){
                    if (d.status === 0) {
                        return '<span class="status-badge" style="color: #ff6b6b; background: #ffebee;">💳 待支付</span>';
                    } else if (d.status === 1) {
                        return '<span class="status-badge" style="color: #2e7d32; background: #e8f5e9;">✅ 已支付</span>';
                    } else if (d.status === 2) {
                        return '<span class="status-badge" style="color: #ff9800; background: #fff3e0;">⏳ 待归还</span>';
                    }
                    return '<span style="color: #999;">未知</span>';
                }},
                {field: 'payDate', title: '✅ 支付日期', width: 140, templet: function(d){
                    if(!d.payDate) return '<span style="color: #999;">-</span>';
                    return d.payDate.substring(0, 10);
                }},
                {title: '操作', toolbar: '#actionBar', width: 120}
            ]],
            done: function(res, curr, count){
                console.log('✅ 数据加载成功 - 当前页:', curr, '记录数:', res.data ? res.data.length : 0, '总数:', res.count || 0);
            }
        });

        // 搜索按钮点击事件
        $('#searchBtn').on('click', function(){
            var status = $('#status').val();
            var statusText = status === '0' ? '💳 未支付' : (status === '1' ? '✅ 已支付' : '全部状态');

            console.log('🔍 开始搜索 - 状态参数:', status);

            tableIns.reload({
                where: {
                    status: status !== '' ? status : null
                },
                page: {
                    curr: 1
                },
                done: function(res, curr, count){
                    console.log('✅ 搜索完成 - 找到', res.data ? res.data.length : 0, '条记录');

                    if(res.data && res.data.length > 0) {
                        layer.msg('✅ 已找到 ' + res.data.length + ' 条' + statusText + '的记录', {icon: 1, time: 1500});
                    } else {
                        layer.msg('😕 没有找到符合条件的记录', {icon: 2, time: 1500});
                    }
                }
            });
        });

        // 支持下拉框改变直接搜索
        $('#status').on('change', function(){
            $('#searchBtn').click();
        });

        table.on('tool(fineTable)', function(obj){
            var data = obj.data;
            if(obj.event === 'pay'){
                layer.confirm('确定要支付这笔罚款吗？<br><br>' +
                    '📖 图书：《' + data.bookTitle + '》<br>' +
                    '💰 金额：¥' + parseFloat(data.amount).toFixed(2) + '<br>' +
                    '⏱️ 逾期：' + data.dueDays + '天', {
                    icon: 3,
                    title: '💳 罚款支付确认',
                    btn: ['确定支付', '取消']
                }, function(index){
                    $.ajax({
                        url: '/fine/pay/' + data.id,
                        type: 'POST',
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('✅ 支付成功', {icon: 1, time: 2000});
                                setTimeout(function() {
                                    tableIns.reload();
                                }, 1500);
                            } else {
                                layer.msg(res.msg || '❌ 支付失败', {icon: 2});
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
    });
</script>
</body>
</html>
