package com.sapati.controllers;

import com.sapati.dao.UserDAO;
import com.sapati.dao.ItemDAO;
import com.sapati.dao.BorrowDAO;
import com.sapati.dao.FineDAO;
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
    private BorrowDAO borrowDAO;
    private FineDAO fineDAO;

    public void init() {
        userDAO = new UserDAO();
        itemDAO = new ItemDAO();
        borrowDAO = new BorrowDAO();
        fineDAO = new FineDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("manage_items".equals(action)) {
            List<Item> items = itemDAO.getAllItemsAdmin();
            request.setAttribute("items", items);
            request.getRequestDispatcher("/WEB-INF/Pages/manageItems.jsp").forward(request, response);
        } else if ("manage_users".equals(action)) {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/WEB-INF/Pages/manageUsers.jsp").forward(request, response);
        } else {
            // Default to dashboard - Fetch Stats
            int userCount = userDAO.getTotalUserCount();
            int itemCount = itemDAO.getTotalItemCount();
            int activeBorrows = borrowDAO.getActiveBorrowCount();
            double totalUnpaidFines = fineDAO.getTotalUnpaidFines();
            
            request.setAttribute("userCount", userCount);
            request.setAttribute("itemCount", itemCount);
            request.setAttribute("activeBorrows", activeBorrows);
            request.setAttribute("totalUnpaidFines", totalUnpaidFines);
            
            request.getRequestDispatcher("/WEB-INF/Pages/adminDashboard.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("approve_item".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("item_id"));
            itemDAO.updateItemStatus(itemId, "Available");
            response.sendRedirect(request.getContextPath() + "/admin?action=manage_items&msg=item_approved");
        } else if ("update_user_status".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("user_id"));
            String status = request.getParameter("status");
            userDAO.updateUserStatus(userId, status);
            response.sendRedirect(request.getContextPath() + "/admin?action=manage_users&msg=user_updated");
        }
    }
}
