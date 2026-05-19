package com.salon;

/**
 * Customer class - demonstrates ENCAPSULATION (private fields + getters/setters)
 * and INHERITANCE (extends abstract Person class below).
 */
public class Customer extends Person {

    // Encapsulated fields
    private String username;
    private String password;
    private String phone;

    public Customer() {
        super("", "");
    }

    public Customer(String name, String email, String username, String password, String phone) {
        super(name, email);
        this.username = username;
        this.password = password;
        this.phone = phone;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    /** POLYMORPHISM - overrides abstract method from Person */
    @Override
    public String getRole() {
        return "CUSTOMER";
    }

    /** Convert to a single CSV line for file storage */
    public String toFileString() {
        return username + "," + password + "," + getName() + "," + getEmail() + "," + phone;
    }

    /** Build object from a CSV line read from users.txt */
    public static Customer fromFileString(String line) {
        String[] p = line.split(",", -1);
        if (p.length < 5) return null;
        return new Customer(p[2], p[3], p[0], p[1], p[4]);
    }
}

/**
 * ABSTRACTION - abstract base class. Cannot be instantiated.
 * Demonstrates INHERITANCE - Customer extends Person.
 */
abstract class Person {
    private String name;
    private String email;

    public Person(String name, String email) {
        this.name = name;
        this.email = email;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    /** Abstract method - must be implemented by subclasses (POLYMORPHISM) */
    public abstract String getRole();
}

