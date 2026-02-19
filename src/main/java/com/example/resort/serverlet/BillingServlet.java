package com.example.resort.serverlet;

import com.example.resort.model.Bill;
import com.example.resort.model.Reservation;
import com.example.resort.service.BillingService;
import com.example.resort.service.ReservationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    private final BillingService     billingService     = new BillingService();
    private final ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action    = req.getParameter("action");
        String idStr     = req.getParameter("id");

        if (action == null) action = "generate";

        if ("generate".equals(action) && idStr != null) {
            int reservationId = Integer.parseInt(idStr);

            String result = billingService.generateBill(reservationId);

            if ("success".equals(result) || "exists".equals(result)) {
                Bill bill = billingService.getBillByReservationId(reservationId);
                Reservation res = reservationService.getById(reservationId);
                req.setAttribute("bill", bill);
                req.setAttribute("reservation", res);
                req.setAttribute("successMsg",
                        "exists".equals(result) ? null : "Bill generated successfully!");
                req.getRequestDispatcher("/WEB-INF/jsp/bill.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() +
                        "/reservation?action=list&error=" + result);
            }

        } else if ("print".equals(action) && idStr != null) {
            int reservationId = Integer.parseInt(idStr);
            Bill bill = billingService.getBillByReservationId(reservationId);
            Reservation res = reservationService.getById(reservationId);
            req.setAttribute("bill", bill);
            req.setAttribute("reservation", res);
            req.setAttribute("printMode", true);
            req.getRequestDispatcher("/WEB-INF/jsp/bill.jsp").forward(req, resp);

        } else {
            resp.sendRedirect(req.getContextPath() + "/reservation?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr         = req.getParameter("reservationId");
        String paymentMethod = req.getParameter("paymentMethod");

        int reservationId = Integer.parseInt(idStr);

        String result = billingService.markAsPaid(reservationId, paymentMethod);

        if ("success".equals(result)) {
            resp.sendRedirect(req.getContextPath() +
                    "/billing?action=generate&id=" + reservationId +
                    "&success=Payment recorded successfully!");
        } else {
            Bill bill = billingService.getBillByReservationId(reservationId);
            Reservation res = reservationService.getById(reservationId);
            req.setAttribute("bill", bill);
            req.setAttribute("reservation", res);
            req.setAttribute("errorMsg", result);
            req.getRequestDispatcher("/WEB-INF/jsp/bill.jsp").forward(req, resp);
        }
    }
}