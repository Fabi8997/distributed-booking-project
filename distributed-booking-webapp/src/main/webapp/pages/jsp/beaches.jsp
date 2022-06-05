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

            row = document.getElementById("row-"+1);

            row.addEventListener("click", () => {
                window.location.href = "<%=request.getContextPath()%>/#";
            });
        }
    </script>

</head>
<body onload="addClickEvent()">

<div class="header">
    <h2>Distributed Auction</h2>
</div>

<ul class="topnav">
    <li><a class="active" href="<%= request.getContextPath() %>/HomepageServlet">Home</a></li>
    <li><a href="<%= request.getContextPath() %>/AuctionsServlet">Beaches</a></li>
    <li><a href="<%= request.getContextPath() %>/ProfileServlet">Profile</a></li>
    <li id="logout"><a href="<%= request.getContextPath() %>/LogoutServlet" >
        <img src="<%= request.getContextPath() %>/images/logout3.png" alt="logout">
    </a></li>
</ul>

<div class="auction_content">

    <h3>List of available auctions</h3>

    <label for="myInputAuct"></label><input style= "background-image: url('<%= request.getContextPath() %>/images/searchicon.png');" type="text" id="myInputAuct" onkeyup="myFunction()" placeholder="Search for names..">

    <table id="myTable">
        <thead>
        <tr>
            <th scope="col">Good</th>
            <th scope="col">Seller</th>
            <th scope="col">CurrentPrice</th>
            <th scope="col">Countdown</th>
        </tr>
        </thead>
        <tbody>

        <tr id = "row-1">
            <td>prova</td>
            <td>prova</td>
            <td>prova</td>
            <td>prova</td>
        </tr>
        <tr id = "row-2">
            <td>prova</td>
            <td>prova</td>
            <td>prova</td>
            <td>prova</td>
        </tr>
        <tr id = "row-3">
            <td>prova</td>
            <td>prova</td>
            <td>prova</td>
            <td>prova</td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>
