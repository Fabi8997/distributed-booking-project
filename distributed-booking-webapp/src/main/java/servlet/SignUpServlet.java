package servlet;

import database.DbManager;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SignUpServlet", value = "/SignUpServlet")
public class SignUpServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("Sending the login page...");

        //Retrieve the data from the form
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");

        if(DbManager.register(user,pass)){

            //Open the login page if is completed correctly
            String targetJSP = "index.jsp";
            //Set the information msg
            request.setAttribute("info","Registration completed!");

            RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
            requestDispatcher.forward(request,response);
        }else{
            String targetJSP = "/pages/jsp/register.jsp";
            request.setAttribute("error", "Username already present!");
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(targetJSP);
            requestDispatcher.forward(request,response);
        }
    }
}
