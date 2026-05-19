<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, com.salon.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String id = request.getParameter("id");
    String username = (String) session.getAttribute("username");
    boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
    Appointment found = null;

    if (id != null) {
        String path = FileHandler.filePath(application.getRealPath("/"), "appointments.txt");
        for (String l : FileHandler.readAllLines(path)) {
            Appointment a = Appointment.fromFileString(l);
            if (a != null && a.getId().equals(id) && (isAdmin || a.getUsername().equals(username))) {
                found = a;
                break;
            }
        }
    }
    if (found == null) {
        response.sendRedirect("appointments.jsp");
        return;
    }

    String svcPath = FileHandler.filePath(application.getRealPath("/"), "services.txt");
    List<String> svcLines = FileHandler.readAllLines(svcPath);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Appointment</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body{background:#fff0f6;}</style>
</head>
<body>

<nav class="navbar navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="dashboard.jsp" style="color:#c71585;">💄 Beauty Salon</a>
        <a href="appointments.jsp" class="btn btn-outline-secondary btn-sm">← Back</a>
    </div>
</nav>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <h3 class="mb-4">Update Appointment</h3>
                    <form method="post" action="UpdateAppointmentServlet">
                        <input type="hidden" name="id" value="<%= found.getId() %>">

                        <div class="mb-3">
                            <label class="form-label">Service</label>
                            <select name="service" class="form-select" required>
                                <%
                                    for (String l : svcLines) {
                                        Service s = Service.fromFileString(l);
                                        if (s == null) continue;
                                        String sel = s.getName().equals(found.getService()) ? "selected" : "";
                                %>
                                    <option value="<%= s.getName() %>" <%= sel %>><%= s.getName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date</label>
                            <input type="date" name="date" class="form-control" value="<%= found.getDate() %>" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Time</label>
                            <input type="time" name="time" class="form-control" value="<%= found.getTime() %>" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <% if (isAdmin) { %>
                            <select name="status" class="form-select">
                                <%
                                    String[] sts = {"BOOKED","COMPLETED","CANCELLED"};
                                    for (String s : sts) {
                                        String sel = s.equals(found.getStatus()) ? "selected" : "";
                                %>
                                    <option <%= sel %>><%= s %></option>
                                <% } %>
                            </select>
                            <% } else { %>
                            <input type="text" class="form-control" value="<%= found.getStatus() %>" disabled>
                            <input type="hidden" name="status" value="<%= found.getStatus() %>">
                            <% } %>
                        </div>
                        <button type="submit" class="btn btn-warning w-100">Save Changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>

