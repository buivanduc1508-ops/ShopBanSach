<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="page-heading">
	<h3><i class="bi bi-receipt-cutoff"></i> Chi tiết đơn hàng #${invoice.getId()}</h3>
	<p class="text-muted">Tạo lúc ${invoice.getCreatedAt()}</p>
</div>

<div class="page-content" style="padding: 24px 28px;">
	<div class="row g-3">
		<!-- Thong tin nguoi nhan -->
		<div class="col-md-4">
			<div class="adm-table-card">
				<div class="adm-card-header">
					<h4><i class="bi bi-person-circle"></i> Người nhận</h4>
				</div>
				<div style="padding:20px;">
					<div style="margin-bottom:12px;">
						<small class="text-muted">Họ tên</small>
						<strong style="display:block;font-size:15px;">${invoice.getReceiverName()}</strong>
					</div>
					<div style="margin-bottom:12px;">
						<small class="text-muted">Số điện thoại</small>
						<strong style="display:block;">
							<a href="tel:${invoice.getReceiverPhone()}" style="color:#b08968;">${invoice.getReceiverPhone()}</a>
						</strong>
					</div>
					<div style="margin-bottom:12px;">
						<small class="text-muted">Địa chỉ</small>
						<strong style="display:block;font-size:13px;">${invoice.getReceiverAddress()}</strong>
					</div>
					<c:if test="${not empty invoice.getNote()}">
						<div>
							<small class="text-muted">Ghi chú</small>
							<div style="background:#fff8e1;padding:10px;border-radius:6px;border-left:3px solid #d4a373;font-size:13px;margin-top:4px;">
								<i class="bi bi-chat-left-text"></i> ${invoice.getNote()}
							</div>
						</div>
					</c:if>
				</div>
			</div>
		</div>

		<!-- Thong tin don + items -->
		<div class="col-md-8">
			<div class="adm-table-card">
				<div class="adm-card-header">
					<h4><i class="bi bi-box-seam"></i> Sản phẩm (${invoiceItems.size()})</h4>
					<div>
						<c:choose>
							<c:when test="${invoice.getOrderStatus() == 'PENDING'}">
								<span class="adm-badge adm-badge-warning">⏳ Chờ xác nhận</span>
							</c:when>
							<c:when test="${invoice.getOrderStatus() == 'CONFIRMED'}">
								<span class="adm-badge adm-badge-info">✅ Đã xác nhận</span>
							</c:when>
							<c:when test="${invoice.getOrderStatus() == 'SHIPPING'}">
								<span class="adm-badge adm-badge-info">🚚 Đang giao</span>
							</c:when>
							<c:when test="${invoice.getOrderStatus() == 'FINISH'}">
								<span class="adm-badge adm-badge-success">🎉 Hoàn thành</span>
							</c:when>
							<c:when test="${invoice.getOrderStatus() == 'CANCELLED'}">
								<span class="adm-badge adm-badge-danger">❌ Đã hủy</span>
							</c:when>
						</c:choose>
					</div>
				</div>
				<table class="adm-table">
					<thead>
						<tr>
							<th>Ảnh</th>
							<th>Sản phẩm</th>
							<th>SL</th>
							<th>Đơn giá</th>
							<th>Thành tiền</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="it" items="${invoiceItems}">
							<tr>
								<td>
									<img src="${it.getImage()}" alt="${it.getName()}" class="adm-img"
										onerror="this.onerror=null;this.src='${ctx}/assets/placeholder-book.jsp?w=80&h=100&bg=b08968&text=Book';">
								</td>
								<td><strong>${it.getName()}</strong></td>
								<td><strong>×${it.getQuantity()}</strong></td>
								<td><fmt:formatNumber value="${it.getPrice()}" pattern="#,###"/>₫</td>
								<td>
									<strong style="color:#e63946;">
										<fmt:formatNumber value="${it.getQuantity() * it.getPrice()}" pattern="#,###"/>₫
									</strong>
								</td>
							</tr>
						</c:forEach>
					</tbody>
					<tfoot>
						<tr style="background:#fff8e1;font-size:15px;">
							<td colspan="4" style="text-align:right;padding:14px;"><strong>TỔNG CỘNG:</strong></td>
							<td style="padding:14px;">
								<strong style="color:#e63946;font-size:18px;">
									<fmt:formatNumber value="${invoice.getTotalAmount()}" pattern="#,###"/>₫
								</strong>
							</td>
						</tr>
					</tfoot>
				</table>
			</div>

			<!-- Cap nhat trang thai -->
			<div class="adm-table-card mt-3">
				<div class="adm-card-header">
					<h4><i class="bi bi-arrow-repeat"></i> Cập nhật trạng thái</h4>
				</div>
				<div style="padding:20px;">
					<form action="${ctx}/admin/donhang" method="post" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
						<input type="hidden" name="action" value="updateStatus"/>
						<input type="hidden" name="id" value="${invoice.getId()}"/>
						<select name="status" class="adm-search-form" style="padding:8px 12px;font-size:14px;min-width:200px;">
							<option value="PENDING" ${invoice.getOrderStatus() == 'PENDING' ? 'selected' : ''}>⏳ Chờ xác nhận</option>
							<option value="CONFIRMED" ${invoice.getOrderStatus() == 'CONFIRMED' ? 'selected' : ''}>✅ Đã xác nhận</option>
							<option value="SHIPPING" ${invoice.getOrderStatus() == 'SHIPPING' ? 'selected' : ''}>🚚 Đang giao</option>
							<option value="FINISH" ${invoice.getOrderStatus() == 'FINISH' ? 'selected' : ''}>🎉 Hoàn thành</option>
							<option value="CANCELLED" ${invoice.getOrderStatus() == 'CANCELLED' ? 'selected' : ''}>❌ Hủy đơn</option>
						</select>
						<button type="submit" class="adm-btn adm-btn-primary">
							<i class="bi bi-check-circle"></i> Cập nhật
						</button>
						<span class="text-muted" style="font-size:12px;margin-left:10px;">
							<i class="bi bi-info-circle"></i> Thanh toán: <strong>${invoice.getPaymentMethod()}</strong>
						</span>
					</form>
				</div>
			</div>

			<div style="margin-top:20px;">
				<a href="${ctx}/admin?page=donhang" class="adm-btn adm-btn-light">
					<i class="bi bi-arrow-left"></i> Quay lại danh sách
				</a>
			</div>
		</div>
	</div>
</div>