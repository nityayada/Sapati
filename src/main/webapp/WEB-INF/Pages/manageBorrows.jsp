<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.BorrowRecord" %>
<%
    List<BorrowRecord> borrows = (List<BorrowRecord>) request.getAttribute("borrows");
    Integer totalActive = (Integer) request.getAttribute("totalActive");
    Integer overdueItems = (Integer) request.getAttribute("overdueItems");
    Integer newToday = (Integer) request.getAttribute("newToday");
    String returnRate = (String) request.getAttribute("returnRate");
%>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="manage_borrows" />
</jsp:include>

<div class="flex items-end justify-between mb-8">
    <div>
        <span class="font-sans uppercase text-[10px] font-bold tracking-widest text-primary mb-1 block">ADMINISTRATION // SEC. 06</span>
        <h1 class="text-4xl font-extrabold tracking-tight text-primary uppercase">Borrow Records</h1>
    </div>
</div>

<!-- Metric Grid -->
<section class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Total Active</div>
        <div class="text-3xl font-black text-primary"><%= totalActive != null ? totalActive : 0 %></div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Overdue Items</div>
        <div class="text-3xl font-black <%= overdueItems != null && overdueItems > 0 ? "text-error" : "text-primary" %>"><%= overdueItems != null ? overdueItems : 0 %></div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">New Today</div>
        <div class="text-3xl font-black text-primary"><%= newToday != null ? newToday : 0 %></div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Return Rate</div>
        <div class="text-3xl font-black text-primary"><%= returnRate != null ? returnRate : "0.0" %>%</div>
    </div>
</section>

<!-- Ledger Table -->
<div class="bg-surface-container-lowest border border-outline-variant/30 overflow-hidden">
    <table class="w-full text-left text-sm">
        <thead class="bg-surface-container-low border-b border-outline-variant/30">
            <tr class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline">
                <th class="px-6 py-4">TRANSACTION ID</th>
                <th class="px-6 py-4">RESOURCE</th>
                <th class="px-6 py-4">LENDER</th>
                <th class="px-6 py-4">BORROWER</th>
                <th class="px-6 py-4">DATE RANGE</th>
                <th class="px-6 py-4 text-center">STATUS</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
            <% if (borrows != null && !borrows.isEmpty()) {
                for (int i = 0; i < borrows.size(); i++) {
                    BorrowRecord br = borrows.get(i);
                    String statusClass = "";
                    if ("Active".equalsIgnoreCase(br.getStatus())) statusClass = "bg-surface-container-high text-on-surface";
                    else if ("Overdue".equalsIgnoreCase(br.getStatus())) statusClass = "bg-error text-white";
                    else if ("Returned".equalsIgnoreCase(br.getStatus())) statusClass = "border border-outline text-outline";
            %>
            <tr class="transition-colors hover:bg-surface-container-lowest/50">
                <td class="px-6 py-4 font-bold font-mono text-xs text-on-surface-variant">TXN_<%= br.getRecordId() %></td>
                <td class="px-6 py-4 font-bold"><%= br.getItemName() %></td>
                <td class="px-6 py-4 text-on-surface-variant font-medium"><%= br.getOwnerName() %></td>
                <td class="px-6 py-4 text-on-surface-variant font-medium"><%= br.getBorrowerName() %></td>
                <td class="px-6 py-4 text-xs font-semibold text-on-surface">
                    <%= br.getBorrowDate() %> <br> <span class="opacity-60 font-normal">&rarr; <%= br.getDueDate() %></span>
                </td>
                <td class="px-6 py-4 text-center">
                    <span class="px-2 py-1 text-[10px] font-bold rounded-full <%= statusClass %>"><%= br.getStatus() %></span>
                </td>
            </tr>
            <%  }
               } else { %>
                <tr><td colspan="6" class="px-6 py-8 text-center text-outline">No transaction records found in the ledger.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>

<jsp:include page="components/admin_layout_footer.jsp" />
