<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.BorrowRecord, com.sapati.model.User" %>
<%
    BorrowRecord record = (BorrowRecord) request.getAttribute("record");
    Long daysLate = (Long) request.getAttribute("daysLate");
    Double amount = (Double) request.getAttribute("amount");
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fine Settlement | Sapati.com</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
</head>
<body style="background-color: var(--surface); min-height: 100vh; display: flex; flex-direction: column;">

    <jsp:include page="components/member_header.jsp" />

    <main class="container" style="flex: 1; display: flex; align-items: center; justify-content: center; padding: 4rem 0;">
        <div class="auth-card" style="max-width: 600px; width: 100%; border: 2px solid var(--primary); padding: 4rem; background: white;">
            
            <div style="text-align: center; margin-bottom: 3rem;">
                <span class="material-symbols-outlined" style="font-size: 4rem; color: var(--error); margin-bottom: 1.5rem;">history_toggle_off</span>
                <span class="label-md" style="color: var(--outline); display: block; margin-bottom: 0.5rem;">COMMUNITY ACCOUNTABILITY</span>
                <h1 style="font-size: 2.5rem; font-weight: 900; text-transform: uppercase; letter-spacing: -0.02em; line-height: 1;">Fine Settlement Required</h1>
            </div>

            <div style="background-color: var(--surface-container-low); padding: 2rem; border-left: 4px solid var(--primary); margin-bottom: 3rem;">
                <p style="font-size: 0.875rem; line-height: 1.6; color: var(--on-surface-variant);">
                    The resource <strong><%= record.getItemName() %></strong> was due on <strong><%= record.getDueDate() %></strong>. 
                    Our records indicate it is currently <strong><%= daysLate %> days overdue</strong>.
                </p>
            </div>

            <div style="border-top: 1px solid var(--outline-variant); border-bottom: 1px solid var(--outline-variant); padding: 2rem 0; margin-bottom: 3rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                    <span class="label-md" style="color: var(--outline);">DAILY LATE RATE</span>
                    <span style="font-weight: 700;">NPR 50.00</span>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <span class="label-md" style="color: var(--outline);">DAYS OVERDUE</span>
                    <span style="font-weight: 700;"><%= daysLate %> DAYS</span>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span class="label-md" style="color: var(--primary); font-weight: 900;">TOTAL AMOUNT DUE</span>
                    <span style="font-size: 1.5rem; font-weight: 900; color: var(--primary);">NPR <%= String.format("%.2f", amount) %></span>
                </div>
            </div>

            <div style="display: flex; flex-direction: column; gap: 1rem;">
                <a href="${pageContext.request.contextPath}/payment?action=mock_gateway&amount=<%= amount %>&record_id=<%= record.getRecordId() %>" class="btn btn-primary" style="width: 100%; padding: 1.5rem; display: flex; align-items: center; justify-content: center; gap: 1rem; font-size: 0.8125rem; letter-spacing: 0.2em;">
                    <span class="material-symbols-outlined">payments</span>
                    PROCEED TO SECURE PAYMENT
                </a>
                <a href="${pageContext.request.contextPath}/item?action=myBorrowings" style="text-align: center; font-size: 0.75rem; font-weight: 800; color: var(--outline); text-decoration: none; text-transform: uppercase; letter-spacing: 0.1em; margin-top: 1rem;">CANCEL & RETURN LATER</a>
            </div>

            <p style="font-size: 0.625rem; color: var(--outline); text-align: center; margin-top: 3rem; line-height: 1.6; text-transform: uppercase;">
                Your fines help maintain the Sapati community resource pool. All transactions are logged in the public ledger for audit.
            </p>
        </div>
    </main>

    <jsp:include page="components/member_footer.jsp" />

</body>
</html>
