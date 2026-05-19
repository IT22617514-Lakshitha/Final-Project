package com.salon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null) username = "";
        if (password == null) password = "";

        if ("admin".equals(username) && "admin123".equals(password)) {
            HttpSession session = req.getSession(true);
            session.setAttribute("username", "admin");
            session.setAttribute("name", "Administrator");
            session.setAttribute("role", "ADMIN");
            resp.sendRedirect("dashboard.jsp");
            return;
        }

        String path = FileHandler.filePath(getServletContext().getRealPath("/"), "users.txt");
        List<String> lines = FileHandler.readAllLines(path);

        for (String l : lines) {
            Customer c = Customer.fromFileString(l);
            if (c == null) continue;
            if (c.getUsername().equals(username) && c.getPassword().equals(password)) {
                HttpSession session = req.getSession(true);
                session.setAttribute("username", c.getUsername());
                session.setAttribute("name", c.getName());
                session.setAttribute("role", "CUSTOMER");
                resp.sendRedirect("dashboard.jsp");
                return;
            }
        }

        req.setAttribute("error", "Invalid username or password.");
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }
}

