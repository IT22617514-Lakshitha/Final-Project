package com.salon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        String service  = req.getParameter("service");
        String date     = req.getParameter("date");
        String time     = req.getParameter("time");

        if (service == null || date == null || time == null
                || service.isEmpty() || date.isEmpty() || time.isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("booking.jsp").forward(req, resp);
            return;
        }

        String path = FileHandler.filePath(getServletContext().getRealPath("/"), "appointments.txt");
        Appointment a = new Appointment(FileHandler.newId(), username, service, date, time, "BOOKED");
        FileHandler.appendLine(path, a.toFileString());

        resp.sendRedirect("appointments.jsp");
    }
}

