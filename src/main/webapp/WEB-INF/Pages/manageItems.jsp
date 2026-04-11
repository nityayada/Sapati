<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.Item" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Global Inventory | Sapati Admin</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container" style="padding: 4rem 1.5rem 8rem 1.5rem;">
        
        <header style="margin-bottom: 4rem; display: flex; justify-content: space-between; align-items: flex-end;">
            <div>
                <span class="label-md" style="color: var(--primary); letter-spacing: 0.3em; margin-bottom: 1rem; display: block;">ADMINISTRATION // SEC. 05</span>
                <h1 style="font-size: 3rem; font-weight: 900; text-transform: uppercase; letter-spacing: -0.02em;">Global Inventory</h1>
            </div>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-ghost" style="letter-spacing: 0.2em;">BACK TO COMMAND CENTER</a>
        </header>

        <div style="border: 1px solid var(--outline-variant); background-color: white; overflow: hidden;">
            <table style="width: 100%; border-collapse: collapse; font-size: 0.875rem;">
                <thead>
                    <tr style="background-color: var(--surface-container-low); border-bottom: 1px solid var(--outline-variant);">
                        <th style="padding: 1.5rem; text-align: left;" class="label-sm">RESOURCE ID</th>
                        <th style="padding: 1.5rem; text-align: left;" class="label-sm">RESOURCE NAME</th>
                        <th style="padding: 1.5rem; text-align: left;" class="label-sm">OWNER NODE</th>
                        <th style="padding: 1.5rem; text-align: center;" class="label-sm">STATUS</th>
                        <th style="padding: 1.5rem; text-align: right;" class="label-sm">ACTIONS</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (items != null) {
                        for (Item item : items) {
                            String statusClass = "Available".equalsIgnoreCase(item.getStatus()) || "Listed".equalsIgnoreCase(item.getStatus()) ? "badge-success" : "badge-outline";
                    %>
                        <tr style="border-bottom: 1px solid var(--outline-variant); transition: background-color 0.2s;">
                            <td style="padding: 1.5rem; font-weight: 800; font-family: 'Courier New', monospace;">RES_<%= item.getItemId() %></td>
                            <td style="padding: 1.5rem;">
                                <div style="display: flex; align-items: center; gap: 1rem;">
                                    <% if (item.getImagePath() != null) { %>
                                        <img src="<%= item.getImagePath() %>" style="width: 40px; height: 40px; object-fit: cover; border: 1px solid var(--outline-variant); filter: grayscale(1);">
                                    <% } %>
                                    <span style="font-weight: 700;"><%= item.getName() %></span>
                                </div>
                            </td>
                            <td style="padding: 1.5rem; color: var(--on-surface-variant);">USR_<%= item.getOwnerId() %></td>
                            <td style="padding: 1.5rem; text-align: center;">
                                <span class="badge <%= statusClass %>" style="padding: 0.4rem 1rem; border-radius: 0;"><%= item.getStatus() %></span>
                            </td>
                            <td style="padding: 1.5rem; text-align: right;">
                                <div style="display: flex; justify-content: flex-end; gap: 1rem;">
                                    <a href="${pageContext.request.contextPath}/item?action=view&id=<%= item.getItemId() %>" class="label-md" style="text-decoration: underline;">VIEW</a>
                                    
                                    <% if ("Listed".equalsIgnoreCase(item.getStatus())) { %>
                                        <form action="${pageContext.request.contextPath}/admin" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="approve_item">
                                            <input type="hidden" name="item_id" value="<%= item.getItemId() %>">
                                            <button type="submit" class="btn btn-primary" style="padding: 0.5rem 1rem; font-size: 0.7rem;">APPROVE</button>
                                        </form>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

    </main>

</body>
</html>
