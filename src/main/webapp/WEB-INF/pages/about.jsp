<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | Sapati.com</title>
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    
    <!-- Custom Vanilla CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
</head>
<body>

    <jsp:include page="components/public_header.jsp" />

    <main class="container">
        
        <section class="mt-8">
            <div class="about-hero">
                <span class="label-md">Our Mission</span>
                <h1 class="mt-8 mb-4">Sharing Resources, <br>Building Community.</h1>
                <p class="mt-8" style="max-width: 700px; margin-left: auto; margin-right: auto;">
                    Sapati is more than just a lending platform. It is a digital ledger of trust, designed to reduce waste and strengthen neighborly bonds through the power of sharing.
                </p>
            </div>
        </section>

        <section class="content-section">
            <div class="mb-8">
                <span class="label-md">The Vision</span>
                <h2 class="section-title">Beyond Consumption</h2>
            </div>
            <p class="mb-8" style="font-size: 1.125rem; line-height: 1.8; color: var(--outline);">
                In a world focused on ownership, Sapati celebrates accessibility. We believe that every high-quality tool, appliance, or piece of camping gear should be used to its full potential, not sit idle in a garage. By creating a transparent, community-governed lending system, we make it possible for everyone to access what they need, exactly when they need it.
            </p>

            <div class="mission-grid">
                <div class="value-block">
                    <span class="label-md" style="color: var(--primary);">01. Sustainability</span>
                    <h3 class="mt-8">Reduced Footprint</h3>
                    <p style="font-size: 0.875rem; color: var(--outline);">By sharing existing resources, we collectively reduce the demand for new manufacturing and minimize community waste.</p>
                </div>
                <div class="value-block">
                    <span class="label-md" style="color: var(--primary);">02. Trust</span>
                    <h3 class="mt-8">Digital Integrity</h3>
                    <p style="font-size: 0.875rem; color: var(--outline);">Our unique trust ledger ensures that every member is accountable, fostering a safe and reliable environment for everyone.</p>
                </div>
                <div class="value-block">
                    <span class="label-md" style="color: var(--primary);">03. Accessibility</span>
                    <h3 class="mt-8">Resource Equity</h3>
                    <p style="font-size: 0.875rem; color: var(--outline);">We lower the barrier to productivity and adventure by making expensive equipment available to all community members for free.</p>
                </div>
                <div class="value-block">
                    <span class="label-md" style="color: var(--primary);">04. Connection</span>
                    <h3 class="mt-8">Neighborhood Bonds</h3>
                    <p style="font-size: 0.875rem; color: var(--outline);">Every lending transaction is an opportunity to meet a neighbor, share a story, and build a more resilient community.</p>
                </div>
            </div>
        </section>

        <section class="cta-section" style="margin-top: 4rem;">
            <div class="hero-card" style="border-style: solid; border-width: 1px;">
                <h2 class="mb-4">Ready to start sharing?</h2>
                <p class="mb-8" style="margin: 10px;">Join hundreds of neighbors already participating in the Sapati trust network.</p>
                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/user?action=register" class="btn btn-primary">Create Your Account</a>
                    <a href="${pageContext.request.contextPath}/contact" class="btn btn-secondary">Talk to Us</a>
                </div>
            </div>
        </section>

    </main>

    <jsp:include page="components/public_footer.jsp" />

</body>
</html>
