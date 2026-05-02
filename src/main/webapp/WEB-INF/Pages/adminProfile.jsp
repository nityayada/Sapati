<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sapati.model.User" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user?action=login");
        return;
    }
    String msg = request.getParameter("msg");
    String error = (String) request.getAttribute("error");
%>

<jsp:include page="components/admin_layout_header.jsp">
    <jsp:param name="action" value="profile" />
</jsp:include>

<!-- Core Styling Override for Admin context -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
<style>
    /* Prevent landing.css from breaking admin layout */
    .container { max-width: none; padding: 0; }
    .form-input { border-radius: 0.25rem; }
    .btn-primary { border-radius: 0.25rem; }
</style>

<div class="max-w-5xl">
    
    <!-- Profile Header -->
    <div class="mb-12 flex items-center gap-8 bg-surface-container-low p-8 border border-outline-variant/30">
        <div class="w-24 h-24 bg-black text-white flex items-center justify-center rounded-sm font-black text-4xl overflow-hidden">
            <% if (user.getProfileImage() != null && !user.getProfileImage().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/<%= user.getProfileImage() %>" alt="Profile" class="w-full h-full object-cover">
            <% } else { %>
                <%= user.getFullName().substring(0,1).toUpperCase() %>
            <% } %>
        </div>
        <div>
            <div class="text-[10px] font-black uppercase tracking-[0.2em] text-primary mb-2">System Administrator Node</div>
            <h1 class="text-3xl font-black uppercase tracking-tight text-black"><%= user.getFullName() %></h1>
            <div class="flex gap-4 mt-2">
                <span class="text-[9px] font-bold bg-black text-white px-2 py-0.5 tracking-widest">ID: USR_<%= user.getUserId() %></span>
                <span class="text-[9px] font-bold border border-black px-2 py-0.5 tracking-widest uppercase">ROLE: <%= user.getRole() %></span>
            </div>
        </div>
    </div>

    <% if ("profile_updated".equals(msg) || "security_updated".equals(msg) || "password_updated".equals(msg)) { %>
        <div class="bg-[#E8F5E9] border-l-4 border-[#2E7D32] p-4 mb-8 text-[#1B5E20] text-[10px] font-black uppercase tracking-widest">
            Identity Records Successfully Updated
        </div>
    <% } %>

    <% if (error != null) { %>
        <div class="bg-[#FFEBEE] border-l-4 border-[#C62828] p-4 mb-8 text-[#B71C1C] text-[10px] font-black uppercase tracking-widest">
            <%= error %>
        </div>
    <% } %>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        
        <!-- Identity Section -->
        <section class="bg-white border border-outline-variant/30 p-8 shadow-sm">
            <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-outline border-b border-outline-variant/30 pb-4 mb-6">ADMIN_IDENTITY_REGISTRY</h2>
            
            <form action="${pageContext.request.contextPath}/user" method="POST" enctype="multipart/form-data" class="space-y-6">
                <input type="hidden" name="action" value="update_profile">
                <input type="hidden" name="redirect" value="admin?action=profile">
                
                <div class="form-group">
                    <label class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Full Name</label>
                    <input type="text" name="full_name" class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none" value="<%= user.getFullName() %>" required>
                </div>

                <div class="form-group">
                    <label class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Email Address (Read-Only)</label>
                    <input type="email" class="w-full border border-outline-variant p-3 text-xs font-bold bg-surface-container-low opacity-50" value="<%= user.getEmail() %>" disabled>
                </div>

                <div class="form-group">
                    <label class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Contact Number</label>
                    <input type="text" name="phone" class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>">
                </div>

                <div class="form-group">
                    <label class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Physical Node (Address)</label>
                    <input type="text" name="address" class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" required>
                </div>

                <div class="form-group">
                    <label class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Update Profile Picture</label>
                    <input type="file" name="profile_image" class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none bg-white" accept="image/*">
                </div>

                <button type="submit" class="btn btn-primary" style="padding: 1.25rem 3rem; font-size: 0.75rem; letter-spacing: 0.2em; margin-top: 1rem; width: 100%; border: none;">COMMIT CHANGES</button>
            </form>
        </section>

        <!-- Security Section -->
        <div class="space-y-8">
            
            <section class="bg-white border border-outline-variant/30 p-8 shadow-sm">
                <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-outline border-b border-outline-variant/30 pb-4 mb-6">SECURITY_OVERRIDE</h2>
                
                <form action="${pageContext.request.contextPath}/user" method="POST" class="space-y-6">
                    <input type="hidden" name="action" value="update_password">
                    <input type="hidden" name="redirect" value="admin?action=profile">
                    
                    <div class="form-group">
                        <label class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">New Security Key</label>
                        <input type="password" name="new_password" class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Confirm Key</label>
                        <input type="password" name="confirm_password" class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none" required>
                    </div>

                    <button type="submit" class="btn btn-ghost" style="width: 100%; border: 2px solid var(--primary); padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.1em; background-color: transparent; cursor: pointer;">UPDATE CREDENTIALS</button>
                </form>
            </section>

            <section class="bg-white border border-outline-variant/30 p-8 shadow-sm">
                <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-[#1976D2] border-b border-[#1976D2]/30 pb-4 mb-6">RECOVERY_PROTOCOLS</h2>
                
                <form action="${pageContext.request.contextPath}/user" method="POST" class="space-y-6">
                    <input type="hidden" name="action" value="update_security_question">
                    <input type="hidden" name="redirect" value="admin?action=profile">
                    
                    <div class="form-group">
                        <label class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Verification Question</label>
                        <select name="security_question" class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none bg-white" required>
                            <option value="What was your first pet's name?" <%= "What was your first pet's name?".equals(user.getSecurityQuestion()) ? "selected" : "" %>>What was your first pet's name?</option>
                            <option value="In what city were you born?" <%= "In what city were you born?".equals(user.getSecurityQuestion()) ? "selected" : "" %>>In what city were you born?</option>
                            <option value="What was your childhood nickname?" <%= "What was your childhood nickname?".equals(user.getSecurityQuestion()) ? "selected" : "" %>>What was your childhood nickname?</option>
                            <option value="What is the name of your first school?" <%= "What is the name of your first school?".equals(user.getSecurityQuestion()) ? "selected" : "" %>>What is the name of your first school?</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Verification Answer</label>
                        <input type="text" name="security_answer" class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none" placeholder="Update answer..." required>
                    </div>

                    <button type="submit" class="btn btn-ghost" style="width: 100%; border: 2px solid var(--primary); padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.1em; background-color: var(--primary); color: white; cursor: pointer;">SET RECOVERY QUESTION</button>
                </form>
            </section>

        </div>
    </div>
</div>

<jsp:include page="components/admin_layout_footer.jsp" />
