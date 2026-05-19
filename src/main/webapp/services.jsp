<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, com.salon.*" %>
<%
    String path = FileHandler.filePath(application.getRealPath("/"), "services.txt");
    String action = request.getParameter("action");
    String msg = null;

    boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
    boolean loggedIn = session.getAttribute("username") != null;

    // Inline CRUD on services (no separate servlet required for this entity)
    if (isAdmin) {
        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String price = request.getParameter("price");
            String duration = request.getParameter("duration");
            if (name != null && price != null && duration != null
                    && !name.isEmpty() && !price.isEmpty()) {
                try {
                    Service s = new Service(FileHandler.newId(), name, Integer.parseInt(price), duration);
                    FileHandler.appendLine(path, s.toFileString());
                    msg = "Service added.";
                } catch (NumberFormatException e) { msg = "Invalid price."; }
            }
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            if (id != null) {
                FileHandler.deleteById(path, id);
                msg = "Service deleted.";
            }
        } else if ("update".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String price = request.getParameter("price");
            String duration = request.getParameter("duration");
            if (id != null && name != null && price != null) {
                try {
                    Service s = new Service(id, name, Integer.parseInt(price), duration);
                    FileHandler.updateById(path, id, s.toFileString());
                    msg = "Service updated.";
                } catch (NumberFormatException e) { msg = "Invalid price."; }
            }
        }
    }

    List<String> lines = FileHandler.readAllLines(path);

    String editId = request.getParameter("edit");
    Service editing = null;
    if (editId != null) {
        for (String l : lines) {
            Service s = Service.fromFileString(l);
            if (s != null && s.getId().equals(editId)) { editing = s; break; }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Services</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body{background:#fff0f6;}</style>
</head>
<body>

<nav class="navbar navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp" style="color:#c71585;">💄 Beauty Salon</a>
        <div>
            <% if (loggedIn) { %>
                <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm">← Dashboard</a>
            <% } else { %>
                <a href="login.jsp" class="btn btn-outline-danger btn-sm">Login</a>
            <% } %>
        </div>
    </div>
</nav>

<div class="container py-5">
    <h3 class="mb-4">Our Services</h3>

    <% if (msg != null) { %>
        <div class="alert alert-info"><%= msg %></div>
    <% } %>

    <% if (isAdmin) { %>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
            <h5><%= editing != null ? "Update Service" : "Add Service" %></h5>
            <form method="post" action="services.jsp" class="row g-2">
                <input type="hidden" name="action" value="<%= editing != null ? "update" : "add" %>">
                <% if (editing != null) { %>
                    <input type="hidden" name="id" value="<%= editing.getId() %>">
                <% } %>
                <div class="col-md-4">
                    <input type="text" name="name" class="form-control" placeholder="Service name"
                           value="<%= editing != null ? editing.getName() : "" %>" required>
                </div>
                <div class="col-md-3">
                    <input type="number" step="1" name="price" class="form-control" placeholder="Price"
                           value="<%= editing != null ? editing.getPrice() : "" %>" required>
                </div>
                <div class="col-md-3">
                    <input type="text" name="duration" class="form-control" placeholder="Duration (e.g. 30 min)"
                           value="<%= editing != null ? editing.getDuration() : "" %>">
                </div>
                <div class="col-md-2">
                    <button class="btn btn-danger w-100"><%= editing != null ? "Save" : "Add" %></button>
                </div>
            </form>
        </div>
    </div>
    <% } %>

    <div class="row g-3">
        <%
            for (String l : lines) {
                Service s = Service.fromFileString(l);
                if (s == null) continue;
        %>
        <div class="col-md-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body">
                    <h5><%= s.getName() %></h5>
                    <p class="text-muted mb-1">Duration: <%= s.getDuration() %></p>
                    <h4 class="text-danger">Rs. <%= s.getPrice() %></h4>
                    <% if (isAdmin) { %>
                        <a class="btn btn-sm btn-warning" href="services.jsp?edit=<%= s.getId() %>">Edit</a>
                        <a class="btn btn-sm btn-danger"
                           href="services.jsp?action=delete&id=<%= s.getId() %>"
                           onclick="return confirm('Delete this service?');">Delete</a>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

</body>
</html>

