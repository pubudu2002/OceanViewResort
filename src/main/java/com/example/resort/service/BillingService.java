package com.example.resort.service;

import com.example.resort.dao.BillDAO;
import com.example.resort.dao.ReservationDAO;
import com.example.resort.model.Bill;
import com.example.resort.model.Reservation;

public class BillingService {

    private final BillDAO        billDAO        = new BillDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    private static final double TAX_RATE = 0.10; // 10% tax

    // Generate bill for a reservation
    public String generateBill(int reservationId) {
        Reservation res = reservationDAO.getById(reservationId);
        if (res == null)
            return "Reservation not found.";
        if ("CANCELLED".equals(res.getStatus()))
            return "Cannot generate bill for a cancelled reservation.";

        // If bill already exists, just return it
        if (billDAO.billExists(reservationId))
            return "exists";

        double roomCharge = res.getTotalAmount();
        double taxAmount  = roomCharge * TAX_RATE;
        double total      = roomCharge + taxAmount;

        Bill bill = new Bill();
        bill.setReservationId(reservationId);
        bill.setRoomCharge(roomCharge);
        bill.setTaxAmount(taxAmount);
        bill.setTotalAmount(total);
        bill.setPaymentStatus("PENDING");
        bill.setPaymentMethod(null);

        boolean saved = billDAO.save(bill);
        return saved ? "success" : "Failed to generate bill.";
    }

    // Get bill by reservation ID
    public Bill getBillByReservationId(int reservationId) {
        return billDAO.getByReservationId(reservationId);
    }

    // Mark bill as paid
    public String markAsPaid(int reservationId, String paymentMethod) {
        if (paymentMethod == null || paymentMethod.trim().isEmpty())
            return "Please select a payment method.";

        Bill bill = billDAO.getByReservationId(reservationId);
        if (bill == null)
            return "Bill not found. Generate bill first.";
        if ("PAID".equals(bill.getPaymentStatus()))
            return "Bill is already marked as paid.";

        boolean updated = billDAO.updatePayment(
                reservationId, paymentMethod, "PAID");

        if (updated) {
            // Mark reservation as checked out
            reservationDAO.updateStatus(reservationId, "CHECKED_OUT");
            return "success";
        }
        return "Failed to process payment.";
    }
}