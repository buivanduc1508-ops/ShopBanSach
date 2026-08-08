<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- BANNER -->
<section class="bc-banner">
	<div class="bc-container">
		<div class="bc-bread">
			<a href="${ctx}/home">Trang chủ</a>
			<span class="bc-bread-sep">/</span>
			<span>Tất cả sản phẩm</span>
		</div>
		<h1>Tất cả sách</h1>
		<p>Bộ sưu tập sách đa dạng từ BookChill</p>
	</div>
</section>

<section class="bc-section">
	<div class="bc-container">
		<div class="bc-shop-grid">
			<!-- SIDEBAR -->
			<aside class="bc-sidebar">
				<div class="bc-side-block">
					<h3>📚 Danh mục</h3>
					<ul class="bc-cat-list">
						<li class="${activeCat == null ? 'active' : ''}">
							<a href="${ctx}/shop">
								<span>Tất cả sách</span>
							</a>
						</li>
						<c:forEach var="dm" items="${listDM}">
							<li class="${activeCat == dm.getId() ? 'active' : ''}">
								<a href="${ctx}/shop?category=${dm.getId()}">
									<span>${dm.getName()}</span>
								</a>
							</li>
						</c:forEach>
					</ul>
				</div>

				<div class="bc-side-block">
					<h3><i class="bi bi-headset"></i> Hỗ trợ</h3>
					<ul class="bc-contact">
						<li><i class="bi bi-telephone-fill"></i> Hotline: 0904 415 459</li>
						<li><i class="bi bi-truck"></i> Giao hàng toàn quốc</li>
						<li><i class="bi bi-cash-coin"></i> Thanh toán COD</li>
						<li><i class="bi bi-arrow-repeat"></i> Đổi trả trong 7 ngày</li>
					</ul>
				</div>
			</aside>

			<!-- MAIN GRID -->
			<div class="bc-shop-main">
				<div class="bc-sort-bar">
					<span>Hiển thị <strong>${listSP.size()}</strong> sản phẩm</span>
					<form method="get" action="${ctx}/shop" style="display:inline-flex;gap:8px;align-items:center;">
						<c:if test="${not empty activeCat}">
							<input type="hidden" name="category" value="${activeCat}">
						</c:if>
						<label style="font-size:13px;font-weight:700;">Sắp xếp theo:</label>
						<select name="sort" class="bc-sort-select" onchange="this.form.submit()">
							<option value="" ${empty sort ? 'selected' : ''}>Mới nhất</option>
							<option value="priceAsc" ${sort == 'priceAsc' ? 'selected' : ''}>Giá: Thấp → Cao</option>
							<option value="priceDesc" ${sort == 'priceDesc' ? 'selected' : ''}>Giá: Cao → Thấp</option>
							<option value="name" ${sort == 'name' ? 'selected' : ''}>Tên A → Z</option>
						</select>
					</form>
				</div>

				<c:choose>
					<c:when test="${empty listSP}">
						<div class="bc-empty">
							<div class="bc-empty-icon">📦</div>
							<h3>Chưa có sản phẩm nào</h3>
							<p>Vui lòng chọn danh mục khác.</p>
							<a href="${ctx}/shop" class="bc-btn bc-btn-primary">Xem tất cả sách</a>
						</div>
					</c:when>
					<c:otherwise>
						<div class="bc-product-grid">
<c:forEach var="sp" items="${listSP}">
							<div class="bc-product-card">
								<a href="${ctx}/product-detail?id=${sp.getId()}" class="bc-product-link">
									<div class="bc-product-thumb">
										<c:if test="${sp.hasSale()}">
											<span class="bc-product-badge">-${sp.getDiscountPercent()}%</span>
										</c:if>
										<c:if test="${sp.getQuantity() <= 0}">
											<span class="bc-product-badge" style="background:#6c757d;">Hết hàng</span>
										</c:if>
										<img src="${sp.getImage()}" alt="${sp.getName()}"
											onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/placeholder-book.jsp?w=400&h=520&bg=b08968&text=BookChill';">
									</a>
									<div class="bc-product-quick">
										<c:choose>
											<c:when test="${sp.getQuantity() > 0}">
												<form action="${ctx}/cart" method="get" style="display:inline;margin:0;">
													<input type="hidden" name="action" value="add">
													<input type="hidden" name="productId" value="${sp.getId()}">
													<input type="hidden" name="quantity" value="1">
													<button type="submit" class="bc-quick-btn">
														<i class="bi bi-cart-plus"></i> Thêm vào giỏ
													</button>
												</form>
											</c:when>
											<c:otherwise>
												<button type="button" class="bc-quick-btn" disabled style="opacity:.6;cursor:not-allowed;"><i class="bi bi-x-circle"></i> Hết hàng</button>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
								<div class="bc-product-info">
									<div class="bc-product-cat">
										<c:choose>
											<c:when test="${sp.getCategoryId() == 1}">Sách giáo khoa</c:when>
											<c:when test="${sp.getCategoryId() == 2}">Truyện tranh</c:when>
											<c:when test="${sp.getCategoryId() == 3}">Văn học</c:when>
											<c:otherwise>Kỹ năng</c:otherwise>
										</c:choose>
									</div>
									<h3 class="bc-product-name"><a href="${ctx}/product-detail?id=${sp.getId()}">${sp.getName()}</a></h3>
									<div class="bc-product-author">
										<i class="bi bi-pen"></i> ${not empty sp.getAuthor() ? sp.getAuthor() : 'Nhiều tác giả'}
									</div>
										<div class="bc-product-foot">
											<span class="bc-price ${sp.hasSale() ? 'bc-price-sale' : ''}">
												<fmt:formatNumber value="${sp.getDisplayPrice()}" pattern="#,###" />₫
											</span>
											<c:if test="${sp.hasSale()}">
												<span class="bc-price-original">
													<fmt:formatNumber value="${sp.getPrice()}" pattern="#,###" />₫
												</span>
											</c:if>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</section>