<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.BeachDTO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%
        String user = (String) session.getAttribute("user");
        System.out.println("Retrieving the information for "+user+"...");
        List<SubscriptionDTO> subscriptions = DbManager.getAllSubscriptions(user);
        List<BeachDTO> beaches = DbManager.getBeaches(user);
    %>

    %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/generalStyle.css">
    <title>Your personal area</title>

    <div class="header">
        <h2>Beach Booking</h2>
    </div>

    <ul class="topnav">
        <li><a href="<%= request.getContextPath() %>/BeachesServlet">Home</a></li>
        <li><a href="<%= request.getContextPath() %>/ProfileServlet">Profile</a></li>
        <li><a href="<%= request.getContextPath() %>/SubscriptionServlet">Subscriptions</a></li>
        <li id="logout"><a href="<%= request.getContextPath() %>/LogoutServlet" >
            <img src="<%= request.getContextPath() %>/images/logout3.png" alt="logout">
        </a></li>
    </ul>

    <div class="booking_content">
        <div id="auction_content_actions">
            <form class="ViewBookingContentForm" action="<%= request.getContextPath() %>/AddSubscriptionServlet">
                <label for="beachInput">Select the beach:</label>
                <select name="beachId" id="beachInput">
                    <option value="0" selected="selected" disabled>--</option>
                    <%
                        for(int i = 0; i < beaches.size(); i++) {
                            boolean subPresent = false;
                            for(int j = 0; j < subscriptions.size(); j++) {
                                if (subscriptions.get(j).getIdBeach() == beaches.get(i).getBeachId()) {
                                    subPresent = true;
                                }
                            }
                            if(!subPresent){
                    %>
                    <option value=<%= beaches.get(i).getBeachId() %>>
                        <%= beaches.get(i).getName().replace("\"", "") %>
                        <!--label>
                          <textarea readonly rows="2"><!%=/*beaches.get(i).getDescription().replace("\"", "")*/%></textarea>
                        </label-->
                    </option>
                    <%
                            }
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
        </div>
    </div>
</head>
</body>
</html>
