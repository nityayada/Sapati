<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/WEB-INF/pages/${user.role == 'Admin' ? 'adminDashboard.jsp' : 'memberHome.jsp'}" class="nav-logo">Sapati</a>
        <div class="nav-links">
            <c:choose>
                <c:when test="${not empty user}">
                    <a href="${pageContext.request.contextPath}/WEB-INF/pages/memberHome.jsp">Home</a>
                    <a href="${pageContext.request.contextPath}/WEB-INF/pages/itemList.jsp">Browse</a>
                    <a href="${pageContext.request.contextPath}/WEB-INF/pages/addItem.jsp">List Item</a>
                    <a href="${pageContext.request.contextPath}/WEB-INF/pages/myBorrows.jsp">My Borrows</a>
                    
                    <c:if test="${user.role == 'Admin'}">
                        <a href="${pageContext.request.contextPath}/WEB-INF/pages/adminDashboard.jsp" class="admin-link">Admin</a>
                    </c:if>
                    
                    <span class="user-name">Hello, ${user.fullName}</span>
                    <a href="${pageContext.request.contextPath}/user?action=logout" class="logout-btn">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/WEB-INF/pages/login.jsp">Login</a>
                    <a href="${pageContext.request.contextPath}/WEB-INF/pages/register.jsp" class="register-btn">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>
