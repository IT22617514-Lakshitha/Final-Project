<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, com.salon.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
    String path = FileHandler.filePath(application.getRealPath("/"), "appointments.txt");
    List<String> lines = FileHandler.readAllLines(path);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Appointments</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body{background:#fff0f6;}</style>
</head>
<body>

<nav class="navbar navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="dashboard.jsp" style="color:#c71585;">💄 Beauty Salon</a>
        <div>
            <% if (!isAdmin) { %>
            <a href="booking.jsp" class="btn btn-danger btn-sm">+ New Booking</a>
            <% } %>
            <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm">← Dashboard</a>
        </div>
    </div>
</nav>

<div class="container py-5">
    <h3 class="mb-4"><%= isAdmin ? "All Customer Appointments" : "My Appointments" %></h3>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <% if (isAdmin) { %><th>Customer</th><% } %>
                            <th>Service</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        int i = 1;
                        boolean any = false;
                        for (String l : lines) {
                            Appointment a = Appointment.fromFileString(l);
                            if (a == null) continue;
                            if (!isAdmin && !a.getUsername().equals(username)) continue;
                            any = true;
                    %>
                        <tr>
                            <td><%= i++ %></td>
                            <% if (isAdmin) { %><td><%= a.getUsername() %></td><% } %>
                            <td><%= a.getService() %></td>
                            <td><%= a.getDate() %></td>
                            <td><%= a.getTime() %></td>
                            <td><span class="badge bg-info text-dark"><%= a.getStatus() %></span></td>
                            <td>
                                <a href="updateAppointment.jsp?id=<%= a.getId() %>" class="btn btn-sm btn-warning">Update</a>
                                <a href="DeleteAppointmentServlet?id=<%= a.getId() %>"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Cancel this appointment?');">Cancel</a>
                            </td>
                        </tr>
                    <% } %>
                    <% if (!any) { %>
                        <tr><td colspan="6" class="text-center text-muted">No appointments yet.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
</html>

