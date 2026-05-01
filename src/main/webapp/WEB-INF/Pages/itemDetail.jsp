<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.Item, com.sapati.model.User, java.time.LocalDate" %>
<%
    Item item = (Item) request.getAttribute("item");
    User owner = (User) request.getAttribute("owner");
    User currentUser = (User) session.getAttribute("user");
    boolean isOwner = currentUser != null && owner != null && currentUser.getUserId() == owner.getUserId();
%>
<%
    boolean isAdmin = currentUser != null && "Admin".equalsIgnoreCase(currentUser.getRole());
%>
<% if (!isAdmin) { %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= item != null ? item.getName() : "Item Details" %> | Sapati.com</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container">
        
        <!-- Breadcrumb / Navigation -->
        <nav style="margin-bottom: 3rem; display: flex; align-items: center; gap: 1rem;">
            <a href="${pageContext.request.contextPath}/item?action=list" class="material-symbols-outlined" style="text-decoration: none; color: var(--primary); font-size: 1.5rem;">arrow_back</a>
            <span class="label-md" style="color: var(--outline);">BACK TO COMMONS</span>
        </nav>
<% } else { %>
    <jsp:include page="components/admin_layout_header.jsp">
        <jsp:param name="action" value="manage_items" />
    </jsp:include>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
    
    <!-- Admin Breadcrumb -->
    <nav style="margin-bottom: 3rem; display: flex; align-items: center; gap: 1rem;">
        <a href="${pageContext.request.contextPath}/admin?action=manage_items" class="material-symbols-outlined" style="text-decoration: none; color: var(--primary); font-size: 1.5rem;">arrow_back</a>
        <span class="label-md" style="color: var(--outline);">BACK TO GLOBAL INVENTORY</span>
    </nav>
<% } %>

        <% if (item == null) { %>
            <div style="text-align: center; padding: 10rem 0;">
                <h1 style="font-weight: 900; text-transform: uppercase;">Resource Not Found</h1>
                <a href="${pageContext.request.contextPath}/item?action=list" class="btn btn-primary" style="margin-top: 2rem; display: inline-block;">RETURN TO CATALOG</a>
            </div>
        <% } else { %>
            <div class="editorial-grid">
                
                <!-- Left: Visual Identity -->
                <section>
                    <div class="detail-canvas">
                        <img src="<%= (item.getImagePath() != null && !item.getImagePath().isEmpty()) ? item.getImagePath() : "" %>" alt="<%= item.getName() %>">
                        <% if (item.getImagePath() == null || item.getImagePath().isEmpty()) { %>
                            <span class="material-symbols-outlined" style="font-size: 8rem; opacity: 0.05; position: absolute;">inventory_2</span>
                        <% } %>
                        <div style="position: absolute; bottom: 0; right: 0; background-color: var(--primary); color: white; padding: 1rem 2rem; font-size: 0.625rem; font-weight: 900; text-transform: uppercase; letter-spacing: 0.2em;">
                            IDENTITY.SPEC_<%= item.getItemId() %>
                        </div>
                    </div>

                    <!-- Small Gallery / Specs -->
                    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; margin-top: 1.5rem;">
                        <% for(int i=0; i<4; i++) { %>
                            <div style="aspect-ratio: 1/1; border: 1px dashed var(--outline-variant); background-color: var(--surface-container-low); display: flex; align-items: center; justify-content: center; opacity: 0.3;">
                                <span class="material-symbols-outlined" style="font-size: 1.5rem;">photo_camera</span>
                            </div>
                        <% } %>
                    </div>
                </section>

                <!-- Right: Metadata & Actions -->
                <section>
                    <div class="item-meta-badge">COMMUNITY RESOURCE</div>
                    
                    <h1 style="font-size: 4rem; font-weight: 900; text-transform: uppercase; line-height: 0.9; letter-spacing: -0.04em; margin-bottom: 2rem;">
                        <%= item.getName() %>
                    </h1>

                    <div style="display: flex; align-items: center; gap: 2rem; margin-bottom: 3rem;">
                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                            <% 
                                String detStatus = item.getStatus();
                                String detColor = "#22c55e";
                                String detIcon = "check_circle";
                                if ("Listed".equalsIgnoreCase(detStatus)) {
                                    detStatus = "PENDING REVIEW";
                                    detColor = "var(--secondary)";
                                    detIcon = "panding";
                                } else if ("Rejected".equalsIgnoreCase(detStatus)) {
                                    detColor = "var(--error)";
                                    detIcon = "cancel";
                                }
                            %>
                            <span class="material-symbols-outlined" style="color: <%= detColor %>; font-size: 1.25rem;"><%= detIcon %></span>
                            <span style="font-weight: 800; text-transform: uppercase; font-size: 0.75rem; color: <%= detColor %>;"><%= detStatus %></span>
                        </div>
                        <div style="width: 1px; height: 16px; background-color: var(--outline-variant);"></div>
                        <span class="label-sm" style="color: var(--outline);"><%= owner != null ? owner.getAddress() : "Location Unknown" %></span>
                    </div>

                    <div class="description-quote">
                        "<%= (item.getDescription() != null && !item.getDescription().isEmpty()) ? item.getDescription() : "No additional specifications provided for this community resource." %>"
                    </div>

                    <div>
                        <span class="label-md" style="color: var(--outline); display: block; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem; margin-bottom: 1.5rem;">RULES & CONDITIONS</span>
                        <ul class="rules-list">
                            <li>
                                <span class="material-symbols-outlined" style="font-size: 1.25rem;">health_and_safety</span>
                                <div>
                                    <div style="font-weight: 800; font-size: 0.75rem; text-transform: uppercase;">Condition</div>
                                    <div style="font-size: 0.875rem; color: var(--on-surface-variant);"><%= item.getItemCondition() %></div>
                                </div>
                            </li>
                            <li>
                                <span class="material-symbols-outlined" style="font-size: 1.25rem; color: var(--error);">warning</span>
                                <div>
                                    <div style="font-weight: 800; font-size: 0.75rem; text-transform: uppercase;">Late Fee</div>
                                    <div style="font-size: 0.875rem; color: var(--on-surface-variant);">NPR 50/day fine applies if not returned by due date.</div>
                                </div>
                            </li>
                            <li>
                                <span class="material-symbols-outlined" style="font-size: 1.25rem;">timer</span>
                                <div>
                                    <div style="font-weight: 800; font-size: 0.75rem; text-transform: uppercase;">Max Duration</div>
                                    <div style="font-size: 0.875rem; color: var(--on-surface-variant);">7 Days maximum borrowing period.</div>
                                </div>
                            </li>
                        </ul>
                    </div>

                    <div style="margin-top: 4rem;">
                        <span class="label-md" style="color: var(--outline); display: block; margin-bottom: 1.5rem;">LENDER NODE</span>
                        <div class="lender-profile-card">
                            <div style="display: flex; align-items: center; gap: 1.5rem;">
                                <div class="lender-avatar">
                                    <span class="material-symbols-outlined">person</span>
                                </div>
                                <div>
                                    <div style="font-weight: 900; text-transform: uppercase; font-size: 0.875rem;"><%= owner != null ? owner.getFullName() : "Anonymous" %></div>
                                    <div class="label-sm" style="font-size: 0.625rem; opacity: 0.6;">Verified Community Member</div>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <div style="display: flex; align-items: center; justify-content: flex-end; gap: 0.25rem; color: var(--primary);">
                                    <span class="material-symbols-outlined" style="font-size: 1rem; font-variation-settings: 'FILL' 1;">star</span>
                                    <span style="font-weight: 900; font-size: 0.875rem;">4.9</span>
                                </div>
                                <div class="label-sm" style="font-size: 0.5rem; color: var(--outline);">TRUST SCORE</div>
                            </div>
                        </div>
                    </div>

                    <div style="margin-top: 3rem;">
                        <% if (isAdmin) { %>
                            <div style="border: 2px dashed var(--outline-variant); padding: 2rem; text-align: center; background-color: var(--surface-container-low);">
                                <span class="material-symbols-outlined" style="font-size: 2rem; margin-bottom: 1rem; color: var(--primary);">admin_panel_settings</span>
                                <div style="font-weight: 900; text-transform: uppercase; font-size: 0.8125rem; letter-spacing: 0.1em; color: var(--primary);">Administrative Oversight Mode</div>
                                <div style="font-size: 0.65rem; opacity: 0.8; margin-top: 0.5rem;">YOU ARE VIEWING THIS RESOURCE AS A SYSTEM MODERATOR. BORROWING IS DISABLED.</div>
                            </div>
                        <% } else if (isOwner) { %>
                            <a href="${pageContext.request.contextPath}/item?action=edit&id=<%= item.getItemId() %>" class="btn btn-primary" style="width: 100%; padding: 1.5rem; text-align: center; font-size: 0.75rem; letter-spacing: 0.3em; background-color: var(--surface-container-high); color: var(--primary); border: 1px solid var(--primary); text-decoration: none; display: block;">EDIT LISTING</a>
                        <% } else if ("Available".equalsIgnoreCase(item.getStatus())) { %>
                            <% if (request.getParameter("error") != null) { %>
                                <div class="auth-msg auth-msg-error" style="margin-bottom: 2rem;"><%= request.getParameter("error") %></div>
                            <% } %>

                            <form action="${pageContext.request.contextPath}/borrow" method="POST">
                                <input type="hidden" name="action" value="request">
                                <input type="hidden" name="item_id" value="<%= item.getItemId() %>">
                                
                                <div style="margin-bottom: 2rem;">
                                    <label class="label-md" style="color: var(--outline); display: block; margin-bottom: 1rem;">PROPOSED RETURN DATE</label>
                                    <input type="date" name="return_date" class="form-input" required 
                                           min="<%= LocalDate.now().plusDays(1).toString() %>" 
                                           max="<%= LocalDate.now().plusDays(7).toString() %>"
                                           style="width: 100%; font-family: inherit; font-weight: 800; border-radius: 0;">
                                    <span class="label-sm" style="display: block; margin-top: 0.5rem; opacity: 0.6;">Maximum borrowing period: 7 days.</span>
                                </div>

                                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1.5rem; font-size: 0.75rem; letter-spacing: 0.3em; display: flex; align-items: center; justify-content: center; gap: 1rem;">
                                    <span class="material-symbols-outlined">send</span>
                                    REQUEST TO BORROW
                                </button>
                            </form>
                        <% } else if ("Listed".equalsIgnoreCase(item.getStatus())) { %>
                            <div style="border: 1px solid var(--secondary); padding: 2rem; text-align: center; background-color: var(--secondary); color: white;">
                                <span class="material-symbols-outlined" style="font-size: 2rem; margin-bottom: 1rem;">policy</span>
                                <div style="font-weight: 900; text-transform: uppercase; font-size: 0.8125rem; letter-spacing: 0.1em;">Under Administrative Review</div>
                                <div style="font-size: 0.65rem; opacity: 0.8; margin-top: 0.5rem;">THIS RESOURCE IS AWAITING VERIFICATION BEFORE IT BECOMES PUBLICLY BORROWABLE.</div>
                            </div>
                        <% } else if ("Rejected".equalsIgnoreCase(item.getStatus())) { %>
                            <div style="border: 1px solid var(--error); padding: 2rem; text-align: center; background-color: var(--error); color: white;">
                                <span class="material-symbols-outlined" style="font-size: 2rem; margin-bottom: 1rem;">cancel</span>
                                <div style="font-weight: 900; text-transform: uppercase; font-size: 0.8125rem; letter-spacing: 0.1em;">Listing Decertified</div>
                                <div style="font-size: 0.65rem; opacity: 0.8; margin-top: 0.5rem;">THIS ENTRY DOES NOT MEET COMMUNITY STANDARDS AND IS FLAGED BY MODERATORS.</div>
                            </div>
                        <% } else { %>
                            <button disabled class="btn btn-primary" style="width: 100%; padding: 1.5rem; font-size: 0.75rem; letter-spacing: 0.3em; opacity: 0.5; background-color: var(--outline-variant); cursor: not-allowed;">RESOURCE CURRENTLY LOANED</button>
                        <% } %>
                    </div>

                </section>
            </div>
        <% } %>

    </main>

    <% if (!isAdmin) { %>
        <jsp:include page="components/member_footer.jsp" />
    </body>
    </html>
    <% } else { %>
        <jsp:include page="components/admin_layout_footer.jsp" />
    <% } %>
