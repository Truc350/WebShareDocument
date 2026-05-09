package vn.edu.hcmuaf.fit.websharedocument.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Category;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/management-doc")
public class AdminDocumentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. [SR-04] BẢO MẬT: Xác thực Session, chỉ cho phép Admin truy cập
        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("authUser");
        if (admin == null || !"admin".equals(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        DocumentDAO dao = new DocumentDAO();

        // 2. Nhận tab từ URL, mặc định ưu tiên Tab Chờ duyệt (0) để Admin xử lý trước
        String tabParam = req.getParameter("tab");
        int currentTab = (tabParam != null && !tabParam.isEmpty()) ? Integer.parseInt(tabParam) : 0;

        // 3. [SR-11] Bắt tham số tìm kiếm từ thanh Search
        String keyword = req.getParameter("q");

        // 4. Logic gọi dữ liệu theo Tab
        List<Document> listDocs;
        if (currentTab == -1) {
            listDocs = dao.getAllDocument(); // Lấy tất cả
        } else {
            listDocs = dao.getDocumentsByStatus(currentTab); // Lấy theo 0 (Chờ), 1 (Đã duyệt), 2 (Vi phạm)
        }

        // 5. [SR-11] Lọc trực tiếp danh sách nếu Admin có nhập từ khóa tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            String finalKeyword = keyword.toLowerCase();
            listDocs.removeIf(doc -> !doc.getFileName().toLowerCase().contains(finalKeyword));
        }

        List<Category> listCategories = dao.getAllCategories();

        int pendingDocs = dao.countDocumentsByStatus(0);
        int approvedDocs = dao.countDocumentsByStatus(1);
        int violationDocs = dao.countDocumentsByStatus(2);
        int totalDocs = dao.countTotalDocuments();

        req.setAttribute("listDocs", listDocs);
        req.setAttribute("currentTab", currentTab);
        req.setAttribute("listCategories", listCategories);
        req.setAttribute("pendingDocs", pendingDocs);
        req.setAttribute("approvedDocs", approvedDocs);
        req.setAttribute("violationDocs", violationDocs);
        req.setAttribute("totalDocs", totalDocs);
        req.setAttribute("searchKeyword", keyword);

        req.getRequestDispatcher("/page/management-doc.jsp").forward(req, resp);
    }
}
