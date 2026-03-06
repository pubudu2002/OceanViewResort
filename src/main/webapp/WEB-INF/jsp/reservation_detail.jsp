<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.Reservation" %>
<%
  Reservation r = (Reservation) request.getAttribute("reservation");
  String successMsg = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reservation Detail — Ocean View Resort</title>
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

    /* ── Page wrapper ── */
    .page-wrapper {
      width: 100%;
      padding: 32px 40px;
      animation: fadeUp 0.5s ease;
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(14px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* ── Page title row ── */
    .page-title-row {
      margin-bottom: 26px;
    }
    .page-title-row h2 {
      font-size: 22px;
      font-weight: 700;
      color: #1565C0;
    }
    .page-title-row p {
      font-size: 13px;
      color: #888;
      margin-top: 3px;
    }

    /* ── Alert ── */
    .alert-success {
      background: #E8F5E9;
      color: #2E7D32;
      padding: 13px 18px;
      border-radius: 10px;
      margin-bottom: 22px;
      border-left: 4px solid #43A047;
      font-size: 13px;
      font-weight: 500;
    }

    /* ── Section Cards ── */
    .section-card {
      background: white;
      border-radius: 14px;
      padding: 30px 36px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.07);
      margin-bottom: 22px;
      width: 100%;
    }

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 22px;
      padding-bottom: 14px;
      border-bottom: 2px solid #EEF4FF;
    }

    .card-header h3 {
      color: #1565C0;
      font-size: 16px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    /* ── Reservation hero ── */
    .res-hero {
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 16px;
    }

    .res-no-block .res-label {
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #aaa;
      margin-bottom: 4px;
      font-weight: 600;
    }

    .res-no {
      font-size: 28px;
      font-weight: 700;
      color: #1565C0;
      letter-spacing: 1px;
    }

    /* ── Status badge ── */
    .badge {
      padding: 6px 18px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 700;
      letter-spacing: 0.5px;
    }
    .badge-confirmed   { background: #E3F2FD; color: #1565C0; }
    .badge-checked_in  { background: #E8F5E9; color: #2E7D32; }
    .badge-checked_out { background: #ECEFF1; color: #546E7A; }
    .badge-cancelled   { background: #FFEBEE; color: #C62828; }

    /* ── Info grid ── */
    .info-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 22px;
    }

    .info-grid-2 {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 22px;
    }

    .info-item .lbl {
      font-size: 11px;
      font-weight: 700;
      color: #aaa;
      text-transform: uppercase;
      letter-spacing: 0.7px;
      margin-bottom: 5px;
    }
    .info-item .val {
      font-size: 15px;
      color: #222;
      font-weight: 500;
    }

    /* ── Cost summary ── */
    .cost-table { width: 100%; }

    .cost-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 11px 0;
      font-size: 14px;
      color: #555;
      border-bottom: 1px solid #f0f4fa;
    }
    .cost-row:last-child { border-bottom: none; }

    .cost-total-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16px 20px;
      background: linear-gradient(135deg, #F0F8FF, #E8F1FF);
      border-radius: 10px;
      margin-top: 14px;
      border: 1px solid #C5D8F8;
    }
    .cost-total-row .total-label {
      font-size: 16px;
      font-weight: 700;
      color: #1565C0;
    }
    .cost-total-row .total-amount {
      font-size: 26px;
      font-weight: 700;
      color: #1565C0;
    }

    /* ── Action row ── */
    .action-row {
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
      align-items: center;
    }

    .btn {
      padding: 11px 26px;
      border-radius: 9px;
      font-size: 13px;
      font-weight: 600;
      font-family: 'Poppins', sans-serif;
      text-decoration: none;
      border: none;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 7px;
      transition: transform 0.2s, opacity 0.2s, box-shadow 0.2s;
    }
    .btn:hover { transform: translateY(-2px); opacity: 0.92; }
    .btn:active { transform: translateY(0); }

    .btn-success {
      background: #43A047;
      color: white;
      box-shadow: 0 3px 12px rgba(67,160,71,0.28);
    }
    .btn-danger {
      background: #E53935;
      color: white;
      box-shadow: 0 3px 12px rgba(229,57,53,0.25);
    }
    .btn-secondary { background: #ECEFF1; color: #555; }

    /* ── Responsive ── */
    @media (max-width: 1000px) {
      .info-grid { grid-template-columns: repeat(2, 1fr); }
    }

    @media (max-width: 700px) {
      .page-wrapper { padding: 20px 16px; }
      .section-card { padding: 22px 18px; }
      .info-grid, .info-grid-2 { grid-template-columns: 1fr; }
      .res-no { font-size: 22px; }
    }
  </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div class="navbar-links">
    <a href="<%= request.getContextPath() %>/reservation?action=list">All Reservations</a>
    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
  </div>
</nav>

<!-- Page Content -->
<div class="page-wrapper">

  <% if (successMsg != null) { %>
  <div class="alert-success">✅ <%= successMsg %></div>
  <% } %>

  <% if (r == null) { %>
  <div class="section-card" style="text-align:center; color:#aaa; padding:50px;">
    Reservation not found.
  </div>
  <% } else { %>

  <!-- Page Title -->
  <div class="page-title-row">
    <h2>📋 Reservation Detail</h2>
    <p>Viewing full details for reservation <strong style="color:#1565C0;"><%= r.getReservationNo() %></strong></p>
  </div>

  <!-- ── Reservation Header ── -->
  <div class="section-card">
    <div class="res-hero">
      <div class="res-no-block">
        <div class="res-label">Reservation Number</div>
        <div class="res-no"><%= r.getReservationNo() %></div>
      </div>
      <span class="badge badge-<%= r.getStatus().toLowerCase() %>">
        <%= r.getStatus() %>
      </span>
    </div>
  </div>

  <!-- ── Guest Information ── -->
  <div class="section-card">
    <div class="card-header">
      <h3>👤 Guest Information</h3>
    </div>
    <div class="info-grid-2">
      <div class="info-item">
        <div class="lbl">Guest Name</div>
        <div class="val"><%= r.getGuestName() %></div>
      </div>
      <div class="info-item">
        <div class="lbl">Contact Number</div>
        <div class="val"><%= r.getContactNo() %></div>
      </div>
    </div>
  </div>

  <!-- ── Booking Details ── -->
  <div class="section-card">
    <div class="card-header">
      <h3>📅 Booking Details</h3>
    </div>
    <div class="info-grid">
      <div class="info-item">
        <div class="lbl">Room Number</div>
        <div class="val">Room <%= r.getRoomNumber() %></div>
      </div>
      <div class="info-item">
        <div class="lbl">Room Type</div>
        <div class="val"><%= r.getRoomType() %></div>
      </div>
      <div class="info-item">
        <div class="lbl">Check-In Date</div>
        <div class="val"><%= r.getCheckInDate() %></div>
      </div>
      <div class="info-item">
        <div class="lbl">Check-Out Date</div>
        <div class="val"><%= r.getCheckOutDate() %></div>
      </div>
      <div class="info-item">
        <div class="lbl">Number of Nights</div>
        <div class="val"><%= r.getNumNights() %> night(s)</div>
      </div>
      <div class="info-item">
        <div class="lbl">Price Per Night</div>
        <div class="val">LKR <%= String.format("%,.2f", r.getPricePerNight()) %></div>
      </div>
      <div class="info-item">
        <div class="lbl">Special Requests</div>
        <div class="val"><%= r.getSpecialRequests() != null && !r.getSpecialRequests().isEmpty() ? r.getSpecialRequests() : "None" %></div>
      </div>
    </div>
  </div>

  <!-- ── Cost Summary ── -->
  <div class="section-card">
    <div class="card-header">
      <h3>💰 Cost Summary</h3>
    </div>
    <div class="cost-table">
      <div class="cost-row">
        <span>Room Charge (<%= r.getNumNights() %> nights × LKR <%= String.format("%,.2f", r.getPricePerNight()) %>)</span>
        <span>LKR <%= String.format("%,.2f", r.getTotalAmount()) %></span>
      </div>
      <div class="cost-row">
        <span>Tax (10%)</span>
        <span>LKR <%= String.format("%,.2f", r.getTotalAmount() * 0.10) %></span>
      </div>
    </div>
    <div class="cost-total-row">
      <span class="total-label">Grand Total</span>
      <span class="total-amount">LKR <%= String.format("%,.2f", r.getTotalAmount() * 1.10) %></span>
    </div>
  </div>

  <!-- ── Actions ── -->
  <div class="section-card">
    <div class="action-row">
      <% if (!"CANCELLED".equals(r.getStatus()) && !"CHECKED_OUT".equals(r.getStatus())) { %>
      <a href="<%= request.getContextPath() %>/billing?action=generate&id=<%= r.getReservationId() %>"
         class="btn btn-success">💰 Generate Bill</a>
      <a href="<%= request.getContextPath() %>/reservation?action=cancel&id=<%= r.getReservationId() %>"
         class="btn btn-danger"
         onclick="return confirm('Are you sure you want to cancel this reservation?')">
        ❌ Cancel Reservation
      </a>
      <% } %>
      <a href="<%= request.getContextPath() %>/reservation?action=list"
         class="btn btn-secondary">← Back to List</a>
    </div>
  </div>

  <% } %>
</div>
</body>
</html>
