package com.example.resort.serverlet;

import com.example.resort.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.*;

class UserServletTest {

    private UserServlet userServlet;

    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {

        userServlet = new UserServlet();

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);
    }

    // -------- ADMIN LIST USERS (200 OK) --------
    @Test
    void testDoGet_ListUsers_Return200() throws Exception {

        User admin = new User();
        admin.setRole("ADMIN");

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("loggedInUser")).thenReturn(admin);

        when(request.getParameter("action")).thenReturn(null);

        when(request.getRequestDispatcher("/WEB-INF/jsp/users.jsp"))
                .thenReturn(dispatcher);

        userServlet.doGet(request, response);

        verify(dispatcher).forward(request, response);
    }

    // -------- ADD USER FORM (200 OK) --------
    @Test
    void testDoGet_AddUserForm_Return200() throws Exception {

        User admin = new User();
        admin.setRole("ADMIN");

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("loggedInUser")).thenReturn(admin);

        when(request.getParameter("action")).thenReturn("add");

        when(request.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp"))
                .thenReturn(dispatcher);

        userServlet.doGet(request, response);

        verify(dispatcher).forward(request, response);
    }

    // -------- NON ADMIN REDIRECT --------
    @Test
    void testDoGet_NonAdmin_Redirect() throws Exception {

        User staff = new User();
        staff.setRole("STAFF");

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("loggedInUser")).thenReturn(staff);
        when(request.getContextPath()).thenReturn("/resort");

        userServlet.doGet(request, response);

        verify(response).sendRedirect("/resort/dashboard");
    }

    // -------- DELETE USER REDIRECT --------
    @Test
    void testDoGet_DeleteUser_Redirect() throws Exception {

        User admin = new User();
        admin.setRole("ADMIN");
        admin.setUserId(1);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("loggedInUser")).thenReturn(admin);

        when(request.getParameter("action")).thenReturn("delete");
        when(request.getParameter("id")).thenReturn("2");

        when(request.getContextPath()).thenReturn("/resort");

        userServlet.doGet(request, response);

        verify(response).sendRedirect(contains("/users"));
    }

    // -------- POST VALIDATION FAIL (200 OK) --------
    @Test
    void testDoPost_ValidationError_Return200() throws Exception {

        User admin = new User();
        admin.setRole("ADMIN");

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("loggedInUser")).thenReturn(admin);

        when(request.getParameter("username")).thenReturn("");
        when(request.getParameter("fullName")).thenReturn("");

        when(request.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp"))
                .thenReturn(dispatcher);

        userServlet.doPost(request, response);

        verify(dispatcher).forward(request, response);
    }

    // -------- ADD USER PASSWORD MISSING (200 OK) --------
    @Test
    void testDoPost_AddUser_NoPassword_Return200() throws Exception {

        User admin = new User();
        admin.setRole("ADMIN");

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("loggedInUser")).thenReturn(admin);

        when(request.getParameter("username")).thenReturn("john");
        when(request.getParameter("fullName")).thenReturn("John Doe");
        when(request.getParameter("password")).thenReturn("");

        when(request.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp"))
                .thenReturn(dispatcher);

        userServlet.doPost(request, response);

        verify(dispatcher).forward(request, response);
    }
}