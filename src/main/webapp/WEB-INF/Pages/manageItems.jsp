<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.Item" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
%>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="manage_items" />
</jsp:include>

<!-- Search & Filter Bar -->
<div class="mb-8">
    <div class="bg-surface-container-low border border-outline-variant/30 flex items-center px-4 max-w-md focus-within:border-primary transition-all">
        <span class="material-symbols-outlined text-outline text-[1.25rem]">search</span>
        <input type="text" id="itemSearch" placeholder="SEARCH RESOURCES BY NAME OR OWNER..." 
               class="w-full bg-transparent border-none py-4 pl-3 font-sans text-[10px] font-bold tracking-widest outline-none">
    </div>
</div>

<!-- Premium Feedback Banners -->
<% if ("item_approved".equals(request.getParameter("msg"))) { %>
    <div class="admin-banner banner-success">
        <div class="flex items-center gap-4">
            <span class="material-symbols-outlined">verified</span>
            <div>
                <div class="font-bold text-xs uppercase tracking-wider">Resource Certified</div>
                <div class="text-[10px] opacity-80">THE ITEM HAS BEEN LOGGED INTO THE PUBLIC COMMUNITY LEDGER.</div>
            </div>
        </div>
        <span class="material-symbols-outlined cursor-pointer opacity-50 hover:opacity-100" onclick="this.parentElement.remove()">close</span>
    </div>
<% } %>

<% if ("item_deleted".equals(request.getParameter("msg"))) { %>
    <div class="admin-banner banner-error">
        <div class="flex items-center gap-4">
            <span class="material-symbols-outlined">delete_sweep</span>
            <div>
                <div class="font-bold text-xs uppercase tracking-wider">Resource Purged</div>
                <div class="text-[10px] opacity-80">THE REJECTED LISTING HAS BEEN PERMANENTLY REMOVED FROM ALL RECORDS.</div>
            </div>
        </div>
        <span class="material-symbols-outlined cursor-pointer opacity-50 hover:opacity-100" onclick="this.parentElement.remove()">close</span>
    </div>
<% } %>

<div class="bg-surface-container-lowest border border-outline-variant/30 overflow-hidden shadow-sm">
    <table class="w-full text-left text-sm border-collapse">
        <thead class="bg-surface-container-low border-b border-outline-variant/30">
            <tr class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline">
                <th class="px-6 py-4" style="width: 150px;">RESOURCE ID</th>
                <th class="px-6 py-4">SPECIFICATIONS</th>
                <th class="px-6 py-4">NODE OWNER</th>
                <th class="px-6 py-4 text-center">STATUS</th>
                <th class="px-6 py-4 text-right">ACTIONS</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
            <% if (items != null && !items.isEmpty()) {
                for (Item item : items) {
                    String statusClass = "";
                    String statusIcon = "";
                    String statusText = item.getStatus().toUpperCase();
                    
                    if ("Available".equalsIgnoreCase(item.getStatus())) {
                        statusClass = "status-tonal-primary";
                        statusIcon = "inventory";
                    } else if ("Listed".equalsIgnoreCase(item.getStatus())) {
                        statusClass = "status-tonal-secondary";
                        statusIcon = "pending_actions";
                        statusText = "PENDING REVIEW";
                    } else {
                        statusClass = "status-tonal-error";
                        statusIcon = "error";
                    }
            %>
            <tr class="transition-colors hover:bg-surface-container-low/50 item-row">
                <td class="px-6 py-4">
                    <span class="font-mono text-[10px] font-bold text-outline">#RES_<%= item.getItemId() %></span>
                </td>
                <td class="px-6 py-4">
                    <div class="flex items-center gap-4">
                        <div class="w-10 h-10 bg-surface-container-high overflow-hidden border border-outline-variant/30 flex items-center justify-center flex-shrink-0">
                            <% if (item.getImagePath() != null) { %>
                                <img src="<%= item.getImagePath() %>" class="w-full h-full object-cover transition-all duration-300">
                            <% } else { %>
                                <span class="material-symbols-outlined text-outline opacity-20">package_2</span>
                            <% } %>
                        </div>
                        <div>
                            <div class="font-bold text-xs uppercase tracking-tight item-name"><%= item.getName() %></div>
                            <div class="text-[9px] text-outline font-black uppercase tracking-widest mt-1"><%= item.getCreatedAt().toString().substring(0, 10) %></div>
                        </div>
                    </div>
                </td>
                <td class="px-6 py-4">
                    <div class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-outline text-base">person</span>
                        <span class="font-bold text-[10px] tracking-widest uppercase owner-info">NODE_<%= item.getOwnerId() %></span>
                    </div>
                </td>
                <td class="px-6 py-4 text-center">
                    <span class="status-pill-premium <%= statusClass %>" style="font-size: 9px;">
                        <span class="material-symbols-outlined text-xs"><%= statusIcon %></span>
                        <%= statusText %>
                    </span>
                </td>
                <td class="px-6 py-4">
                    <div class="flex items-center justify-end gap-2">
                        <a href="${pageContext.request.contextPath}/item?action=view&id=<%= item.getItemId() %>" 
                           class="flex items-center gap-2 px-3 py-1.5 bg-black text-white border border-black hover:bg-[#333333] transition-all no-underline shadow-sm">
                            <span class="material-symbols-outlined text-[16px]">visibility</span>
                            <span class="text-[9px] font-black uppercase tracking-widest">Inspect</span>
                        </a>
                        
                        <% if ("Listed".equalsIgnoreCase(item.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                <input type="hidden" name="action" value="approve_item">
                                <input type="hidden" name="item_id" value="<%= item.getItemId() %>">
                                <button type="submit" class="bg-primary text-on-primary text-[10px] px-3 py-1 font-bold rounded hover:opacity-80">APPROVE</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                <input type="hidden" name="action" value="reject_item">
                                <input type="hidden" name="item_id" value="<%= item.getItemId() %>">
                                <button type="submit" class="border border-error text-error text-[10px] px-3 py-1 font-bold rounded hover:bg-error hover:text-white transition-colors">REJECT</button>
                            </form>
                        <% } %>
                    </div>
                </td>
            </tr>
            <% } } else { %>
                <tr>
                    <td colspan="5" class="px-8 py-12 text-center">
                        <span class="material-symbols-outlined text-4xl text-outline-variant opacity-30">inventory_2</span>
                        <div class="mt-4 text-xs font-bold text-outline uppercase tracking-widest">Global inventory ledger is empty</div>
                    </td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

<script>
document.getElementById('itemSearch').addEventListener('keyup', function() {
    let filter = this.value.toUpperCase();
    let rows = document.querySelectorAll('.item-row');
    
    rows.forEach(row => {
        let name = row.querySelector('.item-name').textContent.toUpperCase();
        let owner = row.querySelector('.owner-info').textContent.toUpperCase();
        if (name.indexOf(filter) > -1 || owner.indexOf(filter) > -1) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
});
</script>

<jsp:include page="components/admin_layout_footer.jsp" />
