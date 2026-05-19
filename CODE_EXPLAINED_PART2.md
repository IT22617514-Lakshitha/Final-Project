# Beauty Salon Booking System — Code Explained (Part 2: Servlets)

Servlets are Java classes that handle HTTP requests (GET/POST) from a browser.
They sit between the JSP view and the data files — this is the **Controller** in MVC.

---

## 6. `LoginServlet.java`

```java
package com.salon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/LoginServlet")
// Line 10: Annotation that maps URL "/LoginServlet" to this class.
// When the form posts to "LoginServlet", Tomcat routes it here.
// No web.xml entry needed — annotation handles registration.

public class LoginServlet extends HttpServlet {
// Line 11: extends HttpServlet = this IS a servlet.
// HttpServlet is provided by the jakarta.servlet-api dependency.

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    // Line 13-15: doPost() handles HTTP POST requests.
    // req = incoming request (form data, session, etc.)
    // resp = outgoing response (redirect, forward, etc.)

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        // Lines 17-18: getParameter() reads form fields by their HTML name attribute.

        if (username == null) username = "";
        if (password == null) password = "";
        // Lines 20-21: null-safety guard in case fields were missing.

        if ("admin".equals(username) && "admin123".equals(password)) {
        // Line 23: hardcoded admin check. "admin".equals(username) is safer
        // than username.equals("admin") because if username is null it won't crash.
            HttpSession session = req.getSession(true);
            // Line 24: get existing session or CREATE one (true = create if none).
            session.setAttribute("username", "admin");
            session.setAttribute("name", "Administrator");
            session.setAttribute("role", "ADMIN");
            // Lines 25-27: store login info in session so all pages can read it.
            resp.sendRedirect("dashboard.jsp");
            // Line 28: redirect browser to dashboard.jsp (HTTP 302).
            return; // Line 29: STOP — don't execute the rest of the method.
        }

        String path = FileHandler.filePath(getServletContext().getRealPath("/"), "users.txt");
        // Line 32: getServletContext().getRealPath("/") = absolute path to webapp root.
        // FileHandler.filePath() appends "data/users.txt" to that path.

        List<String> lines = FileHandler.readAllLines(path);
        // Line 33: read all lines from users.txt into a List.

        for (String l : lines) {
        // Line 35: loop through every line (every user record).
            Customer c = Customer.fromFileString(l);
            // Line 36: parse CSV line → Customer object.
            if (c == null) continue;
            // Line 37: skip blank/malformed lines.
            if (c.getUsername().equals(username) && c.getPassword().equals(password)) {
            // Line 38: compare stored credentials with what user typed.
                HttpSession session = req.getSession(true);
                session.setAttribute("username", c.getUsername());
                session.setAttribute("name", c.getName());
                session.setAttribute("role", "CUSTOMER");
                resp.sendRedirect("dashboard.jsp");
                return;
            }
        }

        req.setAttribute("error", "Invalid username or password.");
        // Line 48: store error message in request scope (visible only for this request).
        req.getRequestDispatcher("login.jsp").forward(req, resp);
        // Line 49: FORWARD back to login.jsp (not a redirect — same request object
        // is reused, so the error attribute is still available in the JSP).
    }
}
```

---

## 7. `RegisterServlet.java`

```java
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name     = safe(req.getParameter("name"));
        String email    = safe(req.getParameter("email"));
        String username = safe(req.getParameter("username"));
        String password = safe(req.getParameter("password"));
        String phone    = safe(req.getParameter("phone"));
        // Lines 17-21: read all 5 form fields and run through safe() helper.

        if (username.isEmpty() || password.isEmpty()) {
        // Line 23: validate that required fields are not empty.
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        String path = FileHandler.filePath(getServletContext().getRealPath("/"), "users.txt");

        List<String> existing = FileHandler.readAllLines(path);
        for (String l : existing) {
            String[] p = l.split(",", -1);
            if (p.length > 0 && p[0].equalsIgnoreCase(username)) {
            // Line 35: p[0] is the username field. equalsIgnoreCase = case-insensitive match.
            // This prevents two users called "Alice" and "alice" from coexisting.
                req.setAttribute("error", "Username already exists. Choose another.");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }
        }

        Customer c = new Customer(name, email, username, password, phone);
        // Line 42: create new Customer object with entered data.
        FileHandler.appendLine(path, c.toFileString());
        // Line 43: convert Customer to CSV line and APPEND to users.txt.

        req.setAttribute("success", "Registration successful! Please login.");
        req.getRequestDispatcher("login.jsp").forward(req, resp);
        // Line 46: forward to login.jsp with a success message.
    }

    private String safe(String s) { return s == null ? "" : s.trim(); }
    // Line 49: helper — if parameter is null return ""; otherwise trim whitespace.
}
```

