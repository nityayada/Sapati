<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.Item, com.sapati.dao.ItemDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sapati</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <main class="main-content">
        <section class="hero-section" style="text-align: center; padding: 4rem 0; color: white;">
            <h1 style="font-size: 3rem; margin-bottom: 1rem;">Borrow from your neighbors.</h1>
            <p style="font-size: 1.2rem; margin-bottom: 2rem; opacity: 0.9;">Sustainable, community-driven resource sharing.</p>
            
            <form action="<%= request.getContextPath() %>/item" method="GET" style="max-width: 600px; margin: 0 auto; display: flex; gap: 10px;">
                <input type="hidden" name="action" value="search">
                <input type="text" name="query" placeholder="Search for tools, books, electronics..." style="flex: 1; padding: 1rem; border-radius: 12px; border: none; font-size: 1.1rem; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
                <button type="submit" class="btn" style="width: auto; padding: 0 2rem;">Search</button>
            </form>
        </section>

        <section class="recent-items">
            <div class="section-header">
                <h2 style="text-align: left; color: white;">Available Near You</h2>
                <a href="<%= request.getContextPath() %>/item?action=list" style="color: var(--secondary); text-decoration: none;">View All Resources &rarr;</a>
            </div>

            <div class="item-grid">
                <% 
                    ItemDAO itemDAO = new ItemDAO();
                    List<Item> recentItems = itemDAO.getAllAvailableItems();
                    if (recentItems.isEmpty()) {
                %>
                    <p style="grid-column: 1/-1; text-align: center; color: #fff; padding: 2rem; background: rgba(0,0,0,0.1); border-radius: 15px;">No items available right now. Why not <a href="addItem.jsp" style="color: var(--secondary)">list one?</a></p>
                <% } else { 
                    for (Item item : recentItems) {
                %>
                    <div class="item-card">
                        <div class="item-img" style="color: #666;">
                            <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                                <img src="<%= item.getImagePath() %>" alt="<%= item.getName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                            <% } else { %>
                                📦
                            <% } %>
                        </div>
                        <div class="item-info">
                            <span class="item-category">Resource</span>
                            <h3 class="item-name"><%= item.getName() %></h3>
                            <div class="status-available item-status">Available</div>
                            <p style="margin: 1rem 0; font-size: 0.9rem; color: #666;"><%= item.getDescription().length() > 60 ? item.getDescription().substring(0, 57) + "..." : item.getDescription() %></p>
                            <a href="itemDetail.jsp?id=<%= item.getItemId() %>" class="btn" style="display: block; text-align: center; text-decoration: none;">View Details</a>
                        </div>
                    </div>
                <% } } %>
            </div>
        </section>
    </main>

    <jsp:include page="components/footer.jsp" />
</body>
</html>