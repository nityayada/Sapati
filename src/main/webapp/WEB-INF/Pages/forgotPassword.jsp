<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Recovery | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body style="min-height: 100vh; display: flex; flex-direction: column; background-color: var(--surface-container-low);">

    <jsp:include page="components/public_header.jsp" />

    <main style="flex: 1; display: flex; align-items: center; justify-content: center; padding: 2rem;">
        <div class="form-container" style="max-width: 450px; width: 100%; box-shadow: 0 10px 25px rgba(0,0,0,0.05);">
            <div class="mb-8 text-center">
                <span class="material-symbols-outlined text-primary" style="font-size: 3rem; margin-bottom: 1rem;">lock_reset</span>
                <h2 style="font-size: 1.75rem; font-weight: 900; color: var(--primary); text-transform: uppercase; tracking-tight">Account Recovery</h2>
                <p style="font-size: 0.875rem; color: var(--outline); margin-top: 0.5rem;">
                    Enter your email to initiate the identity verification process.
                </p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="auth-msg auth-msg-error" style="background: #fee2e2; color: #b91c1c; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.875rem; text-align: center;">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/user" method="POST">
                <input type="hidden" name="action" value="initiate_recovery">
                
                <div class="form-group">
                    <label for="email" class="form-label">Registered Email</label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="john@sapati.com" required>
                </div>

                <div class="mt-8">
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.2em; text-transform: uppercase;">
                        Find Account
                        <span class="material-symbols-outlined" style="font-size: 1rem; vertical-align: middle; margin-left: 1rem;">search</span>
                    </button>
                </div>

                <div class="mt-8 text-center">
                    <a href="${pageContext.request.contextPath}/user?action=login" style="font-size: 0.75rem; font-weight: 800; color: var(--outline); text-transform: uppercase; tracking-widest;">
                        &larr; Back to Login
                    </a>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="components/public_footer.jsp" />

</body>
</html>
