package vn.edu.hcmuaf.fit.websharedocument.controller;

import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProfileServlet", value = "/profile")
public class ProfileServlet extends HttpServlet {
    private DocumentDAO documentDAO;

    @Override
    public void init() {
        documentDAO = new DocumentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User authUser = (User) session.getAttribute("authUser");
        if (authUser == null) {
            authUser = (User) session.getAttribute("adminUser");
        }

        if (authUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = authUser.getId();

        // Get user's documents
        List<Document> myDocuments = documentDAO.getDocumentsByUserId(userId);
        request.setAttribute("myDocuments", myDocuments);

        // Get counts
        int totalDocuments = documentDAO.getTotalDocumentsByUserId(userId);
        request.setAttribute("totalDocuments", totalDocuments);

        int totalDownloads = documentDAO.getTotalDownloadsByUserId(userId);
        request.setAttribute("totalDownloads", totalDownloads);

        request.getRequestDispatcher("/page/user/profile.jsp").forward(request, response);
    }
}
