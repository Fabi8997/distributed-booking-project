<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%
        String user = (String) session.getAttribute("user");
        System.out.println("Retrieving the information for "+user+"...");
        int subscriptionId = DbManager.getSubscriptionFromUser(user);
        SubscriptionDTO subscription = DbManager.getSubscription(subscriptionId, user);
        String subType;
        if(subscription == null){
            subType = "None";
        }
        else{
            subType = subscription.getType();
        }
        List<SubscriptionDTO> subscriptions = DbManager.getAllSubscriptions(user);
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
        <label>Your subscription</label>
        <input class="idSub" type="hidden" name="idSub" value="<%= subType %>">
        <a id="addSub" href="<%= request.getContextPath() %>/SubscriptionServlet">Add a new subscription</a>
    </div>
</div>
</head>
</body>
</html>
