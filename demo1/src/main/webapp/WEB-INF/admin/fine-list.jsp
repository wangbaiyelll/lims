<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>罚款管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
</head>
<body>
<div class="layui-container" style="margin-top: 20px;">
    <div class="layui-card">
        <div class="layui-card-header">
            <div class="layui-form" style="float: right;">
                <div class="layui-input-inline">
                    <input type="text" name="teacherName" id="teacherName" placeholder="教师姓名" class="layui-input">
                </div>
                <div class="layui-input-inline">
                    <select name="status" id="status">
                        <option value="">全部状态</option>
                        <option value="0">未支付</option>
                        <option value="1">已支付</option>
                    </select>
                </div>
                <button class="layui-btn layui-btn-sm" id="searchBtn">搜索</button>
            </div>
        </div>
        <div class="layui-card-body">
            <table class="layui-table" id="fineTable" lay-filter="fineTable">\u5176\u4ed6</div>
    </div>
</div>

<script type="text/html" id="statusTpl">
    {{# if(d.status == 0){ }}
    <span style="color:red;">未支付</span>
    {{# } else { }}
    <span style="color:green;">已支付</span>
    {{# } }}
</script>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script>
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;

        table.render({
            elem: '#fineTable',
            url: '/fine/data',
            method: 'get',
            page: true,
            limit: 10,
            cols: [[
                {field: 'id', title: 'ID', width: 80},
                {field: 'teacherName', title: '教师姓名', width: 100},
                {field: 'bookTitle', title: '图书名称', width: 200},
                {field: 'amount', title: '罚款金额(元)', width: 100},
                {field: 'fineDate', title: '生成日期', width: 110},
                {field: 'dueDays', title: '逾期天数', width: 80},
                {field: 'status', title: '状态', width: 80, templet: '#statusTpl'},
                {field: 'payDate', title: '支付日期', width: 110}
            ]],
            where: {
                teacherName: $('#teacherName').val(),
                status: $('#status').val()
            }
        });

        $('#searchBtn').on('click', function(){
            table.reload('fineTable', {
                where: {
                    teacherName: $('#teacherName').val(),
                    status: $('#status').val()
                },
                page: {curr: 1}
            });
        });
    });
</script>
</body>
</html>
