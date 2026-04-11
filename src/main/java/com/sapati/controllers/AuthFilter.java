package com.sapati.controllers;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Allow access to public resources and login/register
        boolean isPublicPath = path.endsWith("login.jsp") || 
                              path.endsWith("register.jsp") || 
                              path.contains("/CSS/") || 
                              path.contains("/JS/") || 
                              path.contains("/Images/") ||
                              path.equals("/user") ||
                              path.equals("/index.jsp") ||
                              path.equals("/home") ||
                              path.equals("/about") ||
                              path.equals("/contact") ||
                              path.equals("/");

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn || isPublicPath) {
            chain.doFilter(request, response);
        } else {
            // Forward (instead of redirect) because WEB-INF is private
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
