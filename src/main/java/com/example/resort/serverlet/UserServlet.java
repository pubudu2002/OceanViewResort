package com.example.resort.serverlet;

import com.example.resort.dao.UserDAO;
import com.example.resort.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/users")
public class UserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Admin only
        HttpSession session = req.getSession(false);
        User loggedIn = (User) session.getAttribute("loggedInUser");
        if (!"ADMIN".equals(loggedIn.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "add":
                req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
                        .forward(req, resp);
                break;

            case "edit":
                int editId  = Integer.parseInt(req.getParameter("id"));
                User user   = userDAO.findById(editId);
                req.setAttribute("editUser", user);
                req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
                        .forward(req, resp);
                break;

            case "delete":
                int deleteId = Integer.parseInt(req.getParameter("id"));

                // Prevent deleting yourself
                if (deleteId == loggedIn.getUserId()) {
                    resp.sendRedirect(req.getContextPath() +
                            "/users?error=You cannot delete your own account.");
                    return;
                }
                boolean deleted = userDAO.deleteUser(deleteId);
                if (deleted) {
                    resp.sendRedirect(req.getContextPath() +
                            "/users?success=User deleted successfully.");
                } else {
                    resp.sendRedirect(req.getContextPath() +
                            "/users?error=Failed to delete user.");
                }
                break;

            default:
                List<User> users = userDAO.getAllUsers();
                req.setAttribute("users", users);
                req.setAttribute("successMsg", req.getParameter("success"));
                req.setAttribute("errorMsg",   req.getParameter("error"));
                req.getRequestDispatcher("/WEB-INF/jsp/users.jsp")
                        .forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User loggedIn = (User) session.getAttribute("loggedInUser");
        if (!"ADMIN".equals(loggedIn.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        String action    = req.getParameter("action");
        String userIdStr = req.getParameter("userId");
        String username  = req.getParameter("username");
        String password  = req.getParameter("password");
        String fullName  = req.getParameter("fullName");
        String role      = req.getParameter("role");

        // Validation
        if (username == null || username.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Username and Full Name are required.");
            if (userIdStr != null) {
                req.setAttribute("editUser",
                        userDAO.findById(Integer.parseInt(userIdStr)));
            }
            req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
                    .forward(req, resp);
            return;
        }

        if ("edit".equals(action) && userIdStr != null) {
            // Update existing user
            int userId = Integer.parseInt(userIdStr);
            User existing = userDAO.findById(userId);
            if (existing != null) {
                existing.setUsername(username.trim());
                existing.setFullName(fullName.trim());
                existing.setRole(role);
                // Only update password if a new one was entered
                if (password != null && !password.trim().isEmpty()) {
                    existing.setPassword(password.trim());
                }
                boolean updated = userDAO.updateUser(existing);
                if (updated) {
                    resp.sendRedirect(req.getContextPath() +
                            "/users?success=User updated successfully.");
                } else {
                    req.setAttribute("errorMessage", "Failed to update user.");
                    req.setAttribute("editUser", existing);
                    req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
                            .forward(req, resp);
                }
            }
        } else {
            // Add new user
            if (password == null || password.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Password is required for new users.");
                req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
                        .forward(req, resp);
                return;
            }
            // Check username already exists
            if (userDAO.findByUsername(username.trim()) != null) {
                req.setAttribute("errorMessage",
                        "Username '" + username + "' is already taken.");
                req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
                        .forward(req, resp);
                return;
            }
            User newUser = new User(0, username.trim(),
                    password.trim(), fullName.trim(), role);
            boolean saved = userDAO.addUser(newUser);
            if (saved) {
                resp.sendRedirect(req.getContextPath() +
                        "/users?success=User added successfully.");
            } else {
                req.setAttribute("errorMessage", "Failed to add user.");
                req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
                        .forward(req, resp);
            }
        }
    }
}