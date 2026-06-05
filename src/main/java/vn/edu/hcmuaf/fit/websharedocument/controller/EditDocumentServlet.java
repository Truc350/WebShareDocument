package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import vn.edu.hcmuaf.fit.websharedocument.service.FileStorage;
import vn.edu.hcmuaf.fit.websharedocument.service.DMS;
import java.util.Date;

@WebServlet("/edit-document")
public class EditDocumentServlet extends HttpServlet {

    private final DocumentDAO documentDAO = new DocumentDAO();
    private FileStorage storage;

    @Override
    public void init() throws ServletException {
        storage = new FileStorage(getServletContext().getRealPath("/document/uploads"));
    }
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        // UC15.1.1: User truy cập trang chi tiết tài liệu của mình và nhấp nút “Chỉnh sửa” (Trigger doGet)
        HttpSession session = request.getSession();

        // UC15.1.2: Hệ thống xác thực phiên đăng nhập hiện tại của User và kiểm tra quyền sở hữu tài liệu (UC-02)
        User authUser = (User) session.getAttribute("authUser");
        if (authUser == null) {
            authUser = (User) session.getAttribute("adminUser");
        }

        if (authUser == null) {
            String queryString = request.getQueryString();
            String fullUrl = request.getRequestURL().toString() + (queryString != null ? "?" + queryString : "");
            session.setAttribute("redirectAfterLogin", fullUrl);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = authUser;

        String idRaw = request.getParameter("id");

        if (idRaw == null) {
            response.sendRedirect("profile");
            return;
        }

        int documentId = Integer.parseInt(idRaw);

        if (!documentDAO.isOwner(documentId, user.getId())) {
            // UC15.2.1: User không có quyền chỉnh sửa (không phải chủ sở hữu tài liệu)
            // UC15.2.1.1: Hệ thống phát hiện tài liệu không thuộc quyền sở hữu của User đang đăng nhập.
            // UC15.2.1.2: Hệ thống hiển thị thông báo lỗi (ở đây dùng HTTP 403 Forbidden).
            // UC15.2.1.3: Chặn truy cập và không hiển thị form.
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // UC15.1.3: Hệ thống hiển thị form chỉnh sửa với các trường thông tin hiện tại của tài liệu
        Document doc = documentDAO.getDocumentByIdForEdit(documentId);

        request.setAttribute("document", doc);
        request.setAttribute("categories", documentDAO.getAllCategories());

        request.getRequestDispatcher("/page/user/edit-document.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        
        // UC15.1.4 & UC15.1.5: User chỉnh sửa một hoặc nhiều trường thông tin trên form và nhấp nút “Lưu thay đổi” (Trigger doPost)

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // UC15.1.2: Hệ thống xác thực phiên đăng nhập hiện tại của User và kiểm tra quyền sở hữu tài liệu (UC-02)
        User authUser = (User) session.getAttribute("authUser");
        if (authUser == null) {
            authUser = (User) session.getAttribute("adminUser");
        }

        if (authUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = authUser;

        int documentId = Integer.parseInt(request.getParameter("documentId"));

        if (!documentDAO.isOwner(documentId, user.getId())) {
            // UC15.2.1: User không có quyền chỉnh sửa (không phải chủ sở hữu tài liệu)
            // UC15.2.1.1: Hệ thống phát hiện tài liệu không thuộc quyền sở hữu của User đang đăng nhập.
            // UC15.2.1.2 & UC15.2.1.3: Trả về lỗi 403 Forbidden để chặn hành động cập nhật.
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // UC15.1.6: Hệ thống kiểm tra tính hợp lệ của dữ liệu nhập
        // UC15.2.2: Alternate Flow - Dữ liệu nhập không hợp lệ (nếu cần thiết sẽ chặn ở backend, hiện tại chủ yếu ở frontend)
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String categoryIdRaw = request.getParameter("categoryId");
        String privacy = request.getParameter("privacy");
        String tagsRaw = request.getParameter("tags");
        
        // Handle file replacement if any
        String secureUrl = request.getParameter("secureUrl");
        String newFileName = request.getParameter("newFileName");
        String newFileSizeRaw = request.getParameter("newFileSize");
        String newExtension = request.getParameter("newExtension");

        Integer categoryId = null;

        if (categoryIdRaw != null && !categoryIdRaw.isBlank()) {
            categoryId = Integer.parseInt(categoryIdRaw);
        }

        Document existingDoc = documentDAO.getDocumentByIdForEdit(documentId);
        int isActive = "public".equals(privacy) ? 1 : 0;
        if (existingDoc != null && existingDoc.getIsActive() == 2) {
            isActive = 2; // Giữ nguyên trạng thái Vi phạm để Admin duyệt lại từ tab Vi phạm
        }

        List<String> tags = tagsRaw == null || tagsRaw.isBlank()
                ? List.of()
                : Arrays.stream(tagsRaw.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .distinct()
                .toList();

        Document doc = new Document();

        doc.setId(documentId);
        doc.setUserId(user.getId());

        doc.setTitle(title);
        doc.setDescription(description);

        doc.setCategoryId(categoryId);

        doc.setIsActive(isActive);

        doc.setTags(tags);
        
        // Update file info if a new file was uploaded
        if (secureUrl != null && !secureUrl.isBlank() && newFileName != null && !newFileName.isBlank()) {
            // ── Kiểm tra an toàn tệp trước khi cho phép thay thế ────────────────────
            try {
                String secUrlTrimmed = secureUrl.trim();
                if (secUrlTrimmed.startsWith("http")) {
                    java.net.URL url = new java.net.URL(secUrlTrimmed);
                    java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    conn.setConnectTimeout(5000);
                    conn.setReadTimeout(5000);
                    conn.connect();
                    if (conn.getResponseCode() == 200) {
                        try (java.io.InputStream inStream = conn.getInputStream()) {
                            storage.checkFileSafety(inStream, newFileName.trim(), newExtension != null ? newExtension.trim() : "");
                        }
                    } else {
                        request.setAttribute("globalError", "Không thể truy cập tệp thay thế để kiểm tra an toàn.");
                        request.setAttribute("document", doc);
                        request.setAttribute("categories", documentDAO.getAllCategories());
                        request.getRequestDispatcher("/page/user/edit-document.jsp").forward(request, response);
                        return;
                    }
                }
            } catch (FileStorage.DangerousFileException e) {
                DMS dms = new DMS();
                dms.writeSecurityLog(documentId, user.getId(), "Edit file replace blocked: " + e.getMessage(), new Date().toString(), request.getRemoteAddr());
                
                request.setAttribute("globalError", "Tệp bị từ chối: nội dung không an toàn hoặc định dạng không hợp lệ.");
                request.setAttribute("document", doc);
                request.setAttribute("categories", documentDAO.getAllCategories());
                request.getRequestDispatcher("/page/user/edit-document.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("globalError", "Lỗi kiểm tra an toàn tệp: " + e.getMessage());
                request.setAttribute("document", doc);
                request.setAttribute("categories", documentDAO.getAllCategories());
                request.getRequestDispatcher("/page/user/edit-document.jsp").forward(request, response);
                return;
            }

            doc.setFilePath(secureUrl.trim());
            doc.setFileName(newFileName.trim());
            doc.setFileType("application/" + newExtension);
            doc.setFileExtension(newExtension != null ? newExtension.trim() : "");
            
            if (newFileSizeRaw != null && !newFileSizeRaw.isBlank()) {
                try {
                    doc.setFileSize(Long.parseLong(newFileSizeRaw.trim()));
                } catch (NumberFormatException e) {
                    doc.setFileSize(0L);
                }
            }
        }

        // UC15.1.7: Hệ thống cập nhật thông tin tài liệu vào cơ sở dữ liệu và ghi nhận thời điểm chỉnh sửa (updated_at)
        boolean success = documentDAO.updateDocumentInfo(doc);

        if (success) {

            // UC15.1.8: Hệ thống hiển thị thông báo “Cập nhật tài liệu thành công” và làm mới trang chi tiết tài liệu
            session.setAttribute(
                    "flashSuccess",
                    "Cập nhật tài liệu thành công!"
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/edit-document?id="
                            + documentId
            );

        } else {
            // Exception 1: Lỗi kết nối cơ sở dữ liệu hoặc có sự cố xảy ra
            request.setAttribute(
                    "globalError",
                    "Không thể cập nhật tài liệu."
            );
            request.setAttribute("document", doc);
            request.getRequestDispatcher("/page/user/edit-document.jsp")
                    .forward(request, response);
        }
    }
}