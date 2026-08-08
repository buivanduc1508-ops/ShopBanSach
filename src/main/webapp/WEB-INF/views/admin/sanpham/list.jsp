<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="page-heading">
	<h3>Quản lý sản phẩm</h3>
	<p class="text-muted">Danh sách tất cả sách trong cửa hàng</p>
</div>

<div class="page-content" style="padding: 24px 28px;">
	<div class="adm-table-card">
		<div class="adm-card-header">
			<h4>📚 ${listSP.size()} sản phẩm <small class="text-muted">(Trang ${currentPage}/${totalPages}, tổng ${totalSP * totalPages > 0 ? totalSP : listSP.size()})</small></h4>
			<div style="display:flex;gap:10px;align-items:center;">
				<form action="${ctx}/admin?page=sanpham" method="get" class="adm-search-form">
					<input type="hidden" name="page" value="sanpham"/>
					<c:if test="${not empty filterCatId}">
						<input type="hidden" name="categoryId" value="${filterCatId}"/>
					</c:if>
					<input type="text" name="keyword" placeholder="Tìm tên sách, tác giả..." value="${keyword}"/>
					<button type="submit" class="adm-btn adm-btn-primary"><i class="bi bi-search"></i></button>
				</form>
				<form action="${ctx}/admin?page=sanpham" method="get" style="display:flex;gap:6px;">
					<input type="hidden" name="page" value="sanpham"/>
					<c:if test="${not empty keyword}">
						<input type="hidden" name="keyword" value="${keyword}"/>
					</c:if>
					<select name="categoryId" onchange="this.form.submit()" style="padding:8px 10px;border:1px solid #d4a373;border-radius:6px;font-size:13px;background:#fff;">
						<option value="0">📂 Tất cả danh mục</option>
						<c:forEach var="dm" items="${listDM}">
							<option value="${dm.getId()}" ${filterCatId == dm.getId() ? 'selected' : ''}>${dm.getName()}</option>
						</c:forEach>
					</select>
				</form>
				<c:if test="${not empty keyword or not empty filterCatId}">
					<a href="${ctx}/admin?page=sanpham" class="adm-btn adm-btn-light" title="Xóa lọc"><i class="bi bi-x-circle"></i></a>
				</c:if>
				<button class="adm-btn adm-btn-success" onclick="openForm()">
					<i class="bi bi-plus-circle"></i> Thêm sản phẩm
				</button>
			</div>
		</div>

		<c:choose>
			<c:when test="${empty listSP}">
				<div class="adm-empty">
					<i class="bi bi-inbox" style="font-size:64px;color:#d4a373;"></i>
					<h3>Chưa có sản phẩm nào</h3>
					<p>Nhấn "Thêm sản phẩm" để tạo mới.</p>
				</div>
			</c:when>
			<c:otherwise>
				<table class="adm-table">
					<thead>
						<tr>
							<th>ID</th>
							<th>Ảnh</th>
							<th>Tên sách</th>
							<th>Danh mục</th>
							<th>Tác giả</th>
							<th>Giá</th>
							<th>Giá sale</th>
							<th>Kho</th>
							<th>Trạng thái</th>
							<th>Hành động</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="sp" items="${listSP}">
							<tr>
								<td><strong>#${sp.getId()}</strong></td>
								<td>
									<img src="${sp.getImage()}" alt="${sp.getName()}" class="adm-img"
										onerror="this.onerror=null;this.src='${ctx}/assets/placeholder-book.jsp?w=80&h=100&bg=b08968&text=Book';">
								</td>
								<td style="max-width:260px;">
									<strong>${sp.getName()}</strong><br>
									<small class="text-muted">${sp.getCreateAt()}</small>
								</td>
								<td>
									<c:choose>
										<c:when test="${sp.getCategoryId() == 1}">Sách GK</c:when>
										<c:when test="${sp.getCategoryId() == 2}">Truyện tranh</c:when>
										<c:when test="${sp.getCategoryId() == 3}">Văn học</c:when>
										<c:when test="${sp.getCategoryId() == 4}">Kỹ năng</c:when>
										<c:otherwise>#${sp.getCategoryId()}</c:otherwise>
									</c:choose>
								</td>
								<td>${not empty sp.getAuthor() ? sp.getAuthor() : '—'}</td>
								<td><strong><fmt:formatNumber value="${sp.getPrice()}" pattern="#,###"/>₫</strong></td>
								<td>
									<c:choose>
										<c:when test="${sp.hasSale()}">
											<span style="color:#e63946;font-weight:700;">
												<fmt:formatNumber value="${sp.getSalePrice()}" pattern="#,###"/>₫
											</span>
											<br><small class="text-muted">-${sp.getDiscountPercent()}%</small>
										</c:when>
										<c:otherwise><span class="text-muted">—</span></c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${sp.getQuantity() <= 0}">
											<span class="adm-badge adm-badge-danger">Hết</span>
										</c:when>
										<c:when test="${sp.getQuantity() <= 5}">
											<span class="adm-badge adm-badge-warning">${sp.getQuantity()}</span>
										</c:when>
										<c:otherwise>
											<span class="adm-badge adm-badge-success">${sp.getQuantity()}</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${sp.getStatus() == 'ACTIVE'}">
											<span class="adm-badge adm-badge-success">Hiển thị</span>
										</c:when>
										<c:otherwise>
											<span class="adm-badge adm-badge-secondary">Ẩn</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<button class="adm-btn adm-btn-light"
										onclick='openForm(${sp.getId()}, ${sp.getCategoryId()}, "${sp.getName()}", "${sp.getDes()}", ${sp.getPrice()}, ${sp.hasSale() ? sp.getSalePrice() : "null"}, "${sp.getAuthor()}", "${sp.getImage()}", ${sp.getQuantity()}, "${sp.getStatus()}")'>
										<i class="bi bi-pencil"></i> Sửa
									</button>
									<form action="${ctx}/admin/sanpham" method="post" style="display:inline;"
										onsubmit="return confirm('Xóa sản phẩm #${sp.getId()}?');">
										<input type="hidden" name="action" value="delete"/>
										<input type="hidden" name="id" value="${sp.getId()}"/>
										<button type="submit" class="adm-btn adm-btn-danger"><i class="bi bi-trash"></i> Xóa</button>
									</form>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<!-- PHAN TRANG -->
				<c:if test="${totalPages > 1}">
					<div style="padding:18px;display:flex;gap:6px;justify-content:center;align-items:center;flex-wrap:wrap;border-top:1px solid #e8e8e8;background:#fafafa;">
						<c:url var="basePageUrl" value="${ctx}/admin">
							<c:param name="page" value="sanpham"/>
							<c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
							<c:if test="${not empty filterCatId}"><c:param name="categoryId" value="${filterCatId}"/></c:if>
						</c:url>
						<c:if test="${currentPage > 1}">
							<a class="adm-btn adm-btn-light" href="${basePageUrl}&p=${currentPage - 1}"><i class="bi bi-chevron-left"></i></a>
						</c:if>
						<c:forEach var="p" begin="1" end="${totalPages}">
							<c:choose>
								<c:when test="${p == currentPage}">
									<span class="adm-btn adm-btn-primary" style="min-width:36px;">${p}</span>
								</c:when>
								<c:otherwise>
									<a class="adm-btn adm-btn-light" href="${basePageUrl}&p=${p}" style="min-width:36px;">${p}</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<c:if test="${currentPage < totalPages}">
							<a class="adm-btn adm-btn-light" href="${basePageUrl}&p=${currentPage + 1}"><i class="bi bi-chevron-right"></i></a>
						</c:if>
					</div>
				</c:if>
			</c:otherwise>
		</c:choose>
	</div>
