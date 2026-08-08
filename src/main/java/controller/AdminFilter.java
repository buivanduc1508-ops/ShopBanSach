package controller;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = { "/admin", "/admin/*" })
public class AdminFilter implements Filter {

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		try {
			HttpServletRequest request = (HttpServletRequest) req;
			HttpServletResponse response = (HttpServletResponse) res;

			HttpSession session = request.getSession(false);
			Object role = (session == null) ? null : session.getAttribute("role");
			Object user = (session == null) ? null : session.getAttribute("user");

			if (user == null) {
				// chua dang nhap -> chuyen ve trang login
				response.sendRedirect(request.getContextPath() + "/login");
				return;
			}
			if (!"ADMIN".equals(role)) {
				// co tai khoan nhung khong phai admin -> 403
				response.sendError(HttpServletResponse.SC_FORBIDDEN,
					"Trang chi danh cho quan tri vien (ADMIN). Tai khoan cua ban khong co quyen truy cap.");
				return;
			}
			chain.doFilter(req, res);
		} catch (Exception e) {
			// Neu filter loi (vd session bi loi), fallback cho qua de trang hien thi
			// error thay vi fail hoan toan
			System.err.println("[AdminFilter] Loi filter, cho request di tiep: " + e.getMessage());
			chain.doFilter(req, res);
		}
	}
}
