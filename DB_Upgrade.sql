-- Chay script nay neu DB BOOKSTORE da ton tai va THIEU 2 cot sale_price + author
USE BOOKSTORE;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('san_pham') AND name = 'sale_price')
BEGIN
    ALTER TABLE san_pham ADD sale_price DECIMAL(18,2) NULL;
    PRINT 'Da them cot sale_price';
END
ELSE PRINT 'Cot sale_price da co san';
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('san_pham') AND name = 'author')
BEGIN
    ALTER TABLE san_pham ADD author NVARCHAR(150) NULL;
    PRINT 'Da them cot author';
END
ELSE PRINT 'Cot author da co san';
GO

-- Cap nhat du lieu mau (gia goc + gia KM + tac gia) neu cot dang NULL
UPDATE san_pham SET sale_price = ROUND(price * 0.85, 0) WHERE sale_price IS NULL AND price > 100000;
UPDATE san_pham SET author = N'Nhieu tac gia' WHERE author IS NULL;
PRINT 'Da cap nhat sale_price + author cho cac san pham cu';
GO

SELECT id, name, price, sale_price, author FROM san_pham;
GO
