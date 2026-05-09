package vn.edu.hcmuaf.fit.websharedocument.controller;

import vn.edu.hcmuaf.fit.websharedocument.dao.UserDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/page/user/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email và mật khẩu!");
            request.getRequestDispatcher("/page/user/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.loginUser(email, password);
        if (user == null) {
            request.setAttribute("errorType", "invalid_credentials");
            request.getRequestDispatcher("/page/user/login.jsp").forward(request, response);
            return;
        }

        userDAO.updateLastLogin(user.getId());

        HttpSession session = request.getSession();
        session.setAttribute("authUser", user); // Lưu authUser dùng chung
        if ("admin".equals(user.getRole())) {
            session.setAttribute("adminUser", user); // Phục vụ cho AdminFilter
            response.sendRedirect(request.getContextPath() + "/page/overview.jsp");
        } else {
            // UC5.2.1.4: Chuyển hướng lại trang Upload nếu trước đó bị chặn
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null) {
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/page/user/home.jsp");
            }
        }
    }
}
