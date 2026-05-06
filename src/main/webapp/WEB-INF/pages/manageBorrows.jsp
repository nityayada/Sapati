<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

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
        <div class="text-3xl font-black text-primary">${not empty totalActive ? totalActive : 0}</div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Overdue Items</div>
        <div class="text-3xl font-black ${overdueItems > 0 ? 'text-error' : 'text-primary'}">${not empty overdueItems ? overdueItems : 0}</div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">New Today</div>
        <div class="text-3xl font-black text-primary">${not empty newToday ? newToday : 0}</div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Return Rate</div>
        <div class="text-3xl font-black text-primary">${not empty returnRate ? returnRate : '0.0'}%</div>
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
                <th class="px-6 py-4 text-right">ACTIONS</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
            <c:choose>
                <c:when test="${not empty borrows}">
                    <c:forEach items="${borrows}" var="br">
                        <c:set var="statusClass" value="" />
                        <c:choose>
                            <c:when test="${br.status == 'Active'}">
                                <c:set var="statusClass" value="bg-surface-container-high text-on-surface" />
                            </c:when>
                            <c:when test="${br.status == 'Overdue'}">
                                <c:set var="statusClass" value="bg-error text-white" />
                            </c:when>
                            <c:when test="${br.status == 'Returned'}">
                                <c:set var="statusClass" value="border border-outline text-outline" />
                            </c:when>
                        </c:choose>
                        <tr class="transition-colors ${br.status == 'Overdue' ? 'bg-error/5 hover:bg-error/10' : 'hover:bg-surface-container-lowest/50'}">
                            <td class="px-6 py-4 font-bold font-mono text-xs text-on-surface-variant">TXN_${br.recordId}</td>
                            <td class="px-6 py-4 font-bold">
                                ${br.itemName}
                                <c:if test="${br.status == 'Overdue'}">
                                    <span class="material-symbols-outlined text-error text-xs align-middle animate-pulse">warning</span>
                                </c:if>
                            </td>
                            <td class="px-6 py-4 text-on-surface-variant font-medium">${br.ownerName}</td>
                            <td class="px-6 py-4 text-on-surface-variant font-medium">${br.borrowerName}</td>
                            <td class="px-6 py-4 text-xs font-semibold text-on-surface">
                                ${br.borrowDate} <br> <span class="opacity-60 font-normal">&rarr; ${br.dueDate}</span>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <span class="px-2 py-1 text-[10px] font-bold rounded-full ${statusClass}">${br.status}</span>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <c:choose>
                                    <c:when test="${br.status != 'Returned'}">
                                        <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                            <input type="hidden" name="action" value="admin_return_item">
                                            <input type="hidden" name="record_id" value="${br.recordId}">
                                            <input type="hidden" name="item_id" value="${br.itemId}">
                                            <button type="submit" class="bg-primary text-on-primary text-[10px] px-3 py-1 font-bold rounded hover:opacity-80">MARK RETURNED</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-[10px] font-bold text-outline uppercase tracking-widest">ARCHIVED</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="7" class="px-6 py-8 text-center text-outline">No transaction records found in the ledger.</td></tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<jsp:include page="components/admin_layout_footer.jsp" />