</div>

<!-- FORM MODAL -->
<div id="formModal" class="adm-form-modal">
	<div class="adm-form-box">
		<h3 id="formTitle">Thêm sản phẩm mới</h3>
		<form id="spForm" action="${ctx}/admin/sanpham" method="post">
			<input type="hidden" name="action" id="formAction" value="create"/>
			<input type="hidden" name="id" id="spId"/>

			<div class="adm-fg">
				<label>Tên sách *</label>
				<input type="text" name="name" id="spName" required/>
			</div>
			<div class="row g-2">
				<div class="col-md-6 adm-fg">
					<label>Danh mục *</label>
					<select name="categoryId" id="spCat" required>
						<c:forEach var="dm" items="${listDM}">
							<option value="${dm.getId()}">${dm.getName()}</option>
						</c:forEach>
					</select>
				</div>
				<div class="col-md-6 adm-fg">
					<label>Tác giả</label>
					<input type="text" name="author" id="spAuthor"/>
				</div>
			</div>
			<div class="adm-fg">
				<label>Mô tả</label>
				<textarea name="description" id="spDes"></textarea>
			</div>
			<div class="row g-2">
				<div class="col-md-4 adm-fg">
					<label>Giá *</label>
					<input type="number" name="price" id="spPrice" min="0" step="1000" required/>
				</div>
				<div class="col-md-4 adm-fg">
					<label>Giá sale</label>
					<input type="number" name="salePrice" id="spSale" min="0" step="1000"/>
				</div>
				<div class="col-md-4 adm-fg">
					<label>Số lượng kho *</label>
					<input type="number" name="quantity" id="spQty" min="0" required/>
				</div>
			</div>

			<!-- ===== PHẦN ẢNH BÌA - Chỉ input URL + Upload file ===== -->
			<div class="adm-fg">
				<label>Ảnh bìa *</label>

				<!-- Nhập URL -->
				<input type="text" name="image" id="spImage" required
					placeholder="https://... hoặc /assets/images/products/abc.jpg"
					style="width:100%;padding:8px 12px;border:1px solid #d4a373;border-radius:8px;font-size:14px;box-sizing:border-box;"/>

				<div style="margin-top:8px;display:flex;gap:8px;flex-wrap:wrap;">
					<button type="button" class="adm-btn adm-btn-light" onclick="document.getElementById('spImageFile').click();">
						<i class="bi bi-upload"></i> Upload ảnh từ máy
					</button>
					<input type="file" id="spImageFile" accept="image/*" style="display:none;" onchange="uploadImageFile(this)"/>
					<span id="uploadStatus" style="font-size:12px;color:#6c757d;align-self:center;"></span>
				</div>

				<!-- Preview -->
				<img id="spImagePreview" src="" alt=""
					style="max-width:120px;max-height:160px;margin-top:10px;display:none;border-radius:6px;border:1px solid #d4a373;"/>

				<small class="text-muted" style="display:block;margin-top:6px;">
					<i class="bi bi-info-circle"></i> Paste URL ảnh trực tiếp (http/https) hoặc upload file từ máy (≤5MB, định dạng: jpg/png/gif/webp)
				</small>
			</div>

			<div class="adm-fg">
				<label>Trạng thái</label>
				<select name="status" id="spStatus">
					<option value="ACTIVE">Hiển thị</option>
					<option value="INACTIVE">Ẩn</option>
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
function openForm(id, catId, name, des, price, sale, author, image, qty, status) {
	document.getElementById('formModal').classList.add('adm-show');
	if (id) {
		document.getElementById('formTitle').innerText = 'Sửa sản phẩm #' + id;
		document.getElementById('formAction').value = 'update';
		document.getElementById('spId').value = id;
		document.getElementById('spCat').value = catId;
		document.getElementById('spName').value = name || '';
		document.getElementById('spDes').value = des || '';
		document.getElementById('spPrice').value = price;
		document.getElementById('spSale').value = (sale === null || sale === 'null' || sale === '') ? '' : sale;
		document.getElementById('spAuthor').value = author || '';
		document.getElementById('spImage').value = image || '';
		document.getElementById('spQty').value = qty;
		document.getElementById('spStatus').value = status || 'ACTIVE';
		// Show preview for existing image
		var prev = document.getElementById('spImagePreview');
		if (image) {
			prev.src = image;
			prev.style.display = 'block';
		} else {
			prev.style.display = 'none';
		}
	} else {
		document.getElementById('formTitle').innerText = 'Thêm sản phẩm mới';
		document.getElementById('formAction').value = 'create';
		document.getElementById('spForm').reset();
		document.getElementById('spStatus').value = 'ACTIVE';
		document.getElementById('spImagePreview').style.display = 'none';
	}
	document.getElementById('uploadStatus').innerText = '';
}
function closeForm() {
	document.getElementById('formModal').classList.remove('adm-show');
}
document.getElementById('formModal').addEventListener('click', function(e) {
	if (e.target === this) closeForm();
});

