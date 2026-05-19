<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, com.salon.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String svcPath = FileHandler.filePath(application.getRealPath("/"), "services.txt");
    List<String> svcLines = FileHandler.readAllLines(svcPath);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book Appointment</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body{background:#fff0f6;}</style>
</head>
<body>

<nav class="navbar navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="dashboard.jsp" style="color:#c71585;">💄 Beauty Salon</a>
        <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm">← Back</a>
    </div>
</nav>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <h3 class="mb-4">Book an Appointment</h3>

                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                    <% } %>

                    <form method="post" action="BookingServlet">
                        <div class="mb-3">
                            <label class="form-label">Service</label>
                            <select name="service" class="form-select" required>
                                <option value="">-- Select Service --</option>
                                <%
                                    for (String l : svcLines) {
                                        Service s = Service.fromFileString(l);
                                        if (s == null) continue;
                                %>
                                    <option value="<%= s.getName() %>"><%= s.getName() %> ($<%= s.getPrice() %>)</option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date</label>
                            <input type="date" name="date" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Time</label>
                            <input type="time" name="time" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-danger w-100">Book Now</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>

