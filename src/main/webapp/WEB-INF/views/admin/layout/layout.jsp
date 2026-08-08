<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty pageTitle ? 'BookChill Admin' : pageTitle}"/> | BookChill Admin</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<link rel="stylesheet" href="${ctx}/assets/vendors/perfect-scrollbar/perfect-scrollbar.css">
<link rel="stylesheet" href="${ctx}/assets/css/bootstrap.css">
<link rel="stylesheet" href="${ctx}/assets/vendors/bootstrap-icons/bootstrap-icons.css">

<style>
/* Override App admin palette -> BookChill brown */
body { font-family: 'Inter', 'Be Vietnam Pro', 'Segoe UI', sans-serif; background: #f5f3ef; margin: 0; }
#app { display: flex; min-height: 100vh; }
#sidebar {
	background: linear-gradient(180deg, #3d2817 0%, #5a3a1f 100%) !important;
	width: 260px !important;
	min-width: 260px !important;
	max-width: 260px !important;
	min-height: 100vh;
	position: fixed !important;
	left: 0 !important;
	top: 0 !important;
	bottom: 0;
	overflow-y: auto;
	z-index: 1000;
	display: block !important;
	transform: none !important;
}
.sidebar-wrapper { display: block !important; }
.sidebar-wrapper.active { display: block !important; }
.sidebar-menu { display: block !important; }
.sidebar-menu .menu { display: block !important; }
#main {
	background: #f5f3ef;
	flex: 1;
	margin-left: 260px !important;
	min-height: 100vh;
	display: flex;
	flex-direction: column;
	width: calc(100% - 260px);
}

/* Body toan admin su dung Inter */
body, input, select, textarea, button {
	font-family: 'Inter', 'Be Vietnam Pro', 'Segoe UI', sans-serif;
}

#sidebar .sidebar-menu .menu li a.sidebar-link,
#sidebar .sidebar-menu .menu li a.sidebar-link span,
#sidebar .sidebar-header .logo a {
	font-family: 'Inter', 'Segoe UI', sans-serif !important;
}
#sidebar .sidebar-header { background: rgba(0,0,0,.2); padding: 18px 20px; }
#sidebar .sidebar-header .logo a { color: #fff; font-weight: 800; font-size: 22px; text-decoration: none; display:flex; align-items:center; gap:8px; }
#sidebar .sidebar-menu .menu li.sidebar-title { color: #d4a373; padding: 16px 20px 8px; font-size: 11px; letter-spacing: 1.5px; text-transform: uppercase; margin-top: 6px; }
#sidebar .sidebar-menu .menu li.sidebar-item { margin: 2px 0; }
#sidebar .sidebar-menu .menu li a.sidebar-link { color: #f0e6d6; padding: 12px 20px; display: flex; align-items: center; gap: 12px; border-radius: 8px; margin: 0 12px; transition: all 0.2s; }
#sidebar .sidebar-menu .menu li a.sidebar-link:hover { background: rgba(176, 137, 104, 0.25); color: #fff; transform: translateX(3px); }
#sidebar .sidebar-menu .menu li.active > a.sidebar-link { background: linear-gradient(135deg, #b08968 0%, #d4a373 100%); color: #fff; box-shadow: 0 4px 12px rgba(176, 137, 104, 0.3); }
#sidebar .sidebar-menu .menu li a.sidebar-link i { color: #d4a373; font-size: 18px; width: 20px; text-align: center; }
#sidebar .sidebar-menu .menu li.active > a.sidebar-link i { color: #fff; }
#sidebar .sidebar-menu .menu li a.sidebar-link span { font-size: 14px; font-weight: 500; }

#main { background: #f5f3ef; }
#main .page-heading { padding: 24px 28px 0; }
#main .page-heading h3 { font-weight: 700; color: #3d2817; }
#main .page-heading .breadcrumb { background: transparent; padding: 0; }

