<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.User, com.sapati.model.Item, com.sapati.dao.ItemDAO, java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/user?action=login");
        return;
    }
    
    ItemDAO itemDAO = new ItemDAO();
    // Fetch counts dynamically where available
    Integer listedCountAttr = (Integer) request.getAttribute("listedCount");
    int listedCount = (listedCountAttr != null) ? listedCountAttr : 0;
    
    int borrowedCount = 2; // Placeholder for now
    int pendingCount = 1; // Placeholder for now
    int finesAmount = 600; // Placeholder for now
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container" style="padding: 6rem 1.5rem;">
        
        <!-- Welcome Banner - Refined -->
        <section class="welcome-banner">
            <div class="user-avatar">
                <span class="material-symbols-outlined" style="font-size: 3rem; color: var(--primary);">person</span>
            </div>
            <div>
                <div style="display: flex; align-items: baseline; gap: 1.5rem; margin-bottom: 0.75rem;">
                    <h1 style="font-size: 2.5rem; font-weight: 900; line-height: 1; text-transform: uppercase; letter-spacing: -0.02em;">Welcome back, <%= sessionUser.getFullName() %></h1>
                </div>
                <div style="display: flex; gap: 2rem; align-items: center;">
                    <span class="status-chip" style="background-color: var(--primary); color: white; border: none;">Verified Member</span>
                    <p style="font-size: 0.8125rem; color: var(--outline); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em;">
                        Node: <span style="color: var(--primary); font-weight: 800;"><%= sessionUser.getAddress() %></span>
                    </p>
                </div>
            </div>
        </section>

        <!-- Stat Row - Refined Tonal -->
        <section class="stat-row">
            <div class="stat-box">
                <span class="label-md" style="opacity: 0.6;">Items Borrowing</span>
                <div class="count"><%= borrowedCount %></div>
            </div>
            <div class="stat-box">
                <span class="label-md" style="opacity: 0.6;">My Shared Items</span>
                <div class="count"><%= listedCount %></div>
            </div>
            <div class="stat-box">
                <span class="label-md" style="opacity: 0.6;">Open Requests</span>
                <div class="count"><%= pendingCount %></div>
            </div>
            <div class="stat-box error-state">
                <span class="label-md" style="color: var(--error); opacity: 0.8;">Outstanding Balance</span>
                <div class="count" style="color: var(--error);">NPR <%= finesAmount %></div>
            </div>
        </section>

        <!-- Main Dashboard Grid -->
        <div class="dashboard-grid">
            
            <!-- Left Column -->
            <div class="space-y-12">
                
                <!-- Borrow Records -->
                <section>
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem;">
                        <h2 class="label-md" style="color: var(--primary);">RECENT BORROW RECORDS</h2>
                        <a href="#" class="label-md" style="text-decoration: underline; color: var(--outline); font-size: 0.65rem;">View Archive</a>
                    </div>
                    
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>RESOURCE</th>
                                    <th>CUSTODIAN</th>
                                    <th>INITIATED</th>
                                    <th>DUE DATE</th>
                                    <th>LEDGER STATUS</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="font-weight: 800; color: var(--primary);">Sony Alpha A7III</td>
                                    <td>Anil K.</td>
                                    <td>Oct 12</td>
                                    <td>Oct 26</td>
                                    <td><span class="status-chip">ACTIVE</span></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: 800; color: var(--primary);">Camping Tent (4P)</td>
                                    <td>Sita M.</td>
                                    <td>Oct 05</td>
                                    <td style="color: var(--error); font-weight: 900;">Oct 19</td>
                                    <td><span class="status-chip overdue">OVERDUE</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- My Listings Grid -->
                <section>
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem;">
                        <h2 class="label-md" style="color: var(--primary);">MY SHARED RESOURCES</h2>
                        <a href="${pageContext.request.contextPath}/item?action=add" class="label-md" style="color: var(--primary); text-decoration: none;">+ ADD NEW LISTING</a>
                    </div>
                    
                    <div class="grid-3" style="gap: 2rem;">
                        <div class="item-card" style="padding: 0; background-color: transparent; border: none;">
                            <div class="item-image" style="height: 180px; background-color: var(--surface-container-low); border: 1px dashed var(--outline-variant); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center;">
                                <span class="material-symbols-outlined" style="opacity: 0.2; font-size: 3rem;">category</span>
                            </div>
                            <div style="padding: 1rem 0;">
                                <h3 style="font-size: 0.875rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.75rem;">Hammer Drill</h3>
                                <div style="display: flex; gap: 1rem;">
                                    <a href="#" class="label-md" style="font-size: 0.6rem; text-decoration: underline;">EDIT</a>
                                    <a href="#" class="label-md" style="font-size: 0.6rem; color: var(--error); text-decoration: underline;">REMOVE</a>
                                </div>
                            </div>
                        </div>
                        <div class="item-card" style="padding: 0; background-color: transparent; border: none;">
                            <div class="item-image" style="height: 180px; background-color: var(--surface-container-low); border: 1px dashed var(--outline-variant); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center;">
                                <span class="material-symbols-outlined" style="opacity: 0.2; font-size: 3rem;">category</span>
                            </div>
                            <div style="padding: 1rem 0;">
                                <h3 style="font-size: 0.875rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.75rem;">Mountain Bike</h3>
                                <div style="display: flex; gap: 1rem;">
                                    <a href="#" class="label-md" style="font-size: 0.6rem; text-decoration: underline;">EDIT</a>
                                    <a href="#" class="label-md" style="font-size: 0.6rem; color: var(--error); text-decoration: underline;">REMOVE</a>
                                </div>
                            </div>
                        </div>
                        <div class="item-card" style="padding: 0; background-color: transparent; border: none;">
                            <div class="item-image" style="height: 180px; background-color: var(--surface-container-low); border: 1px dashed var(--outline-variant); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center;">
                                <span class="material-symbols-outlined" style="opacity: 0.2; font-size: 3rem;">category</span>
                            </div>
                            <div style="padding: 1rem 0;">
                                <h3 style="font-size: 0.875rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.75rem;">Digital Projector</h3>
                                <div style="display: flex; gap: 1rem;">
                                    <a href="#" class="label-md" style="font-size: 0.6rem; text-decoration: underline;">EDIT</a>
                                    <a href="#" class="label-md" style="font-size: 0.6rem; color: var(--error); text-decoration: underline;">REMOVE</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

            </div>

            <!-- Right Column -->
            <div class="space-y-12">
                
                <!-- Trust & Fines -->
                <section class="sidebar-section">
                    <h2 class="label-md" style="margin-bottom: 2rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem;">LEDGER ACCOUNT</h2>
                    <div class="sidebar-card">
                        <div style="margin-bottom: 2.5rem;">
                            <span class="label-md" style="opacity: 0.5; font-size: 0.6rem;">Outstanding Liabilities</span>
                            <div style="font-size: 2.5rem; font-weight: 900; color: var(--error);">NPR 600</div>
                        </div>
                        <ul style="margin-bottom: 2.5rem; border-top: 1px dashed var(--outline-variant); padding-top: 1.5rem;">
                            <li style="display: flex; justify-content: space-between; margin-bottom: 1.25rem;">
                                <div>
                                    <span style="font-weight: 800; font-size: 0.8125rem;">Camping Tent</span><br>
                                    <span style="font-size: 0.625rem; font-weight: 800; color: var(--error); text-transform: uppercase;">LATE FINE [4D]</span>
                                </div>
                                <span style="font-weight: 900; font-size: 0.8125rem;">400</span>
                            </li>
                            <li style="display: flex; justify-content: space-between;">
                                <div>
                                    <span style="font-weight: 800; font-size: 0.8125rem;">Service Charge</span><br>
                                    <span style="font-size: 0.625rem; opacity: 0.5; text-transform: uppercase;">ADMIN FEE</span>
                                </div>
                                <span style="font-weight: 900; font-size: 0.8125rem;">200</span>
                            </li>
                        </ul>
                        <button class="btn btn-primary" style="width: 100%; padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.15em;">RESOLVE BALANCE</button>
                    </div>
                </section>

                <!-- Quick Actions -->
                <section class="sidebar-section">
                    <h2 class="label-md" style="margin-bottom: 2rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem;">DASHBOARD ACTIONS</h2>
                    <div class="action-list">
                        <a href="${pageContext.request.contextPath}/item?action=add" class="action-item">
                            INITIATE NEW LISTING
                            <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/item?action=list" class="action-item">
                            CATALOG BROWSER
                            <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                        </a>
                        <a href="#" class="action-item">
                            TRUST PROTOCOLS
                            <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/contact" class="action-item">
                            SYSTEM SUPPORT
                            <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                        </a>
                    </div>
                </section>

            </div>

        </div>

    </main>

    <jsp:include page="components/member_footer.jsp" />

</body>
</html>