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
        <h1 class="text-4xl font-extrabold tracking-tight text-primary uppercase">MEMBER DIRECTORY</h1>
    </div>
</div>

<!-- Search & Filter Bar -->
<div class="mb-8">
    <div class="bg-surface-container-low border border-outline-variant/30 flex items-center px-4 max-w-md focus-within:border-primary transition-all">
        <span class="material-symbols-outlined text-outline text-[1.25rem]">search</span>
        <input type="text" id="memberSearch" placeholder="SEARCH MEMBERS BY NAME OR EMAIL..." 
               class="w-full bg-transparent border-none py-4 pl-3 font-sans text-[10px] font-bold tracking-widest outline-none">
    </div>
</div>

<div class="bg-surface-container-lowest border border-outline-variant/30 overflow-hidden">
    <table class="w-full text-left text-sm" id="userTable">
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
            <tr class="transition-colors hover:bg-surface-container-lowest/50 user-row">
                <td class="px-6 py-4 font-bold font-mono text-xs text-on-surface-variant">USR_<%= user.getUserId() %></td>
                <td class="px-6 py-4 font-bold user-name">
                    <div class="flex items-center gap-3" style="display: flex; align-items: center; gap: 0.75rem;">
                        <div style="width: 32px; height: 32px; border-radius: 50%; overflow: hidden; background-color: var(--surface-container-high); border: 1px solid var(--outline-variant); flex-shrink: 0; display: flex; align-items: center; justify-content: center;">
                            <% if (user.getProfileImage() != null && !user.getProfileImage().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= user.getProfileImage() %>" alt="" style="width: 100%; height: 100%; object-fit: cover;">
                            <% } else { %>
                                <span class="material-symbols-outlined" style="font-size: 1rem; color: var(--outline);">person</span>
                            <% } %>
                        </div>
                        <%= user.getFullName() %>
                    </div>
                </td>
                <td class="px-6 py-4 text-on-surface-variant user-email"><%= user.getEmail() %></td>
                <td class="px-6 py-4">
                    <span class="text-[10px] uppercase font-bold tracking-widest <%= "Admin".equals(user.getRole()) ? "text-primary" : "" %>">
                        <%= user.getRole() %>
                    </span>
                </td>
                <td class="px-6 py-4 text-center">
                    <span class="px-2 py-1 text-[10px] font-bold rounded-full <%= statusClass %>"><%= user.getAccountStatus() %></span>
                </td>
                    <td class="px-6 py-4 text-right">
                        <% if (!"Admin".equalsIgnoreCase(user.getRole())) { %>
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                <input type="hidden" name="action" value="update_user_status">
                                <input type="hidden" name="user_id" value="<%= user.getUserId() %>">
                                <% if ("Locked".equalsIgnoreCase(user.getAccountStatus())) { %>
                                    <input type="hidden" name="status" value="Active">
                                    <button type="submit" class="bg-primary text-on-primary text-[10px] px-3 py-1 font-bold rounded hover:opacity-80">REACTIVATE</button>
                                <% } else { %>
                                    <input type="hidden" name="status" value="Locked">
                                    <button type="submit" class="border border-error text-error text-[10px] px-3 py-1 font-bold rounded hover:bg-error hover:text-white transition-colors">LOCK ACCOUNT</button>
                                <% } %>
                            </form>
                        <% } else { %>
                            <span class="text-[9px] font-black opacity-30 tracking-tighter">IMMUTABLE_ACCOUNT</span>
                        <% } %>
                    </td>
            </tr>
            <% } } else { %>
                <tr><td colspan="6" class="px-6 py-8 text-center text-outline">No users found in directory.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>

<script>
document.getElementById('memberSearch').addEventListener('keyup', function() {
    let filter = this.value.toUpperCase();
    let rows = document.querySelectorAll('.user-row');
    
    rows.forEach(row => {
        let name = row.querySelector('.user-name').textContent.toUpperCase();
        let email = row.querySelector('.user-email').textContent.toUpperCase();
        if (name.indexOf(filter) > -1 || email.indexOf(filter) > -1) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
});
</script>

<jsp:include page="components/admin_layout_footer.jsp" />
