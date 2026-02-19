<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 3:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.User, java.util.List" %>
<%
    List<User> users      = (List<User>) request.getAttribute("users");
    String     successMsg = (String) request.getAttribute("successMsg");
    String     errorMsg   = (String) request.getAttribute("errorMsg");
    User       loggedIn   = (User) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users — Ocean View Resort</title>
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
        .navbar a:hover { color: white; }

        .container { padding: 30px; }

        .page-header {
            display: flex; justify-content: space-between;
            align-items: center; margin-bottom: 20px;
        }
        .page-header h2 { color: #1a3a5c; font-size: 22px; }

        .btn {
            padding: 9px 18px; border-radius: 7px;
            font-size: 13px; font-weight: 600;
            text-decoration: none; border: none;
            cursor: pointer; display: inline-block;
        }
        .btn-primary  { background: #1a3a5c; color: white; }
        .btn-primary:hover { background: #0d6e8a; }
        .btn-warning  { background: #f39c12; color: white; }
        .btn-danger   { background: #e74c3c; color: white; }
        .btn-sm       { padding: 5px 12px; font-size: 12px; }

        .alert {
            padding: 12px 16px; border-radius: 8px;
            margin-bottom: 18px; font-size: 14px;
        }
        .alert-success { background: #d4edda; color: #155724;
            border-left: 4px solid #28a745; }
        .alert-danger  { background: #f8d7da; color: #721c24;
            border-left: 4px solid #dc3545; }

        table {
            width: 100%; background: white; border-radius: 10px;
            border-collapse: collapse;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07); overflow: hidden;
        }
        th {
            background: #1a3a5c; color: white;
            padding: 12px 16px; text-align: left; font-size: 13px;
        }
        td {
            padding: 11px 16px; font-size: 13px;
            border-bottom: 1px solid #f0f0f0;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f8fafc; }

        .badge {
            padding: 3px 12px; border-radius: 20px;
            font-size: 11px; font-weight: 700;
        }
        .badge-admin { background: #1a3a5c; color: white; }
        .badge-staff { background: #cce5ff; color: #004085; }

        .you-tag {
            font-size: 10px; background: #0d6e8a;
            color: white; padding: 2px 7px;
            border-radius: 10px; margin-left: 6px;
        }
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
        <h2>👤 Manage Users</h2>
        <a href="<%= request.getContextPath() %>/users?action=add"
           class="btn btn-primary">+ Add New User</a>
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
            <th>#</th>
            <th>Full Name</th>
            <th>Username</th>
            <th>Role</th>
            <th>Created At</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (users == null || users.isEmpty()) { %>
        <tr>
            <td colspan="6" style="text-align:center;color:#999;padding:30px;">
                No users found.
            </td>
        </tr>
        <% } else {
            int i = 1;
            for (User u : users) {
                boolean isYou = u.getUserId() == loggedIn.getUserId();
        %>
        <tr>
            <td><%= i++ %></td>
            <td>
                <strong><%= u.getFullName() %></strong>
                <% if (isYou) { %>
                <span class="you-tag">YOU</span>
                <% } %>
            </td>
            <td><%= u.getUsername() %></td>
            <td>
                    <span class="badge badge-<%= u.getRole().toLowerCase() %>">
                        <%= u.getRole() %>
                    </span>
            </td>
            <td style="color:#888;">—</td>
            <td>
                <a href="<%= request.getContextPath() %>/users?action=edit&id=<%= u.getUserId() %>"
                   class="btn btn-warning btn-sm">Edit</a>
                &nbsp;
                <% if (!isYou) { %>
                <a href="<%= request.getContextPath() %>/users?action=delete&id=<%= u.getUserId() %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete user <%= u.getFullName() %>?')">
                    Delete
                </a>
                <% } %>
            </td>
        </tr>
        <% } } %>
        </tbody>
    </table>

</div>
</body>
</html>