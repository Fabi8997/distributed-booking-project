<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="dto.BeachDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="utility.Utils" %>
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
  List<SubscriptionDTO> subscriptions = DbManager.getSubscriptionFromUser(user);
  List<BeachDTO> beaches = DbManager.getBeaches(user);
%>
<div class="header">
  <h2>Beach Booking</h2>
</div>

<ul class="topnav">
  <li><a href="<%= request.getContextPath() %>/BeachesServlet">Home</a></li>
  <li><a href="<%= request.getContextPath() %>/ProfileServlet">Profile</a></li>
  <li><a class="active" href="<%= request.getContextPath() %>/SubscriptionServlet">Subscriptions</a></li>
  <li id="logout"><a href="<%= request.getContextPath() %>/LogoutServlet" >
    <img src="<%= request.getContextPath() %>/images/logout3.png" alt="logout">
  </a></li>
</ul>

<div class="ViewBookingContent">
  <h3 id="titleAdd">Add a subscription to your account:</h3>

  <form class="ViewSubscriptionContentForm" action="<%= request.getContextPath() %>/AddSubscriptionServlet">
    <label class="subFormLabel" for="beachInput">Select the beach:</label>
    <select name="beachId" id="beachInput">
      <option value="0" selected="selected">--</option>
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
    <label class="subFormLabel" for="subInput">Select the subscription type:</label>
    <select name="subTypes" id="subInput">
      <option value="none" selected="selected">--</option>
      <option value="weekly">Weekly</option>
      <option value="biweekly">Biweekly</option>
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