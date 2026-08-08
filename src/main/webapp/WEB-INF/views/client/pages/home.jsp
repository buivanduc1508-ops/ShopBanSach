<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- HERO Banner -->
<section class="bc-hero">
	<div class="bc-container">
		<div class="bc-hero-grid">
			<div class="bc-hero-text">
				<span class="bc-hero-eyebrow"><i class="bi bi-bookmark-heart-fill"></i> MỌT Bookstore</span>
				<h1>
					NIỀM VUI<br>ĐỌC SÁCH<br>CHILL HẾT MÌNH
				</h1>
				<p>
					Khám phá hàng trăm đầu sách hay về triết học, tâm lý, văn học và kỹ năng sống.
					Giao hàng nhanh toàn quốc, thanh toán khi nhận hàng (COD).
				</p>
				<div class="bc-hero-actions">
					<a href="${ctx}/shop" class="bc-btn bc-btn-primary bc-btn-lg"><i class="bi bi-bag-fill"></i> Mua sắm ngay</a>
					<a href="${ctx}/shop?sort=name" class="bc-btn bc-btn-ghost bc-btn-lg">Tất cả sách</a>
				</div>
			</div>
			<div class="bc-hero-art">
				<img src="${ctx}/assets/img/hero-books.png" alt="Đọc sách chill"
					class="bc-hero-art-img"
					onerror="this.onerror=null;this.style.display='none';">
			</div>
		</div>
	</div>
</section>

<!-- CATEGORIES strip -->
<section class="bc-section">
	<div class="bc-container">
		<div class="bc-section-head">
			<span class="bc-eyebrow">Danh mục</span>
			<h2>Sách theo danh mục</h2>
			<p>Tìm sách theo thể loại yêu thích của bạn</p>
		</div>

		<div class="bc-cat-strip">
			<c:forEach var="dm" items="${listDM}">
				<a href="${ctx}/shop?category=${dm.getId()}" class="bc-cat-card">
					<div class="bc-cat-icon">
						<c:choose>
							<c:when test="${dm.getId() == 1}"><i class="bi bi-mortarboard-fill"></i></c:when>
							<c:when test="${dm.getId() == 2}"><i class="bi bi-book-half"></i></c:when>
							<c:when test="${dm.getId() == 3}"><i class="bi bi-feather"></i></c:when>
							<c:when test="${dm.getId() == 4}"><i class="bi bi-lightbulb-fill"></i></c:when>
							<c:otherwise><i class="bi bi-book"></i></c:otherwise>
						</c:choose>
					</div>
					<h3>${dm.getName()}</h3>
					<span class="bc-cat-meta">
						<c:choose>
							<c:when test="${dm.getId() == 1}">Giáo trình • Bài tập</c:when>
							<c:when test="${dm.getId() == 2}">Manga • Comic</c:when>
							<c:when test="${dm.getId() == 3}">Tiểu thuyết • Truyện ngắn</c:when>
							<c:when test="${dm.getId() == 4}">Kỹ năng • Tư duy</c:when>
							<c:otherwise>Sách hay</c:otherwise>
						</c:choose>
					</span>
				</a>
			</c:forEach>
		</div>
	</div>
</section>

<!-- SACH NOI BAT (Best sellers) -->
<c:if test="${not empty listSP}">
	<section class="bc-section bc-section-alt">
		<div class="bc-container">
			<div class="bc-section-head-flex">
				<div class="bc-head-text">
					<span class="bc-eyebrow"><i class="bi bi-fire"></i> Nổi bật</span>
					<h2><i class="bi bi-book-half"></i> Sách nổi bật</h2>
					<p>Những cuốn sách được yêu thích nhất</p>
				</div>
				<a href="${ctx}/shop" class="bc-link">Xem tất cả →</a>
			</div>

			<div class="bc-product-grid">
<c:forEach var="sp" items="${listSP}" end="7">
				<div class="bc-product-card">
					<a href="${ctx}/product-detail?id=${sp.getId()}" class="bc-product-link">
						<div class="bc-product-thumb">
							<c:if test="${sp.hasSale()}">
								<span class="bc-product-badge">-${sp.getDiscountPercent()}%</span>
							</c:if>
							<c:if test="${sp.getQuantity() <= 0}">
								<span class="bc-product-badge" style="background:#6c757d;">Hết hàng</span>
							</c:if>
							<img src="${sp.getImage()}" alt="${sp.getName()}"
								onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/placeholder-book.jsp?w=400&h=520&bg=b08968&text=BookChill';">
						</a>
						<div class="bc-product-quick">
							<c:choose>
							<c:when test="${sp.getQuantity() > 0}">
								<form action="${ctx}/cart" method="get" style="display:inline;margin:0;">
									<input type="hidden" name="action" value="add">
									<input type="hidden" name="productId" value="${sp.getId()}">
									<input type="hidden" name="quantity" value="1">
									<button type="submit" class="bc-quick-btn">
										<i class="bi bi-cart-plus"></i> Thêm vào giỏ
									</button>
								</form>
							</c:when>
							<c:otherwise>
								<button type="button" class="bc-quick-btn" disabled style="opacity:.6;cursor:not-allowed;"><i class="bi bi-x-circle"></i> Hết hàng</button>
							</c:otherwise>
							</c:choose>
						</div>
					</div>
					<div class="bc-product-info">
						<div class="bc-product-cat">
							<c:choose>
								<c:when test="${sp.getCategoryId() == 1}">Sách giáo khoa</c:when>
								<c:when test="${sp.getCategoryId() == 2}">Truyện tranh</c:when>
								<c:when test="${sp.getCategoryId() == 3}">Văn học</c:when>
								<c:otherwise>Kỹ năng</c:otherwise>
							</c:choose>
						</div>
