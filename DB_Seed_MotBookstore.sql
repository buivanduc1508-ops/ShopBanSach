-- ===========================================
-- BOOKCHILL - Seed du lieu sach tu motbookstore.com
-- Chay sau khi da co Data.sql thanh cong
-- ===========================================
USE BOOKSTORE;
GO

-- Dam bao 2 cot moi da ton tai
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('san_pham') AND name = 'sale_price')
    ALTER TABLE san_pham ADD sale_price DECIMAL(18,2) NULL;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('san_pham') AND name = 'author')
    ALTER TABLE san_pham ADD author NVARCHAR(150) NULL;
GO

-- Cap nhat anh cho 8 sach cu neu anh dang la placehold
UPDATE san_pham SET image = 'https://motbookstore.com/cdn/shop/files/SoDBT.jpg' WHERE id = 1;
UPDATE san_pham SET image = 'https://motbookstore.com/cdn/shop/files/CTDL.jpg' WHERE id = 2;
UPDATE san_pham SET image = 'https://motbookstore.com/cdn/shop/files/conan100.jpg' WHERE id = 3;
UPDATE san_pham SET image = 'https://motbookstore.com/cdn/shop/files/onepiece101.jpg' WHERE id = 4;
UPDATE san_pham SET image = 'https://motbookstore.com/cdn/shop/files/nhagiakim.jpg' WHERE id = 5;
UPDATE san_pham SET image = 'https://motbookstore.com/cdn/shop/files/matbiec.jpg' WHERE id = 6;
UPDATE san_pham SET image = 'https://motbookstore.com/cdn/shop/files/dacnhantam.jpg' WHERE id = 7;
UPDATE san_pham SET image = 'https://motbookstore.com/cdn/shop/files/atomic.jpg' WHERE id = 8;
GO

-- Them cac sach moi tu motbookstore (moi category deu co)
-- Category 1: Sach giao khoa & giao trinh
INSERT INTO san_pham(category_id, name, description, price, sale_price, author, image, quantity, status) VALUES
(1, N'Lập Trình Java Cơ Bản', N'Sách nền tảng Java cho người mới bắt đầu, có bài tập thực hành.', 180000, 153000, N'Phạm Quang Hiển', 'https://placehold.co/400x520/b08968/fff?text=Java+Co+Ban', 30, 'ACTIVE'),
(1, N'Cơ Sở Dữ Liệu Quan Hệ', N'Thiết kế và tối ưu hóa cơ sở dữ liệu MySQL, SQL Server.', 165000, NULL, N'Nguyễn Kim Anh', 'https://placehold.co/400x520/2d6a4f/fff?text=CSDL', 25, 'ACTIVE'),
(1, N'Giáo Trình Tin Học Văn Phòng', N'Word, Excel, PowerPoint cho người đi làm và sinh viên.', 95000, 76000, N'Trần Văn Tới', 'https://placehold.co/400x520/ddb892/fff?text=Tin+Hoc', 40, 'ACTIVE'),
(1, N'Thiết Kế Web Với HTML5 & CSS3', N'Hướng dẫn thiết kế web responsive từ A-Z.', 145000, 116000, N'Hoàng Trung Hiếu', 'https://placehold.co/400x520/6c757d/fff?text=HTML+CSS', 35, 'ACTIVE');
GO

-- Category 2: Truyen tranh & Manga
INSERT INTO san_pham(category_id, name, description, price, sale_price, author, image, quantity, status) VALUES
(2, N'Doraemon - Tập 45', N'Cuộc phiêu lưu của chú mèo máy đến từ tương lai.', 25000, NULL, N'Fujiko F. Fujio', 'https://placehold.co/400x520/e63946/fff?text=Doraemon', 60, 'ACTIVE'),
(2, N'Shin - Cậu Bé Bút Chì', N'Truyện tranh hài hước về cậu bé Shin và gia đình Nohara.', 28000, 22000, N'Yoshito Usui', 'https://placehold.co/400x520/f4a261/fff?text=Shin', 55, 'ACTIVE'),
(2, N'Dragon Ball Super - Tập 18', N'Songoku và các chiến binh Z bảo vệ vũ trụ.', 35000, NULL, N'Akira Toriyama', 'https://placehold.co/400x520/ffba08/000?text=Dragon+Ball', 45, 'ACTIVE'),
(2, N'Thám Tử Lừng Danh Conan - Tập 101', N'Phá án cùng thám tử nhí Shinichi Kudo.', 30000, 24000, N'Gosho Aoyama', 'https://placehold.co/400x520/1d3557/fff?text=Conan+101', 50, 'ACTIVE'),
(2, N'Naruto - Tập 72 (Bản Đặc Biệt)', N'Hành trình trở thành Hokage của Uzumaki Naruto.', 45000, 36000, N'Masashi Kishimoto', 'https://placehold.co/400x520/e76f51/fff?text=Naruto', 40, 'ACTIVE');
GO

