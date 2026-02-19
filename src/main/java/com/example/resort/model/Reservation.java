package com.example.resort.model;

import java.time.LocalDate;

public class Reservation {
    private int reservationId;
    private String reservationNo;
    private int guestId;
    private int roomId;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private int numNights;
    private double totalAmount;
    private String status;
    private String specialRequests;
    private int createdBy;

    // For display purposes (joined data)
    private String guestName;
    private String contactNo;
    private String roomNumber;
    private String roomType;
    private double pricePerNight;

    public Reservation() {}

    // Getters & Setters
    public int getReservationId()                      { return reservationId; }
    public void setReservationId(int reservationId)    { this.reservationId = reservationId; }

    public String getReservationNo()                       { return reservationNo; }
    public void setReservationNo(String reservationNo)     { this.reservationNo = reservationNo; }

    public int getGuestId()                { return guestId; }
    public void setGuestId(int guestId)    { this.guestId = guestId; }

    public int getRoomId()               { return roomId; }
    public void setRoomId(int roomId)    { this.roomId = roomId; }

    public LocalDate getCheckInDate()                      { return checkInDate; }
    public void setCheckInDate(LocalDate checkInDate)      { this.checkInDate = checkInDate; }

    public LocalDate getCheckOutDate()                     { return checkOutDate; }
    public void setCheckOutDate(LocalDate checkOutDate)    { this.checkOutDate = checkOutDate; }

    public int getNumNights()                  { return numNights; }
    public void setNumNights(int numNights)    { this.numNights = numNights; }

    public double getTotalAmount()                     { return totalAmount; }
    public void setTotalAmount(double totalAmount)     { this.totalAmount = totalAmount; }

    public String getStatus()              { return status; }
    public void setStatus(String status)   { this.status = status; }

    public String getSpecialRequests()                         { return specialRequests; }
    public void setSpecialRequests(String specialRequests)     { this.specialRequests = specialRequests; }

    public int getCreatedBy()                  { return createdBy; }
    public void setCreatedBy(int createdBy)    { this.createdBy = createdBy; }

    // Display fields
    public String getGuestName()                   { return guestName; }
    public void setGuestName(String guestName)     { this.guestName = guestName; }

    public String getContactNo()                   { return contactNo; }
    public void setContactNo(String contactNo)     { this.contactNo = contactNo; }

    public String getRoomNumber()                      { return roomNumber; }
    public void setRoomNumber(String roomNumber)       { this.roomNumber = roomNumber; }

    public String getRoomType()                  { return roomType; }
    public void setRoomType(String roomType)     { this.roomType = roomType; }

    public double getPricePerNight()                       { return pricePerNight; }
    public void setPricePerNight(double pricePerNight)     { this.pricePerNight = pricePerNight; }
}