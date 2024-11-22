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

        <div id="Contact" class="tabContent">
          <h2>Support</h2>
          <p>Get in touch, or swing by for a cup of coffee.</p>
        </div>

        <div id="About" class="tabContent">
          <h2>About</h2>
          <p>Who we are and what we do.</p>
        </div>

        <div id="Login" class="tabContent">
        </div>

        <div id="Signup" class="tabContent">
        </div>

        <div id="Forgot" class="tabContent">
            <h2>Forgot Password</h2>
        </div>
    </div>
</body>
</html>
<script type="text/javascript">
    var activeTab = <c:out value="${activeTab}"/>;
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value="/resources/js/common.js" />"></script>

