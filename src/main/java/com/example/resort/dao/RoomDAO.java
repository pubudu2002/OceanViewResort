package com.example.resort.dao;

import com.example.resort.model.Room;
import com.example.resort.utill.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    private Connection getConnection() {
        return DatabaseConnection.getInstance().getConnection();
    }

    // Get all rooms
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_number";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) rooms.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("RoomDAO.getAllRooms error: " + e.getMessage());
        }
        return rooms;
    }

    // Get only available rooms
    public List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE status = 'AVAILABLE' ORDER BY room_type";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) rooms.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("RoomDAO.getAvailableRooms error: " + e.getMessage());
        }
        return rooms;
    }

    // Get room by ID
    public Room getRoomById(int roomId) {
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("RoomDAO.getRoomById error: " + e.getMessage());
        }
        return null;
    }

    // Get room by room number
    public Room getRoomByNumber(String roomNumber) {
        String sql = "SELECT * FROM rooms WHERE room_number = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, roomNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("RoomDAO.getRoomByNumber error: " + e.getMessage());
        }
        return null;
    }

    // Add new room
    public boolean addRoom(Room room) {
        String sql = "INSERT INTO rooms (room_number, room_type, price_per_night, " +
                "capacity, description, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setString(2, room.getRoomType());
            stmt.setDouble(3, room.getPricePerNight());
            stmt.setInt(4, room.getCapacity());
            stmt.setString(5, room.getDescription());
            stmt.setString(6, room.getStatus());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RoomDAO.addRoom error: " + e.getMessage());
            return false;
        }
    }

    // Update room
    public boolean updateRoom(Room room) {
        String sql = "UPDATE rooms SET room_number=?, room_type=?, price_per_night=?, " +
                "capacity=?, description=?, status=? WHERE room_id=?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setString(2, room.getRoomType());
            stmt.setDouble(3, room.getPricePerNight());
            stmt.setInt(4, room.getCapacity());
            stmt.setString(5, room.getDescription());
            stmt.setString(6, room.getStatus());
            stmt.setInt(7, room.getRoomId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RoomDAO.updateRoom error: " + e.getMessage());
            return false;
        }
    }

    // Update room status only
    public boolean updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE rooms SET status=? WHERE room_id=?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RoomDAO.updateRoomStatus error: " + e.getMessage());
            return false;
        }
    }

    // Delete room
    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM rooms WHERE room_id=?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RoomDAO.deleteRoom error: " + e.getMessage());
            return false;
        }
    }

    // Map ResultSet row to Room object
    private Room mapRow(ResultSet rs) throws SQLException {
        return new Room(
                rs.getInt("room_id"),
                rs.getString("room_number"),
                rs.getString("room_type"),
                rs.getDouble("price_per_night"),
                rs.getInt("capacity"),
                rs.getString("description"),
                rs.getString("status")
        );
    }
}