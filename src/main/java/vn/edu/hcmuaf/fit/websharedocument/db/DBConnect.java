package vn.edu.hcmuaf.fit.websharedocument.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    // Thay đổi thông tin CSDL cho phù hợp với môi trường của bạn
    private static final String URL = "jdbc:mysql://localhost:3306/web_tai_lieu";
    private static final String USER = "root";
    private static final String PASS = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
