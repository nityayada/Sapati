<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.Fine" %>
<%
    List<Fine> fines = (List<Fine>) request.getAttribute("fines");
    Integer totalFines = (Integer) request.getAttribute("totalFines");
    Integer unpaidCount = (Integer) request.getAttribute("unpaidCount");
    Double collectedAmount = (Double) request.getAttribute("collectedAmount");
    Double outstandingAmount = (Double) request.getAttribute("outstandingAmount");
%>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="manage_fines" />
</jsp:include>

<div class="flex items-end justify-between mb-8">
    <div>
        <span class="font-sans uppercase text-[10px] font-bold tracking-widest text-primary mb-1 block">ADMINISTRATION // SEC. 07</span>
        <h1 class="text-4xl font-extrabold tracking-tight text-primary uppercase">Fines Oversight</h1>
    </div>
</div>

<!-- Metric Grid -->
<section class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Total Fines Issued</div>
        <div class="text-3xl font-black text-primary"><%= totalFines != null ? totalFines : 0 %></div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Total Unpaid Amount</div>
        <div class="text-3xl font-black <%= outstandingAmount != null && outstandingAmount > 0 ? "text-error" : "text-primary" %>">
            <%= outstandingAmount != null && outstandingAmount > 0 ? "NPR " + Math.round(outstandingAmount) : "NPR 0" %>
        </div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Total Collected</div>
        <div class="text-3xl font-black text-primary">
            <%= collectedAmount != null && collectedAmount > 0 ? "NPR " + Math.round(collectedAmount) : "NPR 0" %>
        </div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Unpaid Fines Count</div>
        <div class="text-3xl font-black <%= unpaidCount != null && unpaidCount > 0 ? "text-error" : "text-primary" %>"><%= unpaidCount != null ? unpaidCount : 0 %></div>
    </div>
</section>

<!-- Fines Table -->
<div class="bg-surface-container-lowest border border-outline-variant/30 overflow-hidden">
    <table class="w-full text-left text-sm">
        <thead class="bg-surface-container-low border-b border-outline-variant/30">
            <tr class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline">
                <th class="px-6 py-4">MEMBER</th>
                <th class="px-6 py-4">ITEM</th>
                <th class="px-6 py-4">DAYS OVERDUE</th>
                <th class="px-6 py-4">FINE</th>
                <th class="px-6 py-4 text-center">STATUS</th>
                <th class="px-6 py-4 text-right">ACTION</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
            <% if (fines != null && !fines.isEmpty()) {
                for (Fine fine : fines) {
                    boolean isPaid = "Paid".equalsIgnoreCase(fine.getPaymentStatus());
                    String statusClass = isPaid ? "bg-surface-container-high text-on-surface" : "bg-error text-white";
            %>
            <tr class="transition-colors hover:bg-surface-container-lowest/50">
                <td class="px-6 py-4 font-bold"><%= fine.getMemberName() %></td>
                <td class="px-6 py-4"><%= fine.getItemName() %></td>
                <td class="px-6 py-4 font-bold <%= isPaid ? "text-on-surface-variant" : "text-error" %>">
                    <%= fine.getDaysLate() %> Days
                </td>
                <td class="px-6 py-4 font-black">NPR <%= Math.round(fine.getAmount()) %></td>
                <td class="px-6 py-4 text-center">
                    <span class="px-2 py-1 text-[10px] font-bold rounded-full <%= statusClass %>"><%= fine.getPaymentStatus() %></span>
                </td>
                <td class="px-6 py-4 text-right">
                    <% if (!isPaid) { %>
                        <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                            <input type="hidden" name="action" value="mark_fine_paid">
                            <input type="hidden" name="fine_id" value="<%= fine.getFineId() %>">
                            <button type="submit" class="bg-primary text-on-primary text-[10px] px-3 py-1 font-bold rounded hover:opacity-80">MARK PAID</button>
                        </form>
                    <% } else { %>
                        <span class="text-xs text-outline font-medium">SETTLED</span>
                    <% } %>
                </td>
            </tr>
            <%  }
               } else { %>
                <tr><td colspan="6" class="px-6 py-8 text-center text-outline">No fine records found.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>

<jsp:include page="components/admin_layout_footer.jsp" />
