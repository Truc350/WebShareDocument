package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
    private static final DateTimeFormatter FILE_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
    private DocumentDAO documentDAO;
    private Path uploadDirPath;

    @Override
    public void init() throws ServletException {
        documentDAO = new DocumentDAO();
        // UC5.1.10: Khởi tạo đường dẫn lưu trữ ngay khi server khởi động để tăng tốc độ cho lần gọi đầu tiên
        this.uploadDirPath = resolveUploadDir();
        try {
            Files.createDirectories(this.uploadDirPath);
        } catch (IOException e) {
            getServletContext().log("Could not create upload directory: " + this.uploadDirPath, e);
        }
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
        // UC5.1.2: Hệ thống xác thực phiên đăng nhập
        HttpSession session = request.getSession();
        User authUser = (User) session.getAttribute("authUser");
        if (authUser == null) {
            // UC5.2.1.2: Lưu URL, chuyển hướng Login
            String currentUrl = request.getRequestURI();
            if (request.getQueryString() != null) {
                currentUrl += "?" + request.getQueryString();
            }
            session.setAttribute("redirectAfterLogin", currentUrl);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // UC5.1.2: Hiển thị form đăng tải
        request.getRequestDispatcher("/page/user/upload.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        // UC5.1.7: Hệ thống kiểm tra tính hợp lệ của toàn bộ form
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
            // Thiếu thông tin bắt buộc
            if (title.isEmpty() || category.isEmpty() || subject.isEmpty()) {
                forwardError(request, response, "Vui lòng nhập đầy đủ thông tin bắt buộc: Tiêu đề, Danh mục và Môn học.");
                return;
            }
            // UC5.1.7: Kiểm tra file tồn tại
            if (filePart == null || filePart.getSize() == 0) {
                forwardError(request, response, "Vui lòng chọn file tài liệu.");
                return;
            }
            // Kích thước tệp vượt quá giới hạn 50MB
            if (filePart.getSize() > 50 * 1024 * 1024) {
                forwardError(request, response, "Tệp vượt quá kích thước tối đa cho phép (50MB). Vui lòng chọn tệp nhỏ hơn.");
                return;
            }
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = getExtension(originalFileName);
            // Định dạng tệp không được hỗ trợ
            if (!ALLOWED_EXTENSIONS.contains(extension)) {
                forwardError(request, response, "Định dạng tệp không được hỗ trợ. Chỉ chấp nhận PDF, DOCX, PPTX, XLSX, TXT, PNG, JPG.");
                return;
            }
            // UC5.1.9: Hệ thống thực hiện quét virus/malware trên tệp
            boolean isSafe = simulateVirusScan(filePart);
            if (!isSafe) {
                // Phát hiện virus/malware trong tệp tải lên
                forwardError(request, response, "Tệp không an toàn và đã bị từ chối.");
                return;
            }
            // UC5.1.10: Sử dụng đường dẫn đã được khởi động sẵn (Pre-initialized)
            String storedFileName = buildStoredFileName(originalFileName, extension);
            Path targetFile = this.uploadDirPath.resolve(storedFileName);
            // UC5.1.10: Lưu tệp vào File Storage System
            Files.copy(filePart.getInputStream(), targetFile, StandardCopyOption.REPLACE_EXISTING);
            // UC5.1.10: Hệ thống ghi metadata vào cơ sở dữ liệu
            Document doc = new Document();
            doc.setTitle(title);
            doc.setDescription(description);
            Integer resolvedCategoryId = null;
            if (category != null && !category.isEmpty()) {
                try {
                    if (category.matches("\\d+")) {
                        resolvedCategoryId = Integer.parseInt(category);
                    } else {
                        resolvedCategoryId = findOrCreateCategoryId(category);
                    }
                } catch (Exception e) {
                    resolvedCategoryId = null;
                }
            }
            doc.setCategoryId(resolvedCategoryId);
            doc.setFileName(originalFileName);
            doc.setFilePath(storedFileName);
            doc.setFileSize(filePart.getSize());
            doc.setFileType(filePart.getContentType() != null
                    ? filePart.getContentType().substring(0, Math.min(filePart.getContentType().length(), 100))
                    : "application/octet-stream");
            doc.setFileExtension(extension);
            doc.setUserId(authUser.getId());
            doc.setViewCount(0);
            doc.setDownloadCount(0);
            doc.setIsActive(1); // UC5.1.10: Luôn đặt là hoạt động khi mới tải lên
            boolean saved = documentDAO.saveDocument(doc);
            if (saved) {
                // UC5.1.11: Trả về JSON thành công để AJAX xử lý chuyển hướng
                response.setContentType("application/json; charset=UTF-8");
                response.setHeader("X-Upload-Status", "success");
                response.getWriter().write("{\"status\":\"success\",\"id\":" + doc.getId() + "}");
            } else {
                sendJsonError(response, "Lỗi khi lưu thông tin vào cơ sở dữ liệu. Vui lòng thử lại sau.");
            }
        } catch (IllegalStateException ex) {
            sendJsonError(response, "Tệp vượt quá kích thước tối đa cho phép (50MB).");
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

    // Hệ thống thực hiện quét virus/malware
    private boolean simulateVirusScan(Part filePart) {
        // Tên file chứa "virus"
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
        // UC5.1.11 Dữ liệu người dùng đã nhập trong form
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/page/user/upload.jsp").forward(request, response);
    }

    private String getExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot < 0 || lastDot == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(lastDot + 1).toLowerCase(Locale.ROOT);
    }

    private String buildStoredFileName(String originalFileName, String extension) {
        String baseName = originalFileName.substring(0, originalFileName.length() - (extension.isEmpty() ? 0 : extension.length() + 1))
                .replaceAll("[^a-zA-Z0-9._-]", "_");
        String timestamp = LocalDateTime.now().format(FILE_TIME_FORMAT);
        return timestamp + "_" + baseName + "." + extension;
    }

    private Path resolveUploadDir() {
        String realPath = getServletContext().getRealPath("/document/uploads");
        if (realPath != null) {
            return Paths.get(realPath);
        }
        return Paths.get(System.getProperty("user.home"), "DocShareUploads");
    }
}
