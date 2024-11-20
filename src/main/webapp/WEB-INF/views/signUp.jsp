<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body>
    <c:if test="${not empty errorMessage}">
        <div style="color: yellow; text-align:center">
            <strong><c:out value="${errorMessage}"/></strong>
        </div>
    </c:if>
    <div class="container">
        <form class="form-login" method="post" action="signUp" modalAttribute="user">
            <h2 class="mb-3">Register</h2>
            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-control" autocomplete="off" autocomplete="off" required>
                </div>
                <div class="form-group col-md-6">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-control" autocomplete="off" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="fullName" class="form-label">Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" autocomplete="off" required>
                </div>
                <div class="form-group col-md-6">
                    <label for="phoneNumber" class="form-label">Phone Number
                    </label>
                    <input type="number" id="phoneNumber" name="phoneNumber" class="form-control" autocomplete="off" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-control" autocomplete="off" required>
                </div>
                <div class="form-group col-md-6">
                    <label for="rePassword" class="form-label">Confirm Password</label>
                    <input type="password" id="rePassword" name="rePassword" class="form-control" autocomplete="off" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="referralCode" class="form-label">Referral Code</label>
                    <input type="text" id="referralCode" name="referralCode" class="form-control" autocomplete="off" required>
                </div>
            </div>

            <button class="btn btn-primary" onclick="saveForm();" type="submit">Sign Up</button>
        </form>

        <div id="signin">
              Already have an account? <button onclick="openPage('Login', this, 'gray');" class="btn btn-primary">Sign In</button>
        </div>

    </div>
</body>
</html>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<script>
    function saveForm(){
        var pass1 = $("password").val();
        var pass2 = $("rePassword").val();
        if(pass1 != pass2){
            alert("Password not same.");
        }
    }
</script>
