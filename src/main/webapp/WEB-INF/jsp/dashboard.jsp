<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="com.example.resort.model.User" %>
<%
  User loggedInUser = (User) session.getAttribute("loggedInUser");
  if (loggedInUser == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Dashboard — Ocean View Resort</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }

    body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

    .navbar {
      background: #1a3a5c;
      color: white;
      padding: 14px 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .navbar h2 { font-size: 18px; }

    .navbar .user-info { font-size: 13px; }

    .navbar a {
      color: #aed6f1;
      text-decoration: none;
      margin-left: 20px;
      font-size: 13px;
    }

    .navbar a:hover { color: white; }

    .container { padding: 30px; }

    .welcome-banner {
      background: white;
      border-radius: 10px;
      padding: 24px 30px;
      margin-bottom: 24px;
      border-left: 5px solid #0d6e8a;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }

    .welcome-banner h3 { color: #1a3a5c; font-size: 20px; }
    .welcome-banner p  { color: #666; margin-top: 6px; font-size: 14px; }

    .menu-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
    }

    .menu-card {
      background: white;
      border-radius: 10px;
      padding: 28px 20px;
      text-align: center;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      text-decoration: none;
      color: #1a3a5c;
      transition: transform 0.2s, box-shadow 0.2s;
      border-top: 4px solid #0d6e8a;
    }

    .menu-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    }

    .menu-card .icon { font-size: 36px; margin-bottom: 12px; }
    .menu-card h4    { font-size: 15px; font-weight: 600; }
  </style>
</head>
<body>

<div class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div class="user-info">
    Welcome, <strong><%= loggedInUser.getFullName() %></strong>
    (<%= loggedInUser.getRole() %>)
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
  </div>
</div>

<div class="container">

  <div class="welcome-banner">
    <h3>Good day, <%= loggedInUser.getFullName() %>!</h3>
    <p>What would you like to manage today?</p>
  </div>

  <div class="menu-grid">
    <a href="${pageContext.request.contextPath}/reservation?action=add" class="menu-card">
      <div class="icon">📋</div>
      <h4>New Reservation</h4>
    </a>
    <a href="${pageContext.request.contextPath}/reservation?action=list" class="menu-card">
      <div class="icon">🔍</div>
      <h4>View Reservations</h4>
    </a>
    <a href="${pageContext.request.contextPath}/billing" class="menu-card">
      <div class="icon">💰</div>
      <h4>Billing</h4>
    </a>
    <a href="${pageContext.request.contextPath}/rooms" class="menu-card">
      <div class="icon">🛏</div>
      <h4>Rooms</h4>
    </a>
    <a href="${pageContext.request.contextPath}/help" class="menu-card">
      <div class="icon">❓</div>
      <h4>Help</h4>
    </a>
    <% if ("ADMIN".equals(loggedInUser.getRole())) { %>
    <a href="${pageContext.request.contextPath}/users" class="menu-card">
      <div class="icon">👤</div>
      <h4>Manage Users</h4>
    </a>
    <% } %>
  </div>

</div>

</body>
</html>