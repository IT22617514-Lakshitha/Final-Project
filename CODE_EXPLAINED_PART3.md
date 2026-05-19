# Beauty Salon Booking System — Code Explained (Part 3: JSP Pages)

JSP (JavaServer Pages) are HTML files that can contain embedded Java code
inside `<% %>` tags. Tomcat compiles them into Servlets at runtime.
These are the **View** layer in MVC.

---

## JSP Tag Reference

| Tag | Meaning |
|-----|---------|
| `<%@ page ... %>` | Page directive — sets content type, imports |
| `<% Java code %>` | Scriptlet — runs Java code, no output |
| `<%= expression %>` | Expression — evaluates and prints the result |
| `<%-- comment --%>` | JSP comment — not sent to browser |

---

## 11. `index.jsp` — Home / Landing Page

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Line 1: Tells Tomcat this page outputs HTML with UTF-8 encoding,
     written in Java. This must be the FIRST line. --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Beauty Salon | Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%-- Viewport meta makes the page responsive on mobile screens --%>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- Line 8: Load Bootstrap 5 CSS from CDN.
         Bootstrap gives us grid, cards, buttons, navbar etc. for free. --%>

    <style>
        body { background: linear-gradient(135deg,#fff0f6 0%,#ffe5ec 100%); min-height: 100vh; }
        /* Line 10: Pink gradient background. linear-gradient = CSS gradient.
           min-height:100vh ensures the body covers the full screen height. */
        .hero { padding: 80px 0; }
        .hero h1 { font-weight: 700; color: #c71585; }
        .feature-card { border:none; border-radius: 18px; box-shadow: 0 6px 18px rgba(199,21,133,.08); }
        /* feature-card: no border, rounded corners (18px), subtle pink shadow */
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold text-pink" href="index.jsp" style="color:#c71585;">💄 Beauty Salon</a>
        <%-- Brand logo/link. fw-bold = font-weight bold. --%>
        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#nav">
            <%-- Line 21-22: Hamburger button shown on small screens.
                 data-bs-toggle and data-bs-target are Bootstrap JS attributes. --%>
            <span class="navbar-toggler-icon"></span>
        </button>
        <div id="nav" class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <%-- ms-auto = margin-start auto = push nav links to the RIGHT --%>
                <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="services.jsp">Services</a></li>
                <li class="nav-item"><a class="nav-link" href="reviews.jsp">Reviews</a></li>
                <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
                <li class="nav-item">
                    <a class="btn btn-sm btn-outline-danger ms-2" href="register.jsp">Register</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- HERO SECTION -->
<section class="hero text-center">
    <div class="container">
        <h1 class="display-4">Welcome to Glamour Beauty Salon</h1>
        <p class="lead text-muted">Book your favorite beauty treatments in just a few clicks.</p>
        <a href="register.jsp" class="btn btn-danger btn-lg me-2">Get Started</a>
        <a href="services.jsp" class="btn btn-outline-dark btn-lg">View Services</a>
    </div>
</section>

<!-- FEATURE CARDS -->
<section class="container pb-5">
    <div class="row g-4">     <%-- g-4 = gap between grid columns --%>
        <div class="col-md-4">    <%-- col-md-4 = 4/12 width on medium+ screens (3 columns) --%>
            <div class="card feature-card p-4 text-center h-100">
                <h4>💇 Professional Stylists</h4>
                <p class="text-muted">Trained experts ready to pamper you.</p>
            </div>
        </div>
        <%-- Two more identical col-md-4 cards for "Easy Online Booking" and "Trusted Reviews" --%>
    </div>
</section>

<!-- FOOTER -->
<footer class="bg-white text-center py-3 border-top">
    <small class="text-muted">© <%= java.time.Year.now() %> Glamour Beauty Salon</small>
    <%-- Line 71: <%= java.time.Year.now() %> outputs the current year dynamically
         so the copyright year is always correct without editing the file. --%>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<%-- Line 74: Bootstrap JS (for the navbar toggle hamburger button). Must be at bottom. --%>
</body>
</html>
```

---

## 12. `login.jsp` — Login Form

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- ... HTML head with Bootstrap ... -->
<body>

<%-- Error/Success alert display using JSP expressions --%>
<% if (request.getAttribute("error") != null) { %>
    <%-- Line 27: If LoginServlet forwarded with an "error" attribute set... --%>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <%-- Line 28: display the error message in a red Bootstrap alert box --%>
<% } %>
<% if (request.getAttribute("success") != null) { %>
    <%-- Line 30: If RegisterServlet forwarded with a "success" attribute... --%>
    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
<% } %>

<form method="post" action="LoginServlet">
    <%-- Line 34: method="post" = submit as POST request.
         action="LoginServlet" = Tomcat routes to the @WebServlet("/LoginServlet") class. --%>
    <div class="mb-3">
        <label class="form-label">Username</label>
        <input type="text" name="username" class="form-control" required>
        <%-- name="username" = servlet reads this via req.getParameter("username") --%>
    </div>
    <div class="mb-3">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="form-control" required>
        <%-- type="password" = browser hides the typed characters --%>
    </div>
    <button type="submit" class="btn btn-danger w-100">Login</button>
    <%-- w-100 = width 100% (full-width button) --%>
</form>
</body>
```

---

## 13. `register.jsp` — Registration Form

Similar structure to login.jsp but with 5 fields:
`name`, `email`, `phone`, `username`, `password`.
The form posts to `RegisterServlet`.

Key difference: no success message block — on success the servlet
forwards to `login.jsp` with the success attribute instead.

---

## 14. `dashboard.jsp` — Post-Login Home Page

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Lines 2-9: SCRIPTLET at very top — runs before any HTML is sent.
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
        // If not logged in, redirect. "return" stops rendering the rest of the page.
    }
    String name = (String) session.getAttribute("name");
    // Read the logged-in user's display name from session.
    boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
    // true if the logged-in user has admin role.
%>

<!-- Navbar shows different links for admin vs customer -->
<% if (isAdmin) { %>
    <%-- Line 25: if admin, show admin-only nav links --%>
    <li><a href="users.jsp">Manage Users</a></li>
    <li><a href="appointments.jsp">All Appointments</a></li>
    <li><a href="services.jsp">Manage Services</a></li>
    <li><a href="reviews.jsp">All Reviews</a></li>
<% } else { %>
    <%-- Line 30: if customer, show customer nav links --%>
    <li><a href="booking.jsp">Book</a></li>
    <li><a href="appointments.jsp">My Appointments</a></li>
<% } %>

<h2>Welcome, <%= name %> 👋</h2>
<%-- Line 44: prints the user's name from session --%>

<!-- Dashboard tiles: different set for admin vs customer -->
<% if (!isAdmin) { %>
    <%-- 4 tiles: Book Appointment, My Appointments, Services, Reviews --%>
<% } else { %>
    <%-- 4 tiles: Manage Users, All Appointments, Manage Services, All Reviews --%>
<% } %>
```

---

## 15. `booking.jsp` — New Appointment Form

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="java.util.*, com.salon.*" %>
<%-- Line 1: import="..." imports Java classes for use in scriptlets.
     java.util.* = List, ArrayList etc.
     com.salon.* = FileHandler, Service etc. --%>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    String svcPath = FileHandler.filePath(application.getRealPath("/"), "services.txt");
    // Line 7: application = ServletContext object. getRealPath("/") = webapp root.
    List<String> svcLines = FileHandler.readAllLines(svcPath);
    // Line 8: read all services from services.txt for the dropdown.
%>

<!-- Service dropdown populated dynamically from services.txt -->
<select name="service" class="form-select" required>
    <option value="">-- Select Service --</option>
    <%
        for (String l : svcLines) {        // loop through each line
            Service s = Service.fromFileString(l);  // parse CSV → Service object
            if (s == null) continue;       // skip invalid lines
    %>
        <option value="<%= s.getName() %>"><%= s.getName() %> ($<%= s.getPrice() %>)</option>
        <%-- Line 49: dynamically generate one <option> per service.
             value = service name (stored in appointments.txt).
             Display text includes price. --%>
    <% } %>
</select>

<input type="date" name="date" class="form-control" required>
<%-- type="date" = browser shows a date picker widget --%>

<input type="time" name="time" class="form-control" required>
<%-- type="time" = browser shows a time picker widget --%>

<button type="submit" class="btn btn-danger w-100">Book Now</button>
<%-- Submits POST to BookingServlet --%>
```

---

## 16. `appointments.jsp` — View / Manage Appointments

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="java.util.*, com.salon.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    String username = (String) session.getAttribute("username");
    boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
    String path = FileHandler.filePath(application.getRealPath("/"), "appointments.txt");
    List<String> lines = FileHandler.readAllLines(path);
    // Lines 2-11: load ALL appointments from file.
%>

<!-- Table title changes based on role -->
<h3><%= isAdmin ? "All Customer Appointments" : "My Appointments" %></h3>
<%-- Line 36: ternary operator in JSP expression --%>

<!-- Table header: admin sees extra "Customer" column -->
<% if (isAdmin) { %><th>Customer</th><% } %>

<!-- Table body: loop through all appointments -->
<%
    int i = 1;
    boolean any = false;
    for (String l : lines) {
        Appointment a = Appointment.fromFileString(l);
        if (a == null) continue;
        if (!isAdmin && !a.getUsername().equals(username)) continue;
        // Line 60: FILTER — if not admin, skip rows that don't belong to this user.
        any = true;
%>
    <tr>
        <td><%= i++ %></td>
        <%-- i++ prints current value then increments it (row number counter) --%>
        <% if (isAdmin) { %><td><%= a.getUsername() %></td><% } %>
        <td><%= a.getService() %></td>
        <td><%= a.getDate() %></td>
        <td><%= a.getTime() %></td>
        <td><span class="badge bg-info text-dark"><%= a.getStatus() %></span></td>
        <td>
            <a href="updateAppointment.jsp?id=<%= a.getId() %>" class="btn btn-sm btn-warning">Update</a>
            <%-- Passes appointment ID in URL query string: ?id=1716... --%>
            <a href="DeleteAppointmentServlet?id=<%= a.getId() %>"
               onclick="return confirm('Cancel this appointment?');">Cancel</a>
            <%-- onclick confirm = browser shows popup before deleting --%>
        </td>
    </tr>
<% } %>
<% if (!any) { %>
    <tr><td colspan="6" class="text-center text-muted">No appointments yet.</td></tr>
    <%-- Line 79: if no rows were displayed, show a "nothing here" message --%>
<% } %>
```

---

## 17. `updateAppointment.jsp` — Edit Appointment Form

```jsp
<%
    // Lines 2-25: SCRIPTLET before HTML output.
    String id = request.getParameter("id");
    // Read ?id=... from the URL.
    boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
    Appointment found = null;

    if (id != null) {
        String path = FileHandler.filePath(application.getRealPath("/"), "appointments.txt");
        for (String l : FileHandler.readAllLines(path)) {
            Appointment a = Appointment.fromFileString(l);
            if (a != null && a.getId().equals(id)
                    && (isAdmin || a.getUsername().equals(username))) {
                // Security: user can only edit their own appointment (or admin can edit any)
                found = a; break;
            }
        }
    }
    if (found == null) { response.sendRedirect("appointments.jsp"); return; }
    // If ID not found or user doesn't own it, redirect away.
%>

<form method="post" action="UpdateAppointmentServlet">
    <input type="hidden" name="id" value="<%= found.getId() %>">
    <%-- hidden input carries the appointment ID to the servlet invisibly --%>

    <!-- Service dropdown pre-selected to current service -->
    <% for (String l : svcLines) {
           Service s = Service.fromFileString(l);
           if (s == null) continue;
           String sel = s.getName().equals(found.getService()) ? "selected" : "";
           // Line 64: if this service matches the current booking, mark it "selected"
    %>
        <option value="<%= s.getName() %>" <%= sel %>><%= s.getName() %></option>
    <% } %>

    <!-- Date/Time inputs pre-filled with existing values -->
    <input type="date" name="date" value="<%= found.getDate() %>" required>
    <input type="time" name="time" value="<%= found.getTime() %>" required>

    <!-- Status: admin gets a dropdown, customer sees it as read-only -->
    <% if (isAdmin) { %>
        <select name="status" class="form-select">
            <% String[] sts = {"BOOKED","COMPLETED","CANCELLED"};
               for (String s : sts) {
                   String sel = s.equals(found.getStatus()) ? "selected" : "";
            %>
                <option <%= sel %>><%= s %></option>
            <% } %>
        </select>
    <% } else { %>
        <input type="text" value="<%= found.getStatus() %>" disabled>
        <%-- disabled = shown but not editable --%>
        <input type="hidden" name="status" value="<%= found.getStatus() %>">
        <%-- hidden field passes the unchanged status to the servlet --%>
    <% } %>
</form>
```

---

## 18. `services.jsp` — Services CRUD (Inline, No Separate Servlet)

This JSP handles all CRUD operations for services directly, without a servlet.
The form posts back to itself (`action="services.jsp"`) with an `action` parameter.

```jsp
<%
    String action = request.getParameter("action");
    // "add", "update", or "delete" — determines which CRUD operation to run.
    boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));

    if (isAdmin) {
        if ("add".equals(action)) {
            // Read form fields, create new Service, append to services.txt
            Service s = new Service(FileHandler.newId(), name, Double.parseDouble(price), duration);
            FileHandler.appendLine(path, s.toFileString());
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            FileHandler.deleteById(path, id);
            // Remove the line with matching id from services.txt
        } else if ("update".equals(action)) {
            // Read form fields, build updated Service, call updateById
            FileHandler.updateById(path, id, s.toFileString());
        }
    }

    // After any action, re-read the file to get fresh data for display.
    List<String> lines = FileHandler.readAllLines(path);

    // Check if ?edit=<id> in URL — load that service for the edit form
    String editId = request.getParameter("edit");
    Service editing = null;
    // If editing != null, the "Add" form transforms into an "Update" form.
