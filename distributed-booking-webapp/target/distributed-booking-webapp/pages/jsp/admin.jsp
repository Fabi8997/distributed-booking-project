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
        function displaySelectSub(elementValue) {
            let selectedId = elementValue.value;
            let subSelects = document.getElementsByClassName("subSelect");
            document.getElementById("subDiv").removeAttribute("hidden");
            for(let i = 0; i < subSelects.length; i++)
            {
                let currentSelect = subSelects[i];
                currentSelect.style.display = currentSelect.id == selectedId ? 'block' : 'none';
                currentSelect.hidden = currentSelect.id == selectedId ? 'false' : 'true';
            }
        }

        function displaySelectBookings(elementValue) {
            let selectedId = elementValue.value;
            let bookingSelects = document.getElementsByClassName("bookingSelect");
            document.getElementById("bookingDiv").removeAttribute("hidden");
            for(let i = 0; i < bookingSelects.length; i++)
            {
                let currentSelect = bookingSelects[i];
                currentSelect.style.display = currentSelect.id == selectedId ? 'block' : 'none';
                currentSelect.hidden = currentSelect.id == selectedId ? 'false' : 'true';
            }
        }
    </script>
    <style>
        .subSelect {
            display: none;
        }

        .bookingSelect {
            display: none;
        }
    </style>
</head>
<body>
    <header>
        <div class = "title">
            <h1><span>B</span>each <span>B</span>ooking</h1>
            <img src='<%= request.getContextPath() %>/images/sunbed.png' alt="BB">
        </div>
    </header>

    <ul class="topnav">
        <li><a class="active" href="<%= request.getContextPath() %>/AdminServlet">Admin Panel</a></li>
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
                <select name="userId" id="userToFindForSubscriptions" onchange="displaySelectSub(this)">
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
                <div hidden id="subDiv">
                    <label class="adminFormLabel">Select the subscription:</label>
                    <% for(int i = 0; i < users.size(); i++)
                        {
                    %>
                    <select hidden="hidden" name="subscriptionId" id="<%=users.get(i).getUserId()%>" class = "subSelect">
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
                </div>
            </form>
            <form class="AdminForm" action="<%= request.getContextPath() %>/DeleteBookingServlet">
                <label class="adminFormLabel" for="userToFindForBookings">Select the user:</label>
                <select name="userId" id="userToFindForBookings" onchange="displaySelectBookings(this)">
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
                <div hidden id="bookingDiv">
                    <label class="adminFormLabel">Select the booking:</label>
                    <% for(int i = 0; i < users.size(); i++)
                    {
                    %>
                    <select hidden="hidden" name="bookingId" id="<%=users.get(i).getUserId()%>" class="bookingSelect">
                        <option value="0" selected="selected">--</option>
                        <%
                            String currentUser = users.get(i).getUsername().replace("\"", "");
                            List<BookingDTO> bookings = DbManager.getUserBookings(currentUser, user);
                            for(int j = 0; j < bookings.size(); j++)
                            {
                        %>
                        <option value=<%= bookings.get(j).getIdBooking() %>>
                            <%= bookings.get(j).getUsername().replace("\"", "") %>,
                            <%= bookings.get(j).getIdBeach() %>,
                            <%= bookings.get(j).getDate().replace("\"", "") %>
                        </option>
                        <%
                            }
                        %>
                    </select>
                    <%
                        }
                    %>
                    <button type="submit">DELETE</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
