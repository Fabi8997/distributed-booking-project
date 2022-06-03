<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="styles/indexStyle.css">
    <title>Login</title>
</head>
<body>


<div class="login-card">
    <h1>Log-in</h1><br>
    <form method="post" action="<%= request.getContextPath() %>/LoginServlet">
        <label>
            <input type="text" name="user" placeholder="Username" minlength="5" maxlength="15" required>
        </label>
        <label>
            <input type="password" name="pass" placeholder="Password" required>
        </label>
        <input type="submit" name="login" class="login login-submit" value="login">
    </form>

    <div class="login-help">
        <%
            if(request.getAttribute("error") != null){
        %>
        <p id="error"><%= request.getAttribute("error")%></p>
        <% }else if(request.getAttribute("info") != null){%>
        <p id="info"><%= request.getAttribute("info")%></p>
        <% }%>
        <a href="<%= request.getContextPath() %>/pages/jsp/register.jsp">Register</a>
    </div>
</div>

</body>
</html>
