package controller.client;

import java.io.IOException;

import dao.DanhMucDao;
import dao.SanPhamDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DanhMucModel;
import model.SanPhamModel;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private SanPhamDao spDao = new SanPhamDao();
	private DanhMucDao dmDao = new DanhMucDao();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idRaw = request.getParameter("id");
		int id = 0;
		try { id = Integer.parseInt(idRaw); } catch (Exception ignored) {}

		SanPhamModel sp = id > 0 ? spDao.findById(id) : null;
		if (sp == null) {
			response.sendRedirect(request.getContextPath() + "/shop");
			return;
		}

		// Lay ten danh muc de hien thi
		DanhMucModel dm = dmDao.findById(sp.getCategoryId());
		String categoryName = dm != null ? dm.getName() : "Khác";

		request.setAttribute("sp", sp);
		request.setAttribute("categoryName", categoryName);
		request.setAttribute("listDM", dmDao.getAll());
		request.setAttribute("pageTitle", sp.getName() + " - BookChill");
		request.setAttribute("activePage", "shop");
		request.setAttribute("contentPage", "/WEB-INF/views/client/pages/product-detail.jsp");
		request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
	}
}