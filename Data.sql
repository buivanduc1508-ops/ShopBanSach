CREATE DATABASE BOOKSTORE;
GO

USE BOOKSTORE;
GO

-- =========================
-- 1. Bảng users (Tài khoản hệ thống)
-- =========================
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

    CONSTRAINT CK_users_role
        CHECK (role IN ('ADMIN', 'CUSTOMER')),

    CONSTRAINT CK_users_status
        CHECK (status IN ('ACTIVE', 'LOCKED'))
);
GO

-- =========================
-- 2. Bảng danh_muc (Danh mục sách)
-- =========================
CREATE TABLE danh_muc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT CK_danh_muc_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- =========================
-- 3. Bảng san_pham (Sách / Sản phẩm)
-- =========================
CREATE TABLE san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(18,2) NOT NULL,
    sale_price DECIMAL(18,2) NULL, -- Gia khuyen mai (NULL = khong giam gia)
    author NVARCHAR(150) NULL, -- Tac gia
    image NVARCHAR(500),
    quantity INT NOT NULL DEFAULT 0, -- Số lượng sách trong kho
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_san_pham_danh_muc
        FOREIGN KEY (category_id) REFERENCES danh_muc(id),

    CONSTRAINT CK_san_pham_price_non_negative
        CHECK (price >= 0),

    CONSTRAINT CK_san_pham_quantity_non_negative
        CHECK (quantity >= 0),

    CONSTRAINT CK_san_pham_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- =========================
-- 4. Bảng gio_hang (Giỏ hàng trực tuyến)
-- =========================
CREATE TABLE gio_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    updated_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_gio_hang_users
        FOREIGN KEY (user_id) REFERENCES users(id),

    CONSTRAINT FK_gio_hang_san_pham
        FOREIGN KEY (product_id) REFERENCES san_pham(id),

    CONSTRAINT CK_gio_hang_quantity_positive
        CHECK (quantity > 0),

    CONSTRAINT UQ_gio_hang_user_product
        UNIQUE (user_id, product_id)
);
GO

-- =========================
-- 5. Bảng hoa_don (Đơn hàng bán sách)
-- =========================
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

    CONSTRAINT FK_hoa_don_users
        FOREIGN KEY (user_id) REFERENCES users(id),

    CONSTRAINT CK_hoa_don_total_amount
        CHECK (total_amount >= 0),

    CONSTRAINT CK_hoa_don_payment_method
        CHECK (payment_method IN ('COD', 'ONLINE')), -- Mở rộng thêm thanh toán Online nếu cần

    CONSTRAINT CK_hoa_don_order_status
        CHECK (order_status IN (
            'PENDING',
            'CONFIRMED',
            'SHIPPING',
            'FINISH',
            'CANCELLED'
        ))
);
GO

-- =========================
-- 6. Bảng hoa_don_chi_tiet (Chi tiết sách trong đơn hàng)
-- =========================
CREATE TABLE hoa_don_chi_tiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name NVARCHAR(150) NOT NULL,
    product_image NVARCHAR(500),
    price_at_purchase DECIMAL(18,2) NOT NULL,
    quantity INT NOT NULL,
    line_total DECIMAL(18,2) NOT NULL,

    CONSTRAINT FK_hoa_don_chi_tiet_hoa_don
        FOREIGN KEY (invoice_id) REFERENCES hoa_don(id),

    CONSTRAINT FK_hoa_don_chi_tiet_san_pham
        FOREIGN KEY (product_id) REFERENCES san_pham(id),

    CONSTRAINT CK_hoa_don_chi_tiet_price_non_negative
        CHECK (price_at_purchase >= 0),

    CONSTRAINT CK_hoa_don_chi_tiet_quantity_positive
        CHECK (quantity > 0),

    CONSTRAINT CK_hoa_don_chi_tiet_line_total_non_negative
        CHECK (line_total >= 0)
);
GO


-- =========================
-- Dữ liệu mẫu: users (Danh sách thành viên dự án)
-- =========================
INSERT INTO users(full_name, email, password_hash, phone, address, role, status)
VALUES
(N'Bùi Văn Đức', 'buivanduc1508@gmail.com', '123654', '0904415459', N'Hải Phòng', 'ADMIN', 'ACTIVE'),
(N'Nguyễn Danh Nhật Lâm', 'dokhanh020906@gmail.com', '123890', '0386550664', N'Cát Bà, Hải Phòng', 'CUSTOMER', 'ACTIVE'),
(N'Trần Thị Phương Nhung', 'phuongnhung14052007@gmail.com', '123789', '0782159754', N'Lê Chân, Hải Phòng', 'CUSTOMER', 'ACTIVE'),
(N'Lương Xuân Tiến', 'xuanatien@gmail.com', '123456', '0867054901', N'Hải Phòng', 'CUSTOMER', 'ACTIVE');
Go

-- =========================
-- Dữ liệu mẫu: danh_muc (Các thể loại sách)
-- =========================
INSERT INTO danh_muc(name, description, status)
VALUES
(N'Sách Giáo Khoa & Giáo Trình', N'Sách phục vụ học tập, giảng dạy tại các cấp học và đại học', 'ACTIVE'),
(N'Truyện Tranh & Manga', N'Truyện tranh giải trí trong và ngoài nước', 'ACTIVE'),
(N'Sách Văn Học & Tiểu Thuyết', N'Tác phẩm văn học kinh điển, tiểu thuyết hiện đại', 'ACTIVE'),
(N'Sách Kỹ Năng & Phát Triển Bản Thân', N'Sách hướng dẫn kỹ năng sống, tư duy, kinh doanh', 'ACTIVE');
GO

