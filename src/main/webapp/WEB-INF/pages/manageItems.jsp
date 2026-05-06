<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="manage_items" />
</jsp:include>

<div class="flex items-end justify-between mb-8">
    <div>
        <span class="font-sans uppercase text-[10px] font-bold tracking-widest text-primary mb-1 block">ADMINISTRATION // SEC. 05</span>
        <h1 class="text-4xl font-extrabold tracking-tight text-primary uppercase">GLOBAL INVENTORY</h1>
    </div>
</div>

<!-- Search & Filter Bar -->
<div class="mb-8">
    <div class="bg-surface-container-low border border-outline-variant/30 flex items-center px-4 max-w-md focus-within:border-primary transition-all">
        <span class="material-symbols-outlined text-outline text-[1.25rem]">search</span>
        <input type="text" id="itemSearch" placeholder="SEARCH RESOURCES BY NAME OR OWNER..." 
               class="w-full bg-transparent border-none py-4 pl-3 font-sans text-[10px] font-bold tracking-widest outline-none">
    </div>
</div>

<!-- Premium Feedback Banners -->
<c:if test="${param.msg == 'item_approved'}">
    <div class="admin-banner banner-success">
        <div class="flex items-center gap-4">
            <span class="material-symbols-outlined">verified</span>
            <div>
                <div class="font-bold text-xs uppercase tracking-wider">Resource Certified</div>
                <div class="text-[10px] opacity-80">THE ITEM HAS BEEN LOGGED INTO THE PUBLIC COMMUNITY LEDGER.</div>
            </div>
        </div>
        <span class="material-symbols-outlined cursor-pointer opacity-50 hover:opacity-100" onclick="this.parentElement.remove()">close</span>
    </div>
</c:if>

<c:if test="${param.msg == 'item_deleted'}">
    <div class="admin-banner banner-error">
        <div class="flex items-center gap-4">
            <span class="material-symbols-outlined">delete_sweep</span>
            <div>
                <div class="font-bold text-xs uppercase tracking-wider">Resource Purged</div>
                <div class="text-[10px] opacity-80">THE REJECTED LISTING HAS BEEN PERMANENTLY REMOVED FROM ALL RECORDS.</div>
            </div>
        </div>
        <span class="material-symbols-outlined cursor-pointer opacity-50 hover:opacity-100" onclick="this.parentElement.remove()">close</span>
    </div>
</c:if>

<div class="bg-surface-container-lowest border border-outline-variant/30 overflow-hidden shadow-sm">
    <table class="w-full text-left text-sm border-collapse">
        <thead class="bg-surface-container-low border-b border-outline-variant/30">
            <tr class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline">
                <th class="px-6 py-4" style="width: 150px;">RESOURCE ID</th>
                <th class="px-6 py-4">SPECIFICATIONS</th>
                <th class="px-6 py-4">NODE OWNER</th>
                <th class="px-6 py-4 text-center">STATUS</th>
                <th class="px-6 py-4 text-right">ACTIONS</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
            <c:choose>
                <c:when test="${not empty items}">
                    <c:forEach items="${items}" var="item">
                        <c:set var="statusClass" value="" />
                        <c:set var="statusIcon" value="" />
                        <c:set var="statusText" value="${fn:toUpperCase(item.status)}" />
                        
                        <c:choose>
                            <c:when test="${item.status == 'Available'}">
                                <c:set var="statusClass" value="status-tonal-primary" />
                                <c:set var="statusIcon" value="inventory" />
                            </c:when>
                            <c:when test="${item.status == 'Listed'}">
                                <c:set var="statusClass" value="status-tonal-secondary" />
                                <c:set var="statusIcon" value="pending_actions" />
                                <c:set var="statusText" value="PENDING REVIEW" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="statusClass" value="status-tonal-error" />
                                <c:set var="statusIcon" value="error" />
                            </c:otherwise>
                        </c:choose>
                        <tr class="transition-colors hover:bg-surface-container-low/50 item-row">
                            <td class="px-6 py-4">
                                <span class="font-mono text-[10px] font-bold text-outline">#RES_${item.itemId}</span>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex items-center gap-4">
                                    <div class="w-10 h-10 bg-surface-container-high overflow-hidden border border-outline-variant/30 flex items-center justify-center flex-shrink-0">
                                        <c:choose>
                                            <c:when test="${not empty item.imagePath}">
                                                <img src="${item.imagePath}" class="w-full h-full object-cover transition-all duration-300">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="material-symbols-outlined text-outline opacity-20">package_2</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <div class="font-bold text-xs uppercase tracking-tight item-name">${item.name}</div>
                                        <div class="text-[9px] text-outline font-black uppercase tracking-widest mt-1">
                                            <c:if test="${not empty item.createdAt}">
                                                ${fn:substring(item.createdAt.toString(), 0, 10)}
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-outline text-base">person</span>
                                    <span class="font-bold text-[10px] tracking-widest uppercase owner-info">NODE_${item.ownerId}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <span class="status-pill-premium ${statusClass}" style="font-size: 9px;">
                                    <span class="material-symbols-outlined text-xs">${statusIcon}</span>
                                    ${statusText}
                                </span>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex items-center justify-end gap-2">
                                    <a href="${pageContext.request.contextPath}/item?action=view&id=${item.itemId}" 
                                       class="admin-action-btn border border-outline-variant hover:border-primary no-underline text-outline">
                                        <span class="material-symbols-outlined text-base">visibility</span>
                                    </a>
                                    
                                    <c:if test="${item.status == 'Listed'}">
                                        <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                            <input type="hidden" name="action" value="approve_item">
                                            <input type="hidden" name="item_id" value="${item.itemId}">
                                            <button type="submit" class="bg-primary text-on-primary text-[10px] px-3 py-1 font-bold rounded hover:opacity-80">APPROVE</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin" method="POST" class="inline">
                                            <input type="hidden" name="action" value="reject_item">
                                            <input type="hidden" name="item_id" value="${item.itemId}">
                                            <button type="submit" class="border border-error text-error text-[10px] px-3 py-1 font-bold rounded hover:bg-error hover:text-white transition-colors">REJECT</button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" class="px-8 py-12 text-center">
                            <span class="material-symbols-outlined text-4xl text-outline-variant opacity-30">inventory_2</span>
                            <div class="mt-4 text-xs font-bold text-outline uppercase tracking-widest">Global inventory ledger is empty</div>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script>
document.getElementById('itemSearch').addEventListener('keyup', function() {
    let filter = this.value.toUpperCase();
    let rows = document.querySelectorAll('.item-row');
    
    rows.forEach(row => {
        let name = row.querySelector('.item-name').textContent.toUpperCase();
        let owner = row.querySelector('.owner-info').textContent.toUpperCase();
        if (name.indexOf(filter) > -1 || owner.indexOf(filter) > -1) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
});
</script>

<jsp:include page="components/admin_layout_footer.jsp" />
