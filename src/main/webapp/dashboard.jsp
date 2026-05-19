<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String name = (String) session.getAttribute("name");
    boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | Beauty Salon</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body{background:#fff0f6;} .tile{border-radius:16px;}</style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="dashboard.jsp" style="color:#c71585;">💄 Beauty Salon</a>
        <ul class="navbar-nav ms-auto">
            <% if (isAdmin) { %>
                <li class="nav-item"><a class="nav-link" href="users.jsp">Manage Users</a></li>
                <li class="nav-item"><a class="nav-link" href="appointments.jsp">All Appointments</a></li>
                <li class="nav-item"><a class="nav-link" href="services.jsp">Manage Services</a></li>
                <li class="nav-item"><a class="nav-link" href="reviews.jsp">All Reviews</a></li>
            <% } else { %>
                <li class="nav-item"><a class="nav-link" href="booking.jsp">Book</a></li>
                <li class="nav-item"><a class="nav-link" href="appointments.jsp">My Appointments</a></li>
                <li class="nav-item"><a class="nav-link" href="services.jsp">Services</a></li>
                <li class="nav-item"><a class="nav-link" href="reviews.jsp">Reviews</a></li>
            <% } %>
            <li class="nav-item">
                <a class="btn btn-sm btn-outline-danger ms-2" href="logout.jsp">Logout</a>
            </li>
        </ul>
    </div>
</nav>

<div class="container py-5">
    <h2 class="mb-4">Welcome, <%= name %> 👋</h2>
    <div class="row g-4">
        <% if (!isAdmin) { %>
        <div class="col-md-3">
            <a class="text-decoration-none" href="booking.jsp">
                <div class="card tile shadow-sm border-0 p-4 text-center">
                    <h5>📅 Book Appointment</h5>
                    <p class="text-muted small mb-0">Reserve a slot</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a class="text-decoration-none" href="appointments.jsp">
                <div class="card tile shadow-sm border-0 p-4 text-center">
                    <h5>📋 My Appointments</h5>
                    <p class="text-muted small mb-0">View / Update / Delete</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a class="text-decoration-none" href="services.jsp">
                <div class="card tile shadow-sm border-0 p-4 text-center">
                    <h5>💅 Services</h5>
                    <p class="text-muted small mb-0">Browse services</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a class="text-decoration-none" href="reviews.jsp">
                <div class="card tile shadow-sm border-0 p-4 text-center">
                    <h5>⭐ Reviews</h5>
                    <p class="text-muted small mb-0">Add / Read reviews</p>
                </div>
            </a>
        </div>
        </div>
        <div class="col-md-12 mt-4 text-center">
            <hr>
            <h5 class="text-danger mb-3">Danger Zone</h5>
            <a href="DeleteAccountServlet" class="btn btn-outline-danger" onclick="return confirm('Are you sure you want to permanently delete your account? This action cannot be undone and will delete all your appointments and reviews.');">Delete My Account</a>
        </div>
        <% } else { %>
        <div class="col-md-3">
            <a class="text-decoration-none" href="users.jsp">
                <div class="card tile shadow-sm border-0 p-4 text-center">
                    <h5>👥 Manage Users</h5>
                    <p class="text-muted small mb-0">View / Delete customers</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a class="text-decoration-none" href="appointments.jsp">
                <div class="card tile shadow-sm border-0 p-4 text-center">
                    <h5>📋 All Appointments</h5>
                    <p class="text-muted small mb-0">Manage all bookings</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a class="text-decoration-none" href="services.jsp">
                <div class="card tile shadow-sm border-0 p-4 text-center">
                    <h5>💅 Manage Services</h5>
                    <p class="text-muted small mb-0">Edit services catalog</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a class="text-decoration-none" href="reviews.jsp">
                <div class="card tile shadow-sm border-0 p-4 text-center">
                    <h5>⭐ All Reviews</h5>
                    <p class="text-muted small mb-0">Moderate reviews</p>
                </div>
            </a>
        </div>
        <% } %>
    </div>
</div>

</body>
</html>
