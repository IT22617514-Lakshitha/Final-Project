package com.salon;


public class Appointment {

    private String id;
    private String username;
    private String service;
    private String date;   // yyyy-MM-dd
    private String time;   // HH:mm
    private String status; // BOOKED / CANCELLED / COMPLETED

    public Appointment() {} //dc

    public Appointment(String id, String username, String service, //pc
                       String date, String time, String status) {
        this.id = id;
        this.username = username;
        this.service = service;
        this.date = date;
        this.time = time;
        this.status = status;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getService() { return service; }
    public void setService(String service) { this.service = service; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String toFileString() {                                      //converting to csv
        return id + "," + username + "," + service + "," + date + "," + time + "," + status;
    }

    public static Appointment fromFileString(String line) {
        String[] p = line.split(",", -1);
        if (p.length < 6) return null;
        return new Appointment(p[0], p[1], p[2], p[3], p[4], p[5]);
    }
}

