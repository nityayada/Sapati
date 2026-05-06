<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
        <div class="text-3xl font-black text-primary">${not empty totalFines ? totalFines : 0}</div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Total Unpaid Amount</div>
        <div class="text-3xl font-black ${outstandingAmount > 0 ? 'text-error' : 'text-primary'}">
            <c:choose>
                <c:when test="${outstandingAmount > 0}">
                    NPR <fmt:formatNumber value="${outstandingAmount}" maxFractionDigits="0" />
                </c:when>
                <c:otherwise>NPR 0</c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Total Collected</div>
        <div class="text-3xl font-black text-primary">
            <c:choose>
                <c:when test="${collectedAmount > 0}">
                    NPR <fmt:formatNumber value="${collectedAmount}" maxFractionDigits="0" />
                </c:when>
                <c:otherwise>NPR 0</c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Unpaid Fines Count</div>
        <div class="text-3xl font-black ${unpaidCount > 0 ? 'text-error' : 'text-primary'}">${not empty unpaidCount ? unpaidCount : 0}</div>
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
                <th class="px-6 py-4">PAYMENT INFO</th>
                <th class="px-6 py-4 text-center">STATUS</th>
                <th class="px-6 py-4 text-right">ACTION</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
            <c:choose>
                <c:when test="${not empty fines}">
                    <c:forEach items="${fines}" var="fine">
                        <c:set var="isPaid" value="${fine.paymentStatus == 'Paid'}" />
                        <c:set var="statusClass" value="${isPaid ? 'bg-surface-container-high text-on-surface' : 'bg-error text-white'}" />
                        <tr class="transition-colors hover:bg-surface-container-lowest/50">
                            <td class="px-6 py-4 font-bold">${fine.memberName}</td>
                            <td class="px-6 py-4">${fine.itemName}</td>
                            <td class="px-6 py-4 font-bold ${isPaid ? 'text-on-surface-variant' : 'text-error'}">
                                ${fine.daysLate} Days
                            </td>
                            <td class="px-6 py-4 font-black">NPR <fmt:formatNumber value="${fine.amount}" maxFractionDigits="0" /></td>
                            <td class="px-6 py-4">
                                <c:choose>
                                    <c:when test="${isPaid}">
                                        <div class="text-[10px] font-bold">${fine.paymentMethod}</div>
                                        <div class="text-[9px] text-outline font-mono">${fine.transactionId}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-[10px] text-outline italic">PENDING PAYMENT</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <span class="px-2 py-1 text-[10px] font-bold rounded-full ${statusClass}">${fine.paymentStatus}</span>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <c:choose>
                                    <c:when test="${not isPaid}">
                                        <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                            <input type="hidden" name="action" value="mark_fine_paid">
                                            <input type="hidden" name="fine_id" value="${fine.fineId}">
                                            <button type="submit" class="bg-primary text-on-primary text-[10px] px-3 py-1 font-bold rounded hover:opacity-80">MARK PAID</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-xs text-outline font-medium">SETTLED</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="7" class="px-6 py-8 text-center text-outline">No fine records found.</td></tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<jsp:include page="components/admin_layout_footer.jsp" />
