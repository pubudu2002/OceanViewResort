package com.example.resort.serverlet;

import com.example.resort.dao.RoomDAO;
import com.example.resort.model.Reservation;
import com.example.resort.model.Room;
import com.example.resort.model.User;
import com.example.resort.service.ReservationService;
import com.example.resort.service.RoomService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {

    private final ReservationService reservationService =
            new ReservationService();
    private final RoomService roomService = new RoomService();
    private final RoomDAO     roomDAO     = new RoomDAO();
    private final Gson        gson        = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "add":
                loadFormData(req);
                req.getRequestDispatcher(
                        "/WEB-INF/jsp/reservation_form.jsp").forward(req, resp);
                break;

            case "view":
                String resNo = req.getParameter("resNo");
                Reservation res =
                        reservationService.getByReservationNo(resNo);
                req.setAttribute("reservation", res);
                req.getRequestDispatcher(
                        "/WEB-INF/jsp/reservation_detail.jsp").forward(req, resp);
                break;

            case "cancel":
                int cancelId =
                        Integer.parseInt(req.getParameter("id"));
                String result =
                        reservationService.cancelReservation(cancelId);
                if ("success".equals(result)) {
                    resp.sendRedirect(req.getContextPath() +
                            "/reservation?action=list" +
                            "&success=Reservation cancelled successfully.");
                } else {
                    resp.sendRedirect(req.getContextPath() +
                            "/reservation?action=list&error=" + result);
                }
                break;

            default:
                List<Reservation> all =
                        reservationService.getAllReservations();
                req.setAttribute("reservations", all);
                req.setAttribute("successMsg", req.getParameter("success"));
                req.setAttribute("errorMsg",   req.getParameter("error"));
                req.getRequestDispatcher(
                        "/WEB-INF/jsp/reservations.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User loggedInUser = (User) req.getSession()
                .getAttribute("loggedInUser");

        String guestName       = req.getParameter("guestName");
        String address         = req.getParameter("address");
        String contactNo       = req.getParameter("contactNo");
        String email           = req.getParameter("email");
        String nic             = req.getParameter("nic");
        String roomIdStr       = req.getParameter("roomId");
        String checkIn         = req.getParameter("checkInDate");
        String checkOut        = req.getParameter("checkOutDate");
        String specialRequests = req.getParameter("specialRequests");

        int roomId = 0;
        try { roomId = Integer.parseInt(roomIdStr); }
        catch (NumberFormatException ignored) {}

        String outcome = reservationService.createReservation(
                guestName, address, contactNo, email, nic,
                roomId, checkIn, checkOut,
                specialRequests, loggedInUser.getUserId()
        );

        if (outcome.startsWith("success:")) {
            String newResNo = outcome.split(":")[1];
            resp.sendRedirect(req.getContextPath() +
                    "/reservation?action=view&resNo=" + newResNo +
                    "&success=Reservation created successfully!");
        } else {
            // Return to form keeping all values
            req.setAttribute("errorMessage",    outcome);
            req.setAttribute("guestName",       guestName);
            req.setAttribute("address",         address);
            req.setAttribute("contactNo",       contactNo);
            req.setAttribute("email",           email);
            req.setAttribute("nic",             nic);
            req.setAttribute("checkInDate",     checkIn);
            req.setAttribute("checkOutDate",    checkOut);
            req.setAttribute("specialRequests", specialRequests);
            req.setAttribute("selectedRoomId",  roomId);
            loadFormData(req);
            req.getRequestDispatcher(
                    "/WEB-INF/jsp/reservation_form.jsp").forward(req, resp);
        }
    }

    // ✅ Helper: loads rooms + booked dates map for the form
    private void loadFormData(HttpServletRequest req) {
        List<Room> allRooms = roomService.getAvailableRooms();
        req.setAttribute("availableRooms", allRooms);

        // Build map: roomId -> list of [checkIn, checkOut] strings
        Map<Integer, List<String[]>> bookedDatesMap = new HashMap<>();
        for (Room r : allRooms) {
            List<String[]> booked =
                    roomDAO.getBookedDatesForRoom(r.getRoomId());
            bookedDatesMap.put(r.getRoomId(), booked);
        }
        req.setAttribute("bookedDatesJson",
                gson.toJson(bookedDatesMap));
    }
}