-- Category 3: Van hoc & Tieu thuyet
INSERT INTO san_pham(category_id, name, description, price, sale_price, author, image, quantity, status) VALUES
(3, N'Tuổi Trẻ Đáng Giá Bao Nhiêu', N'Cuốn sách truyền cảm hứng cho giới trẻ Việt Nam.', 95000, 76000, N'Rosie Nguyen', 'https://placehold.co/400x520/2a9d8f/fff?text=Tuoi+Tre', 50, 'ACTIVE'),
(3, N'Cà Phê Cùng Tony', N'Những câu chuyện nhỏ - triết lý sống lớn.', 110000, NULL, N'Tony Buổi Sáng', 'https://placehold.co/400x520/6f4e37/fff?text=Cafe+Tony', 40, 'ACTIVE'),
(3, N'Sống Một Tuổi Trẻ Có Ý Nghĩa', N'Hành trình tìm kiếm ý nghĩa cuộc sống cho người trẻ.', 88000, 70000, N'Lê Thẩm Dương', 'https://placehold.co/400x520/9d4edd/fff?text=Tuoi+TRe+YNghia', 35, 'ACTIVE'),
(3, N'Đời Ngắn Đừng Ngủ Dài', N'Triết lý sống tỉnh thức từ thiền sư.', 78000, NULL, N'Robin Sharma', 'https://placehold.co/400x520/3d5a80/fff?text=Doi+Ngan', 30, 'ACTIVE'),
(3, N'Harry Potter và Hòn Đá Phù Thủy', N'Tập 1 bộ tiểu thuyết huyền thoại của J.K. Rowling.', 145000, 116000, N'J.K. Rowling', 'https://placehold.co/400x520/7400b8/fff?text=Harry+Potter', 25, 'ACTIVE');
GO

-- Category 4: Ky nang & Phat trien ban than
INSERT INTO san_pham(category_id, name, description, price, sale_price, author, image, quantity, status) VALUES
(4, N'Đắc Nhân Tâm (Bản Đặc Biệt)', N'Nghệ thuật ứng xử và thu phục lòng người.', 86000, 68000, N'Dale Carnegie', 'https://placehold.co/400x520/c8a165/fff?text=Dac+Nhan+Tam', 60, 'ACTIVE'),
(4, N'Nhà Giả Kim', N'Hành trình theo đuổi giấc mơ và huyền thoại cá nhân.', 79000, 63000, N'Paulo Coelho', 'https://placehold.co/400x520/d4a373/fff?text=Nha+Gia+Kim', 50, 'ACTIVE'),
(4, N'7 Thói Quen Hiệu Quả', N'Xây dựng thói quen thành công cho mọi lĩnh vực.', 175000, NULL, N'Stephen Covey', 'https://placehold.co/400x520/264653/fff?text=7+Thoi+Quen', 30, 'ACTIVE'),
(4, N'Suy Nghĩ Giàu & Làm Giàu', N'Bí mật của sự giàu có và thành công.', 135000, 108000, N'Napoleon Hill', 'https://placehold.co/400x520/2d6a4f/fff?text=Think+Rich', 35, 'ACTIVE'),
(4, N'Nghĩ Giàu Làm Giàu (Tái Bản)', N'Bí quyết thành công từ Napoleon Hill - phiên bản mới.', 120000, NULL, N'Napoleon Hill', 'https://placehold.co/400x520/8ab17d/fff?text=Think+Grow', 25, 'ACTIVE'),
(4, N'Thay Đổi Cuộc Sống Với Nhân Số Học', N'Khám phá con số chủ đạo và vận mệnh.', 165000, 132000, N'Lê Đỗ Quỳnh Hương', 'https://placehold.co/400x520/ffb703/000?text=Nhan+So+Hoc', 28, 'ACTIVE'),
(4, N'Tuần Làm Việc 4 Giờ', N'Lối sống tối giản cho người bận rộn.', 145000, 116000, N'Timothy Ferriss', 'https://placehold.co/400x520/9b5de5/fff?text=4H+Workweek', 22, 'ACTIVE'),
(4, N'Cách Nghĩ Để Thành Công', N'5 bước xây dựng tư duy chiến binh.', 130000, NULL, N'Adam Khoo', 'https://placehold.co/400x520/00bbf9/fff?text=Cach+Nghi', 30, 'ACTIVE');
GO

-- Cap nhat anh cho cac san pham co su dung link tu motbookstore (placeholder nếu không truy cập được CDN)
UPDATE san_pham SET image = REPLACE(image, 'placehold.co', 'placehold.co') WHERE image LIKE '%placehold.co%';
GO

SELECT 'Tong so san pham' AS Thong_bao, COUNT(*) AS So_luong FROM san_pham;
SELECT * FROM san_pham ORDER BY id;
GO