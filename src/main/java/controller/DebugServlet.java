package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.ConnectDB;

/**
 * Debug servlet - truy cap /debug de kiem tra DB
 */
@WebServlet("/debug")
public class DebugServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/plain; charset=UTF-8");
		PrintWriter out = response.getWriter();

		out.println("=== BOOKCHILL DEBUG ===");
		out.println("ContextPath: " + request.getContextPath());
		out.println("ServerInfo: " + getServletContext().getServerInfo());
		out.println();

		// Check JDBC driver
		out.println("=== JDBC Driver ===");
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			out.println("OK: Microsoft SQL Server JDBC driver da load");
		} catch (ClassNotFoundException e) {
			out.println("FAIL: KHONG TIM THAY driver");
			out.println("  ==> Kiem tra pom.xml co mssql-jdbc?");
			out.println("  ==> Maven Update Project?");
			out.println("  ==> JAR trong target/WEB-INF/lib?");
		}
		out.println();

		out.println("=== SQL Server Connection ===");
		Connection con = ConnectDB.getConnect();
		if (con == null) {
			out.println("FAIL: ConnectDB tra ve null");
			out.println("Xem log Tomcat (Console) de biet chi tiet loi");
			return;
		}
		try (Connection c = con) {
			out.println("OK: Connected to " + c.getMetaData().getURL());
			out.println("Driver: " + c.getMetaData().getDriverName());
			out.println("Database: " + c.getCatalog());

			out.println();
			out.println("=== Tables ===");
			try (Statement st = c.createStatement();
				 ResultSet rs = st.executeQuery("SELECT name FROM sysobjects WHERE xtype='U' ORDER BY name")) {
				while (rs.next()) {
					out.println("  - " + rs.getString(1));
				}
			}

			out.println();
			out.println("=== Row counts ===");
			String[] tabs = {"users", "danh_muc", "san_pham", "gio_hang", "hoa_don", "hoa_don_chi_tiet"};
			for (String t : tabs) {
				try (Statement st = c.createStatement();
					 ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM " + t)) {
					if (rs.next()) out.println("  " + t + ": " + rs.getInt(1));
				} catch (Exception e) {
					out.println("  " + t + ": ERROR " + e.getMessage());
				}
			}

			out.println();
			out.println("=== San Pham ===");
			try (Statement st = c.createStatement();
				 ResultSet rs = st.executeQuery("SELECT id, name, price, sale_price FROM san_pham ORDER BY id")) {
				int i = 0;
				while (rs.next()) {
					i++;
					out.printf("  #%d | %s | price=%s | sale=%s%n",
						rs.getInt(1),
						rs.getString(2),
						rs.getBigDecimal(3),
						rs.getBigDecimal(4));
				}
				out.println("==> Tong: " + i + " san pham");
			}
		} catch (Exception e) {
			out.println("EXCEPTION: " + e.getMessage());
			e.printStackTrace(out);
		}
	}
}
