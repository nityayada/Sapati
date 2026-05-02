<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 // NODE_NOT_FOUND</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <style>
        :root {
            --bg: #FFFFFF;
            --fg: #000000;
            --muted: #666666;
            --border: #E5E5E5;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background-color: var(--bg);
            background-image: radial-gradient(#000 0.5px, transparent 0.5px);
            background-size: 30px 30px;
            color: var(--fg);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            text-align: center;
        }

        /* 404 Header Box */
        .error-header {
            position: relative;
            padding: 4rem 8rem;
            margin-bottom: 4rem;
        }

        .error-header::before {
            content: '';
            position: absolute;
            inset: 0;
            border: 1px dashed #000;
            opacity: 0.3;
        }

        /* Corner Squares */
        .corner {
            position: absolute;
            width: 8px;
            height: 8px;
            background: #000;
        }
        .tl { top: -4px; left: -4px; }
        .tr { top: -4px; right: -4px; }
        .bl { bottom: -4px; left: -4px; }
        .br { bottom: -4px; right: -4px; }

        .error-code-large {
            font-size: 10rem;
            font-weight: 900;
            letter-spacing: -0.05em;
            line-height: 1;
        }

        /* Pill Label */
        .pill-label {
            background: #000;
            color: #FFF;
            padding: 0.5rem 1.5rem;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            display: inline-block;
            margin-bottom: 2rem;
        }

        /* Headline */
        .headline {
            font-size: 2.25rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: -0.02em;
            line-height: 1.1;
            max-width: 800px;
            margin-bottom: 1.5rem;
        }

        /* Description */
        .description {
            font-size: 1rem;
            color: var(--muted);
            max-width: 600px;
            line-height: 1.6;
            margin-bottom: 4rem;
        }

        /* Action Buttons */
        .btn-container {
            display: flex;
            gap: 1rem;
            margin-bottom: 6rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1.25rem 2.5rem;
            font-size: 11px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            text-decoration: none;
            transition: all 0.2s;
            cursor: pointer;
        }

        .btn-solid {
            background: #000;
            color: #FFF;
            border: 1px solid #000;
        }

        .btn-outline {
            background: #FFF;
            color: #000;
            border: 1px solid #000;
        }

        .btn:hover {
            opacity: 0.8;
            transform: translateY(-2px);
        }

        /* Footer Ribbons */
        .footer-ribbons {
            width: 100%;
            max-width: 1000px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            border: 1px solid #F0F0F0;
            background: #FAFAFA;
        }

        .ribbon {
            padding: 2rem;
            border-right: 1px solid #F0F0F0;
            text-align: left;
        }

        .ribbon:last-child {
            border-right: none;
        }

        .ribbon-label {
            font-size: 9px;
            font-weight: 800;
            color: #AAA;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-bottom: 0.5rem;
            display: block;
        }

        .ribbon-value {
            font-size: 13px;
            font-weight: 900;
            text-transform: uppercase;
            color: #000;
        }
    </style>
</head>
<body>

    <div class="error-header">
        <div class="corner tl"></div>
        <div class="corner tr"></div>
        <div class="corner bl"></div>
        <div class="corner br"></div>
        <h1 class="error-code-large">404</h1>
    </div>

    <div class="pill-label">Error Code: 0xNode_Not_Found</div>

    <h2 class="headline">The requested node cannot be located within the system architecture.</h2>

    <p class="description">
        The navigational parameters provided do not map to any existing directory or terminal. Please verify the destination coordinates or revert to the primary operational interface.
    </p>

    <div class="btn-container">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-solid">
            <span class="material-symbols-outlined" style="font-size: 18px;">dashboard_customize</span>
            Return to Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline">
            <span class="material-symbols-outlined" style="font-size: 18px;">warning</span>
            Report System Anomaly
        </a>
    </div>

    <div class="footer-ribbons">
        <div class="ribbon">
            <span class="ribbon-label">Sub-System</span>
            <span class="ribbon-value">Routing_Engine_v4.2</span>
        </div>
        <div class="ribbon">
            <span class="ribbon-label">Active Latency</span>
            <span class="ribbon-value">0.00ms (Reached Dead End)</span>
        </div>
        <div class="ribbon">
            <span class="ribbon-label">Trace ID</span>
            <span class="ribbon-value">SAP-8821-X-404</span>
        </div>
    </div>

</body>
</html>
