<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.Item, com.sapati.model.Category" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    boolean isLoggedIn = session.getAttribute("user") != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalog | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="background-color: var(--surface);">

    <% if (isLoggedIn) { %>
        <jsp:include page="components/member_header.jsp" />
    <% } else { %>
        <jsp:include page="components/public_header.jsp" />
    <% } %>

    <main class="container" style="padding: 0;">
        
        <!-- Inventory Banner - Structural Header -->
        <section class="inventory-banner">
            <div style="margin-bottom: 4rem; max-width: 800px;">
                <h1 style="font-size: 4rem; font-weight: 900; line-height: 0.9; text-transform: uppercase; margin-bottom: 1.5rem; letter-spacing: -0.04em;">Community Inventory</h1>
                <p style="font-size: 0.875rem; color: var(--outline); text-transform: uppercase; letter-spacing: 0.2em; font-weight: 700; opacity: 0.8;">Section 02: Neighborhood Resource Ledger</p>
            </div>

            <form action="${pageContext.request.contextPath}/item" method="GET" class="search-form">
                <input type="hidden" name="action" value="search">
                
                <div class="filter-group">
                    <label class="filter-label">Search Keywords</label>
                    <input type="text" name="query" class="filter-input" placeholder="Enter resource name..." value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
                </div>

                <div class="filter-group">
                    <label class="filter-label">Resource Category</label>
                    <select name="category" class="filter-input">
                        <option value="">All Categories</option>
                        <% 
                            String selectedCat = request.getParameter("category");
                            if (categories != null) { 
                                for (Category cat : categories) { 
                                    boolean isSelected = selectedCat != null && selectedCat.equals(String.valueOf(cat.getCategoryId()));
                        %>
                            <option value="<%= cat.getCategoryId() %>" <%= isSelected ? "selected" : "" %>><%= cat.getCategoryName() %></option>
                        <% } } %>
                    </select>
                </div>

                <div class="filter-group">
                    <button type="submit" class="btn btn-primary" style="height: 60px; width: 100%; letter-spacing: 0.3em;">APPLY</button>
                </div>
            </form>
        </section>

        <!-- Structured Results Grid -->
        <div style="padding: 0 1.5rem 8rem 1.5rem;">
            <div class="items-grid">
                <% 
                    if (items == null || items.isEmpty()) {
                %>
                    <div style="grid-column: 1/-1; padding: 10rem 0; text-align: center; border-right: 1px solid var(--outline-variant); border-bottom: 1px solid var(--outline-variant);">
                        <span class="material-symbols-outlined" style="font-size: 5rem; color: var(--primary); opacity: 0.1; margin-bottom: 2rem;">inventory_2</span>
                        <h3 style="font-size: 1.5rem; font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em;">No Records Found</h3>
                        <a href="${pageContext.request.contextPath}/item?action=list" class="label-md" style="margin-top: 2rem; display: inline-block; text-decoration: underline;">RESET CATALOG VIEW</a>
                    </div>
                <% } else { 
                    for (Item item : items) {
                %>
                    <div class="inventory-card">
                        <div class="image-box">
                            <div class="status-pill"><%= item.getStatus().toUpperCase() %></div>
                            <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                                <img src="<%= item.getImagePath() %>" alt="<%= item.getName() %>" style="width: 100%; height: 100%; object-fit: cover; filter: grayscale(1); mix-blend-mode: multiply;">
                            <% } else { %>
                                <span class="material-symbols-outlined" style="font-size: 4rem; opacity: 0.1;">package_2</span>
                            <% } %>
                        </div>
                        <div class="card-body">
                            <span class="category-tag">ARCHIVE.REF_<%= item.getItemId() %></span>
                            <h3 class="item-title"><%= item.getName() %></h3>
                            
                            <div class="card-footer">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                                    <span style="font-size: 0.75rem; font-weight: 800; color: var(--outline); text-transform: uppercase;">Ownership</span>
                                    <span style="font-size: 0.8125rem; font-weight: 900; text-transform: uppercase;">Peer Node</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/item?action=view&id=<%= item.getItemId() %>" class="btn btn-primary" style="width: 100%; padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.2em;">VIEW RESOURCE</a>
                            </div>
                        </div>
                    </div>
                <% } } %>
            </div>

            <!-- Footer Pagination Structural -->
            <div style="border-left: 1px solid var(--outline-variant); border-right: 1px solid var(--outline-variant); border-bottom: 1px solid var(--outline-variant); padding: 4rem; display: flex; justify-content: center; background-color: var(--surface-container-low);">
                <button class="btn btn-ghost" style="padding: 1.5rem 4rem; border: 2px dashed var(--primary); font-size: 0.8125rem; letter-spacing: 0.3em; background-color: white;">LOAD MORE RECORDS</button>
            </div>
        </div>

    </main>

    <% if (isLoggedIn) { %>
        <jsp:include page="components/member_footer.jsp" />
    <% } else { %>
        <jsp:include page="components/public_header.jsp" />
    <% } %>

</body>
</html>
