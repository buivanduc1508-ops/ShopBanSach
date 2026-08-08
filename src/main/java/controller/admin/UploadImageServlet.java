package controller.admin;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Upload ảnh bìa sách từ máy tính.
 * POST /admin/upload-image -> tra ve JSON { url: "..." }
 *
 * File được lưu vào:  /assets/images/products/uuid.jpg
 * URL trả về là đường dẫn tương đối để lưu vào DB.
 */
@WebServlet("/admin/upload-image")
@MultipartConfig(
		maxFileSize = 5 * 1024 * 1024,      // 5 MB
		maxRequestSize = 10 * 1024 * 1024    // 10 MB
)
public class UploadImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String UPLOAD_DIR = "assets" + File.separator + "images" + File.separator + "products";

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Check admin
		HttpSession session = request.getSession(false);
		Object role = session == null ? null : session.getAttribute("role");
		Object user = session == null ? null : session.getAttribute("user");
		if (user == null || !"ADMIN".equals(role)) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		response.setContentType("application/json;charset=UTF-8");
		String ctx = request.getContextPath();

		try {
			Part filePart = request.getPart("file");
			if (filePart == null || filePart.getSize() == 0) {
				response.getWriter().print("{\"error\":\"Chưa chọn file\"}");
				return;
			}

			String original = filePart.getSubmittedFileName();
			String ext = "";
			if (original != null && original.contains(".")) {
				ext = original.substring(original.lastIndexOf('.')).toLowerCase();
			}
			// Chỉ cho phép ảnh
			if (!ext.matches("\\.(jpg|jpeg|png|gif|webp)")) {
				response.getWriter().print("{\"error\":\"Chỉ chấp nhận file ảnh (jpg, png, gif, webp)\"}");
				return;
			}

			// Tạo tên file mới tránh trùng
			String newName = UUID.randomUUID().toString().replace("-", "") + ext;

			// Đường dẫn vật lý
			String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
			File dir = new File(uploadPath);
			if (!dir.exists()) dir.mkdirs();

			String fullPath = Paths.get(uploadPath, newName).toString();
			filePart.write(fullPath);

			// URL tương đối để browser load + lưu vào DB
			String publicUrl = "/" + UPLOAD_DIR.replace(File.separator, "/") + "/" + newName;

			response.getWriter().print("{\"url\":\"" + publicUrl + "\",\"name\":\"" + newName + "\"}");
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().print("{\"error\":\"Upload lỗi: " + e.getMessage().replace("\"", "'") + "\"}");
		}
	}
}
