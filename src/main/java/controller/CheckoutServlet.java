package controller;

import java.io.IOException;
import java.util.List;

import dao.CartDao;
import dao.InvoiceDao;
import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItemModel;
import model.InvoiceModel;
import model.UserModel;

@WebServlet(urlPatterns = { "/checkout", "/checkout-success" })
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CartDao cartDao = new CartDao();
	private InvoiceDao invoiceDao = new InvoiceDao();
	private UserDao userDao = new UserDao();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getServletPath();
		if ("/checkout-success".equals(path)) {
			request.setAttribute("pageTitle", "Đặt hàng thành công");
			request.setAttribute("activePage", "");
			request.setAttribute("contentPage", "/WEB-INF/views/client/pages/checkout-success.jsp");
			request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
			return;
		}

		HttpSession session = request.getSession();
		Object userIdObj = session.getAttribute("userId");
		if (userIdObj == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}
		List<CartItemModel> items = cartDao.getByUserId((Integer) userIdObj);
		if (items.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/cart");
			return;
		}
		double total = 0;
		for (CartItemModel i : items) {
			total += i.getLineTotal();
		}
		UserModel user = userDao.findById((Integer) userIdObj);

		request.setAttribute("cartItems", items);
		request.setAttribute("cartTotal", total);
		request.setAttribute("currentUser", user);
		request.setAttribute("pageTitle", "Thanh toán");
		request.setAttribute("activePage", "checkout");
		request.setAttribute("contentPage", "/WEB-INF/views/client/pages/checkout.jsp");
		request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		Object userIdObj = session.getAttribute("userId");
		if (userIdObj == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}
		int userId = (Integer) userIdObj;

		List<CartItemModel> items = cartDao.getByUserId(userId);
		if (items.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/cart");
			return;
		}

		String receiverName = request.getParameter("receiverName");
		String receiverPhone = request.getParameter("receiverPhone");
		String receiverAddress = request.getParameter("receiverAddress");
		String note = request.getParameter("note");
		String paymentMethod = request.getParameter("paymentMethod");
		if (paymentMethod == null || paymentMethod.isEmpty())
			paymentMethod = "COD";

		if (receiverName == null || receiverName.isEmpty() || receiverPhone == null || receiverPhone.isEmpty()
				|| receiverAddress == null || receiverAddress.isEmpty()) {
			// Reload checkout with error
			double total = 0;
			for (CartItemModel i : items)
				total += i.getLineTotal();
			request.setAttribute("cartItems", items);
			request.setAttribute("cartTotal", total);
			request.setAttribute("currentUser", userDao.findById(userId));
			request.setAttribute("error", "Vui long nhap day du thong tin nguoi nhan");
			request.setAttribute("pageTitle", "Thanh toán");
			request.setAttribute("activePage", "checkout");
			request.setAttribute("contentPage", "/WEB-INF/views/client/pages/checkout.jsp");
			request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
			return;
		}

		double total = 0;
		for (CartItemModel i : items)
			total += i.getLineTotal();

		InvoiceModel inv = new InvoiceModel();
		inv.setUserId(userId);
		inv.setReceiverName(receiverName);
		inv.setReceiverPhone(receiverPhone);
		inv.setReceiverAddress(receiverAddress);
		inv.setNote(note);
		inv.setTotalAmount(total);
		inv.setPaymentMethod(paymentMethod);
		inv.setOrderStatus("PENDING");

		int invoiceId = invoiceDao.createInvoice(inv, items);
		if (invoiceId > 0) {
			cartDao.clear(userId);
			response.sendRedirect(request.getContextPath() + "/checkout-success?id=" + invoiceId);
		} else {
			double t2 = 0;
			for (CartItemModel i : items)
				t2 += i.getLineTotal();
			request.setAttribute("cartItems", items);
			request.setAttribute("cartTotal", t2);
			request.setAttribute("currentUser", userDao.findById(userId));
			request.setAttribute("error", "Dat hang that bai, vui long thu lai");
			request.setAttribute("pageTitle", "Thanh toán");
			request.setAttribute("activePage", "checkout");
			request.setAttribute("contentPage", "/WEB-INF/views/client/pages/checkout.jsp");
			request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
		}
	}
}