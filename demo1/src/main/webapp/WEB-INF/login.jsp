<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书信息管理系统登录</title>
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .login-container {
            width: 400px;
            padding: 40px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }
        .login-title {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 30px;
        }
        .login-type {
            margin-bottom: 20px;
            text-align: center;
        }
        .login-type button {
            width: 120px;
            margin: 0 10px;
            padding: 8px 0;
            cursor: pointer;
            border: 1px solid #ddd;
            background: #f5f5f5;
            border-radius: 4px;
        }
        .login-type button.active {
            background: #5FB878;
            color: white;
            border-color: #5FB878;
        }
        .input-group {
            margin-bottom: 15px;
        }
        .input-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .login-btn {
            width: 100%;
            padding: 10px;
            background: #5FB878;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .login-btn:hover { background: #4cae4c; }
        .tips { margin-top: 20px; text-align: center; color: #999; font-size: 12px; }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-title">图书信息管理系统</div>

    <div class="login-type">
        <button id="adminBtn" class="active">管理员登录</button>
        <button id="teacherBtn">教师登录</button>
    </div>

    <form id="loginForm">
        <input type="hidden" name="userType" id="userType" value="admin">
        <div class="input-group">
            <input type="text" name="username" id="username" placeholder="用户名" autocomplete="username">
        </div>
        <div class="input-group">
            <input type="password" name="password" id="password" placeholder="密码" autocomplete="current-password">
        </div>
        <button type="submit" class="login-btn">登 录</button>
    </form>

    <div class="tips">
        管理员: admin / admin123<br>
        教师: teacher01 / teacher123
    </div>
</div>

<script>
// 切换登录类型
document.getElementById('adminBtn').onclick = function() {
    this.className = 'active';
    document.getElementById('teacherBtn').className = '';
    document.getElementById('userType').value = 'admin';
    document.getElementById('username').value = 'admin';
    document.getElementById('password').value = 'admin123';
};

document.getElementById('teacherBtn').onclick = function() {
    this.className = 'active';
    document.getElementById('adminBtn').className = '';
    document.getElementById('userType').value = 'teacher';
    document.getElementById('username').value = 'teacher01';
    document.getElementById('password').value = 'teacher123';
};

// 处理表单提交
document.getElementById('loginForm').onsubmit = function(e) {
    e.preventDefault();

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const userType = document.getElementById('userType').value;

    if (!username || !password) {
        alert('请输入用户名和密码');
        return;
    }

    // 使用FormData对象而不是手动编码
    const formData = new FormData();
    formData.append('username', username);
    formData.append('password', password);
    formData.append('userType', userType);

    fetch('/doLogin', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(res => {
        if(res.code === 0) {
            window.location.href = res.redirect;
        } else {
            alert(res.msg || '登录失败');
        }
    })
    .catch(() => alert('网络错误，请重试'));
};
</script>
</body>
</html>
