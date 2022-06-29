package servlet;

import communication.BookingManager;
import database.DbManager;
import dto.SubscriptionType;
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

@WebServlet(name = "AddSubscriptionServlet", value = "/AddSubscriptionServlet")
public class AddSubscriptionServlet extends HttpServlet {
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
                System.out.println("Receiving the new subscription info...");

                int idBeach = Integer.parseInt(request.getParameter("idBeach"));
                String type = request.getParameter("booking-type");
                String user = session.getAttribute("user").toString();
                String startingDate = request.getParameter("starting-date");
                SubscriptionType subscriptionType = SubscriptionType.valueOf(request.getParameter("subscription-type"));
                int duration = SubscriptionType.parseInt(subscriptionType);
                String targetJSP;

                //.out.println(idBeach + "\n" + type  + "\n" + user  + "\n" + startingDate  + "\n" + duration );
                
                ResultMessage resultMessage = BookingManager.newSubscription(user,idBeach,type,startingDate, duration);

                if(resultMessage.isResult()){
                    //if no errors occur then it goes to the confirmation page!
                    targetJSP = "/pages/jsp/subscription.jsp";
                    request.setAttribute("info", "Subscription inserted correctly!");
                }else{
                    //redirect to the previous page with an error msg!
                    targetJSP = "/pages/jsp/subscription.jsp";
                    request.setAttribute("error", resultMessage.getMessage());
                }

                RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
                requestDispatcher.forward(request,response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}