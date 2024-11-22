<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body>
        <div id="errorMessageForgot" style="color: yellow; text-align:center" class="hide"></div>
    <c:if test="${not empty successMessage}">
        <div style="color: green; text-align:center">
            <strong><c:out value="${successMessage}"/></strong>
        </div>
    </c:if>
    <div class="container">
        <form id="forgotPasswordForm" modalAttribute="user">
            <h2 class="mb-3">Login</h2>
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-control" autocomplete="off" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">New Password</label>
                    <input type="password" id="password" name="password" class="form-control" autocomplete="off" required>
                </div>
            <button id="forgotBtn" class="btn btn-primary" type="submit">Change Password</button>
        </form>
    </div>

</body>
</html>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
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
                    }
                },
                error: function (data) {
                    alert("Error occurred while submitting the form");
                }
            });
        });
    });
</script>
