package vn.edu.hcmuaf.fit.websharedocument.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.io.IOException;

@WebServlet("/admin/update-doc-status")
public class UpdateDocumentStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User admin = (User) req.getSession().getAttribute("authUser");
        if (admin == null || !"admin".equals(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        int status = Integer.parseInt(req.getParameter("status"));

        DocumentDAO dao = new DocumentDAO();

        if (status == 1 || status == 2) {
            // [UC17.1.11] / [UC17.2.5.2] Thực hiện cập nhật trạng thái trong DB
            if (dao.updateDocumentStatus(id, status)) {
                String actionName = (status == 1) ? "APPROVE_DOCUMENT" : "MARK_VIOLATION";
                String detail = (status == 1) ? "Admin duyệt tài liệu" : "Admin đánh dấu tài liệu vi phạm";

                // [UC17.1.11] / [UC17.2.5.2] Ghi Audit Log thao tác của Admin
                dao.logActivity(admin.getId(), actionName, "document", id, detail, req.getRemoteAddr());

                // [UC17.1.12] / [UC17.2.5.2] Gửi thông báo thành công
                req.getSession().setAttribute("message", "Thao tác thành công!");
            }
        } else if (status == 3) {
            // [UC17.2.6.2] Admin xóa vĩnh viễn tài liệu khỏi hệ thống
            Document doc = dao.getDocumentByIdForEdit(id);
            if (doc != null) {
                // 1. Xóa file khỏi Supabase Storage
                String fileUrl = doc.getFilePath();
                if (fileUrl != null && fileUrl.contains("/object/public/documents/")) {
                    String objectPath = fileUrl.substring(fileUrl.indexOf("/object/public/documents/") + "/object/public/documents/".length());
                    deleteFileFromSupabase(objectPath);
                }

                // 2. Xóa khỏi database
                if (dao.deleteDocumentByAdmin(id)) {
                    // [UC17.2.6.3] Ghi audit log đầy đủ
                    dao.logActivity(admin.getId(), "DELETE_PERMANENTLY", "document", id, "Admin xóa vĩnh viễn tài liệu do vẫn vi phạm", req.getRemoteAddr());
                    req.getSession().setAttribute("message", "Xóa tài liệu vi phạm vĩnh viễn thành công!");
                } else {
                    req.getSession().setAttribute("message", "Lỗi: Không thể xóa tài liệu khỏi Database.");
                }
            }
        }

        // Quay lại trang danh sách (Tự động cập nhật lại danh sách - UC17.1.12)
        resp.sendRedirect(req.getContextPath() + "/admin/management-doc");
    }

    // [UC17.2.6.2] Xóa tệp từ Supabase Storage
    private boolean deleteFileFromSupabase(String objectPath) {
        String supabaseUrl = "https://tlbznphszzpondlykmst.supabase.co";
        String supabaseKey = "sb_publishable_3IaZByYoSWSHakJqFMOifQ_ud2mNCpg";
        String bucketName = "documents";

        try {
            java.net.URL url = new java.net.URL(supabaseUrl + "/storage/v1/object/" + bucketName + "/" + objectPath);
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("DELETE");
            conn.setRequestProperty("Authorization", "Bearer " + supabaseKey);
            conn.setRequestProperty("apikey", supabaseKey);

            int responseCode = conn.getResponseCode();
            if (responseCode >= 200 && responseCode < 300) {
                try (java.io.InputStream is = conn.getInputStream()) {
                    is.readAllBytes();
                }
                return true;
            } else {
                try (java.io.InputStream err = conn.getErrorStream()) {
                    if (err != null) err.readAllBytes();
                }
                System.err.println("Failed to delete from Supabase: HTTP " + responseCode);
                return false;
            }
        } catch (Exception e) {
            System.err.println("Exception while deleting from Supabase: " + e.getMessage());
            return false;
        }
    }
}
