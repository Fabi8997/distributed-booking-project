package servlet;

import communication.BookingManager;
import database.DbManager;
import utility.ResultMessage;
import utility.Utils;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "AddBookingServlet", value = "/AddBookingServlet")
public class AddBookingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("Session not exists!");

            //Return to login page
            String targetJSP = "index.jsp";

            //Set the error msg
            request.setAttribute("error","Please Login!");

            RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
            requestDispatcher.forward(request,response);
        } else {

            if(session.getAttribute("user") == null){
                System.out.println("Not logged!");

                //Return to login page
                String targetJSP = "index.jsp";

                //Set the error msg
                request.setAttribute("error","Please Login!");

                RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
                requestDispatcher.forward(request,response);
            }else{
                System.out.println("Receiving the new booking info...");

                int idBeach = Integer.parseInt(request.getParameter("idBeach"));
                String bookingDate = request.getParameter("booking-date");
                String bookingType = request.getParameter("booking-type");
                String user = session.getAttribute("user").toString();
                System.out.println(idBeach + "\n" + bookingDate + "\n" + bookingType + "\n" + user);
                String targetJSP;

                ResultMessage resultMessage = BookingManager.newBooking(user,idBeach,bookingType,bookingDate);

                if(resultMessage.isResult()){
                    targetJSP = "/pages/jsp/new_booking.jsp";
                    request.setAttribute("info", "Booking inserted correctly!");
                }else{
                    //redirect to the previous page with an error msg!
                    targetJSP = "/pages/jsp/new_booking.jsp";
                    request.setAttribute("error", resultMessage.getMessage());
                }

                session.setAttribute("idBeach", idBeach);
                RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
                requestDispatcher.forward(request,response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
