<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="page-heading">
	<h3>Tổng quan</h3>
	<p class="text-muted">Thống kê nhanh hệ thống BookChill</p>
</div>

<div class="page-content" style="padding: 24px 28px;">
	<!-- STAT CARDS -->
	<div class="row g-3 mb-4">
		<div class="col-md-4 col-xl-3">
			<div class="adm-stat-card adm-stat-success">
				<div class="adm-stat-label">Doanh thu</div>
				<div class="adm-stat-value"><fmt:formatNumber value="${revenue}" pattern="#,###"/>₫</div>
			</div>
		</div>
		<div class="col-md-4 col-xl-3">
			<div class="adm-stat-card">
				<div class="adm-stat-label">Sản phẩm</div>
				<div class="adm-stat-value">${totalSP}</div>
			</div>
		</div>
		<div class="col-md-4 col-xl-3">
			<div class="adm-stat-card adm-stat-info">
				<div class="adm-stat-label">Đơn hàng</div>
				<div class="adm-stat-value">${totalHD}</div>
			</div>
		</div>
		<div class="col-md-4 col-xl-3">
			<div class="adm-stat-card adm-stat-warning">
				<div class="adm-stat-label">Người dùng</div>
				<div class="adm-stat-value">${totalUsers}</div>
			</div>
		</div>
	</div>

	<div class="row g-3 mb-4">
		<div class="col-md-3">
			<div class="adm-stat-card adm-stat-warning">
				<div class="adm-stat-label">⏳ Chờ xác nhận</div>
				<div class="adm-stat-value">${hdPending}</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="adm-stat-card adm-stat-info">
				<div class="adm-stat-label">✅ Đã xác nhận</div>
				<div class="adm-stat-value">${hdConfirmed}</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="adm-stat-card adm-stat-info">
				<div class="adm-stat-label">🚚 Đang giao</div>
				<div class="adm-stat-value">${hdShipping}</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="adm-stat-card adm-stat-success">
				<div class="adm-stat-label">🎉 Hoàn thành</div>
				<div class="adm-stat-value">${hdFinish}</div>
			</div>
		</div>
	</div>

	<!-- BIEU DO DOANH THU 7 NGAY + TOP SAN PHAM -->
	<div class="row g-3 mb-4">
		<div class="col-lg-7">
			<div class="adm-table-card">
				<div class="adm-card-header">
					<h4><i class="bi bi-graph-up"></i> Doanh thu 7 ngày gần nhất</h4>
				</div>
				<div style="padding:24px;height:320px;">
					<canvas id="revenueChart"></canvas>
				</div>
			</div>
		</div>
		<div class="col-lg-5">
			<div class="adm-table-card">
				<div class="adm-card-header">
					<h4><i class="bi bi-trophy-fill"></i> Top 5 sản phẩm bán chạy</h4>
				</div>
				<div style="padding:18px;">
					<c:choose>
						<c:when test="${empty topProducts}">
							<div class="adm-empty" style="padding:30px;">
								<i class="bi bi-inbox" style="font-size:48px;color:#d4a373;"></i>
								<p>Chưa có dữ liệu bán hàng.</p>
							</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="tp" items="${topProducts}" varStatus="vs">
								<div style="display:flex;align-items:center;gap:12px;padding:12px;border-bottom:1px solid #f0f0f0;">
									<div style="width:32px;height:32px;border-radius:50%;background:${vs.count == 1 ? '#ffd700' : vs.count == 2 ? '#c0c0c0' : vs.count == 3 ? '#cd7f32' : '#e8e8e8'};color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;flex-shrink:0;">
										${vs.count}
									</div>
									<div style="flex:1;min-width:0;">
										<strong style="display:block;font-size:13px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${tp[0]}">${tp[0]}</strong>
										<small class="text-muted">Đã bán: <strong>${tp[1]}</strong> cuốn</small>
									</div>
									<div style="text-align:right;flex-shrink:0;">
										<strong style="color:#e63946;font-size:13px;">
											<fmt:formatNumber value="${tp[2]}" pattern="#,###"/>₫
										</strong>
									</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</div>

	<div class="row g-3">
		<div class="col-md-6">
			<div class="adm-stat-card adm-stat-danger">
				<div class="adm-stat-label">⚠️ Sắp hết hàng (≤5)</div>
				<div class="adm-stat-value">${lowStock}</div>
				<a href="${ctx}/admin?page=sanpham" class="adm-btn adm-btn-light mt-2">Quản lý</a>
			</div>
		</div>
		<div class="col-md-6">
			<div class="adm-stat-card adm-stat-danger">
				<div class="adm-stat-label">❌ Đơn bị hủy</div>
				<div class="adm-stat-value">${hdCancelled}</div>
			</div>
		</div>
	</div>

	<!-- SHORTCUT -->
	<div class="adm-table-card mt-4">
		<div class="adm-card-header">
			<h4>Truy cập nhanh</h4>
		</div>
		<div style="padding: 22px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
			<a href="${ctx}/admin?page=sanpham" class="adm-btn adm-btn-primary" style="text-align:center;padding:18px;">
				<i class="bi bi-book-half" style="font-size:24px;display:block;margin-bottom:6px;"></i>
				Quản lý sản phẩm
			</a>
			<a href="${ctx}/admin?page=danhmuc" class="adm-btn adm-btn-success" style="text-align:center;padding:18px;">
				<i class="bi bi-tags-fill" style="font-size:24px;display:block;margin-bottom:6px;"></i>
				Quản lý danh mục
			</a>
			<a href="${ctx}/admin?page=donhang" class="adm-btn adm-btn-primary" style="text-align:center;padding:18px;">
				<i class="bi bi-receipt-cutoff" style="font-size:24px;display:block;margin-bottom:6px;"></i>
				Quản lý đơn hàng
			</a>
			<a href="${ctx}/admin?page=nguoidung" class="adm-btn adm-btn-success" style="text-align:center;padding:18px;">
				<i class="bi bi-people-fill" style="font-size:24px;display:block;margin-bottom:6px;"></i>
				Quản lý người dùng
			</a>
		</div>
	</div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
