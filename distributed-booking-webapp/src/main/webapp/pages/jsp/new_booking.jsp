<%@ page import="utility.Utils" %>
<%@ page import="dto.BeachDTO" %>
<%@ page import="database.DbManager" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>New Booking</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/indexStyle.css">
    <script src="<%= request.getContextPath() %>/javascript/utils.js"></script>
</head>
<body>

<%
    String user = (String) session.getAttribute("user");
    String idBeachStr = (request.getAttribute("idBeach") != null)?(String) request.getAttribute("idBeach"):request.getParameter("idBeach");
    int idBeach = Integer.parseInt (idBeachStr);
    System.out.println("[new_booking] idBeach: " + idBeach);
    BeachDTO beach = DbManager.getBeach(idBeach,user);
    assert beach != null;%>

<div class="newFormCard">
    <form class="ViewAuctionContentForm" action="<%= request.getContextPath() %>/AddBookingServlet">
        <input type="hidden" name="idBeach" value="<%=idBeach%>">
        <label>
            <input type="text" name="nameBeach" value="<%=beach.getName()%>" disabled>
        </label>
        <label>
            <textarea rows="4" name="descriptionBeach" disabled><%=beach.getDescription()%></textarea>
        </label>
        <label for="date"></label><input required type="date" id="date" name="booking-date" value=<%=Utils.getDateNow()%> min=<%=Utils.getDateNow()%> max=<%=Utils.getDateNext(2)%>>
        <label for="booking_type"></label><select id="booking_type" name="booking-type" required>
            <option value="" disabled selected>Select your option</option>
            <option value="morning">Morning</option>
            <option value="afternoon">Afternoon</option>
            <option value="all_day">All day</option>
        </select>
        <input type="submit" class="login login-submit" value="Insert booking" name="add_booking">
    </form>
    <button id="back_btn" class="login login-submit" value="back" name="back" onclick="reloadAndClose()">Back</button>
    <%
        if(request.getAttribute("error") != null){
    %>
    <p id="error"><%= request.getAttribute("error")%></p>
    <% }else if(request.getAttribute("info") != null){
        // TODO: 16/06/2022 aggiungere il controllo solo sulla data odierna
        //if(date == current-date => send!)
    %>
    <p id="info"><%= request.getAttribute("info")%></p>
    <script>window.opener.send("<%=beach.getBeachId()%>")</script>
    <% }%>
</div>
</body>
</html>
