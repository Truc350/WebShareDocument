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

        HttpSession session = request.getSession();

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
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

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

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

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
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

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
        
        // Update file info if a new file was uploaded
        if (secureUrl != null && !secureUrl.isBlank() && newFileName != null && !newFileName.isBlank()) {
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

            request.getRequestDispatcher("/page/user/edit-document.jsp")
                    .forward(request, response);
        }
    }
}