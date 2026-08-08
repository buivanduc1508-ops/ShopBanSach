package controller;

import java.io.IOException;

import dao.SanPhamDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.SanPhamModel;

/**
 * POST /admin/sanpham?action=create|update|delete
 */
@WebServlet("/admin/sanpham")
public class AdminSanPhamServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private SanPhamDao dao = new SanPhamDao();

	private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		HttpSession session = req.getSession(false);
		Object role = session == null ? null : session.getAttribute("role");
		Object user = session == null ? null : session.getAttribute("user");
		if (user == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return false;
		}
		if (!"ADMIN".equals(role)) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return false;
		}
		return true;
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!requireAdmin(req, resp)) return;
		req.setCharacterEncoding("UTF-8");

		String action = req.getParameter("action");
		if ("delete".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			dao.delete(id);
			resp.sendRedirect(req.getContextPath() + "/admin?page=sanpham");
			return;
		}

		SanPhamModel sp = new SanPhamModel();
		if (action != null && action.equals("update")) {
			sp.setId(Integer.parseInt(req.getParameter("id")));
		}
		sp.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
		sp.setName(req.getParameter("name"));
		sp.setDes(req.getParameter("description"));
		sp.setPrice(Float.parseFloat(req.getParameter("price")));
		String salePrice = req.getParameter("salePrice");
		if (salePrice != null && !salePrice.isEmpty()) {
			sp.setSalePrice(Float.parseFloat(salePrice));
		}
		sp.setAuthor(req.getParameter("author"));
		sp.setImage(req.getParameter("image"));
		sp.setQuantity(Integer.parseInt(req.getParameter("quantity")));
		sp.setStatus(req.getParameter("status"));

		if ("update".equals(action)) {
			dao.update(sp);
		} else {
			dao.insert(sp);
		}
		resp.sendRedirect(req.getContextPath() + "/admin?page=sanpham");
	}
}
