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
        doGet(request, response);
    }
}
