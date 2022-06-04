<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="dto.BeachDTO" %>
<%@ page import="java.util.List" %>
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
  // TODO: 04/06/2022 getSub can return [] !! --> Solved but still to test!
  int subscriptionId = DbManager.getSubscriptionFromUser(user);
  SubscriptionDTO subscription = DbManager.getSubscription(subscriptionId, user);
  String type;
  if(subscription == null){
    type = "none";
  }
  else{
    type = subscription.getType();
  }
  List<BeachDTO> beaches = DbManager.getBeaches(user);
%>
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

<%
  //TODO 04/06/2022: test the form!!
%>

<div class="ViewBookingContent">
  <h3 id="titleAdd">Add a subscription to your account:</h3>

  <form class="ViewBookingContentForm" action="<%= request.getContextPath() %>/AddSubscriptionServlet">
    <label for="beachInput">Select the beach:</label>
    <select name="beachId" id="beachInput">
      <%
        for(int i = 0; i < beaches.size(); i++) {
      %>
      <option value=<%=beaches.get(i).getBeachId()%>><label>
        <textarea readonly rows="2"><%=beaches.get(i).getDescription().replace("\"", "")%></textarea>
      </label></option>
      <% } %>
    </select>
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
