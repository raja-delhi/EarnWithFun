<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body>
    <div id="errorMessage7" style="color: yellow; text-align:center" class="hide"></div>
    <div class="container">
        <form id="signUpForm" modalAttribute="user">
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
                    <label for="referralCode" class="form-label">Referral Code</label>
                    <input type="text" id="referralCode" name="referralCode" class="form-control" autocomplete="off" required>
                </div>
            </div>
                    <button id="signUp" class="btn btn-primary" type="submit">Sign Up</button>
        </form>

    </div>
</body>
</html>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<script>
    $(document).ready(function () {
            $("#signUp").click(function (event) {
                $("#errorMessage7").hide();
                    event.preventDefault();
                    let form = $("#signUpForm");
                    let url = "signUp";
                    $.ajax({
                        type: "POST",
                        url: url,
                        data: form.serialize(),
                        contentType: "application/x-www-form-urlencoded",
                        dataType: "json",
                        success: function (data) {
                            if(data.errorMessage != null){
                                $("#errorMessage7").show();
                                $("#errorMessage7").html('');
                                $("#errorMessage7").html(data.errorMessage);
                            }else{
                                $("#errorMessage7").show();
                                $("#errorMessage7").html('');
                                $("#errorMessage7").html(data.successMessage);
                                clearAllFields();
                            }
                        },
                        error: function (data) {
                            alert("Error occurred while submitting the form");
                        }
                    });
            });
        });

        function clearAllFields(){
           $("#username").val('');
           $("#email").val('');
           $("#fullName").val('');
           $("#phoneNumber").val('');
           $("#password").val('');
           $("#referralCode").val('');
        }
</script>
