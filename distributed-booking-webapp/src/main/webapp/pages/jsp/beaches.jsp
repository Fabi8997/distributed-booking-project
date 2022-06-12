<%@ page import="dto.SlotsDTO" %>
<%@ page import="database.DbManager" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/generalStyle.css">
    <title>Auctions</title>

    <%
        String user = (String) session.getAttribute("user");
        SlotsDTO slotsBeach0 = DbManager.getAvailableSlots(user, 0);
        SlotsDTO slotsBeach1 = DbManager.getAvailableSlots(user, 1);
        SlotsDTO slotsBeach2 = DbManager.getAvailableSlots(user, 2);

        assert slotsBeach0 != null;%>

    <script>

        //variable to track the popupwindow
        let popupWindow = null;

        function addClickEvent() {
            let row;

            let rows = document.getElementsByClassName("BeachRow");

            for(let i = 0; i < rows.length; i++)
            {
                row = rows[i];
                row.addEventListener("click", () => {
                    openPopupWindow(500,570,i);
                });
            }
        }

        //Open the popup window with width = w , height = h, newGood is a boolean to decide which page we need
        //the last attribute is useful only if newGood is equal to false
        function openPopupWindow(w, h,idBeach) {
            const y = window.top.outerHeight / 2 + window.top.screenY - ( h / 2);
            const x = window.top.outerWidth / 2 + window.top.screenX - ( w / 2);

            popupWindow = window.open('<%=request.getContextPath()%>/NewBookingServlet?idBeach=' + idBeach.toString(), 'targetWindow', 'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=' + w + ',height=' + h + ' top=' + y + ', left=' + x);

            document.getElementById("overlay").style.display = "block";
            document.body.style.filter = "blur(1px)";
        }

        //focus on the popup window if exists, otherwise remove the overlay from the parent page
        function parent_disable() {
            if(popupWindow && !popupWindow.closed)
                popupWindow.focus();
            else {
                document.getElementById("overlay").style.display = "none";
                document.body.style.filter = "none";
            }

        }
    </script>

</head>
<body onload="addClickEvent();" onfocus="parent_disable();" onclick="parent_disable();">

<div id="overlay">

</div>

<div class="header">
    <h2>Beach Booking</h2>
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

        <tr id="beach1" class="BeachRow" style= "background-image: url('<%= request.getContextPath() %>/images/spiaggiadimezzo.jpg')">
            <td>Plagemesu</td>
            <td>Descrizione</td>
            <td>
                <% if(slotsBeach0.getMorningSlots() > 0){%>
                <p>Morning: <em class="FreeSlots"><%=slotsBeach0.getMorningSlots()%></em> slots</p>
                <%} else {%>
                <p>Morning: <em class="Full">Full</em></p>
                <%}%>
                <% if(slotsBeach0.getAfternoonSlots() > 0){%>
                <p>Afternoon: <em class="FreeSlots"><%=slotsBeach0.getAfternoonSlots()%></em> slots</p>
                <%} else {%>
                <p>Afternoon: <em class="Full">Full</em></p>
                <%}%>
            </td>
        </tr>
        <tr id="beach2" class="BeachRow" style= "background-image: url('<%= request.getContextPath() %>/images/masua.jpg')">
            <td>Masua</td>
            <td>Descrizione</td>
            <td>
                <% assert slotsBeach1 != null;
                if(slotsBeach1.getMorningSlots() > 0){%>
                <p>Morning: <em class="FreeSlots"><%=slotsBeach1.getMorningSlots()%></em> slots</p>
                <%} else {%>
                <p>Morning: <em class="Full">Full</em></p>
                <%}%>
                <% if(slotsBeach1.getAfternoonSlots() > 0){%>
                <p>Afternoon: <em class="FreeSlots"><%=slotsBeach1.getAfternoonSlots()%></em> slots</p>
                <%} else {%>
                <p>Afternoon: <em class="Full">Full</em></p>
                <%}%>
            </td>
        </tr>
        <tr id="beach3" class="BeachRow" style= "background-image: url('<%= request.getContextPath() %>/images/portopino.jpg')">
            <td>Porto Pino</td>
            <td>Descrizione</td>
            <td>
                <% assert slotsBeach2 != null;
                if(slotsBeach2.getMorningSlots() > 0){%>
                <p>Morning: <em class="FreeSlots"><%=slotsBeach2.getMorningSlots()%></em> slots</p>
                <%} else {%>
                <p>Morning: <em class="Full">Full</em></p>
                <%}%>
                <% if(slotsBeach2.getAfternoonSlots() > 0){%>
                <p>Afternoon: <em class="FreeSlots"><%=slotsBeach2.getAfternoonSlots()%></em> slots</p>
                <%} else {%>
                <p>Afternoon: <em class="Full">Full</em></p>
                <%}%>
            </td>
        </tr>

        </tbody>
    </table>
</div>
</body>
</html>
