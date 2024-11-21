<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
        <div id="errorMessage" style="color: yellow; text-align:center" class="hide">

        </div>
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
        <div id="logon">
              Don not have an account? <button onclick="openPage('Signup', this, 'gray');" class="btn btn-primary">Sign Up</button>
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
                debugger;
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
