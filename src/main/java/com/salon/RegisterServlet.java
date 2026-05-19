package com.salon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name     = safe(req.getParameter("name"));
        String email    = safe(req.getParameter("email"));
        String username = safe(req.getParameter("username"));
        String password = safe(req.getParameter("password"));
        String phone    = safe(req.getParameter("phone"));

        if (username.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        String path = FileHandler.filePath(getServletContext().getRealPath("/"), "users.txt");

        // Check duplicate username
        List<String> existing = FileHandler.readAllLines(path);
        for (String l : existing) {
            String[] p = l.split(",", -1);
            if (p.length > 0 && p[0].equalsIgnoreCase(username)) {
                req.setAttribute("error", "Username already exists. Choose another.");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }
        }

        Customer c = new Customer(name, email, username, password, phone);
        FileHandler.appendLine(path, c.toFileString());

        req.setAttribute("success", "Registration successful! Please login.");
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    private String safe(String s) { return s == null ? "" : s.trim(); }
}

