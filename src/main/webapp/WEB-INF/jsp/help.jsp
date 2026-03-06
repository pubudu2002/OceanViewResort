<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    String topic = (String) request.getAttribute("topic");
    if (topic == null) topic = "overview";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help — Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Poppins', sans-serif;
            background: #f0f4fa;
            color: #333;
            min-height: 100vh;
        }

        /* ── Navbar ── */
        .navbar {
            background: linear-gradient(135deg, #1565C0, #0D47A1);
            padding: 14px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.18);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar h2 { font-size: 18px; font-weight: 600; color: white; }
        .navbar-links a {
            color: #BBDEFB;
            text-decoration: none;
            margin-left: 24px;
            font-size: 13px;
            font-weight: 500;
            transition: color 0.2s;
        }
        .navbar-links a:hover { color: white; }

        /* ── Full page layout ── */
        .page-layout {
            display: grid;
            grid-template-columns: 260px 1fr;
            min-height: calc(100vh - 52px);
            animation: fadeUp 0.5s ease;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Sidebar ── */
        .sidebar {
            background: white;
            border-right: 1px solid #E3EDFF;
            padding: 28px 18px;
            position: sticky;
            top: 52px;
            height: calc(100vh - 52px);
            overflow-y: auto;
        }

        .sidebar-title {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: #aaa;
            font-weight: 700;
            margin-bottom: 16px;
            padding: 0 10px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            border-radius: 9px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            color: #555;
            margin-bottom: 4px;
            transition: background 0.15s, color 0.15s;
        }
        .sidebar a:hover { background: #EEF4FF; color: #1565C0; }
        .sidebar a.active {
            background: #1565C0;
            color: white;
            font-weight: 600;
        }
        .sidebar a .icon { font-size: 16px; }

        /* ── Content area ── */
        .content-area {
            padding: 36px 48px;
            overflow-y: auto;
        }

        .content-header {
            margin-bottom: 28px;
            padding-bottom: 16px;
            border-bottom: 2px solid #EEF4FF;
        }
        .content-header h2 {
            font-size: 22px;
            font-weight: 700;
            color: #1565C0;
            margin-bottom: 5px;
        }
        .content-header p { font-size: 13px; color: #888; }

        /* ── Overview cards ── */
        .help-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }

        .help-card {
            border: 2px solid #E3EDFF;
            border-radius: 12px;
            padding: 24px 16px;
            text-decoration: none;
            color: #333;
            text-align: center;
            transition: border-color 0.2s, transform 0.2s, box-shadow 0.2s;
            background: white;
        }
        .help-card:hover {
            border-color: #1565C0;
            background: #F0F8FF;
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(21,101,192,0.12);
        }
        .help-card .hc-icon { font-size: 32px; margin-bottom: 10px; }
        .help-card h4 { font-size: 13px; color: #1565C0; font-weight: 600; }

        /* ── Step sections ── */
        .step-section { margin-bottom: 30px; }

        .step-section h3 {
            color: #1565C0;
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .step-number {
            background: #1565C0;
            color: white;
            width: 26px; height: 26px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .steps { list-style: none; }
        .steps li {
            padding: 11px 16px;
            margin-bottom: 8px;
            background: #F8FAFF;
            border-radius: 9px;
            font-size: 13px;
            color: #444;
            border-left: 3px solid #1565C0;
            line-height: 1.6;
        }
        .steps li strong { color: #1565C0; }

        /* ── Info / Warn boxes ── */
        .info-box {
            background: #E3F2FD;
            border-radius: 10px;
            padding: 16px 20px;
            margin: 20px 0;
            border-left: 4px solid #1565C0;
            font-size: 13px;
            color: #0D47A1;
            line-height: 1.6;
        }
        .info-box strong { display: block; margin-bottom: 5px; font-size: 14px; }

        .warn-box {
            background: #FFF8E1;
            border-radius: 10px;
            padding: 16px 20px;
            margin: 20px 0;
            border-left: 4px solid #FFA000;
            font-size: 13px;
            color: #7a5800;
            line-height: 1.6;
        }

        /* ── Rates table ── */
        .rates-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin: 14px 0;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .rates-table th {
            background: #1565C0;
            color: white;
            padding: 12px 16px;
            text-align: left;
            font-weight: 600;
        }
        .rates-table td {
            padding: 11px 16px;
            border-bottom: 1px solid #f0f4fa;
            color: #444;
            background: white;
        }
        .rates-table tr:last-child td { border-bottom: none; }
        .rates-table tr:hover td { background: #F8FAFF; }

        /* ── Exit box ── */
        .exit-box {
            background: white;
            border: 2px solid #E3EDFF;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            margin-top: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        }
        .exit-box h3 { color: #1565C0; font-size: 18px; margin-bottom: 10px; }
        .exit-box p  { color: #777; font-size: 13px; margin-bottom: 22px; line-height: 1.6; }

        .btn-logout {
            background: linear-gradient(135deg, #1565C0, #1976D2);
            color: white;
            padding: 12px 32px;
            border-radius: 9px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
            transition: transform 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 14px rgba(21,101,192,0.3);
        }
        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(21,101,192,0.4);
        }

        /* ── Contact box ── */
        .contact-box {
            background: #F8FAFF;
            border-radius: 10px;
            padding: 20px 24px;
            margin-top: 20px;
            border: 1px solid #E3EDFF;
        }
        .contact-box h4 { color: #1565C0; margin-bottom: 10px; font-size: 14px; font-weight: 600; }
        .contact-box p  { color: #555; margin-bottom: 6px; font-size: 13px; }

        /* ── Responsive ── */
        @media (max-width: 900px) {
            .page-layout { grid-template-columns: 1fr; }
            .sidebar {
                position: static;
                height: auto;
                border-right: none;
                border-bottom: 1px solid #E3EDFF;
                padding: 16px;
                display: flex;
                flex-wrap: wrap;
                gap: 6px;
            }
            .sidebar-title { width: 100%; }
            .content-area { padding: 24px 20px; }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <h2>🏖 Ocean View Resort</h2>
    <div class="navbar-links">
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</nav>

<!-- Full-page layout -->
<div class="page-layout">

    <!-- ── Sidebar ── -->
    <div class="sidebar">
        <div class="sidebar-title">Help Topics</div>

        <a href="<%= request.getContextPath() %>/help?topic=overview"
           class="<%= "overview".equals(topic) ? "active" : "" %>">
            <span class="icon">🏠</span> Overview
        </a>
        <a href="<%= request.getContextPath() %>/help?topic=login"
           class="<%= "login".equals(topic) ? "active" : "" %>">
            <span class="icon">🔐</span> Login & Security
        </a>
        <a href="<%= request.getContextPath() %>/help?topic=reservation"
           class="<%= "reservation".equals(topic) ? "active" : "" %>">
            <span class="icon">📋</span> Reservations
        </a>
        <a href="<%= request.getContextPath() %>/help?topic=rooms"
           class="<%= "rooms".equals(topic) ? "active" : "" %>">
            <span class="icon">🛏</span> Room Management
        </a>
        <a href="<%= request.getContextPath() %>/help?topic=billing"
           class="<%= "billing".equals(topic) ? "active" : "" %>">
            <span class="icon">💰</span> Billing & Payment
        </a>
        <a href="<%= request.getContextPath() %>/help?topic=exit"
           class="<%= "exit".equals(topic) ? "active" : "" %>">
            <span class="icon">🚪</span> Exit System
        </a>
    </div>

    <!-- ── Content ── -->
    <div class="content-area">

        <%-- OVERVIEW --%>
        <% if ("overview".equals(topic)) { %>
        <div class="content-header">
            <h2>❓ Help & User Guide</h2>
            <p>Welcome to the Ocean View Resort Reservation System. Select a topic from the left to get started.</p>
        </div>

        <div class="help-grid">
            <a href="<%= request.getContextPath() %>/help?topic=login" class="help-card">
                <div class="hc-icon">🔐</div><h4>Login & Security</h4>
            </a>
            <a href="<%= request.getContextPath() %>/help?topic=reservation" class="help-card">
                <div class="hc-icon">📋</div><h4>Reservations</h4>
            </a>
            <a href="<%= request.getContextPath() %>/help?topic=rooms" class="help-card">
                <div class="hc-icon">🛏</div><h4>Room Management</h4>
            </a>
            <a href="<%= request.getContextPath() %>/help?topic=billing" class="help-card">
                <div class="hc-icon">💰</div><h4>Billing & Payment</h4>
            </a>
            <a href="<%= request.getContextPath() %>/help?topic=exit" class="help-card">
                <div class="hc-icon">🚪</div><h4>Exit System</h4>
            </a>
        </div>

        <div class="info-box">
            <strong>📌 Quick Tips for New Staff</strong>
            Always log out after your shift. Never share your password.
            Check room availability before taking a reservation over the phone.
            Generate the bill before the guest checks out.
        </div>

        <%-- LOGIN --%>
        <% } else if ("login".equals(topic)) { %>
        <div class="content-header">
            <h2>🔐 Login & Security</h2>
            <p>How to access and secure your account.</p>
        </div>

        <div class="step-section">
            <h3><span class="step-number">1</span> How to Log In</h3>
            <ul class="steps">
                <li>Open the system in your browser and go to the <strong>Login page</strong>.</li>
                <li>Enter your <strong>Username</strong> and <strong>Password</strong> provided by your administrator.</li>
                <li>Click <strong>Sign In</strong> to access the dashboard.</li>
                <li>If your credentials are wrong, an error message will appear — check for typos and try again.</li>
            </ul>
        </div>

        <div class="step-section">
            <h3><span class="step-number">2</span> User Roles</h3>
            <ul class="steps">
                <li><strong>ADMIN</strong> — Full access including user management, room configuration, all reservations and reports.</li>
                <li><strong>STAFF</strong> — Can create and view reservations, generate bills, and manage room status.</li>
            </ul>
        </div>

        <div class="warn-box">
            ⚠ <strong>Security Reminder:</strong> Never share your password with anyone. The system will automatically log you out after 30 minutes of inactivity.
        </div>

        <%-- RESERVATION --%>
        <% } else if ("reservation".equals(topic)) { %>
        <div class="content-header">
            <h2>📋 Managing Reservations</h2>
            <p>How to create, view and cancel reservations.</p>
        </div>

        <div class="step-section">
            <h3><span class="step-number">1</span> Create a New Reservation</h3>
            <ul class="steps">
                <li>Click <strong>New Reservation</strong> from the Dashboard or Reservations page.</li>
                <li>Fill in the <strong>Guest Information</strong> — name, NIC, address, contact number and email.</li>
                <li>Enter <strong>Check-In</strong> and <strong>Check-Out</strong> dates. The cost will calculate automatically.</li>
                <li>Select an available room from the room grid.</li>
                <li>Add any <strong>Special Requests</strong> if needed (e.g. early check-in, honeymoon setup).</li>
                <li>Click <strong>Confirm Reservation</strong> — a unique Reservation Number will be assigned automatically.</li>
            </ul>
        </div>

        <div class="step-section">
            <h3><span class="step-number">2</span> View a Reservation</h3>
            <ul class="steps">
                <li>Go to <strong>View Reservations</strong> from the Dashboard.</li>
                <li>Find the reservation in the table and click <strong>View</strong>.</li>
                <li>The detail page shows all guest info, room details, dates and cost summary.</li>
            </ul>
        </div>

        <div class="step-section">
            <h3><span class="step-number">3</span> Cancel a Reservation</h3>
            <ul class="steps">
                <li>Open the reservation detail page.</li>
                <li>Click <strong>Cancel Reservation</strong>.</li>
                <li>Confirm the cancellation in the popup dialog.</li>
                <li>The room will automatically become <strong>Available</strong> again.</li>
            </ul>
        </div>

        <div class="info-box">
            <strong>💡 Reservation Number Format</strong>
            Reservation numbers follow the format <strong>RES-YYYY-NNNN</strong> (e.g. RES-2025-0001). Use this number when guests call to enquire about their booking.
        </div>

        <%-- ROOMS --%>
        <% } else if ("rooms".equals(topic)) { %>
        <div class="content-header">
            <h2>🛏 Room Management</h2>
            <p>How to manage room inventory and status.</p>
        </div>

        <div class="step-section">
            <h3><span class="step-number">1</span> Room Types & Rates</h3>
            <table class="rates-table">
                <thead>
                <tr><th>Room Type</th><th>Rate Per Night</th><th>Capacity</th><th>Description</th></tr>
                </thead>
                <tbody>
                <tr><td><strong>Standard</strong></td><td>LKR 5,000</td><td>2 persons</td><td>Garden view, comfortable stay</td></tr>
                <tr><td><strong>Deluxe</strong></td><td>LKR 8,500</td><td>2–3 persons</td><td>Ocean view with balcony</td></tr>
                <tr><td><strong>Suite</strong></td><td>LKR 15,000</td><td>4 persons</td><td>Luxury with private facilities</td></tr>
                </tbody>
            </table>
        </div>

        <div class="step-section">
            <h3><span class="step-number">2</span> Room Status Guide</h3>
            <ul class="steps">
                <li><strong>AVAILABLE</strong> — Room is ready and can be booked for new reservations.</li>
                <li><strong>OCCUPIED</strong> — Room has an active reservation. It becomes available automatically when cancelled or checked out.</li>
                <li><strong>MAINTENANCE</strong> — Room is temporarily out of service. Set this manually when the room needs repairs or cleaning.</li>
            </ul>
        </div>

        <div class="step-section">
            <h3><span class="step-number">3</span> Add or Edit a Room</h3>
            <ul class="steps">
                <li>Go to <strong>Rooms</strong> from the Dashboard.</li>
                <li>Click <strong>+ Add New Room</strong> to add a room, or <strong>Edit</strong> next to an existing room.</li>
                <li>Fill in Room Number, Type, Price and Capacity.</li>
                <li>Click <strong>Add Room</strong> or <strong>Update Room</strong> to save.</li>
            </ul>
        </div>

        <div class="warn-box">
            ⚠ <strong>Note:</strong> You cannot delete a room that currently has <strong>OCCUPIED</strong> status. Cancel the active reservation first.
        </div>

        <%-- BILLING --%>
        <% } else if ("billing".equals(topic)) { %>
        <div class="content-header">
            <h2>💰 Billing & Payment</h2>
            <p>How to generate bills and process payments.</p>
        </div>

        <div class="step-section">
            <h3><span class="step-number">1</span> Generate a Bill</h3>
            <ul class="steps">
                <li>Open the <strong>Reservation Detail</strong> page for the guest who is checking out.</li>
                <li>Click <strong>Generate Bill</strong>.</li>
                <li>The system calculates the total automatically: <strong>Room Charge + 10% Tax</strong>.</li>
                <li>The bill is displayed as a printable invoice.</li>
            </ul>
        </div>

        <div class="step-section">
            <h3><span class="step-number">2</span> Process Payment</h3>
            <ul class="steps">
                <li>On the Bill page, select the <strong>Payment Method</strong>: Cash, Card, or Online.</li>
                <li>Click <strong>Mark as Paid</strong>.</li>
                <li>The reservation status changes to <strong>CHECKED OUT</strong> automatically.</li>
                <li>The room becomes <strong>Available</strong> for new bookings.</li>
            </ul>
        </div>

        <div class="step-section">
            <h3><span class="step-number">3</span> Print the Bill</h3>
            <ul class="steps">
                <li>Click <strong>🖨 Print Bill</strong> on the bill page.</li>
                <li>Your browser's print dialog will open.</li>
                <li>The printed version hides all navigation buttons automatically — only the invoice is printed.</li>
            </ul>
        </div>

        <div class="info-box">
            <strong>💡 Billing Formula</strong>
            Room Charge = Number of Nights × Price Per Night. Tax = Room Charge × 10%. Grand Total = Room Charge + Tax.
        </div>

        <%-- EXIT --%>
        <% } else if ("exit".equals(topic)) { %>
        <div class="content-header">
            <h2>🚪 Exit System</h2>
            <p>How to safely close your session.</p>
        </div>

        <div class="step-section">
            <h3><span class="step-number">1</span> Why Logging Out Matters</h3>
            <ul class="steps">
                <li>Always log out at the end of your shift to <strong>protect guest data</strong>.</li>
                <li>Leaving the system open allows others to make changes under your account.</li>
                <li>The system will auto-logout after <strong>30 minutes</strong> of inactivity, but manual logout is always safer.</li>
            </ul>
        </div>

        <div class="step-section">
            <h3><span class="step-number">2</span> How to Log Out</h3>
            <ul class="steps">
                <li>Click the <strong>Logout</strong> link in the top-right corner of any page.</li>
                <li>You will be redirected to the Login page immediately.</li>
                <li>Your session data is completely cleared — no one can go back using the browser Back button.</li>
            </ul>
        </div>

        <div class="exit-box">
            <h3>Ready to finish your session?</h3>
            <p>
                Make sure all reservations are saved before logging out.<br>
                Logged in as: <strong><%= loggedInUser != null ? loggedInUser.getFullName() : "User" %></strong>
            </p>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">🚪 Logout Now</a>
        </div>

        <div class="contact-box">
            <h4>📞 Need Support?</h4>
            <p>📧 Email: priyanga@icbtcampus.edu.lk</p>
            <p>🏨 Ocean View Resort — Galle, Sri Lanka</p>
        </div>

        <% } %>
    </div><!-- /content-area -->
</div><!-- /page-layout -->

</body>
</html>
