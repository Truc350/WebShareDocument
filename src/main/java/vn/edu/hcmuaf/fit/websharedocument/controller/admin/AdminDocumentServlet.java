package vn.edu.hcmuaf.fit.websharedocument.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Category;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/management-doc")
public class AdminDocumentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DocumentDAO dao = new DocumentDAO();

        // 1. Nhận tab từ URL, nếu không có mặc định là -1 (Tab Tất cả)
        String tabParam = req.getParameter("tab");
        int currentTab = (tabParam != null && !tabParam.isEmpty()) ? Integer.parseInt(tabParam) : -1;

        // 2. Logic gọi dữ liệu theo Tab
        List<Document> listDocs;
        if (currentTab == -1) {
            listDocs = dao.getAllDocument(); // Lấy tất cả
        } else {
            listDocs = dao.getDocumentsByStatus(currentTab); // Lấy theo 0 (Chờ), 1 (Đã duyệt), 2 (Vi phạm)
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

        req.getRequestDispatcher("/page/management-doc.jsp").forward(req, resp);
    }
}
