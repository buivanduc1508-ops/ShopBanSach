package controller;

import java.io.IOException;

import dao.DanhMucDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DanhMucModel;

/**
 * POST /admin/danhmuc?action=create|update|delete
 */
@WebServlet("/admin/danhmuc")
public class AdminDanhMucServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DanhMucDao dao = new DanhMucDao();

	private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		HttpSession session = req.getSession(false);
		Object role = session == null ? null : session.getAttribute("role");
		Object user = session == null ? null : session.getAttribute("user");
		if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return false; }
		if (!"ADMIN".equals(role)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return false; }
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
			resp.sendRedirect(req.getContextPath() + "/admin?page=danhmuc");
			return;
		}

		DanhMucModel dm = new DanhMucModel();
		if ("update".equals(action)) {
			dm.setId(Integer.parseInt(req.getParameter("id")));
		}
		dm.setName(req.getParameter("name"));
		dm.setDescription(req.getParameter("description"));
		dm.setStatus(req.getParameter("status"));

		if ("update".equals(action)) dao.update(dm);
		else dao.insert(dm);

		resp.sendRedirect(req.getContextPath() + "/admin?page=danhmuc");
	}
}
