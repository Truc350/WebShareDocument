package vn.edu.hcmuaf.fit.websharedocument.dao;

import vn.edu.hcmuaf.fit.websharedocument.db.DBConnect;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import java.sql.*;

public class DocumentDAO {
    /**
     * UC5.1.10: Ghi metadata vào cơ sở dữ liệu
     */
    public boolean saveDocument(Document document) throws SQLException {
        String sql = "INSERT INTO documents (user_id, category_id, title, description, file_name, file_path, file_size, file_type, file_extension, download_count, view_count, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, document.getUserId());
            if (document.getCategoryId() != null) {
                ps.setInt(2, document.getCategoryId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, document.getTitle());
            ps.setString(4, document.getDescription());
            ps.setString(5, document.getFileName());
            ps.setString(6, document.getFilePath());
            ps.setLong(7, document.getFileSize());
            ps.setString(8, document.getFileType());
            ps.setString(9, document.getFileExtension());
            ps.setInt(10, document.getDownloadCount());
            ps.setInt(11, document.getViewCount());
            ps.setBoolean(12, document.isActive());
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        document.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public Document getDocumentById(int id) {
        String sql = "SELECT d.*, u.full_name as uploader_name, c.name as category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "WHERE d.id = ? AND d.is_active = 1";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Document doc = new Document();
                    doc.setId(rs.getInt("id"));
                    doc.setUserId(rs.getInt("user_id"));
                    doc.setTitle(rs.getString("title"));
                    doc.setDescription(rs.getString("description"));
                    doc.setFileName(rs.getString("file_name"));
                    doc.setFilePath(rs.getString("file_path"));
                    doc.setFileSize(rs.getLong("file_size"));
                    doc.setFileType(rs.getString("file_type"));
                    doc.setFileExtension(rs.getString("file_extension"));
                    doc.setDownloadCount(rs.getInt("download_count"));
                    doc.setViewCount(rs.getInt("view_count"));
                    doc.setActive(rs.getBoolean("is_active"));
                    java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) doc.setCreatedAt(createdAt.toLocalDateTime());
                    doc.setUploaderName(rs.getString("uploader_name"));
                    doc.setCategoryName(rs.getString("category_name"));
                    return doc;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void incrementViewCount(int documentId) {
        String sql = "UPDATE documents SET view_count = view_count + 1 WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, documentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}