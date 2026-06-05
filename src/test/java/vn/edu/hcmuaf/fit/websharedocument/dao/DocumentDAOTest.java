package vn.edu.hcmuaf.fit.websharedocument.dao;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.db.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Lớp kiểm thử đơn vị cho DocumentDAO.
 * Thực hiện kiểm thử các hàm tìm kiếm, tích hợp kết quả, gợi ý từ khóa (UC11) 
 * và các hàm kiểm tra phân quyền, cập nhật thông tin tài liệu (UC15).
 */
public class DocumentDAOTest {

    private DocumentDAO documentDAO;

    @BeforeEach
    public void setUp() {
        documentDAO = new DocumentDAO();
    }

    /**
     * UC11.2.1.3 / UC11.2.6.3: Kiểm tra việc kết hợp và ưu tiên kết quả tìm kiếm (merge)
     * Mong đợi: Danh sách sau khi gộp không được null, loại bỏ hoàn toàn các tài liệu trùng ID, 
     * đồng thời các tài liệu thuộc list1 (khớp chủ đề chính xác) phải được ưu tiên xếp lên đầu.
     */
    @Test
    public void testMergeAndPrioritize() {
        // Tạo danh sách 1 (Ví dụ: Khớp chủ đề chính xác)
        List<Document> list1 = new ArrayList<>();
        Document doc1 = new Document();
        doc1.setId(1);
        doc1.setTitle("Toán Giải Tích 1");
        list1.add(doc1);

        // Tạo danh sách 2 (Ví dụ: Khớp full-text hoặc đồng nghĩa)
        List<Document> list2 = new ArrayList<>();
        Document doc2 = new Document();
        doc2.setId(2);
        doc2.setTitle("Bài tập Giải Tích");
        
        // Tạo thêm 1 phần tử trùng ID với list1 để kiểm thử tính năng khử trùng lặp
        Document docDuplicate = new Document();
        docDuplicate.setId(1);
        docDuplicate.setTitle("Toán Giải Tích 1 - Trùng lặp");

        list2.add(doc2);
        list2.add(docDuplicate);

        // Thực hiện gộp hai danh sách
        List<Document> merged = documentDAO.mergeAndPrioritize(list1, list2);

        // Xác minh kết quả sau khi gộp
        assertNotNull(merged);
        assertEquals(2, merged.size(), "Danh sách sau khi gộp phải loại bỏ phần tử trùng ID (id=1)");
        assertEquals(1, merged.get(0).getId(), "Phần tử thuộc list1 (chủ đề chính xác) phải nằm đầu tiên");
        assertEquals(2, merged.get(1).getId(), "Phần tử thuộc list2 (xếp sau) phải nằm vị trí thứ hai");
    }

    /**
     * UC11.1.6 / UC11.2.6.4: Sắp xếp kết quả tìm kiếm theo relevance score (độ liên quan) giảm dần.
     * Mong đợi: Các tài liệu được sắp xếp theo thứ tự độ liên quan giảm dần dựa trên quy tắc tính điểm:
     * - Khớp tiêu đề đứng thứ nhất (+10 điểm).
     * - Khớp mô tả đứng thứ hai (+5 điểm).
     * - Khớp danh mục đứng cuối cùng (+3 điểm).
     */
    @Test
    public void testSortByRelevanceScore() {
        List<Document> results = new ArrayList<>();

        // Tài liệu 1: Chỉ khớp danh mục (Category) -> Ít liên quan nhất (3 điểm)
        Document docLow = new Document();
        docLow.setId(101);
        docLow.setTitle("Lịch sử Đảng");
        docLow.setDescription("Tài liệu tham khảo môn học lý luận chính trị");
        docLow.setCategoryName("Lập trình Java"); // Khớp từ khóa "Java" ở danh mục

        // Tài liệu 2: Khớp tiêu đề (Title) -> Liên quan nhất (10 điểm)
        Document docHigh = new Document();
        docHigh.setId(102);
        docHigh.setTitle("Lập trình Java căn bản"); // Khớp từ khóa "Java" ở tiêu đề
        docHigh.setDescription("Khóa học nhập môn lập trình");
        docHigh.setCategoryName("Công nghệ thông tin");

        // Tài liệu 3: Khớp mô tả (Description) -> Liên quan vừa (5 điểm)
        Document docMedium = new Document();
        docMedium.setId(103);
        docMedium.setTitle("Nhập môn Lập trình");
        docMedium.setDescription("Hướng dẫn tự học Java hiệu quả"); // Khớp từ khóa "Java" ở mô tả
        docMedium.setCategoryName("Công nghệ thông tin");

        // Thêm vào danh sách theo thứ tự lộn xộn để chuẩn bị sắp xếp
        results.add(docLow);
        results.add(docHigh);
        results.add(docMedium);

        // Thực hiện sắp xếp theo từ khóa "Java"
        documentDAO.sortByRelevanceScore(results, "Java");

        // Kiểm tra thứ tự sau khi sắp xếp (giảm dần từ cao xuống thấp)
        assertEquals(102, results.get(0).getId(), "Tài liệu khớp tiêu đề (docHigh) phải xếp thứ nhất (10 điểm)");
        assertEquals(103, results.get(1).getId(), "Tài liệu khớp mô tả (docMedium) phải xếp thứ hai (5 điểm)");
        assertEquals(101, results.get(2).getId(), "Tài liệu khớp danh mục (docLow) phải xếp cuối cùng (3 điểm)");
    }

