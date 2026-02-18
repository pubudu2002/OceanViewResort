package com.example.resort.filter;

import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class SessionFilter implements Filter {

    private static final String[] PUBLIC_URLS = {"/login", "/css/", "/js/", "/images/"};

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getServletPath();

        // Allow public URLs through
        for (String url : PUBLIC_URLS) {
            if (path.startsWith(url)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // Check session
        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("loggedInUser") != null;

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
}