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
import model.InvoiceModel;

/**
 * Trang "Don hang cua toi" - user xem cac don hang da dat.
 * GET /my-orders            -> danh sach don hang
 * GET /my-orders?id=X       -> chi tiet don hang
 */
@WebServlet("/my-orders")
public class MyOrdersServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private InvoiceDao invoiceDao = new InvoiceDao();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Bat buoc dang nhap
		HttpSession session = request.getSession(false);
		Object userIdObj = (session == null) ? null : session.getAttribute("userId");
		if (userIdObj == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}
		int userId = (Integer) userIdObj;

		String idParam = request.getParameter("id");
		if (idParam != null && !idParam.isEmpty()) {
			// Xem chi tiet 1 don hang (kiem tra quyen so huu)
			try {
				int id = Integer.parseInt(idParam);
				InvoiceModel inv = invoiceDao.findById(id);
				if (inv == null || inv.getUserId() != userId) {
					// Khong phai don cua user -> ve danh sach
					response.sendRedirect(request.getContextPath() + "/my-orders");
					return;
				}
				request.setAttribute("invoice", inv);
				request.setAttribute("invoiceItems", invoiceDao.getItems(id));
				request.setAttribute("pageTitle", "Đơn hàng #" + id);
				request.setAttribute("activePage", "my-orders");
				request.setAttribute("contentPage", "/WEB-INF/views/client/pages/my-order-detail.jsp");
				request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
				return;
			} catch (NumberFormatException e) {
				response.sendRedirect(request.getContextPath() + "/my-orders");
				return;
			}
		}

		// Danh sach tat ca don hang cua user
		List<InvoiceModel> myOrders = invoiceDao.findByUserId(userId);
		request.setAttribute("myOrders", myOrders);
		request.setAttribute("pageTitle", "Đơn hàng của tôi");
		request.setAttribute("activePage", "my-orders");
		request.setAttribute("contentPage", "/WEB-INF/views/client/pages/my-orders.jsp");
		request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
	}
}
