<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="min-height: 100vh; display: flex; flex-direction: column;">

    <jsp:include page="components/public_header.jsp" />

    <main class="auth-main">
        <div class="login-module">
            <!-- Heading Group -->
            <div class="mb-8 text-center" style="border-bottom: 1px dashed var(--outline-variant); padding-bottom: 2rem; margin-bottom: 2rem;">
                <span class="label-md">Access Portal</span>
                <h1 class="mt-8" style="font-size: 2rem;">Login to Ledger</h1>
            </div>

            <!-- Global Messaging -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="auth-msg auth-msg-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("registered")) { %>
                <div class="auth-msg auth-msg-success">Registration successful! Please login.</div>
            <% } %>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/user" method="POST">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="name@community.com" required>
                </div>

                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                        <label for="password" class="form-label" style="margin-bottom: 0;">Password</label>
                        <a href="${pageContext.request.contextPath}/user?action=forgot_password" style="font-size: 0.6875rem; color: var(--primary); font-weight: 800; text-decoration: underline;">Forgot Password?</a>
                    </div>
                    <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required>
                </div>

                <div class="mt-8">
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem; border-radius: 0.5rem;">
                        <span class="material-symbols-outlined" style="font-size: 1.25rem; vertical-align: middle; margin-right: 0.5rem;">login</span>
                        Login to Account
                    </button>
                </div>
            </form>

            <!-- Footer Links -->
            <div class="auth-footer">
                <p>
                    Don't have an account? 
                    <a href="${pageContext.request.contextPath}/user?action=register">Register Here</a>
                </p>
            </div>
        </div>

        <!-- Blueprint Decorative Element -->
        <div style="position: absolute; right: 3rem; bottom: 3rem; opacity: 0.1; pointer-events: none;" class="hidden-mobile">
            <div style="border: 1px dashed var(--outline); padding: 1.5rem; transform: rotate(3deg); font-family: monospace; font-size: 0.6rem; text-transform: uppercase;">
                Ref: SAP-AUTH-2024<br>
                Community Ledger Protocol<br>
                Node: KTM-01
            </div>
        </div>
    </main>

    <jsp:include page="components/public_footer.jsp" />

</body>
</html>