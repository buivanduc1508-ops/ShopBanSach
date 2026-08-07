# Base Java 102 Project

Base project Java Web thuần dùng Java 21, Jakarta Servlet 6, JSP/JSTL và Tomcat 10.1. Project **không dùng Maven hoặc Gradle**.

## Cấu trúc chính

```text
src/main/
├── java/
│   ├── controller/             Các servlet xử lý request
│   │   ├── HomeServlet.java
│   │   └── AdminServlet.java
│   ├── model/                  Các model của dự án
│   ├── dao/                    Các class DAO viết JDBC trực tiếp
│   └── utils/
│       └── ConnectDB.java      Kết nối SQL Server
└── webapp/
    ├── assets/
    │   ├── css/
    │   ├── js/
    │   └── images/             Tạo khi thêm ảnh giao diện
    └── WEB-INF/
        ├── lib/                Các JAR JSTL đã được chuẩn bị sẵn
        └── views/
            ├── admin/
            │   ├── layout/     layout.jsp, header.jsp, footer.jsp
            │   └── pages/      Nội dung từng trang admin
            └── client/
                ├── layout/     layout.jsp, header.jsp, footer.jsp
                └── pages/      Nội dung từng trang client
```

Các JSP được đặt trong `WEB-INF` để không thể truy cập trực tiếp từ trình duyệt. Request đi qua servlet rồi mới được forward tới view.

## Import và chạy bằng Eclipse

1. Chọn **File → Import → General → Existing Projects into Workspace**.
2. Chọn thư mục `BaseJav102Project` và hoàn tất import.
3. Bảo đảm Eclipse đang dùng JDK 21.
4. Mở **Project → Properties → Project Facets**:
   - Java: `21`
   - Dynamic Web Module: `6.0`
5. Mở **Project → Properties → Targeted Runtimes** và chọn Tomcat 10.1 trên máy.
6. Chọn **Project → Clean** nếu Eclipse chưa nhận thư viện Servlet.
7. Chọn **Run As → Run on Server**.

Đường dẫn kiểm tra:

- Client: `http://localhost:8080/BaseJav102Project/`
- Admin: `http://localhost:8080/BaseJav102Project/admin`

Nếu project báo lỗi `Unbound classpath container`, bỏ runtime cũ rồi chọn lại Tomcat 10.1 trong **Targeted Runtimes**.

Project giả định sinh viên sử dụng bộ Tomcat do giảng viên cung cấp. JDBC driver và Lombok đã nằm trong `Tomcat/lib`, vì vậy không thêm lại hai thư viện này vào `WEB-INF/lib`.

## Cách thêm một trang client

1. Tạo phần nội dung trang tại `WEB-INF/views/client/pages`. Không thêm lại `html`, `head`, `body`, header hoặc footer.
2. Tạo servlet trực tiếp trong package `controller`.
3. Trong `doGet`, chọn trang nội dung rồi forward tới client layout:

```java
request.setAttribute("pageTitle", "Tiêu đề trang");
request.setAttribute("activePage", "ten-trang");
request.setAttribute(
        "contentPage",
        "/WEB-INF/views/client/pages/ten-trang.jsp");

request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp")
        .forward(request, response);
```

Các JSP layout và bộ Tomcat do giảng viên cung cấp đã cấu hình UTF-8, nên servlet không cần đặt lại encoding.

Với trang admin, đổi đường dẫn thành `admin/pages/...` và `admin/layout/layout.jsp`.

Hai file `layout.jsp` đã bao gồm `header.jsp` và `footer.jsp`. Khi nhận giao diện HTML thật, tách phần dùng chung vào thư mục `layout`, phần thay đổi theo màn hình vào thư mục `pages`.

## DAO và kết nối database

`ConnectDB` viết theo đúng cách JDBC cơ bản. Mở `src/main/java/utils/ConnectDB.java` rồi thay:

- `YOUR_DATABASE`: tên database SQL Server.
- `sa`: tài khoản SQL Server nếu nhóm dùng tài khoản khác.
- `YOUR_PASSWORD`: mật khẩu SQL Server.

JDBC driver đã nằm trong `Tomcat/lib`, không chép thêm driver vào project.

`ExampleModel` và `ExampleDAO` chỉ là code mẫu để sinh viên đổi tên theo đề tài. DAO gọi trực tiếp `ConnectDB.getConnect()`, viết SQL và xử lý `PreparedStatement` trong từng hàm giống project đã học. Không có `BaseDAO`, interface CRUD, generic hoặc kế thừa DAO.

Ví dụ luồng code của một tính năng:

```text
Servlet → DAO → ConnectDB → SQL Server
       ↓
     JSP View
```

## Export file WAR

Trong Eclipse, nhấp chuột phải project rồi chọn **Export → WAR file**. Chọn Tomcat 10.1 làm target runtime và đặt tên file `BaseJav102Project.war`.

## Quy ước làm việc nhóm đề xuất

- Package Java luôn viết thường: `controller`, `model`, `dao`, `utils`.
- Mỗi tính năng nên có servlet, model/DAO nếu có dữ liệu và JSP tương ứng.
- Không đặt câu lệnh SQL trong servlet hoặc JSP.
- Không đặt Java scriptlet (`<% ... %>`) trong view; dùng JSP EL và JSTL.
- Không commit `build` hoặc file cấu hình riêng của máy.
