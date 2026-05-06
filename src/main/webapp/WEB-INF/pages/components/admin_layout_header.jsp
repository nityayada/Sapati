<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="action" value="${not empty param.action ? param.action : 'dashboard'}" />

<!DOCTYPE html>
<html class="light" lang="en">
<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>Admin Dashboard | Sapati.com</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="bg-surface text-on-surface antialiased">
<header class="flex justify-between items-center px-6 py-3 w-full sticky top-0 z-50 bg-slate-50 border-b border-gray-300 font-sans text-sm tracking-tight">
<div class="text-lg font-black uppercase tracking-tighter text-black">Sapati.com</div>
<nav class="hidden md:flex space-x-6">
</nav>
<div class="flex items-center gap-4">
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            <div class="flex items-center gap-3 pr-4 border-r border-gray-300">
                <div class="text-right">
                    <div class="text-[9px] font-black uppercase text-gray-500 tracking-widest leading-none">Admin Node</div>
                    <div class="text-xs font-bold text-black">${sessionScope.user.fullName}</div>
                </div>
                <div class="w-8 h-8 bg-black text-white flex items-center justify-center rounded-sm font-black text-xs">
                    ${fn:toUpperCase(fn:substring(sessionScope.user.fullName, 0, 1))}
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/user?action=logout" class="flex items-center gap-2 text-[#C62828] hover:bg-[#FFEBEE] px-3 py-1.5 transition-colors rounded group no-underline">
                <span class="material-symbols-outlined text-base">logout</span>
                <span class="text-[10px] font-black uppercase tracking-widest">Secure Logout</span>
            </a>
        </c:when>
        <c:otherwise>
            <button class="text-gray-500 font-medium hover:text-black transition-colors scale-95 duration-75" onclick="window.location.href='${pageContext.request.contextPath}/home'">Back to Site</button>
        </c:otherwise>
    </c:choose>
</div>
</header>

<div class="flex min-h-screen">
<aside class="fixed left-0 top-0 h-full w-64 bg-gray-100 flex flex-col p-4 border-r border-dashed border-gray-400 z-40 mt-[52px]">
<div class="mb-8 px-2">
<div class="text-xl font-black text-black">Admin Panel</div>
<div class="font-sans uppercase text-[10px] font-bold tracking-widest text-gray-600">System Control</div>
</div>
<nav class="flex flex-col space-y-2">
<a class="flex items-center space-x-3 p-3 transition-all duration-200 ${action == 'dashboard' ? 'bg-white text-black border border-black' : 'text-gray-600 hover:bg-gray-200'}" href="${pageContext.request.contextPath}/admin?action=dashboard">
<span class="material-symbols-outlined">dashboard</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Admin Home</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 ${action == 'manage_users' ? 'bg-white text-black border border-black' : 'text-gray-600 hover:bg-gray-200'}" href="${pageContext.request.contextPath}/admin?action=manage_users">
<span class="material-symbols-outlined">group</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Manage Members</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 ${action == 'manage_items' ? 'bg-white text-black border border-black' : 'text-gray-600 hover:bg-gray-200'}" href="${pageContext.request.contextPath}/admin?action=manage_items">
<span class="material-symbols-outlined">inventory_2</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Manage Items</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 ${action == 'manage_borrows' ? 'bg-white text-black border border-black' : 'text-gray-600 hover:bg-gray-200'}" href="${pageContext.request.contextPath}/admin?action=manage_borrows">
<span class="material-symbols-outlined">history_edu</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Borrow Records</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 ${action == 'manage_fines' ? 'bg-white text-black border border-black' : 'text-gray-600 hover:bg-gray-200'}" href="${pageContext.request.contextPath}/admin?action=manage_fines">
<span class="material-symbols-outlined">payments</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Fines</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 ${action == 'manage_messages' ? 'bg-white text-black border border-black' : 'text-gray-600 hover:bg-gray-200'}" href="${pageContext.request.contextPath}/admin?action=manage_messages">
<span class="material-symbols-outlined">mail</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Messages</span>
</a>
<div class="pt-4 mt-4 border-t border-gray-300">
    <a class="flex items-center space-x-3 p-3 transition-all duration-200 ${action == 'profile' ? 'bg-white text-black border border-black' : 'text-gray-600 hover:bg-gray-200'}" href="${pageContext.request.contextPath}/admin?action=profile">
        <span class="material-symbols-outlined">account_circle</span>
        <span class="font-sans uppercase text-[10px] font-bold tracking-widest">My Profile</span>
    </a>
</div>
</nav>
</aside>
<main class="flex-1 ml-64 p-8">