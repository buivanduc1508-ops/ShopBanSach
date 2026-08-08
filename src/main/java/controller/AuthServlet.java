package controller;

import java.io.IOException;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserModel;

@WebServlet(urlPatterns = { "/login", "/logout", "/register" })
public class AuthServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDao userDao = new UserDao();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getServletPath();
		if ("/logout".equals(path)) {
			HttpSession session = request.getSession(false);
			if (session != null) {
				session.invalidate();
			}
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}
		// /login hoặc /register -> hien thi trang auth.jsp voi tab tuong ung
		request.setAttribute("tab", "/register".equals(path) ? "register" : "login");
		request.getRequestDispatcher("/WEB-INF/views/client/pages/auth.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getServletPath();
		if ("/register".equals(path)) {
			doRegister(request, response);
		} else {
			doLogin(request, response);
		}
	}

	private void doLogin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String error = null;
		if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
			error = "Vui lòng nhập đầy đủ email và mật khẩu";
		} else {
			UserModel user = userDao.findByEmail(email.trim());
			if (user == null) {
				error = "Email không tồn tại trong hệ thống";
			} else if (!user.getPasswordHash().equals(password)) {
				error = "Mật khẩu không chính xác";
			} else if (!"ACTIVE".equals(user.getStatus())) {
				error = "Tài khoản đã bị khóa";
			} else {
				HttpSession session = request.getSession(true);
				session.setAttribute("user", user);
				session.setAttribute("userId", user.getId());
				session.setAttribute("fullName", user.getFullName());
				session.setAttribute("role", user.getRole());
				response.sendRedirect(request.getContextPath() + "/home");
				return;
			}
		}
		request.setAttribute("tab", "login");
		request.setAttribute("error", error);
		request.setAttribute("email", email);
		request.getRequestDispatcher("/WEB-INF/views/client/pages/auth.jsp").forward(request, response);
	}

	private void doRegister(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String fullName = request.getParameter("fullName");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String error = null;
		if (fullName == null || fullName.isEmpty() || email == null || email.isEmpty() || password == null
				|| password.isEmpty()) {
			error = "Vui lòng nhập đầy đủ họ tên, email và mật khẩu";
		} else if (userDao.findByEmail(email.trim()) != null) {
			error = "Email này đã được đăng ký rồi";
		} else {
			UserModel u = new UserModel();
			u.setFullName(fullName);
			u.setEmail(email.trim());
			u.setPasswordHash(password);
			u.setPhone(phone);
			u.setAddress(address);
			u.setRole("CUSTOMER");
			u.setStatus("ACTIVE");
			if (userDao.insert(u)) {
				HttpSession session = request.getSession(true);
				UserModel inserted = userDao.findByEmail(email.trim());
				if (inserted != null) {
					session.setAttribute("user", inserted);
					session.setAttribute("userId", inserted.getId());
					session.setAttribute("fullName", inserted.getFullName());
					session.setAttribute("role", inserted.getRole());
				}
				response.sendRedirect(request.getContextPath() + "/home");
				return;
			} else {
				error = "Đăng ký thất bại, vui lòng thử lại sau";
			}
		}
		request.setAttribute("tab", "register");
		request.setAttribute("error", error);
		request.setAttribute("fullName", fullName);
		request.setAttribute("email", email);
		request.setAttribute("phone", phone);
		request.setAttribute("address", address);
		request.getRequestDispatcher("/WEB-INF/views/client/pages/auth.jsp").forward(request, response);
	}
}
