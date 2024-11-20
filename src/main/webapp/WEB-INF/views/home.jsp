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
                <button class="tabLink" onclick="openPage('Home', this, 'gray')" id="newsBtn">Home</button>
                <button class="tabLink" onclick="openPage('Contact', this, 'gray')">Support</button>
                <button class="tabLink" onclick="openPage('Login', this, 'gray')" id="loginBtn">Login</button>
                <button class="tabLink" onclick="openPage('Signup', this, 'gray')" id="signUpBtn">Sign Up</button>
                <button class="tabLink" onclick="openPage('AdminLogin', this, 'gray')" id="adminLoginBtn">Admin</button>
            </div>
    </div>

    <div id="tabContentDiv">
        <div id="Home" class="tabContent">
          <h2>Home</h2>
          <p>Home is where the heart is..</p>
        </div>

        <div id="AdminLogin" class="tabContent">
              <c:if test="${not empty errorMessage}">
                  <div style="color: red; text-align:center">
                      <strong><c:out value="${errorMessage}"/></strong>
                  </div>
              </c:if>
              <div class="container">
                  <form class="form-login" method="post" action="adminLogin" modalAttribute="user">
                      <h2 class="mb-3" style="text-align:center">Admin Login</h2>
                          <div class="mb-3">
                              <label for="username" class="form-label">Username</label>
                              <input type="text" id="username" name="username" class="form-control" autocomplete="off" required>
                          </div>
                          <div class="mb-3">
                              <label for="password" class="form-label">Password</label>
                              <input type="password" id="password" name="password" class="form-control" autocomplete="off" required>
                          </div>
                      <button class="btn btn-primary" type="submit">Sign in</button>
                  </form>
              </div>
        </div>

        <div id="Contact" class="tabContent">
          <h2>Support</h2>
          <p>Get in touch, or swing by for a cup of coffee.</p>
        </div>

        <div id="About" class="tabContent">
          <h2>About</h2>
          <p>Who we are and what we do.</p>
        </div>

        <div id="Login" class="tabContent">
            <%@include file="login.jsp" %>
        </div>

        <div id="Signup" class="tabContent">
            <%@include file="signUp.jsp" %>
        </div>
    </div>
</body>
</html>
<script type="text/javascript">
    var activeTab = <c:out value="${activeTab}"/>;
    $(document).ready(function () {
        $("#logIn").click(function (event) {
            event.preventDefault();
            let form = $("#loginForm");
            let url = "login";

            $.ajax({
                type: "POST",
                url: url,
                data: form.serialize(),
                success: function (data) {
                    alert("Form Submitted Successfully");
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

