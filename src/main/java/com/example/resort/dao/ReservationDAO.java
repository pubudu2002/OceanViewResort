package com.example.resort.dao;

import com.example.resort.model.Reservation;
import com.example.resort.utill.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    private Connection getConnection() {
        return DatabaseConnection.getInstance().getConnection();
    }

    // Save new reservation
    public boolean save(Reservation r) {
        String sql = "INSERT INTO reservations (reservation_no, guest_id, room_id, " +
                "check_in_date, check_out_date, num_nights, total_amount, " +
                "status, special_requests, created_by) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, r.getReservationNo());
            stmt.setInt(2, r.getGuestId());
            stmt.setInt(3, r.getRoomId());
            stmt.setDate(4, Date.valueOf(r.getCheckInDate()));
            stmt.setDate(5, Date.valueOf(r.getCheckOutDate()));
            stmt.setInt(6, r.getNumNights());
            stmt.setDouble(7, r.getTotalAmount());
            stmt.setString(8, r.getStatus());
            stmt.setString(9, r.getSpecialRequests());
            stmt.setInt(10, r.getCreatedBy());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ReservationDAO.save error: " + e.getMessage());
            return false;
        }
    }

    // Get all reservations with guest and room info
    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, g.guest_name, g.contact_no, " +
                "rm.room_number, rm.room_type, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN guests g  ON r.guest_id = g.guest_id " +
                "JOIN rooms  rm ON r.room_id  = rm.room_id " +
                "ORDER BY r.created_at DESC";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("ReservationDAO.getAllReservations error: " + e.getMessage());
        }
        return list;
    }

    // Get single reservation by reservation number
    public Reservation getByReservationNo(String resNo) {
        String sql = "SELECT r.*, g.guest_name, g.contact_no, " +
                "rm.room_number, rm.room_type, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN guests g  ON r.guest_id = g.guest_id " +
                "JOIN rooms  rm ON r.room_id  = rm.room_id " +
                "WHERE r.reservation_no = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, resNo);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("ReservationDAO.getByReservationNo error: " + e.getMessage());
        }
        return null;
    }

    // Get by ID
    public Reservation getById(int id) {
        String sql = "SELECT r.*, g.guest_name, g.contact_no, " +
                "rm.room_number, rm.room_type, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN guests g  ON r.guest_id = g.guest_id " +
                "JOIN rooms  rm ON r.room_id  = rm.room_id " +
                "WHERE r.reservation_id = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("ReservationDAO.getById error: " + e.getMessage());
        }
        return null;
    }

    // Check if room is already booked for given dates
    public boolean isRoomBooked(int roomId, LocalDate checkIn,
                                LocalDate checkOut, int excludeId) {
        String sql = "SELECT COUNT(*) FROM reservations " +
                "WHERE room_id = ? " +
                "AND reservation_id != ? " +
                "AND status NOT IN ('CANCELLED','CHECKED_OUT') " +
                "AND check_in_date  < ? " +
                "AND check_out_date > ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            stmt.setInt(2, excludeId);
            stmt.setDate(3, Date.valueOf(checkOut));
            stmt.setDate(4, Date.valueOf(checkIn));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("ReservationDAO.isRoomBooked error: " + e.getMessage());
        }
        return false;
    }

    // Update status
    public boolean updateStatus(int reservationId, String status) {
        String sql = "UPDATE reservations SET status=? WHERE reservation_id=?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, reservationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ReservationDAO.updateStatus error: " + e.getMessage());
            return false;
        }
    }

    // Get last reservation number to generate next one
    public String getLastReservationNo() {
        String sql = "SELECT reservation_no FROM reservations " +
                "ORDER BY reservation_id DESC LIMIT 1";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getString("reservation_no");
        } catch (SQLException e) {
            System.err.println("ReservationDAO.getLastReservationNo error: " + e.getMessage());
        }
        return null;
    }

    private Reservation mapRow(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setReservationId(rs.getInt("reservation_id"));
        r.setReservationNo(rs.getString("reservation_no"));
        r.setGuestId(rs.getInt("guest_id"));
        r.setRoomId(rs.getInt("room_id"));
        r.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        r.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        r.setNumNights(rs.getInt("num_nights"));
        r.setTotalAmount(rs.getDouble("total_amount"));
        r.setStatus(rs.getString("status"));
        r.setSpecialRequests(rs.getString("special_requests"));
        r.setCreatedBy(rs.getInt("created_by"));

        // Joined fields
        try { r.setGuestName(rs.getString("guest_name")); } catch (SQLException ignored) {}
        try { r.setContactNo(rs.getString("contact_no")); } catch (SQLException ignored) {}
        try { r.setRoomNumber(rs.getString("room_number")); } catch (SQLException ignored) {}
        try { r.setRoomType(rs.getString("room_type")); } catch (SQLException ignored) {}
        try { r.setPricePerNight(rs.getDouble("price_per_night")); } catch (SQLException ignored) {}

        return r;
    }
}