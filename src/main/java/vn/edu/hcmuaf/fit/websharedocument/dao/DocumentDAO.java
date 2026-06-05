package vn.edu.hcmuaf.fit.websharedocument.dao;

import vn.edu.hcmuaf.fit.websharedocument.db.DBConnect;
import vn.edu.hcmuaf.fit.websharedocument.model.Category;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import java.sql.*;
import java.util.*;

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

    // UC17.1.2: Hiển thị trang danh sách tài liệu
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
                doc.setTitle(rs.getString("title"));
                doc.setFileName(rs.getString("file_name"));
                doc.setFilePath(rs.getString("file_path"));
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
                    doc.setTitle(rs.getString("title"));
                    doc.setFileName(rs.getString("file_name"));
                    doc.setFilePath(rs.getString("file_path"));
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
                    doc.setTitle(rs.getString("title"));
                    doc.setFileName(rs.getString("file_name"));
                    doc.setFilePath(rs.getString("file_path"));
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

    /**
     * [UC13.1.4] Lấy thông tin thi chi tiết tài liệu theo ID (chỉ lấy bản ghi is_active = 1).
     * → Gọi bởi: FileStorage.fetchFile(documentId)
     * → null → FileStorage throw FileNotFoundException → UC13.2.3 (tệp không tìm thấy)
     * → Document → tiếp tục kiểm tra filePath (remote/local)
     * → File: DocumentDAO.java
     */
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

