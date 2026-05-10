package vn.edu.hcmuaf.fit.websharedocument.controller;

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
import java.util.Map;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {
    private DocumentDAO documentDAO;

    @Override
    public void init() throws ServletException {
        documentDAO = new DocumentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch stats
        Map<String, Integer> stats = documentDAO.getHomepageStats();
        request.setAttribute("stats", stats);

        // Fetch featured documents (Top 3)
        List<Document> featuredDocs = documentDAO.getFeaturedDocuments(3);
        if (featuredDocs != null && !featuredDocs.isEmpty()) {
            request.setAttribute("mainFeatured", featuredDocs.get(0));
            if (featuredDocs.size() > 1) {
                request.setAttribute("subFeatured", featuredDocs.subList(1, featuredDocs.size()));
            }
        }

        // Fetch categories
        List<Category> categories = documentDAO.getAllCategories();
        request.setAttribute("categories", categories);

        // Forward to JSP
        request.getRequestDispatcher("/page/user/home.jsp").forward(request, response);
    }
}
