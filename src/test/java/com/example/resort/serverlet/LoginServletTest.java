package com.example.resort.serverlet;

import com.example.resort.model.User;
import com.example.resort.service.AuthService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import java.io.IOException;

import static org.mockito.Mockito.*;

class LoginServletTest {

    private LoginServlet loginServlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        loginServlet = new LoginServlet();
    }

    // Test GET request when user NOT logged in
    @Test
    void testDoGet_ShowLoginPage() throws Exception {

        when(request.getSession(false)).thenReturn(null);
        when(request.getRequestDispatcher("/WEB-INF/jsp/login.jsp"))
                .thenReturn(dispatcher);

        loginServlet.doGet(request, response);

        verify(dispatcher).forward(request, response);
    }

    // Test GET request when user already logged in
    @Test
    void testDoGet_RedirectToDashboard() throws Exception {

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("loggedInUser")).thenReturn(new User());

        when(request.getContextPath()).thenReturn("/resort");

        loginServlet.doGet(request, response);

        verify(response).sendRedirect("/resort/dashboard");
    }

    // Test POST request with INVALID login
    @Test
    void testDoPost_InvalidLogin() throws Exception {

        when(request.getParameter("username")).thenReturn("wronguser");
        when(request.getParameter("password")).thenReturn("wrongpass");

        when(request.getRequestDispatcher("/WEB-INF/jsp/login.jsp"))
                .thenReturn(dispatcher);

        loginServlet.doPost(request, response);

        verify(request).setAttribute(eq("errorMessage"), anyString());
        verify(dispatcher).forward(request, response);
    }

    // Test POST request with VALID login
//    @Test
//    void testDoPost_ValidLogin() throws Exception {
//
//        User mockUser = new User();
//        mockUser.setUsername("admin");
//        mockUser.setRole("ADMIN");
//
//        AuthService authServiceMock = mock(AuthService.class);
//        LoginServlet servlet = new LoginServlet();
//
//        when(request.getParameter("username")).thenReturn("admin");
//        when(request.getParameter("password")).thenReturn("1234");
//
//        when(request.getSession(true)).thenReturn(session);
//        when(request.getContextPath()).thenReturn("/resort");
//
//        servlet.doPost(request, response);
//
//        verify(session).setAttribute(eq("loggedInUser"), any());
//        verify(session).setAttribute(eq("username"), any());
//        verify(session).setAttribute(eq("role"), any());
//    }
}