<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, com.salon.*" %>
<%
    String path = FileHandler.filePath(application.getRealPath("/"), "reviews.txt");
    String action = request.getParameter("action");
    String currentUser = (String) session.getAttribute("username");
    boolean loggedIn = currentUser != null;
    boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
    String msg = null;

    if (loggedIn) {
        if ("add".equals(action)) {
            String svc = request.getParameter("service");
            String rating = request.getParameter("rating");
            String comment = request.getParameter("comment");
            if (svc != null && rating != null) {
                try {
                    Review r = new Review(FileHandler.newId(), currentUser, svc,
                            Integer.parseInt(rating), comment == null ? "" : comment);
                    FileHandler.appendLine(path, r.toFileString());
                    msg = "Review added.";
                } catch (NumberFormatException e) { msg = "Invalid rating."; }
            }
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            if (id != null) {
                // ensure the user only deletes their own review
                List<String> all = FileHandler.readAllLines(path);
                for (String l : all) {
                    Review r = Review.fromFileString(l);
                    if (r != null && r.getId().equals(id) && (isAdmin || r.getUsername().equals(currentUser))) {
                        FileHandler.deleteById(path, id);
                        msg = "Review deleted.";
                        break;
                    }
                }
            }
        } else if ("update".equals(action)) {
            String id = request.getParameter("id");
            String svc = request.getParameter("service");
            String rating = request.getParameter("rating");
            String comment = request.getParameter("comment");
            if (id != null) {
                try {
                    // make sure it's the owner
                    List<String> all = FileHandler.readAllLines(path);
                    for (String l : all) {
                        Review existing = Review.fromFileString(l);
                        if (existing != null && existing.getId().equals(id)
                                && existing.getUsername().equals(currentUser)) {
                            Review r = new Review(id, currentUser, svc,
                                    Integer.parseInt(rating), comment == null ? "" : comment);
                            FileHandler.updateById(path, id, r.toFileString());
                            msg = "Review updated.";
                            break;
                        }
                    }
                } catch (NumberFormatException e) { msg = "Invalid rating."; }
            }
        }
    }

    List<String> lines = FileHandler.readAllLines(path);

    String editId = request.getParameter("edit");
    Review editing = null;
    if (editId != null && loggedIn) {
        for (String l : lines) {
            Review r = Review.fromFileString(l);
            if (r != null && r.getId().equals(editId) && r.getUsername().equals(currentUser)) {
                editing = r;
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reviews</title>
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
    <h3 class="mb-4">Customer Reviews</h3>

    <% if (msg != null) { %>
        <div class="alert alert-info"><%= msg %></div>
    <% } %>

    <% if (loggedIn && !isAdmin) { %>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
            <h5><%= editing != null ? "Update Your Review" : "Add a Review" %></h5>
            <form method="post" action="reviews.jsp" class="row g-2">
                <input type="hidden" name="action" value="<%= editing != null ? "update" : "add" %>">
                <% if (editing != null) { %>
                    <input type="hidden" name="id" value="<%= editing.getId() %>">
                <% } %>
                <div class="col-md-4">
                    <input type="text" name="service" class="form-control" placeholder="Service"
                           value="<%= editing != null ? editing.getService() : "" %>" required>
                </div>
                <div class="col-md-2">
                    <select name="rating" class="form-select" required>
                        <% for (int r = 5; r >= 1; r--) {
                            String sel = (editing != null && editing.getRating() == r) ? "selected" : ""; %>
                            <option value="<%= r %>" <%= sel %>><%= r %> ★</option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-4">
                    <input type="text" name="comment" class="form-control" placeholder="Comment"
                           value="<%= editing != null ? editing.getComment() : "" %>">
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
                Review r = Review.fromFileString(l);
                if (r == null) continue;
        %>
        <div class="col-md-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <h5 class="mb-1"><%= r.getService() %></h5>
                        <span class="text-warning">
                            <% for (int i = 0; i < r.getRating(); i++) { %>★<% } %>
                        </span>
                    </div>
                    <p class="text-muted small mb-1">by <%= r.getUsername() %></p>
                    <p class="mb-2"><%= r.getComment() %></p>
                    <% if (loggedIn && (currentUser.equals(r.getUsername()) || isAdmin)) { %>
                        <% if (!isAdmin) { %>
                        <a class="btn btn-sm btn-warning" href="reviews.jsp?edit=<%= r.getId() %>">Edit</a>
                        <% } %>
                        <a class="btn btn-sm btn-danger"
                           href="reviews.jsp?action=delete&id=<%= r.getId() %>"
                           onclick="return confirm('Delete review?');">Delete</a>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

</body>
</html>

