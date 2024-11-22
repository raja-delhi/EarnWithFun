<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body>
        <div id="errorMessage" style="color: yellow; text-align:center" class="hide"></div>
    <c:if test="${not empty successMessage}">
        <div style="color: green; text-align:center">
            <strong><c:out value="${successMessage}"/></strong>
        </div>
    </c:if>
    <div class="container">
        <form id="loginForm" modalAttribute="user">
            <h2 class="mb-3">Login</h2>
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-control" autocomplete="off" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-control" autocomplete="off" required>
                </div>
                <div class="mb-3">
                    <label for="paymentCode" class="form-label">Payment Code</label>
                    <input type="text" id="paymentCode" name="paymentCode" class="form-control" autocomplete="off" required>
                </div>
            <button id="logIn" class="btn btn-primary" type="submit">Sign in</button>
        </form>
        <div class="form-row">
                        <div id="logon" class="form-group col-md-6">
                            Do not have an account? <button onclick="openPage('Signup', this, 'gray');" class="btn btn-primary">Create Account</button>
                        </div>
                        <div id="forgotPassword" class="form-group col-md-6">
                            Forgot password? <button onclick="openPage('Forgot', this, 'gray');" class="btn btn-primary">Forgot Password</button>
                        </div>
        </div>
    </div>

</body>
</html>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
$(document).ready(function () {
        $("#logIn").click(function (event) {
            $("#errorMessage").hide();
            event.preventDefault();
            let form = $("#loginForm");
            let url = "login";
            $.ajax({
                type: "POST",
                url: url,
                data: form.serialize(),
                contentType: "application/x-www-form-urlencoded",
                dataType: "json",
                success: function (data) {
                    if(data.errorMessage != null){
                        $("#errorMessage").show();
                        $("#errorMessage").html('');
                        $("#errorMessage").html(data.errorMessage);
                    }else{
                        loadDashboardScreen(data.userId);
                    }
                },
                error: function (data) {
                    alert("Error occurred while submitting the form");
                }
            });
        });
    });

    function openPage(pageName, element, color) {
          var i, tabContent, tabLinks;
          tabContent = document.getElementsByClassName("tabContent");
          for (i = 0; i < tabContent.length; i++) {
            tabContent[i].style.display = "none";
          }
          tabLinks = document.getElementsByClassName("tabLink");
          for (i = 0; i < tabLinks.length; i++) {
            tabLinks[i].style.backgroundColor = "";
          }
          document.getElementById(pageName).style.display = "block";
          document.getElementById(pageName).style.backgroundColor = color;
          element.style.backgroundColor = 'blue';
    }

    function loadDashboardScreen(userId){
        $.ajax({
                url: '../main/dashboard',
                type: 'GET',
                data:{"userId":userId},
                success: function(response) {
                    $('body').html(response);
                },
                error: function(xhr, status, error) {
                    console.log("Error: " + error);
                }
            });
    }
</script>
