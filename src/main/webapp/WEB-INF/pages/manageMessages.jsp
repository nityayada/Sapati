<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="manage_messages" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_brutalist.css">

<div style="max-width: 1200px;">
    <span class="font-sans uppercase text-[10px] font-bold tracking-widest text-primary mb-1 block">Administration // Sec. 06</span>
    <h1 class="text-4xl font-extrabold tracking-tight text-primary uppercase">Support Inquiries</h1>

    <div style="border: 1px solid #EEE; overflow: hidden;">
        <table class="inquiry-table">
            <thead>
                <tr>
                    <th style="width: 20%;">Sender</th>
                    <th style="width: 20%;">Subject / Category</th>
                    <th style="width: 30%;">Message Content</th>
                    <th style="width: 15%;">Date Sent</th>
                    <th style="width: 15%; text-align: right;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty messages}">
                        <c:forEach items="${messages}" var="msg">
                            <tr>
                                <td style="font-weight: 800; color: #000;">
                                    ${msg.name}
                                    <div style="font-size: 9px; color: #999; font-weight: 400;">${msg.email}</div>
                                </td>
                                <td>
                                    <span style="font-size: 9px; font-weight: 900; padding: 4px 8px; background: #F2F2F2; text-transform: uppercase;">
                                        ${msg.subject}
                                    </span>
                                </td>
                                <td style="font-size: 11px; color: #666; line-height: 1.5; font-style: italic;">
                                    "${msg.message}"
                                </td>
                                <td style="font-size: 10px; font-weight: 700; color: #888;">
                                    ${msg.sentAt}
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: flex; justify-content: flex-end; gap: 0.5rem;">
                                        <c:if test="${not msg.read}">
                                            <form action="${pageContext.request.contextPath}/admin" method="POST" style="display: inline;">
                                                <input type="hidden" name="action" value="mark_message_read">
                                                <input type="hidden" name="message_id" value="${msg.messageId}">
                                                <button type="submit" style="background: #000; color: #FFF; border: none; padding: 8px 12px; font-size: 9px; font-weight: 900; text-transform: uppercase; cursor: pointer;">Resolve</button>
                                            </form>
                                        </c:if>
                                        <button type="button" onclick="openPurgeModal('${msg.messageId}')" style="background: transparent; border: 1px solid #DDD; padding: 8px 12px; font-size: 9px; font-weight: 900; text-transform: uppercase; cursor: pointer;">Purge</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" class="empty-state-container">
                                <span class="material-symbols-outlined empty-icon">mail</span>
                                <h2 class="empty-headline">No active inquiries found.</h2>
                                <p class="empty-subtext">The support system is currently clear. No incoming messages, technical requests, or member inquiries were detected in the last synchronization cycle.</p>
                                
                                <div style="display: flex; justify-content: center; gap: 1.5rem;">
                                    <button onclick="location.reload()" class="btn-wire btn-outlined">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">refresh</span>
                                        Refresh Queue
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <div class="stats-grid">
        <div class="stat-ribbon">
            <span class="stat-label">Queue Status</span>
            <div style="display: flex; align-items: center; gap: 0.5rem;">
                <div style="width: 6px; height: 6px; border-radius: 50%; background: #00D084;"></div>
                <span class="stat-value">Optimized</span>
            </div>
        </div>
        <div class="stat-ribbon">
            <span class="stat-label">Last Sync</span>
            <jsp:useBean id="now" class="java.util.Date" />
            <fmt:formatDate value="${now}" pattern="dd.MMM.yyyy—HH:mm:ss" var="formattedDate" />
            <span class="stat-value">${fn:toUpperCase(formattedDate)}</span>
        </div>
        <div class="stat-ribbon">
            <span class="stat-label">Pending Tasks</span>
            <span class="stat-value">
                <c:set var="pendingCount" value="0" />
                <c:forEach items="${messages}" var="m">
                    <c:if test="${not m.read}">
                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                    </c:if>
                </c:forEach>
                <c:choose>
                    <c:when test="${pendingCount == 0}">Zero Records</c:when>
                    <c:otherwise>${pendingCount} Inquiries</c:otherwise>
                </c:choose>
            </span>
        </div>
    </div>
</div>

<!-- Modal Logic -->
<div id="purgeModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.8); z-index:9999; align-items:center; justify-content:center;">
    <div style="background:white; padding:3rem; max-width:400px; border:2px solid black;">
        <h2 style="font-weight:900; text-transform:uppercase; margin-bottom:1rem;">System Alert</h2>
        <p style="font-size:0.875rem; color:#666; margin-bottom:2rem;">Permanently purge this record from the system?</p>
        <div style="display:flex; gap:1rem;">
            <button onclick="document.getElementById('purgeModal').style.display='none'" style="flex:1; padding:1rem; border:1px solid #DDD; font-weight:900; text-transform:uppercase; font-size:10px; cursor:pointer;">Abort</button>
            <form id="purgeForm" action="${pageContext.request.contextPath}/admin" method="POST" style="flex:1;">
                <input type="hidden" name="action" value="delete_message">
                <input type="hidden" name="message_id" id="modalMessageId">
                <button type="submit" style="width:100%; padding:1rem; background:#C62828; color:white; border:none; font-weight:900; text-transform:uppercase; font-size:10px; cursor:pointer;">Confirm</button>
            </form>
        </div>
    </div>
</div>

<script>
    function openPurgeModal(id) {
        document.getElementById('modalMessageId').value = id;
        document.getElementById('purgeModal').style.display = 'flex';
    }
</script>

<jsp:include page="components/admin_layout_footer.jsp" />
