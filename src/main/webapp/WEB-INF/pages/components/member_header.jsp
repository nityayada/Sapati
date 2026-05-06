<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="header">
    <div class="container header-inner">
        <div style="display: flex; align-items: center; gap: 3rem;">
            <a href="${pageContext.request.contextPath}/home" class="logo">Sapati.com</a>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/item?action=dashboard" class="nav-link ${empty param.action or param.action == 'dashboard' ? 'active' : ''}">Dashboard</a>
                <a href="${pageContext.request.contextPath}/item?action=list" class="nav-link ${param.action == 'list' ? 'active' : ''}">Browse Items</a>
                <a href="${pageContext.request.contextPath}/item?action=myBorrowings" class="nav-link ${param.action == 'myBorrowings' ? 'active' : ''}">My Borrowings</a>
                <a href="${pageContext.request.contextPath}/item?action=myListings" class="nav-link ${param.action == 'myListings' ? 'active' : ''}">My Listings</a>
                <a href="${pageContext.request.contextPath}/borrow?action=view_requests" class="nav-link ${param.action == 'view_requests' ? 'active' : ''}" style="position: relative;">
                    Incoming Requests
                    <c:if test="${pendingActionCount > 0}">
                        <span style="position: absolute; top: -5px; right: -15px; background: #e76f51; background: var(--danger, #e76f51); color: white; font-size: 0.65rem; font-weight: 900; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 0 0 2px var(--surface, white); z-index: 10;">
                            ${pendingActionCount}
                        </span>
                    </c:if>
                </a>
            </nav>
        </div>
        <div class="header-user-info" style="display: flex; align-items: center; gap: 1.5rem;">
            <c:if test="${not empty sessionScope.user}">
                <div style="text-align: right; line-height: 1.2;">
                    <span class="label-md" style="font-size: 0.6rem; opacity: 0.6;">Active Member</span><br>
                    <span style="font-weight: 800; font-size: 0.875rem;">${sessionScope.user.fullName}</span>
                </div>
                <div style="display: flex; gap: 0.5rem; align-items: center;">
                    <a href="${pageContext.request.contextPath}/user?action=profile" style="width: 32px; height: 32px; border-radius: 50%; overflow: hidden; display: flex; align-items: center; justify-content: center; border: 2px solid var(--primary);">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.profileImage}">
                                <img src="${pageContext.request.contextPath}/${sessionScope.user.profileImage}" alt="P" style="width: 100%; height: 100%; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <span class="material-symbols-outlined" style="font-size: 1.5rem;">account_circle</span>
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <a href="${pageContext.request.contextPath}/user?action=logout" class="material-symbols-outlined nav-link" style="font-size: 1.5rem; color: var(--error);">logout</a>
                </div>
            </c:if>
        </div>
    </div>
</header>
