package com.example.resort.model;

public class Guest {
    private int guestId;
    private String guestName;
    private String address;
    private String contactNo;
    private String email;
    private String nic;

    public Guest() {}

    public Guest(int guestId, String guestName, String address,
                 String contactNo, String email, String nic) {
        this.guestId   = guestId;
        this.guestName = guestName;
        this.address   = address;
        this.contactNo = contactNo;
        this.email     = email;
        this.nic       = nic;
    }

    public int getGuestId()                  { return guestId; }
    public void setGuestId(int guestId)      { this.guestId = guestId; }

    public String getGuestName()                   { return guestName; }
    public void setGuestName(String guestName)     { this.guestName = guestName; }

    public String getAddress()                 { return address; }
    public void setAddress(String address)     { this.address = address; }

    public String getContactNo()                   { return contactNo; }
    public void setContactNo(String contactNo)     { this.contactNo = contactNo; }

    public String getEmail()               { return email; }
    public void setEmail(String email)     { this.email = email; }

    public String getNic()             { return nic; }
    public void setNic(String nic)     { this.nic = nic; }
}