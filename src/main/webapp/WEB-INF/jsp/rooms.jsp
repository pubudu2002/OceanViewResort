<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.resort.model.Room, java.util.List" %>
<%@ page import="com.example.resort.model.User" %>
<%
    List<Room> rooms      = (List<Room>) request.getAttribute("rooms");
    String     successMsg = request.getParameter("success");
    String     errorMsg   = request.getParameter("error");
    User       loggedIn   = (User) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rooms — Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Poppins', sans-serif;
            background: #f0f4fa;
            color: #333;
            min-height: 100vh;
        }

        /* ── Navbar ── */
        .navbar {
            background: linear-gradient(135deg, #1565C0, #0D47A1);
            padding: 14px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.18);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar h2 { font-size: 18px; font-weight: 600; color: white; }
        .navbar-links a {
            color: #BBDEFB;
            text-decoration: none;
            margin-left: 24px;
            font-size: 13px;
            font-weight: 500;
            transition: color 0.2s;
        }
        .navbar-links a:hover { color: white; }

        /* ── Page wrapper ── */
        .page-wrapper {
            width: 100%;
            padding: 32px 40px;
            animation: fadeUp 0.5s ease;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(14px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Page header ── */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .page-header-left h2 {
            font-size: 22px;
            font-weight: 700;
            color: #1565C0;
        }
        .page-header-left p {
            font-size: 13px;
            color: #888;
            margin-top: 3px;
        }

        /* ── Buttons ── */
        .btn {
            padding: 10px 20px;
            border-radius: 9px;
            font-size: 13px;
            font-weight: 600;
            font-family: 'Poppins', sans-serif;
            text-decoration: none;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: transform 0.2s, opacity 0.2s;
        }
        .btn:hover { transform: translateY(-1px); opacity: 0.92; }
        .btn:active { transform: translateY(0); }

        .btn-primary { background: linear-gradient(135deg, #1565C0, #1E88E5); color: white; box-shadow: 0 4px 14px rgba(21,101,192,0.3); }
        .btn-warning { background: #FB8C00; color: white; }
        .btn-danger  { background: #E53935; color: white; }
        .btn-sm      { padding: 6px 14px; font-size: 12px; }

        /* ── Alerts ── */
        .alert { padding: 12px 18px; border-radius: 10px; margin-bottom: 20px; font-size: 13px; font-weight: 500; }
        .alert-success { background: #E8F5E9; color: #2E7D32; border-left: 4px solid #43A047; }
        .alert-danger  { background: #FFEBEE; color: #C62828; border-left: 4px solid #E53935; }

        /* ── Rooms grid ── */
        .rooms-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 22px;
        }

        /* ── Room card ── */
        .room-card {
            background: white;
            border-radius: 14px;
            box-shadow: 0 3px 14px rgba(0,0,0,0.07);
            overflow: hidden;
            transition: transform 0.22s, box-shadow 0.22s;
            border: 1px solid #E8EFF8;
        }
        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 28px rgba(21,101,192,0.14);
        }

        /* ── Room image ── */
        .room-img-wrap {
            width: 100%;
            height: 185px;
            overflow: hidden;
            position: relative;
        }

        /* Real image */
        .room-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.35s;
            display: block;
        }
        .room-card:hover .room-img-wrap img { transform: scale(1.06); }

        /* Beautiful placeholder when no image / broken image */
        .room-img-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        /* Gradient by room type */
        .placeholder-standard {
            background: linear-gradient(135deg, #1565C0 0%, #42A5F5 100%);
        }
        .placeholder-deluxe {
            background: linear-gradient(135deg, #4527A0 0%, #7E57C2 100%);
        }
        .placeholder-suite {
            background: linear-gradient(135deg, #E65100 0%, #FFA726 100%);
        }
        .placeholder-default {
            background: linear-gradient(135deg, #37474F 0%, #78909C 100%);
        }

        .placeholder-icon {
            font-size: 42px;
            opacity: 0.9;
        }
        .placeholder-room-label {
            font-size: 14px;
            font-weight: 700;
            color: rgba(255,255,255,0.95);
            letter-spacing: 0.5px;
        }
        .placeholder-type-label {
            font-size: 11px;
            font-weight: 500;
            color: rgba(255,255,255,0.75);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Status badge on image */
        .status-badge {
            position: absolute;
            top: 10px; right: 10px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.4px;
        }
        .badge-available    { background: rgba(232,245,233,0.95); color: #2E7D32; }
        .badge-maintenance  { background: rgba(255,235,238,0.95); color: #C62828; }
        .badge-occupied     { background: rgba(255,243,224,0.95); color: #E65100; }

        /* ── Room body ── */
        .room-body { padding: 16px 18px; }

        .room-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
        }
        .room-number { font-size: 17px; font-weight: 700; color: #1565C0; }

        .room-type-badge { font-size: 10px; font-weight: 700; padding: 3px 10px; border-radius: 20px; }
        .type-standard { background: #E3F2FD; color: #1565C0; }
        .type-deluxe   { background: #EDE7F6; color: #512DA8; }
        .type-suite    { background: #FFF3E0; color: #E65100; }

        .room-price {
            font-size: 15px;
            font-weight: 700;
            color: #1565C0;
            margin-bottom: 4px;
        }
        .room-price span { font-size: 11px; font-weight: 400; color: #aaa; }

        .room-desc {
            font-size: 12px;
            color: #888;
            margin-bottom: 8px;
            line-height: 1.5;
            min-height: 34px;
        }
        .room-meta { font-size: 12px; color: #666; margin-bottom: 10px; }

        .room-actions {
            display: flex;
            gap: 8px;
            padding-top: 12px;
            border-top: 1px solid #EEF4FF;
        }

        /* ── Empty state ── */
        .empty-state {
            background: white;
            padding: 60px 40px;
            border-radius: 14px;
            text-align: center;
            color: #aaa;
            box-shadow: 0 3px 12px rgba(0,0,0,0.07);
        }
        .empty-state div { font-size: 52px; margin-bottom: 14px; }
        .empty-state p   { font-size: 14px; }

        /* ── Responsive ── */
        @media (max-width: 768px) {
            .page-wrapper { padding: 20px 16px; }
            .rooms-grid   { grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 16px; }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <h2>🏖 Ocean View Resort</h2>
    <div class="navbar-links">
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</nav>

<!-- Page Content -->
<div class="page-wrapper">

    <div class="page-header">
        <div class="page-header-left">
            <h2>🛏 Room Management</h2>
            <p>View, add and manage all hotel rooms</p>
        </div>
        <a href="<%= request.getContextPath() %>/rooms?action=add" class="btn btn-primary">+ Add New Room</a>
    </div>

    <% if (successMsg != null) { %><div class="alert alert-success">✅ <%= successMsg %></div><% } %>
    <% if (errorMsg   != null) { %><div class="alert alert-danger">❌ <%= errorMsg %></div><% } %>

    <% if (rooms == null || rooms.isEmpty()) { %>
    <div class="empty-state">
        <div>🛏</div>
        <p>No rooms found. Click <strong>+ Add New Room</strong> to get started.</p>
    </div>
    <% } else { %>

    <div class="rooms-grid">
        <% for (Room r : rooms) {
            String type = r.getRoomType() != null ? r.getRoomType().toLowerCase() : "default";
            boolean hasImage = r.getImagePath() != null && !r.getImagePath().isEmpty();
        %>
        <div class="room-card">

            <!-- Image or Placeholder -->
            <div class="room-img-wrap">
                <% if (hasImage) { %>
                <img src="<%= request.getContextPath() %>/<%= r.getImagePath() %>"
                     alt="Room <%= r.getRoomNumber() %>"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                <% } %>

                <!-- Always render placeholder — hidden if real image loads, shown if missing/broken -->
                <div class="room-img-placeholder placeholder-<%= type %>"
                     style="<%= hasImage ? "display:none;" : "" %>">
                    <div class="placeholder-icon">🛏</div>
                    <div class="placeholder-room-label">Room <%= r.getRoomNumber() %></div>
                    <div class="placeholder-type-label"><%= r.getRoomType() %></div>
                </div>

                <!-- Status badge -->
                <span class="status-badge badge-<%= r.getStatus().toLowerCase() %>">
                    <%= r.getStatus() %>
                </span>
            </div>

            <!-- Room Info -->
            <div class="room-body">
                <div class="room-header">
                    <div class="room-number">Room <%= r.getRoomNumber() %></div>
                    <span class="room-type-badge type-<%= type %>"><%= r.getRoomType() %></span>
                </div>

                <div class="room-price">
                    LKR <%= String.format("%,.0f", r.getPricePerNight()) %>
                    <span>/night</span>
                </div>

                <div class="room-desc">
                    <%= r.getDescription() != null && !r.getDescription().isEmpty()
                            ? r.getDescription() : "No description provided." %>
                </div>

                <div class="room-meta">👥 Up to <%= r.getCapacity() %> person(s)</div>

                <div class="room-actions">
                    <a href="<%= request.getContextPath() %>/rooms?action=edit&id=<%= r.getRoomId() %>"
                       class="btn btn-warning btn-sm">✏ Edit</a>
                    <a href="<%= request.getContextPath() %>/rooms?action=delete&id=<%= r.getRoomId() %>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Delete Room <%= r.getRoomNumber() %>?')">🗑 Delete</a>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <% } %>
</div>

</body>
</html>
