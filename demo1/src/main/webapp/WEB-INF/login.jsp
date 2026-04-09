<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书馆管理系统 - 登录</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -100px;
            right: -100px;
            animation: float 6s ease-in-out infinite;
        }

        body::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            bottom: -80px;
            left: -80px;
            animation: float 8s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .login-container {
            width: 420px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            padding: 50px 40px;
            position: relative;
            z-index: 10;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .login-icon {
            font-size: 64px;
            margin-bottom: 15px;
            display: block;
            animation: bounce 1s ease infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .login-title {
            font-size: 28px;
            font-weight: 700;
            color: #2d3436;
            margin-bottom: 8px;
        }

        .login-subtitle {
            font-size: 14px;
            color: #999;
        }

        .login-type {
            display: flex;
            background: #f8f9fa;
            border-radius: 12px;
            padding: 6px;
            margin-bottom: 30px;
            position: relative;
        }

        .login-type button {
            flex: 1;
            padding: 12px;
            border: none;
            background: transparent;
            cursor: pointer;
            font-size: 15px;
            font-weight: 500;
            color: #636e72;
            border-radius: 8px;
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
        }

        .login-type button.active {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .input-group {
            margin-bottom: 25px;
            position: relative;
        }

        .input-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #b2bec3;
            transition: all 0.3s ease;
        }

        .input-group input {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            outline: none;
            background: #fafafa;
        }

        .input-group input:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .input-group input:focus + .input-icon {
            color: #667eea;
        }

        .login-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            position: relative;
            overflow: hidden;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(102, 126, 234, 0.4);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        .login-btn::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .login-btn:hover::after {
            width: 300px;
            height: 300px;
        }

        .tips {
            margin-top: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 12px;
            font-size: 13px;
            color: #636e72;
            line-height: 1.8;
        }

        .tips-title {
            font-weight: 600;
            color: #2d3436;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .account-info {
            display: flex;
            justify-content: space-between;
            gap: 15px;
        }

        .account-item {
            flex: 1;
            padding: 10px;
            background: white;
            border-radius: 8px;
            text-align: center;
        }

        .account-label {
            font-weight: 600;
            color: #667eea;
            margin-bottom: 5px;
        }

        .account-text {
            font-family: 'Courier New', monospace;
            color: #2d3436;
            font-size: 12px;
        }

        .loading {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.8s linear infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <span class="login-icon">📚</span>
            <h1 class="login-title">图书馆管理系统</h1>
            <p class="login-subtitle">欢迎回来，请登录您的账户</p>
        </div>

        <div class="login-type">
            <button id="adminBtn" class="active">👨‍💼 管理员</button>
            <button id="teacherBtn">👨‍🏫 教师</button>
        </div>

        <form id="loginForm">
            <input type="hidden" name="userType" id="userType" value="admin">

            <div class="input-group">
                <label>用户名</label>
                <div class="input-wrapper">
                    <input type="text" name="username" id="username" placeholder="请输入用户名" autocomplete="username" value="admin">
                    <span class="input-icon">👤</span>
                </div>
            </div>

            <div class="input-group">
                <label>密码</label>
                <div class="input-wrapper">
                    <input type="password" name="password" id="password" placeholder="请输入密码" autocomplete="current-password" value="admin123">
                    <span class="input-icon">🔒</span>
                </div>
            </div>

            <button type="submit" class="login-btn" id="loginBtn">
                <span id="btnText">登 录</span>
            </button>
        </form>

        <div class="tips">
            <div class="tips-title">💡 测试账户</div>
            <div class="account-info">
                <div class="account-item">
                    <div class="account-label">管理员</div>
                    <div class="account-text">admin<br/>admin123</div>
                </div>
                <div class="account-item">
                    <div class="account-label">教师</div>
                    <div class="account-text">teacher01<br/>teacher123</div>
                </div>
            </div>
        </div>
    </div>

    <script>
    layui.use(['layer'], function(){
        var layer = layui.layer;

        // 切换登录类型
        document.getElementById('adminBtn').onclick = function() {
            this.classList.add('active');
            document.getElementById('teacherBtn').classList.remove('active');
            document.getElementById('userType').value = 'admin';
            document.getElementById('username').value = 'admin';
            document.getElementById('password').value = 'admin123';
        };

        document.getElementById('teacherBtn').onclick = function() {
            this.classList.add('active');
            document.getElementById('adminBtn').classList.remove('active');
            document.getElementById('userType').value = 'teacher';
            document.getElementById('username').value = 'teacher01';
            document.getElementById('password').value = 'teacher123';
        };

        // 处理表单提交
        document.getElementById('loginForm').onsubmit = function(e) {
            e.preventDefault();

            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            const userType = document.getElementById('userType').value;

            if (!username || !password) {
                layer.msg('❌ 请输入用户名和密码', {icon: 2});
                return;
            }

            const loginBtn = document.getElementById('loginBtn');
            const btnText = document.getElementById('btnText');

            // 显示加载状态
            loginBtn.disabled = true;
            btnText.innerHTML = '<span class="loading"></span>登录中...';

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
                if(res.code === 0 && res.redirect) {
                    layer.msg('✅ 登录成功，正在跳转...', {icon: 1, time: 1000});
                    setTimeout(() => {
                        window.location.href = res.redirect;
                    }, 1000);
                } else {
                    layer.msg(res.msg || '❌ 用户名或密码错误', {icon: 2});
                    loginBtn.disabled = false;
                    btnText.textContent = '登 录';
                }
            })
            .catch(err => {
                console.error('登录错误:', err);
                layer.msg('❌ 网络错误，请重试', {icon: 2});
                loginBtn.disabled = false;
                btnText.textContent = '登 录';
            });
        };

        // 输入框获得焦点时的动画效果
        const inputs = document.querySelectorAll('.input-group input');
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.parentElement.classList.add('focused');
            });
            input.addEventListener('blur', function() {
                this.parentElement.parentElement.classList.remove('focused');
            });
        });
    });
    </script>
</body>
</html>
