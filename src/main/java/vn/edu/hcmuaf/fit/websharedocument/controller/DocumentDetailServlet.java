package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import java.io.IOException;

/**
 * Servlet xử lý yêu cầu xem chi tiết tài liệu.
 */
@WebServlet(name = "DocumentDetailServlet", value = "/document-detail")
public class DocumentDetailServlet extends HttpServlet {
    private DocumentDAO documentDAO;

    @Override
    public void init() throws ServletException {
        documentDAO = new DocumentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tài liệu không hợp lệ.");
            return;
        }
        Document document = documentDAO.getDocumentById(id);
        if (document == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài liệu.");
            return;
        }
        try {
            documentDAO.incrementViewCount(id);
        } catch (Exception ignored) {
        }
        request.setAttribute("document", document);
        request.getRequestDispatcher("/page/user/document-detail.jsp").forward(request, response);
    }
}
