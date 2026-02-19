<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 2:03 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.Room" %>
<%
  Room room     = (Room) request.getAttribute("room");
  boolean isEdit = (room != null);
  String action  = isEdit ? "edit" : "add";
  String title   = isEdit ? "Edit Room" : "Add New Room";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= title %> — Ocean View Resort</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

    .navbar {
      background: #1a3a5c; color: white;
      padding: 14px 30px;
      display: flex; justify-content: space-between; align-items: center;
    }
    .navbar a { color: #aed6f1; text-decoration: none; margin-left: 16px; font-size: 13px; }

    .container { padding: 30px; max-width: 600px; }

    .card {
      background: white; border-radius: 10px;
      padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.07);
    }
    .card h3 { color: #1a3a5c; margin-bottom: 24px; font-size: 18px; }

    .form-group { margin-bottom: 18px; }
    label {
      display: block; font-size: 13px;
      font-weight: 600; color: #444; margin-bottom: 6px;
    }
    input[type="text"], input[type="number"],
    select, textarea {
      width: 100%; padding: 9px 13px;
      border: 1.5px solid #ddd; border-radius: 7px;
      font-size: 14px; font-family: inherit;
    }
    input:focus, select:focus, textarea:focus {
      outline: none; border-color: #0d6e8a;
    }
    textarea { resize: vertical; min-height: 80px; }

    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

    .btn-group { display: flex; gap: 12px; margin-top: 24px; }
    .btn {
      padding: 10px 24px; border-radius: 7px;
      font-size: 14px; font-weight: 600;
      border: none; cursor: pointer; text-decoration: none;
    }
    .btn-primary { background: #1a3a5c; color: white; }
    .btn-primary:hover { background: #0d6e8a; }
    .btn-secondary { background: #eee; color: #333; }

    .alert-danger {
      background: #f8d7da; color: #721c24;
      padding: 10px 14px; border-radius: 7px;
      margin-bottom: 18px; font-size: 13px;
      border-left: 4px solid #dc3545;
    }
  </style>
</head>
<body>

<div class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div>
    <a href="<%= request.getContextPath() %>/rooms">Back to Rooms</a>
    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
  </div>
</div>

<div class="container">
  <div class="card">
    <h3><%= title %></h3>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert-danger">❌ <%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/rooms" method="post">
      <input type="hidden" name="action" value="<%= action %>" />
      <% if (isEdit) { %>
      <input type="hidden" name="roomId" value="<%= room.getRoomId() %>" />
      <% } %>

      <div class="form-row">
        <div class="form-group">
          <label for="roomNumber">Room Number *</label>
          <input type="text" id="roomNumber" name="roomNumber"
                 value="<%= isEdit ? room.getRoomNumber() : "" %>"
                 placeholder="e.g. 101" required />
        </div>

        <div class="form-group">
          <label for="roomType">Room Type *</label>
          <select id="roomType" name="roomType" required>
            <option value="">-- Select Type --</option>
            <option value="STANDARD"
                    <%= isEdit && "STANDARD".equals(room.getRoomType()) ? "selected" : "" %>>
              Standard (LKR 5,000/night)
            </option>
            <option value="DELUXE"
                    <%= isEdit && "DELUXE".equals(room.getRoomType()) ? "selected" : "" %>>
              Deluxe (LKR 8,500/night)
            </option>
            <option value="SUITE"
                    <%= isEdit && "SUITE".equals(room.getRoomType()) ? "selected" : "" %>>
              Suite (LKR 15,000/night)
            </option>
          </select>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="pricePerNight">Price Per Night (LKR) *</label>
          <input type="number" id="pricePerNight" name="pricePerNight"
                 value="<%= isEdit ? room.getPricePerNight() : "" %>"
                 placeholder="5000.00" step="0.01" min="1" required />
        </div>

        <div class="form-group">
          <label for="capacity">Capacity (Persons) *</label>
          <input type="number" id="capacity" name="capacity"
                 value="<%= isEdit ? room.getCapacity() : "" %>"
                 placeholder="2" min="1" max="10" required />
        </div>
      </div>

      <div class="form-group">
        <label for="description">Description</label>
        <textarea id="description" name="description"
                  placeholder="Brief description of the room..."><%= isEdit && room.getDescription() != null ? room.getDescription() : "" %></textarea>
      </div>

      <% if (isEdit) { %>
      <div class="form-group">
        <label for="status">Status *</label>
        <select id="status" name="status" required>
          <option value="AVAILABLE"
                  <%= "AVAILABLE".equals(room.getStatus()) ? "selected" : "" %>>Available</option>
          <option value="OCCUPIED"
                  <%= "OCCUPIED".equals(room.getStatus()) ? "selected" : "" %>>Occupied</option>
          <option value="MAINTENANCE"
                  <%= "MAINTENANCE".equals(room.getStatus()) ? "selected" : "" %>>Maintenance</option>
        </select>
      </div>
      <% } %>

      <div class="btn-group">
        <button type="submit" class="btn btn-primary">
          <%= isEdit ? "Update Room" : "Add Room" %>
        </button>
        <a href="<%= request.getContextPath() %>/rooms" class="btn btn-secondary">Cancel</a>
      </div>

    </form>
  </div>
</div>

<script>
  // Auto-fill price when room type is selected
  document.getElementById('roomType').addEventListener('change', function() {
    const prices = { 'STANDARD': 5000, 'DELUXE': 8500, 'SUITE': 15000 };
    const priceField = document.getElementById('pricePerNight');
    if (!priceField.value && prices[this.value]) {
      priceField.value = prices[this.value];
    }
  });
</script>

</body>
</html>
