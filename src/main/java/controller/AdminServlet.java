package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Trang quản trị");
        request.setAttribute("activePage", "dashboard");
        request.setAttribute("contentPage", "/WEB-INF/views/client/pages/danhmuc.jsp");

        request.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp")
                .forward(request, response);
    }
}
