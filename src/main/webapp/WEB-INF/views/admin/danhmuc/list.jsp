<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="page-heading">
	<h3>Quản lý danh mục</h3>
	<p class="text-muted">Thêm, sửa, xóa các danh mục sách</p>
</div>

<div class="page-content" style="padding: 24px 28px;">
	<div class="adm-table-card">
		<div class="adm-card-header">
			<h4>📚 ${listDM.size()} danh mục</h4>
			<button class="adm-btn adm-btn-success" onclick="openForm()">
				<i class="bi bi-plus-circle"></i> Thêm danh mục
			</button>
		</div>

		<c:choose>
			<c:when test="${empty listDM}">
				<div class="adm-empty">
					<i class="bi bi-folder" style="font-size:64px;color:#d4a373;"></i>
					<h3>Chưa có danh mục nào</h3>
				</div>
			</c:when>
			<c:otherwise>
				<table class="adm-table">
					<thead>
						<tr>
							<th>ID</th>
							<th>Tên danh mục</th>
							<th>Mô tả</th>
							<th>Trạng thái</th>
							<th>Ngày tạo</th>
							<th>Hành động</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="dm" items="${listDM}">
							<tr>
								<td><strong>#${dm.getId()}</strong></td>
								<td><strong>${dm.getName()}</strong></td>
								<td>${dm.getDescription()}</td>
								<td>
									<c:choose>
										<c:when test="${dm.getStatus() == 'ACTIVE'}">
											<span class="adm-badge adm-badge-success">Hoạt động</span>
										</c:when>
										<c:otherwise>
											<span class="adm-badge adm-badge-secondary">Ngừng</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td><small>${dm.getCreateAt()}</small></td>
								<td>
									<button class="adm-btn adm-btn-light"
										onclick='openForm(${dm.getId()}, "${dm.getName()}", "${dm.getDescription()}", "${dm.getStatus()}")'>
										<i class="bi bi-pencil"></i> Sửa
									</button>
									<form action="${ctx}/admin/danhmuc" method="post" style="display:inline;"
										onsubmit="return confirm('Xóa danh mục #${dm.getId()}? Nếu còn sản phẩm sẽ không xóa được.');">
										<input type="hidden" name="action" value="delete"/>
										<input type="hidden" name="id" value="${dm.getId()}"/>
										<button type="submit" class="adm-btn adm-btn-danger"><i class="bi bi-trash"></i> Xóa</button>
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

<div id="formModal" class="adm-form-modal">
	<div class="adm-form-box" style="max-width:500px;">
		<h3 id="formTitle">Thêm danh mục</h3>
		<form id="dmForm" action="${ctx}/admin/danhmuc" method="post">
			<input type="hidden" name="action" id="formAction" value="create"/>
			<input type="hidden" name="id" id="dmId"/>

			<div class="adm-fg">
				<label>Tên danh mục *</label>
				<input type="text" name="name" id="dmName" required/>
			</div>
			<div class="adm-fg">
				<label>Mô tả</label>
				<textarea name="description" id="dmDes"></textarea>
			</div>
			<div class="adm-fg">
				<label>Trạng thái</label>
				<select name="status" id="dmStatus">
					<option value="ACTIVE">Hoạt động</option>
					<option value="INACTIVE">Ngừng</option>
				</select>
			</div>
			<div class="adm-form-actions">
				<button type="button" class="adm-btn adm-btn-light" onclick="closeForm()">Hủy</button>
				<button type="submit" class="adm-btn adm-btn-success"><i class="bi bi-check-circle"></i> Lưu</button>
			</div>
		</form>
	</div>
</div>

<script>
function openForm(id, name, des, status) {
	document.getElementById('formModal').classList.add('adm-show');
	if (id) {
		document.getElementById('formTitle').innerText = 'Sửa danh mục #' + id;
		document.getElementById('formAction').value = 'update';
		document.getElementById('dmId').value = id;
		document.getElementById('dmName').value = name || '';
		document.getElementById('dmDes').value = des || '';
		document.getElementById('dmStatus').value = status || 'ACTIVE';
	} else {
		document.getElementById('formTitle').innerText = 'Thêm danh mục';
		document.getElementById('formAction').value = 'create';
		document.getElementById('dmForm').reset();
		document.getElementById('dmStatus').value = 'ACTIVE';
	}
}
function closeForm() {
	document.getElementById('formModal').classList.remove('adm-show');
}
document.getElementById('formModal').addEventListener('click', function(e) {
	if (e.target === this) closeForm();
});
</script>
