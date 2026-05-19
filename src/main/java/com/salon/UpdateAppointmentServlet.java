package com.salon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/UpdateAppointmentServlet")
public class UpdateAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        String id      = req.getParameter("id");
        String service = req.getParameter("service");
        String date    = req.getParameter("date");
        String time    = req.getParameter("time");
        String status  = req.getParameter("status");

        if (id == null || id.isEmpty()) {
            resp.sendRedirect("appointments.jsp");
            return;
        }
        if (status == null || status.isEmpty()) status = "BOOKED";

        String path = FileHandler.filePath(getServletContext().getRealPath("/"), "appointments.txt");
        
        Appointment existing = null;
        for (String l : FileHandler.readAllLines(path)) {
            Appointment a = Appointment.fromFileString(l);
            if (a != null && a.getId().equals(id)) {
                existing = a;
                break;
            }
        }

        if (existing == null) {
            resp.sendRedirect("appointments.jsp");
            return;
        }

        boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
        
        // Security check: if not admin, ensure they own the appointment
        if (!isAdmin && !existing.getUsername().equals(username)) {
            resp.sendRedirect("appointments.jsp");
            return;
        }

        String finalUsername = existing.getUsername();
        String finalStatus = isAdmin ? status : existing.getStatus();
        if (finalStatus == null || finalStatus.isEmpty()) finalStatus = "BOOKED";

        Appointment updated = new Appointment(id, finalUsername, service, date, time, finalStatus);
        FileHandler.updateById(path, id, updated.toFileString());

        resp.sendRedirect("appointments.jsp");
    }
}

