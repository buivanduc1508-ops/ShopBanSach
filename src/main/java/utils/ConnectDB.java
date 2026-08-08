package utils;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

/**
 * ConnectDB - Mo connection moi lan goi getConnect()
 * In stderr chi tiet loi de biet chinh xac nguyen nhan.
 */
public class ConnectDB {

    // Cau hinh DB - sua tai day neu khac
    private static final String HOST = "localhost";
    private static final String PORT = "1433";
    private static final String DB_NAME = "BOOKSTORE";
    private static final String USER = "sa";
    private static final String PASSWORD = "1234";

    private static final String URL =
        "jdbc:sqlserver://" + HOST + ":" + PORT + ";"
      + "databaseName=" + DB_NAME + ";"
      + "user=" + USER + ";password=" + PASSWORD + ";"
      + "encrypt=true;trustServerCertificate=true;"
      + "loginTimeout=10;"
      + "sendStringParametersAsUnicode=true";

    static {
        try {
            // Load JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("[ConnectDB] Da load Microsoft SQL Server JDBC driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[ConnectDB] KHONG TIM THAY DRIVER: com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.err.println("==> Kiem tra pom.xml + Maven Update Project + check JAR trong WEB-INF/lib");
            e.printStackTrace();
        }
    }

    public static Connection getConnect() {
        try {
            Connection con = DriverManager.getConnection(URL);
            System.out.println("[ConnectDB] Ket noi thanh cong: " + con.getMetaData().getURL());
            return con;
        } catch (SQLException e) {
            System.err.println("========================================");
            System.err.println("[ConnectDB] LOI KET NOI SQL SERVER!");
            System.err.println("URL: " + URL);
            System.err.println("Nguyen nhan: " + e.getMessage());
            System.err.println("ErrorCode: " + e.getErrorCode());
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("--- Kiem tra:");
            System.err.println("1. SQL Server da chay chua?");
            System.err.println("2. Database BOOKSTORE da tao chua?");
            System.err.println("3. User " + USER + " co ton tai + dung mat khau " + PASSWORD + " khong?");
            System.err.println("4. TCP/IP da enable tren SQL Server Configuration?");
            System.err.println("========================================");
            e.printStackTrace();
            return null;
        }
    }

    public static void closeQuietly(Connection c) {
        if (c == null) return;
        try {
            if (!c.isClosed()) c.close();
        } catch (SQLException ignored) {}
    }

    public static void main(String[] args) {
        Connection c = getConnect();
        if (c != null) {
            System.out.println("Test thanh cong: " + c);
            closeQuietly(c);
        } else {
            System.err.println("Test that bai - xem log phia tren");
        }
    }
}
