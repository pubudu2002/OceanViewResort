<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 3:14 PM
  To change this template use File | Settings | File Templates.
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
  <title><%= title %> — Ocean View Resort</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

    .navbar {
      background: #1a3a5c; color: white; padding: 14px 30px;
      display: flex; justify-content: space-between; align-items: center;
    }
    .navbar h2 { font-size: 18px; }
    .navbar a  {
      color: #aed6f1; text-decoration: none;
      margin-left: 16px; font-size: 13px;
    }

    .container { padding: 30px; max-width: 520px; }

    .card {
      background: white; border-radius: 10px;
      padding: 32px; box-shadow: 0 2px 8px rgba(0,0,0,0.07);
    }
    .card h3 {
      color: #1a3a5c; font-size: 18px;
      margin-bottom: 24px; padding-bottom: 12px;
      border-bottom: 2px solid #f0f4f8;
    }

    .form-group { margin-bottom: 18px; }
    label {
      display: block; font-size: 13px;
      font-weight: 600; color: #444; margin-bottom: 6px;
    }
    .hint {
      font-size: 11px; color: #999;
      font-weight: 400; margin-left: 6px;
    }
    input[type="text"],
    input[type="password"],
    select {
      width: 100%; padding: 10px 13px;
      border: 1.5px solid #ddd; border-radius: 7px;
      font-size: 14px; font-family: inherit;
      transition: border-color 0.2s;
    }
    input:focus, select:focus {
      outline: none; border-color: #0d6e8a;
    }

    .btn-group { display: flex; gap: 12px; margin-top: 24px; }
    .btn {
      padding: 10px 24px; border-radius: 7px;
      font-size: 14px; font-weight: 600;
      border: none; cursor: pointer;
      text-decoration: none; display: inline-block;
    }
    .btn-primary   { background: #1a3a5c; color: white; }
    .btn-primary:hover { background: #0d6e8a; }
    .btn-secondary { background: #eee; color: #333; }

    .alert-danger {
      background: #f8d7da; color: #721c24;
      padding: 12px 14px; border-radius: 8px;
      margin-bottom: 18px; font-size: 13px;
      border-left: 4px solid #dc3545;
    }

    .role-grid {
      display: grid; grid-template-columns: 1fr 1fr; gap: 12px;
    }
    .role-option { display: none; }
    .role-label {
      border: 2px solid #ddd; border-radius: 8px;
      padding: 14px; text-align: center; cursor: pointer;
      transition: all 0.2s;
    }
    .role-label .role-icon { font-size: 24px; margin-bottom: 6px; }
    .role-label .role-name { font-size: 14px; font-weight: 600; color: #444; }
    .role-label .role-desc { font-size: 11px; color: #888; margin-top: 2px; }
    .role-option:checked + .role-label {
      border-color: #1a3a5c; background: #eef2f8;
    }
  </style>
</head>
<body>

<div class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div>
    <a href="<%= request.getContextPath() %>/users">Back to Users</a>
    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
  </div>
</div>

<div class="container">
  <div class="card">
    <h3><%= title %></h3>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert-danger">
      ❌ <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/users"
          method="post" onsubmit="return validateForm()">

      <input type="hidden" name="action"
             value="<%= isEdit ? "edit" : "add" %>" />
      <% if (isEdit) { %>
      <input type="hidden" name="userId"
             value="<%= editUser.getUserId() %>" />
      <% } %>

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
          <% if (isEdit) { %>
          <span class="hint">(leave blank to keep current password)</span>
          <% } %>
        </label>
        <input type="password" id="password" name="password"
               placeholder="<%= isEdit ? "Leave blank to keep current" : "Enter password" %>"
                <%= isEdit ? "" : "required" %> />
      </div>

      <div class="form-group">
        <label>Role *</label>
        <div class="role-grid">
          <div>
            <input type="radio" class="role-option"
                   name="role" id="role_staff" value="STAFF"
                    <%= isEdit && "STAFF".equals(editUser.getRole())
                            ? "checked" : (!isEdit ? "checked" : "") %> />
            <label class="role-label" for="role_staff">
              <div class="role-icon">👷</div>
              <div class="role-name">Staff</div>
              <div class="role-desc">Reservations & Billing</div>
            </label>
          </div>
          <div>
            <input type="radio" class="role-option"
                   name="role" id="role_admin" value="ADMIN"
                    <%= isEdit && "ADMIN".equals(editUser.getRole())
                            ? "checked" : "" %> />
            <label class="role-label" for="role_admin">
              <div class="role-icon">🔑</div>
              <div class="role-name">Admin</div>
              <div class="role-desc">Full system access</div>
            </label>
          </div>
        </div>
      </div>

      <div class="btn-group">
        <button type="submit" class="btn btn-primary">
          <%= isEdit ? "Update User" : "Add User" %>
        </button>
        <a href="<%= request.getContextPath() %>/users"
           class="btn btn-secondary">Cancel</a>
      </div>

    </form>
  </div>
</div>

<script>
  function validateForm() {
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value;
    const isEdit   = <%= isEdit %>;

    if (username.length < 3) {
      alert('Username must be at least 3 characters.');
      return false;
    }
    if (!isEdit && password.length < 4) {
      alert('Password must be at least 4 characters.');
      return false;
    }
    return true;
  }
</script>

</body>
</html>
```

---

## Flow Summary
```
/users               → list all users (ADMIN only)
/users?action=add    → empty user form
/users?action=edit&id=X → filled form with existing data
/users?action=delete&id=X → delete (cannot delete yourself)

POST /users (action=add)  → validate → addUser() → redirect to list
POST /users (action=edit) → validate → updateUser() → redirect to list