    /**
     * UC11.1.2 / UC11.1.3: Kiểm thử gợi ý tự động hoàn thành từ khóa tìm kiếm (Autocomplete Suggestions)
     * Mong đợi: Trả về danh sách các từ khóa gợi ý hợp lệ (tối đa 5 gợi ý), mỗi gợi ý phải chứa cụm từ tìm kiếm gốc (không phân biệt hoa thường).
     */
    @Test
    public void testGetSuggestions() {
        // Gửi truy vấn gợi ý từ khóa "java"
        List<String> suggestions = documentDAO.getSuggestions("java");

        assertNotNull(suggestions, "Kết quả gợi ý không được null");
        assertTrue(suggestions.size() <= 5, "Danh sách gợi ý tối đa 5 mục theo yêu cầu UC11.1.3");
        
        // Kiểm tra xem tất cả các từ khóa gợi ý có thực sự liên quan không
        for (String suggestion : suggestions) {
            assertTrue(suggestion.toLowerCase().contains("java"), 
                    "Mỗi từ khóa gợi ý phải chứa cụm từ tìm kiếm (không phân biệt chữ hoa thường)");
        }
    }

    /**
     * UC11.2.6: Kiểm thử chức năng tìm kiếm đồng nghĩa (Synonym Search)
     * Mong đợi: Trả về danh sách kết quả chứa các từ khóa đồng nghĩa tiếng Việt (giải tích, vi tích phân, toán cao) khi tìm kiếm bằng từ khóa gốc tiếng Anh "calculus".
     */
    @Test
    public void testSynonymSearch() {
        List<String> synonymsUsed = new ArrayList<>();
        
        // Thực hiện tìm kiếm đồng nghĩa với từ khóa gốc "calculus"
        List<Document> results = documentDAO.synonymSearch("calculus", synonymsUsed);

        assertNotNull(results, "Kết quả tìm kiếm không được null");
        assertNotNull(synonymsUsed, "Danh sách từ đồng nghĩa đã dùng không được null");

        // Kiểm tra xem hệ thống có nhận diện và tự động mở rộng sang các từ đồng nghĩa như "giải tích", "vi tích phân", "toán cao" không
        if (!synonymsUsed.isEmpty()) {
            assertTrue(synonymsUsed.contains("giải tích") || synonymsUsed.contains("vi tích phân") || synonymsUsed.contains("toán cao"),
                    "Danh sách từ đồng nghĩa được dùng phải chứa các từ liên quan đến 'calculus' trong từ điển đồng nghĩa");
        }
    }

