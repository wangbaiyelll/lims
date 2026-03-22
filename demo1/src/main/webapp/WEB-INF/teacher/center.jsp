<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>教师中心</title>
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
    .profile-card {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      width: 300px;
    }
    .borrowed-list {
      margin-top: 20px;
    }
    .book-item {
      padding: 10px;
      border-bottom: 1px solid #eee;
      display: flex;
      justify-content: space-between;
    }
    .btn-group {
      display: flex;
      gap: 5px;
    }
    .status-tag {
      padding: 3px 8px;
      border-radius: 12px;
      font-size: 12px;
    }
    .status-normal { background: #5FB878; color: white; }
    .status-overdue { background: #FF5722; color: white; }
  </style>
</head>
<body>
<div class="layui-container">
  <div class="header">
    <h2>教师中心</h2>
    <a href="/logout">退出登录</a>
  </div>

  <div class="layui-row layui-col-space20">
    <div class="layui-col-md4">
      <div class="profile-card">
        <h3>个人信息</h3>
        <p><strong>姓名：</strong>${sessionScope.loginTeacher.name}</p>
        <p><strong>工号：</strong>${sessionScope.loginTeacher.empNo}</p>
        <p><strong>学院：</strong>${sessionScope.loginTeacher.college}</p>
        <p><strong>电话：</strong>${sessionScope.loginTeacher.phone}</p>
        <p><strong>邮箱：</strong>${sessionScope.loginTeacher.email}</p>
      </div>
    </div>

    <div class="layui-col-md8">
      <div class="borrowed-list">
        <h3>当前借阅</h3>
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
<!-- ... existing code ... -->
<script>
  $(document).ready(function() {
    // 修复：添加安全的变量获取和空值检查
    const teacherId = ${sessionScope.loginTeacher != null ? sessionScope.loginTeacher.id : 0};
    if(teacherId === 0) {
      $('#borrowList').html('<tr><td colspan="5" style="text-align:center;">请先登录</td></tr>');
      return;
    }
    loadBorrowRecords(teacherId);
  });

  function loadBorrowRecords(teacherId) {
    $.get('/borrow/my-borrows', {
      teacherId: teacherId,
      status: 1,
      page: 1,
      limit: 10
    }, function(res) {
      if(res.code === 0 && res.data && res.data.length > 0) {
        const tbody = $('#borrowList');
        tbody.empty();

        res.data.forEach(record => {
          const statusClass = record.status === 3 ? 'status-overdue' : 'status-normal';
          const statusText = record.status === 3 ? '逾期' : '正常';

          tbody.append(\`
                    <tr>
                        <td>
                            <strong>\${record.bookTitle}</strong><br>
                            \${record.author}
                        </td>
                        <td>\${formatDate(record.borrowDate)}</td>
                        <td>\${formatDate(record.dueDate)}</td>
                        <td><span class="status-tag \${statusClass}">\${statusText}</span></td>
                        <td>
                            <button class="layui-btn layui-btn-xs" onclick="renewBook(\${record.id})">申请续借</button>
                        </td>
                    </tr>
                \`);
            });
        } else {
          $('#borrowList').html('<tr><td colspan="5" style="text-align:center;">暂无借阅记录</td></tr>');
        }
    }).fail(function() {
      $('#borrowList').html('<tr><td colspan="5" style="text-align:center; color:red;">数据加载失败</td></tr>');
    });
  }

  function renewBook(borrowId) {
    layer.confirm('确定要申请续借吗？', {
        icon: 3,
        title: '提示'
    }, function(index){
        $.post('/borrow/applyRenew/' + borrowId, function(res) {
            if(res.code === 0) {
                layer.msg('续借申请已提交，请等待审核', {icon: 1});
                location.reload(); // 刷新页面
            } else {
                layer.msg(res.msg || '申请失败', {icon: 2});
            }
        }).fail(function() {
            layer.msg('网络错误', {icon: 2});
        });
        layer.close(index);
    });
  }

  function formatDate(dateString) {
    if(!dateString) return '';
    const date = new Date(dateString);
    return date.getFullYear() + '-' +
           String(date.getMonth() + 1).padStart(2, '0') + '-' +
           String(date.getDate()).padStart(2, '0');
  }
</script>
<!-- ... existing code ... -->





</body>
</html>
