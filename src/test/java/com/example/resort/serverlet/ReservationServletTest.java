package com.example.resort.serverlet;

import com.example.resort.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import java.util.ArrayList;

import static org.mockito.Mockito.*;

class ReservationServletTest {

    private ReservationServlet reservationServlet;

    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {

        reservationServlet = new ReservationServlet();

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);
    }

    // -------- TEST: LIST RESERVATIONS (DEFAULT ACTION) --------
    @Test
    void testDoGet_ListReservations_Returns200() throws Exception {

        when(request.getParameter("action")).thenReturn(null);

        when(request.getRequestDispatcher("/WEB-INF/jsp/reservations.jsp"))
                .thenReturn(dispatcher);

        reservationServlet.doGet(request, response);

        verify(dispatcher).forward(request, response);
    }

    // -------- TEST: ADD RESERVATION FORM --------
    @Test
    void testDoGet_AddReservationForm_Returns200() throws Exception {

        when(request.getParameter("action")).thenReturn("add");

        when(request.getRequestDispatcher("/WEB-INF/jsp/reservation_form.jsp"))
                .thenReturn(dispatcher);

        reservationServlet.doGet(request, response);

        verify(dispatcher).forward(request, response);
    }


    @Test
    void testDoGet_ViewReservation_Returns200() throws Exception {

        when(request.getParameter("action")).thenReturn("view");
        when(request.getParameter("resNo")).thenReturn("RES001");

        when(request.getRequestDispatcher("/WEB-INF/jsp/reservation_detail.jsp"))
                .thenReturn(dispatcher);

        reservationServlet.doGet(request, response);

        verify(dispatcher).forward(request, response);
    }

    // -------- TEST: CANCEL RESERVATION (REDIRECT) --------
    @Test
    void testDoGet_CancelReservation_Redirect() throws Exception {

        when(request.getParameter("action")).thenReturn("cancel");
        when(request.getParameter("id")).thenReturn("1");
        when(request.getContextPath()).thenReturn("/resort");

        reservationServlet.doGet(request, response);

        verify(response).sendRedirect(contains("/reservation?action=list"));
    }

    // -------- TEST: CREATE RESERVATION (POST SUCCESS) --------
    @Test
    void testDoPost_SuccessReservation_Redirect() throws Exception {

        User user = new User();
        user.setUserId(1);

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("loggedInUser")).thenReturn(user);

        when(request.getParameter("guestName")).thenReturn("John");
        when(request.getParameter("address")).thenReturn("Colombo");
        when(request.getParameter("contactNo")).thenReturn("0771234567");
        when(request.getParameter("email")).thenReturn("john@test.com");
        when(request.getParameter("nic")).thenReturn("123456789V");
        when(request.getParameter("roomId")).thenReturn("1");
        when(request.getParameter("checkInDate")).thenReturn("2026-03-10");
        when(request.getParameter("checkOutDate")).thenReturn("2026-03-12");
        when(request.getParameter("specialRequests")).thenReturn("None");

        when(request.getContextPath()).thenReturn("/resort");

        reservationServlet.doPost(request, response);

        verify(response).sendRedirect(contains("/reservation?action=view"));
    }

    // -------- TEST: CREATE RESERVATION (FAILED → RETURN FORM 200) --------
    @Test
    void testDoPost_FailedReservation_ReturnForm() throws Exception {

        User user = new User();
        user.setUserId(1);

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("loggedInUser")).thenReturn(user);

        when(request.getParameter("guestName")).thenReturn("John");
        when(request.getParameter("roomId")).thenReturn("invalid");

        when(request.getRequestDispatcher("/WEB-INF/jsp/reservation_form.jsp"))
                .thenReturn(dispatcher);

        reservationServlet.doPost(request, response);

        verify(dispatcher).forward(request, response);
    }
}