<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Borrows - Sapati</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <main class="main-content">
        <div class="section-header">
            <h2 style="color: white;">My Borrowing History</h2>
        </div>

        <c:if test="${param.msg == 'request_sent'}">
            <div class="success-msg">Your borrow request has been sent to the owner!</div>
        </c:if>

        <div class="card">
            <table style="width: 100%; border-collapse: collapse; text-align: left;">
                <thead>
                    <tr style="border-bottom: 2px solid #eee;">
                        <th style="padding: 1rem;">Item</th>
                        <th style="padding: 1rem;">Borrow Date</th>
                        <th style="padding: 1rem;">Due Date</th>
                        <th style="padding: 1rem;">Status</th>
                        <th style="padding: 1rem;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="5" style="padding: 2rem; text-align: center; color: #666;">
                            You haven't borrowed anything yet. <a href="itemList.jsp" style="color: var(--primary)">Start browsing!</a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </main>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
