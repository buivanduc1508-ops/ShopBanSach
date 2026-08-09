<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="bc-container" style="padding: 40px 20px; min-height: 60vh;">
	<div style="max-width: 900px; margin: 0 auto;">
		<div style="margin-bottom: 20px;">
			<a href="${ctx}/my-orders" style="color: #b08968; text-decoration: none; font-weight: 600; font-size: 14px;">
				<i class="bi bi-arrow-left"></i> Quay lại danh sách đơn hàng
			</a>
		</div>

		<c:if test="${not empty invoice}">
			<!-- Header -->
			<div style="background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,.04); margin-bottom: 16px; border-left: 4px solid #b08968;">
				<div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 12px;">
					<div>
						<div style="font-size: 12px; color: #6c757d; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px;">Chi tiết đơn hàng</div>
						<h2 style="margin: 0; color: #3d2817; font-weight: 800;">#${invoice.getId()}</h2>
						<div style="color: #6c757d; font-size: 14px; margin-top: 4px;">
							<i class="bi bi-calendar3"></i> Đặt ngày ${invoice.getCreatedAt()}
						</div>
					</div>
					<div>
						<c:choose>
							<c:when test="${invoice.getOrderStatus() == 'PENDING'}">
								<span style="display: inline-block; padding: 8px 18px; border-radius: 999px; font-size: 13px; font-weight: 700; text-transform: uppercase; background: #fff3cd; color: #856404;">⏳ Chờ xác nhận</span>
							</c:when>
							<c:when test="${invoice.getOrderStatus() == 'CONFIRMED'}">
								<span style="display: inline-block; padding: 8px 18px; border-radius: 999px; font-size: 13px; font-weight: 700; text-transform: uppercase; background: #cce5ff; color: #004085;">✅ Đã xác nhận</span>
							</c:when>
							<c:when test="${invoice.getOrderStatus() == 'SHIPPING'}">
								<span style="display: inline-block; padding: 8px 18px; border-radius: 999px; font-size: 13px; font-weight: 700; text-transform: uppercase; background: #cce5ff; color: #004085;">🚚 Đang giao</span>
							</c:when>
							<c:when test="${invoice.getOrderStatus() == 'FINISH'}">
								<span style="display: inline-block; padding: 8px 18px; border-radius: 999px; font-size: 13px; font-weight: 700; text-transform: uppercase; background: #d4edda; color: #155724;">🎉 Hoàn thành</span>
							</c:when>
							<c:when test="${invoice.getOrderStatus() == 'CANCELLED'}">
								<span style="display: inline-block; padding: 8px 18px; border-radius: 999px; font-size: 13px; font-weight: 700; text-transform: uppercase; background: #f8d7da; color: #721c24;">❌ Đã hủy</span>
							</c:when>
						</c:choose>
					</div>
				</div>

				<!-- Timeline trang thai -->
				<div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid #f0e6d6;">
					<div style="display: flex; justify-content: space-between; align-items: center; gap: 8px; position: relative;">
						<c:set var="steps" value="${['PENDING','CONFIRMED','SHIPPING','FINISH']}"/>
						<c:set var="currentStep" value="0"/>
						<c:choose>
							<c:when test="${invoice.getOrderStatus() == 'PENDING'}"><c:set var="currentStep" value="0"/></c:when>
							<c:when test="${invoice.getOrderStatus() == 'CONFIRMED'}"><c:set var="currentStep" value="1"/></c:when>
							<c:when test="${invoice.getOrderStatus() == 'SHIPPING'}"><c:set var="currentStep" value="2"/></c:when>
							<c:when test="${invoice.getOrderStatus() == 'FINISH'}"><c:set var="currentStep" value="3"/></c:when>
							<c:when test="${invoice.getOrderStatus() == 'CANCELLED'}"><c:set var="currentStep" value="-1"/></c:when>
						</c:choose>
						<c:set var="isCancel" value="${invoice.getOrderStatus() == 'CANCELLED'}"/>
						<c:forEach var="s" items="${steps}" varStatus="vs">
							<div style="flex: 1; text-align: center; position: relative;">
								<div style="width: 32px; height: 32px; border-radius: 50%; margin: 0 auto 6px; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #fff; background: ${vs.index <= currentStep ? '#b08968' : '#e2e3e5'};">
									<c:choose>
										<c:when test="${vs.index < currentStep}"><i class="bi bi-check-lg"></i></c:when>
										<c:otherwise>${vs.index + 1}</c:otherwise>
									</c:choose>
								</div>
								<div style="font-size: 11px; color: ${vs.index <= currentStep ? '#3d2817' : '#6c757d'}; font-weight: 600;">
									<c:choose>
										<c:when test="${vs.index == 0}">Đặt hàng</c:when>
										<c:when test="${vs.index == 1}">Xác nhận</c:when>
										<c:when test="${vs.index == 2}">Vận chuyển</c:when>
										<c:when test="${vs.index == 3}">Hoàn thành</c:when>
									</c:choose>
								</div>
							</div>
						</c:forEach>
					</div>
					<c:if test="${isCancel}">
						<div style="margin-top: 16px; padding: 10px 14px; background: #f8d7da; color: #721c24; border-radius: 8px; text-align: center;">
							<i class="bi bi-x-circle"></i> Đơn hàng đã bị hủy
						</div>
					</c:if>
				</div>
			</div>

			<!-- Thong tin nguoi nhan -->
			<div style="background: #fff; border-radius: 12px; padding: 20px 24px; box-shadow: 0 2px 8px rgba(0,0,0,.04); margin-bottom: 16px;">
				<h4 style="color: #3d2817; margin: 0 0 14px; font-weight: 700;">
					<i class="bi bi-person-circle" style="color: #b08968;"></i> Thông tin người nhận
				</h4>
				<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 12px;">
					<div>
						<div style="font-size: 11px; color: #6c757d; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px;">Họ tên</div>
						<div style="font-weight: 600; color: #2b2b2b;">${invoice.getReceiverName()}</div>
					</div>
					<div>
						<div style="font-size: 11px; color: #6c757d; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px;">Số điện thoại</div>
						<div style="font-weight: 600; color: #2b2b2b;">${invoice.getReceiverPhone()}</div>
					</div>
					<div style="grid-column: 1 / -1;">
						<div style="font-size: 11px; color: #6c757d; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px;">Địa chỉ giao hàng</div>
						<div style="color: #2b2b2b;">${invoice.getReceiverAddress()}</div>
					</div>
					<c:if test="${not empty invoice.getNote()}">
						<div style="grid-column: 1 / -1;">
							<div style="font-size: 11px; color: #6c757d; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px;">Ghi chú</div>
							<div style="color: #2b2b2b; font-style: italic;">"${invoice.getNote()}"</div>
						</div>
					</c:if>
				</div>
			</div>

			<!-- San pham -->
			<div style="background: #fff; border-radius: 12px; padding: 20px 24px; box-shadow: 0 2px 8px rgba(0,0,0,.04); margin-bottom: 16px;">
				<h4 style="color: #3d2817; margin: 0 0 14px; font-weight: 700;">
					<i class="bi bi-bag-check" style="color: #b08968;"></i> Sản phẩm (${invoiceItems.size()})
				</h4>
				<div style="display: flex; flex-direction: column; gap: 12px;">
					<c:forEach var="item" items="${invoiceItems}">
						<div style="display: flex; gap: 14px; padding: 12px; border: 1px solid #f0e6d6; border-radius: 8px; align-items: center;">
							<img src="${item.getImage()}" alt="${item.getName()}"
								style="width: 60px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #f0e6d6; flex-shrink: 0;"
								onerror="this.onerror=null;this.src='${ctx}/assets/placeholder-book.jsp?w=60&h=80&bg=b08968&text=Book';">
							<div style="flex: 1; min-width: 0;">
								<div style="font-weight: 600; color: #2b2b2b; margin-bottom: 4px;">${item.getName()}</div>
								<div style="font-size: 13px; color: #6c757d;">
									<fmt:formatNumber value="${item.getPrice()}" pattern="#,###"/>₫ × ${item.getQuantity()}
								</div>
							</div>
							<div style="text-align: right; white-space: nowrap;">
								<div style="color: #e63946; font-weight: 700;">
									<fmt:formatNumber value="${item.getPrice() * item.getQuantity()}" pattern="#,###"/>₫
								</div>
							</div>
						</div>
					</c:forEach>
				</div>

				<div style="margin-top: 20px; padding-top: 16px; border-top: 2px dashed #f0e6d6; display: flex; justify-content: space-between; align-items: center;">
					<div>
						<div style="font-size: 13px; color: #6c757d;">Phương thức thanh toán</div>
						<div style="font-weight: 600; color: #3d2817; margin-top: 2px;">${invoice.getPaymentMethod()}</div>
					</div>
					<div style="text-align: right;">
						<div style="font-size: 13px; color: #6c757d;">Tổng cộng</div>
						<div style="font-size: 24px; font-weight: 800; color: #e63946;">
							<fmt:formatNumber value="${invoice.getTotalAmount()}" pattern="#,###"/>₫
						</div>
					</div>
				</div>
			</div>

			<div style="text-align: center; margin-top: 24px;">
				<a href="${ctx}/home" style="color: #b08968; text-decoration: none; font-weight: 600;">
					<i class="bi bi-house"></i> Về trang chủ
				</a>
			</div>
		</c:if>
	</div>
</div>