-- =========================
-- Dữ liệu mẫu: san_pham (Các tựa sách cụ thể)
-- =========================
INSERT INTO san_pham(category_id, name, description, price, image, quantity, status)
VALUES
(1, N'Giáo Trình Lập Trình Java Spring Boot', N'Hướng dẫn chi tiết từ cơ bản đến nâng cao về phát triển Web với Spring Boot.', 150000, 'https://placehold.co/book-spring.jpg', 15, 'ACTIVE'),
(1, N'Cấu Trúc Dữ Liệu Và Giải Thuật', N'Sách nền tảng cho mọi lập trình viên tư duy thuật toán.', 120000, 'https://placehold.co/book-ctdl.jpg', 20, 'ACTIVE'),
(2, N'Thám Tử Lừng Danh Conan - Tập 100', N'Ấn bản đặc biệt đánh dấu cột mốc tập thứ 100 của bộ truyện huyền thoại.', 30000, 'https://placehold.co/book-conan.jpg', 50, 'ACTIVE'),
(2, N'One Piece - Tập 101', N'Hành trình chinh phục kho báu vĩ đại của băng Mũ Rơm tại Wano Quốc.', 35000, 'https://placehold.co/book-onepiece.jpg', 40, 'ACTIVE'),
(3, N'Nhà Giả Kim', N'Cuốn sách thúc giục người đọc theo đuổi giấc mơ của cuộc đời mình.', 79000, 'https://placehold.co/book-nhagiakim.jpg', 30, 'ACTIVE'),
(3, N'Mắt Biếc', N'Tác phẩm văn học lãng mạn, sâu lắng của nhà văn Nguyễn Nhật Ánh.', 110000, 'https://placehold.co/book-matbiec.jpg', 12, 'ACTIVE'),
(4, N'Đắc Nhân Tâm', N'Cuốn sách nghệ thuật ứng xử hàng đầu mọi thời đại.', 86000, 'https://placehold.co/book-dacnhantam.jpg', 25, 'ACTIVE'),
(4, N'Thay Đổi Tí Hon Hiệu Quả Bất Ngờ', N'Cách xây dựng thói quen tốt và loại bỏ thói quen xấu một cách khoa học.', 145000, 'https://placehold.co/book-atomic-habits.jpg', 18, 'ACTIVE');
GO

-- =========================
-- Dữ liệu mẫu: hoa_don (Hóa đơn mua sách)
-- =========================
INSERT INTO hoa_don(
    user_id,
    receiver_name,
    receiver_phone,
    receiver_address,
    note,
    total_amount,
    payment_method,
    order_status
)
VALUES
-- user_id = 2 () mua sách giáo trình
(2, N'Bùi Văn Đức', '0904415459', N'Đông Hải, Hải Phòng', N'Giao giờ hành chính, gọi trước 15 phút', 300000, 'COD', 'PENDING'),

-- user_id = 3 () mua truyện tranh
(3, N'Trần Thị Phương Nhung', '0782159754', N'Cát Bà, Hải Phòng', N'Để ở bảo vệ nếu không gọi được', 65000, 'COD', 'CONFIRMED');
GO

-- =========================
-- Dữ liệu mẫu: hoa_don_chi_tiet
-- =========================
INSERT INTO hoa_don_chi_tiet(
    invoice_id,
    product_id,
    product_name,
    product_image,
    price_at_purchase,
    quantity,
    line_total
)
VALUES
-- Chi tiết hóa đơn 1 (Mua 2 cuốn Java Spring Boot: 2 * 150,000 = 300,000)
(1, 1, N'Giáo Trình Lập Trình Java Spring Boot', 'https://placehold.co/book-spring.jpg', 150000, 2, 300000),

-- Chi tiết hóa đơn 2 (Mua 1 cuốn Conan, 1 cuốn One Piece: 30,000 + 35,000 = 65,000)
(2, 3, N'Thám Tử Lừng Danh Conan - Tập 100', 'https://placehold.co/book-conan.jpg', 30000, 1, 30000),
(2, 4, N'One Piece - Tập 101', 'https://placehold.co/book-onepiece.jpg', 35000, 1, 35000);
GO

-- Đơn mẫu số 2 đang ở trạng thái CONFIRMED nên chạy lệnh cập nhật tự động trừ số lượng sách trong kho
-- Trừ 1 cuốn Conan (product_id = 3)
UPDATE san_pham
SET quantity = quantity - 1
WHERE id = 3 AND quantity >= 1;

-- Trừ 1 cuốn One Piece (product_id = 4)
UPDATE san_pham
SET quantity = quantity - 1
WHERE id = 4 AND quantity >= 1;
GO

-- =========================
-- Kiểm tra dữ liệu hệ thống sách
-- =========================
SELECT * FROM users;
SELECT * FROM danh_muc;
SELECT * FROM san_pham;
SELECT * FROM gio_hang;
SELECT * FROM hoa_don;
SELECT * FROM hoa_don_chi_tiet;
GO