package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.CartDao;
import dao.SanPhamDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItemModel;
import model.SanPhamModel;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CartDao cartDao = new CartDao();
	private SanPhamDao spDao = new SanPhamDao();

	private static final String SESSION_KEY = "cart";

	@SuppressWarnings("unchecked")
	private List<CartItemModel> getSessionCart(HttpSession session) {
		Object o = session.getAttribute(SESSION_KEY);
		if (o instanceof List) {
			return (List<CartItemModel>) o;
		}
		List<CartItemModel> list = new ArrayList<>();
		session.setAttribute(SESSION_KEY, list);
		return list;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Endpoint nhẹ: GET /cart?count=1 -> JSON số sp trong giỏ (để update badge)
		if ("1".equals(request.getParameter("count"))) {
			sendJson(response, "{\"count\":" + getCartCount(request) + "}");
			return;
		}

		// Xu ly action=add/update/remove qua GET (cho de test)
		String action = request.getParameter("action");
		if (action != null && (action.equals("add") || action.equals("update") || action.equals("remove"))) {
			handleAction(request, response);
			return;
		}

		// Neu co action=add ma KHONG co ajax=1 -> fallback form-submit: redirect ve trang truoc
		String fallbackAction = request.getParameter("action");
		if (fallbackAction != null && !"1".equals(request.getParameter("ajax"))) {
			handleAction(request, response);
			return;
		}

		List<CartItemModel> items = resolveCart(request);
		double total = 0;
		for (CartItemModel i : items) {
			total += i.getLineTotal();
		}
		request.setAttribute("cartItems", items);
		request.setAttribute("cartTotal", total);
		request.setAttribute("cartCount", getCartCount(request));
		request.setAttribute("pageTitle", "Giỏ hàng");
		request.setAttribute("activePage", "cart");
		request.setAttribute("contentPage", "/WEB-INF/views/client/pages/cart.jsp");
		request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) action = "add";
		handleAction(request, response);
	}

	// ============== Ham dung chung ==============
	private void handleAction(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String action = request.getParameter("action");
		if (action == null) action = "add";

		String pidRaw = request.getParameter("productId");
		String qtyRaw = request.getParameter("quantity");

		int productId = 0;
		try { productId = Integer.parseInt(pidRaw); } catch (Exception ex) { /* keep 0 */ }

		int quantity = 1;
		try { quantity = Integer.parseInt(qtyRaw); } catch (Exception ex) { /* keep 1 */ }
		if (quantity < 1) quantity = 1;

		if (productId <= 0) {
			sendJson(response, "{\"ok\":false,\"error\":\"productId không hợp lệ\"}");
			return;
		}

		HttpSession session = request.getSession();
		Object userIdObj = session.getAttribute("userId");

		if (userIdObj != null) {
			final int uid = (Integer) userIdObj;
			switch (action) {
				case "add":
					cartDao.addOrUpdate(uid, productId, quantity);
					break;
				case "update":
					cartDao.updateQuantity(uid, productId, quantity);
					break;
				case "remove":
					cartDao.remove(uid, productId);
					break;
			}
		} else {
			List<CartItemModel> cart = getSessionCart(session);
			if ("add".equals(action)) {
				SanPhamModel sp = spDao.findById(productId);
				if (sp == null) {
					sendJson(response, "{\"ok\":false,\"error\":\"Sản phẩm không tồn tại\"}");
					return;
				}
				boolean found = false;
				for (CartItemModel item : cart) {
					if (item.getProductId() == productId) {
						item.setQuantity(item.getQuantity() + quantity);
						found = true;
						break;
					}
				}
				if (!found) {
					CartItemModel item = new CartItemModel();
					item.setProductId(sp.getId());
					item.setName(sp.getName());
					item.setImage(sp.getImage());
					item.setPrice(sp.getPrice());
					item.setDisplayPrice(sp.getDisplayPrice());
					item.setQuantity(quantity);
					cart.add(item);
				}
			} else if ("update".equals(action)) {
				for (CartItemModel item : cart) {
					if (item.getProductId() == productId) {
						item.setQuantity(quantity);
						break;
					}
				}
			} else if ("remove".equals(action)) {
				CartItemModel toRemove = null;
				for (CartItemModel item : cart) {
					if (item.getProductId() == productId) {
						toRemove = item;
						break;
					}
				}
				if (toRemove != null) cart.remove(toRemove);
			}
			session.setAttribute(SESSION_KEY, cart);
		}

		// ====== QUYẾT ĐỊNH RESPONSE ======
		String ajax = request.getParameter("ajax");
		String redirect = request.getParameter("redirect");

		if ("checkout".equals(redirect)) {
			response.sendRedirect(request.getContextPath() + "/checkout");
			return;
		}
		if ("shop".equals(redirect)) {
			response.sendRedirect(request.getContextPath() + "/shop");
			return;
		}
		if ("cart".equals(redirect)) {
			response.sendRedirect(request.getContextPath() + "/cart");
			return;
		}
		if ("back".equals(redirect)) {
			String referer = request.getHeader("Referer");
			if (referer != null && !referer.isEmpty()) {
				response.sendRedirect(referer);
				return;
			}
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		// Phản hồi JSON (luôn luôn khi action add/update/remove qua ajax)
		// Neu KHONG co ajax=1 -> fallback redirect ve trang truoc (form-submit)
		String ajaxFlag = request.getParameter("ajax");
		if (!"1".equals(ajaxFlag)) {
			String referer = request.getHeader("Referer");
			if (referer != null && !referer.isEmpty()) {
				response.sendRedirect(referer);
				return;
			}
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		int totalCount = getCartCount(request);
		sendJson(response, "{\"ok\":true,\"count\":" + totalCount + ",\"name\":\""
				+ escape(lookupName(productId)) + "\"}");
	}

	private int getCartCount(HttpServletRequest request) {
		HttpSession session = request.getSession();
		Object userIdObj = session.getAttribute("userId");
		if (userIdObj != null) {
			List<CartItemModel> list = cartDao.getByUserId((Integer) userIdObj);
			int sum = 0;
			for (CartItemModel i : list) sum += i.getQuantity();
			return sum;
		}
		Object o = session.getAttribute(SESSION_KEY);
		if (o instanceof List) {
			int sum = 0;
			for (CartItemModel i : (List<CartItemModel>) o) sum += i.getQuantity();
			return sum;
		}
		return 0;
	}

	private String lookupName(int productId) {
		SanPhamModel sp = spDao.findById(productId);
		return sp == null ? "" : sp.getName();
	}

	private void sendJson(HttpServletResponse response, String json) throws IOException {
		response.setContentType("application/json;charset=UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().print(json);
	}

	private String escape(String s) {
		if (s == null) return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"")
				.replace("\n", " ").replace("\r", " ");
	}

	private List<CartItemModel> resolveCart(HttpServletRequest request) {
		HttpSession session = request.getSession();
		Object userIdObj = session.getAttribute("userId");
		if (userIdObj != null) {
			int userId = (Integer) userIdObj;
			List<CartItemModel> items = cartDao.getByUserId(userId);
			session.setAttribute(SESSION_KEY, items);
			return items;
		}
		return getSessionCart(session);
	}
}
