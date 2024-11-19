<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0"><style>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
 <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
     body {
        background-color: gray;
        margin: 0;
    }
    h3{
        color:white;
        text-align:center;
        margin:10px;
    }
    .header{
      margin:10px;
      padding:10px;
    }
    #tabs{
        text-align: right;
    }
    .tabLink {
      background-color: #555;
      color: white;
      float: left;
      border: none;
      outline: none;
      cursor: pointer;
      padding: 10px 10px;
      font-size: 17px;
      width: 20%;
    }

    .tabLink:hover {
      background-color: #777;
    }

    .tabContent {
      color: white;
      display: none;
      padding: 10px 10px;
      margin:10px;
      overflow: hidden;
    }

    .topnav {
      overflow: hidden;
      background-color: #333;
      position: relative;
    }

    .topnav span {
      color: white;
      padding: 10px 10px;
      text-decoration: none;
      font-size: 17px;
      display: block;
    }

    .active {
      background-color: #04AA6D;
      color: white;
    }
</style>
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
    document.getElementById(activeTab.id).click();

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
</script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>