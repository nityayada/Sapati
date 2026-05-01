<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.BorrowRequest, com.sapati.model.BorrowRecord" %>
<%
    List<BorrowRequest> requests = (List<BorrowRequest>) request.getAttribute("incomingRequests");
    List<BorrowRecord> pendingReturns = (List<BorrowRecord>) request.getAttribute("pendingReturns");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Requests | Sapati.com</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container">
        <header style="margin-bottom: 4rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 2rem;">
            <span class="label-md" style="color: var(--outline);">COMMUNITY LEDGER v1.0</span>
            <h1 style="font-size: 3rem; font-weight: 900; text-transform: uppercase; margin-top: 1rem;">Incoming Requests</h1>
            <p style="opacity: 0.6; font-weight: 500;">Review community requests to borrow your listed resources.</p>
        </header>

        <% if (request.getParameter("msg") != null) { %>
            <div class="auth-msg auth-msg-success" style="margin-bottom: 2rem;"><%= request.getParameter("msg") %> successful.</div>
        <% } %>

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
                    <% if (requests == null || requests.isEmpty()) { %>
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 5rem; opacity: 0.5;">
                                <span class="material-symbols-outlined" style="font-size: 3rem; display: block; margin-bottom: 1rem;">inbox</span>
                                <div class="label-md">No pending requests at this time.</div>
                            </td>
                        </tr>
                    <% } else { 
                        for (BorrowRequest req : requests) { %>
                        <tr>
                            <td>
                                <div style="font-weight: 800; text-transform: uppercase;"><%= req.getItemName() %></div>
                                <div style="font-size: 0.625rem; opacity: 0.5;">ID: <%= req.getItemId() %></div>
                            </td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 0.75rem;">
                                    <div style="width: 24px; height: 24px; background-color: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.6rem; font-weight: 900;">
                                        <%= req.getRequesterName().substring(0, 1) %>
                                    </div>
                                    <span style="font-weight: 700;"><%= req.getRequesterName() %></span>
                                </div>
                            </td>
                            <td class="tabular-nums"><%= req.getRequestedDate() %></td>
                            <td class="tabular-nums" style="color: var(--primary); font-weight: 700;"><%= req.getProposedDueDate() %></td>
                            <td style="text-align: right;">
                                <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                                    <form action="${pageContext.request.contextPath}/borrow" method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="request_id" value="<%= req.getRequestId() %>">
                                        <input type="hidden" name="item_id" value="<%= req.getItemId() %>">
                                        <input type="hidden" name="requester_id" value="<%= req.getRequesterId() %>">
                                        <input type="hidden" name="due_date" value="<%= req.getProposedDueDate() %>">
                                        <button type="submit" class="btn btn-primary" style="padding: 0.5rem 1rem; font-size: 0.625rem;">APPROVE</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/borrow" method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="reject">
                                        <input type="hidden" name="request_id" value="<%= req.getRequestId() %>">
                                        <input type="hidden" name="item_id" value="<%= req.getItemId() %>">
                                        <button type="submit" class="btn btn-ghost" style="padding: 0.5rem 1rem; font-size: 0.625rem; color: var(--error); border-color: var(--error);">REJECT</button>
                                    </form>

                                </div>
                            </td>
                        </tr>
                    <% } 
                    } %>
                </tbody>
            </table>
        </div>

        <%-- NEW: Return Verifications Section --%>
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
                    <% if (pendingReturns == null || pendingReturns.isEmpty()) { %>
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 4rem; opacity: 0.5;">
                                <div class="label-md">No returns awaiting verification.</div>
                            </td>
                        </tr>
                    <% } else { 
                        for (BorrowRecord record : pendingReturns) { %>
                        <tr>
                            <td>
                                <div style="font-weight: 800; text-transform: uppercase;"><%= record.getItemName() %></div>
                            </td>
                            <td>
                                <div style="font-weight: 700;"><%= record.getBorrowerName() %></div>
                            </td>
                            <td class="tabular-nums"><%= record.getReturnDate() %></td>
                            <td style="text-align: right;">
                                <form action="${pageContext.request.contextPath}/borrow" method="POST">
                                    <input type="hidden" name="action" value="confirm_return">
                                    <input type="hidden" name="item_id" value="<%= record.getItemId() %>">
                                    <button type="submit" class="btn btn-primary" style="padding: 0.5rem 1.5rem; font-size: 0.625rem;">CONFIRM & MAKE AVAILABLE</button>
                                </form>
                            </td>
                        </tr>
                    <% } 
                    } %>
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
