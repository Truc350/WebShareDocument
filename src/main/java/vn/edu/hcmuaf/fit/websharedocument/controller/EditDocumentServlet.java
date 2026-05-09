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

@WebServlet("/edit-document")
public class EditDocumentServlet extends HttpServlet {

    private final DocumentDAO documentDAO = new DocumentDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        String idRaw = request.getParameter("id");

        if (idRaw == null) {
            response.sendRedirect("profile");
            return;
        }

        int documentId = Integer.parseInt(idRaw);

        if (!documentDAO.isOwner(documentId, user.getId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Document doc = documentDAO.getDocumentById(documentId);

        request.setAttribute("document", doc);
        request.setAttribute("categories", documentDAO.getAllCategories());

        request.getRequestDispatcher("/edit-document.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        int documentId = Integer.parseInt(request.getParameter("documentId"));

        if (!documentDAO.isOwner(documentId, user.getId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String categoryIdRaw = request.getParameter("categoryId");
        String privacy = request.getParameter("privacy");
        String tagsRaw = request.getParameter("tags");

        Integer categoryId = null;

        if (categoryIdRaw != null && !categoryIdRaw.isBlank()) {
            categoryId = Integer.parseInt(categoryIdRaw);
        }

        int isActive = "public".equals(privacy) ? 1 : 0;

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

        boolean success = documentDAO.updateDocumentInfo(doc);

        if (success) {

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

            request.setAttribute(
                    "globalError",
                    "Không thể cập nhật tài liệu."
            );

            request.setAttribute("document", doc);

            request.getRequestDispatcher("/edit-document.jsp")
                    .forward(request, response);
        }
    }
}