<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sapati.model.ContactMessage" %>
<%
    List<ContactMessage> messages = (List<ContactMessage>) request.getAttribute("messages");
%>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="manage_messages" />
</jsp:include>

<style>
    /* Custom Modal Styles */
    .custom-modal {
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.8);
        z-index: 1000;
        align-items: center;
        justify-content: center;
        backdrop-filter: blur(4px);
    }
    .modal-content {
        background: white;
        border: 2px solid black;
        padding: 2.5rem;
        max-width: 400px;
        width: 90%;
        box-shadow: 12px 12px 0px black;
        animation: modalPop 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }
    @keyframes modalPop {
        from { transform: scale(0.9); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
    }
    .unread-row {
        background-color: rgba(0,0,0,0.02);
    }
    .new-badge {
        background: #000;
        color: #fff;
        font-size: 8px;
        padding: 2px 4px;
        font-weight: 900;
        vertical-align: middle;
        margin-left: 4px;
    }
</style>

<!-- Page Header -->
<div class="flex items-end justify-between mb-8">
    <div>
        <span class="font-sans uppercase text-[10px] font-bold tracking-widest text-primary mb-1 block">ADMINISTRATION // SEC. 06</span>
        <h1 class="text-4xl font-extrabold tracking-tight text-primary uppercase">Support Inquiries</h1>
    </div>
    <% if ("deleted".equals(request.getParameter("msg"))) { %>
        <div class="admin-banner banner-success px-4 py-2 mb-0">
            <span class="text-xs font-bold uppercase tracking-widest">Message purged successfully.</span>
        </div>
    <% } %>
</div>

<!-- Messages Container -->
<div class="bg-surface-container-lowest border border-outline-variant/30 overflow-hidden">
    <table class="w-full text-left text-sm">
        <thead class="bg-surface-container-low border-b border-outline-variant/30">
            <tr class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline">
                <th class="px-6 py-4">SENDER</th>
                <th class="px-6 py-4">SUBJECT / CATEGORY</th>
                <th class="px-6 py-4">MESSAGE CONTENT</th>
                <th class="px-6 py-4">DATE SENT</th>
                <th class="px-6 py-4 text-right">ACTIONS</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
            <% if (messages != null && !messages.isEmpty()) {
                for (ContactMessage msg : messages) {
            %>
            <tr class="transition-colors hover:bg-surface-container-low/30 <%= !msg.isRead() ? "unread-row" : "" %>">
                <td class="px-6 py-4">
                    <div class="font-bold text-on-surface">
                        <%= msg.getName() %>
                        <% if (!msg.isRead()) { %><span class="new-badge">NEW</span><% } %>
                    </div>
                    <div class="text-[10px] text-on-surface-variant uppercase tracking-tighter"><%= msg.getEmail() %></div>
                </td>
                <td class="px-6 py-4">
                    <span class="status-pill-premium status-tonal-primary">
                        <%= msg.getSubject() %>
                    </span>
                </td>
                <td class="px-6 py-4 max-w-xs">
                    <div class="text-xs text-on-surface-variant leading-relaxed line-clamp-2 italic">
                        "<%= msg.getMessage() %>"
                    </div>
                </td>
                <td class="px-6 py-4">
                    <div class="font-mono text-[10px] text-on-surface-variant uppercase">
                        <%= msg.getSentAt() %>
                    </div>
                </td>
                <td class="px-6 py-4 text-right">
                    <div class="flex items-center justify-end gap-2">
                        <% if (!msg.isRead()) { %>
                            <form action="${pageContext.request.contextPath}/admin" method="POST">
                                <input type="hidden" name="action" value="mark_message_read">
                                <input type="hidden" name="message_id" value="<%= msg.getMessageId() %>">
                                <button type="submit" class="admin-action-btn border border-primary hover:bg-primary hover:text-white" title="Mark as handled">
                                    <span class="material-symbols-outlined text-[1rem]">done_all</span>
                                </button>
                            </form>
                        <% } %>
                        
                        <button type="button" class="admin-action-btn action-reject" onclick="openPurgeModal('<%= msg.getMessageId() %>')">
                            <span class="material-symbols-outlined text-[1rem]">delete</span>
                            PURGE
                        </button>
                    </div>
                </td>
            </tr>
            <% } } else { %>
                <tr>
                    <td colspan="5" class="px-6 py-12 text-center">
                        <div class="flex flex-col items-center gap-2 opacity-40">
                            <span class="material-symbols-outlined text-4xl">mail_outline</span>
                            <span class="font-sans uppercase text-[10px] font-bold tracking-widest">No active inquiries found.</span>
                        </div>
                    </td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

<!-- Custom Confirmation Modal -->
<div id="purgeModal" class="custom-modal">
    <div class="modal-content">
        <h2 class="text-2xl font-black uppercase mb-4 tracking-tighter">System Alert</h2>
        <p class="text-sm text-on-surface-variant leading-relaxed mb-8">
            You are about to <span class="text-error font-bold">PERMANENTLY PURGE</span> this inquiry from the community ledger. This action cannot be reversed.
        </p>
        <div class="flex gap-4">
            <button onclick="closePurgeModal()" class="flex-1 border border-outline px-4 py-3 font-bold text-[10px] uppercase tracking-widest hover:bg-surface-container-low transition-colors">Abort Action</button>
            <form id="purgeForm" action="${pageContext.request.contextPath}/admin" method="POST" class="flex-1">
                <input type="hidden" name="action" value="delete_message">
                <input type="hidden" name="message_id" id="modalMessageId">
                <button type="submit" class="w-full bg-error text-white px-4 py-3 font-bold text-[10px] uppercase tracking-widest hover:opacity-90">Confirm Purge</button>
            </form>
        </div>
    </div>
</div>

<script>
    function openPurgeModal(id) {
        document.getElementById('modalMessageId').value = id;
        document.getElementById('purgeModal').style.display = 'flex';
    }
    function closePurgeModal() {
        document.getElementById('purgeModal').style.display = 'none';
    }
    // Close modal when clicking outside content
    window.onclick = function(event) {
        let modal = document.getElementById('purgeModal');
        if (event.target == modal) {
            closePurgeModal();
        }
    }
</script>

<jsp:include page="components/admin_layout_footer.jsp" />
