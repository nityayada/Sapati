<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Borrowings | Sapati.com</title>

                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap"
                        rel="stylesheet">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
                        rel="stylesheet" />
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
                </head>

                <body style="background-color: var(--surface);">

                    <jsp:include page="components/member_header.jsp" />

                    <main class="container">
                        <c:if test="${not empty param.msg or not empty param.error}">
                            <div style="margin: 2rem 0;">
                                <c:choose>
                                    <c:when test="${param.msg == 'request_sent'}">
                                        <div class="auth-msg auth-msg-success">
                                            <div style="display: flex; align-items: center; gap: 1rem;">
                                                <span class="material-symbols-outlined">check_circle</span>
                                                <span>BORROW REQUEST TRANSMITTED SUCCESSFULLY. AWAITING OWNER
                                                    OVERSIGHT.</span>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${param.msg == 'fine_paid_item_returned'}">
                                        <div class="auth-msg auth-msg-success">
                                            <div style="display: flex; align-items: center; gap: 1rem;">
                                                <span class="material-symbols-outlined">payments</span>
                                                <div>
                                                    <div style="font-weight: 900;">FINE SETTLED & ITEM RETURNED
                                                        SUCCESSFULLY</div>
                                                    <div
                                                        style="font-size: 0.625rem; opacity: 0.8; letter-spacing: 0.1em; margin-top: 0.25rem;">
                                                        TRANSACTION ID: ${param.txid}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${not empty param.msg}">
                                        <div class="auth-msg auth-msg-success">
                                            ${param.msg}
                                        </div>
                                    </c:when>
                                </c:choose>

                                <c:if test="${not empty param.error}">
                                    <div class="auth-msg auth-msg-error">
                                        <div style="display: flex; align-items: center; gap: 1rem;">
                                            <span class="material-symbols-outlined">error</span>
                                            <span>${fn:toUpperCase(fn:replace(param.error, '_', ' '))}</span>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>


                        <!-- Editorial Header Section -->
                        <section style="margin-bottom: 4rem;">
                            <div
                                style="display: flex; justify-content: space-between; align-items: flex-end; gap: 2rem; flex-wrap: wrap;">
                                <div style="max-width: 600px;">
                                    <span class="label-md"
                                        style="color: var(--outline); margin-bottom: 1rem; display: block;">ARCHIVE.PERSONAL_LEDGER</span>
                                    <h1
                                        style="font-size: 4rem; font-weight: 900; line-height: 0.9; text-transform: uppercase; margin-bottom: 1.5rem; letter-spacing: -0.04em;">
                                        My Borrowings</h1>
                                    <p style="color: var(--on-surface-variant); line-height: 1.6;">
                                        A curated history of community trust. Track active loans, pending returns, and
                                        historical exchanges within the Sapati ecosystem.
                                    </p>
                                </div>
                                <div style="text-align: right;">
                                    <span class="label-sm"
                                        style="color: var(--outline); margin-bottom: 0.5rem; display: block;">OUTSTANDING
                                        FINES</span>
                                    <div style="font-size: 3rem; font-weight: 900; letter-spacing: -0.05em;">NPR
                                        <fmt:formatNumber value="${not empty totalFine ? totalFine : 0.0}"
                                            pattern="#,##0.00" />
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Stats Bento Grid -->
                        <section class="bento-grid">
                            <div class="stat-box" style="grid-column: span 4;">
                                <span class="stat-label">Active Loans</span>
                                <span class="stat-value">
                                    <fmt:formatNumber value="${not empty borrowStats.active ? borrowStats.active : 0}"
                                        pattern="00" />
                                </span>
                            </div>
                            <div class="stat-box highlight" style="grid-column: span 4;">
                                <span class="stat-label">Overdue Items</span>
                                <span class="stat-value" style="color: var(--error);">
                                    <fmt:formatNumber value="${not empty borrowStats.overdue ? borrowStats.overdue : 0}"
                                        pattern="00" />
                                </span>
                            </div>
                            <div class="stat-box" style="grid-column: span 4;">
                                <span class="stat-label">Total Exchanges</span>
                                <span class="stat-value">
                                    <fmt:formatNumber value="${not empty borrowStats.total ? borrowStats.total : 0}"
                                        pattern="00" />
                                </span>
                            </div>
                        </section>

                        <!-- Personal Ledger Table -->
                        <div class="ledger-container">
                            <table class="ledger-table">
                                <thead>
                                    <tr>
                                        <th>Resource Identity</th>
                                        <th>Owner Node</th>
                                        <th>Borrow Date</th>
                                        <th>Due Date</th>
                                        <th>Status</th>
                                        <th style="text-align: right;">Fine Accrued</th>
                                        <th style="text-align: right;">Operations</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty borrowRecords}">
                                            <tr>
                                                <td colspan="7" style="padding: 10rem 0; text-align: center;">
                                                    <span class="material-symbols-outlined"
                                                        style="font-size: 4rem; opacity: 0.1; margin-bottom: 2rem;">history_edu</span>
                                                    <h3
                                                        style="font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em; color: var(--outline);">
                                                        No Ledger Entries Found</h3>
                                                    <p
                                                        style="font-size: 0.75rem; color: var(--outline); margin-top: 1rem;">
                                                        YOUR RECENT EXCHANGES WILL APPEAR HERE.</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${borrowRecords}" var="record">
                                                <c:set var="statusClass" value="" />
                                                <c:choose>
                                                    <c:when test="${record.status == 'Active'}">
                                                        <c:set var="statusClass" value="badge-active" />
                                                    </c:when>
                                                    <c:when test="${record.status == 'Overdue'}">
                                                        <c:set var="statusClass" value="badge-overdue" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="statusClass" value="badge-returned" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <tr>
                                                    <td>
                                                        <div class="item-info">
                                                            <div class="item-thumb">
                                                                <span class="material-symbols-outlined"
                                                                    style="color: var(--outline); opacity: 0.5;">inventory_2</span>
                                                            </div>
                                                            <div>
                                                                <div
                                                                    style="font-weight: 900; text-transform: uppercase; letter-spacing: -0.02em;">
                                                                    ${record.itemName}</div>
                                                                <div
                                                                    style="font-size: 0.625rem; font-weight: 800; color: var(--outline); text-transform: uppercase;">
                                                                    REF_ID: #${record.itemId}-S</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                                                            <div
                                                                style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--primary);">
                                                            </div>
                                                            <span
                                                                style="font-weight: 700; text-transform: uppercase; font-size: 0.75rem;">${record.ownerName}</span>
                                                        </div>
                                                    </td>
                                                    <td class="tabular">${record.borrowDate}</td>
                                                    <td class="tabular"
                                                        style="${record.status == 'Overdue' ? 'color: var(--error); font-weight: 900;' : ''}">
                                                        ${record.dueDate}
                                                    </td>
                                                    <td>
                                                        <span class="badge ${statusClass}">${record.status}</span>
                                                    </td>
                                                    <td style="text-align: right;" class="tabular">
                                                        <c:set var="recordFine" value="${0.0}" />
                                                        <c:forEach items="${fines}" var="f">
                                                            <c:if
                                                                test="${f.recordId == record.recordId && f.paymentStatus != 'Paid'}">
                                                                <c:set var="recordFine" value="${f.amount}" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:choose>
                                                            <c:when test="${recordFine > 0}">
                                                                NPR
                                                                <fmt:formatNumber value="${recordFine}"
                                                                    pattern="#,##0.00" />
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td style="text-align: right;">
                                                        <c:choose>
                                                            <c:when
                                                                test="${record.status == 'Active' or record.status == 'Overdue'}">
                                                                <form action="${pageContext.request.contextPath}/borrow"
                                                                    method="POST" style="display: inline;">
                                                                    <input type="hidden" name="action" value="return">
                                                                    <input type="hidden" name="record_id"
                                                                        value="${record.recordId}">
                                                                    <input type="hidden" name="item_id"
                                                                        value="${record.itemId}">
                                                                    <button type="submit" class="label-md"
                                                                        style="color: var(--primary); font-weight: 900; border: none; background: none; cursor: pointer; text-decoration: underline; padding: 0;">RETURN
                                                                        RESOURCE</button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="label-md"
                                                                    style="opacity: 0.4;">COMPLETED</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <div
                            style="margin-top: 4rem; display: flex; justify-content: space-between; align-items: center;">
                            <div class="label-sm" style="color: var(--outline);">END OF LEDGER RECORD</div>
                            <div style="display: flex; gap: 0.5rem;">
                                <button class="btn btn-ghost"
                                    style="padding: 0.75rem 1.5rem; border: 1px solid var(--outline-variant); font-size: 0.75rem;">PREV</button>
                                <div
                                    style="width: 40px; height: 40px; background-color: var(--primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 0.75rem;">
                                    01</div>
                                <button class="btn btn-ghost"
                                    style="padding: 0.75rem 1.5rem; border: 1px solid var(--outline-variant); font-size: 0.75rem;">NEXT</button>
                            </div>
                        </div>

                    </main>

                    <jsp:include page="components/member_footer.jsp" />

                </body>

                </html>