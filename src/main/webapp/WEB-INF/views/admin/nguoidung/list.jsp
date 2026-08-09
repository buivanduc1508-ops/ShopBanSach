<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="superAdminEmail" value="buivanduc1508@gmail.com" />

<div class="page-heading">
	<h3>Quản lý người dùng</h3>
	<p class="text-muted">Khóa/mở tài khoản và phân quyền</p>
</div>

<!-- Flash message (sau redirect khi chan thao tac super admin) -->
<c:if test="${not empty sessionScope.flashError}">
	<div style="margin: 0 28px 16px; padding: 12px 16px; background: #f8d7da; color: #721c24; border-left: 4px solid #e63946; border-radius: 8px;">
		<i class="bi bi-exclamation-triangle"></i> ${sessionScope.flashError}
	</div>
	<c:remove var="flashError" scope="session"/>
</c:if>

<div class="page-content" style="padding: 24px 28px;">
	<div class="adm-table-card">
		<div class="adm-card-header">
			<h4>👥 ${listUsers.size()} người dùng</h4>
		</div>

		<c:choose>
			<c:when test="${empty listUsers}">
				<div class="adm-empty">
					<i class="bi bi-people" style="font-size:64px;color:#d4a373;"></i>
					<h3>Chưa có người dùng nào</h3>
				</div>
			</c:when>
			<c:otherwise>
				<table class="adm-table">
					<thead>
						<tr>
							<th>ID</th>
							<th>Họ tên</th>
							<th>Email</th>
							<th>SĐT</th>
							<th>Địa chỉ</th>
							<th>Vai trò</th>
							<th>Trạng thái</th>
							<th>Ngày tạo</th>
							<th>Hành động</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="u" items="${listUsers}">
							<c:set var="isSuper" value="${u.getEmail() == superAdminEmail}" />
							<tr style="${isSuper ? 'background:#fff8e6;' : ''}">
								<td>
									<strong>#${u.getId()}</strong>
									<c:if test="${isSuper}">
										<br><span class="adm-badge" style="background:#ffc107;color:#3d2817;font-size:10px;margin-top:4px;display:inline-block;">
											<i class="bi bi-shield-lock-fill"></i> SUPER ADMIN
										</span>
									</c:if>
								</td>
								<td><strong>${u.getFullName()}</strong></td>
								<td>${u.getEmail()}</td>
								<td>${u.getPhone()}</td>
								<td style="max-width:200px;font-size:12px;">${u.getAddress()}</td>
								<td>
									<c:choose>
										<c:when test="${isSuper}">
											<!-- Super admin: khong cho doi vai tro -->
											<span class="adm-badge" style="background:#ffc107;color:#3d2817;">
												<i class="bi bi-shield-fill-check"></i> ${u.getRole()}
											</span>
											<div style="font-size:11px;color:#856404;margin-top:4px;">
												<i class="bi bi-lock-fill"></i> Đã khóa vai trò
											</div>
										</c:when>
										<c:otherwise>
											<form action="${ctx}/admin/nguoidung" method="post" style="display:inline-flex;gap:4px;">
												<input type="hidden" name="action" value="updateRole"/>
												<input type="hidden" name="id" value="${u.getId()}"/>
												<select name="role" style="padding:6px 8px;font-size:12px;">
													<option value="CUSTOMER" ${u.getRole() == 'CUSTOMER' ? 'selected' : ''}>CUSTOMER</option>
													<option value="ADMIN" ${u.getRole() == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
												</select>
												<button type="submit" class="adm-btn adm-btn-primary"><i class="bi bi-check"></i></button>
											</form>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${u.getStatus() == 'ACTIVE'}">
											<span class="adm-badge adm-badge-success">Hoạt động</span>
										</c:when>
										<c:otherwise>
											<span class="adm-badge adm-badge-danger">Bị khóa</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td><small>${u.getCreatedAt()}</small></td>
								<td>
									<c:choose>
										<c:when test="${isSuper}">
											<!-- Super admin: khong the khoa -->
											<span class="adm-btn adm-btn-light" style="opacity:0.5;cursor:not-allowed;" title="Không thể khóa tài khoản admin tối cao">
												<i class="bi bi-shield-lock"></i> Bảo vệ
											</span>
										</c:when>
										<c:otherwise>
											<form action="${ctx}/admin/nguoidung" method="post" style="display:inline;">
												<input type="hidden" name="action" value="updateStatus"/>
												<input type="hidden" name="id" value="${u.getId()}"/>
												<c:choose>
													<c:when test="${u.getStatus() == 'ACTIVE'}">
														<input type="hidden" name="status" value="LOCKED"/>
														<button type="submit" class="adm-btn adm-btn-danger"
															onclick="return confirm('Khóa tài khoản ${u.getEmail()}?');">
															<i class="bi bi-lock"></i> Khóa
														</button>
													</c:when>
													<c:otherwise>
														<input type="hidden" name="status" value="ACTIVE"/>
														<button type="submit" class="adm-btn adm-btn-success">
															<i class="bi bi-unlock"></i> Mở khóa
														</button>
													</c:otherwise>
												</c:choose>
											</form>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:otherwise>
		</c:choose>
	</div>
</div>
