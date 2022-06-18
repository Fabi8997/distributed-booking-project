package servlet;

import database.DbManager;
import utility.Utils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        if(DbManager.login(request.getParameter("user"), request.getParameter("pass"))){
            String targetJSP = "/pages/jsp/redirect_beaches.jsp";
            if(Utils.isAdmin(request.getParameter("user"))){
                targetJSP = "/pages/jsp/admin.jsp";
            }

            String user = request.getParameter("user");

            HttpSession session=request.getSession(false);

            //If there isn't a session => Create it
            if(session == null){
                System.out.println("Creating the session");
                session = request.getSession();
                session.setAttribute("user", user);
            }

            //Set up the logged user, if the user wasn't already logged!
            if(session.getAttribute("user") == null){
                session.setAttribute("user", user);
            }else{
                //If the session is referred to another user => invalidate it and set up the new user
                if(!session.getAttribute("user").equals(user)){
                    session.invalidate();
                    session.setAttribute("user",user);
                }
            }

            RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
            requestDispatcher.forward(request,response);
        }else{
            String targetJSP = "index.jsp";
            request.setAttribute("error", "Username/Password not correct!");
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
            requestDispatcher.forward(request,response);
        }
    }
}
