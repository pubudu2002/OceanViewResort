<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 2:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.Reservation, java.util.List" %>
<%
  List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
  String successMsg = (String) request.getAttribute("successMsg");
  String errorMsg   = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Reservations — Ocean View Resort</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Poppins', sans-serif; background: #f0f4fa; color: #333; }

    .navbar {
      background: linear-gradient(135deg, #1565C0, #0D47A1);
      padding: 14px 30px;
      display: flex; justify-content: space-between; align-items: center;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    .navbar h2 { font-size: 18px; font-weight: 600; color: white; }
    .navbar a { color: #BBDEFB; text-decoration: none; margin-left: 18px; font-size: 13px; font-weight: 500; transition: color 0.2s; }
    .navbar a:hover { color: white; }

    .container { padding: 28px 24px; animation: fadeUp 0.5s ease; }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(16px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .page-header {
      display: flex; justify-content: space-between;
      align-items: center; margin-bottom: 20px;
    }
    .page-header h2 { color: #1565C0; font-size: 20px; font-weight: 600; }

    /* Buttons */
    .btn {
      padding: 9px 18px; border-radius: 8px;
      font-size: 13px; font-weight: 600;
      font-family: 'Poppins', sans-serif;
      text-decoration: none; border: none;
      cursor: pointer; display: inline-block;
      transition: transform 0.2s, opacity 0.2s;
    }
    .btn:hover { transform: translateY(-1px); opacity: 0.92; }
    .btn:active { transform: translateY(0); }
    .btn-primary { background: linear-gradient(135deg, #1565C0, #1976D2); color: white; box-shadow: 0 3px 10px rgba(21,101,192,0.3); }
    .btn-info    { background: #0288D1; color: white; }
    .btn-danger  { background: #E53935; color: white; }
    .btn-sm      { padding: 4px 11px; font-size: 12px; }

    /* Alerts */
    .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 13px; font-weight: 500; }
    .alert-success { background: #E8F5E9; color: #2E7D32; border-left: 4px solid #43A047; }
    .alert-danger  { background: #FFEBEE; color: #C62828; border-left: 4px solid #E53935; }

    /* Table */
    .table-wrap {
      background: white; border-radius: 12px;
      box-shadow: 0 3px 12px rgba(0,0,0,0.07);
      overflow: hidden;
    }

    table { width: 100%; border-collapse: collapse; }

    th {
      background: #1565C0; color: white;
      padding: 12px 14px; font-size: 12px;
      font-weight: 600; text-align: left;
      letter-spacing: 0.4px;
    }
    td { padding: 11px 14px; font-size: 13px; border-bottom: 1px solid #f0f4fa; color: #444; }
    tr:last-child td { border-bottom: none; }
    tr:hover td { background: #F8FAFF; }

    /* Badges */
    .badge { padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
    .badge-confirmed   { background: #E3F2FD; color: #1565C0; }
    .badge-checked_in  { background: #E8F5E9; color: #2E7D32; }
    .badge-checked_out { background: #ECEFF1; color: #546E7A; }
    .badge-cancelled   { background: #FFEBEE; color: #C62828; }
  </style>
</head>
<body>

<nav class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div>
    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
  </div>
</nav>

<div class="container">
  <div class="page-header">
    <h2>📋 All Reservations</h2>
    <a href="<%= request.getContextPath() %>/reservation?action=add" class="btn btn-primary">+ New Reservation</a>
  </div>

  <% if (successMsg != null) { %><div class="alert alert-success">✅ <%= successMsg %></div><% } %>
  <% if (errorMsg   != null) { %><div class="alert alert-danger">❌ <%= errorMsg %></div><% } %>

  <div class="table-wrap">
    <table>
      <thead>
      <tr>
        <th>Res. No</th><th>Guest</th><th>Contact</th><th>Room</th>
        <th>Check-In</th><th>Check-Out</th><th>Nights</th>
        <th>Total (LKR)</th><th>Status</th><th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <% if (reservations == null || reservations.isEmpty()) { %>
      <tr><td colspan="10" style="text-align:center;color:#aaa;padding:30px;">No reservations found.</td></tr>
      <% } else { for (Reservation r : reservations) { %>
      <tr>
        <td><strong style="color:#1565C0;"><%= r.getReservationNo() %></strong></td>
        <td><%= r.getGuestName() %></td>
        <td><%= r.getContactNo() %></td>
        <td>Room <%= r.getRoomNumber() %><br><small style="color:#aaa;"><%= r.getRoomType() %></small></td>
        <td><%= r.getCheckInDate() %></td>
        <td><%= r.getCheckOutDate() %></td>
        <td><%= r.getNumNights() %></td>
        <td><%= String.format("%,.2f", r.getTotalAmount()) %></td>
        <td><span class="badge badge-<%= r.getStatus().toLowerCase() %>"><%= r.getStatus() %></span></td>
        <td>
          <a href="<%= request.getContextPath() %>/reservation?action=view&resNo=<%= r.getReservationNo() %>" class="btn btn-info btn-sm">View</a>
          &nbsp;
          <% if (!"CANCELLED".equals(r.getStatus()) && !"CHECKED_OUT".equals(r.getStatus())) { %>
          <a href="<%= request.getContextPath() %>/reservation?action=cancel&id=<%= r.getReservationId() %>"
             class="btn btn-danger btn-sm"
             onclick="return confirm('Cancel reservation <%= r.getReservationNo() %>?')">Cancel</a>
          <% } %>
        </td>
      </tr>
      <% } } %>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>
