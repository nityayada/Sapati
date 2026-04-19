<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.sapati.model.BorrowRecord, com.sapati.model.BorrowRequest, com.sapati.model.User" %>
<%
    List<BorrowRecord> records = (List<BorrowRecord>) request.getAttribute("borrowRecords");
    List<BorrowRequest> pendingRequests = (List<BorrowRequest>) request.getAttribute("borrowRequests");
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("borrowStats");
    Double totalFine = (Double) request.getAttribute("totalFine");
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Borrowings | Sapati.com</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container">
        <% 
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if (msg != null || error != null) {
        %>
            <div style="margin: 2rem 0;">
                <% if ("request_sent".equalsIgnoreCase(msg)) { %>
                    <div class="auth-msg auth-msg-success">
                        <div style="display: flex; align-items: center; gap: 1rem;">
                            <span class="material-symbols-outlined">check_circle</span>
                            <span>BORROW REQUEST TRANSMITTED SUCCESSFULLY. AWAITING OWNER OVERSIGHT.</span>
                        </div>
                    </div>
                <% } else if (msg != null) { %>
                    <div class="auth-msg auth-msg-success">
                        <%= msg %>
                    </div>
                <% } %>

                <% if (error != null) { %>
                    <div class="auth-msg auth-msg-error">
                        <div style="display: flex; align-items: center; gap: 1rem;">
                            <span class="material-symbols-outlined">error</span>
                            <span><%= error.replace("_", " ").toUpperCase() %></span>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        
        <!-- Editorial Header Section -->
        <section style="margin-bottom: 4rem;">
            <div style="display: flex; justify-content: space-between; align-items: flex-end; gap: 2rem; flex-wrap: wrap;">
                <div style="max-width: 600px;">
                    <span class="label-md" style="color: var(--outline); margin-bottom: 1rem; display: block;">ARCHIVE.PERSONAL_LEDGER</span>
                    <h1 style="font-size: 4rem; font-weight: 900; line-height: 0.9; text-transform: uppercase; margin-bottom: 1.5rem; letter-spacing: -0.04em;">My Borrowings</h1>
                    <p style="color: var(--on-surface-variant); line-height: 1.6;">
                        A curated history of community trust. Track active loans, pending returns, and historical exchanges within the Sapati ecosystem.
                    </p>
                </div>
                <div style="text-align: right;">
                    <span class="label-sm" style="color: var(--outline); margin-bottom: 0.5rem; display: block;">OUTSTANDING FINES</span>
                    <div style="font-size: 3rem; font-weight: 900; letter-spacing: -0.05em;">NPR <%= String.format("%.2f", totalFine != null ? totalFine : 0.0) %></div>
                </div>
            </div>
        </section>

        <!-- Stats Bento Grid -->
        <section class="bento-grid">
            <div class="stat-box" style="grid-column: span 4;">
                <span class="stat-label">Active Loans</span>
                <span class="stat-value"><%= stats != null ? String.format("%02d", stats.get("active")) : "00" %></span>
            </div>
            <div class="stat-box highlight" style="grid-column: span 4;">
                <span class="stat-label">Overdue Items</span>
                <span class="stat-value" style="color: var(--error);"><%= stats != null ? String.format("%02d", stats.get("overdue")) : "00" %></span>
            </div>
            <div class="stat-box" style="grid-column: span 4;">
                <span class="stat-label">Total Exchanges</span>
                <span class="stat-value"><%= stats != null ? String.format("%02d", stats.get("total")) : "00" %></span>
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
                    </tr>
                </thead>
                <tbody>
                    <% if (records == null || records.isEmpty()) { %>
                        <tr>
                            <td colspan="6" style="padding: 10rem 0; text-align: center;">
                                <span class="material-symbols-outlined" style="font-size: 4rem; opacity: 0.1; margin-bottom: 2rem;">history_edu</span>
                                <h3 style="font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em; color: var(--outline);">No Ledger Entries Found</h3>
                                <p style="font-size: 0.75rem; color: var(--outline); margin-top: 1rem;">YOUR RECENT EXCHANGES WILL APPEAR HERE.</p>
                            </td>
                        </tr>
                    <% } else { 
                        for (BorrowRecord record : records) {
                            String statusClass = "";
                            if ("Active".equalsIgnoreCase(record.getStatus())) statusClass = "badge-active";
                            else if ("Overdue".equalsIgnoreCase(record.getStatus())) statusClass = "badge-overdue";
                            else statusClass = "badge-returned";
                    %>
                        <tr>
                            <td>
                                <div class="item-info">
                                    <div class="item-thumb">
                                        <span class="material-symbols-outlined" style="color: var(--outline); opacity: 0.5;">inventory_2</span>
                                    </div>
                                    <div>
                                        <div style="font-weight: 900; text-transform: uppercase; letter-spacing: -0.02em;"><%= record.getItemName() %></div>
                                        <div style="font-size: 0.625rem; font-weight: 800; color: var(--outline); text-transform: uppercase;">REF_ID: #<%= record.getItemId() %>-S</div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 0.5rem;">
                                    <div style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--primary);"></div>
                                    <span style="font-weight: 700; text-transform: uppercase; font-size: 0.75rem;"><%= record.getOwnerName() %></span>
                                </div>
                            </td>
                            <td class="tabular"><%= record.getBorrowDate() %></td>
                            <td class="tabular" style="<%= "Overdue".equalsIgnoreCase(record.getStatus()) ? "color: var(--error); font-weight: 900;" : "" %>">
                                <%= record.getDueDate() %>
                            </td>
                            <td>
                                <span class="badge <%= statusClass %>"><%= record.getStatus() %></span>
                            </td>
                            <td style="text-align: right;" class="tabular">
                                <%= "Overdue".equalsIgnoreCase(record.getStatus()) ? "NPR --" : "-" %>
                            </td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

        <div style="margin-top: 4rem; display: flex; justify-content: space-between; align-items: center;">
            <div class="label-sm" style="color: var(--outline);">END OF LEDGER RECORD</div>
            <div style="display: flex; gap: 0.5rem;">
                <button class="btn btn-ghost" style="padding: 0.75rem 1.5rem; border: 1px solid var(--outline-variant); font-size: 0.75rem;">PREV</button>
                <div style="width: 40px; height: 40px; background-color: var(--primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 0.75rem;">01</div>
                <button class="btn btn-ghost" style="padding: 0.75rem 1.5rem; border: 1px solid var(--outline-variant); font-size: 0.75rem;">NEXT</button>
            </div>
        </div>

    </main>

    <jsp:include page="components/member_footer.jsp" />

</body>
</html>
