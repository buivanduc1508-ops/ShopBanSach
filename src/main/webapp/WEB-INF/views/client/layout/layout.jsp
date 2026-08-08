<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty pageTitle ? 'BookChill' : pageTitle}"/> | BookChill</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<link rel="stylesheet" href="${ctx}/client-assets/css/bookchill.css?v=11">
<link rel="icon" type="image/svg+xml" href="${ctx}/assets/placeholder-book.jsp?w=32&h=32&bg=b08968&text=BC">
</head>
<body>

<!-- TOPBAR -->
<div class="bc-topbar">
	<div class="bc-container bc-topbar-inner">
		<div>📦 Miễn phí vận chuyển cho đơn từ 300.000₫</div>
		<div class="bc-topbar-right">
			<c:choose>
				<c:when test="${not empty sessionScope.user}">
					<span class="bc-topbar-user">
						👋 Xin chào, <strong>${sessionScope.fullName}</strong>
						<c:if test="${sessionScope.role == 'ADMIN'}">
							<span class="bc-badge-admin">Admin</span>
						</c:if>
					</span>
					<a href="${ctx}/admin" class="bc-topbar-link">⚙️ Quản trị</a>
					<a href="${ctx}/logout" class="bc-topbar-link">🚪 Đăng xuất</a>
				</c:when>
				<c:otherwise>
					<a href="${ctx}/login" class="bc-topbar-link">🔐 Đăng nhập</a>
					<a href="${ctx}/register" class="bc-topbar-link">✨ Đăng ký</a>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

<!-- HEADER -->
<header class="bc-header">
	<div class="bc-container bc-header-inner">
		<a href="${ctx}/home" class="bc-logo">
			<span class="bc-logo-mark">📚</span>
			<span>BookChill</span>
		</a>
		<nav class="bc-nav">
			<a href="${ctx}/home" class="${activePage == 'home' ? 'active' : ''}">Trang chủ</a>
			<a href="${ctx}/shop" class="${activePage == 'shop' ? 'active' : ''}">Sản phẩm</a>
			<a href="${ctx}/cart" class="${activePage == 'cart' ? 'active' : ''}">Giỏ hàng</a>
			<a href="#bc-footer">Liên hệ</a>
		</nav>
		<div class="bc-header-actions">
			<a href="${ctx}/cart" class="bc-icon-btn bc-cart-icon" title="Giỏ hàng" id="bcCartIcon">
				🛒
				<span class="bc-cart-badge" id="bcCartBadge" style="display:none;">0</span>
			</a>
		</div>
	</div>
</header>

<!-- TOAST thông báo (đã ẩn - thông báo chỉ hiện ở badge giỏ hàng góc phải) -->
<div id="bcToast" class="bc-toast" style="display:none;">
	<div class="bc-toast-icon">✓</div>
	<div class="bc-toast-body">
		<strong id="bcToastTitle">Đã thêm vào giỏ</strong>
		<span id="bcToastMsg">Sản phẩm đã được thêm</span>
	</div>
	<a href="${ctx}/cart" class="bc-toast-link">Xem giỏ →</a>
</div>

<script>
// Đọc số lượng giỏ ban đầu: gọi nhanh endpoint /cart?count=1
(function() {
	fetch('${ctx}/cart?count=1', { credentials: 'same-origin' })
		.then(function(r) { return r.json(); })
		.then(function(d) { bcUpdateCartBadge(d.count || 0); })
		.catch(function() {});
})();

function bcAddToCart(btn, productId, quantity) {
	// KHONG chan click - user click bao nhieu lan cung cong don
	var qty = quantity || 1;

	// Lay context path tu bien JSP da set san
	var ctx = '<%= request.getContextPath() %>';
	var url = ctx + '/cart?action=add&productId=' + encodeURIComponent(productId) + '&quantity=' + qty + '&ajax=1';
	console.log('[bcAddToCart]', url);

	fetch(url, { method: 'GET' })
		.then(function(r) { return r.json(); })
		.then(function(data) {
			console.log('[bcAddToCart] response=', data);
			if (data && data.ok) {
				if (typeof bcUpdateCartBadge === 'function') bcUpdateCartBadge(data.count);
				var icon = document.getElementById('bcCartIcon');
				if (icon) {
					icon.classList.remove('bc-bounce');
					void icon.offsetWidth;
					icon.classList.add('bc-bounce');
				}
			}
		})
		.catch(function(e) {
			console.warn('[bcAddToCart] error:', e);
		});
}

function bcUpdateCartBadge(count) {
	var badge = document.getElementById('bcCartBadge');
	if (!badge) return;
	if (count > 0) {
		badge.innerText = count > 99 ? '99+' : count;
		badge.style.display = 'flex';
	} else {
		badge.style.display = 'none';
	}
}

function bcShowToast(name) {
	var t = document.getElementById('bcToast');
	document.getElementById('bcToastMsg').innerText = 'Đã thêm: ' + name;
	t.classList.add('bc-show');
	clearTimeout(window._bcToastTimer);
	window._bcToastTimer = setTimeout(function() {
		t.classList.remove('bc-show');
	}, 3000);
}
</script>

<!-- MAIN -->
<main>
	<jsp:include page="${contentPage}" />
</main>

<!-- FOOTER -->
<footer class="bc-footer" id="bc-footer">
	<div class="bc-container">
		<div class="bc-footer-grid">
			<div>
				<a href="${ctx}/home" class="bc-logo">
					<span class="bc-logo-mark">📚</span>
					<span>BookChill</span>
				</a>
				<p class="bc-footer-text">
					BookChill - Mua sách thật chill, đọc sách thật "chill". Hàng trăm đầu sách hay với giá tốt nhất, giao hàng toàn quốc.
				</p>
				<div class="bc-social">
					<a href="#" title="Facebook">f</a>
					<a href="#" title="Instagram">IG</a>
					<a href="#" title="YouTube">▶</a>
					<a href="#" title="TikTok">♪</a>
				</div>
			</div>
			<div>
				<h4>Liên kết</h4>
				<ul>
					<li><a href="${ctx}/home">→ Trang chủ</a></li>
					<li><a href="${ctx}/shop">→ Tất cả sách</a></li>
					<li><a href="${ctx}/cart">→ Giỏ hàng</a></li>
					<li><a href="${ctx}/login">→ Đăng nhập</a></li>
					<li><a href="${ctx}/register">→ Đăng ký</a></li>
				</ul>
			</div>
			<div>
				<h4>Danh mục</h4>
				<ul>
					<li><a href="${ctx}/shop?category=1">→ Sách giáo khoa</a></li>
					<li><a href="${ctx}/shop?category=2">→ Truyện tranh</a></li>
					<li><a href="${ctx}/shop?category=3">→ Văn học</a></li>
					<li><a href="${ctx}/shop?category=4">→ Kỹ năng</a></li>
				</ul>
			</div>
			<div>
				<h4>Liên hệ</h4>
				<ul class="bc-contact">
					<li><span class="bc-icon">📍</span> Hải Phòng, Việt Nam</li>
					<li><span class="bc-icon">📞</span> 0904 415 459</li>
					<li><span class="bc-icon">✉️</span> buivanduc1508@gmail.com</li>
				</ul>
			</div>
		</div>
		<div class="bc-footer-bottom">
			© 2026 BookChill. All rights reserved. | Made with 📚 for book lovers.
		</div>
	</div>
</footer>

</body>
</html>
