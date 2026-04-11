<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.User" %>
<%
    Integer userCount = (Integer) request.getAttribute("userCount");
    Integer itemCount = (Integer) request.getAttribute("itemCount");
    Integer activeBorrows = (Integer) request.getAttribute("activeBorrows");
    Double totalUnpaidFines = (Double) request.getAttribute("totalUnpaidFines");
    boolean isLoggedIn = session.getAttribute("user") != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Command Center | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
    
    <style>
        .admin-banner {
            background-color: var(--primary);
            color: white;
            padding: 0.5rem 1.5rem;
            font-family: 'Inter', sans-serif;
            font-weight: 900;
            font-size: 0.75rem;
            letter-spacing: 0.4em;
            text-align: center;
            text-transform: uppercase;
        }
        
        .metric-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            border: 1px solid var(--outline-variant);
            margin-bottom: 4rem;
        }
        
        .metric-tile {
            padding: 3rem;
            border-right: 1px solid var(--outline-variant);
            background-color: white;
        }
        
        .metric-tile:last-child {
            border-right: none;
        }
        
        .metric-value {
            font-size: 3.5rem;
            font-weight: 900;
            letter-spacing: -0.05em;
            line-height: 1;
            margin-bottom: 0.5rem;
        }
        
        .metric-label {
            font-size: 0.75rem;
            font-weight: 800;
            color: var(--outline);
            text-transform: uppercase;
            letter-spacing: 0.15em;
        }
        
        .admin-action-card {
            border: 1px solid var(--outline-variant);
            padding: 3rem;
            background-color: white;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .admin-action-card:hover {
            background-color: var(--surface-container-low);
            transform: translateY(-4px);
            border-color: var(--primary);
        }
    </style>
</head>
<body style="background-color: var(--surface);">

    <div class="admin-banner">SYSTEM AUTHORITY MODE ACTIVE // SAPATI COMMAND CENTER</div>

    <% if (isLoggedIn) { %>
        <jsp:include page="components/member_header.jsp" />
    <% } else { %>
        <jsp:include page="components/public_header.jsp" />
    <% } %>

    <main class="container" style="padding: 6rem 1.5rem 8rem 1.5rem;">
        
        <header style="margin-bottom: 6rem;">
            <span class="label-md" style="color: var(--primary); letter-spacing: 0.3em; margin-bottom: 1.5rem; display: block;">OVERWATCH DASHBOARD</span>
            <h1 style="font-size: 5rem; font-weight: 900; line-height: 0.95; letter-spacing: -0.04em; text-transform: uppercase;">
                Community <br>Resource Ledger
            </h1>
        </header>

        <!-- Metric Grid -->
        <section class="metric-grid">
            <div class="metric-tile">
                <div class="metric-value"><%= userCount %></div>
                <div class="metric-label">Verified Nodes</div>
            </div>
            <div class="metric-tile">
                <div class="metric-value"><%= itemCount %></div>
                <div class="metric-label">Total Resources</div>
            </div>
            <div class="metric-tile">
                <div class="metric-value"><%= activeBorrows %></div>
                <div class="metric-label">Live Exchanges</div>
            </div>
            <div class="metric-tile">
                <div class="metric-value" style="color: var(--error);">
                    <%= totalUnpaidFines > 0 ? "NPR " + Math.round(totalUnpaidFines) : "Clean" %>
                </div>
                <div class="metric-label">Outstanding Liability</div>
            </div>
        </section>

        <!-- Functional Access points -->
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem;">
            
            <div class="admin-action-card">
                <div>
                    <span class="material-symbols-outlined" style="font-size: 3rem; margin-bottom: 2rem; color: var(--primary);">person_celebrate</span>
                    <h3 style="font-size: 1.5rem; font-weight: 900; text-transform: uppercase; margin-bottom: 1rem;">Member Directory</h3>
                    <p style="font-size: 0.875rem; color: var(--on-surface-variant); line-height: 1.6; margin-bottom: 2rem;">
                        Audit user accounts, manage trust scores, and handle system access permissions.
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/admin?action=manage_users" class="btn btn-secondary" style="width: 100%; letter-spacing: 0.2em;">ACCESS RECORDS</a>
            </div>

            <div class="admin-action-card">
                <div>
                    <span class="material-symbols-outlined" style="font-size: 3rem; margin-bottom: 2rem; color: var(--primary);">inventory_2</span>
                    <h3 style="font-size: 1.5rem; font-weight: 900; text-transform: uppercase; margin-bottom: 1rem;">Global Inventory</h3>
                    <p style="font-size: 0.875rem; color: var(--on-surface-variant); line-height: 1.6; margin-bottom: 2rem;">
                        Verify item listings, moderate community submissions, and update resource status.
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/admin?action=manage_items" class="btn btn-secondary" style="width: 100%; letter-spacing: 0.2em;">REVIEW ASSETS</a>
            </div>

            <div class="admin-action-card">
                <div>
                    <span class="material-symbols-outlined" style="font-size: 3rem; margin-bottom: 2rem; color: var(--primary);">monitoring</span>
                    <h3 style="font-size: 1.5rem; font-weight: 900; text-transform: uppercase; margin-bottom: 1rem;">System Audit</h3>
                    <p style="font-size: 0.875rem; color: var(--on-surface-variant); line-height: 1.6; margin-bottom: 2rem;">
                        Analyze community exchange patterns, fine accruals, and platform growth metrics.
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/admin?action=reports" class="btn btn-primary" style="width: 100%; letter-spacing: 0.2em;">GENERATE REPORT</a>
            </div>

        </div>

    </main>

    <jsp:include page="components/public_header.jsp" />

</body>
</html>
