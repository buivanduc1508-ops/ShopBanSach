-- =========================================
-- FILE 1/2: Chay voi quyen SA
-- Tao login duc + gan quyen sysadmin
-- =========================================

USE master;
GO

-- Tao login neu chua co
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'duc')
BEGIN
    CREATE LOGIN duc WITH PASSWORD = '123123', CHECK_POLICY = OFF;
    PRINT 'Da tao login duc';
END
ELSE
    PRINT 'Login duc da ton tai';
GO

-- Cho duc quyen sysadmin (de co the tao/xoa DB)
ALTER SERVER ROLE sysadmin ADD MEMBER duc;
PRINT 'Da gan quyen sysadmin cho duc';
GO
