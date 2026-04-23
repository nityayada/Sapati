<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    String currentPath = request.getServletPath();
    String action = request.getParameter("action");
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
                <a href="${pageContext.request.contextPath}/borrow?action=view_requests" class="nav-link <%= "view_requests".equals(action) ? "active" : "" %>">Incoming Requests</a>
            </nav>
        </div>
        <div class="header-user-info" style="display: flex; align-items: center; gap: 1.5rem;">
            <% if (sessionUser != null) { %>
                <div style="text-align: right; line-height: 1.2;">
                    <span class="label-md" style="font-size: 0.6rem; opacity: 0.6;">Active Member</span><br>
                    <span style="font-weight: 800; font-size: 0.875rem;"><%= sessionUser.getFullName() %></span>
                </div>
                <div style="display: flex; gap: 0.5rem;">
                    <a href="${pageContext.request.contextPath}/user?action=profile" class="material-symbols-outlined nav-link" style="font-size: 1.5rem;">account_circle</a>
                    <a href="${pageContext.request.contextPath}/user?action=logout" class="material-symbols-outlined nav-link" style="font-size: 1.5rem; color: var(--error);">logout</a>
                </div>
            <% } %>
        </div>
    </div>
</header>
