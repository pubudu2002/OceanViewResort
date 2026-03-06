<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 2:52 PM
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.Bill" %>
<%@ page import="com.example.resort.model.Reservation" %>
<%
    Bill        bill      = (Bill) request.getAttribute("bill");
    Reservation res       = (Reservation) request.getAttribute("reservation");
    Boolean     printMode = (Boolean) request.getAttribute("printMode");
    String      successMsg = request.getParameter("success");
    String      errorMsg   = (String) request.getAttribute("errorMsg");
    boolean     isPrint    = Boolean.TRUE.equals(printMode);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bill — <%= bill != null ? bill.getReservationNo() : "" %></title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Poppins', sans-serif;
            background: #f0f4fa;
            color: #333;
        }

        /* ── Navbar ── */
        .navbar {
            background: linear-gradient(135deg, #1565C0, #0D47A1);
            color: white;
            padding: 14px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .navbar h2 {
            font-size: 18px;
            font-weight: 600;
        }

        .navbar a {
            color: #BBDEFB;
            text-decoration: none;
            margin-left: 18px;
            font-size: 13px;
            font-weight: 500;
            transition: color 0.2s;
        }

        .navbar a:hover { color: #ffffff; }

        /* ── Container ── */
        .container {
            padding: 30px 20px;
            max-width: 700px;
            margin: 0 auto;
            animation: fadeUp 0.5s ease;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Alerts ── */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 18px;
            font-weight: 500;
        }

        .alert-success {
            background: #E8F5E9;
            color: #2E7D32;
            border-left: 4px solid #43A047;
        }

        .alert-danger {
            background: #FFEBEE;
            color: #C62828;
            border-left: 4px solid #E53935;
        }

        /* ── Bill Card ── */
        .bill-card {
            background: white;
            border-radius: 14px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.09);
            overflow: hidden;
            margin-bottom: 20px;
        }

        /* Bill top header */
        .bill-header {
            background: linear-gradient(135deg, #1565C0, #1976D2);
            color: white;
            padding: 28px 30px;
            text-align: center;
        }

        .bill-header h1 { font-size: 22px; font-weight: 700; margin-bottom: 4px; }
        .bill-header p  { font-size: 12px; color: #BBDEFB; }
        .bill-header .invoice-tag {
            display: inline-block;
            margin-top: 10px;
            padding: 4px 16px;
            background: rgba(255,255,255,0.15);
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        /* Meta row */
        .bill-meta {
            display: flex;
            justify-content: space-between;
            padding: 16px 30px;
            background: #F8FAFF;
            border-bottom: 1px solid #e8eef8;
            gap: 10px;
            flex-wrap: wrap;
        }

        .meta-item .label {
            font-size: 10px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: #999;
            margin-bottom: 3px;
        }

        .meta-item .value {
            font-size: 13px;
            font-weight: 600;
            color: #1565C0;
        }

        /* Bill body */
        .bill-body { padding: 28px 30px; }

        .section-title {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #1565C0;
            font-weight: 700;
            margin-bottom: 12px;
            margin-top: 22px;
            padding-bottom: 6px;
            border-bottom: 1.5px solid #E3F2FD;
        }

        .section-title:first-child { margin-top: 0; }

        /* Info grid */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 10px;
        }

        .info-item .lbl {
            font-size: 11px;
            color: #aaa;
            margin-bottom: 2px;
        }

        .info-item .val {
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }

        /* Charges table */
        .bill-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 8px;
            font-size: 13px;
        }

        .bill-table th {
            background: #F0F6FF;
            padding: 10px 14px;
            font-size: 11px;
            text-align: left;
            color: #1565C0;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .bill-table td {
            padding: 11px 14px;
            border-bottom: 1px solid #f0f0f0;
            color: #444;
        }

        /* Totals */
        .totals { margin-top: 14px; }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 7px 0;
            font-size: 13px;
            color: #666;
            border-bottom: 1px solid #f5f5f5;
        }

        .grand-total {
            display: flex;
            justify-content: space-between;
            padding: 14px 0 0;
            font-size: 19px;
            font-weight: 700;
            color: #1565C0;
            border-top: 2px solid #1565C0;
            margin-top: 8px;
        }

        /* Payment status badge */
        .payment-status {
            text-align: center;
            padding: 13px;
            margin-top: 22px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
        }

        .status-paid    { background: #E8F5E9; color: #2E7D32; }
        .status-pending { background: #FFF8E1; color: #F57F17; }

        /* Bill footer */
        .bill-footer {
            text-align: center;
            padding: 18px;
            border-top: 1px solid #eee;
            font-size: 12px;
            color: #aaa;
            background: #FAFCFF;
        }

        /* ── Payment Card ── */
        .payment-card {
            background: white;
            border-radius: 14px;
            padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        .payment-card h3 {
            color: #1565C0;
            font-size: 16px;
            margin-bottom: 16px;
        }

        .payment-card p {
            font-size: 13px;
            color: #666;
            margin-bottom: 14px;
        }

        /* Payment method options */
        .payment-methods { display: flex; gap: 12px; margin-bottom: 18px; flex-wrap: wrap; }

        .pay-option { display: none; }

        .pay-label {
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            color: #666;
            transition: all 0.2s;
        }

        .pay-label:hover { border-color: #1565C0; color: #1565C0; }

        .pay-option:checked + .pay-label {
            border-color: #1565C0;
            background: #E3F2FD;
            color: #1565C0;
        }

        /* ── Buttons ── */
        .btn {
            padding: 10px 22px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            font-family: 'Poppins', sans-serif;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.2s, box-shadow 0.2s, opacity 0.2s;
        }

        .btn:hover { transform: translateY(-1px); opacity: 0.92; }
        .btn:active { transform: translateY(0); }

        .btn-success   { background: #43A047; color: white; box-shadow: 0 3px 10px rgba(67,160,71,0.3); }
        .btn-primary   { background: linear-gradient(135deg, #1565C0, #1976D2); color: white; box-shadow: 0 3px 10px rgba(21,101,192,0.3); }
        .btn-secondary { background: #eee; color: #555; }

        .btn-group { display: flex; gap: 12px; flex-wrap: wrap; }

        /* ── Print styles ── */
        @media print {
            .navbar, .payment-card, .btn-group, .no-print { display: none !important; }
            body { background: white; }
            .container { padding: 0; max-width: 100%; }
            .bill-card { box-shadow: none; border: 1px solid #ddd; border-radius: 0; }
        }
    </style>
</head>
<body>

<% if (!isPrint) { %>
<nav class="navbar">
    <h2>🏖 Ocean View Resort</h2>
    <div>
        <a href="<%= request.getContextPath() %>/reservation?action=list">Reservations</a>
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
    </div>
</nav>
<% } %>

<div class="container">

    <% if (successMsg != null) { %>
    <div class="alert alert-success">✅ <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
    <div class="alert alert-danger">❌ <%= errorMsg %></div>
    <% } %>

    <% if (bill == null || res == null) { %>
    <div style="background:white;padding:30px;border-radius:14px;text-align:center;color:#999;box-shadow:0 4px 20px rgba(0,0,0,0.08);">
        Bill not found.
    </div>
    <% } else { %>

    <!-- Bill Receipt -->
    <div class="bill-card">

        <div class="bill-header">
            <h1>🏖 Ocean View Resort</h1>
            <p>Beachside Hotel, Galle, Sri Lanka</p>
            <div class="invoice-tag">INVOICE</div>
        </div>

        <div class="bill-meta">
            <div class="meta-item">
                <div class="label">Reservation No.</div>
                <div class="value"><%= bill.getReservationNo() %></div>
            </div>
            <div class="meta-item">
                <div class="label">Bill Generated</div>
                <div class="value">
                    <%= bill.getGeneratedAt() != null
                            ? bill.getGeneratedAt().toLocalDate().toString()
                            : "N/A" %>
                </div>
            </div>
            <div class="meta-item">
                <div class="label">Payment Status</div>
                <div class="value"><%= bill.getPaymentStatus() %></div>
            </div>
        </div>

        <div class="bill-body">

            <div class="section-title">Guest & Room Details</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="lbl">Guest Name</div>
                    <div class="val"><%= bill.getGuestName() %></div>
                </div>
                <div class="info-item">
                    <div class="lbl">Room</div>
                    <div class="val">Room <%= bill.getRoomNumber() %> (<%= bill.getRoomType() %>)</div>
                </div>
                <div class="info-item">
                    <div class="lbl">Check-In</div>
                    <div class="val"><%= res.getCheckInDate() %></div>
                </div>
                <div class="info-item">
                    <div class="lbl">Check-Out</div>
                    <div class="val"><%= res.getCheckOutDate() %></div>
                </div>
            </div>

            <div class="section-title">Charges</div>
            <table class="bill-table">
                <thead>
                <tr>
                    <th>Description</th>
                    <th>Nights</th>
                    <th>Rate (LKR)</th>
                    <th>Amount (LKR)</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>Room Charge — <%= bill.getRoomType() %></td>
                    <td><%= bill.getNumNights() %></td>
                    <td><%= String.format("%,.2f", bill.getRoomCharge() / bill.getNumNights()) %></td>
                    <td><%= String.format("%,.2f", bill.getRoomCharge()) %></td>
                </tr>
                </tbody>
            </table>

            <div class="totals">
                <div class="total-row">
                    <span>Subtotal</span>
                    <span>LKR <%= String.format("%,.2f", bill.getRoomCharge()) %></span>
                </div>
                <div class="total-row">
                    <span>Tax (10%)</span>
                    <span>LKR <%= String.format("%,.2f", bill.getTaxAmount()) %></span>
                </div>
                <div class="grand-total">
                    <span>TOTAL</span>
                    <span>LKR <%= String.format("%,.2f", bill.getTotalAmount()) %></span>
                </div>
            </div>

            <div class="payment-status <%= "PAID".equals(bill.getPaymentStatus()) ? "status-paid" : "status-pending" %>">
                <% if ("PAID".equals(bill.getPaymentStatus())) { %>
                ✅ PAID via <%= bill.getPaymentMethod() %>
                <% } else { %>
                ⏳ PAYMENT PENDING
                <% } %>
            </div>

        </div>

        <div class="bill-footer">
            Thank you for staying at Ocean View Resort! 🌊<br>
            We hope to welcome you again soon.
        </div>
    </div>

    <!-- Payment Form -->
    <% if ("PENDING".equals(bill.getPaymentStatus()) && !isPrint) { %>
    <div class="payment-card no-print">
        <h3>💳 Process Payment</h3>
        <form action="<%= request.getContextPath() %>/billing" method="post">
            <input type="hidden" name="reservationId" value="<%= bill.getReservationId() %>" />

            <p>Select payment method:</p>

            <div class="payment-methods">
                <input type="radio" class="pay-option" name="paymentMethod" id="pay_cash" value="CASH" />
                <label class="pay-label" for="pay_cash">💵 Cash</label>

                <input type="radio" class="pay-option" name="paymentMethod" id="pay_card" value="CARD" />
                <label class="pay-label" for="pay_card">💳 Card</label>

                <input type="radio" class="pay-option" name="paymentMethod" id="pay_online" value="ONLINE" />
                <label class="pay-label" for="pay_online">📱 Online</label>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-success">
                    ✅ Mark as Paid — LKR <%= String.format("%,.2f", bill.getTotalAmount()) %>
                </button>
            </div>
        </form>
    </div>
    <% } %>

    <!-- Action Buttons -->
    <% if (!isPrint) { %>
    <div class="btn-group no-print">
        <button onclick="window.print()" class="btn btn-primary">🖨 Print Bill</button>
        <a href="<%= request.getContextPath() %>/reservation?action=view&resNo=<%= bill.getReservationNo() %>"
           class="btn btn-secondary">← Back to Reservation</a>
    </div>
    <% } %>

    <% } %>
</div>

<script>
    /* Highlight payment method label on select */
    document.querySelectorAll('.pay-option').forEach(function(radio) {
        radio.addEventListener('change', function() {
            document.querySelectorAll('.pay-label').forEach(function(lbl) {
                lbl.style.transform = 'scale(1)';
            });
            if (this.checked) {
                this.nextElementSibling.style.transform = 'scale(1.04)';
                this.nextElementSibling.style.transition = '0.2s';
            }
        });
    });
</script>

</body>
</html>
