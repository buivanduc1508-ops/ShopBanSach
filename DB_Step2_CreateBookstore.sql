-- =========================================
-- FILE 2/2: Tao DB BOOKSTORE day du
-- Sau khi chay File 1 voi quyen sa
-- File nay co the chay voi user 'duc' (vi da co sysadmin)
-- =========================================

USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'BOOKSTORE')
BEGIN
    ALTER DATABASE BOOKSTORE SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BOOKSTORE;
    PRINT 'Da xoa DB cu BOOKSTORE';
END;
GO

CREATE DATABASE BOOKSTORE;
PRINT 'Da tao DB BOOKSTORE';
GO

USE BOOKSTORE;
GO

-- =========================================
-- 1. BANG USERS
-- =========================================
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20),
    address NVARCHAR(255),
    role NVARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT CK_users_role CHECK (role IN ('ADMIN', 'CUSTOMER')),
    CONSTRAINT CK_users_status CHECK (status IN ('ACTIVE', 'LOCKED'))
);
PRINT '1. Tao bang users';
GO

-- =========================================
-- 2. BANG DANH MUC
-- =========================================
CREATE TABLE danh_muc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT CK_danh_muc_status CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
PRINT '2. Tao bang danh_muc';
GO

-- =========================================
-- 3. BANG SAN PHAM
-- =========================================
CREATE TABLE san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(18,2) NOT NULL,
    sale_price DECIMAL(18,2) NULL,
    author NVARCHAR(150) NULL,
    image NVARCHAR(500),
    quantity INT NOT NULL DEFAULT 0,
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_san_pham_danh_muc FOREIGN KEY (category_id) REFERENCES danh_muc(id),
    CONSTRAINT CK_san_pham_price_non_negative CHECK (price >= 0),
    CONSTRAINT CK_san_pham_quantity_non_negative CHECK (quantity >= 0),
    CONSTRAINT CK_san_pham_status CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
PRINT '3. Tao bang san_pham';
GO

-- =========================================
-- 4. BANG GIO HANG
-- =========================================
CREATE TABLE gio_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    updated_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_gio_hang_users FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT FK_gio_hang_san_pham FOREIGN KEY (product_id) REFERENCES san_pham(id),
    CONSTRAINT CK_gio_hang_quantity_positive CHECK (quantity > 0),
    CONSTRAINT UQ_gio_hang_user_product UNIQUE (user_id, product_id)
);
PRINT '4. Tao bang gio_hang';
GO

-- =========================================
-- 5. BANG HOA DON
-- =========================================
CREATE TABLE hoa_don (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    receiver_name NVARCHAR(100) NOT NULL,
    receiver_phone NVARCHAR(20) NOT NULL,
    receiver_address NVARCHAR(255) NOT NULL,
    note NVARCHAR(500),
    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    payment_method NVARCHAR(20) NOT NULL DEFAULT 'COD',
    order_status NVARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    updated_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_hoa_don_users FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT CK_hoa_don_total_amount CHECK (total_amount >= 0),
    CONSTRAINT CK_hoa_don_payment_method CHECK (payment_method IN ('COD', 'ONLINE')),
    CONSTRAINT CK_hoa_don_order_status CHECK (order_status IN ('PENDING','CONFIRMED','SHIPPING','FINISH','CANCELLED'))
);
PRINT '5. Tao bang hoa_don';
GO

-- =========================================
-- 6. BANG HOA DON CHI TIET
-- =========================================
CREATE TABLE hoa_don_chi_tiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name NVARCHAR(150) NOT NULL,
    product_image NVARCHAR(500),
    price_at_purchase DECIMAL(18,2) NOT NULL,
    quantity INT NOT NULL,
    line_total DECIMAL(18,2) NOT NULL,

    CONSTRAINT FK_hoa_don_chi_tiet_hoa_don FOREIGN KEY (invoice_id) REFERENCES hoa_don(id),
    CONSTRAINT FK_hoa_don_chi_tiet_san_pham FOREIGN KEY (product_id) REFERENCES san_pham(id),
    CONSTRAINT CK_hoa_don_chi_tiet_price_non_negative CHECK (price_at_purchase >= 0),
    CONSTRAINT CK_hoa_don_chi_tiet_quantity_positive CHECK (quantity > 0),
    CONSTRAINT CK_hoa_don_chi_tiet_line_total_non_negative CHECK (line_total >= 0)
);
PRINT '6. Tao bang hoa_don_chi_tiet';
GO

