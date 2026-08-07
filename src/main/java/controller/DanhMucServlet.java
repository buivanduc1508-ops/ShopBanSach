package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import dao.DanhMucDao;

/**
 * Servlet implementation class DanhMucServlet
 */
@WebServlet("/admin/danhmuc")
public class DanhMucServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private DanhMucDao dmDao = new DanhMucDao();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DanhMucServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("contentPage", "/WEB-INF/views/admin/danhmuc/list.jsp");
        request.setAttribute("listDM", dmDao.getAll());
        request.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp")
                .forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
