<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.User" %>
<%
    Integer userCount = (Integer) request.getAttribute("userCount");
    Integer itemCount = (Integer) request.getAttribute("itemCount");
    Integer activeBorrows = (Integer) request.getAttribute("activeBorrows");
    Double totalUnpaidFines = (Double) request.getAttribute("totalUnpaidFines");
%>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="dashboard" />
</jsp:include>

<!-- Welcome Banner -->
<section class="mb-10 bg-surface-container-low p-8 flex justify-between items-center outline outline-1 outline-outline-variant/30">
    <div class="flex items-center space-x-6">
        <div>
            <h1 class="text-4xl font-extrabold tracking-tight text-primary uppercase">Admin Dashboard</h1>
            <p class="text-on-surface-variant font-medium flex items-center gap-2 mt-2">
                <span class="material-symbols-outlined text-sm">verified_user</span>
                System Authority Mode Active
            </p>
        </div>
    </div>
    <div class="text-right hidden sm:block">
        <a href="${pageContext.request.contextPath}/admin?action=run_fine_calc" class="bg-primary hover:bg-surface-container-highest text-on-primary hover:text-primary transition-colors text-xs font-bold px-4 py-2 uppercase tracking-widest outline outline-1 outline-primary inline-flex items-center gap-2 mb-4">
            <span class="material-symbols-outlined text-[1rem]">calculate</span>
            Recalculate Fines
        </a>
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline">System Status</div>
        <div class="flex items-center justify-end gap-2 text-primary font-bold mt-1">
            <div class="w-2 h-2 rounded-full bg-primary"></div>
            ACTIVE
        </div>
    </div>
</section>

<!-- Stats Row -->
<section class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Total Members</div>
        <div class="text-3xl font-black text-primary"><%= userCount != null ? userCount : 0 %></div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Total Items Listed</div>
        <div class="text-3xl font-black text-primary"><%= itemCount != null ? itemCount : 0 %></div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Active Borrowings</div>
        <div class="text-3xl font-black text-primary"><%= activeBorrows != null ? activeBorrows : 0 %></div>
    </div>
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 hover:border-primary transition-colors">
        <div class="font-sans uppercase text-[10px] font-bold tracking-widest text-outline mb-1">Outstanding Fines</div>
        <div class="text-3xl font-black text-error"><%= totalUnpaidFines != null && totalUnpaidFines > 0 ? "NPR " + Math.round(totalUnpaidFines) : "Clean" %></div>
    </div>
</section>

<div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 flex flex-col justify-between hover:border-primary transition-colors">
        <div>
            <span class="material-symbols-outlined text-primary mb-4" style="font-size: 3rem;">person_celebrate</span>
            <h3 class="font-sans uppercase text-sm font-black tracking-widest text-primary mb-2">Member Directory</h3>
            <p class="text-sm text-on-surface-variant leading-relaxed mb-6">
                Audit user accounts, manage trust scores, and handle system access permissions.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/admin?action=manage_users" class="bg-primary text-on-primary py-3 px-4 text-center font-bold text-xs uppercase tracking-widest hover:opacity-90">ACCESS RECORDS</a>
    </div>

    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 flex flex-col justify-between hover:border-primary transition-colors">
        <div>
            <span class="material-symbols-outlined text-primary mb-4" style="font-size: 3rem;">inventory_2</span>
            <h3 class="font-sans uppercase text-sm font-black tracking-widest text-primary mb-2">Global Inventory</h3>
            <p class="text-sm text-on-surface-variant leading-relaxed mb-6">
                Verify item listings, moderate community submissions, and update resource status.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/admin?action=manage_items" class="bg-primary text-on-primary py-3 px-4 text-center font-bold text-xs uppercase tracking-widest hover:opacity-90">REVIEW ASSETS</a>
    </div>

    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 flex flex-col justify-between hover:border-primary transition-colors">
        <div>
            <span class="material-symbols-outlined text-primary mb-4" style="font-size: 3rem;">history_edu</span>
            <h3 class="font-sans uppercase text-sm font-black tracking-widest text-primary mb-2">Borrow Records</h3>
            <p class="text-sm text-on-surface-variant leading-relaxed mb-6">
                Oversee all active, completed, and overdue lending activity across the platform ledger.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/admin?action=manage_borrows" class="bg-primary text-on-primary py-3 px-4 text-center font-bold text-xs uppercase tracking-widest hover:opacity-90">VIEW LEDGER</a>
    </div>

    <div class="bg-surface-container-lowest p-6 border border-outline-variant/30 flex flex-col justify-between hover:border-primary transition-colors">
        <div>
            <span class="material-symbols-outlined text-primary mb-4" style="font-size: 3rem;">payments</span>
            <h3 class="font-sans uppercase text-sm font-black tracking-widest text-primary mb-2">Fines Oversight</h3>
            <p class="text-sm text-on-surface-variant leading-relaxed mb-6">
                Manage financial penalties, track overdue resource liabilities, and clear settled fines.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/admin?action=manage_fines" class="bg-primary text-on-primary py-3 px-4 text-center font-bold text-xs uppercase tracking-widest hover:opacity-90">MANAGE PENALTIES</a>
    </div>
</div>

<jsp:include page="components/admin_layout_footer.jsp" />