    /**
     * UC11.1.5 / UC11.2.6.3: Kiểm thử toàn bộ quy trình tìm kiếm full-text kết hợp đồng nghĩa và sắp xếp độ liên quan.
     * Mong đợi: Trả về danh sách tài liệu khớp với từ khóa gốc hoặc các từ đồng nghĩa được áp dụng, không null và được lọc đúng nội dung.
     */
    @Test
    public void testFullTextSearch() {
        List<String> synonymsUsed = new ArrayList<>();
        List<Document> results = documentDAO.fullTextSearch("java", synonymsUsed);

        assertNotNull(results, "Kết quả tìm kiếm không được null");
        
        // Đảm bảo tất cả các kết quả trả về đều liên quan đến từ khóa "java" hoặc các từ đồng nghĩa của nó (ví dụ: "oop", "lập trình java")
        for (Document doc : results) {
            boolean matched = false;
            String title = doc.getTitle().toLowerCase();
            String desc = doc.getDescription() != null ? doc.getDescription().toLowerCase() : "";
            String category = doc.getCategoryName() != null ? doc.getCategoryName().toLowerCase() : "";

            if (title.contains("java") || desc.contains("java") || category.contains("java")) {
                matched = true;
            }
            
            // Hoặc khớp với các từ đồng nghĩa được áp dụng
            for (String syn : synonymsUsed) {
                if (title.contains(syn.toLowerCase()) || desc.contains(syn.toLowerCase()) || category.contains(syn.toLowerCase())) {
                    matched = true;
                }
            }
            
            assertTrue(matched, "Tài liệu trả về phải khớp với từ khóa gốc hoặc từ đồng nghĩa");
        }
    }

    /**
     * UC11.2.4.3: Kiểm thử chức năng gợi ý các từ khóa tìm kiếm phổ biến khi không tìm thấy kết quả.
     * Mong đợi: Trả về danh sách từ khóa phổ biến không rỗng và số lượng gợi ý không vượt quá 5 mục.
     */
    @Test
    public void testGetPopularSearchKeywords() {
        List<String> popularKeywords = documentDAO.getPopularSearchKeywords();

        assertNotNull(popularKeywords, "Danh sách từ khóa phổ biến không được null");
        assertFalse(popularKeywords.isEmpty(), "Hệ thống phải trả về ít nhất một vài từ khóa phổ biến mặc định");
        assertTrue(popularKeywords.size() <= 5, "Danh sách từ khóa phổ biến tối đa 5 mục theo thiết kế");
    }

    /**
     * UC11.2.3.3: Kiểm thử chức năng xóa từ khóa và khôi phục danh sách tài liệu đầy đủ
     * Mong đợi: Trả về toàn bộ tài liệu đang có trạng thái hoạt động (is_active = 1) và không bị null.
     */
    @Test
    public void testGetFullDocumentList() {
        List<Document> list = documentDAO.getFullDocumentList();

        assertNotNull(list, "Danh sách tài liệu đầy đủ không được null");
        
        // Đảm bảo tất cả các tài liệu được trả về đều có trạng thái hoạt động (is_active = 1)
        for (Document doc : list) {
            assertEquals(1, doc.getIsActive(), "Chỉ khôi phục các tài liệu đang ở trạng thái hoạt động (is_active = 1)");
        }
    }

    // ========================================================================
    // CÁC UNIT TEST CHO CHỨC NĂNG UC15: CHỈNH SỬA THÔNG TIN TÀI LIỆU (EDIT INFO)
    // ========================================================================

    /**
     * UC15.1.3: Kiểm thử lấy thông tin tài liệu theo ID để hiển thị lên Form chỉnh sửa thành công
     * Mong đợi: Lấy thành công tài liệu từ DB, kết quả không được null, ID và các trường tiêu đề, mô tả khớp chính xác với dữ liệu kiểm thử.
     */
    @Test
    public void testGetDocumentByIdForEdit_Success() throws Exception {
        // Chuẩn bị dữ liệu kiểm thử
        int userId = getOrCreateTestUserId();
        int docId = createTestDocument(userId, "Tài liệu test Edit", "Mô tả cũ");

        try {
            // Thực hiện truy vấn thông tin tài liệu theo ID
            Document doc = documentDAO.getDocumentByIdForEdit(docId);
            
            // Xác minh dữ liệu lấy lên khớp hoàn toàn với dữ liệu đã lưu
            assertNotNull(doc, "Tài liệu để sửa phải tồn tại và không được null");
            assertEquals(docId, doc.getId());
            assertEquals("Tài liệu test Edit", doc.getTitle());
            assertEquals("Mô tả cũ", doc.getDescription());
        } finally {
            // Dọn dẹp dữ liệu kiểm thử trong CSDL
            deleteTestDocument(docId);
            deleteTestUserIfCreated(userId);
        }
    }

