<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng nhập - BookChill</title>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
:root{--text:#1a1a1a;--text-muted:#6b6b6b;--border:#e8e6e1;--accent:#b08968;--accent-2:#ddb892;--sale:#e63946;--emerald:#2d6a4f;--shadow-lg:0 10px 30px rgba(0,0,0,.10);--radius:8px;--radius-lg:16px}
body{font-family:'Segoe UI',Tahoma,Arial,sans-serif;background:linear-gradient(135deg,#f4f1ec 0%,#e8dfd0 50%,#ddb892 100%);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px;line-height:1.6;color:var(--text)}
a{color:inherit;text-decoration:none;transition:color .2s}
button{font-family:inherit;cursor:pointer;border:none;background:none}
input{font-family:inherit}

.bc-auth-wrapper{width:100%;max-width:480px}
.bc-auth-card{background:#fff;border-radius:var(--radius-lg);padding:42px 40px;box-shadow:var(--shadow-lg);border:1px solid #e8e6e1}
.bc-auth-logo{display:flex;align-items:center;gap:10px;font-size:24px;font-weight:800;color:var(--text);justify-content:center;margin-bottom:24px;letter-spacing:1px;text-transform:uppercase}
.bc-auth-logo .bc-mark{width:42px;height:42px;background:linear-gradient(135deg,var(--accent),var(--accent-2));border-radius:8px;display:inline-flex;align-items:center;justify-content:center;color:#fff;font-size:22px}
.bc-auth-card h2{text-align:center;font-size:24px;margin-bottom:6px;font-weight:800;color:var(--text)}
.bc-auth-sub{text-align:center;color:var(--text-muted);font-size:14px;margin-bottom:24px}
.bc-auth-alert{background:#fee;color:var(--sale);padding:12px 14px;border-radius:var(--radius);margin-bottom:18px;font-size:13px;border:1px solid #fcc;text-align:center}
.bc-input-group{margin-bottom:14px}
.bc-input-group label{display:block;font-size:12px;font-weight:700;margin-bottom:8px;text-transform:uppercase;letter-spacing:1px;color:var(--text)}
.bc-input-icon{position:relative}
.bc-input-icon .bc-icon{position:absolute;left:14px;top:50%;transform:translateY(-50%);color:var(--text-muted);font-size:16px}
.bc-input-icon input{width:100%;padding:13px 16px 13px 42px;border:1px solid var(--border);border-radius:var(--radius);font-size:14px;background:#fff;transition:border-color .2s}
.bc-input-icon input:focus{outline:none;border-color:var(--accent)}
.bc-auth-btn{width:100%;background:var(--text);color:#fff;padding:14px;border-radius:var(--radius);font-weight:700;font-size:13px;cursor:pointer;font-family:inherit;margin-top:6px;text-transform:uppercase;letter-spacing:1.5px;transition:all .2s}
.bc-auth-btn:hover{background:var(--accent);transform:translateY(-1px)}
.bc-auth-foot{text-align:center;margin-top:18px;font-size:13px;color:var(--text-muted)}
.bc-auth-foot a{color:var(--text);font-weight:700}
.bc-auth-foot a:hover{color:var(--accent)}

.bc-demo-block{margin-top:24px;padding:18px;background:#faf9f7;border:1px dashed var(--border);border-radius:var(--radius)}
.bc-demo-block-title{font-size:11px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:1.5px;text-align:center;margin-bottom:12px}
.bc-demo-form{display:grid;gap:8px}
.bc-demo-btn{width:100%;padding:12px;border:1px solid var(--border);background:#fff;border-radius:var(--radius);cursor:pointer;font-family:inherit;font-size:12px;display:inline-flex;gap:8px;align-items:center;justify-content:space-between;transition:all .2s;text-transform:uppercase;letter-spacing:1px;font-weight:700;color:var(--text)}
.bc-demo-btn:hover{border-color:var(--text);background:#fff;transform:translateY(-1px);box-shadow:0 4px 12px rgba(0,0,0,.05)}
.bc-demo-btn .bc-role{color:var(--accent);font-size:11px;font-weight:700}
.bc-demo-btn .bc-tag{background:#fff8ed;color:var(--accent);padding:3px 8px;border-radius:4px;font-size:10px;letter-spacing:1px}
.bc-demo-admin{border-color:rgba(176,137,104,.4)}
.bc-demo-admin:hover{background:var(--accent)!important;color:#fff!important;border-color:var(--accent)}
.bc-demo-admin:hover .bc-role{color:#fff}
.bc-demo-admin:hover .bc-tag{background:rgba(255,255,255,.2);color:#fff}
.bc-demo-back{text-align:center;margin-top:14px;font-size:12px}
.bc-demo-back a{color:var(--text-muted)}
.bc-demo-back a:hover{color:var(--accent)}

@media(max-width:560px){.bc-auth-card{padding:32px 24px}}
</style>
</head>
<body>
<div class="bc-auth-wrapper">
	<div class="bc-auth-card">
		<a href="${ctx}/home" class="bc-auth-logo">
			<span class="bc-mark">📚</span>
			<span>BookChill</span>
		</a>
		<h2>Chào mừng trở lại</h2>
		<p class="bc-auth-sub">Đăng nhập để tiếp tục mua sắm</p>

		<c:if test="${not empty error}">
			<div class="bc-auth-alert">⚠️ ${error}</div>
		</c:if>

		<form action="${ctx}/login" method="post">
			<div class="bc-input-group">
				<label>Email</label>
				<div class="bc-input-icon">
					<span class="bc-icon">✉️</span>
					<input type="email" name="email" placeholder="Nhập email của bạn" required value="${not empty param.email ? param.email : ''}">
				</div>
			</div>
			<div class="bc-input-group">
				<label>Mật khẩu</label>
				<div class="bc-input-icon">
					<span class="bc-icon">🔒</span>
					<input type="password" name="password" placeholder="Nhập mật khẩu" required>
				</div>
			</div>
			<button type="submit" class="bc-auth-btn">🔑 Đăng nhập</button>
		</form>

		<div class="bc-auth-foot">
			Chưa có tài khoản? <a href="${ctx}/register">Đăng ký ngay</a>
		</div>

		<div class="bc-demo-block">
			<div class="bc-demo-block-title">📌 Tài khoản demo - click để đăng nhập nhanh</div>
			<div class="bc-demo-form">
				<button type="button" class="bc-demo-btn bc-demo-admin" onclick="fillForm('buivanduc1508@gmail.com','123654')">
					<span>👤 buivanduc1508@gmail.com</span>
					<span class="bc-tag">Admin</span>
				</button>
				<button type="button" class="bc-demo-btn" onclick="fillForm('xuanatien@gmail.com','123456')">
					<span>👥 xuanatien@gmail.com</span>
					<span class="bc-tag">User</span>
				</button>
			</div>
			<div class="bc-demo-back">
				← <a href="${ctx}/home">Quay lại trang chủ</a>
			</div>
		</div>
	</div>
</div>

<script>
function fillForm(email, password) {
	document.querySelector('input[name=email]').value = email;
	document.querySelector('input[name=password]').value = password;
}
</script>
</body>
</html>
