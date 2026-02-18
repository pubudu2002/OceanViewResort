<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ocean View Resort — Login</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(135deg, #1a3a5c, #0d6e8a);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .login-card {
      background: white;
      border-radius: 12px;
      padding: 40px;
      width: 380px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    }

    .hotel-logo {
      text-align: center;
      margin-bottom: 30px;
    }

    .hotel-logo h1 {
      color: #1a3a5c;
      font-size: 22px;
      font-weight: 700;
    }

    .hotel-logo p {
      color: #0d6e8a;
      font-size: 13px;
      margin-top: 4px;
    }

    .form-group {
      margin-bottom: 20px;
    }

    label {
      display: block;
      font-size: 13px;
      font-weight: 600;
      color: #444;
      margin-bottom: 6px;
    }

    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 10px 14px;
      border: 1.5px solid #ddd;
      border-radius: 8px;
      font-size: 14px;
      transition: border-color 0.2s;
    }

    input:focus {
      outline: none;
      border-color: #0d6e8a;
    }

    .btn-login {
      width: 100%;
      padding: 12px;
      background: #1a3a5c;
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.2s;
    }

    .btn-login:hover { background: #0d6e8a; }

    .error-msg {
      background: #fde8e8;
      color: #c0392b;
      padding: 10px 14px;
      border-radius: 8px;
      font-size: 13px;
      margin-bottom: 18px;
      border-left: 4px solid #c0392b;
    }
  </style>
</head>
<body>

<div class="login-card">
  <div class="hotel-logo">
    <h1>🏖 Ocean View Resort</h1>
    <p>Reservation Management System</p>
  </div>

  <% if (request.getAttribute("errorMessage") != null) { %>
  <div class="error-msg">
    <%= request.getAttribute("errorMessage") %>
  </div>
  <% } %>

  <form action="${pageContext.request.contextPath}/login" method="post">
    <div class="form-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username"
             placeholder="Enter your username"
             value="<%= request.getParameter("username") != null
                              ? request.getParameter("username") : "" %>"
             required />
    </div>

    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password"
             placeholder="Enter your password" required />
    </div>

    <button type="submit" class="btn-login">Sign In</button>
  </form>
</div>

</body>
</html>