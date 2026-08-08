<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<section class="bc-banner">
	<div class="bc-container">
		<div class="bc-bread">
			<a href="${ctx}/home">Trang chủ</a>
			<span class="bc-bread-sep">/</span>
			<a href="${ctx}/cart">Giỏ hàng</a>
			<span class="bc-bread-sep">/</span>
			<span>Thanh toán</span>
		</div>
		<h1>Thanh toán</h1>
		<p>Hoàn tất đơn hàng của bạn</p>
	</div>
</section>

<section class="bc-section">
	<div class="bc-container">
		<c:if test="${not empty error}">
			<div class="bc-alert">⚠️ ${error}</div>
		</c:if>

		<div class="bc-checkout-wrap">
			<form action="${ctx}/checkout" method="post" class="bc-checkout-form">
				<h3>👤 Thông tin người nhận</h3>

				<div class="bc-form-row">
					<div class="bc-form-group">
						<label>Họ và tên <span>*</span></label>
						<input type="text" name="receiverName" required
							value="${currentUser != null ? currentUser.getFullName() : ''}">
					</div>
					<div class="bc-form-group">
						<label>Số điện thoại <span>*</span></label>
						<input type="text" name="receiverPhone" required
							value="${currentUser != null ? currentUser.getPhone() : ''}">
					</div>
				</div>

				<div class="bc-form-group">
					<label>Địa chỉ giao hàng <span>*</span></label>
					<input type="text" name="receiverAddress" required
						value="${currentUser != null ? currentUser.getAddress() : ''}">
				</div>

				<div class="bc-form-group">
					<label>Ghi chú</label>
					<textarea name="note" rows="3" placeholder="Giao giờ hành chính, gọi trước 15 phút..."></textarea>
				</div>

				<h3>💳 Phương thức thanh toán</h3>
				<div class="bc-pay-methods">
					<label class="bc-pay-card">
						<input type="radio" name="paymentMethod" value="COD" checked>
						<span>💵 Thanh toán khi nhận hàng (COD)</span>
					</label>
					<label class="bc-pay-card">
						<input type="radio" name="paymentMethod" value="ONLINE">
						<span>🏦 Chuyển khoản (demo)</span>
					</label>
				</div>

				<button type="submit" class="bc-btn bc-btn-primary bc-btn-block bc-btn-lg">
					✓ Đặt hàng
				</button>
			</form>

			<aside class="bc-cart-summary">
				<h3>🛒 Đơn hàng của bạn</h3>
				<c:forEach var="item" items="${cartItems}">
					<div style="display:flex;gap:10px;padding:12px 0;border-bottom:1px dashed var(--border);align-items:center;">
						<img src="${item.getImage()}" alt="${item.getName()}"
							onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/placeholder-book.jsp?w=60&h=80&bg=b08968&text=Book';"
							style="width:48px;height:64px;object-fit:cover;border-radius:4px;">
						<div style="flex:1;">
							<h4 style="font-size:13px;font-weight:500;line-height:1.3;">${item.getName()}</h4>
							<span style="font-size:12px;color:var(--text-muted);">
								<fmt:formatNumber value="${item.getPrice()}" pattern="#,###" />₫ × ${item.getQuantity()}
							</span>
						</div>
						<strong style="font-size:13px;color:var(--text);">
							<fmt:formatNumber value="${item.getLineTotal()}" pattern="#,###" />₫
						</strong>
					</div>
				</c:forEach>
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
			</aside>
		</div>
	</div>
</section>