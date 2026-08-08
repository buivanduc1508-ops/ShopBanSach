package controller;

import java.io.IOException;
import java.util.List;

import dao.InvoiceDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItemModel;
import model.InvoiceModel;

/**
 * POST /admin/donhang?action=updateStatus
 * GET  /admin/donhang?view=detail&id=... -> xem chi tiet don hang
 */
@WebServlet("/admin/donhang")
public class AdminDonHangServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private InvoiceDao dao = new InvoiceDao();

	private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		HttpSession session = req.getSession(false);
		Object role = session == null ? null : session.getAttribute("role");
		Object user = session == null ? null : session.getAttribute("user");
		if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return false; }
		if (!"ADMIN".equals(role)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return false; }
		return true;
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!requireAdmin(req, resp)) return;
		String view = req.getParameter("view");
		if ("detail".equals(view)) {
			int id = Integer.parseInt(req.getParameter("id"));
			InvoiceModel inv = dao.findById(id);
			List<CartItemModel> items = dao.getItems(id);
			req.setAttribute("invoice", inv);
			req.setAttribute("invoiceItems", items);
			req.setAttribute("pageTitle", "Chi tiết đơn #" + id);
			req.setAttribute("contentPage", "/WEB-INF/views/admin/donhang/detail.jsp");
			req.setAttribute("activeAdminPage", "donhang");
			req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
			return;
		}
		resp.sendRedirect(req.getContextPath() + "/admin?page=donhang");
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!requireAdmin(req, resp)) return;
		req.setCharacterEncoding("UTF-8");

		String action = req.getParameter("action");
		if ("updateStatus".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			String status = req.getParameter("status");
			dao.updateStatus(id, status);
		}
		resp.sendRedirect(req.getContextPath() + "/admin?page=donhang");
	}
}