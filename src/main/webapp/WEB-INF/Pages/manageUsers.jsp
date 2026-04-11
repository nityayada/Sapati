<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.User" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    User sessionUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Directory | Sapati Admin</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container" style="padding: 4rem 1.5rem 8rem 1.5rem;">
        
        <header style="margin-bottom: 4rem; display: flex; justify-content: space-between; align-items: flex-end;">
            <div>
                <span class="label-md" style="color: var(--primary); letter-spacing: 0.3em; margin-bottom: 1rem; display: block;">ADMINISTRATION // SEC. 04</span>
                <h1 style="font-size: 3rem; font-weight: 900; text-transform: uppercase; letter-spacing: -0.02em;">Member Directory</h1>
            </div>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-ghost" style="letter-spacing: 0.2em;">BACK TO COMMAND CENTER</a>
        </header>

        <div style="border: 1px solid var(--outline-variant); background-color: white; overflow: hidden;">
            <table style="width: 100%; border-collapse: collapse; font-size: 0.875rem;">
                <thead>
                    <tr style="background-color: var(--surface-container-low); border-bottom: 1px solid var(--outline-variant);">
                        <th style="padding: 1.5rem; text-align: left;" class="label-sm">NODE ID</th>
                        <th style="padding: 1.5rem; text-align: left;" class="label-sm">FULL NAME</th>
                        <th style="padding: 1.5rem; text-align: left;" class="label-sm">EMAIL</th>
                        <th style="padding: 1.5rem; text-align: left;" class="label-sm">ROLE</th>
                        <th style="padding: 1.5rem; text-align: center;" class="label-sm">STATUS</th>
                        <th style="padding: 1.5rem; text-align: right;" class="label-sm">ACTIONS</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (users != null) {
                        for (User user : users) {
                            String statusClass = "Active".equalsIgnoreCase(user.getAccountStatus()) ? "badge-success" : "badge-error";
                    %>
                        <tr style="border-bottom: 1px solid var(--outline-variant); transition: background-color 0.2s;">
                            <td style="padding: 1.5rem; font-weight: 800; font-family: 'Courier New', monospace;">USR_<%= user.getUserId() %></td>
                            <td style="padding: 1.5rem; font-weight: 700;"><%= user.getFullName() %></td>
                            <td style="padding: 1.5rem; color: var(--on-surface-variant);"><%= user.getEmail() %></td>
                            <td style="padding: 1.5rem;">
                                <span style="font-size: 0.75rem; text-transform: uppercase; font-weight: 900; letter-spacing: 0.1em; color: <%= "Admin".equals(user.getRole()) ? "var(--primary)" : "inherit" %>">
                                    <%= user.getRole() %>
                                </span>
                            </td>
                            <td style="padding: 1.5rem; text-align: center;">
                                <span class="badge <%= statusClass %>" style="padding: 0.4rem 1rem; border-radius: 0;"><%= user.getAccountStatus() %></span>
                            </td>
                            <td style="padding: 1.5rem; text-align: right;">
                                <form action="${pageContext.request.contextPath}/admin" method="POST" style="display: inline;">
                                    <input type="hidden" name="action" value="update_user_status">
                                    <input type="hidden" name="user_id" value="<%= user.getUserId() %>">
                                    <% if ("Suspended".equalsIgnoreCase(user.getAccountStatus())) { %>
                                        <input type="hidden" name="status" value="Active">
                                        <button type="submit" class="btn btn-primary" style="padding: 0.5rem 1rem; font-size: 0.7rem;">REACTIVATE</button>
                                    <% } else { %>
                                        <input type="hidden" name="status" value="Suspended">
                                        <button type="submit" class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.7rem; border-color: var(--error); color: var(--error);">SUSPEND</button>
                                    <% } %>
                                </form>
                            </td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

    </main>

</body>
</html>
