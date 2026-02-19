package com.example.resort.dao;

import com.example.resort.model.Bill;
import com.example.resort.utill.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    private Connection getConnection() {
        return DatabaseConnection.getInstance().getConnection();
    }

    // Save new bill
    public boolean save(Bill bill) {
        String sql = "INSERT INTO bills (reservation_id, room_charge, " +
                "tax_amount, total_amount, payment_status, payment_method) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, bill.getReservationId());
            stmt.setDouble(2, bill.getRoomCharge());
            stmt.setDouble(3, bill.getTaxAmount());
            stmt.setDouble(4, bill.getTotalAmount());
            stmt.setString(5, bill.getPaymentStatus());
            stmt.setString(6, bill.getPaymentMethod());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BillDAO.save error: " + e.getMessage());
            return false;
        }
    }

    // Get bill by reservation ID
    public Bill getByReservationId(int reservationId) {
        String sql = "SELECT b.*, r.reservation_no, r.num_nights, " +
                "g.guest_name, rm.room_number, rm.room_type " +
                "FROM bills b " +
                "JOIN reservations r ON b.reservation_id = r.reservation_id " +
                "JOIN guests g       ON r.guest_id = g.guest_id " +
                "JOIN rooms rm       ON r.room_id  = rm.room_id " +
                "WHERE b.reservation_id = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("BillDAO.getByReservationId error: " + e.getMessage());
        }
        return null;
    }

    // Check if bill already exists for reservation
    public boolean billExists(int reservationId) {
        String sql = "SELECT COUNT(*) FROM bills WHERE reservation_id = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("BillDAO.billExists error: " + e.getMessage());
        }
        return false;
    }

    // Update payment status and method
    public boolean updatePayment(int reservationId,
                                 String method, String status) {
        String sql = "UPDATE bills SET payment_method=?, payment_status=? " +
                "WHERE reservation_id=?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, method);
            stmt.setString(2, status);
            stmt.setInt(3, reservationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BillDAO.updatePayment error: " + e.getMessage());
            return false;
        }
    }

    // Get all bills
    public List<Bill> getAllBills() {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT b.*, r.reservation_no, r.num_nights, " +
                "g.guest_name, rm.room_number, rm.room_type " +
                "FROM bills b " +
                "JOIN reservations r ON b.reservation_id = r.reservation_id " +
                "JOIN guests g       ON r.guest_id = g.guest_id " +
                "JOIN rooms rm       ON r.room_id  = rm.room_id " +
                "ORDER BY b.generated_at DESC";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("BillDAO.getAllBills error: " + e.getMessage());
        }
        return list;
    }

    private Bill mapRow(ResultSet rs) throws SQLException {
        Bill b = new Bill();
        b.setBillId(rs.getInt("bill_id"));
        b.setReservationId(rs.getInt("reservation_id"));
        b.setRoomCharge(rs.getDouble("room_charge"));
        b.setTaxAmount(rs.getDouble("tax_amount"));
        b.setTotalAmount(rs.getDouble("total_amount"));
        b.setPaymentStatus(rs.getString("payment_status"));
        b.setPaymentMethod(rs.getString("payment_method"));

        Timestamp ts = rs.getTimestamp("generated_at");
        if (ts != null) b.setGeneratedAt(ts.toLocalDateTime());

        try { b.setReservationNo(rs.getString("reservation_no")); }
        catch (SQLException ignored) {}
        try { b.setGuestName(rs.getString("guest_name")); }
        catch (SQLException ignored) {}
        try { b.setRoomNumber(rs.getString("room_number")); }
        catch (SQLException ignored) {}
        try { b.setRoomType(rs.getString("room_type")); }
        catch (SQLException ignored) {}
        try { b.setNumNights(rs.getInt("num_nights")); }
        catch (SQLException ignored) {}

        return b;
    }
}