-- =========================================
-- DATA: USERS
-- =========================================
SET IDENTITY_INSERT users ON;
INSERT INTO users(id, full_name, email, password_hash, phone, address, role, status) VALUES
(1, N'Bùi Văn Đức', 'buivanduc1508@gmail.com', '123654', '0904415459', N'Hải Phòng', 'ADMIN', 'ACTIVE'),
(2, N'Nguyễn Danh Nhật Lâm', 'dokhanh020906@gmail.com', '123890', '0386550664', N'Cát Bà, Hải Phòng', 'CUSTOMER', 'ACTIVE'),
(3, N'Trần Thị Phương Nhung', 'phuongnhung14052007@gmail.com', '123789', '0782159754', N'Lê Chân, Hải Phòng', 'CUSTOMER', 'ACTIVE'),
(4, N'Lương Xuân Tiến', 'xuanatien@gmail.com', '123456', '0867054901', N'Hải Phòng', 'CUSTOMER', 'ACTIVE');
SET IDENTITY_INSERT users OFF;
PRINT 'Da them 4 users';
GO

-- =========================================
-- DATA: DANH MUC
-- =========================================
SET IDENTITY_INSERT danh_muc ON;
INSERT INTO danh_muc(id, name, description, status) VALUES
(1, N'Sách Giáo Khoa & Giáo Trình', N'Sách phục vụ học tập, giảng dạy tại các cấp học và đại học', 'ACTIVE'),
(2, N'Truyện Tranh & Manga', N'Truyện tranh giải trí trong và ngoài nước', 'ACTIVE'),
(3, N'Sách Văn Học & Tiểu Thuyết', N'Tác phẩm văn học kinh điển, tiểu thuyết hiện đại', 'ACTIVE'),
(4, N'Sách Kỹ Năng & Phát Triển Bản Thân', N'Sách hướng dẫn kỹ năng sống, tư duy, kinh doanh', 'ACTIVE');
SET IDENTITY_INSERT danh_muc OFF;
PRINT 'Da them 4 danh muc';
GO

-- =========================================
-- DATA: SAN PHAM - 28 sach
-- =========================================
SET IDENTITY_INSERT san_pham ON;
INSERT INTO san_pham(id, category_id, name, description, price, sale_price, author, image, quantity, status) VALUES
-- Category 1: Sach giao khoa (6 sach)
(1, 1, N'Giáo Trình Lập Trình Java Spring Boot', N'Hướng dẫn chi tiết từ cơ bản đến nâng cao về phát triển Web với Spring Boot.', 150000, 127500, N'Phạm Huy Hoàng', 'https://placehold.co/400x520/b08968/ffffff?text=Java+Spring', 15, 'ACTIVE'),
(2, 1, N'Cấu Trúc Dữ Liệu Và Giải Thuật', N'Sách nền tảng cho mọi lập trình viên tư duy thuật toán.', 120000, NULL, N'Nguyễn Văn Linh', 'https://placehold.co/400x520/2d6a4f/ffffff?text=CTDL', 20, 'ACTIVE'),
(3, 1, N'Lập Trình Java Cơ Bản', N'Sách nền tảng Java cho người mới bắt đầu, có bài tập thực hành.', 180000, 153000, N'Phạm Quang Hiển', 'https://placehold.co/400x520/c8a165/ffffff?text=Java+Co+Ban', 30, 'ACTIVE'),
(4, 1, N'Cơ Sở Dữ Liệu Quan Hệ', N'Thiết kế và tối ưu hóa cơ sở dữ liệu MySQL, SQL Server.', 165000, NULL, N'Nguyễn Kim Anh', 'https://placehold.co/400x520/3d5a80/ffffff?text=CSDL', 25, 'ACTIVE'),
(5, 1, N'Giáo Trình Tin Học Văn Phòng', N'Word, Excel, PowerPoint cho người đi làm và sinh viên.', 95000, 76000, N'Trần Văn Tới', 'https://placehold.co/400x520/ddb892/ffffff?text=Tin+Hoc', 40, 'ACTIVE'),
(6, 1, N'Thiết Kế Web Với HTML5 & CSS3', N'Hướng dẫn thiết kế web responsive từ A-Z.', 145000, 116000, N'Hoàng Trung Hiếu', 'https://placehold.co/400x520/6c757d/ffffff?text=HTML+CSS', 35, 'ACTIVE'),

