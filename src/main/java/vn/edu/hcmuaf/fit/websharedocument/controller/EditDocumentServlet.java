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

/**
 * Controller xử lý yêu cầu chỉnh sửa thông tin tài liệu (UC15)
 * Địa chỉ truy cập: /edit-document
 */
@WebServlet("/edit-document")
public class EditDocumentServlet extends HttpServlet {

    private final DocumentDAO documentDAO = new DocumentDAO();
    private FileStorage storage;

    @Override
    public void init() throws ServletException {
        storage = new FileStorage(getServletContext().getRealPath("/document/uploads"));
    }

    /**
     * Xử lý yêu cầu lấy thông tin tài liệu và hiển thị giao diện Form sửa (GET)
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        
        // UC15.1.1: User truy cập Trang cá nhân, vào mục tài liệu đã tải lên, chọn tài liệu cần chỉnh sửa và bấm nút "Chỉnh sửa" (Kích hoạt doGet)
        HttpSession session = request.getSession();

        // UC15.1.2 & EX-02: Hệ thống xác thực phiên đăng nhập hiện tại của User
        User authUser = (User) session.getAttribute("authUser");
        if (authUser == null) {
            authUser = (User) session.getAttribute("adminUser");
        }

        if (authUser == null) {
            // EX-02: Timeout phiên làm việc – Hệ thống hiển thị thông báo hết phiên và chuyển hướng về trang đăng nhập.
            session.setAttribute("flashError", "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.");
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

        // EX-03: Tài liệu bị xóa trong khi đang chỉnh sửa – Hệ thống hiển thị thông báo "Tài liệu không còn tồn tại" và chuyển về Trang cá nhân.
        Document doc = documentDAO.getDocumentByIdForEdit(documentId);
        if (doc == null) {
            session.setAttribute("flashError", "Tài liệu không còn tồn tại.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // UC15.1.2 & UC15.2.1: Hệ thống kiểm tra quyền sở hữu tài liệu của User hiện tại
        if (!documentDAO.isOwner(documentId, user.getId())) {
            // UC15.2.1.1: Hệ thống phát hiện User đang cố tình truy cập chức năng chỉnh sửa tài liệu của người khác.
            // UC15.2.1.2: Hệ thống từ chối yêu cầu và thiết lập thông báo lỗi: "Bạn không có quyền chỉnh sửa tài liệu này."
            session.setAttribute("flashError", "Bạn không có quyền chỉnh sửa tài liệu này.");
            // UC15.2.1.3: Hệ thống chuyển hướng User về mục "Tài liệu của tôi" trong Trang cá nhân.
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // UC15.1.3: Hệ thống hiển thị form chỉnh sửa 2 cột (cột trái chứa các trường Tên, Mô tả, Danh mục, Tags, Trạng thái; cột phải là Live Preview Card)
        request.setAttribute("document", doc);
        request.setAttribute("categories", documentDAO.getAllCategories());

        request.getRequestDispatcher("/page/user/edit-document.jsp")
                .forward(request, response);
    }

    /**
     * Xử lý gửi Form cập nhật thông tin tài liệu lên hệ thống (POST)
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        
        // UC15.1.7: User nhấp nút "Lưu thay đổi" để xác nhận cập nhật thông tin tài liệu (Kích hoạt doPost)

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // UC15.1.2 & EX-02: Hệ thống xác thực phiên đăng nhập hiện tại của User
        User authUser = (User) session.getAttribute("authUser");
        if (authUser == null) {
            authUser = (User) session.getAttribute("adminUser");
        }

        if (authUser == null) {
            // EX-02: Timeout phiên làm việc
            session.setAttribute("flashError", "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = authUser;
        int documentId = Integer.parseInt(request.getParameter("documentId"));

        // EX-03: Tài liệu bị xóa bởi người khác trong khi đang chỉnh sửa
        Document existingDoc = documentDAO.getDocumentByIdForEdit(documentId);
        if (existingDoc == null) {
            session.setAttribute("flashError", "Tài liệu không còn tồn tại.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // UC15.1.2 & UC15.2.1: Hệ thống kiểm tra quyền sở hữu tài liệu
        if (!documentDAO.isOwner(documentId, user.getId())) {
            // UC15.2.1.2: Từ chối yêu cầu và thông báo lỗi
            session.setAttribute("flashError", "Bạn không có quyền chỉnh sửa tài liệu này.");
            // UC15.2.1.3: Chuyển hướng về trang profile
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // UC15.1.8 & UC15.2.2.1: Hệ thống kiểm tra tính hợp lệ của dữ liệu nhập
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String categoryIdRaw = request.getParameter("categoryId");
        String privacy = request.getParameter("privacy");
        String tagsRaw = request.getParameter("tags");

        boolean hasError = false;
        
        // Ràng buộc 1: Tên tài liệu không được để trống và độ dài ≤ 255 ký tự
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("titleError", "Tên tài liệu không được để trống.");
            hasError = true;
        } else if (title.length() > 255) {
            request.setAttribute("titleError", "Tên tài liệu không được vượt quá 255 ký tự.");
            hasError = true;
        }

        // Ràng buộc 2: Độ dài mô tả tài liệu ≤ 2000 ký tự
        if (description != null && description.length() > 2000) {
            request.setAttribute("descriptionError", "Mô tả không được vượt quá 2000 ký tự.");
            hasError = true;
        }

        // Ràng buộc 3: Định dạng tags hợp lệ (mỗi tag ≤ 50 ký tự và không chứa ký tự đặc biệt)
        List<String> tags = List.of();
        if (tagsRaw != null && !tagsRaw.isBlank()) {
            tags = Arrays.stream(tagsRaw.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .distinct()
                    .toList();
            
            String tagRegex = "^[a-zA-Z0-9\\sÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐđ\\-]+$";
            for (String tag : tags) {
                if (tag.length() > 50) {
                    request.setAttribute("tagsError", "Mỗi thẻ không được vượt quá 50 ký tự.");
                    hasError = true;
                    break;
                }
                if (!tag.matches(tagRegex)) {
                    request.setAttribute("tagsError", "Thẻ chứa ký tự không hợp lệ. Chỉ cho phép chữ, số, khoảng trắng và dấu gạch ngang.");
                    hasError = true;
                    break;
                }
            }
        }

        // UC15.2.2: Xử lý khi dữ liệu nhập không hợp lệ
        if (hasError) {
            // UC15.2.2.1: Trả về giao diện, highlight trường lỗi và giữ nguyên các thông tin đã nhập
            request.setAttribute("inputTitle", title);
            request.setAttribute("inputDescription", description);
            request.setAttribute("inputCategoryId", categoryIdRaw);
            request.setAttribute("inputPrivacy", privacy);
            request.setAttribute("inputTags", tagsRaw);
            
            request.setAttribute("document", existingDoc);
            request.setAttribute("categories", documentDAO.getAllCategories());
            request.getRequestDispatcher("/page/user/edit-document.jsp").forward(request, response);
            return;
        }
        
        // Xử lý tệp tin thay thế (nếu người dùng tải lên tệp mới)
        String secureUrl = request.getParameter("secureUrl");
        String newFileName = request.getParameter("newFileName");
        String newFileSizeRaw = request.getParameter("newFileSize");
        String newExtension = request.getParameter("newExtension");

        Integer categoryId = null;
        if (categoryIdRaw != null && !categoryIdRaw.isBlank()) {
            categoryId = Integer.parseInt(categoryIdRaw);
        }

        // Trạng thái công khai: "public" -> 1, "draft" -> 0
        int isActive = "public".equals(privacy) ? 1 : 0;
        if (existingDoc.getIsActive() == 2) {
            isActive = 2; // Giữ nguyên trạng thái Vi phạm để Admin duyệt lại từ tab Vi phạm
        }

        Document doc = new Document();
        doc.setId(documentId);
        doc.setUserId(user.getId());
        doc.setTitle(title);
        doc.setDescription(description);
        doc.setCategoryId(categoryId);
        doc.setIsActive(isActive);
        doc.setTags(tags);
        
        // Cập nhật thông tin tệp nếu người dùng thay thế tệp tin mới
        if (secureUrl != null && !secureUrl.isBlank() && newFileName != null && !newFileName.isBlank()) {
            // Kiểm tra tính an toàn của tệp tải lên
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
                        request.setAttribute("document", existingDoc);
                        request.setAttribute("categories", documentDAO.getAllCategories());
                        request.getRequestDispatcher("/page/user/edit-document.jsp").forward(request, response);
                        return;
                    }
                }
            } catch (FileStorage.DangerousFileException e) {
                // EX-02: Ghi nhận tệp nguy hiểm vào Security Log
                DMS dms = new DMS();
                dms.writeSecurityLog(documentId, user.getId(), "Edit file replace blocked: " + e.getMessage(), new Date().toString(), request.getRemoteAddr());
                
                request.setAttribute("globalError", "Tệp bị từ chối: nội dung không an toàn hoặc định dạng không hợp lệ.");
                request.setAttribute("document", existingDoc);
                request.setAttribute("categories", documentDAO.getAllCategories());
                request.getRequestDispatcher("/page/user/edit-document.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("globalError", "Lỗi kiểm tra an toàn tệp: " + e.getMessage());
                request.setAttribute("document", existingDoc);
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
        } else {
            // Giữ lại thông tin tệp cũ nếu không có tệp mới tải lên thay thế
            doc.setFilePath(existingDoc.getFilePath());
            doc.setFileName(existingDoc.getFileName());
            doc.setFileType(existingDoc.getFileType());
            doc.setFileExtension(existingDoc.getFileExtension());
            doc.setFileSize(existingDoc.getFileSize());
        }

        // UC15.1.9: Hệ thống cập nhật thông tin tài liệu vào cơ sở dữ liệu và ghi nhận thời điểm chỉnh sửa (updated_at)
        boolean success = false;
        try {
            success = documentDAO.updateDocumentInfo(doc);
        } catch (Exception e) {
            // EX-01: Lỗi kết nối cơ sở dữ liệu – Hệ thống hiển thị thông báo "Có lỗi xảy ra, vui lòng thử lại sau" và không lưu thay đổi.
            e.printStackTrace();
        }

        if (success) {
            // UC15.1.10: Hệ thống hiển thị thông báo "Cập nhật tài liệu thành công" và làm mới Trang cá nhân
            session.setAttribute("flashSuccess", "Cập nhật tài liệu thành công");
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            // EX-01: Lỗi lưu CSDL
            request.setAttribute("globalError", "Có lỗi xảy ra, vui lòng thử lại sau");
            request.setAttribute("document", existingDoc);
            request.setAttribute("categories", documentDAO.getAllCategories());
            request.getRequestDispatcher("/page/user/edit-document.jsp").forward(request, response);
        }
    }
}