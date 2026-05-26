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
            String description = trim(request.getParameter("description"));
            String secureUrl = trim(request.getParameter("secureUrl"));
            String originalFileName = trim(request.getParameter("fileName"));
            long fileSize = Long.parseLong(trim(request.getParameter("fileSize")));
            String extension = trim(request.getParameter("extension"));

            if (secureUrl.isEmpty() || originalFileName.isEmpty()) {
                forwardError(request, response, "Lỗi: Không nhận được thông tin file từ trình duyệt.");
                return;
            }

            // ── Kiểm tra an toàn tệp trước khi lưu vào CSDL ────────────────────
            try {
                if (secureUrl.startsWith("http")) {
                    java.net.URL url = new java.net.URL(secureUrl);
                    java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    conn.setConnectTimeout(5000);
                    conn.setReadTimeout(5000);
                    conn.connect();
                    if (conn.getResponseCode() == 200) {
                        try (java.io.InputStream inStream = conn.getInputStream()) {
                            storage.checkFileSafety(inStream, originalFileName, extension);
                        }
                    } else {
                        sendJsonError(response, "Lỗi: Không thể truy cập tệp đã tải lên để kiểm tra an toàn.");
                        return;
                    }
                }
            } catch (FileStorage.DangerousFileException e) {
                DMS dms = new DMS();
                dms.writeSecurityLog(0, authUser.getId(), "Upload blocked: " + e.getMessage(), new Date().toString(), request.getRemoteAddr());
                sendJsonError(response, "Tệp bị từ chối: nội dung không an toàn hoặc định dạng không hợp lệ.");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                sendJsonError(response, "Lỗi kiểm tra an toàn tệp: " + e.getMessage());
                return;
            }

            Document doc = new Document();
            doc.setTitle(title);
            doc.setDescription(description);
            doc.setFilePath(secureUrl); 
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
                // Lỗi ghi CSDL
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
