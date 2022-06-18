<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.BeachDTO" %>
<%@ page import="utility.Utils" %>
<%@ page import="dto.BookingDTO" %>
<%@ page import="dto.UserDTO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%
        String user = (String) session.getAttribute("user");
        System.out.println("Retrieving the information for "+user+"...");
        List<BeachDTO> beaches = DbManager.getBeaches(user);
        List<UserDTO> users = DbManager.getUsers(user);
    %>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/generalStyle.css">
    <title>Administration Panel</title>

    <div class="header">
        <h2>Beach Booking</h2>
    </div>

    <ul class="topnav">
        <li><a href="<%= request.getContextPath() %>/AdminServlet">AdminPanel</a></li>
        <li id="logout"><a href="<%= request.getContextPath() %>/LogoutServlet" >
            <img src="<%= request.getContextPath() %>/images/logout3.png" alt="logout">
        </a></li>
    </ul>

    <div class="booking_content">
        <div id="ViewBookingContent">
            <form class="AdminForm" action="<%= request.getContextPath() %>/UpdateBeachServlet">
                <label class="adminFormLabel" for="beachInput">Select the beach:</label>
                <select name="beachId" id="beachInput">
                    <option value="0" selected="selected" disabled>--</option>
                    <%
                        for(int i = 0; i < beaches.size(); i++)
                        {
                    %>
                    <option value=<%= beaches.get(i).getBeachId() %>>
                        <%= beaches.get(i).getName().replace("\"", "") %>
                        <!--label>
                          <textarea rows="2"><!%=/*beaches.get(i).getDescription().replace("\"", "")*/%></textarea>
                        </label-->
                    </option>
                    <%
                        }
                    %>
                </select>
                <label class="adminFormLabel">Insert new description</label>
                <input type="text" id="description" value ="Desc">
                <label class="adminFormLabel">Insert new number of slots</label>
                <input type="number" id="slots" value="0">
                <button type="submit">UPDATE</button>
            </form>
            <% //TODO: show bookings and subscriptions only for the selected user? %>
            <form class="AdminForm" action="<%= request.getContextPath() %>/DeleteUserServlet">
                <label class="adminFormLabel" for="userToDelete">Select the user:</label>
                <select name="userId" id="userToDelete">
                    <option value="0" selected="selected">--</option>
                    <%
                        for(int i = 0; i < users.size(); i++)
                        {
                    %>
                    <option value=<%= users.get(i).getUserId() %>>
                        <%= users.get(i).getUsername().replace("\"", "") %>
                    </option>
                    <%
                        }
                    %>
                </select>
                <button type="submit">DELETE</button>
            </form>
            <form class="AdminForm" action="<%= request.getContextPath() %>/DeleteSubscriptionServlet">
                <label class="adminFormLabel" for="beachInput">Select the subscription:</label>
                <select name="userId" id="subscriptionToDelete">
                    <option value="0" selected="selected">--</option>
                    <%

                        List<SubscriptionDTO> subscriptions = DbManager.getAllSubscriptions(user);
                        for(int i = 0; i < subscriptions.size(); i++)
                        {
                    %>
                    <option value=<%= subscriptions.get(i).getIdSubscription() %>>
                        <%= subscriptions.get(i).getUsername().replace("\"", "") %>,
                        <%= subscriptions.get(i).getIdBeach() %>,
                        <%= subscriptions.get(i).getType().replace("\"", "") %>,
                        <%= subscriptions.get(i).getEndDate().replace("\"", "") %>
                    </option>
                    <%
                        }
                    %>
                </select>
                <button type="submit">DELETE</button>
            </form>
            <form class="AdminForm" action="<%= request.getContextPath() %>/DeleteBookingServlet">
                <label class="adminFormLabel" for="bookingToDelete">Select the booking:</label>
                <select name="bookingId" id="bookingToDelete">
                    <option value="0" selected="selected">--</option>
                    <%
                        List<BookingDTO> bookings = DbManager.getAllBookings(user);
                        for(int i = 0; i < bookings.size(); i++)
                        {
                    %>
                    <option value=<%= bookings.get(i).getIdBooking() %>>
                        <%= bookings.get(i).getUsername().replace("\"", "") %>,
                        <%= bookings.get(i).getIdBeach() %>,
                        <%= bookings.get(i).getDate().replace("\"", "") %>
                    </option>
                    <%
                        }
                    %>
                </select>
                <button type="submit">DELETE</button>
            </form>
        </div>
    </div>
</head>
</body>
</html>
