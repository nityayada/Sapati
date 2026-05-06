<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Listings | Sapati.com</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
    <style>
        .remove-btn {
            transition: all 0.2s ease;
        }
        .remove-btn:hover {
            background-color: var(--primary) !important;
            color: var(--surface-container-lowest) !important;
        }
        .remove-btn:active {
            transform: scale(0.96);
        }
        #removeConfirmDialog::backdrop {
            background-color: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(2px);
        }
    </style>
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container">
        
        <c:if test="${param.msg == 'item_added'}">
            <div class="auth-msg auth-msg-success" style="margin: 2rem 0; border: 1px solid var(--primary);">
                <span class="material-symbols-outlined">inventory</span>
                RESOURCE REGISTERED SUCCESSFULLY IN COMMUNITY LEDGER
            </div>
        </c:if>
        <c:if test="${param.msg == 'item_updated'}">
            <div class="auth-msg auth-msg-success" style="margin: 2rem 0; border: 1px solid var(--primary);">
                <span class="material-symbols-outlined">edit_note</span>
                METADATA REVISED SUCCESSFULLY. LEDGER UPDATED.
            </div>
        </c:if>
        <c:if test="${param.msg == 'item_removed'}">
            <div class="auth-msg auth-msg-success" style="margin: 2rem 0; border: 1px solid var(--primary);">
                <span class="material-symbols-outlined">delete</span>
                RESOURCE REMOVED SUCCESSFULLY FROM THE LEDGER.
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="auth-msg auth-msg-error" style="margin: 2rem 0;">
                <span class="material-symbols-outlined">error</span>
                ${fn:toUpperCase(fn:replace(param.error, '_', ' '))}
            </div>
        </c:if>

        <!-- Editorial Header Section -->
        <section style="margin-bottom: 4rem;">
            <div style="display: flex; justify-content: space-between; align-items: flex-end; gap: 2rem; flex-wrap: wrap;">
                <div style="max-width: 600px;">
                    <span class="label-md" style="color: var(--outline); margin-bottom: 1rem; display: block;">INVENTORY.OWNER_CATALOG</span>
                    <h1 style="font-size: 4rem; font-weight: 900; line-height: 0.9; text-transform: uppercase; margin-bottom: 1.5rem; letter-spacing: -0.04em;">My Listings</h1>
                    <p style="color: var(--on-surface-variant); line-height: 1.6;">
                        Manage the tools, books, and equipment you share with the Sapati community. Track borrowing status and item condition from your architectural ledger.
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/item?action=add" class="btn btn-primary" style="padding: 1.5rem 3rem; border-radius: 0; font-size: 0.75rem; letter-spacing: 0.2em; display: flex; align-items: center; gap: 1rem;">
                        <span class="material-symbols-outlined">add</span>
                        ADD NEW LISTING
                    </a>
                </div>
            </div>
        </section>

        <!-- Bento Grid Layout -->
        <div class="bento-grid">
            
            <!-- Featured Card (Newest Addition) -->
            <c:if test="${not empty items}">
                <c:set var="newestItem" value="${items[fn:length(items) - 1]}" />
                <div class="col-span-8 featured-card">
                    <div class="featured-img" style="background-image: url('${not empty newestItem.imagePath ? newestItem.imagePath : ''}'); background-size: cover; background-position: center;">
                        <c:if test="${empty newestItem.imagePath}">
                            <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; opacity: 0.1;">
                                <span class="material-symbols-outlined" style="font-size: 5rem;">package_2</span>
                            </div>
                        </c:if>
                        <div style="position: absolute; top: 0; left: 0; background-color: var(--primary); color: white; padding: 0.5rem 1rem; font-size: 0.625rem; font-weight: 900; text-transform: uppercase;">NEWEST ENTRY</div>
                    </div>
                    <div class="featured-content">
                        <div>
                            <span class="label-sm" style="color: var(--outline); margin-bottom: 1rem; display: block;">ADDED 
                                <c:choose>
                                    <c:when test="${not empty newestItem.createdAt}">
                                        ${fn:substring(newestItem.createdAt.toString(), 0, 10)}
                                    </c:when>
                                    <c:otherwise>RECENTLY</c:otherwise>
                                </c:choose>
                            </span>
                            <h2 style="font-size: 2rem; font-weight: 900; text-transform: uppercase; line-height: 1.1; margin-bottom: 1.5rem;">${newestItem.name}</h2>
                            <div style="display: flex; align-items: center; gap: 2rem;">
                                <div>
                                    <div class="label-sm" style="color: var(--outline); font-size: 0.625rem;">STATUS</div>
                                    <c:choose>
                                        <c:when test="${newestItem.status == 'Listed'}">
                                            <div style="font-weight: 800; text-transform: uppercase; font-size: 0.875rem; color: var(--secondary);">PENDING REVIEW</div>
                                        </c:when>
                                        <c:when test="${newestItem.status == 'Available'}">
                                            <div style="font-weight: 800; text-transform: uppercase; font-size: 0.875rem; color: var(--primary);">${newestItem.status}</div>
                                        </c:when>
                                        <c:when test="${newestItem.status == 'Rejected'}">
                                            <div style="font-weight: 800; text-transform: uppercase; font-size: 0.875rem; color: var(--error);">${newestItem.status}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div style="font-weight: 800; text-transform: uppercase; font-size: 0.875rem;">${newestItem.status}</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div style="width: 1px; height: 30px; background-color: var(--outline-variant);"></div>
                                <div>
                                    <div class="label-sm" style="color: var(--outline); font-size: 0.625rem;">REF</div>
                                    <div style="font-weight: 800; text-transform: uppercase; font-size: 0.875rem;">#${newestItem.itemId}-L</div>
                                </div>
                            </div>
                        </div>
                        <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                            <a href="${pageContext.request.contextPath}/item?action=edit&id=${newestItem.itemId}" class="btn btn-ghost" style="flex: 1; border: 1px solid var(--outline); font-size: 0.75rem; letter-spacing: 0.1em; font-weight: 900; display: flex; align-items: center; justify-content: center; text-decoration: none; color: inherit;">EDIT RECORD</a>
                            <form action="${pageContext.request.contextPath}/item" method="POST" style="flex: 1; display: flex;" onsubmit="confirmRemoval(event, this);">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="item_id" value="${newestItem.itemId}">
                                <button type="submit" class="btn btn-ghost remove-btn" style="width: 100%; border: 1px solid var(--primary); color: var(--primary); font-size: 0.75rem; letter-spacing: 0.1em; font-weight: 900;">REMOVE</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Health Widget -->
            <div class="col-span-4 health-widget">
                <span class="label-md" style="margin-bottom: 2rem; display: block;">INVENTORY HEALTH</span>
                <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                    <span style="font-size: 3.5rem; font-weight: 900; letter-spacing: -0.05em; line-height: 1;">${availabilityRate}%</span>
                    <span class="label-sm" style="color: var(--outline);">AVAILABILITY</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${availabilityRate}%;"></div>
                </div>
                <p style="font-size: 0.75rem; color: var(--on-surface-variant); line-height: 1.8; margin-top: 2rem;">
                    Your community contribution has saved neighbors an estimated <strong>NPR 1,240</strong> this year through collaborative consumption.
                </p>
            </div>

            <!-- List Header Utility -->
            <div class="col-span-12" style="border-bottom: 2px solid var(--primary); padding-bottom: 1rem; margin-top: 2rem; display: flex; justify-content: space-between; align-items: center;">
                <span class="label-md">ALL COLLECTIONS (${not empty items ? fn:length(items) : 0})</span>
                <div class="label-sm" style="color: var(--outline);">SORT BY: NEWEST</div>
            </div>

            <!-- Standard Grid Items -->
            <c:forEach items="${items}" var="item">
                <div class="col-span-4 inventory-card" style="border: 1px solid var(--outline-variant); margin-bottom: 2rem;">
                    <div class="image-box">
                        <c:choose>
                            <c:when test="${item.status == 'Listed'}">
                                <div class="status-pill" style="background-color: var(--secondary);">PENDING REVIEW</div>
                            </c:when>
                            <c:when test="${item.status == 'Rejected'}">
                                <div class="status-pill" style="background-color: var(--error);">REJECTED</div>
                            </c:when>
                            <c:otherwise>
                                <div class="status-pill" style="background-color: var(--primary);">${fn:toUpperCase(item.status)}</div>
                            </c:otherwise>
                        </c:choose>
                        
                        <c:choose>
                            <c:when test="${not empty item.imagePath}">
                                <img src="${item.imagePath}" alt="${item.name}" style="width: 100%; height: 100%; object-fit: cover; filter: grayscale(1); mix-blend-mode: multiply;">
                            </c:when>
                            <c:otherwise>
                                <span class="material-symbols-outlined" style="font-size: 4rem; opacity: 0.1;">package_2</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-body">
                        <span class="category-tag">REF_${item.itemId}</span>
                        <h3 class="item-title" style="font-size: 1.25rem;">${item.name}</h3>
                        <div style="display: flex; gap: 0.5rem; margin-top: auto;">
                            <a href="${pageContext.request.contextPath}/item?action=edit&id=${item.itemId}" class="btn btn-ghost" style="flex: 1; border: 1px solid var(--outline); font-size: 0.625rem; font-weight: 900; letter-spacing: 0.1em; padding: 0.75rem; display: flex; align-items: center; justify-content: center; text-decoration: none; color: inherit;">EDIT</a>
                            <form action="${pageContext.request.contextPath}/item" method="POST" style="flex: 1; display: flex;" onsubmit="confirmRemoval(event, this);">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="item_id" value="${item.itemId}">
                                <button type="submit" class="btn btn-ghost remove-btn" style="width: 100%; border: 1px solid var(--primary); color: var(--primary); font-size: 0.625rem; font-weight: 900; letter-spacing: 0.1em; padding: 0.75rem;">REMOVE</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <!-- Empty State -->
            <c:if test="${empty items}">
                <div class="col-span-12" style="border: 2px dashed var(--outline-variant); padding: 8rem 0; text-align: center;">
                    <span class="material-symbols-outlined" style="font-size: 5rem; opacity: 0.1; margin-bottom: 2rem;">inventory_2</span>
                    <h3 style="font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em;">Your catalog is empty</h3>
                    <p style="color: var(--outline); margin-bottom: 3rem;">LIST ITEMS YOU DON'T USE EVERY DAY TO HELP YOUR NEIGHBORS.</p>
                    <a href="${pageContext.request.contextPath}/item?action=add" class="btn btn-primary" style="padding: 1.25rem 3rem;">LIST YOUR FIRST RESOURCE</a>
                </div>
            </c:if>

        </div>

    </main>

    <!-- Custom Dialog for Removal Confirmation -->
    <dialog id="removeConfirmDialog" style="padding: 2.5rem; border: 2px solid var(--primary); background-color: var(--surface-container-lowest); border-radius: 0; max-width: 450px; margin: auto; box-shadow: 12px 12px 0px rgba(0,0,0,1);">
        <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem;">
            <span class="material-symbols-outlined" style="color: var(--error); font-size: 2rem;">warning</span>
            <h3 style="font-weight: 900; text-transform: uppercase; font-size: 1.25rem; margin: 0; line-height: 1;">CONFIRM DELETION</h3>
        </div>
        <p style="color: var(--on-surface-variant); font-size: 0.875rem; margin-bottom: 2.5rem; line-height: 1.6; font-weight: 500;">
            Are you sure you want to permanently remove this listing from the ledger? This action cannot be undone and will erase all historical data associated with it.
        </p>
        <div style="display: flex; gap: 1rem;">
            <button type="button" class="btn btn-ghost" onclick="document.getElementById('removeConfirmDialog').close()" style="flex: 1; border: 2px solid var(--outline); font-weight: 900; color: var(--outline);">CANCEL</button>
            <button type="button" class="btn btn-primary" id="confirmRemoveBtn" style="flex: 1; background-color: var(--primary); border: 2px solid var(--primary); color: var(--surface-container-lowest); font-weight: 900;">REMOVE</button>
        </div>
    </dialog>

    <script>
        let formToSubmit = null;
        function confirmRemoval(event, form) {
            event.preventDefault();
            formToSubmit = form;
            document.getElementById('removeConfirmDialog').showModal();
        }
        
        document.getElementById('confirmRemoveBtn').addEventListener('click', function() {
            if (formToSubmit) {
                formToSubmit.submit();
            }
        });
    </script>

    <jsp:include page="components/member_footer.jsp" />

</body>
</html>
