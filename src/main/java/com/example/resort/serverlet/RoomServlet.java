package com.example.resort.serverlet;

import com.example.resort.model.Room;
import com.example.resort.service.RoomService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;

@WebServlet("/rooms")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize       = 5 * 1024 * 1024,
        maxRequestSize    = 10 * 1024 * 1024
)
public class RoomServlet extends HttpServlet {

    private final RoomService roomService = new RoomService();

    // ✅ Permanent path — images saved here survive Tomcat restarts
    private static final String PERMANENT_DIR =
            "C:/Users/USER/IdeaProjects/OceanViewResort/src/main/webapp/uploads/rooms/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "add":
                req.getRequestDispatcher("/WEB-INF/jsp/room_form.jsp")
                        .forward(req, resp);
                break;

            case "edit":
                int editId = Integer.parseInt(req.getParameter("id"));
                Room room  = roomService.getRoomById(editId);
                if (room == null) {
                    resp.sendRedirect(req.getContextPath() +
                            "/rooms?error=Room not found.");
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
                    resp.sendRedirect(req.getContextPath() +
                            "/rooms?success=Room deleted successfully.");
                } else {
                    resp.sendRedirect(req.getContextPath() +
                            "/rooms?error=" + delResult);
                }
                break;

            default:
                List<Room> rooms = roomService.getAllRooms();
                req.setAttribute("rooms", rooms);
                req.setAttribute("successMsg", req.getParameter("success"));
                req.setAttribute("errorMsg",   req.getParameter("error"));
                req.getRequestDispatcher("/WEB-INF/jsp/rooms.jsp")
                        .forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action      = req.getParameter("action");
        String roomIdStr   = req.getParameter("roomId");
        String roomNumber  = req.getParameter("roomNumber");
        String roomType    = req.getParameter("roomType");
        String priceStr    = req.getParameter("pricePerNight");
        String capacityStr = req.getParameter("capacity");
        String description = req.getParameter("description");
        String status      = req.getParameter("status");
        if (status == null) status = "AVAILABLE";

        // Handle image upload
        String imagePath = null;
        try {
            Part filePart = req.getPart("roomImage");
            if (filePart != null && filePart.getSize() > 0) {
                imagePath = saveImage(req, filePart);
                if (imagePath == null) {
                    req.setAttribute("errorMessage",
                            "Only JPG, JPEG, PNG images allowed (max 5MB).");
                    if ("edit".equals(action) && roomIdStr != null) {
                        req.setAttribute("room",
                                roomService.getRoomById(
                                        Integer.parseInt(roomIdStr)));
                    }
                    req.getRequestDispatcher("/WEB-INF/jsp/room_form.jsp")
                            .forward(req, resp);
                    return;
                }
            }
        } catch (Exception e) {
            System.err.println("Image upload error: " + e.getMessage());
        }

        String result;
        if ("edit".equals(action) && roomIdStr != null) {
            int roomId = Integer.parseInt(roomIdStr);
            result = roomService.updateRoom(
                    roomId, roomNumber, roomType,
                    priceStr, capacityStr,
                    description, status, imagePath);
        } else {
            result = roomService.addRoom(
                    roomNumber, roomType,
                    priceStr, capacityStr,
                    description, imagePath);
        }

        if ("success".equals(result)) {
            resp.sendRedirect(req.getContextPath() +
                    "/rooms?success=Room saved successfully.");
        } else {
            req.setAttribute("errorMessage", result);
            if ("edit".equals(action) && roomIdStr != null) {
                req.setAttribute("room",
                        roomService.getRoomById(
                                Integer.parseInt(roomIdStr)));
            }
            req.getRequestDispatcher("/WEB-INF/jsp/room_form.jsp")
                    .forward(req, resp);
        }
    }

    // ✅ Saves image to permanent project folder AND Tomcat deploy folder
    private String saveImage(HttpServletRequest req, Part filePart)
            throws IOException {

        String fileName = Paths.get(
                filePart.getSubmittedFileName()).getFileName().toString();
        String ext = fileName.contains(".")
                ? fileName.substring(fileName.lastIndexOf(".")).toLowerCase()
                : "";

        // Validate file type
        if (!ext.equals(".jpg") && !ext.equals(".jpeg")
                && !ext.equals(".png")) {
            return null;
        }

        // Generate unique filename
        String uniqueName = UUID.randomUUID().toString() + ext;

        // ✅ Step 1: Save to permanent project source folder
        File permanentDir = new File(PERMANENT_DIR);
        if (!permanentDir.exists()) permanentDir.mkdirs();

        File permanentFile = new File(permanentDir, uniqueName);
        filePart.write(permanentFile.getAbsolutePath());

        // ✅ Step 2: Also copy to Tomcat deployed folder
        // so image shows immediately without restart
        String deployedDir = req.getServletContext()
                .getRealPath("/uploads/rooms");
        File deployedDirFile = new File(deployedDir);
        if (!deployedDirFile.exists()) deployedDirFile.mkdirs();

        Files.copy(
                permanentFile.toPath(),
                new File(deployedDirFile, uniqueName).toPath(),
                StandardCopyOption.REPLACE_EXISTING
        );

        return "uploads/rooms/" + uniqueName;
    }
}