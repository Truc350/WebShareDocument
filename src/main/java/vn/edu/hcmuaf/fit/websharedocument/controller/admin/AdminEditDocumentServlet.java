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

@WebServlet("/admin/edit-doc")
public class AdminEditDocumentServlet extends HttpServlet {
    // 1. [UC17.1.7] Hiển thị Form chỉnh sửa
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User admin = (User) req.getSession().getAttribute("authUser");
        if (admin == null || !"admin".equals(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        DocumentDAO dao = new DocumentDAO();
        Document doc = dao.getDocumentByIdForEdit(id);

        req.setAttribute("doc", doc);
        req.setAttribute("listCategories", dao.getAllCategories());
        req.getRequestDispatcher("/page/admin/edit-document.jsp").forward(req, resp);
    }

    // 2. [UC17.1.8] Xử lý lưu thông tin
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User admin = (User) req.getSession().getAttribute("authUser");
        if (admin == null || !"admin".equals(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String catParam = req.getParameter("categoryId");
        if (catParam == null || catParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/management-doc");
            return;
        }
        int categoryId = Integer.parseInt(catParam);

        // Kiểm tra tính hợp lệ dữ liệu (Tiêu đề không rỗng, mô tả < 1000 ký tự)
        if (title == null || title.trim().isEmpty() || (description != null && description.length() > 1000)) {
            req.setAttribute("errorMessage", "Dữ liệu không hợp lệ. Tiêu đề không được để trống và mô tả không vượt quá 1000 ký tự.");
            DocumentDAO daoErr = new DocumentDAO();
            req.setAttribute("doc", daoErr.getDocumentByIdForEdit(id));
            req.setAttribute("listCategories", daoErr.getAllCategories());
            req.getRequestDispatcher("/page/admin/edit-document.jsp").forward(req, resp);
            return;
        }

        DocumentDAO dao = new DocumentDAO();
        if (dao.updateDocumentMetadata(id, title, description, categoryId)) {
            // [UC17.1.9] Thành công thì quay lại trang danh sách quản lý
            resp.sendRedirect(req.getContextPath() + "/admin/management-doc");
        } else {
            req.setAttribute("errorMessage", "Lỗi hệ thống! Không thể cập nhật cơ sở dữ liệu.");
            req.setAttribute("doc", dao.getDocumentByIdForEdit(id));
            req.setAttribute("listCategories", dao.getAllCategories());
            req.getRequestDispatcher("/page/admin/edit-document.jsp").forward(req, resp);
        }
    }
}
