package vn.edu.hcmuaf.fit.websharedocument.controller.admin;

import vn.edu.hcmuaf.fit.websharedocument.dao.UserDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AdminLoginServlet", value = "/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            // Nếu đã đăng nhập thì chuyển thẳng tới trang chủ admin
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        
        // Chuyển hướng tới trang đăng nhập (tạo một trang jsp tại /admin/login.jsp)
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Thiết lập encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Gọi DAO để kiểm tra user
        User adminUser = userDAO.loginAdmin(username, password);

        if (adminUser != null) {
            // Cập nhật last login
            userDAO.updateLastLogin(adminUser.getId());

            // Lưu session
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", adminUser);

            // Chuyển hướng đến Dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            // Đăng nhập thất bại
            request.setAttribute("error", "Tên đăng nhập, mật khẩu không đúng hoặc bạn không có quyền Admin!");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}
