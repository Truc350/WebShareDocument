package vn.edu.hcmuaf.fit.websharedocument.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    // Thay đổi thông tin CSDL cho phù hợp với môi trường của bạn
    private static final String URL = "jdbc:mysql://mysql-345b2be-macchinguyenmcn-1236.k.aivencloud.com:25965/defaultdb";
    private static final String USER = "avnadmin";
    private static final String PASS = "AVNS_5DOVBjmnXDxH_1xLa9I";

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
