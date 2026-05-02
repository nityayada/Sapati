<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.ContactMessage" %>
<%
    List<ContactMessage> messages = (List<ContactMessage>) request.getAttribute("messages");
%>

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
                <% if (messages != null && !messages.isEmpty()) { 
                    for (ContactMessage msg : messages) {
                %>
                    <tr>
                        <td style="font-weight: 800; color: #000;">
                            <%= msg.getName() %>
                            <div style="font-size: 9px; color: #999; font-weight: 400;"><%= msg.getEmail() %></div>
                        </td>
                        <td>
                            <span style="font-size: 9px; font-weight: 900; padding: 4px 8px; background: #F2F2F2; text-transform: uppercase;">
                                <%= msg.getSubject() %>
                            </span>
                        </td>
                        <td style="font-size: 11px; color: #666; line-height: 1.5; font-style: italic;">
                            "<%= msg.getMessage() %>"
                        </td>
                        <td style="font-size: 10px; font-weight: 700; color: #888;">
                            <%= msg.getSentAt() %>
                        </td>
                        <td style="text-align: right;">
                            <div style="display: flex; justify-content: flex-end; gap: 0.5rem;">
                                <% if (!msg.isRead()) { %>
                                    <form action="${pageContext.request.contextPath}/admin" method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="mark_message_read">
                                        <input type="hidden" name="message_id" value="<%= msg.getMessageId() %>">
                                        <button type="submit" style="background: #000; color: #FFF; border: none; padding: 8px 12px; font-size: 9px; font-weight: 900; text-transform: uppercase; cursor: pointer;">Resolve</button>
                                    </form>
                                <% } %>
                                <button type="button" onclick="openPurgeModal('<%= msg.getMessageId() %>')" style="background: transparent; border: 1px solid #DDD; padding: 8px 12px; font-size: 9px; font-weight: 900; text-transform: uppercase; cursor: pointer;">Purge</button>
                            </div>
                        </td>
                    </tr>
                <% } } else { %>
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
                <% } %>
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
            <span class="stat-value"><%= new java.text.SimpleDateFormat("dd.MMM.yyyy—HH:mm:ss").format(new java.util.Date()).toUpperCase() %></span>
        </div>
        <div class="stat-ribbon">
            <span class="stat-label">Pending Tasks</span>
            <span class="stat-value">
                <% 
                    int pendingCount = 0;
                    if (messages != null) {
                        for (ContactMessage m : messages) if (!m.isRead()) pendingCount++;
                    }
                    out.print(pendingCount == 0 ? "Zero Records" : pendingCount + " Inquiries");
                %>
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
