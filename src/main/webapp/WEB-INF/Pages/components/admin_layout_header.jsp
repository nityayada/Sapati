<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    String action = request.getParameter("action");
    if (action == null) action = "dashboard";
%>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>Admin Dashboard | Sapati.com</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
</head>
<body class="bg-surface text-on-surface antialiased">
<header class="flex justify-between items-center px-6 py-3 w-full sticky top-0 z-50 bg-slate-50 border-b border-gray-300 font-sans text-sm tracking-tight">
<div class="text-lg font-black uppercase tracking-tighter text-black">Sapati.com</div>
<nav class="hidden md:flex space-x-6">
</nav>
<div class="flex items-center gap-4">
    <% if (sessionUser != null) { %>
        <span class="font-bold text-xs"><%= sessionUser.getFullName() %></span>
        <button class="text-gray-500 font-medium hover:text-black transition-colors scale-95 duration-75" onclick="window.location.href='${pageContext.request.contextPath}/user?action=logout'">Logout</button>
    <% } else { %>
        <button class="text-gray-500 font-medium hover:text-black transition-colors scale-95 duration-75" onclick="window.location.href='${pageContext.request.contextPath}/home'">Back to Site</button>
    <% } %>
</div>
</header>

<div class="flex min-h-screen">
<aside class="fixed left-0 top-0 h-full w-64 bg-gray-100 flex flex-col p-4 border-r border-dashed border-gray-400 z-40 mt-[52px]">
<div class="mb-8 px-2">
<div class="text-xl font-black text-black">Admin Panel</div>
<div class="font-sans uppercase text-[10px] font-bold tracking-widest text-gray-600">System Control</div>
</div>
<nav class="flex flex-col space-y-2">
<a class="flex items-center space-x-3 p-3 transition-all duration-200 <%= action.equals("dashboard") ? "bg-white text-black border border-black" : "text-gray-600 hover:bg-gray-200" %>" href="${pageContext.request.contextPath}/admin?action=dashboard">
<span class="material-symbols-outlined">dashboard</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Admin Home</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 <%= action.equals("manage_users") ? "bg-white text-black border border-black" : "text-gray-600 hover:bg-gray-200" %>" href="${pageContext.request.contextPath}/admin?action=manage_users">
<span class="material-symbols-outlined">group</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Manage Members</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 <%= action.equals("manage_items") ? "bg-white text-black border border-black" : "text-gray-600 hover:bg-gray-200" %>" href="${pageContext.request.contextPath}/admin?action=manage_items">
<span class="material-symbols-outlined">inventory_2</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Manage Items</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 <%= action.equals("manage_borrows") ? "bg-white text-black border border-black" : "text-gray-600 hover:bg-gray-200" %>" href="${pageContext.request.contextPath}/admin?action=manage_borrows">
<span class="material-symbols-outlined">history_edu</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Borrow Records</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 <%= action.equals("manage_fines") ? "bg-white text-black border border-black" : "text-gray-600 hover:bg-gray-200" %>" href="${pageContext.request.contextPath}/admin?action=manage_fines">
<span class="material-symbols-outlined">payments</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Fines</span>
</a>
<a class="flex items-center space-x-3 p-3 transition-all duration-200 <%= action.equals("manage_messages") ? "bg-white text-black border border-black" : "text-gray-600 hover:bg-gray-200" %>" href="${pageContext.request.contextPath}/admin?action=manage_messages">
<span class="material-symbols-outlined">mail</span>
<span class="font-sans uppercase text-[10px] font-bold tracking-widest">Messages</span>
</a>
</nav>
</aside>
<main class="flex-1 ml-64 p-8">