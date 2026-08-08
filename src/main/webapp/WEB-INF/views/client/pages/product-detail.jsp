<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- BREADCRUMB -->
<section class="bc-banner" style="padding:24px 0 14px;">
	<div class="bc-container">
		<div class="bc-bread">
			<a href="${ctx}/home"><i class="bi bi-house-door"></i> Trang chủ</a>
			<span class="bc-bread-sep"><i class="bi bi-chevron-right"></i></span>
			<a href="${ctx}/shop">Sách</a>
			<span class="bc-bread-sep"><i class="bi bi-chevron-right"></i></span>
			<a href="${ctx}/shop?category=${sp.categoryId}">${categoryName}</a>
			<span class="bc-bread-sep"><i class="bi bi-chevron-right"></i></span>
			<span>${sp.name}</span>
		</div>
	</div>
</section>

<!-- PRODUCT DETAIL -->
<section class="bc-pd-wrap">
	<div class="bc-container">
		<div class="bc-pd-grid">

			<!-- LEFT: Main cover + Sample pages -->
			<div class="bc-pd-left">
				<div class="bc-pd-cover-card">
					<img id="mainCover" src="${sp.image}" alt="${sp.name}"
						onerror="this.onerror=null;this.src='${ctx}/assets/placeholder-book.jsp?w=400&h=600&bg=b08968&text=Book';">
					<c:if test="${sp.hasSale()}">
						<span class="bc-pd-badge-sale">-${sp.discountPercent}%</span>
					</c:if>
				</div>

				<!-- Sample pages gallery -->
				<div class="bc-pd-samples-card">
					<h4><i class="bi bi-book-half"></i> Một số trang sách</h4>
					<div class="bc-pd-sample-list">
						<div class="bc-pd-sample-item">
							<div class="bc-pd-sample-icon"><i class="bi bi-file-earmark-text"></i></div>
							<span>Trang bìa</span>
						</div>
						<div class="bc-pd-sample-item">
							<div class="bc-pd-sample-icon"><i class="bi bi-file-earmark-text"></i></div>
							<span>Mục lục</span>
						</div>
						<div class="bc-pd-sample-item">
							<div class="bc-pd-sample-icon"><i class="bi bi-file-earmark-text"></i></div>
							<span>Trang 12</span>
						</div>
						<div class="bc-pd-sample-item">
							<div class="bc-pd-sample-icon"><i class="bi bi-file-earmark-text"></i></div>
							<span>Trang 45</span>
						</div>
					</div>
				</div>
			</div>

			<!-- RIGHT: Info -->
			<div class="bc-pd-right">
				<span class="bc-pd-cat"><i class="bi bi-bookmark-heart-fill"></i> ${categoryName}</span>
				<h1 class="bc-pd-title">${sp.name}</h1>

				<div class="bc-pd-meta-row" style="margin-top:8px;">
					<i class="bi bi-pen"></i>
					<span>Tác giả: <strong>${not empty sp.author ? sp.author : 'Nhiều tác giả'}</strong></span>
				</div>

				<div class="bc-pd-meta-row">
					<i class="bi bi-star-fill"></i>
					<i class="bi bi-star-fill"></i>
					<i class="bi bi-star-fill"></i>
					<i class="bi bi-star-fill"></i>
					<i class="bi bi-star-half"></i>
					<span style="margin-left:6px;color:#1a1a1a;font-weight:700;">4.5/5</span>
					<span style="color:#6c757d;margin-left:8px;">• Đã bán 120+</span>
				</div>

				<div class="bc-pd-price-box">
					<c:choose>
						<c:when test="${sp.hasSale()}">
							<div class="bc-pd-price-now">
								<fmt:formatNumber value="${sp.salePrice}" pattern="#,###"/>₫
							</div>
							<div class="bc-pd-price-old">
								<fmt:formatNumber value="${sp.price}" pattern="#,###"/>₫
							</div>
							<span class="bc-pd-discount-tag">Tiết kiệm ${sp.discountPercent}%</span>
						</c:when>
						<c:otherwise>
							<div class="bc-pd-price-now">
								<fmt:formatNumber value="${sp.price}" pattern="#,###"/>₫
							</div>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- Service features -->
				<div class="bc-pd-services">
					<div class="bc-pd-svc">
						<i class="bi bi-truck"></i>
						<div>
							<strong>Giao hàng toàn quốc</strong>
							<small>Miễn phí vận chuyển cho đơn từ 200k</small>
						</div>
					</div>
					<div class="bc-pd-svc">
						<i class="bi bi-cash-coin"></i>
						<div>
							<strong>COD - Thanh toán khi nhận hàng</strong>
							<small>Hoặc chuyển khoản ngân hàng</small>
						</div>
					</div>
					<div class="bc-pd-svc">
						<i class="bi bi-arrow-repeat"></i>
						<div>
							<strong>Đổi trả trong 7 ngày</strong>
							<small>Nếu sách có lỗi của nhà xuất bản</small>
						</div>
					</div>
					<div class="bc-pd-svc">
						<i class="bi bi-box-seam"></i>
						<div>
							<strong>Tình trạng kho:</strong>
							<c:choose>
								<c:when test="${sp.quantity <= 0}">
									<span class="stock-out">Hết hàng</span>
								</c:when>
								<c:when test="${sp.quantity <= 5}">
									<span class="stock-low">Còn ${sp.quantity} cuốn (sắp hết)</span>
								</c:when>
								<c:otherwise>
									<span class="stock-ok">Còn ${sp.quantity} cuốn</span>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>

					<!-- Actions -->
					<div class="bc-pd-actions">
						<c:choose>
							<c:when test="${sp.quantity > 0}">
								<form id="pdAddForm" action="${ctx}/cart" method="get" class="bc-pd-form">
									<input type="hidden" name="action" value="add"/>
									<input type="hidden" name="productId" value="${sp.id}"/>
									<input type="hidden" name="redirect" value="back"/>
									<div class="bc-pd-qty-wrap">
										<span class="bc-pd-qty-label">Số lượng:</span>
										<div class="bc-pd-qty">
											<button type="button" onclick="changePDQty(-1)">−</button>
											<input type="number" name="quantity" id="pdQty" value="1" min="1" max="${sp.quantity}"/>
											<button type="button" onclick="changePDQty(1)">+</button>
										</div>
									</div>
									<div class="bc-pd-btn-row">
										<button type="submit" class="bc-btn bc-btn-ghost bc-btn-lg bc-btn-flex">
											<i class="bi bi-cart-plus"></i> Thêm vào giỏ
										</button>
									</div>
								</form>
								<form id="pdBuyForm" action="${ctx}/cart" method="get" class="bc-pd-form" style="margin-top:8px;">
									<input type="hidden" name="action" value="add"/>
									<input type="hidden" name="productId" value="${sp.id}"/>
									<input type="hidden" name="quantity" value="1"/>
									<input type="hidden" name="redirect" value="checkout"/>
									<button type="submit" class="bc-btn bc-btn-primary bc-btn-lg bc-btn-flex" style="width:100%;">
										<i class="bi bi-lightning-fill"></i> Mua ngay
									</button>
								</form>
							</c:when>
						<c:otherwise>
							<button type="button" class="bc-btn bc-btn-lg bc-btn-flex" disabled style="opacity:.5;cursor:not-allowed;background:#9ca39a;border-color:#9ca39a;">
								<i class="bi bi-x-circle"></i> Hết hàng
							</button>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- Hotline -->
				<div class="bc-pd-hotline">
					<div class="bc-pd-hotline-icon">
						<i class="bi bi-telephone-fill"></i>
					</div>
					<div>
						<small>Hotline tư vấn miễn phí</small>
						<strong>0904 415 459</strong>
					</div>
				</div>
			</div>
		</div>

		<!-- Description block -->
		<div class="bc-pd-desc-card">
			<div class="bc-pd-desc-head">
				<i class="bi bi-card-text"></i>
				<h2>Mô tả sản phẩm</h2>
			</div>
			<div class="bc-pd-desc-body">
				<c:choose>
					<c:when test="${not empty sp.des}">
						<p>${sp.des}</p>
					</c:when>
					<c:otherwise>
						<p>Cuốn sách <strong>${sp.name}</strong> là một tác phẩm giá trị dành cho mọi độc giả.
						Với nội dung chất lượng và hình thức trình bày đẹp mắt, đây sẽ là lựa chọn tuyệt vời
						cho tủ sách của bạn.</p>
						<p>Một cuốn sách hay không chỉ mang đến kiến thức mà còn là người bạn đồng hành
						trong những giờ phút thư giãn. Hãy để <em>${sp.name}</em> trở thành một phần
						trong hành trình khám phá tri thức của bạn.</p>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</section>

<script>
function changePDQty(delta) {
	var input = document.getElementById('pdQty');
	var v = parseInt(input.value) || 1;
	var max = parseInt(input.max) || 999;
	v += delta;
	if (v < 1) v = 1;
	if (v > max) v = max;
	input.value = v;
}
</script>