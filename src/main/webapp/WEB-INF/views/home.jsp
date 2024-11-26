<%@include file="taglibs.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Earn with fun</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <link href="<c:url value="/resources/css/common.css" />" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body>
    <div class="row header">
            <div class="topnav">
              <span class="active">
                <h3 style="text-align:center">Welcome to Earn with Fun!</h3>
                <h4 style="text-align:center;color:black;">Refer more earn more...</h4>
              </span>
            </div>
            <div id="tabs">
                <button class="tabLink" style="width:33%" onclick="openPage('Home', this, 'gray');resetErrorOnForgot();" id="homeBtn">Home</button>
                <button class="tabLink" style="width:33%" onclick="loadJsp('Login',this);resetErrorOnForgot();" id="loginBtn">Login</button>
                <button class="tabLink" style="width:33%" onclick="loadJsp('Signup',this);resetErrorOnForgot();" id="signUpBtn">Sign Up</button>
            </div>
    </div>

    <div id="tabContentDiv">
        <div id="Home" class="tabContent">
            <%@include file="instruction.jsp" %>
        </div>

        <div id="Login" class="tabContent">
        </div>

        <div id="Signup" class="tabContent">
        </div>
        <div id="Forgot" class="tabContent">
            <div id="errorMessageForgot" style="color: yellow; text-align:center" class="hide"></div>
                <div class="container">
                    <form id="forgotPasswordForm" modalAttribute="user">
                        <h2 class="mb-3" style="text-align:center;text-decoration: underline;">Reset Password</h2>
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
   <div class="modal fade" id="instructions" tabindex="-1" role="dialog" aria-labelledby="Instructions" aria-hidden="true">
         <div class="modal-dialog modal-dialog-centered" role="document">
           <div class="modal-content">
             <div class="modal-header">
               <h5 class="modal-title" id="exampleModalLongTitle">Instructions</h5>
               <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                 <span aria-hidden="true">&times;</span>
               </button>
             </div>
             <div class="modal-body">

             </div>
             <div class="modal-footer">
               <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
             </div>
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
    function resetErrorOnForgot(){
        $("#errorMessageForgot").hide();
        $("#errorMessageForgot").html('');
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value="/resources/js/common.js" />"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