-- Category 2: Truyen tranh (7 sach)
(7, 2, N'Thám Tử Lừng Danh Conan - Tập 100', N'Ấn bản đặc biệt đánh dấu cột mốc tập thứ 100 của bộ truyện huyền thoại.', 30000, NULL, N'Gosho Aoyama', 'https://placehold.co/400x520/1d3557/ffffff?text=Conan', 50, 'ACTIVE'),
(8, 2, N'One Piece - Tập 101', N'Hành trình chinh phục kho báu vĩ đại của băng Mũ Rơm tại Wano Quốc.', 35000, NULL, N'Eiichiro Oda', 'https://placehold.co/400x520/e63946/ffffff?text=One+Piece', 40, 'ACTIVE'),
(9, 2, N'Doraemon - Tập 45', N'Cuộc phiêu lưu của chú mèo máy đến từ tương lai.', 25000, NULL, N'Fujiko F. Fujio', 'https://placehold.co/400x520/00a8e8/ffffff?text=Doraemon', 60, 'ACTIVE'),
(10, 2, N'Shin - Cậu Bé Bút Chì', N'Truyện tranh hài hước về cậu bé Shin và gia đình Nohara.', 28000, 22000, N'Yoshito Usui', 'https://placehold.co/400x520/f4a261/ffffff?text=Shin', 55, 'ACTIVE'),
(11, 2, N'Dragon Ball Super - Tập 18', N'Songoku và các chiến binh Z bảo vệ vũ trụ.', 35000, NULL, N'Akira Toriyama', 'https://placehold.co/400x520/ffba08/000000?text=Dragon+Ball', 45, 'ACTIVE'),
(12, 2, N'Thám Tử Lừng Danh Conan - Tập 101', N'Phá án cùng thám tử nhí Shinichi Kudo.', 30000, 24000, N'Gosho Aoyama', 'https://placehold.co/400x520/457b9d/ffffff?text=Conan+101', 50, 'ACTIVE'),
(13, 2, N'Naruto - Tập 72 (Bản Đặc Biệt)', N'Hành trình trở thành Hokage của Uzumaki Naruto.', 45000, 36000, N'Masashi Kishimoto', 'https://placehold.co/400x520/e76f51/ffffff?text=Naruto', 40, 'ACTIVE'),

-- Category 3: Van hoc (7 sach)
(14, 3, N'Nhà Giả Kim', N'Cuốn sách thúc giục người đọc theo đuổi giấc mơ của cuộc đời mình.', 79000, 63000, N'Paulo Coelho', 'https://placehold.co/400x520/d4a373/ffffff?text=Nha+Gia+Kim', 30, 'ACTIVE'),
(15, 3, N'Mắt Biếc', N'Tác phẩm văn học lãng mạn, sâu lắng của nhà văn Nguyễn Nhật Ánh.', 110000, NULL, N'Nguyễn Nhật Ánh', 'https://placehold.co/400x520/006d77/ffffff?text=Mat+Biec', 12, 'ACTIVE'),
(16, 3, N'Tuổi Trẻ Đáng Giá Bao Nhiêu', N'Cuốn sách truyền cảm hứng cho giới trẻ Việt Nam.', 95000, 76000, N'Rosie Nguyen', 'https://placehold.co/400x520/2a9d8f/ffffff?text=Tuoi+Tre', 50, 'ACTIVE'),
(17, 3, N'Cà Phê Cùng Tony', N'Những câu chuyện nhỏ - triết lý sống lớn.', 110000, NULL, N'Tony Buổi Sáng', 'https://placehold.co/400x520/6f4e37/ffffff?text=Cafe+Tony', 40, 'ACTIVE'),
(18, 3, N'Sống Một Tuổi Trẻ Có Ý Nghĩa', N'Hành trình tìm kiếm ý nghĩa cuộc sống cho người trẻ.', 88000, 70000, N'Lê Thẩm Dương', 'https://placehold.co/400x520/9d4edd/ffffff?text=YNghia', 35, 'ACTIVE'),
(19, 3, N'Đời Ngắn Đừng Ngủ Dài', N'Triết lý sống tỉnh thức từ thiền sư.', 78000, NULL, N'Robin Sharma', 'https://placehold.co/400x520/3d5a80/ffffff?text=Doi+Ngan', 30, 'ACTIVE'),
(20, 3, N'Harry Potter và Hòn Đá Phù Thủy', N'Tập 1 bộ tiểu thuyết huyền thoại của J.K. Rowling.', 145000, 116000, N'J.K. Rowling', 'https://placehold.co/400x520/7400b8/ffffff?text=Harry+Potter', 25, 'ACTIVE'),

