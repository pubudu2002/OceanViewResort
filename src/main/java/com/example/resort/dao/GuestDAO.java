package com.example.resort.dao;

import com.example.resort.model.Guest;
import com.example.resort.utill.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuestDAO {

    private Connection getConnection() {
        return DatabaseConnection.getInstance().getConnection();
    }

    public int addGuest(Guest guest) {
        String sql = "INSERT INTO guests (guest_name, address, contact_no, email, nic) " +
                "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = getConnection()
                .prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, guest.getGuestName());
            stmt.setString(2, guest.getAddress());
            stmt.setString(3, guest.getContactNo());
            stmt.setString(4, guest.getEmail());
            stmt.setString(5, guest.getNic());
            stmt.executeUpdate();

            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);

        } catch (SQLException e) {
            System.err.println("GuestDAO.addGuest error: " + e.getMessage());
        }
        return -1;
    }

    public Guest findByNic(String nic) {
        String sql = "SELECT * FROM guests WHERE nic = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, nic);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("GuestDAO.findByNic error: " + e.getMessage());
        }
        return null;
    }

    public Guest getGuestById(int id) {
        String sql = "SELECT * FROM guests WHERE guest_id = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("GuestDAO.getGuestById error: " + e.getMessage());
        }
        return null;
    }

    public List<Guest> getAllGuests() {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM guests ORDER BY guest_name";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("GuestDAO.getAllGuests error: " + e.getMessage());
        }
        return list;
    }

    private Guest mapRow(ResultSet rs) throws SQLException {
        return new Guest(
                rs.getInt("guest_id"),
                rs.getString("guest_name"),
                rs.getString("address"),
                rs.getString("contact_no"),
                rs.getString("email"),
                rs.getString("nic")
        );
    }
}