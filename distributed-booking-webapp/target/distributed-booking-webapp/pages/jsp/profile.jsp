<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="utility.Utils" %>
<%@ page import="dto.BookingDTO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%
        String user = (String) session.getAttribute("user");
        System.out.println("Retrieving the information for "+user+"...");
        List<SubscriptionDTO> subscriptions = DbManager.getSubscriptionFromUser(user);
        List<BookingDTO> bookings = DbManager.getAllBookings(user);
    %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/generalStyle.css">
    <title>Your personal area</title>

    <div class="header">
        <h2>Beach Booking</h2>
    </div>

    <ul class="topnav">
        <li><a href="<%= request.getContextPath() %>/BeachesServlet">Home</a></li>
        <li><a class="active" href="<%= request.getContextPath() %>/ProfileServlet">Profile</a></li>
        <li><a href="<%= request.getContextPath() %>/SubscriptionServlet">Subscriptions</a></li>
        <li id="logout"><a href="<%= request.getContextPath() %>/LogoutServlet" >
            <img src="<%= request.getContextPath() %>/images/logout3.png" alt="logout">
        </a></li>
    </ul>

    <div class="booking_content">
        <div>
            <h3 class="profileLabel">Your subscriptions</h3>
            <table id="myTable">
                <thead>
                <tr>
                    <th scope="col" style="display: none;"></th>
                    <th scope="col">Type</th>
                    <th scope="col">Beach</th>
                    <th scope="col">Description</th>
                    <th scope="col">Status</th>
                    <th scope="col">EndDate</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for(int i = 0; i < subscriptions.size(); i++) {
                %>
                <tr id = "row-<%=i%>">
                    <td style="display:none;"><input class="idSubCell" type="hidden" name="subCell" value="<%=subscriptions.get(i).getIdSubscription()%>"></td>
                    <td><%=subscriptions.get(i).getType().replace("\"", "")%></td>
                    <td><%=DbManager.getBeach(subscriptions.get(i).getIdBeach(), user).getName().replace("\"", "")%></td>
                    <td><label>
                        <textarea readonly rows="2"><%=DbManager.getBeach(subscriptions.get(i).getIdBeach(), user).getDescription().replace("\"", "")%></textarea>
                    </label></td>
                    <td><%=subscriptions.get(i).getStatus().replace("\"", "")%></td>
                    <td><%=subscriptions.get(i).getEndDate().replace("\"", "")%></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <div>
            <h3 class="profileLabel">Your bookings</h3>
            <table id="bookingTable">
                <thead>
                <tr>
                    <th scope="col" style="display: none;"></th>
                    <th scope="col">Type</th>
                    <th scope="col">Beach</th>
                    <th scope="col">EndDate</th>
                    <!--<th scope="col"></th>-->
                </tr>
                </thead>
                <tbody>
                <%
                    for(int i = 0; i < bookings.size(); i++) {
                %>
                    <tr id = "row-<%=i%>">
                        <td style="display:none;"><input type="hidden" value="<%=bookings.get(i).getIdBooking()%>"></td>
                        <td><%=bookings.get(i).getType().replace("\"", "")%></td>
                        <td><%=DbManager.getBeach(bookings.get(i).getIdBeach(), user).getName().replace("\"", "")%></td>
                        <td><%=bookings.get(i).getDate().replace("\"", "")%></td>
                        <!--<td><button>DELETE</button></td>-->
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</head>
</body>
</html>