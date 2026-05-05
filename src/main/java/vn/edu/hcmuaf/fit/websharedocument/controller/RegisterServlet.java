package vn.edu.hcmuaf.fit.websharedocument.controller;

import vn.edu.hcmuaf.fit.websharedocument.dao.UserDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", value = "/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/page/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone"); // Sử dụng phone làm username
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate cơ bản
        if (fullName == null || email == null || phone == null || password == null || confirmPassword == null ||
            fullName.isEmpty() || email.isEmpty() || phone.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            request.getRequestDispatcher("/page/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/page/register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem số điện thoại (username) hoặc email đã tồn tại chưa
        if (userDAO.checkUserExist(phone, email)) {
            request.setAttribute("error", "Số điện thoại hoặc Email đã được sử dụng!");
            request.getRequestDispatcher("/page/register.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng User
        User newUser = new User();
        newUser.setUsername(phone); // Dùng số điện thoại làm username
        newUser.setEmail(email);
        newUser.setPassword(password); // Nên mã hóa (vd BCrypt) trong thực tế
        newUser.setFullName(fullName);

        // Đăng ký
        boolean isRegistered = userDAO.registerUser(newUser);

        if (isRegistered) {
            // Chuyển hướng sang trang đăng nhập, kèm thông báo thành công
            request.getSession().setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/page/login.jsp");
        } else {
            request.setAttribute("error", "Đăng ký thất bại, vui lòng thử lại sau!");
            request.getRequestDispatcher("/page/register.jsp").forward(request, response);
        }
    }
}
