<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="page-heading">
	<h3>Quản lý đơn hàng</h3>
	<p class="text-muted">Cập nhật trạng thái, xem chi tiết đơn hàng</p>
</div>

<div class="page-content" style="padding: 24px 28px;">
	<div class="adm-table-card">
		<div class="adm-card-header">
			<h4>📦 ${listHD.size()} đơn hàng</h4>
		</div>

		<!-- THANH LOC + TIM KIEM -->
		<div style="padding:18px 22px;border-bottom:1px solid #e8e8e8;display:flex;gap:10px;flex-wrap:wrap;align-items:center;background:#fafafa;">
			<form action="${ctx}/admin?page=donhang" method="get" style="display:flex;gap:8px;flex:1;min-width:280px;">
				<input type="hidden" name="page" value="donhang"/>
				<input type="text" name="keyword" placeholder="🔍 Tìm theo tên, SĐT, mã đơn..."
					value="${keyword}" style="flex:1;padding:8px 12px;border:1px solid #d4a373;border-radius:8px;font-size:14px;"/>
				<button type="submit" class="adm-btn adm-btn-primary"><i class="bi bi-search"></i></button>
			</form>
			<form action="${ctx}/admin?page=donhang" method="get" style="display:flex;gap:8px;">
				<input type="hidden" name="page" value="donhang"/>
				<select name="status" onchange="this.form.submit()" style="padding:8px 12px;border:1px solid #d4a373;border-radius:8px;font-size:14px;background:#fff;">
					<option value="ALL" ${empty filterStatus || filterStatus == 'ALL' ? 'selected' : ''}>📋 Tất cả</option>
					<option value="PENDING" ${filterStatus == 'PENDING' ? 'selected' : ''}>⏳ Chờ xác nhận</option>
					<option value="CONFIRMED" ${filterStatus == 'CONFIRMED' ? 'selected' : ''}>✅ Đã xác nhận</option>
					<option value="SHIPPING" ${filterStatus == 'SHIPPING' ? 'selected' : ''}>🚚 Đang giao</option>
					<option value="FINISH" ${filterStatus == 'FINISH' ? 'selected' : ''}>🎉 Hoàn thành</option>
					<option value="CANCELLED" ${filterStatus == 'CANCELLED' ? 'selected' : ''}>❌ Đã hủy</option>
				</select>
			</form>
			<c:if test="${not empty keyword or (not empty filterStatus and filterStatus != 'ALL')}">
				<a href="${ctx}/admin?page=donhang" class="adm-btn adm-btn-light">
					<i class="bi bi-x-circle"></i> Xóa lọc
				</a>
			</c:if>
		</div>

		<c:choose>
			<c:when test="${empty listHD}">
				<div class="adm-empty">
					<i class="bi bi-receipt" style="font-size:64px;color:#d4a373;"></i>
					<h3>Không có đơn hàng nào</h3>
					<p>Thử đổi bộ lọc hoặc từ khóa khác.</p>
				</div>
			</c:when>
			<c:otherwise>
				<table class="adm-table">
					<thead>
						<tr>
							<th>Mã ĐH</th>
							<th>Người nhận</th>
							<th>SĐT</th>
							<th>Tổng tiền</th>
							<th>Thanh toán</th>
							<th>Trạng thái</th>
							<th>Ngày tạo</th>
							<th>Hành động</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="hd" items="${listHD}">
							<tr>
								<td>
									<strong>#${hd.getId()}</strong><br>
									<a href="${ctx}/admin/donhang?view=detail&id=${hd.getId()}" style="font-size:11px;color:#b08968;">
										<i class="bi bi-eye"></i> Xem chi tiết
									</a>
								</td>
								<td><strong>${hd.getReceiverName()}</strong></td>
								<td>${hd.getReceiverPhone()}</td>
								<td><strong style="color:#e63946;"><fmt:formatNumber value="${hd.getTotalAmount()}" pattern="#,###"/>₫</strong></td>
								<td><span class="adm-badge adm-badge-info">${hd.getPaymentMethod()}</span></td>
								<td>
									<c:choose>
										<c:when test="${hd.getOrderStatus() == 'PENDING'}">
											<span class="adm-badge adm-badge-warning">⏳ Chờ xác nhận</span>
										</c:when>
										<c:when test="${hd.getOrderStatus() == 'CONFIRMED'}">
											<span class="adm-badge adm-badge-info">✅ Đã xác nhận</span>
										</c:when>
										<c:when test="${hd.getOrderStatus() == 'SHIPPING'}">
											<span class="adm-badge adm-badge-info">🚚 Đang giao</span>
										</c:when>
										<c:when test="${hd.getOrderStatus() == 'FINISH'}">
											<span class="adm-badge adm-badge-success">🎉 Hoàn thành</span>
										</c:when>
										<c:when test="${hd.getOrderStatus() == 'CANCELLED'}">
											<span class="adm-badge adm-badge-danger">❌ Đã hủy</span>
										</c:when>
									</c:choose>
								</td>
								<td><small>${hd.getCreatedAt()}</small></td>
								<td>
									<form action="${ctx}/admin/donhang" method="post" style="display:inline-flex;gap:4px;">
										<input type="hidden" name="action" value="updateStatus"/>
										<input type="hidden" name="id" value="${hd.getId()}"/>
										<select name="status" class="adm-search-form" style="padding:6px 8px;font-size:12px;min-width:120px;">
											<option value="PENDING" ${hd.getOrderStatus() == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
											<option value="CONFIRMED" ${hd.getOrderStatus() == 'CONFIRMED' ? 'selected' : ''}>Xác nhận</option>
											<option value="SHIPPING" ${hd.getOrderStatus() == 'SHIPPING' ? 'selected' : ''}>Đang giao</option>
											<option value="FINISH" ${hd.getOrderStatus() == 'FINISH' ? 'selected' : ''}>Hoàn thành</option>
											<option value="CANCELLED" ${hd.getOrderStatus() == 'CANCELLED' ? 'selected' : ''}>Hủy</option>
										</select>
										<button type="submit" class="adm-btn adm-btn-primary" title="Lưu"><i class="bi bi-check"></i></button>
									</form>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:otherwise>
		</c:choose>
	</div>
</div>