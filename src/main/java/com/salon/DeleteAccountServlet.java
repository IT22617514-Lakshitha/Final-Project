package com.salon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    private void handle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));

        if (!isAdmin && username != null && !username.isEmpty()) {
            String usersPath = FileHandler.filePath(getServletContext().getRealPath("/"), "users.txt");
            FileHandler.deleteById(usersPath, username);

            // Cascade delete their appointments
            String appPath = FileHandler.filePath(getServletContext().getRealPath("/"), "appointments.txt");
            List<String> apps = FileHandler.readAllLines(appPath);
            boolean appsChanged = apps.removeIf(l -> {
                Appointment a = Appointment.fromFileString(l);
                return a != null && a.getUsername().equals(username);
            });
            if (appsChanged) FileHandler.writeAllLines(appPath, apps);

            // Cascade delete their reviews
            String revPath = FileHandler.filePath(getServletContext().getRealPath("/"), "reviews.txt");
            List<String> revs = FileHandler.readAllLines(revPath);
            boolean revsChanged = revs.removeIf(l -> {
                Review r = Review.fromFileString(l);
                return r != null && r.getUsername().equals(username);
            });
            if (revsChanged) FileHandler.writeAllLines(revPath, revs);

            // Invalidate session and redirect to home
            session.invalidate();
            resp.sendRedirect("index.jsp");
            return;
        }
        
        resp.sendRedirect("dashboard.jsp");
    }
}
