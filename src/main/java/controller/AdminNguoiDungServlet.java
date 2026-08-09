package controller;

import java.io.IOException;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * POST /admin/nguoidung?action=updateStatus|updateRole
 */
@WebServlet("/admin/nguoidung")
public class AdminNguoiDungServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDao dao = new UserDao();

	/**
	 * Email cua admin toi cao - khong the doi vai tro, khong the khoa.
	 * Admin goc cua he thong, bao ve khoi cac tac dong admin khac.
	 */
	private static final String SUPER_ADMIN_EMAIL = "buivanduc1508@gmail.com";

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
		int id = Integer.parseInt(req.getParameter("id"));

		// BAO VE super admin: chan moi thao tac doi vai tro / khoa tai khoan
		model.UserModel target = dao.findById(id);
		if (target != null && SUPER_ADMIN_EMAIL.equalsIgnoreCase(target.getEmail())) {
			req.getSession().setAttribute("flashError",
				"Khong the thao tac tren tai khoan admin toi cao (" + SUPER_ADMIN_EMAIL + ").");
			resp.sendRedirect(req.getContextPath() + "/admin?page=nguoidung");
			return;
		}

		if ("updateStatus".equals(action)) {
			dao.updateStatus(id, req.getParameter("status"));
		} else if ("updateRole".equals(action)) {
			dao.updateRole(id, req.getParameter("role"));
		}
		resp.sendRedirect(req.getContextPath() + "/admin?page=nguoidung");
	}
}
