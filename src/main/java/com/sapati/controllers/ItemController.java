package com.sapati.controllers;

import com.sapati.dao.ItemDAO;
import com.sapati.dao.CategoryDAO;
import com.sapati.model.Item;
import com.sapati.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/item")
public class ItemController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ItemDAO itemDAO;
    private CategoryDAO categoryDAO;

    public void init() {
        itemDAO = new ItemDAO();
        categoryDAO = new CategoryDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("list".equals(action)) {
            List<Item> items = itemDAO.getAllAvailableItems();
            request.setAttribute("items", items);
            request.getRequestDispatcher("/WEB-INF/Pages/itemList.jsp").forward(request, response);
        } else if ("search".equals(action)) {
            String query = request.getParameter("query");
            List<Item> items = itemDAO.searchItems(query);
            request.setAttribute("items", items);
            request.getRequestDispatcher("/WEB-INF/Pages/itemList.jsp").forward(request, response);
        } else {
            // Default to member house
            request.getRequestDispatcher("/WEB-INF/Pages/memberHome.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addItem(request, response);
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
        String imagePath = request.getParameter("image_path"); // Optional path

        Item item = new Item();
        item.setOwnerId(user.getUserId());
        item.setName(name);
        item.setCategoryId(categoryId);
        item.setItemCondition(condition);
        item.setDescription(description);
        item.setImagePath(imagePath);
        item.setStatus("Listed");

        if (itemDAO.addItem(item)) {
            request.setAttribute("msg", "item_added");
            request.getRequestDispatcher("/WEB-INF/Pages/memberHome.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to add item. Try again.");
            request.getRequestDispatcher("/WEB-INF/Pages/addItem.jsp").forward(request, response);
        }
    }
}
