<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.User, com.sapati.dao.BorrowDAO, java.util.List, com.sapati.model.BorrowRequest, com.sapati.model.BorrowRecord" %>

<%
    User sessionUser = (User) session.getAttribute("user");
    String currentPath = request.getServletPath();
    String action = request.getParameter("action");
    
    int pendingActionCount = 0;
    if (sessionUser != null) {
        BorrowDAO headerDAO = new BorrowDAO();
        // Fetch borrow requests
        List<BorrowRequest> headerRequests = headerDAO.getRequestsForOwner(sessionUser.getUserId());
        // Fetch items waiting for owner to confirm return
        List<BorrowRecord> headerReturns = headerDAO.getRecordsAwaitingVerification(sessionUser.getUserId());
        
        int reqCount = (headerRequests != null) ? headerRequests.size() : 0;
        int retCount = (headerReturns != null) ? headerReturns.size() : 0;
        pendingActionCount = reqCount + retCount;
    }
%>



<header class="header">
    <div class="container header-inner">
        <div style="display: flex; align-items: center; gap: 3rem;">
            <a href="${pageContext.request.contextPath}/home" class="logo">Sapati.com</a>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/item?action=dashboard" class="nav-link <%= action == null || "dashboard".equals(action) ? "active" : "" %>">Dashboard</a>
                <a href="${pageContext.request.contextPath}/item?action=list" class="nav-link <%= "list".equals(action) ? "active" : "" %>">Browse Items</a>
                <a href="${pageContext.request.contextPath}/item?action=myBorrowings" class="nav-link <%= "myBorrowings".equals(action) ? "active" : "" %>">My Borrowings</a>
                <a href="${pageContext.request.contextPath}/item?action=myListings" class="nav-link <%= "myListings".equals(action) ? "active" : "" %>">My Listings</a>
                <a href="${pageContext.request.contextPath}/borrow?action=view_requests" class="nav-link <%= "view_requests".equals(action) ? "active" : "" %>" style="position: relative;">
                    Incoming Requests
                    <% if (pendingActionCount > 0) { %>
                        <span style="position: absolute; top: -5px; right: -15px; background: #e76f51; background: var(--danger, #e76f51); color: white; font-size: 0.65rem; font-weight: 900; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 0 0 2px var(--surface, white); z-index: 10;">
                            <%= pendingActionCount %>
                        </span>
                    <% } %>
                </a>

            </nav>

        </div>
        <div class="header-user-info" style="display: flex; align-items: center; gap: 1.5rem;">
            <% if (sessionUser != null) { %>
                <div style="text-align: right; line-height: 1.2;">
                    <span class="label-md" style="font-size: 0.6rem; opacity: 0.6;">Active Member</span><br>
                    <span style="font-weight: 800; font-size: 0.875rem;"><%= sessionUser.getFullName() %></span>
                </div>
                <div style="display: flex; gap: 0.5rem; align-items: center;">
                    <a href="${pageContext.request.contextPath}/user?action=profile" style="width: 32px; height: 32px; border-radius: 50%; overflow: hidden; display: flex; align-items: center; justify-content: center; border: 2px solid var(--primary);">
                        <% if (sessionUser.getProfileImage() != null && !sessionUser.getProfileImage().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/<%= sessionUser.getProfileImage() %>" alt="P" style="width: 100%; height: 100%; object-fit: cover;">
                        <% } else { %>
                            <span class="material-symbols-outlined" style="font-size: 1.5rem;">account_circle</span>
                        <% } %>
                    </a>
                    <a href="${pageContext.request.contextPath}/user?action=logout" class="material-symbols-outlined nav-link" style="font-size: 1.5rem; color: var(--error);">logout</a>
                </div>
            <% } %>
        </div>
    </div>
</header>
