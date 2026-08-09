<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="activeTab" value="${empty tab ? 'login' : tab}" />
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${activeTab == 'register' ? 'Đăng ký' : 'Đăng nhập'} - BookChill</title>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
:root{--text:#1a1a1a;--text-muted:#6b6b6b;--border:#e8e6e1;--border-soft:#f0ede8;--bg-soft:#faf9f7;--accent:#b08968;--accent-2:#ddb892;--sale:#e63946;--emerald:#2d6a4f;--shadow-lg:0 10px 30px rgba(0,0,0,.10);--radius:8px;--radius-lg:16px}
body{font-family:'Segoe UI',Tahoma,Arial,sans-serif;background:linear-gradient(135deg,#f4f1ec 0%,#e8dfd0 50%,#ddb892 100%);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px;line-height:1.6;color:var(--text)}
a{color:inherit;text-decoration:none;transition:color .2s}
button{font-family:inherit;cursor:pointer;border:none;background:none}
input{font-family:inherit}

.bc-auth-wrapper{width:100%;max-width:480px;margin:0 auto}
.bc-auth-main{background:#fff;border-radius:var(--radius-lg);box-shadow:var(--shadow-lg);padding:42px 40px}
.bc-auth-tabs{display:flex;gap:0;background:var(--bg-soft);border-radius:var(--radius);padding:4px;margin-bottom:24px}
.bc-auth-tab{flex:1;padding:11px;text-align:center;font-weight:700;font-size:13px;color:var(--text-muted);border-radius:6px;transition:all .2s;text-transform:uppercase;letter-spacing:1px}
.bc-auth-tab.active{background:#fff;color:var(--text);box-shadow:0 2px 6px rgba(0,0,0,.05)}
.bc-auth-tab:hover:not(.active){color:var(--text)}
.bc-auth-main h3{font-size:20px;margin-bottom:6px;font-weight:800}
.bc-auth-main-sub{color:var(--text-muted);font-size:13px;margin-bottom:18px}

.bc-auth-alert{background:#fee;color:var(--sale);padding:11px 14px;border-radius:var(--radius);margin-bottom:16px;font-size:13px;border:1px solid #fcc;text-align:center}
.bc-auth-success{background:#e6f4ec;color:var(--emerald);padding:11px 14px;border-radius:var(--radius);margin-bottom:16px;font-size:13px;border:1px solid #b8e0c8;text-align:center}

.bc-input-group{margin-bottom:12px}
.bc-input-group label{display:block;font-size:11px;font-weight:700;margin-bottom:6px;text-transform:uppercase;letter-spacing:1px;color:var(--text)}
.bc-input-noicon input{width:100%;padding:11px 16px;border:1px solid var(--border);border-radius:var(--radius);font-size:14px;background:#fff;transition:border-color .2s}
.bc-input-noicon input:focus{outline:none;border-color:var(--accent)}
.bc-form-row{display:grid;grid-template-columns:1fr 1fr;gap:12px}

.bc-auth-btn{width:100%;background:var(--text);color:#fff;padding:13px;border-radius:var(--radius);font-weight:700;font-size:13px;cursor:pointer;font-family:inherit;margin-top:8px;text-transform:uppercase;letter-spacing:1.5px;transition:all .2s}
.bc-auth-btn:hover{background:var(--accent);transform:translateY(-1px);box-shadow:0 6px 16px rgba(176,137,104,.3)}
.bc-auth-btn-accent{background:var(--accent)}
.bc-auth-btn-accent:hover{background:#8e6f54}

.bc-divider{text-align:center;margin:18px 0 14px;position:relative;color:var(--text-muted);font-size:11px;text-transform:uppercase;letter-spacing:2px;font-weight:700}
.bc-divider::before{content:"";position:absolute;left:0;right:0;top:50%;height:1px;background:var(--border)}
.bc-divider span{background:#fff;padding:0 14px;position:relative}

.bc-demo-form{display:grid;gap:7px}
.bc-demo-btn{width:100%;padding:10px 12px;border:1px solid var(--border);background:#fff;border-radius:var(--radius);cursor:pointer;font-family:inherit;font-size:12px;display:inline-flex;gap:8px;align-items:center;justify-content:space-between;transition:all .2s;font-weight:600;color:var(--text)}
.bc-demo-btn:hover{border-color:var(--text);background:var(--bg-soft);transform:translateY(-1px)}
.bc-demo-btn .bc-email{font-size:11px;color:var(--text-muted);font-weight:400}
.bc-demo-btn .bc-tag{background:#fff8ed;color:var(--accent);padding:2px 8px;border-radius:4px;font-size:10px;font-weight:700;letter-spacing:1px}
.bc-demo-admin{border-color:rgba(176,137,104,.4)}
.bc-demo-admin:hover{background:var(--accent)!important;color:#fff!important;border-color:var(--accent)}
.bc-demo-admin:hover .bc-email{color:rgba(255,255,255,.8)}
.bc-demo-admin:hover .bc-tag{background:rgba(255,255,255,.2);color:#fff}

.bc-back-home{text-align:center;margin-top:14px;font-size:12px}
.bc-back-home a{color:var(--text-muted)}
.bc-back-home a:hover{color:var(--accent)}

@media(max-width:480px){
	.bc-auth-main{padding:32px 24px}
	.bc-form-row{grid-template-columns:1fr}
}
</style>
</head>
<body>
<div class="bc-auth-wrapper">
	<main class="bc-auth-main">
		<div class="bc-auth-tabs">
			<a href="${ctx}/login" class="bc-auth-tab ${activeTab == 'login' ? 'active' : ''}">Đăng nhập</a>
			<a href="${ctx}/register" class="bc-auth-tab ${activeTab == 'register' ? 'active' : ''}">Đăng ký</a>
		</div>

		<c:if test="${activeTab == 'login'}">
			<h3>Chào mừng trở lại!</h3>
			<p class="bc-auth-main-sub">Đăng nhập để tiếp tục hành trình đọc sách.</p>

			<c:if test="${not empty error}">
				<div class="bc-auth-alert">${error}</div>
			</c:if>

			<form action="${ctx}/login" method="post">
				<div class="bc-input-group">
					<label>Email</label>
					<div class="bc-input-noicon">
						<input type="email" name="email" placeholder="email@example.com" required value="${not empty param.email ? param.email : ''}">
					</div>
				</div>
				<div class="bc-input-group">
					<label>Mật khẩu</label>
					<div class="bc-input-noicon">
						<input type="password" name="password" placeholder="••••••" required>
					</div>
				</div>
				<button type="submit" class="bc-auth-btn">Đăng nhập ngay</button>
			</form>

			<div class="bc-divider"><span>Hoặc đăng nhập nhanh</span></div>

			<div class="bc-demo-form">
				<button type="button" class="bc-demo-btn bc-demo-admin" onclick="fillForm('buivanduc1508@gmail.com','123654')">
					<span><span class="bc-email">buivanduc1508@gmail.com</span></span>
					<span class="bc-tag">ADMIN</span>
				</button>
				<button type="button" class="bc-demo-btn" onclick="fillForm('xuanatien@gmail.com','123456')">
					<span><span class="bc-email">xuanatien@gmail.com</span></span>
					<span class="bc-tag">USER</span>
				</button>
			</div>
		</c:if>

		<c:if test="${activeTab == 'register'}">
			<h3>Tạo tài khoản mới</h3>
			<p class="bc-auth-main-sub">Điền thông tin để trở thành thành viên BookChill.</p>

			<c:if test="${not empty error}">
				<div class="bc-auth-alert">${error}</div>
			</c:if>
			<c:if test="${not empty success}">
				<div class="bc-auth-success">${success}</div>
			</c:if>

			<form action="${ctx}/register" method="post">
				<div class="bc-form-row">
					<div class="bc-input-group">
						<label>Họ và tên</label>
						<div class="bc-input-noicon">
							<input type="text" name="fullName" placeholder="Nguyễn Văn A" required value="${not empty param.fullName ? param.fullName : ''}">
						</div>
					</div>
					<div class="bc-input-group">
						<label>Số điện thoại</label>
						<div class="bc-input-noicon">
							<input type="text" name="phone" placeholder="0901234567" value="${not empty param.phone ? param.phone : ''}">
						</div>
					</div>
				</div>
				<div class="bc-input-group">
					<label>Email</label>
					<div class="bc-input-noicon">
						<input type="email" name="email" placeholder="email@example.com" required value="${not empty param.email ? param.email : ''}">
					</div>
				</div>
				<div class="bc-input-group">
					<label>Mật khẩu</label>
					<div class="bc-input-noicon">
						<input type="password" name="password" placeholder="Ít nhất 6 ký tự" required>
					</div>
				</div>
				<div class="bc-input-group">
					<label>Địa chỉ</label>
					<div class="bc-input-noicon">
						<input type="text" name="address" placeholder="Số nhà, đường, quận/huyện..." value="${not empty param.address ? param.address : ''}">
					</div>
				</div>
				<button type="submit" class="bc-auth-btn bc-auth-btn-accent">Đăng ký tài khoản</button>
			</form>

			<div class="bc-divider"><span>Đã có tài khoản?</span></div>
			<a href="${ctx}/login" class="bc-auth-btn" style="display:block;text-align:center;text-decoration:none;background:transparent;color:var(--text);border:1px solid var(--border);">Đăng nhập ngay</a>
		</c:if>

		<div class="bc-back-home">
			<a href="${ctx}/home">Quay lại trang chủ</a>
		</div>
	</main>
</div>

<script>
function fillForm(email, password) {
	document.querySelector('input[name=email]').value = email;
	document.querySelector('input[name=password]').value = password;
}
</script>
</body>
</html>