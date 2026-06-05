package vn.edu.hcmuaf.fit.websharedocument.dao;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class DocumentDAOTest {

    private DocumentDAO documentDAO;

    @BeforeEach
    public void setUp() {
        documentDAO = new DocumentDAO();
    }

    /**
     * UC11.2.1.3 / UC11.2.6.3: Kiểm tra việc kết hợp kết quả (merge)
     * Đảm bảo:
     * - Ưu tiên kết quả từ list1 lên đầu.
     * - Các kết quả từ list2 xếp sau.
     * - Loại bỏ hoàn toàn các bản ghi bị trùng lặp ID.
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
        
        // Tạo thêm 1 phần tử trùng với list1 để test khử trùng lặp
        Document docDuplicate = new Document();
        docDuplicate.setId(1);
        docDuplicate.setTitle("Toán Giải Tích 1 - Trùng lặp");

        list2.add(doc2);
        list2.add(docDuplicate);

        // Thực hiện gộp
        List<Document> merged = documentDAO.mergeAndPrioritize(list1, list2);

        // Kiểm tra kết quả
        assertNotNull(merged);
        assertEquals(2, merged.size(), "Danh sách sau khi gộp phải loại bỏ phần tử trùng ID (id=1)");
        assertEquals(1, merged.get(0).getId(), "Phần tử thuộc list1 (chủ đề chính xác) phải nằm đầu tiên");
        assertEquals(2, merged.get(1).getId(), "Phần tử thuộc list2 (xếp sau) phải nằm vị trí thứ hai");
    }

    /**
     * UC11.1.6 / UC11.2.6.4: Sắp xếp kết quả theo relevance score (độ liên quan) giảm dần.
     * Đảm bảo:
     * - Khớp tiêu đề (Title) có điểm cao nhất (+10 điểm).
     * - Khớp mô tả (Description) (+5 điểm).
     * - Khớp danh mục (CategoryName) (+3 điểm).
     */
    @Test
    public void testSortByRelevanceScore() {
        List<Document> results = new ArrayList<>();

        // Tài liệu 1: Chỉ khớp danh mục (Category) -> Ít liên quan nhất
        Document docLow = new Document();
        docLow.setId(101);
        docLow.setTitle("Lịch sử Đảng");
        docLow.setDescription("Tài liệu tham khảo môn học lý luận chính trị");
        docLow.setCategoryName("Lập trình Java"); // Khớp từ khóa "Java" ở danh mục

        // Tài liệu 2: Khớp tiêu đề (Title) -> Liên quan nhất
        Document docHigh = new Document();
        docHigh.setId(102);
        docHigh.setTitle("Lập trình Java căn bản"); // Khớp từ khóa "Java" ở tiêu đề
        docHigh.setDescription("Khóa học nhập môn lập trình");
        docHigh.setCategoryName("Công nghệ thông tin");

        // Tài liệu 3: Khớp mô tả (Description) -> Liên quan vừa
        Document docMedium = new Document();
        docMedium.setId(103);
        docMedium.setTitle("Nhập môn Lập trình");
        docMedium.setDescription("Hướng dẫn tự học Java hiệu quả"); // Khớp từ khóa "Java" ở mô tả
        docMedium.setCategoryName("Công nghệ thông tin");

        // Thêm vào danh sách theo thứ tự lộn xộn
        results.add(docLow);
        results.add(docHigh);
        results.add(docMedium);

        // Thực hiện sắp xếp theo từ khóa "Java"
        documentDAO.sortByRelevanceScore(results, "Java");

        // Kiểm tra thứ tự sau khi sắp xếp
        assertEquals(102, results.get(0).getId(), "Tài liệu khớp tiêu đề (docHigh) phải xếp thứ nhất (10 điểm)");
        assertEquals(103, results.get(1).getId(), "Tài liệu khớp mô tả (docMedium) phải xếp thứ hai (5 điểm)");
        assertEquals(101, results.get(2).getId(), "Tài liệu khớp danh mục (docLow) phải xếp cuối cùng (3 điểm)");
    }

    /**
     * UC11.1.2 / UC11.1.3: Kiểm thử chức năng gợi ý tìm kiếm (Autocomplete Suggestions)
     * Chạy thực tế với database để lấy các từ khóa gợi ý.
     */
    @Test
    public void testGetSuggestions() {
        // Gửi truy vấn gợi ý từ khóa "java"
        List<String> suggestions = documentDAO.getSuggestions("java");

        assertNotNull(suggestions, "Kết quả gợi ý không được null");
        assertTrue(suggestions.size() <= 5, "Danh sách gợi ý tối đa 5 mục theo yêu cầu UC11.1.3");
        
        // Nếu database có dữ liệu, kiểm tra xem có chứa từ khóa mong muốn không
        for (String suggestion : suggestions) {
            assertTrue(suggestion.toLowerCase().contains("java"), 
                    "Mỗi từ khóa gợi ý phải chứa cụm từ tìm kiếm (không phân biệt chữ hoa thường)");
        }
    }

    /**
     * UC11.2.6: Kiểm thử chức năng tìm kiếm đồng nghĩa (Synonym Search)
     * Đảm bảo khi tìm kiếm từ khóa gốc (ví dụ: "calculus"), hệ thống sẽ gợi ý thêm từ đồng nghĩa (ví dụ: "giải tích", "vi tích phân").
     */
    @Test
    public void testSynonymSearch() {
        List<String> synonymsUsed = new ArrayList<>();
        
        // Thực hiện tìm kiếm đồng nghĩa với từ khóa "calculus"
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
     */
    @Test
    public void testFullTextSearch() {
        List<String> synonymsUsed = new ArrayList<>();
        List<Document> results = documentDAO.fullTextSearch("java", synonymsUsed);

        assertNotNull(results, "Kết quả tìm kiếm không được null");
        
        // Kiểm tra nếu có kết quả trả về, đảm bảo các kết quả đều liên quan đến từ khóa "java" hoặc các từ đồng nghĩa của nó (ví dụ: "lập trình java", "oop", "hướng đối tượng")
        for (Document doc : results) {
            boolean matched = false;
            String title = doc.getTitle().toLowerCase();
            String desc = doc.getDescription() != null ? doc.getDescription().toLowerCase() : "";
            String category = doc.getCategoryName() != null ? doc.getCategoryName().toLowerCase() : "";

            if (title.contains("java") || desc.contains("java") || category.contains("java")) {
                matched = true;
            }
            
            // Hoặc khớp với các từ đồng nghĩa được dùng
            for (String syn : synonymsUsed) {
                if (title.contains(syn.toLowerCase()) || desc.contains(syn.toLowerCase()) || category.contains(syn.toLowerCase())) {
                    matched = true;
                }
            }
            
            assertTrue(matched, "Tài liệu trả về phải khớp với từ khóa gốc hoặc từ đồng nghĩa");
        }
    }

    /**
     * UC11.2.4.3: Kiểm thử lấy các từ khóa tìm kiếm phổ biến khi không tìm thấy kết quả.
     */
    @Test
    public void testGetPopularSearchKeywords() {
        List<String> popularKeywords = documentDAO.getPopularSearchKeywords();

        assertNotNull(popularKeywords, "Danh sách từ khóa phổ biến không được null");
        assertFalse(popularKeywords.isEmpty(), "Hệ thống phải trả về ít nhất một vài từ khóa phổ biến mặc định hoặc thực tế");
        assertTrue(popularKeywords.size() <= 5, "Danh sách từ khóa phổ biến tối đa 5 mục theo thiết kế");
    }

    /**
     * UC11.2.3.3: Kiểm thử chức năng xóa từ khóa và khôi phục danh sách tài liệu đầy đủ
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
}