<h3 class="bc-product-name"><a href="${ctx}/product-detail?id=${sp.getId()}">${sp.getName()}</a></h3>
					<div class="bc-product-author">
						<i class="bi bi-pen"></i> ${not empty sp.getAuthor() ? sp.getAuthor() : 'Nhiều tác giả'}
					</div>
							<div class="bc-product-foot">
								<span class="bc-price ${sp.hasSale() ? 'bc-price-sale' : ''}">
									<fmt:formatNumber value="${sp.getDisplayPrice()}" pattern="#,###" />₫
								</span>
								<c:if test="${sp.hasSale()}">
									<span class="bc-price-original">
										<fmt:formatNumber value="${sp.getPrice()}" pattern="#,###" />₫
									</span>
								</c:if>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</section>
</c:if>

<!-- ON SALE -->
<c:if test="${not empty listOnSale}">
	<section class="bc-section">
		<div class="bc-container">
			<div class="bc-section-head">
				<span class="bc-eyebrow"><i class="bi bi-fire"></i> Khuyến mãi</span>
				<h2><i class="bi bi-tag-fill"></i> Sách đang giảm giá</h2>
				<p>Những cuốn sách hay đang có ưu đãi hấp dẫn</p>
			</div>
			<div class="bc-product-grid">
<c:forEach var="sp" items="${listOnSale}">
				<div class="bc-product-card">
					<a href="${ctx}/product-detail?id=${sp.getId()}" class="bc-product-link">
						<div class="bc-product-thumb">
							<span class="bc-product-badge">-${sp.getDiscountPercent()}%</span>
							<img src="${sp.getImage()}" alt="${sp.getName()}"
								onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/placeholder-book.jsp?w=400&h=520&bg=e63946&text=SALE';">
						</a>
						<div class="bc-product-quick">
							<form action="${ctx}/cart" method="get" style="display:inline;margin:0;">
								<input type="hidden" name="action" value="add">
								<input type="hidden" name="productId" value="${sp.getId()}">
								<input type="hidden" name="quantity" value="1">
								<button type="submit" class="bc-quick-btn">
									<i class="bi bi-cart-plus"></i> Thêm vào giỏ
								</button>
							</form>
						</div>
					</div>
					<div class="bc-product-info">
						<div class="bc-product-cat">
							<c:choose>
								<c:when test="${sp.getCategoryId() == 1}">Sách giáo khoa</c:when>
								<c:when test="${sp.getCategoryId() == 2}">Truyện tranh</c:when>
								<c:when test="${sp.getCategoryId() == 3}">Văn học</c:when>
								<c:otherwise>Kỹ năng</c:otherwise>
							</c:choose>
						</div>
						<h3 class="bc-product-name"><a href="${ctx}/product-detail?id=${sp.getId()}">${sp.getName()}</a></h3>
					<div class="bc-product-author">
						<i class="bi bi-pen"></i> ${not empty sp.getAuthor() ? sp.getAuthor() : 'Nhiều tác giả'}
					</div>
					<div class="bc-product-foot">
						<span class="bc-price bc-price-sale">
							<fmt:formatNumber value="${sp.getDisplayPrice()}" pattern="#,###" />₫
						</span>
						<span class="bc-price-original">
							<fmt:formatNumber value="${sp.getPrice()}" pattern="#,###" />₫
						</span>
					</div>
				</div>
			</div>
		</c:forEach>
			</div>
		</div>
	</section>
</c:if>

<!-- CTA -->
<section class="bc-cta">
	<div class="bc-container">
		<h2><i class="bi bi-envelope-paper-heart-fill"></i> Đăng ký nhận bản tin</h2>
		<p>Để lại email để nhận ngay thông tin sách mới và ưu đãi hấp dẫn.</p>
		<form class="bc-cta-form" onsubmit="event.preventDefault();alert('Cảm ơn bạn đã đăng ký!');">
			<input type="email" placeholder="Email của bạn" required>
			<button type="submit"><i class="bi bi-send-fill"></i> Đăng ký</button>
		</form>
	</div>
</section>