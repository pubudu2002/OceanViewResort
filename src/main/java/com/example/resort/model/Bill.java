package com.example.resort.model;

import java.time.LocalDateTime;

public class Bill {
    private int billId;
    private int reservationId;
    private double roomCharge;
    private double taxAmount;
    private double totalAmount;
    private String paymentStatus;
    private String paymentMethod;
    private LocalDateTime generatedAt;

    // Display fields
    private String reservationNo;
    private String guestName;
    private String roomNumber;
    private String roomType;
    private int numNights;

    public Bill() {}

    // Getters & Setters
    public int getBillId()                 { return billId; }
    public void setBillId(int billId)      { this.billId = billId; }

    public int getReservationId()                      { return reservationId; }
    public void setReservationId(int reservationId)    { this.reservationId = reservationId; }

    public double getRoomCharge()                  { return roomCharge; }
    public void setRoomCharge(double roomCharge)   { this.roomCharge = roomCharge; }

    public double getTaxAmount()                   { return taxAmount; }
    public void setTaxAmount(double taxAmount)     { this.taxAmount = taxAmount; }

    public double getTotalAmount()                     { return totalAmount; }
    public void setTotalAmount(double totalAmount)     { this.totalAmount = totalAmount; }

    public String getPaymentStatus()                       { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus)     { this.paymentStatus = paymentStatus; }

    public String getPaymentMethod()                       { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod)     { this.paymentMethod = paymentMethod; }

    public LocalDateTime getGeneratedAt()                      { return generatedAt; }
    public void setGeneratedAt(LocalDateTime generatedAt)      { this.generatedAt = generatedAt; }

    // Display fields
    public String getReservationNo()                       { return reservationNo; }
    public void setReservationNo(String reservationNo)     { this.reservationNo = reservationNo; }

    public String getGuestName()                   { return guestName; }
    public void setGuestName(String guestName)     { this.guestName = guestName; }

    public String getRoomNumber()                      { return roomNumber; }
    public void setRoomNumber(String roomNumber)       { this.roomNumber = roomNumber; }

    public String getRoomType()                  { return roomType; }
    public void setRoomType(String roomType)     { this.roomType = roomType; }

    public int getNumNights()                  { return numNights; }
    public void setNumNights(int numNights)    { this.numNights = numNights; }
}