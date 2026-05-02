<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join the Community | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
    <style>
        .upload-drop-zone {
            border: 2px dashed var(--outline-variant);
            padding: 2.5rem;
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
<body style="min-height: 100vh; display: flex; flex-direction: column;">

    <jsp:include page="components/public_header.jsp" />

    <main class="auth-main" style="padding: 4rem 2rem;">
        <div class="split-layout">
            <!-- Left Side: Branding -->
            <div class="split-branding">
                <div>
                    <span class="label-md" style="color: var(--on-primary); opacity: 0.7;">Node Registration v1.0</span>
                    <h1 style="color: var(--on-primary); font-size: 3.5rem; line-height: 1; margin: 2rem 0;">JOIN THE<br>COMMUNITY.</h1>
                    <div style="width: 3rem; height: 4px; background-color: var(--on-primary); margin-bottom: 2rem;"></div>
                    <p style="opacity: 0.8; font-weight: 500; line-height: 1.6;">
                        Access shared resources, track community borrowings, and maintain collective trust in your local neighborhood ecosystem.
                    </p>
                </div>
                
                <div class="branding-notice">
                    <h4>Security Protocol</h4>
                    <p>Registration requires a valid address to ensure neighborhood specific ledger integrity and accountability.</p>
                </div>
            </div>

            <!-- Right Side: Form -->
            <div class="split-form">
                <div class="mb-8">
                    <h2 style="font-size: 1.75rem; font-weight: 800; color: var(--primary);">Create Account</h2>
                    <p style="font-size: 0.875rem; color: var(--outline); margin-top: 0.5rem;margin-bottom:0.7rem">
                        Already a member? <a href="${pageContext.request.contextPath}/user?action=login" style="color: var(--primary); font-weight: 800; text-decoration: underline;">Login Here</a>
                    </p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="auth-msg auth-msg-error"><%= request.getAttribute("error") %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/user" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="register">
                    
                    <div class="input-grid">
                        <div class="form-group">
                            <label for="full_name" class="form-label">Full Name</label>
                            <input type="text" id="full_name" name="full_name" class="form-input" placeholder="John Doe" required>
                        </div>
                        <div class="form-group">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" id="email" name="email" class="form-input" placeholder="john@sapati.com" required>
                        </div>
                    </div>

                    <div class="input-grid mt-8">
                        <div class="form-group">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="text" id="phone" name="phone" class="form-input" placeholder="98XXXXXXXX" required>
                        </div>
                        <div class="form-group">
                            <label for="password" class="form-label">Account Password</label>
                            <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required>
                        </div>
                    </div>

                    <div class="form-group mt-8">
                        <label for="address" class="form-label">Neighborhood / Address</label>
                        <div style="position: relative;">
                            <span class="material-symbols-outlined" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--outline); font-size: 1.25rem;">location_on</span>
                            <input type="text" id="address" name="address" class="form-input" style="padding-left: 3rem;" placeholder="e.g. Kathmandu / 123 Main St" required>
                        </div>
                    </div>

                    <div class="form-group mt-8">
                        <label class="label-md" style="color: var(--outline);">PROFILE IDENTITY IMAGE</label>
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

                    <div class="input-grid mt-8">
                        <div class="form-group">
                            <label for="security_question" class="form-label">Security Question</label>
                            <select id="security_question" name="security_question" class="form-input" style="background-image: none;" required>
                                <option value="" disabled selected>Select a question...</option>
                                <option value="What was your first pet's name?">What was your first pet's name?</option>
                                <option value="In what city were you born?">In what city were you born?</option>
                                <option value="What was your childhood nickname?">What was your childhood nickname?</option>
                                <option value="What is the name of your first school?">What is the name of your first school?</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="security_answer" class="form-label">Security Answer</label>
                            <input type="text" id="security_answer" name="security_answer" class="form-input" placeholder="Your answer..." required>
                        </div>
                    </div>

                    <div class="mt-8 pt-8" style="border-top: 1px dashed var(--outline-variant);">
                        <label style="display: flex; gap: 1rem; cursor: pointer;">
                            <input type="checkbox" required style="margin-top: 0.25rem;">
                            <span style="font-size: 0.75rem; line-height: 1.6; color: var(--outline);margin-top:0.5rem">
                                I agree to the <strong style="color: var(--primary);">Terms of Service</strong> and acknowledge the community late fine policy of NPR 50/day. I understand trust is our foundation.
                            </span>
                        </label>
                    </div>

                    <div class="mt-8">
                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1.25rem; font-size: 0.75rem; letter-spacing: 0.2em; text-transform: uppercase;margin-top:0.5rem">
                            Initiate Registration
                            <span class="material-symbols-outlined" style="font-size: 1rem; vertical-align: middle; margin-left: 1rem;">arrow_forward</span>
                        </button>
                    </div>
                </form>
                
                <div class="mt-8 grid-3" style="gap: 1rem; opacity: 0.5;">
                    <div style="height: 2px; background-color: var(--outline-variant);"><div style="width: 40%; height: 100%; background-color: var(--primary);"></div></div>
                    <div style="height: 2px; background-color: var(--outline-variant);"></div>
                    <div style="height: 2px; background-color: var(--outline-variant);"></div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="components/public_footer.jsp" />

</body>
</html>