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
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }
    .navbar {
      background: #1a3a5c; color: white; padding: 14px 30px;
      display: flex; justify-content: space-between; align-items: center;
    }
    .navbar a { color: #aed6f1; text-decoration: none; margin-left: 16px; font-size: 13px; }
    .container { padding: 30px; }
    .page-header {
      display: flex; justify-content: space-between;
      align-items: center; margin-bottom: 20px;
    }
    .page-header h2 { color: #1a3a5c; }
    .btn {
      padding: 9px 18px; border-radius: 7px; font-size: 13px;
      font-weight: 600; text-decoration: none; border: none; cursor: pointer;
    }
    .btn-primary  { background: #1a3a5c; color: white; }
    .btn-info     { background: #17a2b8; color: white; }
    .btn-danger   { background: #e74c3c; color: white; }
    .btn-sm       { padding: 4px 10px; font-size: 12px; }
    .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; }
    .alert-success { background:#d4edda; color:#155724; border-left:4px solid #28a745; }
    .alert-danger  { background:#f8d7da; color:#721c24; border-left:4px solid #dc3545; }
    table {
      width: 100%; background: white; border-radius: 10px;
      border-collapse: collapse; box-shadow: 0 2px 8px rgba(0,0,0,0.07);
    }
    th { background: #1a3a5c; color: white; padding: 12px 14px; font-size: 13px; text-align: left; }
    td { padding: 10px 14px; font-size: 13px; border-bottom: 1px solid #f0f0f0; }
    tr:hover td { background: #f8fafc; }
    .badge { padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
    .badge-confirmed   { background: #cce5ff; color: #004085; }
    .badge-checked_in  { background: #d4edda; color: #155724; }
    .badge-checked_out { background: #e2e3e5; color: #383d41; }
    .badge-cancelled   { background: #f8d7da; color: #721c24; }
  </style>
</head>
<body>

<div class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div>
    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
  </div>
</div>

<div class="container">
  <div class="page-header">
    <h2>📋 All Reservations</h2>
    <a href="<%= request.getContextPath() %>/reservation?action=add" class="btn btn-primary">
      + New Reservation
    </a>
  </div>

  <% if (successMsg != null) { %>
  <div class="alert alert-success">✅ <%= successMsg %></div>
  <% } %>
  <% if (errorMsg != null) { %>
  <div class="alert alert-danger">❌ <%= errorMsg %></div>
  <% } %>

  <table>
    <thead>
    <tr>
      <th>Res. No</th>
      <th>Guest</th>
      <th>Contact</th>
      <th>Room</th>
      <th>Check-In</th>
      <th>Check-Out</th>
      <th>Nights</th>
      <th>Total (LKR)</th>
      <th>Status</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <% if (reservations == null || reservations.isEmpty()) { %>
    <tr>
      <td colspan="10" style="text-align:center;color:#999;padding:30px;">
        No reservations found.
      </td>
    </tr>
    <% } else { for (Reservation r : reservations) { %>
    <tr>
      <td><strong><%= r.getReservationNo() %></strong></td>
      <td><%= r.getGuestName() %></td>
      <td><%= r.getContactNo() %></td>
      <td>Room <%= r.getRoomNumber() %><br>
        <small style="color:#888;"><%= r.getRoomType() %></small>
      </td>
      <td><%= r.getCheckInDate() %></td>
      <td><%= r.getCheckOutDate() %></td>
      <td><%= r.getNumNights() %></td>
      <td><%= String.format("%,.2f", r.getTotalAmount()) %></td>
      <td>
                    <span class="badge badge-<%= r.getStatus().toLowerCase() %>">
                        <%= r.getStatus() %>
                    </span>
      </td>
      <td>
        <a href="<%= request.getContextPath() %>/reservation?action=view&resNo=<%= r.getReservationNo() %>"
           class="btn btn-info btn-sm">View</a>
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
</body>
</html>
