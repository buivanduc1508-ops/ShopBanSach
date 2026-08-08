package controller.client;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import dao.DanhMucDao;
import dao.SanPhamDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DanhMucModel;
import model.SanPhamModel;

@WebServlet("/shop")
public class ShopServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private SanPhamDao spDao = new SanPhamDao();
	private DanhMucDao dmDao = new DanhMucDao();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<SanPhamModel> all = spDao.getAll();
		List<DanhMucModel> categories = dmDao.getAll();

		String catParam = request.getParameter("category");
		String sortParam = request.getParameter("sort");

		List<SanPhamModel> filtered = all;
		Integer activeCat = null;

		if (catParam != null && !catParam.isEmpty()) {
			try {
				activeCat = Integer.parseInt(catParam);
				final int catId = activeCat;
				filtered = all.stream()
					.filter(s -> s.getCategoryId() == catId)
					.collect(Collectors.toList());
			} catch (NumberFormatException ignored) {}
		}

		if ("priceAsc".equals(sortParam)) {
			filtered = filtered.stream()
				.sorted((a, b) -> Float.compare(a.getDisplayPrice(), b.getDisplayPrice()))
				.collect(Collectors.toList());
		} else if ("priceDesc".equals(sortParam)) {
			filtered = filtered.stream()
				.sorted((a, b) -> Float.compare(b.getDisplayPrice(), a.getDisplayPrice()))
				.collect(Collectors.toList());
		} else if ("name".equals(sortParam)) {
			filtered = filtered.stream()
				.sorted((a, b) -> a.getName().compareToIgnoreCase(b.getName()))
				.collect(Collectors.toList());
		}

		System.out.println("[ShopServlet] All=" + all.size()
			+ " | Filtered=" + filtered.size()
			+ " | Cat=" + activeCat + " | Sort=" + sortParam);

		request.setAttribute("listSP", filtered);
		request.setAttribute("listDM", categories);
		request.setAttribute("activeCat", activeCat);
		request.setAttribute("sort", sortParam);
		request.setAttribute("pageTitle", "Tat ca san pham - BookChill");
		request.setAttribute("activePage", "shop");
		request.setAttribute("contentPage", "/WEB-INF/views/client/pages/shop.jsp");
		request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp")
			.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}