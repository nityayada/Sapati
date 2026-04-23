package com.sapati.controllers;

import com.sapati.dao.UserDAO;
import com.sapati.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            request.getSession().invalidate();
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
        } else if ("profile".equals(action)) {
            showProfile(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            registerUser(request, response);
        } else if ("login".equals(action)) {
            loginUser(request, response);
        } else if ("update_profile".equals(action)) {
            updateProfile(request, response);
        } else if ("update_password".equals(action)) {
            updatePassword(request, response);
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String address = request.getParameter("address");

        if (userDAO.isEmailTaken(email)) {
            request.setAttribute("error", "Email already registered!");
            request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phone);
        user.setPasswordHash(password); // Will be hashed in DAO
        user.setAddress(address);
        user.setRole("Member");

        if (userDAO.registerUser(user)) {
            request.setAttribute("msg", "registered");
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Try again.");
            request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
        }
    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.loginUser(email, password);

        if (user != null) {
            if ("Locked".equals(user.getAccountStatus())) {
                request.setAttribute("error", "Account locked. Please contact admin.");
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("Admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/item?action=dashboard"); // Fixed to point to item controller or home
            }
        } else {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            }
        }
    private void showProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }
        
        // Refresh user data from DB
        User user = userDAO.getUserById(currentUser.getUserId());
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/Pages/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        User user = new User();
        user.setUserId(currentUser.getUserId());
        user.setFullName(fullName);
        user.setPhoneNumber(phone);
        user.setAddress(address);

        if (userDAO.updateUser(user)) {
            // Update session object too
            currentUser.setFullName(fullName);
            session.setAttribute("user", currentUser);
            response.sendRedirect(request.getContextPath() + "/user?action=profile&msg=profile_updated");
        } else {
            request.setAttribute("error", "Failed to update profile.");
            showProfile(request, response);
        }
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            showProfile(request, response);
            return;
        }

        if (userDAO.updatePassword(currentUser.getUserId(), newPassword)) {
            response.sendRedirect(request.getContextPath() + "/user?action=profile&msg=password_updated");
        } else {
            request.setAttribute("error", "Failed to update password.");
            showProfile(request, response);
        }
    }
}
