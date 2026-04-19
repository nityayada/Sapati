package com.sapati.controllers;

import com.sapati.dao.ItemDAO;
import com.sapati.dao.CategoryDAO;
import com.sapati.dao.UserDAO;
import com.sapati.model.Item;
import com.sapati.model.User;
import com.sapati.model.BorrowRecord;
import com.sapati.dao.BorrowDAO;
import com.sapati.dao.FineDAO;
import com.sapati.model.Fine;
import java.util.Map;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.util.UUID;

@WebServlet("/item")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class ItemController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ItemDAO itemDAO;
    private CategoryDAO categoryDAO;
    private BorrowDAO borrowDAO;
    private FineDAO fineDAO;
    private UserDAO userDAO;

    public void init() {
        itemDAO = new ItemDAO();
        categoryDAO = new CategoryDAO();
        borrowDAO = new BorrowDAO();
        fineDAO = new FineDAO();
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("list".equals(action)) {
            List<Item> items = itemDAO.getAllAvailableItems();
            request.setAttribute("items", items);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/Pages/itemList.jsp").forward(request, response);
        } else if ("myListings".equals(action)) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                List<Item> myItems = itemDAO.getItemsByOwner(user.getUserId());
                int totalItems = myItems.size();
                long availableItems = myItems.stream().filter(i -> "Available".equalsIgnoreCase(i.getStatus()) || "Listed".equalsIgnoreCase(i.getStatus())).count();
                double availabilityRate = totalItems > 0 ? (double) availableItems / totalItems * 100 : 0;
                
                request.setAttribute("items", myItems);
                request.setAttribute("availabilityRate", Math.round(availabilityRate));
                request.getRequestDispatcher("/WEB-INF/Pages/myListings.jsp").forward(request, response);
            } else {
                response.sendRedirect("user?action=login");
            }
        } else if ("myBorrowings".equals(action)) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                List<BorrowRecord> records = borrowDAO.getBorrowRecordsByUser(user.getUserId());
                Map<String, Integer> stats = borrowDAO.getBorrowStats(user.getUserId());
                
                // [NEW] Fetch pending requests
                List<com.sapati.model.BorrowRequest> pendingRequests = borrowDAO.getRequestsByRequester(user.getUserId());
                
                List<Fine> fines = fineDAO.getFinesByUser(user.getUserId());
                double totalFine = fines.stream().filter(f -> "Unpaid".equalsIgnoreCase(f.getPaymentStatus())).mapToDouble(Fine::getAmount).sum();
                
                request.setAttribute("borrowRequests", pendingRequests);
                request.setAttribute("borrowRecords", records);
                request.setAttribute("borrowStats", stats);
                request.setAttribute("totalFine", totalFine);

                request.getRequestDispatcher("/WEB-INF/Pages/myBorrowings.jsp").forward(request, response);
            } else {
                response.sendRedirect("user?action=login");
            }
        } else if ("view".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int itemId = Integer.parseInt(idStr);
                Item item = itemDAO.getItemById(itemId);
                if (item != null) {
                    User owner = userDAO.getUserById(item.getOwnerId());
                    request.setAttribute("item", item);
                    request.setAttribute("owner", owner);
                    request.getRequestDispatcher("/WEB-INF/Pages/itemDetail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("item?action=list");
                }
            } else {
                response.sendRedirect("item?action=list");
            }
        } else if ("search".equals(action)) {
            String query = request.getParameter("query");
            String categoryStr = request.getParameter("category");
            Integer categoryId = (categoryStr != null && !categoryStr.isEmpty()) ? Integer.parseInt(categoryStr) : null;
            
            List<Item> items = itemDAO.searchItems(query, categoryId);
            request.setAttribute("items", items);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/Pages/itemList.jsp").forward(request, response);
        } else if ("add".equals(action)) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                request.getRequestDispatcher("/WEB-INF/Pages/addItem.jsp").forward(request, response);
            } else {
                response.sendRedirect("user?action=login");
            }
        } else if ("edit".equals(action)) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            String idStr = request.getParameter("id");
            
            if (user != null && idStr != null) {
                int itemId = Integer.parseInt(idStr);
                Item item = itemDAO.getItemById(itemId);
                
                // Security check: Only owner can edit
                if (item != null && item.getOwnerId() == user.getUserId()) {
                    request.setAttribute("item", item);
                    request.setAttribute("categories", categoryDAO.getAllCategories());
                    request.getRequestDispatcher("/WEB-INF/Pages/editItem.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/item?action=myListings&error=unauthorized_access");
                }
            } else {
                response.sendRedirect(request.getContextPath() + (user == null ? "/user?action=login" : "/item?action=myListings"));
            }
        } else {
            // Default to member house
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                List<Item> myItems = itemDAO.getItemsByOwner(user.getUserId());
                request.setAttribute("listedCount", myItems.size());
            }
            request.getRequestDispatcher("/WEB-INF/Pages/memberHome.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addItem(request, response);
        } else if ("edit".equals(action)) {
            editItem(request, response);
        }
    }

    private void editItem(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        int itemId = Integer.parseInt(request.getParameter("item_id"));
        Item existingItem = itemDAO.getItemById(itemId);

        // Security check
        if (existingItem == null || existingItem.getOwnerId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/item?action=myListings&error=unauthorized");
            return;
        }

        String name = request.getParameter("name");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String condition = request.getParameter("condition");
        String description = request.getParameter("description");
        
        // Handle Image
        String imagePath = existingItem.getImagePath(); // Keep existing by default
        Part filePart = request.getPart("image");
        String imageUrl = request.getParameter("image_url");

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/Images");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
            imagePath = "Images/" + fileName;
        } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            imagePath = imageUrl;
        }

        existingItem.setName(name);
        existingItem.setCategoryId(categoryId);
        existingItem.setItemCondition(condition);
        existingItem.setDescription(description);
        existingItem.setImagePath(imagePath);

        if (itemDAO.updateItem(existingItem)) {
            response.sendRedirect(request.getContextPath() + "/item?action=myListings&msg=item_updated");
        } else {
            request.setAttribute("error", "Failed to update item.");
            request.setAttribute("item", existingItem);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/Pages/editItem.jsp").forward(request, response);
        }
    }

    private void addItem(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            return;
        }

        String name = request.getParameter("name");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String condition = request.getParameter("condition");
        String description = request.getParameter("description");
        
        // Handle Hybrid Image Protocol
        String imagePath = "Images/placeholder.jpg"; // Default
        Part filePart = request.getPart("image");
        String imageUrl = request.getParameter("image_url");
        
        if (filePart != null && filePart.getSize() > 0) {
            // Priority: Local File Upload
            String fileName = UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/Images");
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            filePart.write(uploadPath + File.separator + fileName);
            imagePath = "Images/" + fileName;
        } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            // Fallback: External URL
            imagePath = imageUrl;
        }

        Item item = new Item();
        item.setOwnerId(user.getUserId());
        item.setName(name);
        item.setCategoryId(categoryId);
        item.setItemCondition(condition);
        item.setDescription(description);
        item.setImagePath(imagePath);
        item.setStatus("Listed");

        if (itemDAO.addItem(item)) {
            response.sendRedirect(request.getContextPath() + "/item?action=myListings&msg=item_added");
        } else {
            request.setAttribute("error", "Failed to add item. Try again.");
            request.getRequestDispatcher("/WEB-INF/Pages/addItem.jsp").forward(request, response);
        }
    }
}
