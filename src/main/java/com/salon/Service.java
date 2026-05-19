package com.salon;

/**
 * Service model - represents a salon service (haircut, facial, etc.).
 * Stored in services.txt as: id,name,price,duration
 */
public class Service {

    private String id;
    private String name;
    private double price;
    private String duration; // e.g., "30 min"

    public Service() {}

    public Service(String id, String name, double price, String duration) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.duration = duration;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String toFileString() {
        return id + "," + name + "," + price + "," + duration;
    }

    public static Service fromFileString(String line) {
        String[] p = line.split(",", -1);
        if (p.length < 4) return null;
        try {
            return new Service(p[0], p[1], Double.parseDouble(p[2]), p[3]);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}