.adm-stat-card { background: #fff; border-radius: 12px; padding: 22px; box-shadow: 0 2px 8px rgba(0,0,0,.04); border-left: 4px solid #b08968; }
.adm-stat-card .adm-stat-label { color: #6c757d; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px; }
.adm-stat-card .adm-stat-value { font-size: 28px; font-weight: 800; color: #3d2817; }
.adm-stat-card.adm-stat-success { border-left-color: #2d6a4f; }
.adm-stat-card.adm-stat-warning { border-left-color: #ffba08; }
.adm-stat-card.adm-stat-danger { border-left-color: #e63946; }
.adm-stat-card.adm-stat-info { border-left-color: #457b9d; }

.adm-table-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,.04); overflow: hidden; }
.adm-table-card .adm-card-header { padding: 16px 22px; border-bottom: 1px solid #f0e6d6; display: flex; justify-content: space-between; align-items: center; }
.adm-table-card .adm-card-header h4 { margin: 0; color: #3d2817; font-weight: 700; }
.adm-table { width: 100%; border-collapse: collapse; }
.adm-table th { background: #f5f3ef; color: #3d2817; font-weight: 700; padding: 12px 16px; text-align: left; font-size: 13px; text-transform: uppercase; letter-spacing: .5px; }
.adm-table td { padding: 12px 16px; border-bottom: 1px solid #f0e6d6; color: #2b2b2b; }
.adm-table tr:hover td { background: #fdf8f0; }
.adm-table .adm-img { width: 56px; height: 70px; object-fit: cover; border-radius: 6px; border: 1px solid #f0e6d6; }

.adm-badge { display: inline-block; padding: 3px 10px; border-radius: 999px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; }
.adm-badge-success { background: #d4edda; color: #155724; }
.adm-badge-warning { background: #fff3cd; color: #856404; }
.adm-badge-info { background: #cce5ff; color: #004085; }
.adm-badge-danger { background: #f8d7da; color: #721c24; }
.adm-badge-secondary { background: #e2e3e5; color: #383d41; }

.adm-btn { padding: 8px 14px; border-radius: 8px; border: none; cursor: pointer; font-size: 13px; font-weight: 600; transition: all .15s; text-decoration: none; display: inline-block; }
.adm-btn-primary { background: #b08968; color: #fff; }
.adm-btn-primary:hover { background: #8a6a4f; color: #fff; }
.adm-btn-danger { background: #e63946; color: #fff; }
.adm-btn-danger:hover { background: #b32431; }
.adm-btn-success { background: #2d6a4f; color: #fff; }
.adm-btn-success:hover { background: #1d4d36; }
.adm-btn-light { background: #f5f3ef; color: #3d2817; border: 1px solid #d4a373; }
.adm-btn-light:hover { background: #d4a373; color: #fff; }

.adm-search-form { display: flex; gap: 8px; }
.adm-search-form input { padding: 8px 12px; border: 1px solid #d4a373; border-radius: 8px; font-size: 14px; min-width: 260px; }

.adm-form-modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 9999; align-items: center; justify-content: center; }
.adm-form-modal.adm-show { display: flex; }
.adm-form-modal .adm-form-box { background: #fff; border-radius: 12px; width: 90%; max-width: 600px; max-height: 90vh; overflow: auto; padding: 24px; }
.adm-form-modal h3 { color: #3d2817; margin-bottom: 18px; font-weight: 700; }
.adm-form-modal .adm-fg { margin-bottom: 14px; }
.adm-form-modal .adm-fg label { display: block; font-size: 13px; font-weight: 700; margin-bottom: 6px; color: #3d2817; }
.adm-form-modal .adm-fg input, .adm-form-modal .adm-fg select, .adm-form-modal .adm-fg textarea { width: 100%; padding: 8px 12px; border: 1px solid #d4a373; border-radius: 8px; font-size: 14px; box-sizing: border-box; }
.adm-form-modal .adm-fg textarea { min-height: 80px; resize: vertical; }
.adm-form-modal .adm-form-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 18px; }

.adm-empty { text-align: center; padding: 60px 20px; color: #6c757d; }
.adm-empty h3 { color: #3d2817; margin: 12px 0 8px; }

.adm-topbar { background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,.04); padding: 12px 28px; display: flex; justify-content: space-between; align-items: center; }
.adm-topbar .adm-greeting { color: #3d2817; font-weight: 700; }
.adm-topbar .adm-actions { display: flex; gap: 12px; align-items: center; }

@media (max-width: 992px) {
	#sidebar { transform: translateX(-100%); transition: transform .25s; }
	#sidebar.active { transform: translateX(0); }
	#main { margin-left: 0; }
}
</style>
</head>

<body>
<div id="app">
	<!-- SIDEBAR -->
	<div id="sidebar" class="active">
		<div class="sidebar-wrapper active">
			<div class="sidebar-header">
				<div class="d-flex justify-content-between">
					<div class="logo">
						<a href="${ctx}/admin">
							<span style="font-size:22px;">📚</span>
							<span>BookChill</span>
						</a>
					</div>
					<div class="toggler">
						<a href="#" class="sidebar-hide d-xl-none d-block"><i class="bi bi-x"></i></a>
					</div>
				</div>
			</div>
			<div class="sidebar-menu">
				<ul class="menu">
					<li class="sidebar-title">Quản trị</li>
					<li class="sidebar-item ${activeAdminPage == 'dashboard' ? 'active' : ''}">
						<a href="${ctx}/admin" class='sidebar-link'>
							<i class="bi bi-grid-fill"></i><span>Tổng quan</span>
						</a>
					</li>
					<li class="sidebar-item ${activeAdminPage == 'sanpham' ? 'active' : ''}">
						<a href="${ctx}/admin?page=sanpham" class='sidebar-link'>
							<i class="bi bi-book-half"></i><span>Sản phẩm</span>
						</a>
					</li>
					<li class="sidebar-item ${activeAdminPage == 'danhmuc' ? 'active' : ''}">
						<a href="${ctx}/admin?page=danhmuc" class='sidebar-link'>
							<i class="bi bi-tags-fill"></i><span>Danh mục</span>
						</a>
					</li>
					<li class="sidebar-item ${activeAdminPage == 'donhang' ? 'active' : ''}">
						<a href="${ctx}/admin?page=donhang" class='sidebar-link'>
							<i class="bi bi-receipt-cutoff"></i><span>Đơn hàng</span>
						</a>
					</li>
					<li class="sidebar-item ${activeAdminPage == 'nguoidung' ? 'active' : ''}">
						<a href="${ctx}/admin?page=nguoidung" class='sidebar-link'>
							<i class="bi bi-people-fill"></i><span>Người dùng</span>
						</a>
					</li>

					<li class="sidebar-title">Khác</li>
					<li class="sidebar-item">
						<a href="${ctx}/home" class='sidebar-link'>
							<i class="bi bi-shop"></i><span>Xem shop</span>
						</a>
					</li>
					<li class="sidebar-item">
						<a href="${ctx}/logout" class='sidebar-link'>
							<i class="bi bi-box-arrow-right"></i><span>Đăng xuất</span>
						</a>
					</li>
				</ul>
			</div>
		</div>
	</div>

	<!-- MAIN CONTENT -->
	<div id="main">
		<div class="adm-topbar">
			<div class="adm-greeting"><i class="bi bi-hand-thumbs-up"></i> Xin chào, ${sessionScope.fullName} <span class="adm-badge adm-badge-warning">ADMIN</span></div>
			<div class="adm-actions">
				<a href="${ctx}/home" class="adm-btn adm-btn-light"><i class="bi bi-house"></i> Về trang chủ</a>
				<a href="${ctx}/logout" class="adm-btn adm-btn-danger"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
			</div>
		</div>

		<jsp:include page="${contentPage}" />

		<footer style="padding: 20px 28px; text-align: center; color: #6c757d; font-size: 13px;">
			© 2026 BookChill Admin • Made with 📚 for book lovers
		</footer>
	</div>
</div>

<script src="${ctx}/assets/vendors/perfect-scrollbar/perfect-scrollbar.min.js"></script>
<script src="${ctx}/assets/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/assets/js/main.js"></script>
</body>
</html>
