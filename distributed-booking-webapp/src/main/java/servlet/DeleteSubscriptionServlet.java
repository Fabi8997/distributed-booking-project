package servlet;


import communication.BookingManager;
import database.DbManager;
import utility.ResultMessage;
import utility.Utils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DeleteSubscriptionServlet", value = "/DeleteSubscriptionServlet")
public class DeleteSubscriptionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("Session not exists!");

            //Return to login page
            String targetJSP = "index.jsp";

            //Set the error msg
            request.setAttribute("error", "Please Login!");

            RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
            requestDispatcher.forward(request, response);
        } else {

            if (session.getAttribute("user") == null) {
                System.out.println("Not logged!");

                //Return to login page
                String targetJSP = "index.jsp";

                //Set the error msg
                request.setAttribute("error", "Please Login!");

                RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
                requestDispatcher.forward(request, response);
            } else {
                System.out.println("Receiving the subscription to delete info...");
                int subscription = Integer.parseInt(request.getParameter("subscriptionId"));
                String admin = session.getAttribute("user").toString();
                String targetJSP;
                ResultMessage resultMessage = BookingManager.removeSubscription(admin, subscription);
                if(resultMessage.isResult()){
                    //if no errors occur then it goes to the confirmation page!
                    targetJSP = "/pages/jsp/admin.jsp";
                    request.setAttribute("info", "Subscription correctly inserted!");
                } else {
                    //redirect to the previous page with an error msg!
                    targetJSP = "/pages/jsp/admin.jsp";
                    request.setAttribute("error", "Something has gone wrong!");
                }

                RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
                requestDispatcher.forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
