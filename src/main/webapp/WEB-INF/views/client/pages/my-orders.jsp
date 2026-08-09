<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="bc-container" style="padding: 40px 20px; min-height: 60vh;">
	<div style="max-width: 1100px; margin: 0 auto;">
		<div style="margin-bottom: 28px;">
			<h2 style="color: #3d2817; font-weight: 800; margin: 0 0 8px;">
				<i class="bi bi-receipt-cutoff" style="color: #b08968;"></i>
				Đơn hàng của tôi
			</h2>
			<p style="color: #6c757d; margin: 0;">Theo dõi trạng thái và lịch sử các đơn hàng bạn đã đặt.</p>
		</div>

		<c:choose>
			<c:when test="${empty myOrders}">
				<div style="background: #fff; border-radius: 12px; padding: 60px 20px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,.04);">
					<i class="bi bi-inbox" style="font-size: 80px; color: #d4a373;"></i>
					<h3 style="color: #3d2817; margin: 16px 0 8px;">Bạn chưa có đơn hàng nào</h3>
					<p style="color: #6c757d; margin-bottom: 20px;">Hãy khám phá và đặt mua những cuốn sách yêu thích nhé!</p>
					<a href="${ctx}/shop" class="bc-btn bc-btn-primary" style="display: inline-block; padding: 12px 24px; background: #b08968; color: #fff; text-decoration: none; border-radius: 8px; font-weight: 600;">
						<i class="bi bi-book"></i> Khám phá sách ngay
					</a>
				</div>
			</c:when>

			<c:otherwise>
				<!-- Loc theo trang thai -->
				<div style="background: #fff; border-radius: 12px; padding: 14px 18px; margin-bottom: 16px; box-shadow: 0 2px 8px rgba(0,0,0,.04); display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
					<span style="font-weight: 600; color: #3d2817;">Lọc:</span>
					<a href="${ctx}/my-orders" class="bc-chip ${empty param.status || param.status == 'ALL' ? 'active' : ''}" style="padding:6px 14px;border-radius:999px;border:1px solid #d4a373;text-decoration:none;font-size:13px;font-weight:600;color:${empty param.status || param.status == 'ALL' ? '#fff' : '#3d2817'};background:${empty param.status || param.status == 'ALL' ? '#b08968' : '#fff'};">
						Tất cả (${myOrders.size()})
					</a>
					<c:set var="cntPending" value="0"/><c:set var="cntConfirmed" value="0"/><c:set var="cntShipping" value="0"/><c:set var="cntFinish" value="0"/><c:set var="cntCancelled" value="0"/>
					<c:forEach var="o" items="${myOrders}">
						<c:choose>
							<c:when test="${o.getOrderStatus() == 'PENDING'}"><c:set var="cntPending" value="${cntPending + 1}"/></c:when>
							<c:when test="${o.getOrderStatus() == 'CONFIRMED'}"><c:set var="cntConfirmed" value="${cntConfirmed + 1}"/></c:when>
							<c:when test="${o.getOrderStatus() == 'SHIPPING'}"><c:set var="cntShipping" value="${cntShipping + 1}"/></c:when>
							<c:when test="${o.getOrderStatus() == 'FINISH'}"><c:set var="cntFinish" value="${cntFinish + 1}"/></c:when>
							<c:when test="${o.getOrderStatus() == 'CANCELLED'}"><c:set var="cntCancelled" value="${cntCancelled + 1}"/></c:when>
						</c:choose>
					</c:forEach>
					<a href="${ctx}/my-orders?status=PENDING" class="bc-chip" style="padding:6px 14px;border-radius:999px;border:1px solid #d4a373;text-decoration:none;font-size:13px;font-weight:600;color:${param.status == 'PENDING' ? '#fff' : '#3d2817'};background:${param.status == 'PENDING' ? '#b08968' : '#fff'};">⏳ Chờ xác nhận (${cntPending})</a>
					<a href="${ctx}/my-orders?status=CONFIRMED" class="bc-chip" style="padding:6px 14px;border-radius:999px;border:1px solid #d4a373;text-decoration:none;font-size:13px;font-weight:600;color:${param.status == 'CONFIRMED' ? '#fff' : '#3d2817'};background:${param.status == 'CONFIRMED' ? '#b08968' : '#fff'};">✅ Đã xác nhận (${cntConfirmed})</a>
					<a href="${ctx}/my-orders?status=SHIPPING" class="bc-chip" style="padding:6px 14px;border-radius:999px;border:1px solid #d4a373;text-decoration:none;font-size:13px;font-weight:600;color:${param.status == 'SHIPPING' ? '#fff' : '#3d2817'};background:${param.status == 'SHIPPING' ? '#b08968' : '#fff'};">🚚 Đang giao (${cntShipping})</a>
					<a href="${ctx}/my-orders?status=FINISH" class="bc-chip" style="padding:6px 14px;border-radius:999px;border:1px solid #d4a373;text-decoration:none;font-size:13px;font-weight:600;color:${param.status == 'FINISH' ? '#fff' : '#3d2817'};background:${param.status == 'FINISH' ? '#b08968' : '#fff'};">🎉 Hoàn thành (${cntFinish})</a>
					<a href="${ctx}/my-orders?status=CANCELLED" class="bc-chip" style="padding:6px 14px;border-radius:999px;border:1px solid #d4a373;text-decoration:none;font-size:13px;font-weight:600;color:${param.status == 'CANCELLED' ? '#fff' : '#3d2817'};background:${param.status == 'CANCELLED' ? '#b08968' : '#fff'};">❌ Đã hủy (${cntCancelled})</a>
				</div>

				<!-- Danh sach don hang -->
				<div style="display: flex; flex-direction: column; gap: 14px;">
					<c:forEach var="o" items="${myOrders}">
						<c:if test="${empty param.status || param.status == 'ALL' || param.status == o.getOrderStatus()}">
							<div style="background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,.04); border-left: 4px solid #b08968;">
								<div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 12px;">
									<div>
										<div style="font-size: 12px; color: #6c757d; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px;">Mã đơn hàng</div>
										<div style="font-size: 18px; font-weight: 800; color: #3d2817;">#${o.getId()}</div>
										<div style="font-size: 13px; color: #6c757d; margin-top: 4px;">
											<i class="bi bi-calendar3"></i> ${o.getCreatedAt()}
										</div>
									</div>
									<div style="text-align: right;">
										<c:choose>
											<c:when test="${o.getOrderStatus() == 'PENDING'}">
												<span style="display: inline-block; padding: 6px 14px; border-radius: 999px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; background: #fff3cd; color: #856404;">
													⏳ Chờ xác nhận
												</span>
											</c:when>
											<c:when test="${o.getOrderStatus() == 'CONFIRMED'}">
												<span style="display: inline-block; padding: 6px 14px; border-radius: 999px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; background: #cce5ff; color: #004085;">
													✅ Đã xác nhận
												</span>
											</c:when>
											<c:when test="${o.getOrderStatus() == 'SHIPPING'}">
												<span style="display: inline-block; padding: 6px 14px; border-radius: 999px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; background: #cce5ff; color: #004085;">
													🚚 Đang giao
												</span>
											</c:when>
											<c:when test="${o.getOrderStatus() == 'FINISH'}">
												<span style="display: inline-block; padding: 6px 14px; border-radius: 999px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; background: #d4edda; color: #155724;">
													🎉 Hoàn thành
												</span>
											</c:when>
											<c:when test="${o.getOrderStatus() == 'CANCELLED'}">
												<span style="display: inline-block; padding: 6px 14px; border-radius: 999px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; background: #f8d7da; color: #721c24;">
													❌ Đã hủy
												</span>
											</c:when>
										</c:choose>
									</div>
								</div>

								<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 12px; margin-top: 16px; padding-top: 16px; border-top: 1px solid #f0e6d6;">
									<div>
										<div style="font-size: 11px; color: #6c757d; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px;">Người nhận</div>
										<div style="color: #2b2b2b; font-weight: 600;">${o.getReceiverName()}</div>
										<div style="color: #6c757d; font-size: 13px;">${o.getReceiverPhone()}</div>
									</div>
									<div>
										<div style="font-size: 11px; color: #6c757d; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px;">Địa chỉ</div>
										<div style="color: #2b2b2b; font-size: 13px;">${o.getReceiverAddress()}</div>
									</div>
									<div>
										<div style="font-size: 11px; color: #6c757d; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px;">Thanh toán</div>
										<div style="color: #2b2b2b; font-weight: 600;">${o.getPaymentMethod()}</div>
									</div>
									<div style="text-align: right;">
										<div style="font-size: 11px; color: #6c757d; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px;">Tổng tiền</div>
										<div style="color: #e63946; font-size: 20px; font-weight: 800;">
											<fmt:formatNumber value="${o.getTotalAmount()}" pattern="#,###"/>₫
										</div>
									</div>
								</div>

								<div style="margin-top: 16px; padding-top: 16px; border-top: 1px solid #f0e6d6; display: flex; justify-content: flex-end; gap: 10px;">
									<a href="${ctx}/my-orders?id=${o.getId()}" style="padding: 8px 18px; background: #b08968; color: #fff; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 14px;">
										<i class="bi bi-eye"></i> Xem chi tiết
									</a>
								</div>
							</div>
						</c:if>
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
</div>
