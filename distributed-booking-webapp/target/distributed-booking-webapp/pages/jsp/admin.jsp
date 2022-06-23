<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.BeachDTO" %>
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
    <link rel="icon" type="image/png" href='<%= request.getContextPath() %>/images/sunbed.png'/>


    <script>
        function displaySelect(elementValue) {
            let selectedId = elementValue.value;
            let subSelects = document.getElementsByClassName("subSelect");
            for(let i = 0; i < subSelects.length; i++)
            {
                let currentSelect = subSelects[i];
                currentSelect.style.display = currentSelect.id == selectedId ? 'block' : 'none';
            }
        }
    </script>
    <style>
        .subSelect {
            display: none;
        }
    </style>

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
                    <option value=0 selected="selected" disabled>--</option>
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
                <input type="number" id="slots" value=0>
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
                <label class="adminFormLabel" for="userToDelete">Select the user:</label>
                <select name="userId" id="userToFindForSubscriptions" onchange="displaySelect(this)">
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
                <label class="adminFormLabel" for="beachInput">Select the subscription:</label>
                <% for(int i = 0; i < users.size(); i++)
                    {
                %>
                <select name="subscriptionId" id="<%=users.get(i).getUserId()%>" class = "subSelect">
                    <option value="0" selected="selected">--</option>
                    <%
                            String currentUser = users.get(i).getUsername().replace("\"", "");
                            List<SubscriptionDTO> subscriptions = DbManager.getSubscriptionFromAnotherUser(currentUser, user);
                            for(int j = 0; j < subscriptions.size(); j++)
                            {
                    %>
                    <option value=<%= subscriptions.get(j).getIdSubscription() %>>
                        <%= subscriptions.get(j).getUsername().replace("\"", "") %>,
                        <%= subscriptions.get(j).getIdBeach() %>,
                        <%= subscriptions.get(j).getType().replace("\"", "") %>,
                        <%= subscriptions.get(j).getEndDate().replace("\"", "") %>
                    </option>
                    <%
                            }
                    %>
                </select>
                 <%
                     }
                 %>
                <button type="submit">DELETE</button>
            </form>
            <form class="AdminForm" action="<%= request.getContextPath() %>/DeleteBookingServlet">
                <label class="adminFormLabel" for="userToDelete">Select the user:</label>
                <select name="userId" id="userToFindForBookings">
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
