package com.example.resort.service;

import com.example.resort.dao.UserDAO;
import com.example.resort.model.User;

public class AuthService {
    private final UserDAO userDAO = new UserDAO();

    public User login(String username, String password) {
        // Input validation
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            return null;
        }

        User user = userDAO.findByUsername(username.trim());

        if (user == null) {
            return null; // user not found
        }

        // Plain text check (upgrade to BCrypt later)
        if (user.getPassword().equals(password)) {
            return user;
        }

        return null; // wrong password
    }

    public boolean isAdmin(User user) {
        return user != null && "ADMIN".equals(user.getRole());
    }
}
