<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body>

    <jsp:include page="components/public_header.jsp" />

    <main class="container">
        
        <section class="mt-8">
            <div class="about-hero" style="border-style: solid; border-width: 1px; background-color: var(--surface);">
                <span class="label-md">Get in Touch</span>
                <h1 class="mt-8 mb-4">How can we help?</h1>
                <p class="mt-8" style="max-width: 600px; margin-left: auto; margin-right: auto;">
                    Have questions about the trust ledger, membership, or hosting items? Our community support team is here to assist you.
                </p>
            </div>
        </section>

        <section class="section">
            <div class="form-container">
                <form action="#" method="POST">
                    <div class="form-group">
                        <label for="name" class="form-label">Full Name</label>
                        <input type="text" id="name" name="name" class="form-input" placeholder="Your name" required>
                    </div>
                    <div class="form-group">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" id="email" name="email" class="form-input" placeholder="your.email@example.com" required>
                    </div>
                    <div class="form-group">
                        <label for="subject" class="form-label">Subject</label>
                        <select id="subject" name="subject" class="category-select" style="width: 100%; height: auto; padding: 1rem;">
                            <option value="general">General Inquiry</option>
                            <option value="account">Account Support</option>
                            <option value="violation">Report a Violation</option>
                            <option value="feedback">Feedback/Suggestions</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="message" class="form-label">Message</label>
                        <textarea id="message" name="message" class="form-textarea" placeholder="Describe your inquiry in detail..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem;">
                        Send Message
                        <span class="material-symbols-outlined" style="font-size: 1rem; margin-top: 2px;">send</span>
                    </button>
                </form>
            </div>
        </section>

        <section class="content-section text-center" style="padding-top: 0;">
            <div class="grid-3" style="gap: 1.5rem;">
                <div class="step-card" style="padding: 1.5rem;">
                    <span class="material-symbols-outlined mb-4" style="font-size: 2rem; color: var(--outline);">mail</span>
                    <h3 style="font-size: 1rem;">Email Us</h3>
                    <p style="font-size: 0.75rem;">support@sapati.com</p>
                </div>
                <div class="step-card" style="padding: 1.5rem;">
                    <span class="material-symbols-outlined mb-4" style="font-size: 2rem; color: var(--outline);">location_on</span>
                    <h3 style="font-size: 1rem;">Visit Us</h3>
                    <p style="font-size: 0.75rem;">Kathmandu, Nepal</p>
                </div>
                <div class="step-card" style="padding: 1.5rem;">
                    <span class="material-symbols-outlined mb-4" style="font-size: 2rem; color: var(--outline);">chat_bubble</span>
                    <h3 style="font-size: 1rem;">Live Chat</h3>
                    <p style="font-size: 0.75rem;">Mon-Fri, 9am - 6pm</p>
                </div>
            </div>
        </section>

    </main>

    <jsp:include page="components/public_footer.jsp" />

</body>
</html>
