package vn.edu.hcmuaf.fit.websharedocument.controller;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/api/search", "/api/suggestions"})
public class SearchAPIController extends HttpServlet {
    private DocumentDAO documentDAO = new DocumentDAO();

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    private String buildSuggestionsJson(List<String> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append("\"").append(escapeJson(list.get(i))).append("\"");
            if (i < list.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String buildResultsJson(List<Document> list, List<String> synonymsUsed, List<String> popularKeywords) {
        StringBuilder sb = new StringBuilder("{\"count\":").append(list.size()).append(",");
        // UC11.2.6.5 synonymsUsed
        sb.append("\"synonymsUsed\":[");
        for (int i = 0; i < synonymsUsed.size(); i++) {
            sb.append("\"").append(escapeJson(synonymsUsed.get(i))).append("\"");
            if (i < synonymsUsed.size() - 1) sb.append(",");
        }
        sb.append("],");
        // UC11.2.4.3 popularKeywords
        sb.append("\"popularKeywords\":[");
        for (int i = 0; i < popularKeywords.size(); i++) {
            sb.append("\"").append(escapeJson(popularKeywords.get(i))).append("\"");
            if (i < popularKeywords.size() - 1) sb.append(",");
        }
        sb.append("],");
        sb.append("\"results\":[");
        for (int i = 0; i < list.size(); i++) {
            Document d = list.get(i);
            sb.append("{")
              .append("\"id\":").append(d.getId()).append(",")
              .append("\"title\":\"").append(escapeJson(d.getTitle())).append("\",")
              .append("\"description\":\"").append(escapeJson(d.getDescription())).append("\",")
              .append("\"fileName\":\"").append(escapeJson(d.getFileName())).append("\",")
              .append("\"categoryName\":\"").append(escapeJson(d.getCategoryName())).append("\",")
              .append("\"fileExtension\":\"").append(escapeJson(d.getFileExtension())).append("\",")
              .append("\"uploaderName\":\"").append(escapeJson(d.getUploaderName())).append("\",")
              .append("\"viewCount\":").append(d.getViewCount()).append(",")
              .append("\"downloadCount\":").append(d.getDownloadCount()).append(",")
              .append("\"createdAt\":");
              
              if (d.getCreatedAt() != null) {
                  sb.append("{\"date\":{")
                    .append("\"year\":").append(d.getCreatedAt().getYear()).append(",")
                    .append("\"month\":").append(d.getCreatedAt().getMonthValue()).append(",")
                    .append("\"day\":").append(d.getCreatedAt().getDayOfMonth())
                    .append("}}");
              } else {
                  sb.append("null");
              }
            sb.append("}");
            if (i < list.size() - 1) sb.append(",");
        }
        sb.append("]}");
        return sb.toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String uri = request.getRequestURI();
        String q = request.getParameter("q");

        if (q == null) q = "";

        // EX-01: Sanitize đầu vào
        q = q.replaceAll("[^a-zA-Z0-9\\s\\p{L}]", "").trim();

        if (uri.endsWith("/api/suggestions")) {
            // EX-02: Từ khóa quá ngắn
            if (q.length() < 2) {
                response.getWriter().write("[]");
                return;
            }
            // UC11.1.2: Sau 300ms kể từ lúc người dùng ngừng gõ (debounce), hệ thống gửi yêu cầu tìm kiếm gợi ý (autocomplete) với từ khóa hiện tại.
            List<String> suggestions = documentDAO.getSuggestions(q);
            response.getWriter().write(buildSuggestionsJson(suggestions));
        } else if (uri.endsWith("/api/search")) {
            List<Document> results;
            List<String> synonymsUsed = new ArrayList<>();
            List<String> popularKeywords = documentDAO.getPopularSearchKeywords();
            if (q.isEmpty()) {
                // UC11.2.3.3: Khôi phục lại danh sách tài liệu đầy đủ (không có bộ lọc từ khóa) – giữ nguyên các bộ lọc danh mục đang áp dụng.
                results = documentDAO.getFullDocumentList();
            } else {
                // UC11.1.5: Nhận tham số q={từ+khóa}; thực hiện truy vấn full-text search trên các trường: tên tài liệu, mô tả, chủ đề, tags. / UC11.2.6.3: Thực hiện truy vấn full-text song song cho từ khóa gốc và tất cả từ đồng nghĩa; kết hợp kết quả và loại bỏ trùng lặp.
                results = documentDAO.fullTextSearch(q, synonymsUsed);
            }

            response.getWriter().write(buildResultsJson(results, synonymsUsed, popularKeywords));
        }
    }
}
