<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ocean View Resort — Login</title>

  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(135deg, #1565C0, #0D47A1, #0A2E6E);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    /* ── Card ── */
    .login-card {
      background: #ffffff;
      width: 400px;
      border-radius: 16px;
      padding: 40px 36px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
      animation: fadeUp 0.6s ease;
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* ── Header ── */
    .header {
      text-align: center;
      margin-bottom: 30px;
    }

    .logo-circle {
      width: 72px;
      height: 72px;
      background: linear-gradient(135deg, #1565C0, #42A5F5);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 14px;
      font-size: 28px;
    }

    .logo-circle img {
      width: 50px;
      height: 50px;
      border-radius: 50%;
      object-fit: cover;
    }

    .header h1 {
      font-size: 20px;
      font-weight: 700;
      color: #0D47A1;
    }

    .header p {
      font-size: 12px;
      color: #888;
      margin-top: 4px;
      letter-spacing: 0.5px;
    }

    /* ── Divider ── */
    .divider {
      border: none;
      border-top: 1px solid #e8e8e8;
      margin-bottom: 24px;
    }

    /* ── Error ── */
    .error-msg {
      background: #FFF3F3;
      border-left: 4px solid #E53935;
      color: #C62828;
      padding: 10px 14px;
      border-radius: 6px;
      font-size: 13px;
      margin-bottom: 18px;
      animation: shake 0.4s ease;
    }

    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      25%       { transform: translateX(-5px); }
      75%       { transform: translateX(5px); }
    }

    /* ── Form ── */
    .form-group {
      margin-bottom: 18px;
    }

    label {
      display: block;
      font-size: 13px;
      font-weight: 500;
      color: #444;
      margin-bottom: 6px;
    }

    input[type="text"],
    input[type="password"] {
      width: 100%;
      padding: 11px 14px;
      border: 1.5px solid #ddd;
      border-radius: 8px;
      font-family: 'Poppins', sans-serif;
      font-size: 14px;
      color: #333;
      background: #fafafa;
      outline: none;
      transition: border-color 0.3s, box-shadow 0.3s;
    }

    input:focus {
      border-color: #1565C0;
      background: #fff;
      box-shadow: 0 0 0 3px rgba(21, 101, 192, 0.12);
    }

    /* ── Button ── */
    .btn-login {
      width: 100%;
      padding: 13px;
      background: linear-gradient(135deg, #1565C0, #1976D2);
      color: white;
      border: none;
      border-radius: 8px;
      font-family: 'Poppins', sans-serif;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      margin-top: 6px;
      transition: background 0.3s, transform 0.2s, box-shadow 0.2s;
      box-shadow: 0 4px 15px rgba(21, 101, 192, 0.35);
    }

    .btn-login:hover {
      background: linear-gradient(135deg, #0D47A1, #1565C0);
      transform: translateY(-1px);
      box-shadow: 0 6px 20px rgba(21, 101, 192, 0.45);
    }

    .btn-login:active {
      transform: translateY(0);
      box-shadow: 0 2px 8px rgba(21, 101, 192, 0.3);
    }

    /* ── Footer ── */
    .footer {
      text-align: center;
      margin-top: 20px;
      font-size: 12px;
      color: #aaa;
    }

  </style>
</head>
<body>

<div class="login-card">

  <!-- Header -->
  <div class="header">
    <div class="logo-circle">
      <img src="logo.png"
           onerror="this.parentElement.innerHTML='🌊'"
           alt="Logo">
    </div>
    <h1>Ocean View Resort</h1>
    <p>Reservation Management System</p>
  </div>

  <hr class="divider">

  <!-- Error message -->
  <% if (request.getAttribute("errorMessage") != null) { %>
  <div class="error-msg">
    ⚠ <%= request.getAttribute("errorMessage") %>
  </div>
  <% } %>

  <!-- Form -->
  <form action="${pageContext.request.contextPath}/login" method="post">

    <div class="form-group">
      <label for="username">Username</label>
      <input type="text"
             id="username"
             name="username"
             placeholder="Enter your username"
             value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
             required>
    </div>

    <div class="form-group">
      <label for="password">Password</label>
      <input type="password"
             id="password"
             name="password"
             placeholder="Enter your password"
             required>
    </div>

    <button type="submit" class="btn-login">Sign In</button>

  </form>

  <div class="footer">
    &copy; 2024 Ocean View Resort. All rights reserved.
  </div>

</div>

<script>
  /* Simple input highlight effect */
  document.querySelectorAll('input').forEach(input => {
    input.addEventListener('focus', function() {
      this.parentElement.style.transform = 'scale(1.01)';
      this.parentElement.style.transition = '0.2s';
    });
    input.addEventListener('blur', function() {
      this.parentElement.style.transform = 'scale(1)';
    });
  });
</script>

</body>
</html>
