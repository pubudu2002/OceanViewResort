<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 2:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.Room, java.util.List" %>
<%
  List<Room> rooms = (List<Room>) request.getAttribute("availableRooms");
  String errMsg    = (String) request.getAttribute("errorMessage");
  Object selRoom   = request.getAttribute("selectedRoomId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>New Reservation — Ocean View Resort</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

    .navbar {
      background: #1a3a5c; color: white;
      padding: 14px 30px;
      display: flex; justify-content: space-between; align-items: center;
    }
    .navbar a { color: #aed6f1; text-decoration: none; margin-left: 16px; font-size: 13px; }

    .container { padding: 30px; max-width: 750px; }

    .card {
      background: white; border-radius: 10px;
      padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.07);
      margin-bottom: 20px;
    }
    .card h3 {
      color: #1a3a5c; font-size: 16px;
      margin-bottom: 20px; padding-bottom: 10px;
      border-bottom: 2px solid #f0f4f8;
    }

    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .form-group { margin-bottom: 16px; }

    label {
      display: block; font-size: 13px;
      font-weight: 600; color: #444; margin-bottom: 5px;
    }
    input, select, textarea {
      width: 100%; padding: 9px 13px;
      border: 1.5px solid #ddd; border-radius: 7px;
      font-size: 14px; font-family: inherit;
    }
    input:focus, select:focus, textarea:focus {
      outline: none; border-color: #0d6e8a;
    }

    .room-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
      gap: 12px; margin-top: 6px;
    }
    .room-option { display: none; }
    .room-label {
      border: 2px solid #ddd; border-radius: 8px;
      padding: 14px 12px; cursor: pointer;
      text-align: center; transition: all 0.2s;
    }
    .room-option:checked + .room-label {
      border-color: #0d6e8a;
      background: #e8f4f8;
    }
    .room-label:hover { border-color: #aaa; }
    .room-label .rnum  { font-size: 18px; font-weight: 700; color: #1a3a5c; }
    .room-label .rtype { font-size: 11px; color: #666; margin: 4px 0; }
    .room-label .rprice { font-size: 13px; font-weight: 600; color: #0d6e8a; }

    .cost-box {
      background: #f0f8ff; border-radius: 8px;
      padding: 16px; border: 1px solid #bee3f8;
      font-size: 14px; color: #1a3a5c;
    }
    .cost-box .total {
      font-size: 20px; font-weight: 700;
      color: #0d6e8a; margin-top: 8px;
    }

    .btn-group { display: flex; gap: 12px; margin-top: 10px; }
    .btn {
      padding: 11px 28px; border-radius: 7px;
      font-size: 14px; font-weight: 600;
      border: none; cursor: pointer; text-decoration: none;
    }
    .btn-primary   { background: #1a3a5c; color: white; }
    .btn-secondary { background: #eee; color: #333; }

    .alert-danger {
      background: #f8d7da; color: #721c24;
      padding: 12px 16px; border-radius: 8px;
      margin-bottom: 18px; border-left: 4px solid #dc3545;
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

  <% if (errMsg != null) { %>
  <div class="alert-danger">❌ <%= errMsg %></div>
  <% } %>

  <form action="<%= request.getContextPath() %>/reservation" method="post"
        onsubmit="return validateForm()">

    <!-- Guest Details -->
    <div class="card">
      <h3>👤 Guest Information</h3>
      <div class="form-row">
        <div class="form-group">
          <label>Full Name *</label>
          <input type="text" name="guestName" required
                 value="<%= request.getAttribute("guestName") != null ? request.getAttribute("guestName") : "" %>"
                 placeholder="e.g. John Fernando" />
        </div>
        <div class="form-group">
          <label>NIC Number</label>
          <input type="text" name="nic"
                 value="<%= request.getAttribute("nic") != null ? request.getAttribute("nic") : "" %>"
                 placeholder="e.g. 199012345678" />
        </div>
      </div>
      <div class="form-group">
        <label>Address *</label>
        <input type="text" name="address" required
               value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>"
               placeholder="e.g. 12 Galle Road, Colombo" />
      </div>
      <div class="form-row">
        <div class="form-group">
          <label>Contact Number * (10 digits)</label>
          <input type="text" name="contactNo" required
                 maxlength="10"
                 value="<%= request.getAttribute("contactNo") != null ? request.getAttribute("contactNo") : "" %>"
                 placeholder="e.g. 0771234567" />
        </div>
        <div class="form-group">
          <label>Email</label>
          <input type="email" name="email"
                 value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                 placeholder="e.g. john@email.com" />
        </div>
      </div>
    </div>

    <!-- Booking Details -->
    <div class="card">
      <h3>📅 Booking Details</h3>
      <div class="form-row">
        <div class="form-group">
          <label>Check-In Date *</label>
          <input type="date" name="checkInDate" id="checkInDate" required
                 value="<%= request.getAttribute("checkInDate") != null ? request.getAttribute("checkInDate") : "" %>"
                 onchange="calculateCost()" />
        </div>
        <div class="form-group">
          <label>Check-Out Date *</label>
          <input type="date" name="checkOutDate" id="checkOutDate" required
                 value="<%= request.getAttribute("checkOutDate") != null ? request.getAttribute("checkOutDate") : "" %>"
                 onchange="calculateCost()" />
        </div>
      </div>
      <div class="form-group">
        <label>Special Requests</label>
        <textarea name="specialRequests" rows="2"
                  placeholder="e.g. Early check-in, sea view preferred..."><%= request.getAttribute("specialRequests") != null ? request.getAttribute("specialRequests") : "" %></textarea>
      </div>
    </div>

    <!-- Room Selection -->
    <div class="card">
      <h3>🛏 Select Room *</h3>
      <div class="room-grid">
        <% if (rooms == null || rooms.isEmpty()) { %>
        <p style="color:#999;">No rooms available at the moment.</p>
        <% } else { for (Room r : rooms) {
          boolean selected = selRoom != null &&
                  Integer.parseInt(selRoom.toString()) == r.getRoomId();
        %>
        <div>
          <input type="radio" class="room-option"
                 name="roomId" id="room_<%= r.getRoomId() %>"
                 value="<%= r.getRoomId() %>"
                 data-price="<%= r.getPricePerNight() %>"
                  <%= selected ? "checked" : "" %>
                 onchange="calculateCost()" required />
          <label class="room-label" for="room_<%= r.getRoomId() %>">
            <div class="rnum">Room <%= r.getRoomNumber() %></div>
            <div class="rtype"><%= r.getRoomType() %></div>
            <div class="rprice">LKR <%= String.format("%,.0f", r.getPricePerNight()) %>/night</div>
            <div style="font-size:11px;color:#888;">👥 <%= r.getCapacity() %> person(s)</div>
          </label>
        </div>
        <% } } %>
      </div>
    </div>

    <!-- Cost Summary -->
    <div class="card">
      <h3>💰 Cost Summary</h3>
      <div class="cost-box">
        <div id="costDetails" style="color:#666;">
          Select a room and dates to see the cost.
        </div>
        <div class="total" id="totalDisplay"></div>
      </div>
    </div>

    <div class="btn-group">
      <button type="submit" class="btn btn-primary">✅ Confirm Reservation</button>
      <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">Cancel</a>
    </div>

  </form>
</div>

<script>
  // Set minimum date to today
  const today = new Date().toISOString().split('T')[0];
  document.getElementById('checkInDate').min  = today;
  document.getElementById('checkOutDate').min = today;

  function calculateCost() {
    const checkIn  = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    const roomRadio = document.querySelector('input[name="roomId"]:checked');

    if (!checkIn || !checkOut || !roomRadio) return;

    const inDate  = new Date(checkIn);
    const outDate = new Date(checkOut);
    const nights  = Math.round((outDate - inDate) / (1000 * 60 * 60 * 24));

    if (nights <= 0) {
      document.getElementById('costDetails').textContent =
              '⚠ Check-out must be after check-in.';
      document.getElementById('totalDisplay').textContent = '';
      return;
    }

    const price = parseFloat(roomRadio.dataset.price);
    const total = nights * price;

    document.getElementById('costDetails').innerHTML =
            nights + ' night(s) × LKR ' +
            price.toLocaleString() + '/night';
    document.getElementById('totalDisplay').textContent =
            'Total: LKR ' + total.toLocaleString();
  }

  function validateForm() {
    const contactNo = document.querySelector('input[name="contactNo"]').value;
    if (!/^\d{10}$/.test(contactNo)) {
      alert('Contact number must be exactly 10 digits.');
      return false;
    }
    const checkIn  = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    if (new Date(checkOut) <= new Date(checkIn)) {
      alert('Check-out date must be after check-in date.');
      return false;
    }
    const room = document.querySelector('input[name="roomId"]:checked');
    if (!room) {
      alert('Please select a room.');
      return false;
    }
    return true;
  }
</script>
</body>
</html>