<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 2:51 PM
  To change this template use File | Settings | File Templates.
--%>
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
  <title>Reservation Detail — Ocean View Resort</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

    .navbar {
      background: #1a3a5c; color: white; padding: 14px 30px;
      display: flex; justify-content: space-between; align-items: center;
    }
    .navbar a { color: #aed6f1; text-decoration: none; margin-left: 16px; font-size: 13px; }

    .container { padding: 30px; max-width: 750px; }

    .page-title { color: #1a3a5c; margin-bottom: 20px; font-size: 22px; }

    .card {
      background: white; border-radius: 10px;
      padding: 28px; box-shadow: 0 2px 8px rgba(0,0,0,0.07);
      margin-bottom: 20px;
    }
    .card-header {
      display: flex; justify-content: space-between;
      align-items: center; margin-bottom: 20px;
      padding-bottom: 12px; border-bottom: 2px solid #f0f4f8;
    }
    .card-header h3 { color: #1a3a5c; font-size: 16px; }

    .res-no {
      font-size: 20px; font-weight: 700;
      color: #0d6e8a; letter-spacing: 1px;
    }

    .detail-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
    }
    .detail-item label {
      display: block; font-size: 11px;
      font-weight: 700; color: #999;
      text-transform: uppercase; margin-bottom: 4px;
    }
    .detail-item span {
      font-size: 14px; color: #333; font-weight: 500;
    }

    .badge { padding: 4px 14px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .badge-confirmed   { background: #cce5ff; color: #004085; }
    .badge-checked_in  { background: #d4edda; color: #155724; }
    .badge-checked_out { background: #e2e3e5; color: #383d41; }
    .badge-cancelled   { background: #f8d7da; color: #721c24; }

    .cost-summary {
      background: #f8fafc; border-radius: 8px;
      padding: 20px; margin-top: 16px;
    }
    .cost-row {
      display: flex; justify-content: space-between;
      padding: 6px 0; font-size: 14px; color: #555;
      border-bottom: 1px solid #eee;
    }
    .cost-row:last-child { border-bottom: none; }
    .cost-total {
      display: flex; justify-content: space-between;
      padding: 12px 0 0; font-size: 18px;
      font-weight: 700; color: #1a3a5c;
    }

    .btn-group { display: flex; gap: 12px; flex-wrap: wrap; }
    .btn {
      padding: 10px 20px; border-radius: 7px;
      font-size: 13px; font-weight: 600;
      text-decoration: none; border: none;
      cursor: pointer; display: inline-block;
    }
    .btn-success  { background: #28a745; color: white; }
    .btn-warning  { background: #f39c12; color: white; }
    .btn-danger   { background: #e74c3c; color: white; }
    .btn-secondary { background: #eee; color: #333; }

    .alert-success {
      background: #d4edda; color: #155724;
      padding: 12px 16px; border-radius: 8px;
      margin-bottom: 18px; border-left: 4px solid #28a745;
    }
  </style>
</head>
<body>

<div class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div>
    <a href="<%= request.getContextPath() %>/reservation?action=list">All Reservations</a>
    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
  </div>
</div>

<div class="container">

  <% if (successMsg != null) { %>
  <div class="alert-success">✅ <%= successMsg %></div>
  <% } %>

  <% if (r == null) { %>
  <div class="card">
    <p style="color:#999;text-align:center;padding:20px;">
      Reservation not found.
    </p>
  </div>
  <% } else { %>

  <!-- Header -->
  <div class="card">
    <div class="card-header">
      <div>
        <div style="font-size:12px;color:#999;margin-bottom:4px;">
          RESERVATION NUMBER
        </div>
        <div class="res-no"><%= r.getReservationNo() %></div>
      </div>
      <span class="badge badge-<%= r.getStatus().toLowerCase() %>">
                <%= r.getStatus() %>
            </span>
    </div>

    <!-- Guest Details -->
    <h4 style="color:#666;font-size:12px;text-transform:uppercase;
                   margin-bottom:14px;">Guest Information</h4>
    <div class="detail-grid">
      <div class="detail-item">
        <label>Guest Name</label>
        <span><%= r.getGuestName() %></span>
      </div>
      <div class="detail-item">
        <label>Contact Number</label>
        <span><%= r.getContactNo() %></span>
      </div>
    </div>
  </div>

  <!-- Booking Details -->
  <div class="card">
    <div class="card-header">
      <h3>📅 Booking Details</h3>
    </div>
    <div class="detail-grid">
      <div class="detail-item">
        <label>Room Number</label>
        <span>Room <%= r.getRoomNumber() %> (<%= r.getRoomType() %>)</span>
      </div>
      <div class="detail-item">
        <label>Number of Nights</label>
        <span><%= r.getNumNights() %> night(s)</span>
      </div>
      <div class="detail-item">
        <label>Check-In Date</label>
        <span><%= r.getCheckInDate() %></span>
      </div>
      <div class="detail-item">
        <label>Check-Out Date</label>
        <span><%= r.getCheckOutDate() %></span>
      </div>
      <div class="detail-item">
        <label>Price Per Night</label>
        <span>LKR <%= String.format("%,.2f", r.getPricePerNight()) %></span>
      </div>
      <div class="detail-item">
        <label>Special Requests</label>
        <span><%= r.getSpecialRequests() != null
                ? r.getSpecialRequests() : "None" %></span>
      </div>
    </div>

    <!-- Cost Summary -->
    <div class="cost-summary">
      <div class="cost-row">
                <span>Room Charge
                    (<%= r.getNumNights() %> nights ×
                    LKR <%= String.format("%,.2f", r.getPricePerNight()) %>)
                </span>
        <span>LKR <%= String.format("%,.2f", r.getTotalAmount()) %></span>
      </div>
      <div class="cost-row">
        <span>Tax (10%)</span>
        <span>LKR <%= String.format("%,.2f", r.getTotalAmount() * 0.10) %></span>
      </div>
      <div class="cost-total">
        <span>Grand Total</span>
        <span>LKR <%= String.format("%,.2f", r.getTotalAmount() * 1.10) %></span>
      </div>
    </div>
  </div>

  <!-- Actions -->
  <div class="card">
    <div class="btn-group">
      <% if (!"CANCELLED".equals(r.getStatus()) &&
              !"CHECKED_OUT".equals(r.getStatus())) { %>

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