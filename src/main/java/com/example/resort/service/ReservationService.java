package com.example.resort.service;

import com.example.resort.dao.GuestDAO;
import com.example.resort.dao.ReservationDAO;
import com.example.resort.dao.RoomDAO;
import com.example.resort.model.Guest;
import com.example.resort.model.Reservation;
import com.example.resort.model.Room;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class ReservationService {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final GuestDAO       guestDAO       = new GuestDAO();
    private final RoomDAO        roomDAO        = new RoomDAO();

    public List<Reservation> getAllReservations() {
        return reservationDAO.getAllReservations();
    }

    public Reservation getByReservationNo(String resNo) {
        return reservationDAO.getByReservationNo(resNo);
    }

    public Reservation getById(int id) {
        return reservationDAO.getById(id);
    }

    // Generate reservation number e.g. RES-2025-0004
    public String generateReservationNo() {
        int year = LocalDate.now().getYear();
        String last = reservationDAO.getLastReservationNo();
        int nextNum = 1;
        if (last != null) {
            try {
                String[] parts = last.split("-");
                nextNum = Integer.parseInt(parts[2]) + 1;
            } catch (Exception ignored) {}
        }
        return String.format("RES-%d-%04d", year, nextNum);
    }

    // Main method to create a reservation
    public String createReservation(
            String guestName, String address, String contactNo,
            String email, String nic,
            int roomId, String checkInStr, String checkOutStr,
            String specialRequests, int createdBy) {

        // --- Validate inputs ---
        if (guestName == null || guestName.trim().isEmpty())
            return "Guest name is required.";
        if (address == null || address.trim().isEmpty())
            return "Address is required.";
        if (contactNo == null || contactNo.trim().isEmpty())
            return "Contact number is required.";
        if (!contactNo.trim().matches("^[0-9]{10}$"))
            return "Contact number must be 10 digits.";
        if (roomId <= 0)
            return "Please select a room.";

        // --- Parse dates ---
        LocalDate checkIn, checkOut;
        try {
            checkIn  = LocalDate.parse(checkInStr);
            checkOut = LocalDate.parse(checkOutStr);
        } catch (Exception e) {
            return "Invalid date format.";
        }

        if (!checkIn.isBefore(checkOut))
            return "Check-out date must be after check-in date.";
        if (checkIn.isBefore(LocalDate.now()))
            return "Check-in date cannot be in the past.";

        // --- Check room availability ---
        Room room = roomDAO.getRoomById(roomId);
        if (room == null)
            return "Selected room does not exist.";
        if (!"AVAILABLE".equals(room.getStatus()))
            return "Room " + room.getRoomNumber() + " is not available.";
        if (reservationDAO.isRoomBooked(roomId, checkIn, checkOut, 0))
            return "Room " + room.getRoomNumber() +
                    " is already booked for the selected dates.";

        // --- Calculate cost ---
        long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
        double total = nights * room.getPricePerNight();

        // --- Save or find guest ---
        Guest guest = null;
        if (nic != null && !nic.trim().isEmpty()) {
            guest = guestDAO.findByNic(nic.trim());
        }
        if (guest == null) {
            Guest newGuest = new Guest(0, guestName.trim(), address.trim(),
                    contactNo.trim(), email, nic);
            int guestId = guestDAO.addGuest(newGuest);
            if (guestId == -1) return "Failed to save guest details.";
            newGuest.setGuestId(guestId);
            guest = newGuest;
        }

        // --- Build reservation ---
        Reservation res = new Reservation();
        res.setReservationNo(generateReservationNo());
        res.setGuestId(guest.getGuestId());
        res.setRoomId(roomId);
        res.setCheckInDate(checkIn);
        res.setCheckOutDate(checkOut);
        res.setNumNights((int) nights);
        res.setTotalAmount(total);
        res.setStatus("CONFIRMED");
        res.setSpecialRequests(specialRequests);
        res.setCreatedBy(createdBy);

        boolean saved = reservationDAO.save(res);
        if (!saved) return "Failed to save reservation. Please try again.";

        // Update room status to OCCUPIED
        roomDAO.updateRoomStatus(roomId, "OCCUPIED");

        return "success:" + res.getReservationNo();
    }

    public String cancelReservation(int reservationId) {
        Reservation res = reservationDAO.getById(reservationId);
        if (res == null) return "Reservation not found.";
        if ("CANCELLED".equals(res.getStatus()))
            return "Reservation is already cancelled.";

        boolean updated = reservationDAO.updateStatus(reservationId, "CANCELLED");
        if (updated) {
            roomDAO.updateRoomStatus(res.getRoomId(), "AVAILABLE");
            return "success";
        }
        return "Failed to cancel reservation.";
    }
}