(function() {
	var revenueData = [
		<c:forEach var="r" items="${revenue7}" varStatus="vs">
			${r}<c:if test="${!vs.last}">,</c:if>
		</c:forEach>
	];
	// Tao nhan ngay (dd/MM) cho 7 ngay gan nhat
	var labels = [];
	var now = new Date();
	for (var i = 6; i >= 0; i--) {
		var d = new Date(now);
		d.setDate(d.getDate() - i);
		labels.push(String(d.getDate()).padStart(2, '0') + '/' + String(d.getMonth() + 1).padStart(2, '0'));
	}

	var ctx = document.getElementById('revenueChart');
	if (!ctx) return;
	var chart = new Chart(ctx, {
		type: 'line',
		data: {
			labels: labels,
			datasets: [{
				label: 'Doanh thu (₫)',
				data: revenueData,
				borderColor: '#b08968',
				backgroundColor: 'rgba(176, 137, 104, 0.15)',
				borderWidth: 3,
				fill: true,
				tension: 0.35,
				pointRadius: 5,
				pointBackgroundColor: '#b08968',
				pointBorderColor: '#fff',
				pointBorderWidth: 2,
				pointHoverRadius: 7
			}]
		},
		options: {
			responsive: true,
			maintainAspectRatio: false,
			plugins: {
				legend: { display: false },
				tooltip: {
					callbacks: {
						label: function(c) {
							return ' Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(c.parsed.y) + '₫';
						}
					}
				}
			},
			scales: {
				y: {
					beginAtZero: true,
					ticks: {
						callback: function(v) {
							return new Intl.NumberFormat('vi-VN').format(v);
						}
					}
				}
			}
		}
	});
})();
</script>