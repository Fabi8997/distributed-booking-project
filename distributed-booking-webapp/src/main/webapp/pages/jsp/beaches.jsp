<%@ page import="dto.SlotsDTO" %>
<%@ page import="database.DbManager" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/generalStyle.css">
    <title>Beaches</title>
    <link rel="icon" type="image/png" href='<%= request.getContextPath() %>/images/sunbed.png'/>

    <%
        String user = (String) session.getAttribute("user");
        SlotsDTO slotsBeach1 = DbManager.getAvailableSlots(user, 1);
        SlotsDTO slotsBeach2 = DbManager.getAvailableSlots(user, 2);
        SlotsDTO slotsBeach3 = DbManager.getAvailableSlots(user, 3);

        assert slotsBeach1 != null;%>

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
                    openPopupWindow(500,570,i+1);
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
<body onload="addClickEvent(); connect();" onfocus="parent_disable();" onclick="parent_disable();">

<div id="overlay">

</div>

<header>
    <div class = "title">
        <h1><span>B</span>each <span>B</span>ooking</h1>
        <img src='<%= request.getContextPath() %>/images/sunbed.png' alt="BB">
    </div>
</header>


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
                <% if(slotsBeach1.getMorningSlots() > 0){%>
                <p>Morning: <em class="FreeSlotsMorning"><%=slotsBeach1.getMorningSlots()%></em> slots</p>
                <%} else {%>
                <p>Morning: <em class="Full">Full</em></p>
                <%}%>
                <% if(slotsBeach1.getAfternoonSlots() > 0){%>
                <p>Afternoon: <em class="FreeSlotsAfternoon"><%=slotsBeach1.getAfternoonSlots()%></em> slots</p>
                <%} else {%>
                <p>Afternoon: <em class="Full">Full</em></p>
                <%}%>
            </td>
        </tr>
        <tr id="beach2" class="BeachRow" style= "background-image: url('<%= request.getContextPath() %>/images/masua.jpg')">
            <td>Masua</td>
            <td>Descrizione</td>
            <td>
                <% assert slotsBeach2 != null;
                if(slotsBeach2.getMorningSlots() > 0){%>
                <p>Morning: <em class="FreeSlotsMorning"><%=slotsBeach2.getMorningSlots()%></em> slots</p>
                <%} else {%>
                <p>Morning: <em class="Full">Full</em></p>
                <%}%>
                <% if(slotsBeach2.getAfternoonSlots() > 0){%>
                <p>Afternoon: <em class="FreeSlotsAfternoon"><%=slotsBeach2.getAfternoonSlots()%></em> slots</p>
                <%} else {%>
                <p>Afternoon: <em class="Full">Full</em></p>
                <%}%>
            </td>
        </tr>
        <tr id="beach3" class="BeachRow" style= "background-image: url('<%= request.getContextPath() %>/images/portopino.jpg')">
            <td>Porto Pino</td>
            <td>Descrizione</td>
            <td>
                <% assert slotsBeach3 != null;
                if(slotsBeach3.getMorningSlots() > 0){%>
                <p>Morning: <em class="FreeSlotsMorning"><%=slotsBeach3.getMorningSlots()%></em> slots</p>
                <%} else {%>
                <p>Morning: <em class="Full">Full</em></p>
                <%}%>
                <% if(slotsBeach3.getAfternoonSlots() > 0){%>
                <p>Afternoon: <em class="FreeSlotsAfternoon"><%=slotsBeach3.getAfternoonSlots()%></em> slots</p>
                <%} else {%>
                <p>Afternoon: <em class="Full">Full</em></p>
                <%}%>
            </td>
        </tr>

        </tbody>
    </table>
</div>
</body>
<script src="${pageContext.request.contextPath}/javascript/websocket.js"></script>
</html>