-- Category 4: Ky nang (8 sach)
(21, 4, N'Đắc Nhân Tâm', N'Cuốn sách nghệ thuật ứng xử hàng đầu mọi thời đại.', 86000, 68000, N'Dale Carnegie', 'https://placehold.co/400x520/c8a165/ffffff?text=Dac+Nhan+Tam', 25, 'ACTIVE'),
(22, 4, N'Thay Đổi Tí Hon Hiệu Quả Bất Ngờ', N'Cách xây dựng thói quen tốt và loại bỏ thói quen xấu một cách khoa học.', 145000, 116000, N'James Clear', 'https://placehold.co/400x520/264653/ffffff?text=Atomic', 18, 'ACTIVE'),
(23, 4, N'7 Thói Quen Hiệu Quả', N'Xây dựng thói quen thành công cho mọi lĩnh vực.', 175000, NULL, N'Stephen Covey', 'https://placehold.co/400x520/2d6a4f/ffffff?text=7+Thoi+Quen', 30, 'ACTIVE'),
(24, 4, N'Nghĩ Giàu & Làm Giàu', N'Bí mật của sự giàu có và thành công.', 135000, 108000, N'Napoleon Hill', 'https://placehold.co/400x520/8ab17d/ffffff?text=Think+Rich', 35, 'ACTIVE'),
(25, 4, N'Thay Đổi Cuộc Sống Với Nhân Số Học', N'Khám phá con số chủ đạo và vận mệnh.', 165000, 132000, N'Lê Đỗ Quỳnh Hương', 'https://placehold.co/400x520/ffb703/000000?text=Nhan+So+Hoc', 28, 'ACTIVE'),
(26, 4, N'Tuần Làm Việc 4 Giờ', N'Lối sống tối giản cho người bận rộn.', 145000, 116000, N'Timothy Ferriss', 'https://placehold.co/400x520/9b5de5/ffffff?text=4H+Workweek', 22, 'ACTIVE'),
(27, 4, N'Cách Nghĩ Để Thành Công', N'5 bước xây dựng tư duy chiến binh.', 130000, NULL, N'Adam Khoo', 'https://placehold.co/400x520/00bbf9/ffffff?text=Cach+Nghi', 30, 'ACTIVE'),
(28, 4, N'Đắc Nhân Tâm (Bản Đặc Biệt 2024)', N'Phiên bản đặc biệt - bìa cứng, có chữ ký tác giả.', 120000, 99000, N'Dale Carnegie', 'https://placehold.co/400x520/f15bb5/ffffff?text=DNT+2024', 40, 'ACTIVE');
SET IDENTITY_INSERT san_pham OFF;
PRINT 'Da them 28 san pham';
GO

-- =========================================
-- DATA: HOA DON + CHI TIET
-- =========================================
SET IDENTITY_INSERT hoa_don ON;
INSERT INTO hoa_don(id, user_id, receiver_name, receiver_phone, receiver_address, note, total_amount, payment_method, order_status) VALUES
(1, 2, N'Bùi Văn Đức', '0904415459', N'Đông Hải, Hải Phòng', N'Giao giờ hành chính, gọi trước 15 phút', 300000, 'COD', 'PENDING'),
(2, 3, N'Trần Thị Phương Nhung', '0782159754', N'Cát Bà, Hải Phòng', N'Để ở bảo vệ nếu không gọi được', 65000, 'COD', 'CONFIRMED');
SET IDENTITY_INSERT hoa_don OFF;
PRINT 'Da them 2 hoa don';
GO

SET IDENTITY_INSERT hoa_don_chi_tiet ON;
INSERT INTO hoa_don_chi_tiet(id, invoice_id, product_id, product_name, product_image, price_at_purchase, quantity, line_total) VALUES
(1, 1, 1, N'Giáo Trình Lập Trình Java Spring Boot', 'https://placehold.co/400x520/b08968/ffffff?text=Java+Spring', 150000, 2, 300000),
(2, 2, 7, N'Thám Tử Lừng Danh Conan - Tập 100', 'https://placehold.co/400x520/1d3557/ffffff?text=Conan', 30000, 1, 30000),
(3, 2, 8, N'One Piece - Tập 101', 'https://placehold.co/400x520/e63946/ffffff?text=One+Piece', 35000, 1, 35000);
SET IDENTITY_INSERT hoa_don_chi_tiet OFF;
PRINT 'Da them 3 chi tiet hoa don';
GO

-- Tru quantity san pham da ban
UPDATE san_pham SET quantity = quantity - 1 WHERE id = 7;
UPDATE san_pham SET quantity = quantity - 1 WHERE id = 8;
PRINT 'Da tru quantity cho 2 sp';
GO

-- =========================================
-- KIEM TRA
-- =========================================
SELECT 'USERS' AS Bang, COUNT(*) AS So_luong FROM users
UNION ALL SELECT 'DANH_MUC', COUNT(*) FROM danh_muc
UNION ALL SELECT 'SAN_PHAM', COUNT(*) FROM san_pham
UNION ALL SELECT 'GIO_HANG', COUNT(*) FROM gio_hang
UNION ALL SELECT 'HOA_DON', COUNT(*) FROM hoa_don
UNION ALL SELECT 'HOA_DON_CHI_TIET', COUNT(*) FROM hoa_don_chi_tiet;
GO

PRINT '=========================================';
PRINT 'HOAN TAT! Tat ca bang + data da san sang.';
PRINT '=========================================';
GO
