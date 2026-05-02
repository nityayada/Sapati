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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Registry | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
    <style>
        .upload-drop-zone {
            border: 2px dashed var(--outline-variant);
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background-color: var(--surface-container-low);
            border-radius: 0.5rem;
            margin-top: 1rem;
        }

        .upload-drop-zone:hover {
            background-color: var(--surface-variant);
            border-color: var(--primary);
        }

        .upload-icon {
            font-size: 2.5rem;
            color: var(--outline);
            margin-bottom: 0.75rem;
        }

        .upload-text {
            font-size: 0.75rem;
            font-weight: 900;
            letter-spacing: 0.05em;
            color: var(--primary);
            text-transform: uppercase;
        }

        #file-name-display {
            font-size: 0.7rem;
            color: var(--primary);
            margin-top: 0.5rem;
            font-weight: 700;
            text-transform: uppercase;
        }
    </style>
</head>
<body style="background-color: var(--surface);">

    <jsp:include page="components/member_header.jsp" />

    <main class="container" style="padding: 6rem 1.5rem;">
        
        <!-- Profile Header -->
        <section class="welcome-banner" style="margin-bottom: 4rem;">
            <div class="user-avatar" style="width: 100px; height: 100px; background-color: var(--primary-container); border: 2px solid var(--primary); overflow: hidden; display: flex; align-items: center; justify-content: center;">
                <% if (user.getProfileImage() != null && !user.getProfileImage().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= user.getProfileImage() %>" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                <% } else { %>
                    <span class="material-symbols-outlined" style="font-size: 4rem; color: var(--primary);">person</span>
                <% } %>
            </div>
            <div>
                <div style="display: flex; align-items: baseline; gap: 1.5rem; margin-bottom: 0.75rem;">
                    <h1 style="font-size: 3rem; font-weight: 900; line-height: 1; text-transform: uppercase; letter-spacing: -0.04em;">Member Registry</h1>
                </div>
                <div style="display: flex; gap: 2rem; align-items: center;">
                    <span class="status-chip" style="background-color: var(--primary); color: white; border: none;">NODE_<%= user.getUserId() %></span>
                    <p style="font-size: 0.8125rem; color: var(--outline); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em;">
                        System Role: <span style="color: var(--primary); font-weight: 800;"><%= user.getRole() %></span>
                    </p>
                </div>
            </div>
        </section>

        <% if ("profile_updated".equals(msg)) { %>
            <div style="background-color: #E8F5E9; border-left: 5px solid #2E7D32; padding: 1.5rem; margin-bottom: 3rem; font-weight: 700; font-size: 0.875rem; text-transform: uppercase; letter-spacing: 0.1em; color: #1B5E20;">
                Identity Records Successfully Updated
            </div>
        <% } %>
        
        <% if ("password_updated".equals(msg)) { %>
            <div style="background-color: #E8F5E9; border-left: 5px solid #2E7D32; padding: 1.5rem; margin-bottom: 3rem; font-weight: 700; font-size: 0.875rem; text-transform: uppercase; letter-spacing: 0.1em; color: #1B5E20;">
                Security Protocols Updated
            </div>
        <% } %>

        <% if ("security_updated".equals(msg)) { %>
            <div style="background-color: #E3F2FD; border-left: 5px solid #1976D2; padding: 1.5rem; margin-bottom: 3rem; font-weight: 700; font-size: 0.875rem; text-transform: uppercase; letter-spacing: 0.1em; color: #0D47A1;">
                Identity Verification Protocols Configured
            </div>
        <% } %>

        <% if (error != null) { %>
            <div style="background-color: #FFEBEE; border-left: 5px solid #C62828; padding: 1.5rem; margin-bottom: 3rem; font-weight: 700; font-size: 0.875rem; text-transform: uppercase; letter-spacing: 0.1em; color: #B71C1C;">
                <%= error %>
            </div>
        <% } %>

        <div class="dashboard-grid" style="grid-template-columns: 1.5fr 1fr; gap: 4rem;">
            
            <!-- Identity Registry Section -->
            <section style="background-color: white; border: 1px solid var(--outline-variant); padding: 3rem;">
                <h2 class="label-md" style="margin-bottom: 3rem; border-bottom: 2px solid var(--primary); padding-bottom: 1rem; display: inline-block;">IDENTITY_REGISTRY_v1.0</h2>
                
                <form action="${pageContext.request.contextPath}/user" method="POST" enctype="multipart/form-data" class="space-y-8">
                    <input type="hidden" name="action" value="update_profile">
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem;">
                        <div class="form-group">
                            <label class="filter-label">Full Name</label>
                            <input type="text" name="full_name" class="filter-input" value="<%= user.getFullName() %>" required style="width: 100%; border-color: var(--outline-variant);">
                        </div>
                        <div class="form-group">
                            <label class="filter-label">Email Access (Read-Only)</label>
                            <input type="email" class="filter-input" value="<%= user.getEmail() %>" disabled style="width: 100%; background-color: var(--surface-container-lowest); opacity: 0.6;">
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem;">
                        <div class="form-group">
                            <label class="filter-label">Contact Number</label>
                            <input type="text" name="phone" class="filter-input" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>" style="width: 100%; border-color: var(--outline-variant);">
                        </div>
                        <div class="form-group">
                            <label class="filter-label">Physical Node (Address)</label>
                            <input type="text" name="address" class="filter-input" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" required style="width: 100%; border-color: var(--outline-variant);">
                        </div>
                    </div>

                    <div class="form-group mb-8">
                        <label class="label-md" style="color: var(--outline);">UPDATE PROFILE IDENTITY IMAGE</label>
                        <div class="upload-drop-zone" onclick="document.getElementById('profile_image').click();">
                            <span class="material-symbols-outlined upload-icon">upload_file</span>
                            <span class="upload-text">LOCAL UPLOAD</span>
                            <input type="file" id="profile_image" name="profile_image" accept="image/*" style="display: none;" onchange="updateFileName(this)">
                            <p id="file-name-display" style="display: none;"></p>
                        </div>
                    </div>

                    <script>
                        function updateFileName(input) {
                            const display = document.getElementById('file-name-display');
                            if (input.files && input.files[0]) {
                                display.textContent = "SELECTED: " + input.files[0].name.toUpperCase();
                                display.style.display = 'block';
                                document.querySelector('.upload-drop-zone').style.borderColor = 'var(--primary)';
                            } else {
                                display.style.display = 'none';
                                document.querySelector('.upload-drop-zone').style.borderColor = 'var(--outline-variant)';
                            }
                        }
                    </script>

                    <button type="submit" class="btn btn-primary" style="padding: 1.5rem 4rem; font-size: 0.8125rem; letter-spacing: 0.2em; margin-top: 2rem;">COMMIT CHANGES</button>
                </form>
            </section>

            <!-- Security & Meta Section -->
            <aside class="space-y-12">
                
                <section style="background-color: white; border: 1px solid var(--outline-variant); padding: 3rem;">
                    <h2 class="label-md" style="margin-bottom: 2rem; border-bottom: 1px solid var(--outline-variant); padding-bottom: 1rem;">SECURITY_PROTOCOLS</h2>
                    
                    <form action="${pageContext.request.contextPath}/user" method="POST" class="space-y-6">
                        <input type="hidden" name="action" value="update_password">
                        
                        <div class="form-group">
                            <label class="filter-label">New Security Key</label>
                            <input type="password" name="new_password" class="filter-input" required style="width: 100%; border-color: var(--outline-variant);">
                        </div>
                        
                        <div class="form-group" style="margin-bottom: 1.5rem;">
                            <label class="filter-label">Confirm Key</label>
                            <input type="password" name="confirm_password" class="filter-input" required style="width: 100%; border-color: var(--outline-variant);">
                        </div>

                        <button type="submit" class="btn btn-ghost" style="width: 100%; border: 2px solid var(--primary); padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.1em; background-color: transparent;">UPDATE CREDENTIALS</button>
                    </form>

                    <div style="margin: 2rem 0; border-top: 1px dashed var(--outline-variant);"></div>

                    <!-- Recovery Section -->
                    <form action="${pageContext.request.contextPath}/user" method="POST" class="space-y-6">
                        <input type="hidden" name="action" value="update_security_question">
                        
                        <div class="form-group">
                            <label class="filter-label">Identity Verification Question</label>
                            <select name="security_question" class="filter-input" style="width: 100%; background-image: none; border-color: var(--outline-variant);" required>
                                <option value="What was your first pet's name?" <%= "What was your first pet's name?".equals(user.getSecurityQuestion()) ? "selected" : "" %>>What was your first pet's name?</option>
                                <option value="In what city were you born?" <%= "In what city were you born?".equals(user.getSecurityQuestion()) ? "selected" : "" %>>In what city were you born?</option>
                                <option value="What was your childhood nickname?" <%= "What was your childhood nickname?".equals(user.getSecurityQuestion()) ? "selected" : "" %>>What was your childhood nickname?</option>
                                <option value="What is the name of your first school?" <%= "What is the name of your first school?".equals(user.getSecurityQuestion()) ? "selected" : "" %>>What is the name of your first school?</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="filter-label">Verification Answer</label>
                            <input type="text" name="security_answer" class="filter-input" placeholder="Update answer..." required style="width: 100%; border-color: var(--outline-variant);">
                            <p style="font-size: 0.625rem; color: var(--outline); margin-top: 0.5rem; text-transform: uppercase; font-weight: 700;">Leave blank to keep existing answer (not recommended for first-time setup)</p>
                        </div>

                        <button type="submit" class="btn btn-ghost" style="width: 100%; border: 2px solid var(--primary); padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.1em; background-color: var(--primary); color: white;">SET RECOVERY QUESTION</button>
                    </form>
                </section>

                <section style="background-color: var(--surface-container-low); padding: 2rem; border: 1px solid var(--outline-variant);">
                    <h2 class="label-md" style="margin-bottom: 1.5rem; opacity: 0.7;">ACCOUNT_METADATA</h2>
                    <div style="font-family: 'Inter', sans-serif; font-size: 0.75rem; line-height: 2;">
                        <div style="display: flex; justify-content: space-between;">
                            <span style="font-weight: 700; color: var(--outline);">Status</span>
                            <span style="font-weight: 900; color: var(--primary);"><%= user.getAccountStatus() %></span>
                        </div>
                        <div style="display: flex; justify-content: space-between;">
                            <span style="font-weight: 700; color: var(--outline);">Permissions</span>
                            <span style="font-weight: 900; color: var(--primary);"><%= user.getRole().toUpperCase() %>_ACCESS</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-top: 1rem; padding-top: 1rem; border-top: 1px dashed var(--outline-variant);">
                            <span style="font-weight: 700; color: var(--error);">DANGER_ZONE</span>
                            <a href="#" style="color: var(--error); font-weight: 900; text-decoration: underline;">DEACTIVATE_ACCOUNT</a>
                        </div>
                    </div>
                </section>

            </aside>
        </div>

    </main>

    <jsp:include page="components/member_footer.jsp" />

</body>
</html>
