package vn.edu.hcmuaf.fit.websharedocument.dao;

import vn.edu.hcmuaf.fit.websharedocument.db.DBConnect;
import vn.edu.hcmuaf.fit.websharedocument.model.Category;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {
    // Lấy danh sách tài liệu
    public List<Document> getAllDocument() {
        List<Document> list = new ArrayList<>();
        String query = "SELECT d.*, u.full_name, c.name AS category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "ORDER BY d.created_at DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Document doc = new Document();
                doc.setId(rs.getInt("id"));
                doc.setFileName(rs.getString("file_name"));
                doc.setFileSize(rs.getLong("file_size"));
                doc.setFileExtension(rs.getString("file_extension"));
                doc.setIsActive(rs.getInt("is_active"));
                doc.setCreatedAt(rs.getTimestamp("created_at"));
                doc.setUploaderName(rs.getString("full_name"));
                doc.setCategoryName(rs.getString("category_name"));
                list.add(doc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm số lượng tài liệu theo trạng thái (0: chờ duyệt, 1: đã duyệt)
    public int countDocumentsByStatus(int isActive) {
        String query = "SELECT COUNT(*) FROM documents WHERE is_active = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, isActive);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm tổng số tài liệu
    public int countTotalDocuments() {
        String query = "SELECT COUNT(*) FROM documents";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy danh sách các danh mục
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String query = "SELECT id, name, slug, description, created_at FROM categories";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setSlug(rs.getString("slug"));
                c.setDescription(rs.getString("description"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tìm kiếm và lọc tài liệu
    public List<Document> searchAndFilterDocuments(String keyword, String categoryId, String format, String timeFilter) {
        List<Document> list = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT d.*, u.full_name, c.name AS category_name " +
                        "FROM documents d " +
                        "LEFT JOIN users u ON d.user_id = u.id " +
                        "LEFT JOIN categories c ON d.category_id = c.id " +
                        "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        // 1. Lọc theo từ khóa (Tìm theo Tên tài liệu HOẶC Tên người tải)
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append(" AND (d.file_name LIKE ? OR u.full_name LIKE ?) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        // 2. Lọc theo danh mục
        if (categoryId != null && !categoryId.trim().isEmpty() && !categoryId.equals("all")) {
            query.append(" AND d.category_id = ? ");
            params.add(Integer.parseInt(categoryId));
        }

        // 3. Lọc theo định dạng
        if (format != null && !format.trim().isEmpty() && !format.equals("all")) {
            query.append(" AND d.file_extension LIKE ? ");
            params.add("%" + format + "%");
        }

        // 4. Lọc theo thời gian
        if (timeFilter != null && !timeFilter.trim().isEmpty()) {
            if (timeFilter.equals("24hours")) {
                query.append(" AND d.created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY) ");
            } else if (timeFilter.equals("7days")) {
                query.append(" AND d.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) ");
            } else if (timeFilter.equals("thismonth")) {
                query.append(" AND MONTH(d.created_at) = MONTH(NOW()) AND YEAR(d.created_at) = YEAR(NOW()) ");
            }
        }

        query.append(" ORDER BY d.created_at DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {

            // Gắn các tham số vào câu SQL
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Document doc = new Document();
                    doc.setId(rs.getInt("id"));
                    doc.setFileName(rs.getString("file_name"));
                    doc.setFileSize(rs.getLong("file_size"));
                    doc.setFileExtension(rs.getString("file_extension"));
                    doc.setIsActive(rs.getInt("is_active"));
                    doc.setCreatedAt(rs.getTimestamp("created_at"));
                    doc.setUploaderName(rs.getString("full_name"));
                    doc.setCategoryName(rs.getString("category_name"));
                    list.add(doc);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm vào file DocumentDAO.java
    public boolean updateDocumentStatus(int docId, int newStatus) {
        String query = "UPDATE documents SET is_active = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, newStatus);
            ps.setInt(2, docId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Document> getDocumentsByStatus(int isActive) {
        List<Document> list = new ArrayList<>();
        String query = "SELECT d.*, u.full_name, c.name AS category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "WHERE d.is_active = ? " +
                "ORDER BY d.created_at DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, isActive);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Document doc = new Document();
                    doc.setId(rs.getInt("id"));
                    doc.setFileName(rs.getString("file_name"));
                    doc.setFileSize(rs.getLong("file_size"));
                    doc.setFileExtension(rs.getString("file_extension"));
                    doc.setIsActive(rs.getInt("is_active"));
                    doc.setCreatedAt(rs.getTimestamp("created_at"));
                    doc.setUploaderName(rs.getString("full_name"));
                    doc.setCategoryName(rs.getString("category_name"));
                    list.add(doc);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
