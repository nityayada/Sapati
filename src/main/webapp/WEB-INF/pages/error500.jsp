<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 // SYSTEM_FAILURE</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <style>
        :root {
            --bg: #000000;
            --fg: #FFFFFF;
            --muted: #888888;
            --error: #FF3B30;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background-color: var(--bg);
            background-image: linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px),
                              linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px);
            background-size: 40px 40px;
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

        /* 500 Header Box */
        .error-header {
            position: relative;
            padding: 4rem 8rem;
            margin-bottom: 4rem;
        }

        .error-header::before {
            content: '';
            position: absolute;
            inset: 0;
            border: 1px dashed rgba(255,255,255,0.3);
        }

        .corner {
            position: absolute;
            width: 8px;
            height: 8px;
            background: var(--error);
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
            color: var(--error);
        }

        /* Pill Label */
        .pill-label {
            background: var(--error);
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
            background: #FFF;
            color: #000;
            border: 1px solid #FFF;
        }

        .btn-outline {
            background: transparent;
            color: #FFF;
            border: 1px solid rgba(255,255,255,0.3);
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
            border: 1px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.02);
        }

        .ribbon {
            padding: 2rem;
            border-right: 1px solid rgba(255,255,255,0.1);
            text-align: left;
        }

        .ribbon:last-child {
            border-right: none;
        }

        .ribbon-label {
            font-size: 9px;
            font-weight: 800;
            color: #555;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-bottom: 0.5rem;
            display: block;
        }

        .ribbon-value {
            font-size: 13px;
            font-weight: 900;
            text-transform: uppercase;
            color: var(--fg);
        }
    </style>
</head>
<body>

    <div class="error-header">
        <div class="corner tl"></div>
        <div class="corner tr"></div>
        <div class="corner bl"></div>
        <div class="corner br"></div>
        <h1 class="error-code-large">500</h1>
    </div>

    <div class="pill-label">System State: 0xCritical_Failure</div>

    <h2 class="headline">An internal architecture failure has been detected.</h2>

    <p class="description">
        The community ledger has encountered an unhandled exception sequence. Core operational parameters have been suspended to prevent data corruption. Please re-initialize your session.
    </p>

    <div class="btn-container">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-solid">
            <span class="material-symbols-outlined" style="font-size: 18px;">restart_alt</span>
            Re-initialize System
        </a>
        <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline">
            <span class="material-symbols-outlined" style="font-size: 18px;">terminal</span>
            View Status Report
        </a>
    </div>

    <div class="footer-ribbons">
        <div class="ribbon">
            <span class="ribbon-label">Sub-System</span>
            <span class="ribbon-value">Internal_Kernel_v2.0</span>
        </div>
        <div class="ribbon">
            <span class="ribbon-label">Error Status</span>
            <span class="ribbon-value">Exception_Unhandled</span>
        </div>
        <div class="ribbon">
            <span class="ribbon-label">Trace ID</span>
            <span class="ribbon-value">SAP-SYS-CRITICAL-500</span>
        </div>
    </div>

</body>
</html>
