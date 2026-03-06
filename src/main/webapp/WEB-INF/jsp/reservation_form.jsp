<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.Room, java.util.List" %>
<%
  List<Room> rooms = (List<Room>) request.getAttribute("availableRooms");
  String bookedDatesJson = (String) request.getAttribute("bookedDatesJson");
  if (bookedDatesJson == null) bookedDatesJson = "{}";
  String errMsg  = (String) request.getAttribute("errorMessage");
  Object selRoom = request.getAttribute("selectedRoomId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>New Reservation — Ocean View Resort</title>
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

    /* Page title row */
    .page-title-row {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 28px;
    }
    .page-title-row h2 {
      font-size: 22px;
      font-weight: 700;
      color: #1565C0;
    }
    .page-title-row p {
      font-size: 13px;
      color: #888;
      margin-top: 2px;
    }

    /* ── Alert ── */
    .alert-danger {
      background: #FFEBEE;
      color: #C62828;
      padding: 13px 18px;
      border-radius: 10px;
      margin-bottom: 22px;
      border-left: 4px solid #E53935;
      font-size: 13px;
      font-weight: 500;
    }

    /* ── Section Card ── */
    .section-card {
      background: white;
      border-radius: 14px;
      padding: 30px 36px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.07);
      margin-bottom: 24px;
      width: 100%;
    }

    .section-card h3 {
      color: #1565C0;
      font-size: 16px;
      font-weight: 600;
      margin-bottom: 22px;
      padding-bottom: 12px;
      border-bottom: 2px solid #EEF4FF;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    /* ── Form layout ── */
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }

    .form-row-3 {
      display: grid;
      grid-template-columns: 1fr 1fr 1fr;
      gap: 20px;
    }

    .form-group { margin-bottom: 18px; }
    .form-group:last-child { margin-bottom: 0; }

    label {
      display: block;
      font-size: 12px;
      font-weight: 600;
      color: #555;
      margin-bottom: 7px;
      text-transform: uppercase;
      letter-spacing: 0.6px;
    }

    input[type="text"],
    input[type="email"],
    input[type="date"],
    select,
    textarea {
      width: 100%;
      padding: 11px 15px;
      border: 1.5px solid #dde4f0;
      border-radius: 9px;
      font-size: 14px;
      font-family: 'Poppins', sans-serif;
      color: #333;
      background: #FAFBFF;
      outline: none;
      transition: border-color 0.25s, box-shadow 0.25s, background 0.25s;
    }

    input:focus, select:focus, textarea:focus {
      border-color: #1565C0;
      background: white;
      box-shadow: 0 0 0 4px rgba(21,101,192,0.09);
    }

    input::placeholder, textarea::placeholder { color: #bbb; }

    textarea { resize: vertical; min-height: 80px; }

    /* ── Room Grid ── */
    .legend {
      font-size: 12px;
      color: #777;
      margin-bottom: 18px;
      padding: 11px 16px;
      background: #F0F6FF;
      border-radius: 8px;
      border-left: 3px solid #1565C0;
    }

    .room-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
      gap: 18px;
    }

    .room-radio { display: none; }

    .room-select-card {
      border: 2px solid #E3EDFF;
      border-radius: 12px;
      overflow: hidden;
      cursor: pointer;
      transition: border-color 0.2s, box-shadow 0.2s, transform 0.2s;
      position: relative;
      background: white;
    }
    .room-select-card:hover {
      border-color: #1565C0;
      box-shadow: 0 4px 16px rgba(21,101,192,0.14);
      transform: translateY(-2px);
    }
    .room-radio:checked + .room-select-card {
      border-color: #1565C0;
      box-shadow: 0 4px 18px rgba(21,101,192,0.22);
    }
    .room-select-card.conflicted {
      opacity: 0.42;
      cursor: not-allowed;
      filter: grayscale(50%);
      transform: none !important;
    }

    .select-tick {
      display: none;
      position: absolute; top: 9px; left: 9px;
      background: #1565C0; color: white;
      width: 24px; height: 24px;
      border-radius: 50%;
      font-size: 12px; font-weight: 700;
      align-items: center; justify-content: center;
      z-index: 2;
      box-shadow: 0 2px 6px rgba(21,101,192,0.4);
    }
    .room-radio:checked + .room-select-card .select-tick { display: flex; }

    .select-img-wrap {
      width: 100%; height: 145px;
      overflow: hidden; background: #E3F2FD;
    }
    .select-img-wrap img {
      width: 100%; height: 100%;
      object-fit: cover; transition: transform 0.3s;
    }
    .room-select-card:hover .select-img-wrap img { transform: scale(1.06); }

    .no-img-placeholder {
      width: 100%; height: 100%;
      display: flex; align-items: center;
      justify-content: center; font-size: 36px; color: #90CAF9;
    }

    .select-body { padding: 14px; }

    .select-header {
      display: flex; justify-content: space-between;
      align-items: center; margin-bottom: 5px;
    }
    .select-room-no { font-size: 16px; font-weight: 700; color: #1565C0; }

    .select-type {
      font-size: 10px; font-weight: 700;
      padding: 3px 10px; border-radius: 20px;
    }
    .type-standard { background: #E3F2FD; color: #1565C0; }
    .type-deluxe   { background: #EDE7F6; color: #512DA8; }
    .type-suite    { background: #FFF3E0; color: #E65100; }

    .select-price { font-size: 14px; font-weight: 700; color: #1565C0; margin-bottom: 3px; }
    .select-cap   { font-size: 11px; color: #999; margin-bottom: 8px; }
    .select-divider { border: none; border-top: 1px solid #f0f0f0; margin: 6px 0; }

    .booked-label  { font-size: 10px; text-transform: uppercase; font-weight: 700; color: #bbb; margin-bottom: 3px; }
    .booked-range  { display: inline-block; background: #FFEBEE; color: #C62828; font-size: 10px; font-weight: 600; padding: 2px 6px; border-radius: 4px; margin: 1px 2px 1px 0; }
    .free-label    { font-size: 11px; color: #43A047; font-weight: 600; }

    .conflict-tag {
      display: none; margin-top: 7px;
      background: #FFF8E1; color: #F57F17;
      font-size: 10px; font-weight: 700;
      padding: 5px 8px; border-radius: 6px; text-align: center;
    }

    /* ── Cost box ── */
    .cost-box {
      background: linear-gradient(135deg, #F0F8FF, #E8F1FF);
      border-radius: 10px;
      padding: 20px 24px;
      border: 1px solid #C5D8F8;
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 12px;
    }
    .cost-breakdown { font-size: 14px; color: #555; }
    .cost-breakdown strong { color: #1565C0; }
    .cost-total { font-size: 24px; font-weight: 700; color: #1565C0; }

    /* ── Action row ── */
    .action-row {
      display: flex;
      gap: 14px;
      align-items: center;
      padding: 24px 0 8px;
    }

    .btn {
      padding: 12px 30px;
      border-radius: 9px;
      font-size: 14px;
      font-weight: 600;
      font-family: 'Poppins', sans-serif;
      border: none;
      cursor: pointer;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: transform 0.2s, opacity 0.2s, box-shadow 0.2s;
    }
    .btn:hover { transform: translateY(-2px); opacity: 0.93; }
    .btn:active { transform: translateY(0); }

    .btn-primary {
      background: linear-gradient(135deg, #1565C0, #1E88E5);
      color: white;
      box-shadow: 0 4px 16px rgba(21,101,192,0.32);
    }
    .btn-primary:hover { box-shadow: 0 6px 20px rgba(21,101,192,0.42); }
    .btn-secondary { background: #ECEFF1; color: #555; }

    /* ── Responsive ── */
    @media (max-width: 900px) {
      .page-wrapper { padding: 24px 20px; }
      .section-card { padding: 22px 20px; }
      .form-row, .form-row-3 { grid-template-columns: 1fr; }
    }

    @media (max-width: 600px) {
      .navbar { padding: 12px 16px; }
      .room-grid { grid-template-columns: 1fr; }
      .cost-box { flex-direction: column; align-items: flex-start; }
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

  <!-- Page Title -->
  <div class="page-title-row">
    <div>
      <h2>📋 New Reservation</h2>
      <p>Fill in the details below to create a new guest reservation</p>
    </div>
  </div>

  <% if (errMsg != null) { %>
  <div class="alert-danger">❌ <%= errMsg %></div>
  <% } %>

  <form action="<%= request.getContextPath() %>/reservation" method="post" onsubmit="return validateForm()">

    <!-- ── Guest Information ── -->
    <div class="section-card">
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
          <input type="text" name="contactNo" required maxlength="10"
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

    <!-- ── Booking Dates ── -->
    <div class="section-card">
      <h3>📅 Booking Dates</h3>

      <div class="form-row">
        <div class="form-group">
          <label>Check-In Date *</label>
          <input type="date" name="checkInDate" id="checkInDate" required
                 value="<%= request.getAttribute("checkInDate") != null ? request.getAttribute("checkInDate") : "" %>"
                 onchange="onDateChange()" />
        </div>
        <div class="form-group">
          <label>Check-Out Date *</label>
          <input type="date" name="checkOutDate" id="checkOutDate" required
                 value="<%= request.getAttribute("checkOutDate") != null ? request.getAttribute("checkOutDate") : "" %>"
                 onchange="onDateChange()" />
        </div>
      </div>

      <div class="form-group">
        <label>Special Requests</label>
        <textarea name="specialRequests" rows="3"
                  placeholder="e.g. Early check-in, sea view preferred, honeymoon setup..."><%= request.getAttribute("specialRequests") != null ? request.getAttribute("specialRequests") : "" %></textarea>
      </div>
    </div>

    <!-- ── Room Selection ── -->
    <div class="section-card">
      <h3>🛏 Select a Room *</h3>

      <div class="legend">
        🔴 Red dates = Already booked &nbsp;|&nbsp;
        ✅ Green = Fully available &nbsp;|&nbsp;
        Greyed out card = Conflicts with your selected dates
      </div>

      <div class="room-grid">
        <% if (rooms == null || rooms.isEmpty()) { %>
        <p style="color:#aaa;font-size:13px;">No rooms available.</p>
        <% } else { for (Room r : rooms) {
          boolean selected = selRoom != null && Integer.parseInt(selRoom.toString()) == r.getRoomId();
        %>
        <div>
          <input type="radio" class="room-radio" name="roomId"
                 id="room_<%= r.getRoomId() %>"
                 value="<%= r.getRoomId() %>"
                 data-price="<%= r.getPricePerNight() %>"
                 data-roomid="<%= r.getRoomId() %>"
                  <%= selected ? "checked" : "" %>
                 onchange="calculateCost()" />

          <label class="room-select-card" id="card_<%= r.getRoomId() %>" for="room_<%= r.getRoomId() %>">
            <div class="select-tick">✓</div>
            <div class="select-img-wrap">
              <% if (r.getImagePath() != null && !r.getImagePath().isEmpty()) { %>
              <img src="<%= request.getContextPath() %>/<%= r.getImagePath() %>" alt="Room <%= r.getRoomNumber() %>" />
              <% } else { %>
              <div class="no-img-placeholder">🛏</div>
              <% } %>
            </div>
            <div class="select-body">
              <div class="select-header">
                <div class="select-room-no">Room <%= r.getRoomNumber() %></div>
                <span class="select-type type-<%= r.getRoomType().toLowerCase() %>"><%= r.getRoomType() %></span>
              </div>
              <div class="select-price">LKR <%= String.format("%,.0f", r.getPricePerNight()) %>/night</div>
              <div class="select-cap">👥 Up to <%= r.getCapacity() %> person(s)</div>
              <hr class="select-divider" />
              <div id="bookedInfo_<%= r.getRoomId() %>">
                <span class="free-label">✅ No upcoming bookings</span>
              </div>
              <div class="conflict-tag" id="conflictTag_<%= r.getRoomId() %>">⚠ Conflicts with your dates</div>
            </div>
          </label>
        </div>
        <% } } %>
      </div>
    </div>

    <!-- ── Cost Summary ── -->
    <div class="section-card">
      <h3>💰 Cost Summary</h3>
      <div class="cost-box">
        <div class="cost-breakdown" id="costDetails">Select a room and dates to see the total cost.</div>
        <div class="cost-total" id="totalDisplay"></div>
      </div>
    </div>

    <!-- ── Action Buttons ── -->
    <div class="action-row">
      <button type="submit" class="btn btn-primary">✅ Confirm Reservation</button>
      <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">✕ Cancel</a>
    </div>

  </form>
</div>

<script>
  const bookedDatesMap = <%= bookedDatesJson %>;

  const today = new Date().toISOString().split('T')[0];
  document.getElementById('checkInDate').min  = today;
  document.getElementById('checkOutDate').min = today;

  function onDateChange() {
    const checkIn  = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    if (checkIn) document.getElementById('checkOutDate').min = checkIn;
    refreshRoomCards(checkIn, checkOut);
    calculateCost();
  }

  function refreshRoomCards(checkIn, checkOut) {
    document.querySelectorAll('input.room-radio').forEach(function(radio) {
      const roomId     = radio.dataset.roomid;
      const bookings   = bookedDatesMap[roomId] || [];
      const infoDiv    = document.getElementById('bookedInfo_'  + roomId);
      const conflictEl = document.getElementById('conflictTag_' + roomId);
      const card       = document.getElementById('card_'        + roomId);

      if (bookings.length === 0) {
        infoDiv.innerHTML = '<span class="free-label">✅ No upcoming bookings</span>';
      } else {
        let html = '<div class="booked-label">Booked periods:</div>';
        bookings.forEach(function(b) {
          html += '<span class="booked-range">' + fmtDate(b[0]) + ' → ' + fmtDate(b[1]) + '</span>';
        });
        infoDiv.innerHTML = html;
      }

      let conflict = false;
      if (checkIn && checkOut) {
        conflict = bookings.some(function(b) { return checkIn < b[1] && checkOut > b[0]; });
      }

      if (conflict) {
        card.classList.add('conflicted');
        conflictEl.style.display = 'block';
        radio.disabled = true;
        if (radio.checked) { radio.checked = false; clearCost(); }
      } else {
        card.classList.remove('conflicted');
        conflictEl.style.display = 'none';
        radio.disabled = false;
      }
    });
  }

  function calculateCost() {
    const checkIn  = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    const selected = document.querySelector('input.room-radio:checked');
    if (!checkIn || !checkOut || !selected) { clearCost(); return; }

    const nights = Math.round((new Date(checkOut) - new Date(checkIn)) / (1000*60*60*24));
    if (nights <= 0) {
      document.getElementById('costDetails').textContent = '⚠ Check-out must be after check-in.';
      document.getElementById('totalDisplay').textContent = '';
      return;
    }

    const price = parseFloat(selected.dataset.price);
    const total = nights * price;
    document.getElementById('costDetails').innerHTML =
            '<strong>' + nights + '</strong> night(s) &times; LKR ' + price.toLocaleString('en-LK') + ' /night';
    document.getElementById('totalDisplay').textContent = 'LKR ' + total.toLocaleString('en-LK');
  }

  function clearCost() {
    document.getElementById('costDetails').textContent = 'Select a room and dates to see the total cost.';
    document.getElementById('totalDisplay').textContent = '';
  }

  function fmtDate(dateStr) {
    const d = new Date(dateStr + 'T00:00:00');
    return d.toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric' });
  }

  function validateForm() {
    const contact = document.querySelector('input[name="contactNo"]').value;
    if (!/^\d{10}$/.test(contact)) { alert('Contact number must be exactly 10 digits.'); return false; }
    const checkIn  = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    if (!checkIn || !checkOut) { alert('Please select check-in and check-out dates.'); return false; }
    if (new Date(checkOut) <= new Date(checkIn)) { alert('Check-out date must be after check-in date.'); return false; }
    if (!document.querySelector('input.room-radio:checked')) { alert('Please select an available room.'); return false; }
    return true;
  }

  window.addEventListener('load', function() {
    const checkIn  = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    refreshRoomCards(checkIn, checkOut);
    calculateCost();
  });
</script>
</body>
</html>
