package com.sapati.controllers;

import com.sapati.dao.UserDAO;
import com.sapati.dao.ItemDAO;
import com.sapati.model.User;
import com.sapati.model.Item;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private ItemDAO itemDAO;

    public void init() {
        userDAO = new UserDAO();
        itemDAO = new ItemDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("manage_items".equals(action)) {
            List<Item> items = itemDAO.getAllAvailableItems();
            request.setAttribute("items", items);
            request.getRequestDispatcher("/WEB-INF/Pages/manageItems.jsp").forward(request, response);
        } else {
            // Default to dashboard
            request.getRequestDispatcher("/WEB-INF/Pages/adminDashboard.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("approve_item".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("item_id"));
            // itemDAO.updateStatus(itemId, "Available"); // Need to implement this DAO method
            response.sendRedirect(request.getContextPath() + "/admin?action=manage_items");
        }
    }
}
