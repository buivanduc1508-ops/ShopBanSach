<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<section class="bc-banner">
	<div class="bc-container">
		<div class="bc-bread">
			<a href="${ctx}/home">Trang chủ</a>
			<span class="bc-bread-sep">/</span>
			<span>Giỏ hàng</span>
		</div>
		<h1><i class="bi bi-bag-heart-fill"></i> Giỏ hàng của bạn</h1>
		<p>Có <strong>${cartItems.size()}</strong> sản phẩm trong giỏ — sẵn sàng thanh toán</p>
	</div>
</section>

<section class="bc-section">
	<div class="bc-container">
		<c:choose>
			<c:when test="${empty cartItems}">
				<div class="bc-empty">
					<div class="bc-empty-icon"><i class="bi bi-bag-x"></i></div>
					<h3>Giỏ hàng của bạn đang trống</h3>
					<p>Hãy khám phá những cuốn sách hay và thêm vào giỏ nhé!</p>
					<a href="${ctx}/shop" class="bc-btn bc-btn-primary"><i class="bi bi-book"></i> Tiếp tục mua sắm</a>
				</div>
			</c:when>
			<c:otherwise>
				<div class="bc-cart-wrap">
					<div class="bc-cart-list">
						<div class="bc-cart-head">
							<div>Sản phẩm</div>
							<div>Đơn giá</div>
							<div>Số lượng</div>
							<div>Thành tiền</div>
							<div></div>
						</div>
						<c:forEach var="item" items="${cartItems}">
							<div class="bc-cart-row">
								<div class="bc-cart-prod">
									<img src="${item.getImage()}" alt="${item.getName()}"
										onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/placeholder-book.jsp?w=100&h=130&bg=b08968&text=Book';">
									<div>
										<h4>${item.getName()}</h4>
										<c:if test="${item.hasSale()}">
											<span style="color:#e63946;font-size:12px;font-weight:700;"><i class="bi bi-fire"></i> Đang giảm giá</span>
										</c:if>
									</div>
								</div>
								<div class="bc-cart-price">
									<c:choose>
										<c:when test="${item.hasSale()}">
											<span class="bc-price-sale"><fmt:formatNumber value="${item.getDisplayPrice()}" pattern="#,###" />₫</span>
											<div class="bc-price-original"><fmt:formatNumber value="${item.getPrice()}" pattern="#,###" />₫</div>
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${item.getPrice()}" pattern="#,###" />₫
										</c:otherwise>
									</c:choose>
								</div>
								<div class="bc-cart-qty">
									<form action="${ctx}/cart" method="post" class="bc-qty-form">
										<input type="hidden" name="action" value="update">
										<input type="hidden" name="productId" value="${item.getProductId()}">
										<div class="bc-qty-ctrl">
											<button type="button" onclick="changeQty(this,-1)">−</button>
											<input type="number" name="quantity" min="1" value="${item.getQuantity()}" onchange="this.form.submit()">
											<button type="button" onclick="changeQty(this,1)">+</button>
										</div>
									</form>
								</div>
								<div class="bc-cart-total">
									<fmt:formatNumber value="${item.getLineTotal()}" pattern="#,###" />₫
								</div>
								<div>
									<form action="${ctx}/cart" method="post">
										<input type="hidden" name="action" value="remove">
										<input type="hidden" name="productId" value="${item.getProductId()}">
										<button type="submit" class="bc-remove-btn" title="Xóa"><i class="bi bi-x"></i></button>
									</form>
								</div>
							</div>
						</c:forEach>
					</div>

					<aside class="bc-cart-summary">
						<h3>📋 Tóm tắt đơn hàng</h3>
						<div class="bc-sum-row">
							<span>Tạm tính</span>
							<strong><fmt:formatNumber value="${cartTotal}" pattern="#,###" />₫</strong>
						</div>
						<div class="bc-sum-row">
							<span>Phí vận chuyển</span>
							<strong style="color:var(--emerald)">Miễn phí</strong>
						</div>
						<div class="bc-sum-row bc-sum-total">
							<span>Tổng cộng</span>
							<strong><fmt:formatNumber value="${cartTotal}" pattern="#,###" />₫</strong>
						</div>
						<a href="${ctx}/checkout" class="bc-btn-checkout-big">
							<i class="bi bi-credit-card-2-back-fill"></i>
							<span>THANH TOÁN NGAY</span>
							<i class="bi bi-arrow-right bc-checkout-arrow"></i>
						</a>
						<a href="${ctx}/shop" class="bc-btn bc-btn-ghost bc-btn-block" style="margin-top:14px;">
							<i class="bi bi-arrow-left"></i> Tiếp tục mua sắm
						</a>
					</aside>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
</section>

<script>
function changeQty(btn, delta) {
	var input = btn.parentElement.querySelector('input[type=number]');
	var val = parseInt(input.value) || 1;
	val += delta;
	if (val < 1) val = 1;
	input.value = val;
	input.form.submit();
}
</script>