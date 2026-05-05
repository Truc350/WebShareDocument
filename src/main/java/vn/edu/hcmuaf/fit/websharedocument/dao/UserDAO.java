package vn.edu.hcmuaf.fit.websharedocument.dao;

import vn.edu.hcmuaf.fit.websharedocument.db.DBConnect;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    /**
     * Xác thực đăng nhập cho Admin
     * Mật khẩu có thể cần hash (ví dụ BCrypt) trong thực tế
     */
    public User loginAdmin(String username, String password) {
        // Chỉ cho phép admin và tài khoản đang hoạt động (is_active = 1)
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND role = 'admin' AND is_active = 1";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, username);
            ps.setString(2, password); // Cần mã hóa password trong thực tế
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    user.setIsActive(rs.getInt("is_active"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setUpdatedAt(rs.getTimestamp("updated_at"));
                    user.setLastLogin(rs.getTimestamp("last_login"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Cập nhật thời gian đăng nhập lần cuối
     */
    public void updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login = NOW() WHERE id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, userId);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Kiểm tra xem username hoặc email đã tồn tại chưa
     * Trả về true nếu đã tồn tại, ngược lại false
     */
    public boolean checkUserExist(String username, String email) {
        String sql = "SELECT id FROM users WHERE username = ? OR email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // nếu có dữ liệu tức là đã tồn tại
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đăng ký người dùng mới
     * Trả về true nếu thành công
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, email, password, full_name, role, is_active) VALUES (?, ?, ?, ?, 'user', 1)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // Cần hash trong thực tế
            ps.setString(4, user.getFullName());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
