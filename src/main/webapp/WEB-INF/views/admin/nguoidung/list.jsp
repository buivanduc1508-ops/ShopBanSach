<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="page-heading">
	<h3>Quản lý người dùng</h3>
	<p class="text-muted">Khóa/mở tài khoản và phân quyền</p>
</div>

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
							<tr>
								<td><strong>#${u.getId()}</strong></td>
								<td><strong>${u.getFullName()}</strong></td>
								<td>${u.getEmail()}</td>
								<td>${u.getPhone()}</td>
								<td style="max-width:200px;font-size:12px;">${u.getAddress()}</td>
								<td>
									<form action="${ctx}/admin/nguoidung" method="post" style="display:inline-flex;gap:4px;">
										<input type="hidden" name="action" value="updateRole"/>
										<input type="hidden" name="id" value="${u.getId()}"/>
										<select name="role" style="padding:6px 8px;font-size:12px;">
											<option value="CUSTOMER" ${u.getRole() == 'CUSTOMER' ? 'selected' : ''}>CUSTOMER</option>
											<option value="ADMIN" ${u.getRole() == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
										</select>
										<button type="submit" class="adm-btn adm-btn-primary"><i class="bi bi-check"></i></button>
									</form>
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
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:otherwise>
		</c:choose>
	</div>
</div>
