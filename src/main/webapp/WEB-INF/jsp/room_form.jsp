<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.Room" %>
<%
  Room room    = (Room) request.getAttribute("room");
  boolean isEdit = (room != null);
  String title   = isEdit ? "Edit Room" : "Add New Room";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= title %> — Ocean View Resort</title>
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

    .container { padding: 30px 20px; max-width: 640px; animation: fadeUp 0.5s ease; }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(16px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .card {
      background: white; border-radius: 12px;
      padding: 32px; box-shadow: 0 3px 12px rgba(0,0,0,0.07);
    }
    .card h3 {
      color: #1565C0; font-size: 18px; font-weight: 600;
      margin-bottom: 22px; padding-bottom: 12px;
      border-bottom: 2px solid #f0f4fa;
    }

    .form-group { margin-bottom: 16px; }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

    label {
      display: block; font-size: 12px; font-weight: 600;
      color: #555; margin-bottom: 5px;
      text-transform: uppercase; letter-spacing: 0.5px;
    }

    input[type="text"], input[type="number"], select, textarea {
      width: 100%; padding: 10px 13px;
      border: 1.5px solid #ddd; border-radius: 8px;
      font-size: 14px; font-family: 'Poppins', sans-serif;
      background: #fafafa; color: #333;
      outline: none; transition: border-color 0.25s, box-shadow 0.25s;
    }
    input:focus, select:focus, textarea:focus {
      border-color: #1565C0; background: white;
      box-shadow: 0 0 0 3px rgba(21,101,192,0.10);
    }

    /* Image upload */
    .image-upload-area {
      border: 2px dashed #BBDEFB; border-radius: 10px;
      padding: 24px; text-align: center;
      cursor: pointer; transition: all 0.2s;
      background: #F8FAFF; position: relative;
    }
    .image-upload-area:hover { border-color: #1565C0; background: #EEF5FF; }
    .image-upload-area.has-image { border-color: #1565C0; }
    .image-upload-area input[type="file"] {
      position: absolute; top: 0; left: 0;
      width: 100%; height: 100%; opacity: 0; cursor: pointer;
    }
    .upload-icon { font-size: 34px; margin-bottom: 8px; }
    .upload-text { font-size: 13px; color: #888; }
    .upload-hint { font-size: 11px; color: #aaa; margin-top: 4px; }

    .preview-container { margin-top: 14px; text-align: center; }
    .preview-img {
      max-width: 100%; max-height: 200px;
      border-radius: 8px; object-fit: cover;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .current-image-label { font-size: 11px; color: #aaa; margin-bottom: 6px; }

    /* Alert */
    .alert-danger {
      background: #FFEBEE; color: #C62828;
      padding: 12px 14px; border-radius: 8px;
      margin-bottom: 18px; font-size: 13px;
      border-left: 4px solid #E53935;
    }

    /* Buttons */
    .btn-group { display: flex; gap: 12px; margin-top: 22px; }
    .btn {
      padding: 10px 24px; border-radius: 8px;
      font-size: 14px; font-weight: 600;
      font-family: 'Poppins', sans-serif;
      border: none; cursor: pointer; text-decoration: none;
      display: inline-block; transition: transform 0.2s, opacity 0.2s;
    }
    .btn:hover { transform: translateY(-1px); opacity: 0.92; }
    .btn:active { transform: translateY(0); }
    .btn-primary   { background: linear-gradient(135deg, #1565C0, #1976D2); color: white; box-shadow: 0 3px 10px rgba(21,101,192,0.28); }
    .btn-secondary { background: #ECEFF1; color: #555; }
  </style>
</head>
<body>

<nav class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div>
    <a href="<%= request.getContextPath() %>/rooms">Back to Rooms</a>
    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
  </div>
</nav>

<div class="container">
  <div class="card">
    <h3><%= title %></h3>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert-danger">❌ <%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/rooms" method="post" enctype="multipart/form-data">
      <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
      <% if (isEdit) { %><input type="hidden" name="roomId" value="<%= room.getRoomId() %>" /><% } %>

      <div class="form-row">
        <div class="form-group">
          <label>Room Number *</label>
          <input type="text" name="roomNumber"
                 value="<%= isEdit ? room.getRoomNumber() : "" %>"
                 placeholder="e.g. 101" required />
        </div>
        <div class="form-group">
          <label>Room Type *</label>
          <select name="roomType" id="roomType" onchange="autoFillPrice()" required>
            <option value="">-- Select Type --</option>
            <option value="STANDARD" <%= isEdit && "STANDARD".equals(room.getRoomType()) ? "selected" : "" %>>Standard</option>
            <option value="DELUXE"   <%= isEdit && "DELUXE".equals(room.getRoomType())   ? "selected" : "" %>>Deluxe</option>
            <option value="SUITE"    <%= isEdit && "SUITE".equals(room.getRoomType())    ? "selected" : "" %>>Suite</option>
          </select>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Price Per Night (LKR) *</label>
          <input type="number" name="pricePerNight" id="pricePerNight"
                 value="<%= isEdit ? room.getPricePerNight() : "" %>"
                 placeholder="5000" step="0.01" min="1" required />
        </div>
        <div class="form-group">
          <label>Capacity (Persons) *</label>
          <input type="number" name="capacity"
                 value="<%= isEdit ? room.getCapacity() : "" %>"
                 placeholder="2" min="1" max="10" required />
        </div>
      </div>

      <div class="form-group">
        <label>Description</label>
        <textarea name="description" rows="2" placeholder="Brief description of the room..."><%= isEdit && room.getDescription() != null ? room.getDescription() : "" %></textarea>
      </div>

      <% if (isEdit) { %>
      <div class="form-group">
        <label>Status *</label>
        <select name="status" required>
          <option value="AVAILABLE"    <%= "AVAILABLE".equals(room.getStatus())    ? "selected" : "" %>>Available</option>
          <option value="MAINTENANCE"  <%= "MAINTENANCE".equals(room.getStatus())  ? "selected" : "" %>>Maintenance</option>
        </select>
      </div>
      <% } %>

      <div class="form-group">
        <label>Room Image <%= isEdit ? "(leave empty to keep current)" : "" %></label>
        <div class="image-upload-area" id="uploadArea">
          <input type="file" name="roomImage" id="roomImage"
                 accept=".jpg,.jpeg,.png" onchange="previewImage(event)" />
          <div class="upload-icon">📷</div>
          <div class="upload-text">Click to browse or drag & drop image</div>
          <div class="upload-hint">JPG, JPEG, PNG only — Max 5MB</div>
        </div>

        <% if (isEdit && room.getImagePath() != null && !room.getImagePath().isEmpty()) { %>
        <div class="preview-container" id="previewContainer">
          <div class="current-image-label">Current Image:</div>
          <img src="<%= request.getContextPath() %>/<%= room.getImagePath() %>"
               class="preview-img" id="previewImg" alt="Room Image" />
        </div>
        <% } else { %>
        <div class="preview-container" id="previewContainer" style="display:none;">
          <img src="" class="preview-img" id="previewImg" alt="Preview" />
        </div>
        <% } %>
      </div>

      <div class="btn-group">
        <button type="submit" class="btn btn-primary"><%= isEdit ? "✅ Update Room" : "✅ Add Room" %></button>
        <a href="<%= request.getContextPath() %>/rooms" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>
</div>

<script>
  function previewImage(event) {
    const file = event.target.files[0];
    if (!file) return;
    if (file.size > 5 * 1024 * 1024) {
      alert('Image too large. Maximum size is 5MB.');
      event.target.value = ''; return;
    }
    const reader = new FileReader();
    reader.onload = function(e) {
      document.getElementById('previewImg').src = e.target.result;
      document.getElementById('previewContainer').style.display = 'block';
      document.getElementById('uploadArea').classList.add('has-image');
    };
    reader.readAsDataURL(file);
  }

  function autoFillPrice() {
    const prices = { STANDARD: 5000, DELUXE: 8500, SUITE: 15000 };
    const type   = document.getElementById('roomType').value;
    const field  = document.getElementById('pricePerNight');
    if (!field.value && prices[type]) field.value = prices[type];
  }
</script>
</body>
</html>
