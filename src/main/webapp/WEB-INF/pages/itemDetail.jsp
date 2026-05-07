<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:useBean id="now" class="java.util.Date" />
<c:set var="sevenDaysInMs" value="${7 * 24 * 60 * 60 * 1000}" />
<jsp:useBean id="maxDate" class="java.util.Date" />
<c:set target="${maxDate}" property="time" value="${now.time + sevenDaysInMs}" />

<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="minDateStr" />
<fmt:formatDate value="${maxDate}" pattern="yyyy-MM-dd" var="maxDateStr" />
<c:set var="isAdmin" value="${not empty sessionScope.user and sessionScope.user.role.equalsIgnoreCase('Admin')}" />
<c:set var="isOwner" value="${not empty sessionScope.user and not empty owner and sessionScope.user.userId eq owner.userId}" />

<c:choose>
    <c:when test="${not isAdmin}">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty item ? item.name : 'Item Details'} | Sapati.com</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
</head>
<body style="background-color: var(--surface);">
    <jsp:include page="components/member_header.jsp" />
    <main class="container">
        <!-- Breadcrumb / Navigation -->
        <nav style="margin-bottom: 3rem; display: flex; align-items: center; gap: 1rem;">
            <a href="${pageContext.request.contextPath}/item?action=list" class="material-symbols-outlined" style="text-decoration: none; color: var(--primary); font-size: 1.5rem;">arrow_back</a>
            <span class="label-md" style="color: var(--outline);">BACK TO COMMONS</span>
        </nav>

        <c:choose>
            <c:when test="${empty item}">
                <div style="text-align: center; padding: 10rem 0;">
                    <h1 style="font-weight: 900; text-transform: uppercase;">Resource Not Found</h1>
                    <a href="${pageContext.request.contextPath}/item?action=list" class="btn btn-primary" style="margin-top: 2rem; display: inline-block;">RETURN TO CATALOG</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="editorial-grid">
                    <!-- Left: Visual Identity -->
                    <section>
                        <div class="detail-canvas">
                            <img src="${not empty item.imagePath ? item.imagePath : ''}" alt="${item.name}">
                            <c:if test="${empty item.imagePath}">
                                <span class="material-symbols-outlined" style="font-size: 8rem; opacity: 0.05; position: absolute;">inventory_2</span>
                            </c:if>
                            <div style="position: absolute; bottom: 0; right: 0; background-color: var(--primary); color: white; padding: 1rem 2rem; font-size: 0.625rem; font-weight: 900; text-transform: uppercase; letter-spacing: 0.2em;">
                                IDENTITY.SPEC_${item.itemId}
                            </div>
                        </div>
                        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; margin-top: 1.5rem;">
                            <c:forEach begin="1" end="4">
                                <div style="aspect-ratio: 1/1; border: 1px dashed var(--outline-variant); background-color: var(--surface-container-low); display: flex; align-items: center; justify-content: center; opacity: 0.3;">
                                    <span class="material-symbols-outlined" style="font-size: 1.5rem;">photo_camera</span>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                    <!-- Right: Metadata & Actions -->
                    <section>
                        <div class="item-meta-badge">COMMUNITY RESOURCE</div>
                        <h1 style="font-size: 4rem; font-weight: 900; text-transform: uppercase; line-height: 0.9; letter-spacing: -0.04em; margin-bottom: 2rem;">${item.name}</h1>
                        <div style="display: flex; align-items: center; gap: 2rem; margin-bottom: 3rem;">
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <c:choose>
                                    <c:when test="${item.status.equalsIgnoreCase('Listed')}">
                                        <c:set var="detStatus" value="PENDING REVIEW" /><c:set var="detColor" value="var(--secondary)" /><c:set var="detIcon" value="pending" />
                                    </c:when>
                                    <c:when test="${item.status.equalsIgnoreCase('Rejected')}">
                                        <c:set var="detStatus" value="REJECTED" /><c:set var="detColor" value="var(--error)" /><c:set var="detIcon" value="cancel" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="detStatus" value="${item.status}" /><c:set var="detColor" value="#22c55e" /><c:set var="detIcon" value="check_circle" />
                                    </c:otherwise>
                                </c:choose>
                                <span class="material-symbols-outlined" style="color: ${detColor}; font-size: 1.25rem;">${detIcon}</span>
                                <span style="font-weight: 800; text-transform: uppercase; font-size: 0.75rem; color: ${detColor};">${detStatus}</span>
                            </div>
                            <div style="width: 1px; height: 16px; background-color: var(--outline-variant);"></div>
                            <span class="label-sm" style="color: var(--outline);">${not empty owner ? owner.address : 'Location Unknown'}</span>
                        </div>
                        <div class="description-quote">"${not empty item.description ? item.description : 'No additional specifications provided for this community resource.'}"</div>
                        <div>
                            <span class="label-md" style="color: var(--outline); display: block; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem; margin-bottom: 1.5rem;">RULES & CONDITIONS</span>
                            <ul class="rules-list">
                                <li><span class="material-symbols-outlined">health_and_safety</span><div><div style="font-weight: 800; font-size: 0.75rem; text-transform: uppercase;">Condition</div><div style="font-size: 0.875rem; color: var(--on-surface-variant);">${item.itemCondition}</div></div></li>
                                <li><span class="material-symbols-outlined" style="color: var(--error);">warning</span><div><div style="font-weight: 800; font-size: 0.75rem; text-transform: uppercase;">Late Fee</div><div style="font-size: 0.875rem; color: var(--on-surface-variant);">NPR 50/day fine applies.</div></div></li>
                                <li><span class="material-symbols-outlined">timer</span><div><div style="font-weight: 800; font-size: 0.75rem; text-transform: uppercase;">Max Duration</div><div style="font-size: 0.875rem; color: var(--on-surface-variant);">7 Days.</div></div></li>
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
                                        <div style="font-weight: 900; text-transform: uppercase; font-size: 0.875rem;">${not empty owner ? owner.fullName : 'Anonymous'}</div>
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
                            <c:choose>
                                <c:when test="${isOwner}">
                                    <a href="${pageContext.request.contextPath}/item?action=edit&id=${item.itemId}" class="btn btn-primary" style="width: 100%; padding: 1.5rem; text-align: center; font-size: 0.75rem; letter-spacing: 0.3em; background-color: var(--surface-container-high); color: var(--primary); border: 1px solid var(--primary); text-decoration: none; display: block;">EDIT LISTING</a>
                                </c:when>
                                <c:when test="${item.status.equalsIgnoreCase('Available')}">
                                    <c:if test="${not empty param.error}"><div class="auth-msg auth-msg-error" style="margin-bottom: 2rem;">${param.error}</div></c:if>
                                    <form action="${pageContext.request.contextPath}/borrow" method="POST">
                                        <input type="hidden" name="action" value="request"><input type="hidden" name="item_id" value="${item.itemId}">
                                        <div style="margin-bottom: 2rem;">
                                            <label class="label-md" style="color: var(--outline); display: block; margin-bottom: 1rem;">PROPOSED RETURN DATE</label>
                                            <input type="date" name="return_date" class="form-input" required min="${minDateStr}" max="${maxDateStr}" style="width: 100%; border-radius: 0;">
                                            <span class="label-sm" style="display: block; margin-top: 0.5rem; opacity: 0.6;">Maximum borrowing period: 7 days.</span>
                                        </div>
                                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1.5rem; font-size: 0.75rem; letter-spacing: 0.3em; display: flex; align-items: center; justify-content: center; gap: 1rem;">
                                            <span class="material-symbols-outlined">send</span>REQUEST TO BORROW
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <button disabled class="btn btn-primary" style="width: 100%; padding: 1.5rem; opacity: 0.5; background-color: var(--outline-variant); cursor: not-allowed;">NOT AVAILABLE</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    <jsp:include page="components/member_footer.jsp" />
</body>
</html>
    </c:when>
    <c:otherwise>
        <jsp:include page="components/admin_layout_header.jsp">
            <jsp:param name="action" value="manage_items" />
        </jsp:include>
        <nav style="margin-bottom: 3rem; display: flex; align-items: center; gap: 1rem;">
            <a href="${pageContext.request.contextPath}/admin?action=manage_items" class="material-symbols-outlined" style="text-decoration: none; color: var(--primary); font-size: 1.5rem;">arrow_back</a>
            <span class="label-md" style="color: var(--outline);">BACK TO GLOBAL INVENTORY</span>
        </nav>
        <c:choose>
            <c:when test="${empty item}">
                <div style="text-align: center; padding: 10rem 0;">
                    <h1 style="font-weight: 900; text-transform: uppercase;">Resource Not Found</h1>
                    <a href="${pageContext.request.contextPath}/admin?action=manage_items" class="btn btn-primary" style="margin-top: 2rem; display: inline-block;">RETURN TO INVENTORY</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="editorial-grid">
                    <section>
                        <div class="detail-canvas">
                            <img src="${not empty item.imagePath ? item.imagePath : ''}" alt="${item.name}">
                            <div style="position: absolute; bottom: 0; right: 0; background-color: var(--primary); color: white; padding: 1rem 2rem; font-size: 0.625rem; font-weight: 900; text-transform: uppercase; letter-spacing: 0.2em;">IDENTITY.SPEC_${item.itemId}</div>
                        </div>
                    </section>
                    <section>
                        <div class="item-meta-badge">COMMUNITY RESOURCE</div>
                        <h1 style="font-size: 4rem; font-weight: 900; text-transform: uppercase; line-height: 0.9; letter-spacing: -0.04em; margin-bottom: 2rem;">${item.name}</h1>
                        <div style="border: 2px dashed var(--outline-variant); padding: 2rem; text-align: center; background-color: var(--surface-container-low);">
                            <span class="material-symbols-outlined" style="font-size: 2rem; margin-bottom: 1rem; color: var(--primary);">admin_panel_settings</span>
                            <div style="font-weight: 900; text-transform: uppercase; font-size: 0.8125rem; letter-spacing: 0.1em; color: var(--primary);">Administrative Oversight Mode</div>
                            <div style="font-size: 0.65rem; opacity: 0.8; margin-top: 0.5rem;">BORROWING IS DISABLED IN MODERATOR VIEW.</div>
                        </div>
                    </section>
                </div>
            </c:otherwise>
        </c:choose>
        <jsp:include page="components/admin_layout_footer.jsp" />
    </c:otherwise>
</c:choose>
