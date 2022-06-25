<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="dto.BeachDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="utility.Utils" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/generalStyle.css">
  <title>Make a new subscription</title>
  <link rel="icon" type="image/png" href='<%= request.getContextPath() %>/images/sunbed.png'/>
</head>
<body>

  <%
    String user = (String) session.getAttribute("user");
    System.out.println("Retrieving the information for "+user+"...");
    List<SubscriptionDTO> subscriptions = DbManager.getSubscriptionFromUser(user);
    List<BeachDTO> beaches = DbManager.getBeaches(user);
  %>

  <header>
    <div class = "title">
      <h1><span>B</span>each <span>B</span>ooking</h1>
      <img src='<%= request.getContextPath() %>/images/sunbed.png' alt="BB">
    </div>
  </header>

  <ul class="topnav">
    <li><a href="<%= request.getContextPath() %>/BeachesServlet">Home</a></li>
    <li><a href="<%= request.getContextPath() %>/ProfileServlet">Profile</a></li>
    <li><a class="active" href="<%= request.getContextPath() %>/SubscriptionServlet">Subscriptions</a></li>
    <li id="logout"><a href="<%= request.getContextPath() %>/LogoutServlet" >
      <img src="<%= request.getContextPath() %>/images/logout3.png" alt="logout">
    </a></li>
  </ul>

  <div class="ViewSubscriptionContent">
    <h3 id="titleAdd">Add a subscription to your account:</h3>

    <form class="ViewSubscriptionContentForm" action="<%= request.getContextPath() %>/AddSubscriptionServlet">
      <label class="subFormLabel" for="beachInput">Select the beach:</label>
      <select name="idBeach" id="beachInput" required>
        <option value="" disabled selected>Select your option</option>
        <%
          for (BeachDTO beach : beaches) {
            boolean subPresent = false;
            for (SubscriptionDTO subscription : subscriptions) {
              if (subscription.getIdBeach() == beach.getBeachId()) {
                subPresent = true;
                break;
              }
            }
            if (!subPresent) {
        %>
        <option value=<%= beach.getBeachId() %>>
          <%= beach.getName().replace("\"", "") %>
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
      <select name="subscription-type" id="subInput" required>
        <option value="" disabled selected>Select your option</option>
        <option value="weekly">Weekly</option>
        <option value="biweekly">Biweekly</option>
      </select>
      <label class="subFormLabel" for="booking_type">Select the booking type:</label>
      <select id="booking_type" name="booking-type" required>
        <option value="" disabled selected>Select your option</option>
        <option value="morning">Morning</option>
        <option value="afternoon">Afternoon</option>
        <option value="all_day">All day</option>
      </select>
      <label class="subFormLabel" for="date"></label>
      <input required type="date" id="date" name="starting-date" value=<%=Utils.getDateNow()%> min=<%=Utils.getDateNow()%> max="2022-08-24">

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