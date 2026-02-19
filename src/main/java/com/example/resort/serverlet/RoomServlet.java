package com.example.resort.serverlet;

import com.example.resort.model.Room;
import com.example.resort.service.RoomService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/rooms")
public class RoomServlet extends HttpServlet {

    private final RoomService roomService = new RoomService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "add":
                // Show empty add form
                req.getRequestDispatcher("/WEB-INF/jsp/room_form.jsp")
                        .forward(req, resp);
                break;

            case "edit":
                // Show edit form filled with existing data
                int editId = Integer.parseInt(req.getParameter("id"));
                Room room  = roomService.getRoomById(editId);
                if (room == null) {
                    req.setAttribute("errorMessage", "Room not found.");
                    showRoomList(req, resp);
                } else {
                    req.setAttribute("room", room);
                    req.getRequestDispatcher("/WEB-INF/jsp/room_form.jsp")
                            .forward(req, resp);
                }
                break;

            case "delete":
                int deleteId = Integer.parseInt(req.getParameter("id"));
                String delResult = roomService.deleteRoom(deleteId);
                if ("success".equals(delResult)) {
                    resp.sendRedirect(req.getContextPath()
                            + "/rooms?success=Room deleted successfully.");
                } else {
                    resp.sendRedirect(req.getContextPath()
                            + "/rooms?error=" + delResult);
                }
                break;

            default:
                showRoomList(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action    = req.getParameter("action");
        String roomIdStr = req.getParameter("roomId");

        String roomNumber   = req.getParameter("roomNumber");
        String roomType     = req.getParameter("roomType");
        String priceStr     = req.getParameter("pricePerNight");
        String capacityStr  = req.getParameter("capacity");
        String description  = req.getParameter("description");
        String status       = req.getParameter("status");

        String result;

        if ("edit".equals(action) && roomIdStr != null) {
            int roomId = Integer.parseInt(roomIdStr);
            result = roomService.updateRoom(roomId, roomNumber, roomType,
                    priceStr, capacityStr,
                    description, status);
        } else {
            result = roomService.addRoom(roomNumber, roomType,
                    priceStr, capacityStr, description);
        }

        if ("success".equals(result)) {
            resp.sendRedirect(req.getContextPath()
                    + "/rooms?success=Room saved successfully.");
        } else {
            req.setAttribute("errorMessage", result);
            req.setAttribute("action", action);
            req.getRequestDispatcher("/WEB-INF/jsp/room_form.jsp")
                    .forward(req, resp);
        }
    }

    private void showRoomList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Room> rooms = roomService.getAllRooms();
        req.setAttribute("rooms", rooms);
        req.getRequestDispatcher("/WEB-INF/jsp/rooms.jsp").forward(req, resp);
    }
}