//                if (rs.next()) {
//                    return mapResultSetToDocument(rs);
//                }
                if (rs.next()) {

                    Document doc = new Document();

                    doc.setId(rs.getInt("id"));
                    doc.setUserId(rs.getInt("user_id"));
                    doc.setTitle(rs.getString("title"));
                    doc.setDescription(rs.getString("description"));

                    doc.setCategoryId(
                            rs.getObject("category_id") != null
                                    ? rs.getInt("category_id")
                                    : null
                    );

                    doc.setFileName(rs.getString("file_name"));
                    doc.setFilePath(rs.getString("file_path"));
                    doc.setFileSize(rs.getLong("file_size"));
                    doc.setFileType(rs.getString("file_type"));
                    doc.setFileExtension(rs.getString("file_extension"));

                    doc.setDownloadCount(rs.getInt("download_count"));
                    doc.setViewCount(rs.getInt("view_count"));
                    doc.setIsActive(rs.getInt("is_active"));

                    doc.setUploaderName(rs.getString("uploader_name"));
                    doc.setCategoryName(rs.getString("category_name"));

                    // LOAD TAGS
                    doc.setTags(getTagsByDocumentId(conn, id));

                    return doc;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Document getDocumentByIdForEdit(int id) {

        String sql = "SELECT d.*, u.full_name as uploader_name, c.name as category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "WHERE d.id = ?";

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

                    doc.setCategoryId(
                            rs.getObject("category_id") != null
                                    ? rs.getInt("category_id")
                                    : null
                    );

                    doc.setFileName(rs.getString("file_name"));
                    doc.setFilePath(rs.getString("file_path"));
                    doc.setFileSize(rs.getLong("file_size"));
                    doc.setFileType(rs.getString("file_type"));
                    doc.setFileExtension(rs.getString("file_extension"));

                    doc.setDownloadCount(rs.getInt("download_count"));
                    doc.setViewCount(rs.getInt("view_count"));
                    doc.setIsActive(rs.getInt("is_active"));

                    doc.setUploaderName(rs.getString("uploader_name"));
                    doc.setCategoryName(rs.getString("category_name"));

                    // LOAD TAGS
                    doc.setTags(getTagsByDocumentId(conn, id));

                    return doc;
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
//        doc.setTags(getTagsByDocumentId(DBConnect.getConnection(), doc.getId()));
        return doc;
    }

    // UC11.1.2: Sau 300ms kể từ lúc người dùng ngừng gõ (debounce), hệ thống gửi yêu cầu tìm kiếm gợi ý (autocomplete) với từ khóa hiện tại.
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

    // UC11.2.1.2: Thực hiện hai truy vấn song song: (1) tìm theo chủ đề/tag chính xác; (2) tìm full-text trên tên và mô tả.
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

    // UC11.2.1.2: Thực hiện hai truy vấn song song: (1) tìm theo chủ đề/tag chính xác; (2) tìm full-text trên tên và mô tả.
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

    // UC11.2.1.3: Kết hợp kết quả: ưu tiên tài liệu khớp chủ đề/tag lên đầu; các kết quả full-text xếp sau.
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

    // UC11.2.6.1: Hệ thống kiểm tra từ khóa nhập vào trong bảng đồng nghĩa (synonym dictionary) được quản lý tập trung trên hệ thống.
    private void initSynonymTable() {
        String createTableSql = "CREATE TABLE IF NOT EXISTS synonyms (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "group_id INT NOT NULL, " +
                "word VARCHAR(255) NOT NULL, " +
                "UNIQUE KEY (group_id, word)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement psTable = conn.prepareStatement(createTableSql)) {
            psTable.execute();
            // Kiểm tra xem đã có dữ liệu chưa
            String checkSql = "SELECT COUNT(*) FROM synonyms";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql);
                 ResultSet rs = psCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) == 0) {
                    // Chèn dữ liệu mẫu (các từ đồng nghĩa tiếng Việt)
                    String insertSql = "INSERT INTO synonyms (group_id, word) VALUES " +
                            "(1, 'giải tích'), (1, 'toán cao'), (1, 'calculus'), (1, 'vi tích phân'), " +
                            "(2, 'java'), (2, 'lập trình java'), (2, 'oop'), (2, 'hướng đối tượng'), " +
                            "(3, 'mạng máy tính'), (3, 'computer network'), (3, 'networking')";
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // UC11.2.6.2: Nếu từ khóa có trong bảng đồng nghĩa, hệ thống tự động mở rộng truy vấn với tất cả các từ đồng nghĩa tương ứng / UC11.2.6.3: Thực hiện truy vấn full-text song song cho từ khóa gốc và tất cả từ đồng nghĩa; kết hợp kết quả và loại bỏ trùng lặp.
    public List<Document> synonymSearch(String q, List<String> synonymsUsed) {
        List<Document> list = new ArrayList<>();
        if (q == null || q.trim().isEmpty()) return list;
        initSynonymTable();
        // 1. Tìm các group_id chứa từ khóa q
        String findGroupsSql = "SELECT DISTINCT group_id FROM synonyms WHERE LOWER(word) = LOWER(?)";
        List<Integer> groupIds = new ArrayList<>();
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(findGroupsSql)) {
            ps.setString(1, q.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    groupIds.add(rs.getInt("group_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (groupIds.isEmpty()) {
            return list;
        }
        // 2. Lấy tất cả các từ đồng nghĩa trong các group đó (loại trừ từ khóa gốc)
        List<String> synonyms = new ArrayList<>();
        StringBuilder sb = new StringBuilder("SELECT word FROM synonyms WHERE group_id IN (");
        for (int i = 0; i < groupIds.size(); i++) {
            sb.append(groupIds.get(i));
            if (i < groupIds.size() - 1) sb.append(",");
        }
        sb.append(") AND LOWER(word) != LOWER(?)");
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            ps.setString(1, q.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    synonyms.add(rs.getString("word"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // 3. Thực hiện truy vấn song song (hoặc tuần tự) cho từ đồng nghĩa, kết hợp kết quả
        for (String syn : synonyms) {
            if (synonymsUsed != null) {
                synonymsUsed.add(syn);
            }
            List<Document> synDocs = fullTextQuery(syn);
            for (Document doc : synDocs) {
                if (list.stream().noneMatch(d -> d.getId() == doc.getId())) {
                    list.add(doc);
                }
            }
        }
        return list;
    }
    // UC11.1.6: Truy vấn cả các từ đồng nghĩa / từ khóa liên quan (nếu hệ thống hỗ trợ synonym search); sắp xếp kết quả theo relevance score giảm dần.
    public List<Document> synonymSearch(String q) {
        return synonymSearch(q, new ArrayList<>());
    }

    // UC11.1.6: Truy vấn cả các từ đồng nghĩa / từ khóa liên quan (nếu hệ thống hỗ trợ synonym search); sắp xếp kết quả theo relevance score giảm dần.
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

    // UC11.1.5: Nhận tham số q={từ+khóa}; thực hiện truy vấn full-text search trên các trường: tên tài liệu, mô tả, chủ đề, tags. / UC11.2.6.3: Thực hiện truy vấn full-text song song cho từ khóa gốc và tất cả từ đồng nghĩa; kết hợp kết quả và loại bỏ trùng lặp.
    public List<Document> fullTextSearch(String q, List<String> synonymsUsed) {
        List<Document> exactMatches = exactMatchQuery(q);
        List<Document> fullTextMatches = fullTextQuery(q);
        List<Document> results = mergeAndPrioritize(exactMatches, fullTextMatches);
        List<Document> synonyms = synonymSearch(q, synonymsUsed);
        // UC11.2.6.4: Sắp xếp kết quả theo độ liên quan: tài liệu khớp từ khóa gốc được ưu tiên hàng đầu, tiếp theo là các tài liệu khớp từ đồng nghĩa.
        results = mergeAndPrioritize(results, synonyms);
        sortByRelevanceScore(results, q);
        return results;
    }

    // UC11.1.5: Nhận tham số q={từ+khóa}; thực hiện truy vấn full-text search trên các trường: tên tài liệu, mô tả, chủ đề, tags.
    public List<Document> fullTextSearch(String q) {
        return fullTextSearch(q, new ArrayList<>());
    }
    // UC11.2.4.3: Gợi ý: hiển thị các từ khóa tìm kiếm phổ biến hoặc các chủ đề đề xuất.
    public List<String> getPopularSearchKeywords() {
        List<String> keywords = new ArrayList<>();
        String sql = "SELECT c.name, COUNT(d.id) as count_docs " +
                     "FROM categories c JOIN documents d ON c.id = d.category_id " +
                     "WHERE d.is_active = 1 " +
                     "GROUP BY c.name ORDER BY count_docs DESC LIMIT 5";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                keywords.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Nếu DB chưa có dữ liệu, trả về danh sách mặc định phong phú
        if (keywords.isEmpty()) {
            keywords.add("giải tích");
            keywords.add("lập trình java");
            keywords.add("kinh tế vi mô");
            keywords.add("toán cao");
            keywords.add("mạng máy tính");
        }
        return keywords;
    }
    // UC11.2.3.3: Khôi phục lại danh sách tài liệu đầy đủ (không có bộ lọc từ khóa) – giữ nguyên các bộ lọc danh mục đang áp dụng.
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

    /**
     * UC15.1.2 – Kiểm tra userId có phải chủ sở hữu của documentId không.
     * UC15.2.1.1: Nếu false → hệ thống từ chối quyền chỉnh sửa.
     */
    public boolean isOwner(int documentId, int userId) {
        String sql = "SELECT 1 FROM documents WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, documentId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi kiểm tra quyền sở hữu: " + e.getMessage(), e);
        }
    }

    /**
     * UC15.1.7 – Cập nhật title, description, category_id, is_active vào CSDL.
     * Đồng thời cập nhật bảng document_tags trong cùng transaction.
     * UC15 Post-Condition: updated_at được ghi lại tự động.
     * Trả về true nếu UPDATE thành công.
     */
    public boolean updateDocumentInfo(Document doc) {
        boolean updateFile = doc.getFileName() != null && !doc.getFileName().isEmpty();
        
        StringBuilder sql = new StringBuilder("""
                UPDATE documents
                SET title       = ?,
                    description = ?,
                    category_id = ?,
                    is_active   = ?
                """);
        
        if (updateFile) {
            sql.append(", file_name = ?, file_path = ?, file_size = ?, file_type = ?, file_extension = ? \n");
        }
        
        sql.append("WHERE id = ? AND user_id = ?");

        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                ps.setString(1, doc.getTitle());
                ps.setString(2, doc.getDescription());
                if (doc.getCategoryId() != null) ps.setInt(3, doc.getCategoryId());
                else ps.setNull(3, Types.INTEGER);
                ps.setInt(4, doc.getIsActive() == 1 ? 1 : 0);
                
                int paramIndex = 5;
                if (updateFile) {
                    ps.setString(paramIndex++, doc.getFileName());
                    ps.setString(paramIndex++, doc.getFilePath());
                    ps.setLong(paramIndex++, doc.getFileSize());
                    ps.setString(paramIndex++, doc.getFileType());
                    ps.setString(paramIndex++, doc.getFileExtension());
                }
                
                ps.setInt(paramIndex++, doc.getId());
                ps.setInt(paramIndex++, doc.getUserId()); 

                int affected = ps.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false; 
                }

                updateDocumentTags(conn, doc.getId(), doc.getTags());

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi cập nhật tài liệu: " + e.getMessage(), e);
        }
    }

    /**
     * UC15.1.7 – Xóa toàn bộ tags cũ rồi insert tags mới cho tài liệu.
     * Nếu tag chưa có trong bảng tags thì tạo mới (upsert).
     */
    private void updateDocumentTags(Connection conn, int documentId, List<String> tagNames)
            throws SQLException {

        // Xóa tags cũ trong bảng trung gian document_tags
        String deleteSql = "DELETE FROM document_tags WHERE document_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
            ps.setInt(1, documentId);
            ps.executeUpdate();
        }

        if (tagNames == null || tagNames.isEmpty()) return;

        for (String tagName : tagNames) {
            String name = tagName.trim();
            if (name.isEmpty()) continue;
            String slug = toSlug(name);

            // Upsert tag vào bảng tags (tạo mới hoặc lấy id hiện có)
            String upsertTag = """
                    INSERT INTO tags (name, slug)
                    VALUES (?, ?)
                    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id)
                    """;
            int tagId;
            try (PreparedStatement ps = conn.prepareStatement(upsertTag,
                    Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, name);
                ps.setString(2, slug);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    rs.next();
                    tagId = rs.getInt(1);
                }
            }

            // Gán tag vào tài liệu qua bảng document_tags
            String insertLink = "INSERT IGNORE INTO document_tags (document_id, tag_id) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertLink)) {
                ps.setInt(1, documentId);
                ps.setInt(2, tagId);
                ps.executeUpdate();
            }
        }
    }

    /**
     * UC15.1.3 – Lấy danh sách tên tags của tài liệu (dùng khi load form).
     */
    private List<String> getTagsByDocumentId(Connection conn, int documentId) throws SQLException {
        String sql = """
                SELECT t.name FROM tags t
                INNER JOIN document_tags dt ON t.id = dt.tag_id
                WHERE dt.document_id = ?
                ORDER BY t.name
                """;
        List<String> tags = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, documentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) tags.add(rs.getString("name"));
            }
        }
        return tags;
    }

    public List<Document> getDocumentsByUserId(int userId) {
        List<Document> list = new ArrayList<>();
        String query = "SELECT d.*, u.full_name, c.name AS category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "WHERE d.user_id = ? " +
                "ORDER BY d.created_at DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Document doc = new Document();

                    doc.setId(rs.getInt("id"));
                    doc.setTitle(rs.getString("title"));
                    doc.setFileName(rs.getString("file_name"));
                    doc.setFileSize(rs.getLong("file_size"));
                    doc.setFileExtension(rs.getString("file_extension"));
                    doc.setDownloadCount(rs.getInt("download_count"));
                    doc.setViewCount(rs.getInt("view_count"));
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

    public int getTotalDocumentsByUserId(int userId) {
        String query = "SELECT COUNT(*) FROM documents WHERE user_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalDownloadsByUserId(int userId) {
        String query = "SELECT SUM(download_count) FROM documents WHERE user_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Document mapRow(ResultSet rs) throws SQLException {
        Document doc = new Document();
        doc.setId(rs.getInt("id"));
        doc.setUserId(rs.getInt("user_id"));
        doc.setCategoryId(rs.getObject("category_id") != null ? rs.getInt("category_id") : null);
        doc.setCategoryName(rs.getString("category_name"));
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
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) doc.setCreatedAt(created.toLocalDateTime());
        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) doc.setUpdatedAt(updated.toLocalDateTime());
        return doc;
    }

    private String toSlug(String name) {
        return name.toLowerCase()
                .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                .replaceAll("[ìíịỉĩ]", "i")
                .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                .replaceAll("[ùúụủũưừứựửữ]", "u")
                .replaceAll("[ỳýỵỷỹ]", "y")
                .replaceAll("[đ]", "d")
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("^-|-$", "");
    }
    /**
     * [UC13.1.8] Tăng số lượt tải xuống của tài liệu lên 1.
     * → Gọi bởi: DMS.writeAuditLog() ngay sau khi stream tệp thành công
     * → SQL: UPDATE documents SET download_count = download_count + 1 WHERE id = ?
     * → File: DocumentDAO.java
     */
    public void incrementDownloadCount(int documentId) {
        String sql = "UPDATE documents SET download_count = download_count + 1 WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, documentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // =========================
    // HOMEPAGE METHODS
    // =========================
    public List<Document> getLatestDocuments(int limit) {
        List<Document> list = new ArrayList<>();
        String query = "SELECT d.*, u.full_name as uploader_name, c.name AS category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "WHERE d.is_active = 1 " +
                "ORDER BY d.created_at DESC " +
                "LIMIT ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToDocument(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Document> getFeaturedDocuments(int limit) {
        List<Document> list = new ArrayList<>();
        String query = "SELECT d.*, u.full_name as uploader_name, c.name AS category_name " +
                "FROM documents d " +
                "LEFT JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN categories c ON d.category_id = c.id " +
                "WHERE d.is_active = 1 AND LENGTH(d.title) > 3 AND d.title NOT LIKE '%sdf%' AND d.title NOT LIKE '%test%' " +
                "ORDER BY (d.view_count + d.download_count) DESC " +
                "LIMIT ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToDocument(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Integer> getHomepageStats() {
        Map<String, Integer> stats = new HashMap<>();
        String queryDocs = "SELECT COUNT(*) FROM documents WHERE is_active = 1";
        String queryUsers = "SELECT COUNT(*) FROM users";
        String queryCategories = "SELECT COUNT(*) FROM categories";

        try (Connection conn = DBConnect.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(queryDocs);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.put("totalDocuments", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement(queryUsers);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.put("totalUsers", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement(queryCategories);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.put("totalCategories", rs.getInt(1));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public boolean deleteDocument(int documentId, int userId) {
        String deleteTagsSql = "DELETE FROM document_tags WHERE document_id = ?";
        String deleteDocSql = "DELETE FROM documents WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement psTags = conn.prepareStatement(deleteTagsSql)) {
                    psTags.setInt(1, documentId);
                    psTags.executeUpdate();
                }
                
                int affectedRows = 0;
                try (PreparedStatement psDoc = conn.prepareStatement(deleteDocSql)) {
                    psDoc.setInt(1, documentId);
                    psDoc.setInt(2, userId);
                    affectedRows = psDoc.executeUpdate();
                }
                
                if (affectedRows > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // [UC17.1.8] Cập nhật thông tin tài liệu (tiêu đề, mô tả, danh mục) vào Database
    public boolean updateDocumentMetadata(int id, String title, String description, int categoryId) {
        String sql = "UPDATE documents SET title = ?, description = ?, category_id = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setInt(3, categoryId);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // [UC17.1.11] Ghi nhật ký hoạt động (Audit Log)
    public void logActivity(int adminId, String action, String targetType, int targetId, String detail, String ip) {
        String sql = "INSERT INTO activity_logs (user_id, action, target_type, target_id, detail, ip_address) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setString(2, action);
            ps.setString(3, targetType);
            ps.setInt(4, targetId);
            ps.setString(5, detail);
            ps.setString(6, ip);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}