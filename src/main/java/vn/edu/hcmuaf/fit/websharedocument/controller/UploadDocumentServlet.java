package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.db.DBConnect;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Statement;
import vn.edu.hcmuaf.fit.websharedocument.service.FileStorage;
import vn.edu.hcmuaf.fit.websharedocument.service.DMS;
import java.util.Date;

@WebServlet(name = "UploadDocumentServlet", value = "/upload", loadOnStartup = 1)
@MultipartConfig(
        fileSizeThreshold = 10 * 1024 * 1024,
        maxFileSize = 50L * 1024L * 1024L,
        maxRequestSize = 60L * 1024L * 1024L
)
public class UploadDocumentServlet extends HttpServlet {
    private DocumentDAO documentDAO;
    private FileStorage storage;

    @Override
    public void init() throws ServletException {
        documentDAO = new DocumentDAO();
        storage = new FileStorage(getServletContext().getRealPath("/document/uploads"));
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
        // UC5.1.2: Hệ thống xác thực phiên đăng nhập và hiển thị form đăng tải tài liệu.
        HttpSession session = request.getSession();
        User authUser = (User) session.getAttribute("authUser");
        boolean isHeadRequest = "HEAD".equalsIgnoreCase(request.getMethod());

        if (authUser == null) {
            // UC5.2.1.1: Hệ thống phát hiện người dùng chưa có phiên đăng nhập.
            // UC5.2.1.2: Hệ thống lưu URL hiện tại /upload vào thuộc tính session redirectAfterLogin.
            if (!isHeadRequest) {
                String currentUrl = request.getRequestURI();
                if (request.getQueryString() != null) {
                    currentUrl += "?" + request.getQueryString();
                }
                session.setAttribute("redirectAfterLogin", currentUrl);
            }
            // UC5.2.1.3: Hệ thống điều hướng người dùng đến trang Đăng nhập.
            if (isHeadRequest) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }
        // UC5.1.2: Hiển thị form đăng tải tài liệu
        request.getRequestDispatcher("/page/user/upload.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            User authUser = (User) session.getAttribute("authUser");
            if (authUser == null) {
                sendJsonError(response, "Vui lòng đăng nhập lại.");
                return;
            }

            // Lấy thông tin về Chunk hiện tại từ JavaScript truyền lên
            String chunkIndexStr = request.getParameter("chunkIndex");
            if (chunkIndexStr == null) {
                sendJsonError(response, "Yêu cầu không hợp lệ. Lỗi Chunked Upload.");
                return;
            }

            int chunkIndex = Integer.parseInt(chunkIndexStr);
            int totalChunks = Integer.parseInt(request.getParameter("totalChunks"));
            String fileId = trim(request.getParameter("fileId"));
            String originalFileName = trim(request.getParameter("fileName"));
            Part fileChunk = request.getPart("fileChunk");

            // Tạo thư mục tạm trên Server (nếu chưa có)
            String uploadDirPath = getServletContext().getRealPath("/document/uploads");
            java.io.File uploadDir = new java.io.File(uploadDirPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // Lắp ráp file: Nối chunk mới vào đuôi file tạm (.part)
            java.io.File tempFile = new java.io.File(uploadDir, fileId + ".part");
            try (java.io.InputStream is = fileChunk.getInputStream();
                 java.io.FileOutputStream fos = new java.io.FileOutputStream(tempFile, true)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }

            // Nếu đây là chunk cuối cùng -> Xử lý lưu DB và kiểm tra bảo mật
            if (chunkIndex == totalChunks - 1) {
                String title = trim(request.getParameter("title"));
                String category = trim(request.getParameter("category"));
                String description = trim(request.getParameter("description"));
                long fileSize = Long.parseLong(trim(request.getParameter("fileSize")));
                String extension = trim(request.getParameter("extension"));

                // Đổi tên file: bỏ đuôi .part đi thành file hoàn chỉnh
                java.io.File finalFile = new java.io.File(uploadDir, fileId);
                tempFile.renameTo(finalFile);

                // ── Kiểm tra an toàn tệp trước khi lưu vào CSDL ────────────────────
                try (java.io.InputStream checkStream = new java.io.FileInputStream(finalFile)) {
                    storage.checkFileSafety(checkStream, originalFileName, extension);
                } catch (FileStorage.DangerousFileException e) {
                    finalFile.delete(); // Xóa ngay file nếu phát hiện nguy hiểm
                    DMS dms = new DMS();
                    dms.writeSecurityLog(0, authUser.getId(), "Upload blocked: " + e.getMessage(), new Date().toString(), request.getRemoteAddr());
                    sendJsonError(response, "Tệp bị từ chối: nội dung không an toàn hoặc định dạng không hợp lệ.");
                    return;
                } catch (Exception e) {
                    finalFile.delete();
                    e.printStackTrace();
                    sendJsonError(response, "Lỗi kiểm tra an toàn tệp: " + e.getMessage());
                    return;
                }

                Document doc = new Document();
                doc.setTitle(title);
                doc.setDescription(description);
                // Lưu đường dẫn cục bộ trên Server
                doc.setFilePath("/document/uploads/" + fileId);
                doc.setFileName(originalFileName);
                doc.setFileSize(fileSize);
                doc.setFileType("application/" + extension);
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
                doc.setIsActive(0);

                // UC5.1.11: Hệ thống lưu dữ liệu vào database, hiển thị thông báo thành công và điều hướng người dùng về Trang cá nhân.
                boolean saved = documentDAO.saveDocument(doc);
                if (saved) {
                    // UC5.1.11: Trả về trạng thái thành công cho trình duyệt
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"status\":\"success\",\"id\":" + doc.getId() + "}");
                } else {
                    finalFile.delete(); // Xóa file rác trên server nếu việc lưu CSDL thất bại
                    sendJsonError(response, "Lỗi khi lưu vào CSDL.");
                }
            } else {
                // Phản hồi thành công cho 1 chunk để Client (JS) gửi tiếp chunk tiếp theo
                response.getWriter().write("{\"status\":\"chunk_success\"}");
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
}
