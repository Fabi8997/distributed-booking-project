<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/generalStyle.css">
  <title>Make a new subscription</title>
</head>
<body>
<%
  String user = (String) session.getAttribute("user");
  System.out.println("Retrieving the information for "+user+"...");
  int subscriptionId = DbManager.getSubscriptionFromUser(user);
  SubscriptionDTO subscription = DbManager.getSubscription(subscriptionId, user);
%>
<div class="header">
  <h2>Beach Booking</h2>
</div>

<ul class="topnav">
  <li><a href="<%= request.getContextPath() %>/HomepageServlet">Home</a></li>
  <li><a href="<%= request.getContextPath() %>/AuctionsServlet">Beaches</a></li>
  <li><a href="<%= request.getContextPath() %>/ProfileServlet">Profile</a></li>
  <li id="logout"><a href="<%= request.getContextPath() %>/LogoutServlet" >
    <img src="<%= request.getContextPath() %>/images/logout3.png" alt="logout">
  </a></li>
</ul>


<div class="ViewAuctionContent">
  <h3 id="titleAdd">Add a subscription to your account:</h3>

  <form class="ViewAuctionContentForm" action="<%= request.getContextPath() %>/AddSubscriptionServlet">
    <label for="subInput">Select the subscription type:</label>
    <select name="subTypes" id="subInput">
      <option value="none" selected="selected" disabled>--</option>
      <option value="weekly">Weekly</option>
      <option value="monthly">Monthly</option>
    </select>
    <button type="submit">ADD</button>
  </form>
  <%
    if(request.getAttribute("error") != null){
  %>
  <p id="error"><%= request.getAttribute("error")%></p>
  <% }else if(request.getAttribute("info") != null){%>
  <p id="info"><%= request.getAttribute("info")%></p>
  <% }%>
</div>


</body>
</html>