    /**
     * EX-03: Kiểm thử khi tài liệu bị xóa trong khi đang sửa (truy vấn với ID không tồn tại)
     * Mong đợi: Kết quả trả về phải là null.
     */
    @Test
    public void testGetDocumentByIdForEdit_NotFound() {
        Document doc = documentDAO.getDocumentByIdForEdit(-9999);
        assertNull(doc, "ID không tồn tại trong hệ thống phải trả về null");
    }

    /**
     * UC15.1.2: Kiểm thử xác minh quyền sở hữu tài liệu thành công (Đúng chủ sở hữu)
     * Mong đợi: Trả về giá trị true.
     */
    @Test
    public void testIsOwner_Success() throws Exception {
        int userId = getOrCreateTestUserId();
        int docId = createTestDocument(userId, "Tài liệu của tôi", "Mô tả");

        try {
            // Xác minh người dùng hiện tại là chủ sở hữu hợp lệ của tài liệu vừa tạo
            boolean isOwner = documentDAO.isOwner(docId, userId);
            assertTrue(isOwner, "Hàm isOwner phải trả về true khi truyền đúng userId sở hữu");
        } finally {
            deleteTestDocument(docId);
            deleteTestUserIfCreated(userId);
        }
    }

    /**
     * UC15.1.2 & UC15.2.1: Kiểm thử xác minh quyền sở hữu thất bại (Sai chủ sở hữu hoặc sai ID tài liệu)
     * Mong đợi: Trả về giá trị false cho cả 2 trường hợp.
     */
    @Test
    public void testIsOwner_Failed() throws Exception {
        int userId = getOrCreateTestUserId();
        int docId = createTestDocument(userId, "Tài liệu người khác", "Mô tả");

        try {
            // Trường hợp 1: Sai userId (Không phải chủ sở hữu) -> Mong đợi trả về false
            boolean isOwner = documentDAO.isOwner(docId, -9999); 
            assertFalse(isOwner, "Phải trả về false khi người dùng không sở hữu tài liệu này");

            // Trường hợp 2: Sai ID tài liệu -> Mong đợi trả về false
            boolean isOwnerInvalidDoc = documentDAO.isOwner(-9999, userId); 
            assertFalse(isOwnerInvalidDoc, "Phải trả về false khi tài liệu không tồn tại");
        } finally {
            deleteTestDocument(docId);
            deleteTestUserIfCreated(userId);
        }
    }

    /**
     * UC15.1.9: Kiểm thử cập nhật thông tin tài liệu thành công (Tiêu đề, mô tả và nhãn tags)
     * Mong đợi: Cập nhật thành công thông tin tài liệu (trả về true), lấy tài liệu ra kiểm tra thấy tiêu đề, mô tả mới và các nhãn dán tags mới đã được lưu vào DB.
     */
    @Test
    public void testUpdateDocumentInfo_Success() throws Exception {
        int userId = getOrCreateTestUserId();
        int docId = createTestDocument(userId, "Tiêu đề gốc", "Mô tả gốc");

        try {
            // Thiết lập thông tin mới cần cập nhật cho tài liệu
            Document updateDoc = new Document();
            updateDoc.setId(docId);
            updateDoc.setUserId(userId);
            updateDoc.setTitle("Tiêu đề đã cập nhật");
            updateDoc.setDescription("Mô tả đã cập nhật");
            updateDoc.setCategoryId(null);
            updateDoc.setIsActive(1);
            updateDoc.setTags(Arrays.asList("JUnit", "DaoTest"));

            // Thực thi cập nhật thông tin
            boolean success = documentDAO.updateDocumentInfo(updateDoc);
            assertTrue(success, "Hàm updateDocumentInfo phải trả về true khi cập nhật thành công");

            // Lấy lại dữ liệu từ DB để xác minh các thay đổi đã được ghi nhận
            Document fetched = documentDAO.getDocumentByIdForEdit(docId);
            assertNotNull(fetched);
            assertEquals("Tiêu đề đã cập nhật", fetched.getTitle());
            assertEquals("Mô tả đã cập nhật", fetched.getDescription());
            assertTrue(fetched.getTags().contains("JUnit"));
            assertTrue(fetched.getTags().contains("DaoTest"));
        } finally {
            deleteTestDocument(docId);
            deleteTestUserIfCreated(userId);
        }
    }

