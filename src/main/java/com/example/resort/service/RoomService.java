package com.example.resort.service;

import com.example.resort.dao.RoomDAO;
import com.example.resort.model.Room;

import java.time.LocalDate;
import java.util.List;

public class RoomService {

    private final RoomDAO roomDAO = new RoomDAO();

    public List<Room> getAllRooms() {
        return roomDAO.getAllRooms();
    }

    public List<Room> getAvailableRooms() {
        return roomDAO.getAvailableRooms();
    }

    public List<Room> getAvailableRoomsForDates(LocalDate checkIn,
                                                LocalDate checkOut) {
        return roomDAO.getAvailableRoomsForDates(checkIn, checkOut);
    }

    public List<String[]> getBookedDatesForRoom(int roomId) {
        return roomDAO.getBookedDatesForRoom(roomId);
    }

    public Room getRoomById(int id) {
        return roomDAO.getRoomById(id);
    }

    // ✅ Updated: accepts imagePath
    public String addRoom(String roomNumber, String roomType,
                          String priceStr, String capacityStr,
                          String description, String imagePath) {
        if (roomNumber == null || roomNumber.trim().isEmpty())
            return "Room number is required.";
        if (roomDAO.getRoomByNumber(roomNumber.trim()) != null)
            return "Room number " + roomNumber + " already exists.";
        if (roomType == null || roomType.trim().isEmpty())
            return "Room type is required.";

        double price;
        int capacity;
        try {
            price = Double.parseDouble(priceStr);
            if (price <= 0) return "Price must be greater than zero.";
        } catch (NumberFormatException e) {
            return "Invalid price format.";
        }
        try {
            capacity = Integer.parseInt(capacityStr);
            if (capacity <= 0) return "Capacity must be at least 1.";
        } catch (NumberFormatException e) {
            return "Invalid capacity format.";
        }

        Room room = new Room(0, roomNumber.trim(), roomType,
                price, capacity, description,
                "AVAILABLE", imagePath); // ✅
        boolean saved = roomDAO.addRoom(room);
        return saved ? "success" : "Failed to save room.";
    }

    // ✅ Updated: accepts imagePath
    public String updateRoom(int roomId, String roomNumber, String roomType,
                             String priceStr, String capacityStr,
                             String description, String status,
                             String imagePath) {
        Room existing = roomDAO.getRoomById(roomId);
        if (existing == null) return "Room not found.";

        double price;
        int capacity;
        try {
            price    = Double.parseDouble(priceStr);
            capacity = Integer.parseInt(capacityStr);
        } catch (NumberFormatException e) {
            return "Invalid price or capacity.";
        }

        existing.setRoomNumber(roomNumber.trim());
        existing.setRoomType(roomType);
        existing.setPricePerNight(price);
        existing.setCapacity(capacity);
        existing.setDescription(description);
        existing.setStatus(status);

        // ✅ Only update image if a new one was uploaded
        if (imagePath != null && !imagePath.isEmpty()) {
            existing.setImagePath(imagePath);
        }

        boolean updated = roomDAO.updateRoom(existing);
        return updated ? "success" : "Failed to update room.";
    }

    public String deleteRoom(int roomId) {
        Room room = roomDAO.getRoomById(roomId);
        if (room == null) return "Room not found.";
        boolean deleted = roomDAO.deleteRoom(roomId);
        return deleted ? "success" : "Failed to delete room.";
    }
}