---

## 8. `BookingServlet.java`

```java
@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        // Line 16: getSession(false) = get EXISTING session only, don't create one.
        if (session == null || session.getAttribute("username") == null) {
        // Line 17: if no session or not logged in → redirect to login.
            resp.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        // Line 22: cast from Object to String (session stores Objects).
        String service  = req.getParameter("service");
        String date     = req.getParameter("date");
        String time     = req.getParameter("time");

        if (service == null || date == null || time == null
                || service.isEmpty() || date.isEmpty() || time.isEmpty()) {
        // Lines 27-28: validate all 3 fields are present and non-empty.
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("booking.jsp").forward(req, resp);
            return;
        }

        String path = FileHandler.filePath(getServletContext().getRealPath("/"), "appointments.txt");
        Appointment a = new Appointment(FileHandler.newId(), username, service, date, time, "BOOKED");
        // Line 35: create Appointment with auto-generated ID, current user, and status "BOOKED".
        FileHandler.appendLine(path, a.toFileString());
        // Line 36: save to appointments.txt.

        resp.sendRedirect("appointments.jsp");
        // Line 38: redirect to appointments list after successful booking.
    }
}
```

---

## 9. `UpdateAppointmentServlet.java`

```java
@WebServlet("/UpdateAppointmentServlet")
public class UpdateAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check (same pattern as BookingServlet)
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect("login.jsp"); return;
        }

        String username = (String) session.getAttribute("username");
        String id      = req.getParameter("id");      // appointment ID from hidden form field
        String service = req.getParameter("service");
        String date    = req.getParameter("date");
        String time    = req.getParameter("time");
        String status  = req.getParameter("status");

        if (id == null || id.isEmpty()) {
        // Line 29: if no ID, nothing to update, redirect away.
            resp.sendRedirect("appointments.jsp"); return;
        }
        if (status == null || status.isEmpty()) status = "BOOKED";
        // Line 33: default status fallback.

        String path = FileHandler.filePath(getServletContext().getRealPath("/"), "appointments.txt");

        // Find the existing appointment in the file
        Appointment existing = null;
        for (String l : FileHandler.readAllLines(path)) {
            Appointment a = Appointment.fromFileString(l);
            if (a != null && a.getId().equals(id)) {
                existing = a; break;
            }
        }
        // Lines 38-44: loop through appointments.txt to find the record with matching id.

        if (existing == null) { resp.sendRedirect("appointments.jsp"); return; }
        // Line 46: appointment not found — redirect.

        boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));

        if (!isAdmin && !existing.getUsername().equals(username)) {
        // Line 54: SECURITY CHECK — a regular customer can only update THEIR OWN appointments.
        // If the logged-in user doesn't own this appointment, block the update.
            resp.sendRedirect("appointments.jsp"); return;
        }

        String finalUsername = existing.getUsername();
        // Line 59: always keep the original owner's username (don't let it be changed).
        String finalStatus = isAdmin ? status : existing.getStatus();
        // Line 60: only ADMIN can change status. Regular users keep their original status.

        Appointment updated = new Appointment(id, finalUsername, service, date, time, finalStatus);
        FileHandler.updateById(path, id, updated.toFileString());
        // Line 63-64: build updated object and rewrite the file.

        resp.sendRedirect("appointments.jsp");
    }
}
```

---

## 10. `DeleteAppointmentServlet.java`

```java
@WebServlet("/DeleteAppointmentServlet")
public class DeleteAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp); // Line 15: GET request → delegate to handle()
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp); // Line 21: POST request → same handler
    }
    // Having both doGet and doPost call handle() means the delete works
    // whether triggered by a link (GET) or a form button (POST).

    private void handle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect("login.jsp"); return;
        }

        String id = req.getParameter("id");
        // Line 31: get appointment ID from URL query string e.g. ?id=1716099600000

        if (id != null && !id.isEmpty()) {
            String path = FileHandler.filePath(getServletContext().getRealPath("/"), "appointments.txt");
            String username = (String) session.getAttribute("username");
            boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));

            if (isAdmin) {
                FileHandler.deleteById(path, id);
                // Line 38: admin can delete ANY appointment directly.
            } else {
                for (String l : FileHandler.readAllLines(path)) {
                    Appointment a = Appointment.fromFileString(l);
                    if (a != null && a.getId().equals(id) && a.getUsername().equals(username)) {
                    // Line 42: SECURITY — customer can only delete their OWN appointment.
                    // Must match both ID AND username.
                        FileHandler.deleteById(path, id);
                        break;
                    }
                }
            }
        }
        resp.sendRedirect("appointments.jsp");
        // Line 49: always redirect back to appointments list after deletion.
    }
}
```
