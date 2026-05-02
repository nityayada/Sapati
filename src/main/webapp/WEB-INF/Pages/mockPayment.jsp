<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String amount = (String) request.getAttribute("amount");
    String recordId = (String) request.getAttribute("record_id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Gateway | Sapati.com</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
    <style>
        .payment-option {
            border: 2px solid var(--outline-variant);
            padding: 1.5rem;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 1rem;
        }
        .payment-option:hover {
            border-color: var(--primary);
            background-color: var(--surface-container-low);
        }
        .payment-option.active {
            border-color: var(--primary);
            background-color: var(--surface-container-high);
        }
        .gateway-container {
            max-width: 500px;
            margin: 4rem auto;
            background: white;
            border: 1px solid var(--outline-variant);
            padding: 3rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
        }
        .loader-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.9);
            display: none;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        .spinner {
            width: 50px;
            height: 50px;
            border: 5px solid var(--outline-variant);
            border-top: 5px solid var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-bottom: 2rem;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body style="background-color: #F8F9FA; min-height: 100vh;">

    <div id="loader" class="loader-overlay">
        <div class="spinner"></div>
        <h2 style="font-weight: 900; text-transform: uppercase; letter-spacing: 0.2em;">Processing Transaction</h2>
        <p style="color: var(--outline); font-size: 0.75rem; margin-top: 1rem;">SECURE CONNECTION ESTABLISHED. DO NOT REFRESH.</p>
    </div>

    <div class="gateway-container">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 3rem;">
            <div>
                <span class="label-md" style="color: var(--outline);">SECURE CHECKOUT</span>
                <h1 style="font-size: 1.5rem; font-weight: 900; text-transform: uppercase;">Sapati Pay</h1>
            </div>
            <div style="text-align: right;">
                <div style="font-size: 0.75rem; color: var(--outline); font-weight: 700;">AMOUNT</div>
                <div style="font-size: 1.25rem; font-weight: 900; color: var(--primary);">NPR <%= amount %></div>
            </div>
        </div>

        <form id="paymentForm" action="${pageContext.request.contextPath}/payment" method="POST">
            <input type="hidden" name="action" value="finalize">
            <input type="hidden" name="record_id" value="<%= recordId %>">
            <input type="hidden" name="amount" value="<%= amount %>">
            <input type="hidden" name="days_late" value="<%= (int)(Double.parseDouble(amount)/50) %>">
            <input type="hidden" id="selectedMethod" name="payment_method" value="eSewa">

            <div class="payment-option active" onclick="selectMethod('eSewa', this)">
                <div style="width: 48px; height: 48px; background: #60BB46; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 900; font-size: 0.75rem;">eSewa</div>
                <div>
                    <div style="font-weight: 900; font-size: 0.875rem;">eSewa Wallet</div>
                    <div style="font-size: 0.625rem; color: var(--outline);">CONNECT TO DIGITAL WALLET</div>
                </div>
            </div>

            <div class="payment-option" onclick="selectMethod('Khalti', this)">
                <div style="width: 48px; height: 48px; background: #5C2D91; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 900; font-size: 0.75rem;">Khalti</div>
                <div>
                    <div style="font-weight: 900; font-size: 0.875rem;">Khalti Wallet</div>
                    <div style="font-size: 0.625rem; color: var(--outline);">INSTANT MOBILE PAYMENT</div>
                </div>
            </div>

            <div class="payment-option" onclick="selectMethod('ConnectIPS', this)">
                <div style="width: 48px; height: 48px; background: #004B8D; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 900; font-size: 0.6rem;">ConnectIPS</div>
                <div>
                    <div style="font-weight: 900; font-size: 0.875rem;">Direct Bank Transfer</div>
                    <div style="font-size: 0.625rem; color: var(--outline);">INTERBANK PAYMENT SYSTEM</div>
                </div>
            </div>

            <div id="detailsArea" style="margin-top: 2rem; background: var(--surface-container-low); padding: 2rem; border: 1px solid var(--outline-variant);">
                <div class="form-group" style="margin-bottom: 0;">
                    <label id="methodLabel" class="label-md" style="color: var(--outline); margin-bottom: 0.5rem; display: block;">ESEWA ID (MOBILE NUMBER)</label>
                    <input type="text" class="form-input" placeholder="98XXXXXXXX" style="letter-spacing: 0.1em; font-weight: 700;">
                </div>
            </div>

            <button type="button" onclick="processPayment()" class="btn btn-primary" style="width: 100%; margin-top: 3rem; padding: 1.5rem; font-size: 0.8125rem; letter-spacing: 0.3em; background: #1A1A1A;">
                AUTHORIZE PAYMENT
            </button>
        </form>

        <div style="margin-top: 2rem; display: flex; align-items: center; justify-content: center; gap: 0.5rem; color: var(--outline);">
            <span class="material-symbols-outlined" style="font-size: 1rem;">lock</span>
            <span style="font-size: 0.625rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em;">256-bit AES Encryption</span>
        </div>
    </div>

    <script>
        function selectMethod(method, element) {
            document.querySelectorAll('.payment-option').forEach(opt => opt.classList.remove('active'));
            element.classList.add('active');
            document.getElementById('selectedMethod').value = method;
            document.getElementById('methodLabel').textContent = method.toUpperCase() + " IDENTIFIER";
        }

        function processPayment() {
            document.getElementById('loader').style.display = 'flex';
            setTimeout(() => {
                document.getElementById('paymentForm').submit();
            }, 2500); // Simulate network latency
        }
    </script>

</body>
</html>
