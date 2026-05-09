package vn.edu.hcmuaf.fit.websharedocument.dao;

import vn.edu.hcmuaf.fit.websharedocument.db.DBConnect;
import vn.edu.hcmuaf.fit.websharedocument.model.Category;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {

    // =========================
    // SAVE DOCUMENT
    // =========================
    public boolean saveDocument(Document document) throws SQLException {
        String sql = "INSERT INTO documents (user_id, category_id, title, description, file_name, file_path, file_size, file_type, file_extension, download_count, view_count, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, document.getUserId());

            if (document.getCategoryId() != null) {
                ps.setInt(2, document.getCategoryId());
            } else {
                ps.setNull(2, Types.INTEGER);
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
            ps.setInt(12, document.getIsActive());

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

    // =========================
    // GET ALL DOCUMENTS
    // =========================
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
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    doc.setCreatedAt(createdAt.toLocalDateTime());
                }
                doc.setUploaderName(rs.getString("full_name"));
                doc.setCategoryName(rs.getString("category_name"));

                list.add(doc);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // COUNT DOCUMENTS BY STATUS
    // =========================
    public int countDocumentsByStatus(int isActive) {
        String query = "SELECT COUNT(*) FROM documents WHERE is_active = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, isActive);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =========================
    // COUNT TOTAL DOCUMENTS
    // =========================
    public int countTotalDocuments() {
        String query = "SELECT COUNT(*) FROM documents";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =========================
    // GET ALL CATEGORIES
    // =========================
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

    // =========================
    // SEARCH AND FILTER
    // =========================
    public List<Document> searchAndFilterDocuments(String keyword,
                                                   String categoryId,
                                                   String format,
                                                   String timeFilter) {

        List<Document> list = new ArrayList<>();

        StringBuilder query = new StringBuilder(
                "SELECT d.*, u.full_name, c.name AS category_name " +
                        "FROM documents d " +
                        "LEFT JOIN users u ON d.user_id = u.id " +
                        "LEFT JOIN categories c ON d.category_id = c.id " +
                        "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append(" AND (d.file_name LIKE ? OR u.full_name LIKE ?) ");

            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        if (categoryId != null &&
                !categoryId.trim().isEmpty() &&
                !categoryId.equals("all")) {

            query.append(" AND d.category_id = ? ");
            params.add(Integer.parseInt(categoryId));
        }

        if (format != null &&
                !format.trim().isEmpty() &&
                !format.equals("all")) {

            query.append(" AND d.file_extension LIKE ? ");
            params.add("%" + format + "%");
        }

        if (timeFilter != null && !timeFilter.trim().isEmpty()) {

            if (timeFilter.equals("24hours")) {
                query.append(" AND d.created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY) ");

            } else if (timeFilter.equals("7days")) {
                query.append(" AND d.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) ");

            } else if (timeFilter.equals("thismonth")) {
                query.append(" AND MONTH(d.created_at) = MONTH(NOW()) " +
                        "AND YEAR(d.created_at) = YEAR(NOW()) ");
            }
        }

        query.append(" ORDER BY d.created_at DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {

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
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        doc.setCreatedAt(createdAt.toLocalDateTime());
                    }
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

    // =========================
    // UPDATE DOCUMENT STATUS
    // =========================
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

    // =========================
    // GET DOCUMENTS BY STATUS
    // =========================
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
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        doc.setCreatedAt(createdAt.toLocalDateTime());
                    }
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

    // =========================
    // GET DOCUMENT BY ID
    // =========================
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
                    return mapResultSetToDocument(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Document mapResultSetToDocument(ResultSet rs) throws SQLException {
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
        doc.setIsActive(rs.getInt("is_active"));
        java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) doc.setCreatedAt(createdAt.toLocalDateTime());
        doc.setUploaderName(rs.getString("uploader_name"));
        doc.setCategoryName(rs.getString("category_name"));
        return doc;
    }

    // UC11.1.2 getSuggestions(q)
    public List<String> getSuggestions(String q) {
        List<String> suggestions = new ArrayList<>();
        String sql = "SELECT title as suggestion FROM documents WHERE title LIKE ? AND is_active = 1 " +
                "UNION " +
                "SELECT name as suggestion FROM categories WHERE name LIKE ? " +
                "LIMIT 5";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String likeQ = "%" + q + "%";
            ps.setString(1, likeQ);
            ps.setString(2, likeQ);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    suggestions.add(rs.getString("suggestion"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suggestions;
    }

    // UC11.2.1.2 exactMatchQuery(q)
    public List<Document> exactMatchQuery(String q) {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT d.*, u.full_name as uploader_name, c.name as category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "WHERE (c.name = ?) AND d.is_active = 1";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, q);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToDocument(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // UC11.2.1.2 fullTextQuery(q)
    public List<Document> fullTextQuery(String q) {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT d.*, u.full_name as uploader_name, c.name as category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "WHERE (d.title LIKE ? OR d.description LIKE ? OR c.name LIKE ?) AND d.is_active = 1";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String likeQ = "%" + q + "%";
            ps.setString(1, likeQ);
            ps.setString(2, likeQ);
            ps.setString(3, likeQ);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToDocument(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // UC11.2.1.3 mergeAndPrioritize(results)
    public List<Document> mergeAndPrioritize(List<Document> list1, List<Document> list2) {
        List<Document> merged = new ArrayList<>(list1);
        Set<Integer> existingIds = new HashSet<>();
        for (Document doc : list1) {
            existingIds.add(doc.getId());
        }
        for (Document doc : list2) {
            if (!existingIds.contains(doc.getId())) {
                merged.add(doc);
                existingIds.add(doc.getId());
            }
        }
        return merged;
    }

    // UC11.1.6 synonymSearch(q)
    public List<Document> synonymSearch(String q) {
        return new ArrayList<>(); // Basic implementation without DB synonyms
    }

    // UC11.1.6 sortByRelevanceScore(results)
    public void sortByRelevanceScore(List<Document> results, String q) {
        results.sort((d1, d2) -> {
            int score1 = calculateRelevance(d1, q);
            int score2 = calculateRelevance(d2, q);
            return Integer.compare(score2, score1);
        });
    }

    private int calculateRelevance(Document d, String q) {
        int score = 0;
        String lowerQ = q.toLowerCase();
        if (d.getTitle() != null && d.getTitle().toLowerCase().contains(lowerQ)) score += 10;
        if (d.getDescription() != null && d.getDescription().toLowerCase().contains(lowerQ)) score += 5;
        if (d.getCategoryName() != null && d.getCategoryName().toLowerCase().contains(lowerQ)) score += 3;
        return score;
    }

    // UC11.1.5 fullTextSearch(q)
    public List<Document> fullTextSearch(String q) {
        List<Document> exactMatches = exactMatchQuery(q);
        List<Document> fullTextMatches = fullTextQuery(q);
        List<Document> results = mergeAndPrioritize(exactMatches, fullTextMatches);
        List<Document> synonyms = synonymSearch(q);
        results = mergeAndPrioritize(results, synonyms);
        sortByRelevanceScore(results, q);
        return results;
    }

    // UC11.2.3.3 getFullDocumentList()
    public List<Document> getFullDocumentList() {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT d.*, u.full_name as uploader_name, c.name as category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "WHERE d.is_active = 1";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToDocument(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // INCREMENT VIEW COUNT
    // =========================
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