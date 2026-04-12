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

<div class="bg-surface-container-lowest border border-outline-variant/30 overflow-hidden">
    <table class="w-full text-left text-sm">
        <thead class="bg-surface-container-low border-b border-outline-variant/30">
            <tr class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline">
                <th class="px-6 py-4">RESOURCE ID</th>
                <th class="px-6 py-4">RESOURCE NAME</th>
                <th class="px-6 py-4">OWNER NODE</th>
                <th class="px-6 py-4 text-center">STATUS</th>
                <th class="px-6 py-4 text-right">ACTIONS</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
            <% if (items != null && !items.isEmpty()) {
                for (Item item : items) {
                    String statusClass = "Available".equalsIgnoreCase(item.getStatus()) || "Listed".equalsIgnoreCase(item.getStatus()) ? "bg-surface-container-high text-on-surface" : "border border-outline text-outline";
            %>
            <tr class="transition-colors hover:bg-surface-container-lowest/50">
                <td class="px-6 py-4 font-bold font-mono text-xs text-on-surface-variant">RES_<%= item.getItemId() %></td>
                <td class="px-6 py-4">
                    <div class="flex items-center gap-3">
                        <% if (item.getImagePath() != null) { %>
                            <img src="<%= item.getImagePath() %>" class="w-10 h-10 object-cover border border-outline-variant grayscale">
                        <% } %>
                        <span class="font-bold"><%= item.getName() %></span>
                    </div>
                </td>
                <td class="px-6 py-4 text-on-surface-variant text-xs font-mono">USR_<%= item.getOwnerId() %></td>
                <td class="px-6 py-4 text-center">
                    <span class="px-2 py-1 text-[10px] font-bold rounded-full <%= statusClass %>"><%= item.getStatus() %></span>
                </td>
                <td class="px-6 py-4 text-right">
                    <div class="flex items-center justify-end gap-4">
                        <a href="${pageContext.request.contextPath}/item?action=view&id=<%= item.getItemId() %>" class="text-xs font-bold underline hover:text-primary transition-colors">VIEW</a>
                        
                        <% if ("Listed".equalsIgnoreCase(item.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                <input type="hidden" name="action" value="approve_item">
                                <input type="hidden" name="item_id" value="<%= item.getItemId() %>">
                                <button type="submit" class="bg-primary text-on-primary text-[10px] px-3 py-1 font-bold rounded hover:opacity-80">APPROVE</button>
                            </form>
                        <% } %>
                    </div>
                </td>
            </tr>
            <% } } else { %>
                <tr><td colspan="5" class="px-6 py-8 text-center text-outline">No resources found in inventory.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>

<jsp:include page="components/admin_layout_footer.jsp" />
