<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/indexStyle.css">
    <title>Registration</title>
</head>
<body>


<div class="login-card">
    <h1>Sign-Up</h1><br>
    <form method="post" action="<%= request.getContextPath() %>/SignUpServlet">
        <label>
            <input type="text" name="user" placeholder="Username" maxlength="15" required>
        </label>
        <label>
            <input id="psw" type="password" name="pass" placeholder="Password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Must contain at least: &#013; 1 number &#013; 1 uppercase &#013; 1 lowercase letter &#013; 8 or more characters" required>
        </label>
        <label>
            <input id="confirm_psw" type="password" name="pass" placeholder="Confirm Password" required>
        </label>
        <input type="submit" name="signup" class="login login-submit" value="Sign Up">
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

<script>
    const password = document.getElementById("psw")
        , confirm_password = document.getElementById("confirm_psw");

    function validatePassword(){
        if(password.value !== confirm_password.value) {
            confirm_password.setCustomValidity("Passwords don't match");
        } else {
            confirm_password.setCustomValidity('');
        }
    }

    password.onchange = validatePassword;
    confirm_password.onkeyup = validatePassword;
</script>

</body>
</html>
