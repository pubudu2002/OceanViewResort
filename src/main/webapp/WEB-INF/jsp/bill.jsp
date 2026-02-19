<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 2:52 PM
  To change this template use File | Settings | File Templates.
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
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

        .navbar {
            background: #1a3a5c; color: white; padding: 14px 30px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .navbar a { color: #aed6f1; text-decoration: none; margin-left: 16px; font-size: 13px; }

        .container { padding: 30px; max-width: 680px; margin: 0 auto; }

        /* Bill receipt card */
        .bill-card {
            background: white; border-radius: 10px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            overflow: hidden; margin-bottom: 20px;
        }

        .bill-header {
            background: #1a3a5c; color: white;
            padding: 30px; text-align: center;
        }
        .bill-header h1 { font-size: 24px; margin-bottom: 4px; }
        .bill-header p  { font-size: 13px; color: #aed6f1; }

        .bill-meta {
            display: flex; justify-content: space-between;
            padding: 20px 30px; background: #f8fafc;
            border-bottom: 1px solid #eee; font-size: 13px;
        }
        .bill-meta .label { color: #999; font-size: 11px;
            text-transform: uppercase; margin-bottom: 3px; }
        .bill-meta .value { font-weight: 600; color: #333; }

        .bill-body { padding: 30px; }

        .section-title {
            font-size: 12px; text-transform: uppercase;
            color: #999; font-weight: 700;
            margin-bottom: 14px; margin-top: 20px;
        }

        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 14px;
            margin-bottom: 20px;
        }
        .info-item .lbl { font-size: 11px; color: #aaa; margin-bottom: 2px; }
        .info-item .val { font-size: 14px; color: #333; font-weight: 500; }

        .bill-table {
            width: 100%; border-collapse: collapse; margin-bottom: 10px;
        }
        .bill-table th {
            background: #f0f4f8; padding: 10px 14px;
            font-size: 12px; text-align: left; color: #555;
        }
        .bill-table td { padding: 10px 14px; font-size: 14px; border-bottom: 1px solid #f5f5f5; }

        .totals { margin-top: 16px; }
        .total-row {
            display: flex; justify-content: space-between;
            padding: 7px 0; font-size: 14px; color: #555;
            border-bottom: 1px solid #f5f5f5;
        }
        .grand-total {
            display: flex; justify-content: space-between;
            padding: 14px 0 0; font-size: 20px;
            font-weight: 700; color: #1a3a5c;
            border-top: 2px solid #1a3a5c; margin-top: 8px;
        }

        .payment-status {
            text-align: center; padding: 14px;
            margin: 20px 0 0; border-radius: 8px;
            font-size: 15px; font-weight: 600;
        }
        .status-paid    { background: #d4edda; color: #155724; }
        .status-pending { background: #fff3cd; color: #856404; }

        .bill-footer {
            text-align: center; padding: 20px;
            border-top: 1px solid #eee;
            font-size: 12px; color: #aaa;
        }

        /* Payment form */
        .payment-card {
            background: white; border-radius: 10px;
            padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            margin-bottom: 20px;
        }
        .payment-card h3 { color: #1a3a5c; margin-bottom: 18px; }

        .payment-methods {
            display: flex; gap: 12px; margin-bottom: 18px;
        }
        .pay-option { display: none; }
        .pay-label {
            border: 2px solid #ddd; border-radius: 8px;
            padding: 12px 20px; cursor: pointer;
            font-size: 14px; font-weight: 600; color: #555;
            transition: all 0.2s;
        }
        .pay-option:checked + .pay-label {
            border-color: #0d6e8a; background: #e8f4f8; color: #0d6e8a;
        }

        .btn {
            padding: 10px 22px; border-radius: 7px;
            font-size: 14px; font-weight: 600;
            border: none; cursor: pointer;
            text-decoration: none; display: inline-block;
        }
        .btn-success   { background: #28a745; color: white; }
        .btn-primary   { background: #1a3a5c; color: white; }
        .btn-secondary { background: #eee; color: #333; }
        .btn-group { display: flex; gap: 12px; flex-wrap: wrap; }

        .alert-success {
            background: #d4edda; color: #155724;
            padding: 12px 16px; border-radius: 8px;
            margin-bottom: 16px; border-left: 4px solid #28a745;
        }
        .alert-danger {
            background: #f8d7da; color: #721c24;
            padding: 12px 16px; border-radius: 8px;
            margin-bottom: 16px; border-left: 4px solid #dc3545;
        }

        @media print {
            .navbar, .payment-card, .btn-group, .no-print { display: none !important; }
            body { background: white; }
            .container { padding: 0; max-width: 100%; }
            .bill-card { box-shadow: none; border: 1px solid #ddd; }
        }
    </style>
</head>
<body>

<% if (!isPrint) { %>
<div class="navbar">
    <h2>🏖 Ocean View Resort</h2>
    <div>
        <a href="<%= request.getContextPath() %>/reservation?action=list">Reservations</a>
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
    </div>
</div>
<% } %>

<div class="container">

    <% if (successMsg != null) { %>
    <div class="alert-success">✅ <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
    <div class="alert-danger">❌ <%= errorMsg %></div>
    <% } %>

    <% if (bill == null || res == null) { %>
    <div style="background:white;padding:30px;border-radius:10px;text-align:center;color:#999;">
        Bill not found.
    </div>
    <% } else { %>

    <!-- Bill Receipt -->
    <div class="bill-card">

        <div class="bill-header">
            <h1>🏖 Ocean View Resort</h1>
            <p>Beachside Hotel, Galle, Sri Lanka</p>
            <p style="margin-top:8px;font-size:16px;font-weight:600;">INVOICE</p>
        </div>

        <div class="bill-meta">
            <div>
                <div class="label">Reservation No.</div>
                <div class="value"><%= bill.getReservationNo() %></div>
            </div>
            <div>
                <div class="label">Bill Generated</div>
                <div class="value">
                    <%= bill.getGeneratedAt() != null
                            ? bill.getGeneratedAt().toLocalDate().toString()
                            : "N/A" %>
                </div>
            </div>
            <div>
                <div class="label">Payment Status</div>
                <div class="value"><%= bill.getPaymentStatus() %></div>
            </div>
        </div>

        <div class="bill-body">

            <!-- Guest & Room Info -->
            <div class="section-title">Guest & Room Details</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="lbl">Guest Name</div>
                    <div class="val"><%= bill.getGuestName() %></div>
                </div>
                <div class="info-item">
                    <div class="lbl">Room</div>
                    <div class="val">Room <%= bill.getRoomNumber() %>
                        (<%= bill.getRoomType() %>)</div>
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

            <!-- Charges Table -->
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
                    <td><%= String.format("%,.2f",
                            bill.getRoomCharge() / bill.getNumNights()) %></td>
                    <td><%= String.format("%,.2f", bill.getRoomCharge()) %></td>
                </tr>
                </tbody>
            </table>

            <!-- Totals -->
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

            <!-- Payment Status Badge -->
            <div class="payment-status
                <%= "PAID".equals(bill.getPaymentStatus())
                    ? "status-paid" : "status-pending" %>">
                <% if ("PAID".equals(bill.getPaymentStatus())) { %>
                ✅ PAID via <%= bill.getPaymentMethod() %>
                <% } else { %>
                ⏳ PAYMENT PENDING
                <% } %>
            </div>

        </div>

        <div class="bill-footer">
            Thank you for staying at Ocean View Resort!<br>
            We hope to welcome you again soon. 🌊
        </div>
    </div>

    <!-- Payment Form (only if pending and not print mode) -->
    <% if ("PENDING".equals(bill.getPaymentStatus()) && !isPrint) { %>
    <div class="payment-card no-print">
        <h3>💳 Process Payment</h3>
        <form action="<%= request.getContextPath() %>/billing" method="post">
            <input type="hidden" name="reservationId"
                   value="<%= bill.getReservationId() %>" />

            <p style="font-size:13px;color:#666;margin-bottom:14px;">
                Select payment method:
            </p>

            <div class="payment-methods">
                <input type="radio" class="pay-option"
                       name="paymentMethod" id="pay_cash" value="CASH" />
                <label class="pay-label" for="pay_cash">💵 Cash</label>

                <input type="radio" class="pay-option"
                       name="paymentMethod" id="pay_card" value="CARD" />
                <label class="pay-label" for="pay_card">💳 Card</label>

                <input type="radio" class="pay-option"
                       name="paymentMethod" id="pay_online" value="ONLINE" />
                <label class="pay-label" for="pay_online">📱 Online</label>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-success">
                    ✅ Mark as Paid —
                    LKR <%= String.format("%,.2f", bill.getTotalAmount()) %>
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
</body>
</html>
