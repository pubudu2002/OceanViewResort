package com.example.resort.dao;

import com.example.resort.model.Room;
import com.example.resort.utill.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    private Connection getConnection() {
        return DatabaseConnection.getInstance().getConnection();
    }

    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_number";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) rooms.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("RoomDAO.getAllRooms: " + e.getMessage());
        }
        return rooms;
    }

    public List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE status != 'MAINTENANCE' " +
                "ORDER BY room_type, room_number";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) rooms.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("RoomDAO.getAvailableRooms: " + e.getMessage());
        }
        return rooms;
    }

    public List<Room> getAvailableRoomsForDates(LocalDate checkIn,
                                                LocalDate checkOut) {
        List<Room> rooms = new ArrayList<>();
        String sql =
                "SELECT * FROM rooms " +
                        "WHERE status != 'MAINTENANCE' " +
                        "AND room_id NOT IN ( " +
                        "  SELECT room_id FROM reservations " +
                        "  WHERE status NOT IN ('CANCELLED','CHECKED_OUT') " +
                        "  AND check_in_date  < ? " +
                        "  AND check_out_date > ? " +
                        ") ORDER BY room_type, room_number";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(checkOut));
            stmt.setDate(2, Date.valueOf(checkIn));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) rooms.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("RoomDAO.getAvailableRoomsForDates: "
                    + e.getMessage());
        }
        return rooms;
    }

    public List<String[]> getBookedDatesForRoom(int roomId) {
        List<String[]> bookedDates = new ArrayList<>();
        String sql =
                "SELECT check_in_date, check_out_date " +
                        "FROM reservations " +
                        "WHERE room_id = ? " +
                        "AND status NOT IN ('CANCELLED','CHECKED_OUT') " +
                        "AND check_out_date >= CURDATE() " +
                        "ORDER BY check_in_date";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                bookedDates.add(new String[]{
                        rs.getDate("check_in_date").toString(),
                        rs.getDate("check_out_date").toString()
                });
            }
        } catch (SQLException e) {
            System.err.println("RoomDAO.getBookedDatesForRoom: "
                    + e.getMessage());
        }
        return bookedDates;
    }

    public Room getRoomById(int roomId) {
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("RoomDAO.getRoomById: " + e.getMessage());
        }
        return null;
    }

    public Room getRoomByNumber(String roomNumber) {
        String sql = "SELECT * FROM rooms WHERE room_number = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, roomNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("RoomDAO.getRoomByNumber: " + e.getMessage());
        }
        return null;
    }

    public boolean addRoom(Room room) {
        String sql = "INSERT INTO rooms (room_number, room_type, " +
                "price_per_night, capacity, description, " +
                "status, image_path) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setString(2, room.getRoomType());
            stmt.setDouble(3, room.getPricePerNight());
            stmt.setInt(4, room.getCapacity());
            stmt.setString(5, room.getDescription());
            stmt.setString(6, room.getStatus());
            stmt.setString(7, room.getImagePath());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RoomDAO.addRoom: " + e.getMessage());
            return false;
        }
    }

    public boolean updateRoom(Room room) {
        String sql = "UPDATE rooms SET room_number=?, room_type=?, " +
                "price_per_night=?, capacity=?, description=?, " +
                "status=?, image_path=? WHERE room_id=?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setString(2, room.getRoomType());
            stmt.setDouble(3, room.getPricePerNight());
            stmt.setInt(4, room.getCapacity());
            stmt.setString(5, room.getDescription());
            stmt.setString(6, room.getStatus());
            stmt.setString(7, room.getImagePath());
            stmt.setInt(8, room.getRoomId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RoomDAO.updateRoom: " + e.getMessage());
            return false;
        }
    }

    public boolean updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE rooms SET status=? WHERE room_id=?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RoomDAO.updateRoomStatus: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM rooms WHERE room_id=?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RoomDAO.deleteRoom: " + e.getMessage());
            return false;
        }
    }

    private Room mapRow(ResultSet rs) throws SQLException {
        return new Room(
                rs.getInt("room_id"),
                rs.getString("room_number"),
                rs.getString("room_type"),
                rs.getDouble("price_per_night"),
                rs.getInt("capacity"),
                rs.getString("description"),
                rs.getString("status"),
                rs.getString("image_path")
        );
    }

}