%>

<!-- Admin-only form (add/edit) -->
<% if (isAdmin) { %>
    <form method="post" action="services.jsp" class="row g-2">
        <input type="hidden" name="action" value="<%= editing != null ? "update" : "add" %>">
        <%-- Tells the scriptlet above which branch to run --%>
        <% if (editing != null) { %>
            <input type="hidden" name="id" value="<%= editing.getId() %>">
        <% } %>
        <input type="text" name="name" value="<%= editing != null ? editing.getName() : "" %>" required>
        <input type="number" name="price" value="<%= editing != null ? editing.getPrice() : "" %>" required>
        <input type="text" name="duration" value="<%= editing != null ? editing.getDuration() : "" %>">
        <button><%= editing != null ? "Save" : "Add" %></button>
    </form>
<% } %>

<!-- Display all services as cards -->
<% for (String l : lines) {
       Service s = Service.fromFileString(l);
       if (s == null) continue;
%>
    <div class="card">
        <h5><%= s.getName() %></h5>
        <p>Duration: <%= s.getDuration() %></p>
        <h4>$<%= s.getPrice() %></h4>
        <% if (isAdmin) { %>
            <a href="services.jsp?edit=<%= s.getId() %>">Edit</a>
            <%-- Reloads the page with ?edit=id — triggers the edit form to appear --%>
            <a href="services.jsp?action=delete&id=<%= s.getId() %>"
               onclick="return confirm('Delete this service?');">Delete</a>
        <% } %>
    </div>
<% } %>
```

---

## 19. `reviews.jsp` — Reviews CRUD (Inline)

Same pattern as services.jsp. Key differences:
- **Anyone logged in** (not just admin) can add/update their OWN reviews.
- **Admin** can delete any review; customers can only delete their own.
- Before deleting/updating, code verifies `r.getUsername().equals(currentUser)`.

```jsp
if ("delete".equals(action)) {
    // Check ownership before deleting
    for (String l : all) {
        Review r = Review.fromFileString(l);
        if (r != null && r.getId().equals(id)
                && (isAdmin || r.getUsername().equals(currentUser))) {
            FileHandler.deleteById(path, id);  // only runs if owner OR admin
            break;
        }
    }
}
```

Stars are rendered with a Java loop:
```jsp
<% for (int i = 0; i < r.getRating(); i++) { %>★<% } %>
<%-- Prints ★ once for each rating point (e.g. 4 stars → ★★★★) --%>
```

---

## 20. `logout.jsp` — Session Termination

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.invalidate();
    // Line 3: destroy the session object and all its attributes.
    // The user is now logged out — session.getAttribute("username") returns null.
    response.sendRedirect("index.jsp");
    // Line 4: redirect to the home page.
%>
```
Only 6 lines — the entire logout is handled in a scriptlet with no HTML output.

---

## 21. Data Flow Summary

```
Browser → HTTP Request
    ↓
Tomcat routes URL to correct Servlet or JSP
    ↓
Servlet reads/writes .txt files via FileHandler
    ↓
Servlet redirects or forwards to JSP
    ↓
JSP reads session/request attributes, renders HTML
    ↓
Browser receives HTML response
```

## 22. OOP Concepts — Where Exactly

| Concept | File | Line(s) | Description |
|---------|------|---------|-------------|
| **Encapsulation** | All model classes | `private` fields + getters/setters | Data hidden, accessed only via methods |
| **Inheritance** | `Customer.java` | `class Customer extends Person` | Customer inherits name, email, and abstract method |
| **Abstraction** | `Customer.java` | `abstract class Person` | Person cannot be instantiated; forces subclasses to implement `getRole()` |
| **Polymorphism** | `Customer.java` | `@Override getRole()` | Customer provides its own version of the abstract method |
| **File I/O** | `FileHandler.java` | All methods | `BufferedReader`/`BufferedWriter` for reading/writing `.txt` files |
| **MVC Pattern** | Whole project | — | JSP=View, Servlet=Controller, Java classes + FileHandler=Model |
