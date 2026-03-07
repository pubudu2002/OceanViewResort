<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 3:14 PM
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.User" %>
<%
  User   editUser = (User) request.getAttribute("editUser");
  boolean isEdit  = (editUser != null);
  String title    = isEdit ? "Edit User" : "Add New User";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

    .container { padding: 30px 20px; max-width: 540px; margin: 0 auto; animation: fadeUp 0.5s ease; }

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

    label {
      display: block; font-size: 12px; font-weight: 600;
      color: #555; margin-bottom: 5px;
      text-transform: uppercase; letter-spacing: 0.5px;
    }
    .hint { font-size: 11px; color: #aaa; font-weight: 400; margin-left: 5px; text-transform: none; letter-spacing: 0; }

    input[type="text"], input[type="password"], select {
      width: 100%; padding: 10px 13px;
      border: 1.5px solid #ddd; border-radius: 8px;
      font-size: 14px; font-family: 'Poppins', sans-serif;
      background: #fafafa; color: #333;
      outline: none; transition: border-color 0.25s, box-shadow 0.25s;
    }
    input:focus, select:focus {
      border-color: #1565C0; background: white;
      box-shadow: 0 0 0 3px rgba(21,101,192,0.10);
    }

    /* Alert */
    .alert-danger {
      background: #FFEBEE; color: #C62828;
      padding: 12px 14px; border-radius: 8px;
      margin-bottom: 18px; font-size: 13px;
      border-left: 4px solid #E53935;
    }

    /* Role grid */
    .role-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
    .role-option { display: none; }
    .role-label {
      border: 2px solid #E3F2FD; border-radius: 10px;
      padding: 14px; text-align: center; cursor: pointer;
      transition: border-color 0.2s, background 0.2s;
      height: 100%; display: block;
    }
    .role-label:hover { border-color: #1565C0; background: #F0F8FF; }
    .role-label .role-icon { font-size: 24px; margin-bottom: 6px; }
    .role-label .role-name { font-size: 14px; font-weight: 600; color: #444; }
    .role-label .role-desc { font-size: 11px; color: #888; margin-top: 2px; }
    .role-option:checked + .role-label {
      border-color: #1565C0; background: #E3F2FD;
    }
    .role-option:checked + .role-label .role-name { color: #1565C0; }

    /* Buttons */
    .btn-group { display: flex; gap: 12px; margin-top: 22px; }
    .btn {
      padding: 10px 24px; border-radius: 8px;
      font-size: 14px; font-weight: 600;
      font-family: 'Poppins', sans-serif;
      border: none; cursor: pointer; text-decoration: none;
      display: inline-block; transition: transform 0.2s, opacity 0.2s;
      text-align: center;
    }
    .btn:hover { transform: translateY(-1px); opacity: 0.92; }
    .btn-primary   { background: linear-gradient(135deg, #1565C0, #1976D2); color: white; box-shadow: 0 3px 10px rgba(21,101,192,0.28); }
    .btn-secondary { background: #ECEFF1; color: #555; }

    /* --- RESPONSIVE MEDIA QUERIES --- */
    @media (max-width: 600px) {
      .navbar {
        flex-direction: column;
        padding: 15px;
        text-align: center;
      }
      .navbar h2 { margin-bottom: 10px; }
      .navbar div { display: flex; gap: 10px; }
      .navbar a { margin-left: 0; font-size: 12px; }

      .container {
        padding: 15px;
        max-width: 100%;
      }

      .card {
        padding: 20px;
      }

      .role-grid {
        grid-template-columns: 1fr; /* Stack roles vertically on mobile */
      }

      .btn-group {
        flex-direction: column; /* Stack buttons vertically */
      }

      .btn {
        width: 100%;
      }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div>
    <a href="<%= request.getContextPath() %>/users">Back to Users</a>
    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
  </div>
</nav>

<div class="container">
  <div class="card">
    <h3><%= title %></h3>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert-danger">❌ <%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/users" method="post" onsubmit="return validateForm()">
      <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
      <% if (isEdit) { %><input type="hidden" name="userId" value="<%= editUser.getUserId() %>" /><% } %>

      <div class="form-group">
        <label for="fullName">Full Name *</label>
        <input type="text" id="fullName" name="fullName"
               value="<%= isEdit ? editUser.getFullName() : "" %>"
               placeholder="e.g. Kamal Perera" required />
      </div>

      <div class="form-group">
        <label for="username">Username *</label>
        <input type="text" id="username" name="username"
               value="<%= isEdit ? editUser.getUsername() : "" %>"
               placeholder="e.g. kamal123" required />
      </div>

      <div class="form-group">
        <label for="password">
          Password *
          <% if (isEdit) { %><span class="hint">(leave blank to keep current)</span><% } %>
        </label>
        <input type="password" id="password" name="password"
               placeholder="<%= isEdit ? "Leave blank to keep current" : "Enter password" %>"
                <%= isEdit ? "" : "required" %> />
      </div>

      <div class="form-group">
        <label>Role *</label>
        <div class="role-grid">
          <div>
            <input type="radio" class="role-option" name="role" id="role_staff" value="STAFF"
                    <%= isEdit && "STAFF".equals(editUser.getRole()) ? "checked" : (!isEdit ? "checked" : "") %> />
            <label class="role-label" for="role_staff">
              <div class="role-icon">👷</div>
              <div class="role-name">Staff</div>
              <div class="role-desc">Reservations & Billing</div>
            </label>
          </div>
          <div>
            <input type="radio" class="role-option" name="role" id="role_admin" value="ADMIN"
                    <%= isEdit && "ADMIN".equals(editUser.getRole()) ? "checked" : "" %> />
            <label class="role-label" for="role_admin">
              <div class="role-icon">🔑</div>
              <div class="role-name">Admin</div>
              <div class="role-desc">Full system access</div>
            </label>
          </div>
        </div>
      </div>

      <div class="btn-group">
        <button type="submit" class="btn btn-primary"><%= isEdit ? "✅ Update User" : "✅ Add User" %></button>
        <a href="<%= request.getContextPath() %>/users" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>
</div>

<script>
  function validateForm() {
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value;
    const isEdit   = <%= isEdit %>;
    if (username.length < 3) { alert('Username must be at least 3 characters.'); return false; }
    if (!isEdit && password.length < 4) { alert('Password must be at least 4 characters.'); return false; }
    return true;
  }
</script>
</body>
</html>