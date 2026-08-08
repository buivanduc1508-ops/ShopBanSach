package controller;

import java.io.IOException;
import java.util.List;

import dao.DanhMucDao;
import dao.SanPhamDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DanhMucModel;
import model.SanPhamModel;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private SanPhamDao spDao = new SanPhamDao();
	private DanhMucDao dmDao = new DanhMucDao();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<SanPhamModel> featured = spDao.getFeatured(12);
		List<SanPhamModel> onSale = spDao.getOnSale();
		List<DanhMucModel> categories = dmDao.getAll();
		int total = spDao.countAll();

		System.out.println("[HomeServlet] Tong SP=" + total
			+ " | Featured=" + featured.size()
			+ " | OnSale=" + onSale.size()
			+ " | Categories=" + categories.size());

		request.setAttribute("pageTitle", "Trang chu - BookChill");
		request.setAttribute("activePage", "home");
		request.setAttribute("listSP", featured);
		request.setAttribute("listOnSale", onSale);
		request.setAttribute("listDM", categories);
		request.setAttribute("contentPage", "/WEB-INF/views/client/pages/home.jsp");

		request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp")
			.forward(request, response);
	}
}