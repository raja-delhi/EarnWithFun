<%@include file="taglibs.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <link href="<c:url value="/resources/css/common.css" />" rel="stylesheet">
</head>
<body>
    <div class="row header">
            <div class="topnav">
              <span class="active"><h3>Welcome to Earn with Fun!</h3></span>
            </div>
            <div id="tabs">
                <button class="tabLink" onclick="openPage('Home', this, 'gray')" id="homeBtn">Home</button>
                <button class="tabLink" onclick="loadJsp('Login',this)" id="loginBtn">Login</button>
                <button class="tabLink" onclick="loadJsp('Signup',this)" id="signUpBtn">Sign Up</button>
                <button class="tabLink" onclick="loadJsp('AdminLogin', this)" id="adminLoginBtn">Admin</button>
            </div>
    </div>

    <div id="tabContentDiv">
        <div id="Home" class="tabContent">
          <h2>Home</h2>
          <p>Home is where the heart is..</p>
        </div>

        <div id="AdminLogin" class="tabContent">
        </div>

        <div id="Login" class="tabContent">
        </div>

        <div id="Signup" class="tabContent">

        </div>

        <div id="Forgot" class="tabContent">
            <div id="errorMessageForgot" style="color: yellow; text-align:center" class="hide"></div>
                <div class="container">
                    <form id="forgotPasswordForm" modalAttribute="user">
                        <h2 class="mb-3" style="text-align:center">Reset Password</h2>
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" id="username1" name="username" class="form-control" autocomplete="off" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">New Password</label>
                                <input type="password" id="password1" name="password" class="form-control" autocomplete="off" required>
                            </div>
                        <button id="forgotBtn" class="btn btn-primary" type="submit">Change Password</button>
                    </form>
                </div>
        </div>
    </div>
</body>
</html>
<script type="text/javascript">
    var activeTab = <c:out value="${activeTab}"/>;
    $(document).ready(function () {
            $("#forgotBtn").click(function (event) {
                $("#errorMessageForgot").hide();
                event.preventDefault();
                let form = $("#forgotPasswordForm");
                let url = "forgotPassword";
                $.ajax({
                    type: "POST",
                    url: url,
                    data: form.serialize(),
                    contentType: "application/x-www-form-urlencoded",
                    dataType: "json",
                    success: function (data) {
                        if(data.errorMessage != null){
                            $("#errorMessageForgot").show();
                            $("#errorMessageForgot").html('');
                            $("#errorMessageForgot").html(data.errorMessage);
                        }else{
                            $("#errorMessageForgot").show();
                            $("#errorMessageForgot").html('');
                            $("#errorMessageForgot").html(data.successMessage);
                            $("#username1").val('');
                            $("#password1").val('');
                        }
                    },
                    error: function (data) {
                        alert("Error occurred while submitting the form");
                    }
                });
            });
        });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value="/resources/js/common.js" />"></script>

