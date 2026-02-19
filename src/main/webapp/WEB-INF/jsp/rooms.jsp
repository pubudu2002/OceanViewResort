<%--
  Created by IntelliJ IDEA.
  User: pubud
  Date: 2/19/2026
  Time: 2:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.Room, java.util.List" %>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Rooms — Ocean View Resort</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

        .navbar {
            background: #1a3a5c; color: white;
            padding: 14px 30px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .navbar a { color: #aed6f1; text-decoration: none; margin-left: 16px; font-size: 13px; }
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
            text-decoration: none; cursor: pointer;
            border: none; display: inline-block;
        }
        .btn-primary { background: #1a3a5c; color: white; }
        .btn-primary:hover { background: #0d6e8a; }
        .btn-warning { background: #f39c12; color: white; }
        .btn-danger  { background: #e74c3c; color: white; }
        .btn-sm { padding: 5px 12px; font-size: 12px; }

        .alert {
            padding: 12px 16px; border-radius: 8px;
            margin-bottom: 18px; font-size: 14px;
        }
        .alert-success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .alert-danger  { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }

        table {
            width: 100%; background: white;
            border-radius: 10px; border-collapse: collapse;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            overflow: hidden;
        }
        th {
            background: #1a3a5c; color: white;
            padding: 12px 16px; text-align: left; font-size: 13px;
        }
        td { padding: 11px 16px; font-size: 13px; border-bottom: 1px solid #f0f0f0; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f8fafc; }

        .badge {
            padding: 3px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600;
        }
        .badge-available   { background: #d4edda; color: #155724; }
        .badge-occupied    { background: #fff3cd; color: #856404; }
        .badge-maintenance { background: #f8d7da; color: #721c24; }

        .type-standard { color: #2980b9; font-weight: 600; }
        .type-deluxe   { color: #8e44ad; font-weight: 600; }
        .type-suite    { color: #c0392b; font-weight: 600; }
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
        <h2>🛏 Room Management</h2>
        <a href="<%= request.getContextPath() %>/rooms?action=add"
           class="btn btn-primary">+ Add New Room</a>
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
            <th>Room No</th>
            <th>Type</th>
            <th>Price/Night (LKR)</th>
            <th>Capacity</th>
            <th>Description</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (rooms == null || rooms.isEmpty()) { %>
        <tr>
            <td colspan="8" style="text-align:center; color:#999; padding:30px;">
                No rooms found.
            </td>
        </tr>
        <% } else {
            int i = 1;
            for (Room r : rooms) { %>
        <tr>
            <td><%= i++ %></td>
            <td><strong><%= r.getRoomNumber() %></strong></td>
            <td>
                    <span class="type-<%= r.getRoomType().toLowerCase() %>">
                        <%= r.getRoomType() %>
                    </span>
            </td>
            <td>LKR <%= String.format("%,.2f", r.getPricePerNight()) %></td>
            <td><%= r.getCapacity() %> person(s)</td>
            <td><%= r.getDescription() != null ? r.getDescription() : "-" %></td>
            <td>
                    <span class="badge badge-<%= r.getStatus().toLowerCase() %>">
                        <%= r.getStatus() %>
                    </span>
            </td>
            <td>
                <a href="<%= request.getContextPath() %>/rooms?action=edit&id=<%= r.getRoomId() %>"
                   class="btn btn-warning btn-sm">Edit</a>
                &nbsp;
                <a href="<%= request.getContextPath() %>/rooms?action=delete&id=<%= r.getRoomId() %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete Room <%= r.getRoomNumber() %>?')">Delete</a>
            </td>
        </tr>
        <% } } %>
        </tbody>
    </table>

</div>
</body>
</html>