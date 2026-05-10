package vn.edu.hcmuaf.fit.websharedocument.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.io.IOException;

@WebServlet("/admin/update-doc-status")
public class UpdateDocumentStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User admin = (User) req.getSession().getAttribute("authUser");
        int id = Integer.parseInt(req.getParameter("id"));
        int status = Integer.parseInt(req.getParameter("status"));

        DocumentDAO dao = new DocumentDAO();

        // [UC17.1.11] Thực hiện cập nhật trạng thái trong DB
        if (dao.updateDocumentStatus(id, status)) {
            String actionName = (status == 1) ? "APPROVE_DOCUMENT" : "DELETE_VIOLATION";
            String detail = (status == 1) ? "Admin duyệt tài liệu" : "Admin xóa tài liệu vi phạm";

            // [UC17.1.11] Ghi Audit Log thao tác của Admin
            dao.logActivity(admin.getId(), actionName, "document", id, detail, req.getRemoteAddr());

            // [UC17.1.12] Gửi thông báo thành công (có thể qua Session)
            req.getSession().setAttribute("message", "Thao tác thành công!");
        }

        // Quay lại trang danh sách (Tự động cập nhật lại danh sách - UC17.1.12)
        resp.sendRedirect(req.getContextPath() + "/admin/management-doc");
    }
}
