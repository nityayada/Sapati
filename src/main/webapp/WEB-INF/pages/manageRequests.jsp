<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Requests | Sapati.com</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container">
        <header style="margin-bottom: 4rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 2rem;">
            <span class="label-md" style="color: var(--outline);">COMMUNITY LEDGER v1.0</span>
            <h1 style="font-size: 3rem; font-weight: 900; text-transform: uppercase; margin-top: 1rem;">Incoming Requests</h1>
            <p style="opacity: 0.6; font-weight: 500;">Review community requests to borrow your listed resources.</p>
        </header>

        <c:if test="${not empty param.msg}">
            <div class="auth-msg auth-msg-success" style="margin-bottom: 2rem;">${param.msg} successful.</div>
        </c:if>

        <div class="ledger-container">
            <table class="ledger-table">
                <thead>
                    <tr>
                        <th class="label-sm">RESOURCE</th>
                        <th class="label-sm">REQUESTER</th>
                        <th class="label-sm">DATE REQUESTED</th>
                        <th class="label-sm">PROPOSED RETURN</th>
                        <th class="label-sm" style="text-align: right;">ACTIONS</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty incomingRequests}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 5rem; opacity: 0.5;">
                                    <span class="material-symbols-outlined" style="font-size: 3rem; display: block; margin-bottom: 1rem;">inbox</span>
                                    <div class="label-md">No pending requests at this time.</div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${incomingRequests}" var="req">
                                <tr>
                                    <td>
                                        <div style="font-weight: 800; text-transform: uppercase;">${req.itemName}</div>
                                        <div style="font-size: 0.625rem; opacity: 0.5;">ID: ${req.itemId}</div>
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                                            <div style="width: 24px; height: 24px; background-color: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.6rem; font-weight: 900;">
                                                ${fn:substring(req.requesterName, 0, 1)}
                                            </div>
                                            <span style="font-weight: 700;">${req.requesterName}</span>
                                        </div>
                                    </td>
                                    <td class="tabular-nums">${req.requestedDate}</td>
                                    <td class="tabular-nums" style="color: var(--primary); font-weight: 700;">${req.proposedDueDate}</td>
                                    <td style="text-align: right;">
                                        <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                                            <form action="${pageContext.request.contextPath}/borrow" method="POST" style="display: inline;">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="request_id" value="${req.requestId}">
                                                <input type="hidden" name="item_id" value="${req.itemId}">
                                                <input type="hidden" name="requester_id" value="${req.requesterId}">
                                                <input type="hidden" name="due_date" value="${req.proposedDueDate}">
                                                <button type="submit" class="btn btn-primary" style="padding: 0.5rem 1rem; font-size: 0.625rem;">APPROVE</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/borrow" method="POST" style="display: inline;">
                                                <input type="hidden" name="action" value="reject">
                                                <input type="hidden" name="request_id" value="${req.requestId}">
                                                <input type="hidden" name="item_id" value="${req.itemId}">
                                                <button type="submit" class="btn btn-ghost" style="padding: 0.5rem 1rem; font-size: 0.625rem; color: var(--error); border-color: var(--error);">REJECT</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- Return Verifications Section --%>
        <header style="margin-top: 6rem; margin-bottom: 3rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 2rem;">
            <span class="label-md" style="color: var(--outline);">SEC. 02 // RETURN PROTOCOLS</span>
            <h2 style="font-size: 2.5rem; font-weight: 900; text-transform: uppercase; margin-top: 1rem;">Return Verifications</h2>
            <p style="opacity: 0.6; font-weight: 500;">Confirm that items have been returned in good condition before making them available again.</p>
        </header>

        <div class="ledger-container" style="margin-bottom: 4rem;">
            <table class="ledger-table">
                <thead>
                    <tr>
                        <th class="label-sm">RESOURCE</th>
                        <th class="label-sm">BORROWER</th>
                        <th class="label-sm">DATE RETURNED</th>
                        <th class="label-sm" style="text-align: right;">ACTIONS</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty pendingReturns}">
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 4rem; opacity: 0.5;">
                                    <div class="label-md">No returns awaiting verification.</div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${pendingReturns}" var="record">
                                <tr>
                                    <td>
                                        <div style="font-weight: 800; text-transform: uppercase;">${record.itemName}</div>
                                    </td>
                                    <td>
                                        <div style="font-weight: 700;">${record.borrowerName}</div>
                                    </td>
                                    <td class="tabular-nums">${record.returnDate}</td>
                                    <td style="text-align: right;">
                                        <form action="${pageContext.request.contextPath}/borrow" method="POST">
                                            <input type="hidden" name="action" value="confirm_return">
                                            <input type="hidden" name="item_id" value="${record.itemId}">
                                            <button type="submit" class="btn btn-primary" style="padding: 0.5rem 1.5rem; font-size: 0.625rem;">CONFIRM & MAKE AVAILABLE</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Trust Notice -->
        <div style="margin-top: 4rem; padding: 2rem; border-left: 4px solid var(--primary); background-color: var(--surface-container-low);">
            <div class="label-md" style="font-weight: 900;">COMMUNITY NOTICE</div>
            <p style="font-size: 0.875rem; color: var(--outline-variant); margin-top: 0.5rem;">
                Approving a request will transition the resource to "Borrowed" status and create a legal ledger entry for tracking trust scores.
            </p>
        </div>
    </main>

    <jsp:include page="components/member_footer.jsp" />

</body>
</html>
