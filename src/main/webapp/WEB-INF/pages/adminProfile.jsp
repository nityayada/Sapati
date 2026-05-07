<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

            <c:if test="${empty user}">
                <c:redirect url="/user?action=login" />
            </c:if>

            <jsp:include page="components/admin_layout_header.jsp">
                <jsp:param name="action" value="profile" />
            </jsp:include>

            <!-- Core Styling Override for Admin context -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
            <style>
                /* Prevent landing.css from breaking admin layout */
                .container {
                    max-width: none;
                    padding: 0;
                }

                .form-input {
                    border-radius: 0.25rem;
                }

                .btn-primary {
                    border-radius: 0.25rem;
                }

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

            <div class="max-w-5xl">

                <!-- Profile Header -->
                <div
                    class="mb-12 flex items-center gap-8 bg-surface-container-low p-8 border border-outline-variant/30">
                    <div class="user-avatar"
                        style="width: 100px; height: 100px;  border: 2px solid var(--primary); overflow: hidden; display: flex; align-items: center; justify-content: center;">
                        <c:choose>
                            <c:when test="${not empty user.profileImage}">
                                <img src="${pageContext.request.contextPath}/${user.profileImage}" alt="Profile"
                                    class="w-full h-full object-cover">
                            </c:when>
                            <c:otherwise>
                                <span class="material-symbols-outlined"
                                    style="font-size: 4rem; color: var(--primary);">person</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <div class="text-[10px] font-black uppercase tracking-[0.2em] text-primary mb-2">System
                            Administrator Node</div>
                        <h1 class="text-3xl font-black uppercase tracking-tight text-black">${user.fullName}</h1>
                        <div class="flex gap-4 mt-2">
                            <span class="status-chip"
                                style="background-color: var(--primary); color: white; border: none;">ID:
                                USR_${user.userId}</span>
                            <span
                                style="font-size: 0.8125rem; color: var(--outline); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em;">ROLE:
                                <span style="color: var(--primary); font-weight: 800;">${user.role}</span></span>
                        </div>
                    </div>
                </div>

                <c:if
                    test="${param.msg == 'profile_updated' || param.msg == 'security_updated' || param.msg == 'password_updated'}">
                    <div
                        class="bg-[#E8F5E9] border-l-4 border-[#2E7D32] p-4 mb-8 text-[#1B5E20] text-[10px] font-black uppercase tracking-widest">
                        Identity Records Successfully Updated
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div
                        class="bg-[#FFEBEE] border-l-4 border-[#C62828] p-4 mb-8 text-[#B71C1C] text-[10px] font-black uppercase tracking-widest">
                        ${error}
                    </div>
                </c:if>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">

                    <!-- Identity Section -->
                    <section class="bg-white border border-outline-variant/30 p-8 shadow-sm">
                        <h2
                            class="text-[10px] font-black uppercase tracking-[0.2em] text-outline border-b border-outline-variant/30 pb-4 mb-6">
                            ADMIN_IDENTITY_REGISTRY</h2>

                        <form action="${pageContext.request.contextPath}/user" method="POST"
                            enctype="multipart/form-data" class="space-y-6">
                            <input type="hidden" name="action" value="update_profile">
                            <input type="hidden" name="redirect" value="admin?action=profile">

                            <div class="form-group">
                                <label
                                    class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Full
                                    Name</label>
                                <input type="text" name="full_name"
                                    class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none"
                                    value="${user.fullName}" required>
                            </div>

                            <div class="form-group">
                                <label
                                    class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Email
                                    Address (Read-Only)</label>
                                <input type="email"
                                    class="w-full border border-outline-variant p-3 text-xs font-bold bg-surface-container-low opacity-50"
                                    value="${user.email}" disabled>
                            </div>

                            <div class="form-group">
                                <label
                                    class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Contact
                                    Number</label>
                                <input type="text" name="phone"
                                    class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none"
                                    value="${not empty user.phoneNumber ? user.phoneNumber : ''}">
                            </div>

                            <div class="form-group">
                                <label
                                    class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Physical
                                    Node (Address)</label>
                                <input type="text" name="address"
                                    class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none"
                                    value="${not empty user.address ? user.address : ''}" required>
                            </div>

                            <div class="form-group mb-8">
                                <label
                                    class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">UPDATE
                                    PROFILE IDENTITY IMAGE</label>
                                <div class="upload-drop-zone"
                                    onclick="document.getElementById('profile_image').click();">
                                    <span class="material-symbols-outlined upload-icon">upload_file</span>
                                    <span class="upload-text">LOCAL UPLOAD</span>
                                    <input type="file" id="profile_image" name="profile_image" accept="image/*"
                                        style="display: none;" onchange="updateFileName(this)">
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

                            <button type="submit" class="btn btn-primary"
                                style="padding: 1.25rem 3rem; font-size: 0.75rem; letter-spacing: 0.2em; margin-top: 1rem; width: 100%; border: none;">COMMIT
                                CHANGES</button>
                        </form>
                    </section>

                    <!-- Security Section -->
                    <div class="space-y-8">

                        <section class="bg-white border border-outline-variant/30 p-8 shadow-sm">
                            <h2
                                class="text-[10px] font-black uppercase tracking-[0.2em] text-outline border-b border-outline-variant/30 pb-4 mb-6">
                                SECURITY_OVERRIDE</h2>

                            <form action="${pageContext.request.contextPath}/user" method="POST" class="space-y-6">
                                <input type="hidden" name="action" value="update_password">
                                <input type="hidden" name="redirect" value="admin?action=profile">

                                <div class="form-group">
                                    <label
                                        class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">New
                                        Security Key</label>
                                    <input type="password" name="new_password"
                                        class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none"
                                        required>
                                </div>

                                <div class="form-group">
                                    <label
                                        class="text-[9px] font-black uppercase tracking-widest text-outline mb-2 block">Confirm
                                        Key</label>
                                    <input type="password" name="confirm_password"
                                        class="w-full border border-outline-variant p-3 text-xs font-bold focus:border-black outline-none"
                                        required>
                                </div>

                                <button type="submit" class="btn btn-ghost"
                                    style="width: 100%; border: 2px solid var(--primary); padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.1em; background-color: transparent; cursor: pointer;">UPDATE
                                    CREDENTIALS</button>
                            </form>
                        </section>

                    </div>
                </div>
            </div>

            <jsp:include page="components/admin_layout_footer.jsp" />