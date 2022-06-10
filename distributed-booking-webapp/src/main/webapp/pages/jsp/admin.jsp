<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.BeachDTO" %>
<%@ page import="utility.Utils" %>
<%@ page import="dto.BookingDTO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%
        String user = (String) session.getAttribute("user");
        System.out.println("Retrieving the information for "+user+"...");
        List<BeachDTO> beaches = DbManager.getBeaches(user);
    %>

    %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/generalStyle.css">
    <title>Administration Panel</title>

    <div class="header">
        <h2>Beach Booking</h2>
    </div>

    <ul class="topnav">
        <li><a href="<%= request.getContextPath() %>/BeachesServlet">Home</a></li>
        <li><a href="<%= request.getContextPath() %>/ProfileServlet">Profile</a></li>
        <li><a href="<%= request.getContextPath() %>/SubscriptionServlet">Subscriptions</a></li>
        <% if(Utils.isAdmin(user))
        {
        %>
        <li><a href="<%= request.getContextPath() %>/AdminServlet">AdminPanel</a></li>
        <%
            }
        %>
        <li id="logout"><a href="<%= request.getContextPath() %>/LogoutServlet" >
            <img src="<%= request.getContextPath() %>/images/logout3.png" alt="logout">
        </a></li>
    </ul>

    <div class="booking_content">
        <div id="auction_content_actions">
            <form class="ViewBookingContentForm" action="<%= request.getContextPath() %>/UpdateBeachServlet">
                <label for="beachInput">Select the beach:</label>
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
                <label for="subInput">Select the subscription type:</label>
                <select name="subTypes" id="subInput">
                    <option value="none" selected="selected" disabled>--</option>
                    <option value="weekly">Weekly</option>
                    <option value="monthly">Monthly</option>
                </select>
                <button type="submit">ADD</button>
            </form>
            <form class="ViewBookingContentForm" action="<%= request.getContextPath() %>/DeleteUserServlet">
                <label for="beachInput">Select the user:</label>
                <select name="userId" id="userToDelete">
                    <option value="0" selected="selected" disabled>--</option>
                    <%
                        for(int i = 0; i < beaches.size(); i++)
                        {
                    %>
                    <option value=<%= beaches.get(i).getBeachId() %>>
                        <%= beaches.get(i).getName().replace("\"", "") %>
                    </option>
                    <%
                        }
                    %>
                </select>
                <button type="submit">ADD</button>
            </form>
            <form class="ViewBookingContentForm" action="<%= request.getContextPath() %>/DeleteSubscriptionServlet">
                <label for="beachInput">Select the user:</label>
                <select name="userId" id="subscriptionToDelete">
                    <option value="0" selected="selected" disabled>--</option>
                    <%

                        List<SubscriptionDTO> subscriptions = DbManager.getAllSubscriptions(user);
                        for(int i = 0; i < beaches.size(); i++)
                        {
                    %>
                    <option value=<%= beaches.get(i).getBeachId() %>>
                        <%= beaches.get(i).getName().replace("\"", "") %>
                    </option>
                    <%
                        }
                    %>
                </select>
                <button type="submit">ADD</button>
            </form>
            <form class="ViewBookingContentForm" action="<%= request.getContextPath() %>/DeleteBookingServlet">
                <label for="beachInput">Select the user:</label>
                <select name="userId" id="bookingToDelete">
                    <option value="0" selected="selected" disabled>--</option>
                    <%
                        List<BookingDTO> bookings = DbManager.getAllBookings(user);
                        for(int i = 0; i < beaches.size(); i++)
                        {
                    %>
                    <option value=<%= beaches.get(i).getBeachId() %>>
                        <%= beaches.get(i).getName().replace("\"", "") %>
                    </option>
                    <%
                        }
                    %>
                </select>
                <button type="submit">ADD</button>
            </form>
        </div>
    </div>
</head>
</body>
</html>
