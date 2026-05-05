package vn.edu.hcmuaf.fit.websharedocument.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    // Thay đổi thông tin CSDL cho phù hợp với môi trường của bạn
    private static final String URL = "jdbc:mysql://localhost:3306/web_tai_lieu";
    private static final String USER = "root";
    private static final String PASS = "";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new SQLException("Database connection error");
        }
    }
}
