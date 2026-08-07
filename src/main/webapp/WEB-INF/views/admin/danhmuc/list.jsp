<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="main">
	<header class="mb-3">
		<a href="#" class="burger-btn d-block d-xl-none"> <i
			class="bi bi-justify fs-3"></i>
		</a>
	</header>

	<div class="page-heading">
		<div class="page-title">
			<div class="row">
				<div class="col-12 col-md-6 order-md-1 order-last">
					<h3>DataTable</h3>
					<p class="text-subtitle text-muted">For user to check they list</p>
				</div>
				<div class="col-12 col-md-6 order-md-2 order-first">
					<nav aria-label="breadcrumb"
						class="breadcrumb-header float-start float-lg-end">
						<ol class="breadcrumb">
							<li class="breadcrumb-item"><a href="index.html">Dashboard</a></li>
							<li class="breadcrumb-item active" aria-current="page">DataTable</li>
						</ol>
					</nav>
				</div>
			</div>
		</div>
		<section class="section">
			<div class="card">
				<div class="card-header">Simple Datatable</div>
				<div class="card-body">
					<table class="table table-striped" id="table1">
						<thead>
							<tr>
								<th>ID</th>
								<th>Tên DM</th>
								<th>Mô tả</th>
								<th>Trạng thái</th>
								<th>Ngày tạo</th>
								<th>Hành động</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${listDM}">
								<tr>
									<td>${item.getId() }</td>
									<td>${item.getName() }</td>
									<td>${item.getDescription() }</td>
									<td>${item.getStatus() }</td>
									<td>${item.getCreateAt() }</td>
									<td>Sửa, xóa</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>

		</section>
	</div>