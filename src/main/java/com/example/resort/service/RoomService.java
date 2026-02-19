package com.example.resort.service;

import com.example.resort.dao.RoomDAO;
import com.example.resort.model.Room;

import java.util.List;

public class RoomService {

    private final RoomDAO roomDAO = new RoomDAO();

    public List<Room> getAllRooms() {
        return roomDAO.getAllRooms();
    }

    public List<Room> getAvailableRooms() {
        return roomDAO.getAvailableRooms();
    }

    public Room getRoomById(int id) {
        return roomDAO.getRoomById(id);
    }

    public String addRoom(String roomNumber, String roomType,
                          String priceStr, String capacityStr,
                          String description) {

        // Validation
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
                price, capacity, description, "AVAILABLE");
        boolean saved = roomDAO.addRoom(room);
        return saved ? "success" : "Failed to save room. Please try again.";
    }

    public String updateRoom(int roomId, String roomNumber, String roomType,
                             String priceStr, String capacityStr,
                             String description, String status) {

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

        boolean updated = roomDAO.updateRoom(existing);
        return updated ? "success" : "Failed to update room.";
    }

    public String deleteRoom(int roomId) {
        Room room = roomDAO.getRoomById(roomId);
        if (room == null) return "Room not found.";
        if ("OCCUPIED".equals(room.getStatus()))
            return "Cannot delete an occupied room.";
        boolean deleted = roomDAO.deleteRoom(roomId);
        return deleted ? "success" : "Failed to delete room.";
    }
}