package controller;

import java.io.IOException;

import dao.DanhMucDao;
import dao.InvoiceDao;
import dao.SanPhamDao;
import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Router chinh cho trang admin. /admin             -> dashboard
 * /admin?page=sanpham     -> quan ly san pham
 * /admin?page=danhmuc     -> quan ly danh muc
 * /admin?page=donhang     -> quan ly don hang
 * /admin?page=nguoidung   -> quan ly nguoi dung
 */
@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private SanPhamDao spDao = new SanPhamDao();
	private DanhMucDao dmDao = new DanhMucDao();
	private InvoiceDao invDao = new InvoiceDao();
	private UserDao userDao = new UserDao();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String page = request.getParameter("page");
		if (page == null || page.isEmpty()) page = "dashboard";

		// --- Dashboard stats ---
		int totalSP = spDao.countAll();
		int totalDM = dmDao.getAll().size();
		int totalHD = invDao.countAll();
		int hdPending = invDao.countByStatus("PENDING");
		int hdConfirmed = invDao.countByStatus("CONFIRMED");
		int hdShipping = invDao.countByStatus("SHIPPING");
		int hdFinish = invDao.countByStatus("FINISH");
		int hdCancelled = invDao.countByStatus("CANCELLED");
		double revenue = invDao.sumRevenue();
		int totalUsers = userDao.countAll();
		int lowStock = spDao.countLowStock(5);

		request.setAttribute("totalSP", totalSP);
		request.setAttribute("totalDM", totalDM);
		request.setAttribute("totalHD", totalHD);
		request.setAttribute("hdPending", hdPending);
		request.setAttribute("hdConfirmed", hdConfirmed);
		request.setAttribute("hdShipping", hdShipping);
		request.setAttribute("hdFinish", hdFinish);
		request.setAttribute("hdCancelled", hdCancelled);
		request.setAttribute("revenue", revenue);
		request.setAttribute("totalUsers", totalUsers);
		request.setAttribute("lowStock", lowStock);
		request.setAttribute("activeAdminPage", page);

		// Dashboard data (cho ca dashboard va cac page khac cung co the su dung)
		double[] revenue7 = invDao.revenueLast7Days();
		List<Object[]> topProds = invDao.topProducts(5);
		request.setAttribute("revenue7", revenue7);
		request.setAttribute("topProducts", topProds);

		switch (page) {
			case "danhmuc":
				request.setAttribute("pageTitle", "Quan ly danh muc");
				request.setAttribute("contentPage", "/WEB-INF/views/admin/danhmuc/list.jsp");
				request.setAttribute("listDM", dmDao.getAll());
				break;
			case "sanpham":
				request.setAttribute("pageTitle", "Quan ly san pham");
				String keyword = request.getParameter("keyword");
				String catRaw = request.getParameter("categoryId");
				String pageRaw = request.getParameter("p");
				Integer categoryId = null;
				try { if (catRaw != null && !catRaw.isEmpty()) categoryId = Integer.parseInt(catRaw); } catch (Exception ex) {}
				int page = 1;
				try { if (pageRaw != null && !pageRaw.isEmpty()) page = Math.max(1, Integer.parseInt(pageRaw)); } catch (Exception ex) {}
				final int PAGE_SIZE = 15;
				int totalSP = spDao.countFilter(keyword, categoryId);
				int totalPages = (int) Math.ceil(totalSP / (double) PAGE_SIZE);
				if (page > totalPages && totalPages > 0) page = totalPages;
				request.setAttribute("listSP", spDao.filter(keyword, categoryId, page, PAGE_SIZE));
				request.setAttribute("listDM", dmDao.getAll());
				request.setAttribute("keyword", keyword);
				request.setAttribute("filterCatId", categoryId);
				request.setAttribute("currentPage", page);
				request.setAttribute("totalPages", totalPages);
				request.setAttribute("contentPage", "/WEB-INF/views/admin/sanpham/list.jsp");
				break;
			case "donhang":
				request.setAttribute("pageTitle", "Quan ly don hang");
				String status = request.getParameter("status");
				String keyword = request.getParameter("keyword");
				request.setAttribute("filterStatus", (status == null || status.isEmpty()) ? "ALL" : status);
				request.setAttribute("keyword", keyword);
				request.setAttribute("listHD", invDao.filter(status, keyword));
				request.setAttribute("contentPage", "/WEB-INF/views/admin/donhang/list.jsp");
				break;
			case "nguoidung":
				request.setAttribute("pageTitle", "Quan ly nguoi dung");
				request.setAttribute("listUsers", userDao.getAll());
				request.setAttribute("contentPage", "/WEB-INF/views/admin/nguoidung/list.jsp");
				break;
			default: // dashboard
				request.setAttribute("pageTitle", "Tong quan");
				request.setAttribute("contentPage", "/WEB-INF/views/admin/dashboard/dashboard.jsp");
				break;
		}

		request.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp")
				.forward(request, response);
	}
}
