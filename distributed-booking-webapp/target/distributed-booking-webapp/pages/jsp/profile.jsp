<%@ page import="database.DbManager" %>
<%@ page import="dto.SubscriptionDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="utility.Utils" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%
        String user = (String) session.getAttribute("user");
        System.out.println("Retrieving the information for "+user+"...");
        List<SubscriptionDTO> subscriptions = DbManager.getSubscriptionFromUser(user);
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
        <label>Your subscriptions</label>
        <table id="myTable">
            <thead>
            <tr>
                <th scope="col" style="display: none;"></th>
                <th scope="col">Type</th>
                <th scope="col">Beach</th>
                <th scope="col">Status</th>
                <th scope="col">EndDate</th>
            </tr>
            </thead>
            <tbody>
            <%
                for(int i = 0; i < subscriptions.size(); i++) {
            %>
            <tr id = "row-<%=i%>">
                <td style="display:none;"><input class="idGood" type="hidden" name="idGood" value="<%=subscriptions.get(i).getIdSubscription()%>"></td>
                <td><%=subscriptions.get(i).getType().replace("\"", "")%></td>
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
</div>
</head>
</body>
</html>
