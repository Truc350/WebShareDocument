package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Statement;
import java.util.Locale;
import java.util.Set;
import vn.edu.hcmuaf.fit.websharedocument.db.DBConnect;

@WebServlet(name = "UploadDocumentServlet", value = "/upload", loadOnStartup = 1)
@MultipartConfig(
        fileSizeThreshold = 10 * 1024 * 1024,
        maxFileSize = 50L * 1024L * 1024L,
        maxRequestSize = 60L * 1024L * 1024L
)
public class UploadDocumentServlet extends HttpServlet {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "txt", "png", "jpg", "jpeg");
    private DocumentDAO documentDAO;

    @Override
    public void init() throws ServletException {
        documentDAO = new DocumentDAO();
        // Warm-up database connection ngay khi khởi động
        try (Connection conn = DBConnect.getConnection()) {
            if (conn != null) {
                try (Statement stmt = conn.createStatement()) {
                    stmt.executeQuery("SELECT 1");
                }
            }
            getServletContext().log("UploadDocumentServlet: Database warm-up successful.");
        } catch (Exception e) {
            getServletContext().log("UploadDocumentServlet: Database warm-up failed.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User authUser = (User) session.getAttribute("authUser");
        if (authUser == null) {
            String currentUrl = request.getRequestURI();
            if (request.getQueryString() != null) {
                currentUrl += "?" + request.getQueryString();
            }
            session.setAttribute("redirectAfterLogin", currentUrl);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/page/user/upload.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            User authUser = (User) session.getAttribute("authUser");
            if (authUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            String title = trim(request.getParameter("title"));
            String category = trim(request.getParameter("category"));
            String subject = trim(request.getParameter("subject"));
            String description = trim(request.getParameter("description"));
            Part filePart = request.getPart("documentFile");

            if (title.isEmpty() || category.isEmpty() || subject.isEmpty()) {
                forwardError(request, response, "Vui lòng nhập đầy đủ thông tin bắt buộc: Tiêu đề, Danh mục và Môn học.");
                return;
            }
            if (filePart == null || filePart.getSize() == 0) {
                forwardError(request, response, "Vui lòng chọn file tài liệu.");
                return;
            }
            if (filePart.getSize() > 50 * 1024 * 1024) {
                forwardError(request, response, "Tệp vượt quá kích thước tối đa cho phép (50MB). Vui lòng chọn tệp nhỏ hơn.");
                return;
            }

            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = getExtension(originalFileName);
            if (!ALLOWED_EXTENSIONS.contains(extension)) {
                forwardError(request, response, "Định dạng tệp không được hỗ trợ.");
                return;
            }

            boolean isSafe = simulateVirusScan(filePart);
            if (!isSafe) {
                forwardError(request, response, "Tệp không an toàn và đã bị từ chối.");
                return;
            }

            // UC5.1.10: Tải tệp lên Cloudinary
            java.util.Map<?, ?> uploadResult = vn.edu.hcmuaf.fit.websharedocument.util.CloudinaryUtil.getCloudinary().uploader().upload(
                    filePart.getInputStream().readAllBytes(),
                    com.cloudinary.utils.ObjectUtils.asMap(
                            "resource_type", "auto",
                            "public_id", "websharedoc_" + System.currentTimeMillis() + "_" + originalFileName.replaceAll("[^a-zA-Z0-9]", "_")
                    )
            );
            String secureUrl = (String) uploadResult.get("secure_url");

            Document doc = new Document();
            doc.setTitle(title);
            doc.setDescription(description);
            doc.setFilePath(secureUrl); 
            doc.setFileName(originalFileName);
            doc.setFileSize(filePart.getSize());
            doc.setFileType(filePart.getContentType() != null ? filePart.getContentType() : "application/octet-stream");
            doc.setFileExtension(extension);
            doc.setUserId(authUser.getId());

            Integer resolvedCategoryId = null;
            if (category != null && !category.isEmpty()) {
                if (category.matches("\\d+")) {
                    resolvedCategoryId = Integer.parseInt(category);
                } else {
                    resolvedCategoryId = findOrCreateCategoryId(category);
                }
            }
            doc.setCategoryId(resolvedCategoryId);
            doc.setIsActive(1);
            
            boolean saved = documentDAO.saveDocument(doc);
            if (saved) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"status\":\"success\",\"id\":" + doc.getId() + "}");
            } else {
                sendJsonError(response, "Lỗi khi lưu vào CSDL.");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonError(response, "Lỗi kỹ thuật: " + ex.getMessage());
        }
    }

    private Integer findOrCreateCategoryId(String categoryName) {
        if ("Giáo trình".equalsIgnoreCase(categoryName)) return 1;
        if ("Tài liệu tham khảo".equalsIgnoreCase(categoryName)) return 2;
        return null;
    }

    private boolean simulateVirusScan(Part filePart) {
        return !filePart.getSubmittedFileName().toLowerCase().contains("virus");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        String escaped = message.replace("\\", "\\\\").replace("\"", "\\\"");
        response.getWriter().write("{\"status\":\"error\",\"message\":\"" + escaped + "\"}");
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/page/user/upload.jsp").forward(request, response);
    }

    private String getExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot < 0 || lastDot == fileName.length() - 1) return "";
        return fileName.substring(lastDot + 1).toLowerCase(Locale.ROOT);
    }
}
