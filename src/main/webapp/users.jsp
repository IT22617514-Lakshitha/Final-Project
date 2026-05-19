<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, com.salon.*" %>
<%
    if (session.getAttribute("username") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String path = FileHandler.filePath(application.getRealPath("/"), "users.txt");
    String action = request.getParameter("action");
    String msg = null;

    if ("delete".equals(action)) {
        String user = request.getParameter("username");
        if (user != null) {
            FileHandler.deleteById(path, user);
            
            // Optionally cascade delete their appointments and reviews
            String appPath = FileHandler.filePath(application.getRealPath("/"), "appointments.txt");
            List<String> apps = FileHandler.readAllLines(appPath);
            apps.removeIf(l -> {
                Appointment a = Appointment.fromFileString(l);
                return a != null && a.getUsername().equals(user);
            });
            FileHandler.writeAllLines(appPath, apps);

            String revPath = FileHandler.filePath(application.getRealPath("/"), "reviews.txt");
            List<String> revs = FileHandler.readAllLines(revPath);
            revs.removeIf(l -> {
                Review r = Review.fromFileString(l);
                return r != null && r.getUsername().equals(user);
            });
            FileHandler.writeAllLines(revPath, revs);
            
            msg = "User deleted successfully.";
        }
    }

    List<String> lines = FileHandler.readAllLines(path);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users | Beauty Salon</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body{background:#fff0f6;}</style>
</head>
<body>

<nav class="navbar navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="dashboard.jsp" style="color:#c71585;">💄 Beauty Salon</a>
        <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm">← Dashboard</a>
    </div>
</nav>

<div class="container py-5">
    <h3 class="mb-4">Manage Customers</h3>

    <% if (msg != null) { %>
        <div class="alert alert-info"><%= msg %></div>
    <% } %>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        boolean any = false;
                        for (String l : lines) {
                            Customer c = Customer.fromFileString(l);
                            if (c == null) continue;
                            any = true;
                    %>
                        <tr>
                            <td><%= c.getName() %></td>
                            <td><%= c.getUsername() %></td>
                            <td><%= c.getEmail() %></td>
                            <td><%= c.getPhone() %></td>
                            <td>
                                <a href="users.jsp?action=delete&username=<%= c.getUsername() %>"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Delete this user completely (including their appointments)?');">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                    <% if (!any) { %>
                        <tr><td colspan="5" class="text-center text-muted">No customers registered yet.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
</html>
