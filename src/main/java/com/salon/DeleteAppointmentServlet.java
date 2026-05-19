package com.salon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/DeleteAppointmentServlet")
public class DeleteAppointmentServlet extends HttpServlet {

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

        String id = req.getParameter("id");
        if (id != null && !id.isEmpty()) {
            String path = FileHandler.filePath(getServletContext().getRealPath("/"), "appointments.txt");
            String username = (String) session.getAttribute("username");
            boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
            
            if (isAdmin) {
                FileHandler.deleteById(path, id);
            } else {
                for (String l : FileHandler.readAllLines(path)) {
                    Appointment a = Appointment.fromFileString(l);
                    if (a != null && a.getId().equals(id) && a.getUsername().equals(username)) {
                        FileHandler.deleteById(path, id);
                        break;
                    }
                }
            }
        }
        resp.sendRedirect("appointments.jsp");
    }
}

