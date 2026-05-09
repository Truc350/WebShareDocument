package vn.edu.hcmuaf.fit.websharedocument.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;

import java.io.IOException;

@WebServlet("/admin/update-doc-status")
public class UpdateDocumentStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        int status = Integer.parseInt(req.getParameter("status"));

        DocumentDAO dao = new DocumentDAO();
        dao.updateDocumentStatus(id, status);

        // Sau khi cập nhật, quay về trang quản lý (giữ nguyên tab cũ nếu cần)
        String ref = req.getHeader("referer");
        resp.sendRedirect(ref != null ? ref : req.getContextPath() + "/admin/management-doc");
    }
}
