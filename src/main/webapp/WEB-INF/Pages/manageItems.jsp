<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.Item" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
%>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="manage_items" />
</jsp:include>

<div class="flex items-end justify-between mb-8">
    <div>
        <span class="font-sans uppercase text-[10px] font-bold tracking-widest text-primary mb-1 block">ADMINISTRATION // SEC. 05</span>
        <h1 class="text-4xl font-extrabold tracking-tight text-primary uppercase">Global Inventory</h1>
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

<div class="bg-white border border-outline-variant-30 shadow-sm overflow-hidden">
    <table class="w-full text-left text-sm border-collapse table-fixed">
        <thead>
            <tr class="bg-surface-container-low border-b border-outline-variant-30 text-[10px] font-black tracking-widest text-outline uppercase">
                <th class="px-8 py-5" style="width: 12%;">UID</th>
                <th class="px-8 py-5" style="width: 40%;">RESOURCE SPECIFICATIONS</th>
                <th class="px-8 py-5" style="width: 18%;">NODE OWNER</th>
                <th class="px-8 py-5 text-center" style="width: 15%;">STATUS</th>
                <th class="px-8 py-5 text-right" style="width: 15%;">OPERATIONS</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant-20">
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
            <tr class="group hover:bg-surface-container-low/30 transition-colors">
                <td class="px-8 py-6">
                    <span class="font-mono text-[10px] font-bold text-outline">#RES_<%= item.getItemId() %></span>
                </td>
                <td class="px-8 py-6">
                    <div class="flex items-center gap-4" style="min-width: 200px;">
                        <div class="flex-shrink-0 w-12 h-12 bg-surface-container-high overflow-hidden border border-outline-variant-30 flex items-center justify-center">
                            <% if (item.getImagePath() != null) { %>
                                <img src="<%= item.getImagePath() %>" class="w-full h-full object-cover filter grayscale group-hover:grayscale-0 transition-all duration-300" style="max-width: 100%; max-height: 100%;">
                            <% } else { %>
                                <div class="w-full h-full flex items-center justify-center opacity-20">
                                    <span class="material-symbols-outlined">package_2</span>
                                </div>
                            <% } %>
                        </div>
                        <div>
                            <div class="font-black text-sm uppercase tracking-tight"><%= item.getName() %></div>
                            <div class="text-[10px] text-outline font-medium mt-0.5"><%= item.getCreatedAt().toString().substring(0, 10) %></div>
                        </div>
                    </div>
                </td>
                <td class="px-8 py-6">
                    <div class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-outline text-base">person</span>
                        <span class="font-bold text-xs tracking-wide">NODE_<%= item.getOwnerId() %></span>
                    </div>
                </td>
                <td class="px-8 py-6 text-center">
                    <span class="status-pill-premium <%= statusClass %>">
                        <span class="material-symbols-outlined text-sm"><%= statusIcon %></span>
                        <%= statusText %>
                    </span>
                </td>
                <td class="px-8 py-6">
                    <div class="flex items-center justify-end gap-3">
                        <a href="${pageContext.request.contextPath}/item?action=view&id=<%= item.getItemId() %>" class="admin-action-btn border border-outline-variant hover:border-primary">
                            <span class="material-symbols-outlined text-base">visibility</span>
                        </a>
                        
                        <% if ("Listed".equalsIgnoreCase(item.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                <input type="hidden" name="action" value="approve_item">
                                <input type="hidden" name="item_id" value="<%= item.getItemId() %>">
                                <button type="submit" class="admin-action-btn action-approve">
                                    <span class="material-symbols-outlined text-base">check</span>
                                    APPROVE
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                <input type="hidden" name="action" value="reject_item">
                                <input type="hidden" name="item_id" value="<%= item.getItemId() %>">
                                <button type="submit" class="admin-action-btn action-reject">
                                    <span class="material-symbols-outlined text-base">close</span>
                                    REJECT
                                </button>
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

<jsp:include page="components/admin_layout_footer.jsp" />
