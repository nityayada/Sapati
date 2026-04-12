<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sapati.com | Community Trust Ledger</title>
    
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
        
        <!-- Hero Section -->
        <section class="hero">
            <div class="hero-card">
                <div class="hero-icon material-symbols-outlined">inventory_2</div>
                <h1>
                    Borrow from your community. <span>Return with trust.</span>
                </h1>
                <p>
                    Free borrowing within your neighborhood ledger. <span class="price-accent">NPR 50/day</span> late fine applies to ensure fairness for everyone.
                </p>
                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/user?action=register" class="btn btn-primary">Register Free</a>
                    <a href="${pageContext.request.contextPath}/item?action=list" class="btn btn-secondary">Browse Items</a>
                </div>
                <div class="hero-stats">
                    <div class="stat-item">
                        <span class="material-symbols-outlined">verified_user</span>
                        <span class="stat-text">Verified Members</span>
                    </div>
                    <div class="stat-item">
                        <span class="material-symbols-outlined">history_edu</span>
                        <span class="stat-text">Digital Ledger</span>
                    </div>
                    <div class="stat-item">
                        <span class="material-symbols-outlined">volunteer_activism</span>
                        <span class="stat-text">Community Trust</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- How It Works Section -->
        <section class="section">
            <div class="section-header">
                <span class="label-md">The Process</span>
                <h2 class="section-title">How It Works</h2>
            </div>
            <div class="grid-3">
                <!-- Step 01 -->
                <div class="step-card">
                    <div class="step-number">01</div>
                    <div class="step-image">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuCgjlLEDHH2JCypnGM8hCC0lcLJfyyGsrHdCSMxcpriyyf7daP_2DTY4fzZazQyWDXdszVIDk9hRqk8YUDYVAA06SIZjpLQa9m3XfhXvgBxAIpcLGCKFU7j8K906L-tyqObPdh92yEbnEaWb6FdDDPZiSmzrT_ISDpgKgM2z8u1bJKko7WoIpfnkdeaBZgTUWmy4VOwmnEEeHj_bbIm5OONKjd6Hy3b0wUBUYTTKpVoQ7-hqycONUjpuj3VyMIIIsTCfbvgJj_hclA" alt="Blueprint of items">
                    </div>
                    <h3>Browse Items</h3>
                    <p>Search through our community catalog of high-quality tools, appliances, and gear available for free borrowing.</p>
                </div>
                <!-- Step 02 -->
                <div class="step-card">
                    <div class="step-number">02</div>
                    <div class="step-image">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuDUlNOlfHBZ6-sgjTHwe1vzI2_EFHeNT3QFfXDm6XwYhHIHCCoduvl3fYOlALv68igE2mxW4n2UxOIyLlXEc3sKtiqE0JpTD2rGmOSxoIlN4rXNMHYR0XhhYGG5_8_aYV8gCoBQ3Gvst1Ly_8P2zGdGZMHQ_ghz3OJw79JTIoKnzEQNgyPWyW4lFMWjgk5m1Znixg9tTKmlcmnV5jKGze04yiRBsyL-_OaWdNRL2O6yJrmrZ0AgsYSH76rYKhCKRFkcsONPSZOkj9c" alt="Handshake agreement">
                    </div>
                    <h3>Request to Borrow</h3>
                    <p>Select your dates and send a request. The owner will review your profile trust score before approving the hand-off.</p>
                </div>
                <!-- Step 03 -->
                <div class="step-card">
                    <div class="step-number">03</div>
                    <div class="step-image">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuDPaAQH5jIJYZpAxbseeRN0pWhOrj1m34IKk5LkORJT5biyPj74O8Ce0QDGccX_N38dDcGtUv3HjR-KDzGkHJlAAjPTk1uVessDJy9VoRNCM7qTOMiotf_z2-Kl1UqjvqloeQoVeIC1VmSYPXZIIri5bamTnlSo49N8pj7Vcin6GU81g0xxLyxAfIZAyVc-9w71tGUyzV7xKClWEz62nmG6qvFF4l_VydPKYlZmmLZdzA8CAvPeqaS178ixUK7_jvsEP9YLSX6OYkg" alt="Clock symbolising time">
                    </div>
                    <h3>Return on Time</h3>
                    <p>Ensure the item is returned in original condition. On-time returns maintain your trust rating and avoid late fees.</p>
                </div>
            </div>
        </section>

        <!-- Live Catalog Section -->
        <section class="section">
            <div class="catalog-header">
                <div>
                    <span class="label-md">Live Catalog</span>
                    <h2 class="section-title">Available for Borrowing</h2>
                </div>
                <div class="catalog-actions">
                    <form action="<%= request.getContextPath() %>/item" method="GET" class="search-box">
                        <input type="hidden" name="action" value="search">
                        <span class="material-symbols-outlined">search</span>
                        <input type="text" name="query" class="search-input" placeholder="Search items...">
                    </form>
                    <select class="category-select">
                        <option>All Categories</option>
                        <option>Tools</option>
                        <option>Electronics</option>
                        <option>Camping</option>
                    </select>
                </div>
            </div>

            <div class="grid-4">
                <!-- Item Card 1 -->
                <div class="item-card">
                    <div class="item-image">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuDx7eE2xp2J1lNIhqrUPVm-eetUTu26SkzhIgnP1BMm9YrZJD7R6JLVp1zakE5DOC0p29b3yqVO5Gjq_yycrFD3So3DbzoTvRSeyapg47qD8c6RuIWOvk9GyA8blpr2qvGpNYyJVGG64QqSJ0vS8Z439T3SH9nmDBYxdHcsKrJwDVUJp8QaoQFhoyQcZ5vi_poZw41mXjjtiLj9Npcc_2Ote5xv4HGkLhfDGGHZSy9qUcDUJd48IjLQj6_shY1GCeFhcyhqf862NwA" alt="Power Drill">
                    </div>
                    <div class="item-meta">
                        <span class="category-badge">Tools</span>
                        <span class="status-badge">
                            <span class="status-dot"></span> Available
                        </span>
                    </div>
                    <h3>DeWalt Cordless Drill</h3>
                    <p class="owner-text">Owned by <span class="owner-name">Rajan K.</span></p>
                    <a href="<%= request.getContextPath() %>/item?action=list" class="btn btn-secondary">
                        Request to Borrow <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                    </a>
                </div>

                <!-- Item Card 2 -->
                <div class="item-card">
                    <div class="item-image">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuARQUhtMksZzD2FWoXBdLkkXcdGTDse6ecHvf2LiCJu1cgFlyuJWpKZ_DRVlFwnnk3tz4c8mwHkRc2MTAGp2mvIvmF1GXN27Ajae7JSZjto0E103M6dfcvgW73Mba4IWPW6zkaHh5chvDFfGrt0GLbSCo-tL9gwEIFLhTV4OgNzyzJjxJwp5NaoRvGGwGbu0X85oTK4dlL13ZOyHLUP4MUWipk4bgdsVenjsx0dJowY0YH9o6xChprQBPZmZrIIQ3TfHV9PwFQ8jew" alt="Projector">
                    </div>
                    <div class="item-meta">
                        <span class="category-badge">Electronics</span>
                        <span class="status-badge">
                            <span class="status-dot"></span> Available
                        </span>
                    </div>
                    <h3>Epson 4K Projector</h3>
                    <p class="owner-text">Owned by <span class="owner-name">Sita M.</span></p>
                    <a href="<%= request.getContextPath() %>/item?action=list" class="btn btn-secondary">
                        Request to Borrow <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                    </a>
                </div>

                <!-- Item Card 3 -->
                <div class="item-card" style="opacity: 0.8;">
                    <div class="item-image">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuBVf7Qi8d36VRrYhan_-Uz4EhXvZXRmf7MR0-yt4qGDZDEMNSIVXqyPOtcpgAqF1zqBjlqFzPKQXAni-CAHMErwjoHE4qkxXIm0BRvdyjVMHnkrcoFHCoeozvFCzKXsgJN-En6tmlZQwrqtjZmALsfExfRMzLB9IbFRa-ScNiIBoEdosA3C14BKDeZ7-xoHCX-hOs6aTNlJ9ixURzUiiRt7OlRy_93zF0bDvIx0GVxW661VSCcS9plHl5hqV6RvN0XDoE0Y6liO2cE" alt="Tent">
                    </div>
                    <div class="item-meta">
                        <span class="category-badge">Camping</span>
                        <span class="status-badge" style="background-color: var(--surface-container-high); color: var(--outline);">
                            Borrowed
                        </span>
                    </div>
                    <h3>4-Person Alpine Tent</h3>
                    <p class="owner-text">Owned by <span class="owner-name">Aayush G.</span></p>
                    <button class="btn btn-ghost" style="border: 1px solid var(--outline); cursor: not-allowed;">
                        Coming Soon
                    </button>
                </div>

                <!-- Item Card 4 -->
                <div class="item-card">
                    <div class="item-image">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuCLz5YqXOHydTmlBQ8rpoj_6kvCMeGV2QwHpGgGrLgy_o7_iA66Rb4MLh264Fa7ksV0c3r0pBrLkVPeTOztNFFbGF1ylUDFB3Dgswfeymjxh1PiP4GZfo3OvWrIHPmxxqWvpB2RlRhgoAnPJkgEImX8YnkDPlnECWF8HRyWo8EdZN9ibBJhg10jS5ded0NeVkNXXBzWs9kQRFAjZWcB0BPeUBjUGmpN5FJl4_rExBVNGDrNWpfiJmOxhl6_HmY7LbhoRjUqPSZQxY0" alt="Pressure Washer">
                    </div>
                    <div class="item-meta">
                        <span class="category-badge">Tools</span>
                        <span class="status-badge">
                            <span class="status-dot"></span> Available
                        </span>
                    </div>
                    <h3>High-Power Washer</h3>
                    <p class="owner-text">Owned by <span class="owner-name">Bibek T.</span></p>
                    <a href="<%= request.getContextPath() %>/item?action=list" class="btn btn-secondary">
                        Request to Borrow <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
                    </a>
                </div>
            </div>

            <div style="margin-top: 4rem; display: flex; justify-content: center;">
                <a href="<%= request.getContextPath() %>/item?action=list" class="nav-link" style="font-weight: 900; letter-spacing: 0.1em; display: flex; align-items: center; gap: 1rem;">
                    VIEW ALL CATALOG ITEMS
                    <span style="width: 3rem; height: 2px; background-color: var(--primary);"></span>
                </a>
            </div>
        </section>

        <!-- Trust Ledger Teaser -->
        <section class="cta-section">
            <div class="cta-card">
                <div class="cta-content">
                    <h2>Join the Trusted Network</h2>
                    <p>Every transaction is logged in our community ledger. Your trust score determines your access to premium community items. Start building your legacy today.</p>
                </div>
                <div class="cta-stats">
                    <div style="text-align: center;">
                        <div class="cta-number">98%</div>
                        <div class="cta-stat-label">Return Accuracy</div>
                    </div>
                    <a href="<%= request.getContextPath() %>/user?action=register" class="btn">Join Now</a>
                </div>
            </div>
        </section>

    </main>

    <jsp:include page="components/public_footer.jsp" />

</body>
</html>
