<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.User" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="manage_users" />
</jsp:include>

<div class="flex items-end justify-between mb-8">
    <div>
        <span class="font-sans uppercase text-[10px] font-bold tracking-widest text-primary mb-1 block">ADMINISTRATION // SEC. 04</span>
        <h1 class="text-4xl font-extrabold tracking-tight text-primary uppercase">Member Directory</h1>
    </div>
</div>

<div class="bg-surface-container-lowest border border-outline-variant/30 overflow-hidden">
    <table class="w-full text-left text-sm">
        <thead class="bg-surface-container-low border-b border-outline-variant/30">
            <tr class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline">
                <th class="px-6 py-4">NODE ID</th>
                <th class="px-6 py-4">FULL NAME</th>
                <th class="px-6 py-4">EMAIL</th>
                <th class="px-6 py-4">ROLE</th>
                <th class="px-6 py-4 text-center">STATUS</th>
                <th class="px-6 py-4 text-right">ACTIONS</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
            <% if (users != null) {
                for (User user : users) {
                    String statusClass = "Active".equalsIgnoreCase(user.getAccountStatus()) ? "bg-surface-container-high text-on-surface" : "bg-error text-white";
            %>
            <tr class="transition-colors hover:bg-surface-container-lowest/50">
                <td class="px-6 py-4 font-bold font-mono text-xs text-on-surface-variant">USR_<%= user.getUserId() %></td>
                <td class="px-6 py-4 font-bold"><%= user.getFullName() %></td>
                <td class="px-6 py-4 text-on-surface-variant"><%= user.getEmail() %></td>
                <td class="px-6 py-4">
                    <span class="text-[10px] uppercase font-bold tracking-widest <%= "Admin".equals(user.getRole()) ? "text-primary" : "" %>">
                        <%= user.getRole() %>
                    </span>
                </td>
                <td class="px-6 py-4 text-center">
                    <span class="px-2 py-1 text-[10px] font-bold rounded-full <%= statusClass %>"><%= user.getAccountStatus() %></span>
                </td>
                <td class="px-6 py-4 text-right">
                    <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                        <input type="hidden" name="action" value="update_user_status">
                        <input type="hidden" name="user_id" value="<%= user.getUserId() %>">
                        <% if ("Suspended".equalsIgnoreCase(user.getAccountStatus())) { %>
                            <input type="hidden" name="status" value="Active">
                            <button type="submit" class="bg-primary text-on-primary text-[10px] px-3 py-1 font-bold rounded hover:opacity-80">REACTIVATE</button>
                        <% } else { %>
                            <input type="hidden" name="status" value="Suspended">
                            <button type="submit" class="border border-error text-error text-[10px] px-3 py-1 font-bold rounded hover:bg-error hover:text-white transition-colors">SUSPEND</button>
                        <% } %>
                    </form>
                </td>
            </tr>
            <% } } else { %>
                <tr><td colspan="6" class="px-6 py-8 text-center text-outline">No users found in directory.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>

<jsp:include page="components/admin_layout_footer.jsp" />
