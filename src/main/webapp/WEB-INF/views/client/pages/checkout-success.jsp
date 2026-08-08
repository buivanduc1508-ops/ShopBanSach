<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<section class="bc-success">
	<div class="bc-container">
		<div class="bc-success-card">
			<div class="bc-success-icon">✓</div>
			<h1>Đặt hàng thành công!</h1>
			<p>
				Cảm ơn bạn đã mua sắm tại <strong>BookChill</strong>. Đơn hàng của bạn đang được xử lý và sẽ được giao trong 2-3 ngày tới.
			</p>
			<c:if test="${not empty param.id}">
				<div class="bc-success-order">
					<span>Mã đơn hàng</span>
					<strong>#${param.id}</strong>
				</div>
			</c:if>
			<div class="bc-success-actions">
				<a href="${ctx}/home" class="bc-btn bc-btn-primary">🏠 Về trang chủ</a>
				<a href="${ctx}/shop" class="bc-btn bc-btn-ghost">📖 Tiếp tục mua sắm</a>
			</div>
		</div>
	</div>
</section>