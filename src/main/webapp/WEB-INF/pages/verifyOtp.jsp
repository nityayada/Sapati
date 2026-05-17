<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${empty sessionScope.resetEmail}">
            <c:redirect url="/user?action=forgot_password" />
        </c:if>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Verify OTP | Sapati.com</title>

            <!-- Google Fonts: Inter -->
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap"
                rel="stylesheet">

            <!-- Material Symbols -->
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
                rel="stylesheet" />

            <!-- CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
        </head>

        <body
            style="min-height: 100vh; display: flex; flex-direction: column; background-color: var(--surface-container-low);">

            <jsp:include page="components/public_header.jsp" />

            <main style="flex: 1; display: flex; align-items: center; justify-content: center; padding: 2rem;">
                <div class="form-container"
                    style="max-width: 450px; width: 100%; box-shadow: 0 10px 25px rgba(0,0,0,0.05);">
                    <div class="mb-8 text-center">
                        <span class="material-symbols-outlined text-primary"
                            style="font-size: 3rem; margin-bottom: 1rem;">mark_email_read</span>
                        <h2
                            style="font-size: 1.75rem; font-weight: 900; color: var(--primary); text-transform: uppercase; tracking-tight">
                            Enter Verficiation Code</h2>
                        <p style="font-size: 0.875rem; color: var(--outline); margin-top: 0.5rem;">
                            We sent a 6-digit code to your email address.
                        </p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="auth-msg auth-msg-error"
                            style="background: #fee2e2; color: #b91c1c; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.875rem; text-align: center;">
                            ${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/user" method="POST">
                        <input type="hidden" name="action" value="verify_otp">

                        <div class="form-group">
                            <label for="otp" class="form-label">6-Digit Code</label>
                            <input type="text" id="otp" name="otp" class="form-input" placeholder="123456" maxlength="6"
                                pattern="\d{6}" required title="Please enter exactly 6 digits"
                                style="text-align: center; letter-spacing: 0.5em; font-size: 1.25rem;">
                        </div>

                        <div class="mt-8">
                            <button type="submit" class="btn btn-primary"
                                style="width: 100%; padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.2em; text-transform: uppercase;">
                                Verify Code
                                <span class="material-symbols-outlined"
                                    style="font-size: 1rem; vertical-align: middle; margin-left: 1rem;">check_circle</span>
                            </button>
                        </div>

                        <div class="mt-8 text-center">
                            <a href="${pageContext.request.contextPath}/user?action=login"
                                style="font-size: 0.75rem; font-weight: 800; color: var(--outline); text-transform: uppercase; tracking-widest;">
                                &larr; Back to Login
                            </a>
                        </div>
                    </form>
                </div>
            </main>

            <jsp:include page="components/public_footer.jsp" />

        </body>

        </html>