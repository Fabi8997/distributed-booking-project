<%@ page import="utility.Utils" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>New Good</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/indexStyle.css">
    <script src="<%= request.getContextPath() %>/javascript/utils.js"></script>

</head>
<body>
<div class="newFormCard">
    <form class="ViewAuctionContentForm" action="<%= request.getContextPath() %>/AddBookingServlet">
        <label>
            <input type="text" name="nameGood" placeholder="Insert Name" maxlength="15" required>
        </label>
        <label>
            <textarea placeholder="Insert a description of the good" rows="4" name="description" required></textarea>
        </label>
        <label for="date"></label><input required type="date" id="date" name="booking-date" value=<%=Utils.getDateNow()%> min=<%=Utils.getDateNow()%> max=<%=Utils.getDateNext(2)%>>

        <input type="submit" class="login login-submit" value="Insert booking" name="add_booking">
    </form>
    <button id="back_btn" class="login login-submit" value="back" name="back" onclick="reloadAndClose()">Back</button>
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
