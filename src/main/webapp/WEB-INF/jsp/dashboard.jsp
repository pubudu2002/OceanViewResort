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

  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      font-family: 'Poppins', sans-serif;
      background: #f0f4fa;
      color: #333;
      min-height: 100vh;
    }

    /* ── Navbar ── */
    .navbar {
      background: linear-gradient(135deg, #1565C0, #0D47A1);
      padding: 15px 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 2px 10px rgba(0,0,0,0.15);
      animation: slideDown 0.5s ease;
    }

    @keyframes slideDown {
      from { transform: translateY(-40px); opacity: 0; }
      to   { transform: translateY(0);     opacity: 1; }
    }

    .navbar h2 {
      font-size: 18px;
      font-weight: 600;
      color: white;
      letter-spacing: 0.5px;
    }

    .user-info {
      display: flex;
      align-items: center;
      gap: 16px;
      font-size: 13px;
      color: #BBDEFB;
    }

    .user-info strong { color: white; }

    .logout-btn {
      background: white;
      color: #1565C0;
      padding: 7px 18px;
      border-radius: 20px;
      text-decoration: none;
      font-weight: 600;
      font-size: 13px;
      transition: background 0.2s, transform 0.2s;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .logout-btn:hover {
      background: #E3F2FD;
      transform: scale(1.05);
    }

    .logout-btn:active { transform: scale(0.97); }

    /* ── Container ── */
    .container {
      padding: 35px 30px;
      max-width: 1100px;
      margin: 0 auto;
      animation: fadeIn 0.6s ease;
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to   { opacity: 1; }
    }

    /* ── Welcome Banner ── */
    .welcome-banner {
      background: white;
      border-radius: 12px;
      padding: 22px 26px;
      margin-bottom: 28px;
      border-left: 5px solid #1565C0;
      box-shadow: 0 3px 12px rgba(0,0,0,0.07);
    }

    .welcome-banner h3 {
      color: #1565C0;
      font-size: 18px;
      font-weight: 600;
    }

    .welcome-banner p {
      color: #888;
      margin-top: 5px;
      font-size: 13px;
    }

    /* ── Menu Grid ── */
    .menu-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 22px;
    }

    /* ── Menu Card ── */
    .menu-card {
      background: white;
      border-radius: 12px;
      padding: 32px 20px;
      text-align: center;
      text-decoration: none;
      color: #333;
      border-top: 4px solid #1565C0;
      box-shadow: 0 3px 14px rgba(0,0,0,0.07);
      transition: transform 0.25s, box-shadow 0.25s, border-color 0.25s;
      opacity: 0;
      animation: cardFade 0.5s ease forwards;
    }

    .menu-card:hover {
      transform: translateY(-6px);
      box-shadow: 0 10px 28px rgba(21,101,192,0.18);
      border-top-color: #42A5F5;
    }

    .menu-card:active { transform: translateY(-2px); }

    .menu-card .icon {
      font-size: 38px;
      margin-bottom: 12px;
    }

    .menu-card h4 {
      font-size: 15px;
      font-weight: 500;
      color: #1565C0;
    }

    /* Staggered card animations */
    .menu-card:nth-child(1) { animation-delay: 0.10s; }
    .menu-card:nth-child(2) { animation-delay: 0.20s; }
    .menu-card:nth-child(3) { animation-delay: 0.30s; }
    .menu-card:nth-child(4) { animation-delay: 0.40s; }
    .menu-card:nth-child(5) { animation-delay: 0.50s; }
    .menu-card:nth-child(6) { animation-delay: 0.60s; }

    @keyframes cardFade {
      from { opacity: 0; transform: translateY(25px); }
      to   { opacity: 1; transform: translateY(0); }
    }

  </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
  <h2>🏖 Ocean View Resort</h2>
  <div class="user-info">
    <span>Welcome, <strong><%= loggedInUser.getFullName() %></strong> (<%= loggedInUser.getRole() %>)</span>
    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
  </div>
</div>

<!-- Main Content -->
<div class="container">

  <!-- Welcome Banner -->
  <div class="welcome-banner">
    <h3>Good day, <%= loggedInUser.getFullName() %>! 👋</h3>
    <p>What would you like to manage today?</p>
  </div>

  <!-- Menu Cards -->
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
