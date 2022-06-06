<%@ page import="dto.BeachDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="database.DbManager" %>
<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/generalStyle.css">
    <title>Auctions</title>

    <%
        String user = (String) session.getAttribute("user");

    %>

    <script>

        function addClickEvent() {
            let row;

            rows = document.getElementsByClassName("BeachRow");

            for(let i = 0; i < rows.length; i++)
            {
                row = rows[i];
                row.addEventListener("click", () => {
                    window.location.href = "<%=request.getContextPath()%>/#";
                });
            }
        }
    </script>

</head>
<body onload="addClickEvent()">

<div class="header">
    <h2>Distributed Auction</h2>
</div>

<ul class="topnav">
    <li><a class="active" href="<%= request.getContextPath() %>/BeachesServlet">Home</a></li>
    <li><a href="<%= request.getContextPath() %>/ProfileServlet">Profile</a></li>
    <li><a href="<%= request.getContextPath() %>/SubscriptionServlet">Subscriptions</a></li>
    <li id="logout"><a href="<%= request.getContextPath() %>/LogoutServlet" >
        <img src="<%= request.getContextPath() %>/images/logout3.png" alt="logout">
    </a></li>
</ul>

<div class="booking_content">

    <table class = "BeachTable" id="myTable">
        <tbody>

        <tr class="BeachRow" style= "background-image: url('<%= request.getContextPath() %>/images/spiaggiadimezzo.jpg')">
            <td>Spiaggia1</td>
            <td>Descrizione</td>
            <td>PostiDisponibili</td>
        </tr>
        <tr class="BeachRow" style= "background-image: url('<%= request.getContextPath() %>/images/spiaggiadimezzo.jpg')">
            <td>Spiaggia1</td>
            <td>Descrizione</td>
            <td>PostiDisponibili</td>
        </tr>
        <tr class="BeachRow" style= "background-image: url('<%= request.getContextPath() %>/images/spiaggiadimezzo.jpg')">
            <td>Spiaggia1</td>
            <td>Descrizione</td>
            <td>PostiDisponibili</td>
        </tr>

        </tbody>
    </table>
</div>
</body>
</html>
