<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.User, com.sapati.model.Item, com.sapati.model.BorrowRecord, com.sapati.model.Fine, java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/user?action=login");
        return;
    }
    
    // Fetch counts dynamically from request attributes
    Integer listedCount = (Integer) request.getAttribute("listedCount");
    Integer borrowedCount = (Integer) request.getAttribute("borrowedCount");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer finesAmount = (Integer) request.getAttribute("finesAmount");
    
    List<BorrowRecord> recentRecords = (List<BorrowRecord>) request.getAttribute("recentRecords");
    List<Item> myListings = (List<Item>) request.getAttribute("myListings");
    List<Fine> unpaidFines = (List<Fine>) request.getAttribute("unpaidFines");

    listedCount = (listedCount != null) ? listedCount : 0;
    borrowedCount = (borrowedCount != null) ? borrowedCount : 0;
    pendingCount = (pendingCount != null) ? pendingCount : 0;
    finesAmount = (finesAmount != null) ? finesAmount : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container" style="padding: 6rem 1.5rem;">
        
        <!-- Welcome Banner - Refined -->
        <section class="welcome-banner">
            <div class="user-avatar" style="width: 80px; height: 80px; background-color: var(--primary-container); border: 2px solid var(--primary); display: flex; align-items: center; justify-content: center;">
                <span class="material-symbols-outlined" style="font-size: 3rem; color: var(--primary);">person</span>
            </div>
            <div>
                <div style="display: flex; align-items: baseline; gap: 1.5rem; margin-bottom: 0.75rem;">
                    <h1 style="font-size: 2.5rem; font-weight: 900; line-height: 1; text-transform: uppercase; letter-spacing: -0.02em;">Welcome back, <%= sessionUser.getFullName() %></h1>
                </div>
                <div style="display: flex; gap: 2rem; align-items: center;">
                    <span class="status-chip" style="background-color: var(--primary); color: white; border: none;">Verified Member</span>
                    <p style="font-size: 0.8125rem; color: var(--outline); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em;">
                        Node: <span style="color: var(--primary); font-weight: 800;"><%= sessionUser.getAddress() != null ? sessionUser.getAddress() : "Remote" %></span>
                    </p>
                </div>
            </div>
        </section>

        <!-- Stat Row - Refined Tonal -->
        <section class="stat-row" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 2rem; margin-bottom: 4rem;">
            <div class="stat-box" style="background: white; border: 1px solid var(--outline-variant); padding: 2rem;">
                <span class="label-md" style="opacity: 0.6; display: block; margin-bottom: 0.5rem;">Items Borrowing</span>
                <div class="count" style="font-size: 2.5rem; font-weight: 900;"><%= String.format("%02d", borrowedCount) %></div>
            </div>
            <div class="stat-box" style="background: white; border: 1px solid var(--outline-variant); padding: 2rem;">
                <span class="label-md" style="opacity: 0.6; display: block; margin-bottom: 0.5rem;">My Shared Items</span>
                <div class="count" style="font-size: 2.5rem; font-weight: 900;"><%= String.format("%02d", listedCount) %></div>
            </div>
            <div class="stat-box" style="background: white; border: 1px solid var(--outline-variant); padding: 2rem;">
                <span class="label-md" style="opacity: 0.6; display: block; margin-bottom: 0.5rem;">Incoming Requests</span>
                <div class="count" style="font-size: 2.5rem; font-weight: 900;"><%= String.format("%02d", pendingCount) %></div>
            </div>
            <div class="stat-box error-state" style="background: white; border: 1px solid var(--error); padding: 2rem;">
                <span class="label-md" style="color: var(--error); opacity: 0.8; display: block; margin-bottom: 0.5rem;">Outstanding Balance</span>
                <div class="count" style="color: var(--error); font-size: 2.5rem; font-weight: 900;">NPR <%= finesAmount %></div>
            </div>
        </section>

        <!-- Main Dashboard Grid -->
        <div class="dashboard-grid" style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 4rem;">
            
            <!-- Left Column -->
            <div class="space-y-12">
                
                <!-- Borrow Records -->
                <section>
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem;">
                        <h2 class="label-md" style="color: var(--primary);">RECENT BORROW RECORDS</h2>
                        <a href="${pageContext.request.contextPath}/item?action=myBorrowings" class="label-md" style="text-decoration: underline; color: var(--outline); font-size: 0.65rem;">View Archive</a>
                    </div>
                    
                    <div class="table-container">
                        <table class="data-table" style="width: 100%; text-align: left; border-collapse: collapse;">
                            <thead>
                                <tr style="font-size: 0.65rem; color: var(--outline); text-transform: uppercase; letter-spacing: 0.1em; border-bottom: 1px solid var(--outline-variant);">
                                    <th style="padding: 1rem 0;">RESOURCE</th>
                                    <th style="padding: 1rem 0;">CUSTODIAN</th>
                                    <th style="padding: 1rem 0;">INITIATED</th>
                                    <th style="padding: 1rem 0;">DUE DATE</th>
                                    <th style="padding: 1rem 0;">LEDGER STATUS</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recentRecords == null || recentRecords.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" style="padding: 3rem 0; text-align: center; color: var(--outline); font-size: 0.75rem;">NO ACTIVE BORROW RECORDS DETECTED.</td>
                                    </tr>
                                <% } else { 
                                    for (BorrowRecord record : recentRecords) {
                                        boolean isOverdue = "Overdue".equalsIgnoreCase(record.getStatus());
                                %>
                                <tr style="border-bottom: 1px solid var(--outline-variant);">
                                    <td style="padding: 1.5rem 0; font-weight: 800; color: var(--primary);"><%= record.getItemName() %></td>
                                    <td style="padding: 1.5rem 0; font-size: 0.8125rem;"><%= record.getOwnerName() %></td>
                                    <td style="padding: 1.5rem 0; font-size: 0.8125rem;"><%= record.getBorrowDate() %></td>
                                    <td style="padding: 1.5rem 0; font-size: 0.8125rem; <%= isOverdue ? "color: var(--error); font-weight: 900;" : "" %>"><%= record.getDueDate() %></td>
                                    <td style="padding: 1.5rem 0;">
                                        <span class="status-chip <%= isOverdue ? "overdue" : "" %>" style="padding: 0.25rem 0.75rem; font-size: 0.6rem; font-weight: 900; background-color: <%= isOverdue ? "var(--error)" : "var(--primary)" %>; color: white;">
                                            <%= record.getStatus().toUpperCase() %>
                                        </span>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- My Listings Grid -->
                <section>
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem;">
                        <h2 class="label-md" style="color: var(--primary);">MY SHARED RESOURCES</h2>
                        <a href="${pageContext.request.contextPath}/item?action=add" class="label-md" style="color: var(--primary); text-decoration: none;">+ ADD NEW LISTING</a>
                    </div>
                    
                    <div class="grid-3" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem;">
                        <% if (myListings == null || myListings.isEmpty()) { %>
                            <div style="grid-column: span 3; padding: 3rem; background: var(--surface-container-low); border: 1px dashed var(--outline-variant); text-align: center;">
                                <p style="font-size: 0.75rem; color: var(--outline);">YOU HAVEN'T SHARED ANY RESOURCES YET.</p>
                            </div>
                        <% } else { 
                            int count = 0;
                            for (Item item : myListings) {
                                if (count++ >= 3) break; // Limit to 3 on home
                        %>
                            <div class="item-card" style="padding: 0; background-color: transparent; border: none;">
                                <div class="item-image" style="height: 180px; background-color: var(--surface-container-low); border: 1px dashed var(--outline-variant); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; overflow: hidden;">
                                    <% if (item.getImagePath() != null && !item.getImagePath().contains("placeholder")) { %>
                                        <img src="<%= item.getImagePath() %>" style="width: 100%; height: 100%; object-fit: cover; filter: grayscale(1); transition: 0.3s;" onmouseover="this.style.filter='grayscale(0)'" onmouseout="this.style.filter='grayscale(1)'">
                                    <% } else { %>
                                        <span class="material-symbols-outlined" style="opacity: 0.2; font-size: 3rem;">inventory_2</span>
                                    <% } %>
                                </div>
                                <div style="padding: 1rem 0;">
                                    <h3 style="font-size: 0.875rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.75rem;"><%= item.getName() %></h3>
                                    <div style="display: flex; gap: 1rem;">
                                        <a href="${pageContext.request.contextPath}/item?action=edit&id=<%= item.getItemId() %>" class="label-md" style="font-size: 0.6rem; text-decoration: underline;">EDIT</a>
                                        <span class="label-md" style="font-size: 0.6rem; opacity: 0.5;"><%= item.getStatus().toUpperCase() %></span>
                                    </div>
                                </div>
                            </div>
                        <% } } %>
                    </div>
                </section>

            </div>

            <!-- Right Column -->
            <div class="space-y-12">
                
                <!-- Trust & Fines -->
                <section class="sidebar-section">
                    <h2 class="label-md" style="margin-bottom: 2rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem;">LEDGER ACCOUNT</h2>
                    <div class="sidebar-card" style="background: white; border: 1px solid var(--outline-variant); padding: 2.5rem;">
                        <div style="margin-bottom: 2.5rem;">
                            <span class="label-md" style="opacity: 0.5; font-size: 0.6rem;">Outstanding Liabilities</span>
                            <div style="font-size: 2.5rem; font-weight: 900; color: var(--error);">NPR <%= finesAmount %></div>
                        </div>
                        
                        <% if (unpaidFines != null && !unpaidFines.isEmpty()) { %>
                            <ul style="margin-bottom: 2.5rem; border-top: 1px dashed var(--outline-variant); padding-top: 1.5rem; list-style: none;">
                                <% for (Fine fine : unpaidFines) { %>
                                <li style="display: flex; justify-content: space-between; margin-bottom: 1.25rem;">
                                    <div>
                                        <span style="font-weight: 800; font-size: 0.8125rem;">REF_TXN #<%= fine.getRecordId() %></span><br>
                                        <span style="font-size: 0.625rem; font-weight: 800; color: var(--error); text-transform: uppercase;">LATE FINE [<%= fine.getDaysLate() %>D]</span>
                                    </div>
                                    <span style="font-weight: 900; font-size: 0.8125rem;"><%= (int)fine.getAmount() %></span>
                                </li>
                                <% } %>
                            </ul>
                        <% } else { %>
                            <div style="margin-bottom: 2.5rem; border-top: 1px dashed var(--outline-variant); padding-top: 1.5rem; font-size: 0.75rem; color: var(--outline);">
                                ALL FINANCIAL PROTOCOLS CLEAR.
                            </div>
                        <% } %>
                        
                        <button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/contact'" style="width: 100%; padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.15em; background: var(--primary); color: white; border: none; cursor: pointer;">RESOLVE BALANCE</button>
                    </div>
                </section>

                <!-- Quick Actions -->
                <section class="sidebar-section">
                    <h2 class="label-md" style="margin-bottom: 2rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem;">DASHBOARD ACTIONS</h2>
                    <div class="action-list" style="display: flex; flex-direction: column; gap: 1rem;">
                        <a href="${pageContext.request.contextPath}/item?action=add" class="action-item" style="display: flex; justify-content: space-between; padding: 1.5rem; border: 1px solid var(--outline-variant); text-decoration: none; font-size: 0.75rem; font-weight: 900; letter-spacing: 0.1em; color: var(--primary);">
                            INITIATE NEW LISTING
                            <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/item?action=list" class="action-item" style="display: flex; justify-content: space-between; padding: 1.5rem; border: 1px solid var(--outline-variant); text-decoration: none; font-size: 0.75rem; font-weight: 900; letter-spacing: 0.1em; color: var(--primary);">
                            CATALOG BROWSER
                            <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/borrow?action=view_requests" class="action-item" style="display: flex; justify-content: space-between; padding: 1.5rem; border: 1px solid var(--outline-variant); text-decoration: none; font-size: 0.75rem; font-weight: 900; letter-spacing: 0.1em; color: var(--primary);">
                            INCOMING REQUESTS
                            <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/contact" class="action-item" style="display: flex; justify-content: space-between; padding: 1.5rem; border: 1px solid var(--outline-variant); text-decoration: none; font-size: 0.75rem; font-weight: 900; letter-spacing: 0.1em; color: var(--primary);">
                            SYSTEM SUPPORT
                            <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                        </a>
                    </div>
                </section>

            </div>

        </div>

    </main>

    <jsp:include page="components/member_footer.jsp" />

</body>
</html>