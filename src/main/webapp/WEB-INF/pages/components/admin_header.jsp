<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="header">
    <div class="container header-inner">
        <div style="display: flex; align-items: center; gap: 3rem;">
            <a href="${pageContext.request.contextPath}/home" class="logo">Sapati.com</a>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="nav-link ${empty param.action or param.action == 'dashboard' ? 'active' : ''}">Command Center</a>
                <a href="${pageContext.request.contextPath}/admin?action=manage_users" class="nav-link ${param.action == 'manage_users' ? 'active' : ''}">Member Directory</a>
                <a href="${pageContext.request.contextPath}/admin?action=manage_items" class="nav-link ${param.action == 'manage_items' ? 'active' : ''}">Global Inventory</a>
                <a href="${pageContext.request.contextPath}/admin?action=manage_borrows" class="nav-link ${param.action == 'manage_borrows' ? 'active' : ''}">Borrow Records</a>
                <a href="${pageContext.request.contextPath}/admin?action=manage_fines" class="nav-link ${param.action == 'manage_fines' ? 'active' : ''}">Fines Oversight</a>
            </nav>
        </div>
        <div class="header-user-info" style="display: flex; align-items: center; gap: 1.5rem;">
            <c:if test="${not empty user}">
                <div style="text-align: right; line-height: 1.2;">
                    <span class="label-md" style="font-size: 0.6rem; opacity: 0.6; color: var(--primary); font-weight: 900;">SYSTEM ADMIN</span><br>
                    <span style="font-weight: 800; font-size: 0.875rem;">${user.fullName}</span>
                </div>
                <div style="display: flex; gap: 0.5rem; align-items: center;">
                    <a href="${pageContext.request.contextPath}/user?action=profile" style="width: 32px; height: 32px; border-radius: 50%; overflow: hidden; display: flex; align-items: center; justify-content: center; border: 2px solid var(--primary);">
                        <c:choose>
                            <c:when test="${not empty user.profileImage}">
                                <img src="${pageContext.request.contextPath}/${user.profileImage}" alt="P" style="width: 100%; height: 100%; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <span class="material-symbols-outlined" style="font-size: 1.5rem;">shield_person</span>
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <a href="${pageContext.request.contextPath}/user?action=logout" class="material-symbols-outlined nav-link" style="font-size: 1.5rem; color: var(--error);">logout</a>
                </div>
            </c:if>
        </div>
    </div>
</header>
