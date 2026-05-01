package com.sapati.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/home", "/about", "/contact", ""})
public class HomeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private com.sapati.dao.ContactDAO contactDAO;

    public void init() {
        contactDAO = new com.sapati.dao.ContactDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/about".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/Pages/about.jsp").forward(request, response);
        } else if ("/contact".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/Pages/contact.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/Pages/landing.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/contact".equals(path)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String subject = request.getParameter("subject");
            String messageText = request.getParameter("message");
            
            com.sapati.model.ContactMessage msg = new com.sapati.model.ContactMessage(name, email, subject, messageText);
            
            if (contactDAO.saveMessage(msg)) {
                response.sendRedirect(request.getContextPath() + "/contact?msg=sent");
            } else {
                request.setAttribute("error", "Could not send message. Please try again.");
                request.getRequestDispatcher("/WEB-INF/Pages/contact.jsp").forward(request, response);
            }
        } else {
            doGet(request, response);
        }
    }
}
