<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Beauty Salon | Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg,#fff0f6 0%,#ffe5ec 100%); min-height: 100vh; }
        .hero { padding: 80px 0; }
        .hero h1 { font-weight: 700; color: #c71585; }
        .feature-card { border:none; border-radius: 18px; box-shadow: 0 6px 18px rgba(199,21,133,.08); }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold text-pink" href="index.jsp" style="color:#c71585;">💄 Beauty Salon</a>
        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#nav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div id="nav" class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
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

<section class="hero text-center">
    <div class="container">
        <h1 class="display-4">Welcome to Glamour Beauty Salon</h1>
        <p class="lead text-muted">Book your favorite beauty treatments in just a few clicks.</p>
        <a href="register.jsp" class="btn btn-danger btn-lg me-2">Get Started</a>
        <a href="services.jsp" class="btn btn-outline-dark btn-lg">View Services</a>
    </div>
</section>

<section class="container pb-5">
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card feature-card p-4 text-center h-100">
                <h4>💇 Professional Stylists</h4>
                <p class="text-muted">Trained experts ready to pamper you.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card feature-card p-4 text-center h-100">
                <h4>📅 Easy Online Booking</h4>
                <p class="text-muted">Reserve your slot anytime, anywhere.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card feature-card p-4 text-center h-100">
                <h4>⭐ Trusted Reviews</h4>
                <p class="text-muted">Read real feedback from our customers.</p>
            </div>
        </div>
    </div>
</section>

<footer class="bg-white text-center py-3 border-top">
    <small class="text-muted">© <%= java.time.Year.now() %> Glamour Beauty Salon</small>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