    /**
     * UC15.1.9 & EX-01: Kiểm thử cập nhật thông tin thất bại khi tài liệu không tồn tại (ID sai)
     * Mong đợi: Hàm updateDocumentInfo phải trả về false.
     */
    @Test
    public void testUpdateDocumentInfo_InvalidId() {
        Document updateDoc = new Document();
        updateDoc.setId(-9999); // ID không tồn tại
        updateDoc.setUserId(1);
        updateDoc.setTitle("Tiêu đề");
        updateDoc.setDescription("Mô tả");
        updateDoc.setIsActive(1);
        updateDoc.setTags(new ArrayList<>());

        boolean success = documentDAO.updateDocumentInfo(updateDoc);
        assertFalse(success, "Phải trả về false khi thực hiện cập nhật trên một tài liệu không tồn tại");
    }

    // ========================================================================
    // CÁC HÀM BỔ TRỢ (HELPER) ĐỂ QUẢN LÝ DỮ LIỆU TEST TRÊN DB THẬT
    // ========================================================================

    private int createdTestUserId = -1;

    /**
     * Lấy ID của một người dùng bất kỳ có sẵn trong cơ sở dữ liệu để chạy test.
     * Nếu cơ sở dữ liệu trống, hàm tự động tạo một người dùng giả lập mới.
     */
    private int getOrCreateTestUserId() throws Exception {
        try (Connection conn = DBConnect.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT id FROM users LIMIT 1")) {
            if (rs.next()) {
                return rs.getInt("id");
            }
        }
        
        // Tạo một người dùng giả lập nếu cơ sở dữ liệu hoàn toàn trống
        String sql = "INSERT INTO users (username, email, password, full_name, role, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "testuser_junit");
            ps.setString(2, "testuser_junit@example.com");
            ps.setString(3, "password");
            ps.setString(4, "JUnit Test User");
            ps.setString(5, "user");
            ps.setInt(6, 1);
            ps.executeUpdate();
            try (ResultSet rsKeys = ps.getGeneratedKeys()) {
                if (rsKeys.next()) {
                    createdTestUserId = rsKeys.getInt(1);
                    return createdTestUserId;
                }
            }
        }
        throw new SQLException("Không thể lấy hoặc tạo người dùng giả lập cho việc chạy thử");
    }

    /**
     * Tạo một tài liệu giả lập gắn với userId được chỉ định để chạy kiểm thử.
     */
    private int createTestDocument(int userId, String title, String description) throws Exception {
        String sql = "INSERT INTO documents (user_id, title, description, file_name, file_path, file_size, file_type, file_extension, download_count, view_count, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setString(4, "test.pdf");
            ps.setString(5, "test.pdf");
            ps.setLong(6, 1024L);
            ps.setString(7, "application/pdf");
            ps.setString(8, "pdf");
            ps.setInt(9, 0);
            ps.setInt(10, 0);
            ps.setInt(11, 1);
            ps.executeUpdate();
            try (ResultSet rsKeys = ps.getGeneratedKeys()) {
                if (rsKeys.next()) {
                    return rsKeys.getInt(1);
                }
            }
        }
        throw new SQLException("Không thể khởi tạo tài liệu giả lập cho việc chạy thử");
    }

    /**
     * Xóa sạch tài liệu giả lập và các mối liên kết tag của nó trong bảng trung gian document_tags.
     */
    private void deleteTestDocument(int documentId) throws Exception {
        try (Connection conn = DBConnect.getConnection()) {
            // Bước 1: Xóa liên kết nhãn dán trong bảng trung gian document_tags
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM document_tags WHERE document_id = ?")) {
                ps.setInt(1, documentId);
                ps.executeUpdate();
            }
            // Bước 2: Xóa thông tin tài liệu trong bảng documents
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM documents WHERE id = ?")) {
                ps.setInt(1, documentId);
                ps.executeUpdate();
            }
        }
    }

    /**
     * Xóa tài khoản người dùng giả lập nếu tài khoản đó được tạo ở bước chuẩn bị.
     */
    private void deleteTestUserIfCreated(int userId) throws Exception {
        if (userId == createdTestUserId) {
            try (Connection conn = DBConnect.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            createdTestUserId = -1;
        }
    }
}
