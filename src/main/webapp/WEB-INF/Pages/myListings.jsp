<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.Item, com.sapati.model.User" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
    Long availabilityRate = (Long) request.getAttribute("availabilityRate");
    User user = (User) session.getAttribute("user");
    Item newestItem = (items != null && !items.isEmpty()) ? items.get(items.size() - 1) : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Listings | Sapati.com</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container">
        
        <% if ("item_added".equals(request.getParameter("msg"))) { %>
            <div class="auth-msg auth-msg-success" style="margin: 2rem 0; border: 1px solid var(--primary);">
                <span class="material-symbols-outlined">inventory</span>
                RESOURCE REGISTERED SUCCESSFULLY IN COMMUNITY LEDGER
            </div>
        <% } %>
        <% if ("item_updated".equals(request.getParameter("msg"))) { %>
            <div class="auth-msg auth-msg-success" style="margin: 2rem 0; border: 1px solid var(--primary);">
                <span class="material-symbols-outlined">edit_note</span>
                METADATA REVISED SUCCESSFULLY. LEDGER UPDATED.
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="auth-msg auth-msg-error" style="margin: 2rem 0;">
                <span class="material-symbols-outlined">error</span>
                <%= request.getParameter("error").replace("_", " ").toUpperCase() %>
            </div>
        <% } %>

        <!-- Editorial Header Section -->
        <section style="margin-bottom: 4rem;">
            <div style="display: flex; justify-content: space-between; align-items: flex-end; gap: 2rem; flex-wrap: wrap;">
                <div style="max-width: 600px;">
                    <span class="label-md" style="color: var(--outline); margin-bottom: 1rem; display: block;">INVENTORY.OWNER_CATALOG</span>
                    <h1 style="font-size: 4rem; font-weight: 900; line-height: 0.9; text-transform: uppercase; margin-bottom: 1.5rem; letter-spacing: -0.04em;">My Listings</h1>
                    <p style="color: var(--on-surface-variant); line-height: 1.6;">
                        Manage the tools, books, and equipment you share with the Sapati community. Track borrowing status and item condition from your architectural ledger.
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/item?action=add" class="btn btn-primary" style="padding: 1.5rem 3rem; border-radius: 0; font-size: 0.75rem; letter-spacing: 0.2em; display: flex; align-items: center; gap: 1rem;">
                        <span class="material-symbols-outlined">add</span>
                        ADD NEW LISTING
                    </a>
                </div>
            </div>
        </section>

        <!-- Bento Grid Layout -->
        <div class="bento-grid">
            
            <!-- Featured Card (Newest Addition) -->
            <% if (newestItem != null) { %>
            <div class="col-span-8 featured-card">
                <div class="featured-img" style="background-image: url('<%= (newestItem.getImagePath() != null && !newestItem.getImagePath().isEmpty()) ? newestItem.getImagePath() : "" %>'); background-size: cover; background-position: center;">
                    <% if (newestItem.getImagePath() == null || newestItem.getImagePath().isEmpty()) { %>
                        <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; opacity: 0.1;">
                            <span class="material-symbols-outlined" style="font-size: 5rem;">package_2</span>
                        </div>
                    <% } %>
                    <div style="position: absolute; top: 0; left: 0; background-color: var(--primary); color: white; padding: 0.5rem 1rem; font-size: 0.625rem; font-weight: 900; text-transform: uppercase;">NEWEST ENTRY</div>
                </div>
                <div class="featured-content">
                    <div>
                        <span class="label-sm" style="color: var(--outline); margin-bottom: 1rem; display: block;">ADDED <%= newestItem.getCreatedAt() != null ? newestItem.getCreatedAt().toString().substring(0, 10) : "RECENTLY" %></span>
                        <h2 style="font-size: 2rem; font-weight: 900; text-transform: uppercase; line-height: 1.1; margin-bottom: 1.5rem;"><%= newestItem.getName() %></h2>
                        <div style="display: flex; align-items: center; gap: 2rem;">
                            <div>
                                <div class="label-sm" style="color: var(--outline); font-size: 0.625rem;">STATUS</div>
                                <% 
                                    String displayedStatus = newestItem.getStatus();
                                    String statusColor = "inherit";
                                    if ("Listed".equalsIgnoreCase(displayedStatus)) {
                                        displayedStatus = "PENDING REVIEW";
                                        statusColor = "var(--secondary)";
                                    } else if ("Available".equalsIgnoreCase(displayedStatus)) {
                                        statusColor = "var(--primary)";
                                    } else if ("Rejected".equalsIgnoreCase(displayedStatus)) {
                                        statusColor = "var(--error)";
                                    }
                                %>
                                <div style="font-weight: 800; text-transform: uppercase; font-size: 0.875rem; color: <%= statusColor %>;"><%= displayedStatus %></div>
                            </div>
                            <div style="width: 1px; height: 30px; background-color: var(--outline-variant);"></div>
                            <div>
                                <div class="label-sm" style="color: var(--outline); font-size: 0.625rem;">REF</div>
                                <div style="font-weight: 800; text-transform: uppercase; font-size: 0.875rem;">#<%= newestItem.getItemId() %>-L</div>
                            </div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                        <a href="${pageContext.request.contextPath}/item?action=edit&id=<%= newestItem.getItemId() %>" class="btn btn-ghost" style="flex: 1; border: 1px solid var(--outline); font-size: 0.75rem; letter-spacing: 0.1em; font-weight: 900; display: flex; align-items: center; justify-content: center; text-decoration: none; color: inherit;">EDIT RECORD</a>
                        <button class="btn btn-ghost" style="flex: 1; border: 1px solid var(--error); color: var(--error); font-size: 0.75rem; letter-spacing: 0.1em; font-weight: 900;">REMOVE</button>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Health Widget -->
            <div class="col-span-4 health-widget">
                <span class="label-md" style="margin-bottom: 2rem; display: block;">INVENTORY HEALTH</span>
                <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                    <span style="font-size: 3.5rem; font-weight: 900; letter-spacing: -0.05em; line-height: 1;"><%= availabilityRate %>%</span>
                    <span class="label-sm" style="color: var(--outline);">AVAILABILITY</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: <%= availabilityRate %>%;"></div>
                </div>
                <p style="font-size: 0.75rem; color: var(--on-surface-variant); line-height: 1.8; margin-top: 2rem;">
                    Your community contribution has saved neighbors an estimated <strong>NPR 1,240</strong> this year through collaborative consumption.
                </p>
            </div>

            <!-- List Header Utility -->
            <div class="col-span-12" style="border-bottom: 2px solid var(--primary); padding-bottom: 1rem; margin-top: 2rem; display: flex; justify-content: space-between; align-items: center;">
                <span class="label-md">ALL COLLECTIONS (<%= items != null ? items.size() : 0 %>)</span>
                <div class="label-sm" style="color: var(--outline);">SORT BY: NEWEST</div>
            </div>

            <!-- Standard Grid Items -->
            <% if (items != null) { 
                for (Item item : items) { %>
                <div class="col-span-4 inventory-card" style="border: 1px solid var(--outline-variant); margin-bottom: 2rem;">
                    <div class="image-box">
                        <% 
                           String cardStatus = item.getStatus();
                           String cardStatusPill = cardStatus.toUpperCase();
                           String pillStyle = "background-color: var(--primary);";
                           if ("Listed".equalsIgnoreCase(cardStatus)) {
                               cardStatusPill = "PENDING REVIEW";
                               pillStyle = "background-color: var(--secondary);";
                           } else if ("Rejected".equalsIgnoreCase(cardStatus)) {
                               pillStyle = "background-color: var(--error);";
                           }
                        %>
                        <div class="status-pill" style="<%= pillStyle %>"><%= cardStatusPill %></div>
                        <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                                <img src="<%= item.getImagePath() %>" alt="<%= item.getName() %>" style="width: 100%; height: 100%; object-fit: cover; filter: grayscale(1); mix-blend-mode: multiply;">
                        <% } else { %>
                            <span class="material-symbols-outlined" style="font-size: 4rem; opacity: 0.1;">package_2</span>
                        <% } %>
                    </div>
                    <div class="card-body">
                        <span class="category-tag">REF_<%= item.getItemId() %></span>
                        <h3 class="item-title" style="font-size: 1.25rem;"><%= item.getName() %></h3>
                        <div style="display: flex; gap: 0.5rem; margin-top: auto;">
                            <a href="${pageContext.request.contextPath}/item?action=edit&id=<%= item.getItemId() %>" class="btn btn-ghost" style="flex: 1; border: 1px solid var(--outline); font-size: 0.625rem; font-weight: 900; letter-spacing: 0.1em; padding: 0.75rem; display: flex; align-items: center; justify-content: center; text-decoration: none; color: inherit;">EDIT</a>
                            <button class="btn btn-ghost" style="flex: 1; border: 1px solid var(--outline-variant); font-size: 0.625rem; font-weight: 900; letter-spacing: 0.1em; padding: 0.75rem;">ARCHIVE</button>
                        </div>
                    </div>
                </div>
            <% } } %>

            <!-- Empty State -->
            <% if (items == null || items.isEmpty()) { %>
            <div class="col-span-12" style="border: 2px dashed var(--outline-variant); padding: 8rem 0; text-align: center;">
                <span class="material-symbols-outlined" style="font-size: 5rem; opacity: 0.1; margin-bottom: 2rem;">inventory_2</span>
                <h3 style="font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em;">Your catalog is empty</h3>
                <p style="color: var(--outline); margin-bottom: 3rem;">LIST ITEMS YOU DON'T USE EVERY DAY TO HELP YOUR NEIGHBORS.</p>
                <a href="${pageContext.request.contextPath}/item?action=add" class="btn btn-primary" style="padding: 1.25rem 3rem;">LIST YOUR FIRST RESOURCE</a>
            </div>
            <% } %>

        </div>

    </main>

    <jsp:include page="components/member_footer.jsp" />

</body>
</html>
