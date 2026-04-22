package com.sapati.controllers;

import com.sapati.dao.UserDAO;
import com.sapati.dao.ItemDAO;
import com.sapati.dao.BorrowDAO;
import com.sapati.dao.FineDAO;
import com.sapati.model.User;
import com.sapati.model.Item;
import com.sapati.model.BorrowRecord;
import com.sapati.model.Fine;
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
        } else if ("manage_borrows".equals(action)) {
            List<BorrowRecord> borrows = borrowDAO.getAllBorrowRecordsAdmin();
            
            // Calculate Metrics
            int totalActive = 0;
            int overdueItems = 0;
            int newToday = 0;
            int returnedItems = 0;
            
            long todayMs = System.currentTimeMillis();
            java.sql.Date today = new java.sql.Date(todayMs);
            
            for (BorrowRecord br : borrows) {
                if ("Active".equalsIgnoreCase(br.getStatus())) totalActive++;
                if ("Overdue".equalsIgnoreCase(br.getStatus())) overdueItems++;
                if ("Returned".equalsIgnoreCase(br.getStatus())) returnedItems++;
                if (br.getBorrowDate() != null && br.getBorrowDate().toString().equals(today.toString())) {
                    newToday++;
                }
            }
            
            double returnRate = 0.0;
            if (borrows.size() > 0) {
                returnRate = (double) returnedItems / borrows.size() * 100.0;
            }
            
            request.setAttribute("borrows", borrows);
            request.setAttribute("totalActive", totalActive);
            request.setAttribute("overdueItems", overdueItems);
            request.setAttribute("newToday", newToday);
            request.setAttribute("returnRate", String.format("%.1f", returnRate));
            
            request.getRequestDispatcher("/WEB-INF/Pages/manageBorrows.jsp").forward(request, response);
        } else if ("run_fine_calc".equals(action)) {
            com.sapati.util.FineCalculator.runCalculations();
            response.sendRedirect(request.getContextPath() + "/admin?action=manage_fines&msg=fines_recalculated");
        } else if ("manage_fines".equals(action)) {
            List<Fine> fines = fineDAO.getAllFinesWithDetails();
            
            int totalFines = 0;
            int unpaidCount = 0;
            double collectedAmount = 0.0;
            double outstandingAmount = 0.0;
            
            for (Fine f : fines) {
                totalFines++;
                if ("Paid".equalsIgnoreCase(f.getPaymentStatus())) {
                    collectedAmount += f.getAmount();
                } else {
                    unpaidCount++;
                    outstandingAmount += f.getAmount();
                }
            }
            
            request.setAttribute("fines", fines);
            request.setAttribute("totalFines", totalFines);
            request.setAttribute("unpaidCount", unpaidCount);
            request.setAttribute("collectedAmount", collectedAmount);
            request.setAttribute("outstandingAmount", outstandingAmount);
            
            request.getRequestDispatcher("/WEB-INF/Pages/manageFines.jsp").forward(request, response);
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
        } else if ("reject_item".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("item_id"));
            itemDAO.deleteItem(itemId);
            response.sendRedirect(request.getContextPath() + "/admin?action=manage_items&msg=item_deleted");
        } else if ("update_user_status".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("user_id"));
            String status = request.getParameter("status");
            userDAO.updateUserStatus(userId, status);
            response.sendRedirect(request.getContextPath() + "/admin?action=manage_users&msg=user_updated");
        } else if ("mark_fine_paid".equals(action)) {
            int fineId = Integer.parseInt(request.getParameter("fine_id"));
            fineDAO.markAsPaid(fineId);
            response.sendRedirect(request.getContextPath() + "/admin?action=manage_fines&msg=fine_paid");
        }
    }
}
