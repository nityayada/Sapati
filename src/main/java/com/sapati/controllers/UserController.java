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
import java.io.File;
import java.nio.file.Paths;
import java.util.UUID;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@WebServlet("/user")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            request.getSession().invalidate();
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
        } else if ("forgot_password".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
        } else if ("verify_reset_link".equals(action)) {
            String token = request.getParameter("token");
            if (token != null) {
                String decodedEmail = new String(java.util.Base64.getDecoder().decode(token));
                request.setAttribute("resetEmail", decodedEmail);
                request.getRequestDispatcher("/WEB-INF/pages/resetPassword.jsp").forward(request, response);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/user?action=login");
        } else if ("profile".equals(action)) {
            showProfile(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            registerUser(request, response);
        } else if ("login".equals(action)) {
            loginUser(request, response);
        } else if ("update_profile".equals(action)) {
            updateProfile(request, response);
        } else if ("update_password".equals(action)) {
            updatePassword(request, response);
        } else if ("initiate_recovery".equals(action)) {
            initiateRecovery(request, response);
        } else if ("verify_otp".equals(action)) {
            verifyOtp(request, response);
        } else if ("complete_reset".equals(action)) {
            completePasswordReset(request, response);
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String address = request.getParameter("address");

        if (phone == null || !phone.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isEmailTaken(email)) {
            request.setAttribute("error", "Email already registered!");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phone);
        user.setPasswordHash(password); // Will be hashed in DAO
        user.setAddress(address);
        user.setRole("Member");

        // Handle Profile Image Upload

        Part filePart = request.getPart("profile_image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + "_"
                    + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/images");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
            user.setProfileImage("images/" + fileName);
        } else {
            user.setProfileImage(""); // Set a default if not provided
        }
        if (userDAO.registerUser(user)) {
            // Send Welcome Email asynchronously to avoid delaying the response
            new Thread(() -> {
                com.sapati.util.EmailUtil.sendWelcomeEmail(email, fullName);
            }).start();

            response.sendRedirect(request.getContextPath() + "/user?action=login&msg=registered");
        } else {
            request.setAttribute("error", "Registration failed. Try again.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
        }
    }
   

    private void loginUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.loginUser(email, password);

        if (user != null) {
            if ("Locked".equals(user.getAccountStatus())) {
                request.setAttribute("error", "Account locked. Please contact admin.");
                request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("Admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/item?action=dashboard"); // Fixed to point to item
                                                                                            // controller or home
            }
        } else {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        // Refresh user data from DB
        User user = userDAO.getUserById(currentUser.getUserId());
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        String redirect = request.getParameter("redirect");
        String redirectPath = (redirect != null && !redirect.isEmpty()) ? redirect : "user?action=profile";

        if (phone == null || !phone.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits.");
            if (redirectPath.contains("admin")) {
                request.setAttribute("user", userDAO.getUserById(currentUser.getUserId()));
                request.getRequestDispatcher("/WEB-INF/pages/adminProfile.jsp").forward(request, response);
            } else {
                showProfile(request, response);
            }
            return;
        }

        User user = new User();
        user.setUserId(currentUser.getUserId());
        user.setFullName(fullName);
        user.setPhoneNumber(phone);
        user.setAddress(address);

        // Handle Profile Image Update
        Part filePart = request.getPart("profile_image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + "_"
                    + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/images");
            if (uploadPath == null) {
                // Fallback to absolute path or context root if real path fails
                uploadPath = getServletContext().getRealPath("/");
            }
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
            user.setProfileImage("images/" + fileName);
            currentUser.setProfileImage("images/" + fileName); // Update session object
        } else {
            // Keep existing image if no new one uploaded
            user.setProfileImage(currentUser.getProfileImage());
        }

        if (userDAO.updateUser(user)) {
            // Update session object too
            currentUser.setFullName(fullName);
            currentUser.setPhoneNumber(phone);
            currentUser.setAddress(address);
            session.setAttribute("user", currentUser);
            response.sendRedirect(request.getContextPath() + "/" + redirectPath + "&msg=profile_updated");
        } else {
            request.setAttribute("error", "Failed to update profile.");
            if (redirectPath.contains("admin")) {
                request.setAttribute("user", userDAO.getUserById(currentUser.getUserId()));
                request.getRequestDispatcher("/WEB-INF/pages/adminProfile.jsp").forward(request, response);
            } else {
                showProfile(request, response);
            }
        }
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        String redirect = request.getParameter("redirect");
        String redirectPath = (redirect != null && !redirect.isEmpty()) ? redirect : "user?action=profile";

        if (userDAO.updatePassword(currentUser.getUserId(), newPassword)) {
            response.sendRedirect(request.getContextPath() + "/" + redirectPath + "&msg=password_updated");
        } else {
            request.setAttribute("error", "Failed to update password.");
            if (redirectPath.contains("admin")) {
                request.setAttribute("user", userDAO.getUserById(currentUser.getUserId()));
                request.getRequestDispatcher("/WEB-INF/pages/adminProfile.jsp").forward(request, response);
            } else {
                showProfile(request, response);
            }
        }
    }

    private void initiateRecovery(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        User user = userDAO.getUserByEmail(email);

        if (user != null) {
            String otp = String.format("%06d", new java.util.Random().nextInt(999999));
            HttpSession session = request.getSession();
            session.setAttribute("resetOtp", otp);
            session.setAttribute("resetEmail", email);

            new Thread(() -> {
                com.sapati.util.EmailUtil.sendPasswordResetOtp(email, otp);
            }).start();

            request.getRequestDispatcher("/WEB-INF/pages/verifyOtp.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Email not found.");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
        }
    }

    private void verifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String savedOtp = (String) session.getAttribute("resetOtp");
        String resetEmail = (String) session.getAttribute("resetEmail");
        String enteredOtp = request.getParameter("otp");

        if (savedOtp != null && resetEmail != null && savedOtp.equals(enteredOtp)) {
            // OTP matches
            request.setAttribute("resetEmail", resetEmail);
            request.getRequestDispatcher("/WEB-INF/pages/resetPassword.jsp").forward(request, response);
        } else {
            // OTP doesn't match
            request.setAttribute("error", "Invalid verification code.");
            request.getRequestDispatcher("/WEB-INF/pages/verifyOtp.jsp").forward(request, response);
        }
    }

    private void completePasswordReset(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String resetEmail = (String) session.getAttribute("resetEmail");

        if (resetEmail == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        if (newPassword != null && newPassword.equals(confirmPassword)) {
            if (userDAO.updatePasswordByEmail(resetEmail, newPassword)) {
                // Clear session variables after successful reset
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetOtp");
                response.sendRedirect(request.getContextPath() + "/user?action=login&msg=password_reset_success");
            } else {
                request.setAttribute("error", "Failed to update password. Please try again.");
                request.getRequestDispatcher("/WEB-INF/pages/resetPassword.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/pages/resetPassword.jsp").forward(request, response);
        }
    }
}
