<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="header">
    <div class="container header-inner">
        <div style="display: flex; align-items: center; gap: 3rem;">
            <a href="${pageContext.request.contextPath}/home" class="logo">Sapati.com</a>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/home" class="nav-link ${pageContext.request.servletPath == '/home' or pageContext.request.servletPath == '/' or empty pageContext.request.servletPath ? 'active' : ''}">Home</a>
                <a href="${pageContext.request.contextPath}/about" class="nav-link ${pageContext.request.servletPath == '/about' ? 'active' : ''}">About</a>
                <a href="${pageContext.request.contextPath}/contact" class="nav-link ${pageContext.request.servletPath == '/contact' ? 'active' : ''}">Contact</a>
            </nav>
        </div>
        <div class="auth-buttons">
            <a href="${pageContext.request.contextPath}/user?action=login" class="btn btn-ghost">Login</a>
            <a href="${pageContext.request.contextPath}/user?action=register" class="btn btn-primary">Register</a>
        </div>
    </div>
</header>
