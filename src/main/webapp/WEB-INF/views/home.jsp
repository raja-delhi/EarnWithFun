<%@include file="taglibs.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <link href="<c:url value="/resources/css/common.css" />" rel="stylesheet">
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
                <button class="tabLink" onclick="openPage('Home', this, 'gray');resetErrorOnForgot();" id="homeBtn">Home</button>
                <button class="tabLink" onclick="loadJsp('Login',this);resetErrorOnForgot();" id="loginBtn">Login</button>
                <button class="tabLink" onclick="loadJsp('Signup',this);resetErrorOnForgot();" id="signUpBtn">Sign Up</button>
                <button class="tabLink" onclick="loadJsp('AdminLogin', this);resetErrorOnForgot();" id="adminLoginBtn">Admin</button>
            </div>
    </div>

    <div id="tabContentDiv">
        <div id="Home" class="tabContent">
          <div id="homeContent">
                <h4 style="color:orange;text-decoration: underline;"><b>Steps to Create account and Login.</b></h4>
                <h6>1. First you need to go Sign up page to create account. and while creation account you need a referral code. if you don not have Referral Code. contact person who gave this link to you. else contact on Contact No. +91 9797317200.</h6>
                <h6>2. After Registration Successfully you need to do payment, Payment amount should be equal to Payment Plan which you selected at the time of Account Creation. For payment you need to share your username on +91 9797317200 Whatsapp or call on this Number. then you will receive a bar code for payment from this number.</h6>
                <h6>3. After your Payment done you will get a Payment Code to Your Whatsapp or SMS.</h6>
                <h6>4. After Payment Code Received, then only you will be able to login from Login Page.</h6>
                <h4 style="color:orange;text-decoration: underline;"><b>How we Earn from This App?</b></h4>
                <h6>1. You Need to share this link to your friends with your Referral Code(Your Referral Code will be available in your profile section). And tell them to do the above Process.</h6>
                <h6>2. Try to convince your friends to Choose Higher Payment Plan. So, you will get more Money.</h6>
                <h6>3. You can change your payment plan from your profile section.</h6>
                <h6>4. If your Payment Plan is less then 500, than you will not get any bonus of your Payment Plan.</h6>
                <h6>5. If your Payment Plan is 500 or more, than you will receive 50% bonus of your Payment Plan.</h6>
                <h6>6. You will get 30% of Your Immediate Referral Friends Payment Plan.<h6>
                <h6>7. When your referral Friend refer to his friend then you will get 5% of your referrals referral Payment Plan.</h6>
                <h6>8. For point No. 4, 5, 6, & 7 there are some regulation, if your Payment plan is less than your friends or friends referral Payment Plan, then you will receive bonus according to your selected Payment Plan.<h6>
                <div class="verticalLine"></div>
                <h4 style="text-align:center;color:yellow;">Still you have any doubts Contact on +91 9797317200</h4>
          </div>
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

