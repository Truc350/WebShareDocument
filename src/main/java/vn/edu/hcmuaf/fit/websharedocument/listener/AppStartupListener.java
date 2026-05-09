package vn.edu.hcmuaf.fit.websharedocument.listener;

import vn.edu.hcmuaf.fit.websharedocument.db.DBConnect;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebListener
public class AppStartupListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String sql = "INSERT IGNORE INTO users (username, email, password, full_name, role, is_active) " +
                     "VALUES ('admin', 'admin@example.com', 'admin@123', 'Administrator', 'admin', 1)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
            System.out.println("Tài khoản admin mặc định đã được kiểm tra/tạo thành công.");
        } catch (Exception e) {
            System.err.println("Lỗi khi tạo tài khoản admin: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
