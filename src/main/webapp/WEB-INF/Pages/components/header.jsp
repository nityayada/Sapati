<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
%>
<nav class="navbar">
    <div class="nav-container">
        <a href="<%= request.getContextPath() %>/WEB-INF/Pages/<%= sessionUser != null && sessionUser.getRole().equals("Admin") ? "adminDashboard.jsp" : "memberHome.jsp" %>" class="nav-logo">Sapati</a>
        <div class="nav-links">
            <% if (sessionUser != null) { %>
                <a href="<%= request.getContextPath() %>/WEB-INF/Pages/memberHome.jsp">Home</a>
                <a href="<%= request.getContextPath() %>/WEB-INF/Pages/itemList.jsp">Browse</a>
                <a href="<%= request.getContextPath() %>/WEB-INF/Pages/addItem.jsp">List Item</a>
                <a href="<%= request.getContextPath() %>/WEB-INF/Pages/myBorrows.jsp">My Borrows</a>
                
                <% if (sessionUser.getRole().equals("Admin")) { %>
                    <a href="<%= request.getContextPath() %>/WEB-INF/Pages/adminDashboard.jsp" class="admin-link">Admin</a>
                <% } %>
                
                <span class="user-name">Hello, <%= sessionUser.getFullName() %></span>
                <a href="<%= request.getContextPath() %>/user?action=logout" class="logout-btn">Logout</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/WEB-INF/Pages/login.jsp">Login</a>
                <a href="<%= request.getContextPath() %>/WEB-INF/Pages/register.jsp" class="register-btn">Register</a>
            <% } %>
        </div>
    </div>
</nav>
