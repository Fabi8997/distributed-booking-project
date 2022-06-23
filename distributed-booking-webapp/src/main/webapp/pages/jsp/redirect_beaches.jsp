<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Redirect to homepage</title>
    <link rel="icon" type="image/png" href='<%= request.getContextPath() %>/images/sunbed.png'/>
</head>
<body onload="window.location.href = '<%=request.getContextPath()%>/BeachesServlet'">

</body>
</html>
