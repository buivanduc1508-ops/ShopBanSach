package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectDB {
    public static Connection con = null;

    public static Connection getConnect() {
        // Thay tên database, tài khoản và mật khẩu theo máy của nhóm.
        String strDbUrl = "jdbc:sqlserver://localhost:1433;"
                + "databaseName=SD2001_DATN_DEMO;"
                + "user=sa;password=123123;"
                + "encrypt=true;trustServerCertificate=true";

        try {
            con = DriverManager.getConnection(strDbUrl);
            System.out.println("Kết nối thành công");
        } catch (SQLException e) {
            System.err.println("Kết nối lỗi: " + e.getMessage());
        }

        return con;
    }

    public static void main(String[] args) {
        ConnectDB.getConnect();
    }
}