// ============= UPLOAD ẢNH =============
function uploadImageFile(input) {
	if (!input.files || !input.files[0]) return;
	var file = input.files[0];

	// Validate size client-side
	if (file.size > 5 * 1024 * 1024) {
		alert('File quá lớn (>5MB). Vui lòng chọn ảnh nhỏ hơn.');
		input.value = '';
		return;
	}

	var status = document.getElementById('uploadStatus');
	status.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang upload...';

	var formData = new FormData();
	formData.append('file', file);

	var xhr = new XMLHttpRequest();
	xhr.open('POST', '${ctx}/admin/upload-image', true);
	xhr.onload = function() {
		try {
			var data = JSON.parse(xhr.responseText);
			if (data.error) {
				status.innerHTML = '<span style="color:#e63946;"><i class="bi bi-exclamation-triangle"></i> ' + data.error + '</span>';
				return;
			}
			// Gán URL vào input + hiện preview
			document.getElementById('spImage').value = data.url;
			var prev = document.getElementById('spImagePreview');
			prev.src = data.url;
			prev.style.display = 'block';
			status.innerHTML = '<span style="color:#2d6a4f;"><i class="bi bi-check-circle"></i> Upload thành công!</span>';
		} catch (e) {
			status.innerHTML = '<span style="color:#e63946;">Lỗi: ' + e.message + '</span>';
		}
	};
	xhr.onerror = function() {
		status.innerHTML = '<span style="color:#e63946;">Không kết nối được server.</span>';
	};
	xhr.send(formData);
}

// ============= LIVE PREVIEW KHI NHẬP URL =============
document.getElementById('spImage').addEventListener('input', function() {
	var prev = document.getElementById('spImagePreview');
	var v = this.value.trim();
	if (v && (v.startsWith('http://') || v.startsWith('https://') || v.startsWith('/'))) {
		prev.src = v;
		prev.style.display = 'block';
	} else {
		prev.style.display = 'none';
	}
});
</script>
