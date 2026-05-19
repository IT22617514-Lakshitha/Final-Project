package com.salon;

/**
 * Review model - customer review for a service.
 * Stored in reviews.txt as: id,username,service,rating,comment
 */
public class Review {

    private String id;
    private String username;
    private String service;
    private int rating;     // 1..5
    private String comment;

    public Review() {}

    public Review(String id, String username, String service, int rating, String comment) {
        this.id = id;
        this.username = username;
        this.service = service;
        this.rating = rating;
        this.comment = comment;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getService() { return service; }
    public void setService(String service) { this.service = service; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public String toFileString() {
        // sanitize commas in comment
        String safe = comment == null ? "" : comment.replace(",", " ");
        return id + "," + username + "," + service + "," + rating + "," + safe;
    }

    public static Review fromFileString(String line) {
        String[] p = line.split(",", -1);
        if (p.length < 5) return null;
        try {
            return new Review(p[0], p[1], p[2], Integer.parseInt(p[3]), p[4]);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}

