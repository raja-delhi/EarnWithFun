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
      margin:5px;
      padding:5px;
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
      width: 16.66%;
    }

    .tabLink:hover {
      background-color: #777;
    }

    /* Style the tab content (and add height:100% for full page content) */
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

    /* Style navigation menu links */
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
                    <button class="tabLink" onclick="openPage('Home', this, 'gray')">Home</button>
                    <button class="tabLink" onclick="openPage('News', this, 'gray')" id="newsBtn">News</button>
                    <button class="tabLink" onclick="openPage('Contact', this, 'gray')">Contact</button>
                    <button class="tabLink" onclick="openPage('About', this, 'gray')">About</button>
                    <button class="tabLink" onclick="openPage('Login', this, 'gray')" id="loginBtn">Login</button>
                    <button class="tabLink" onclick="openPage('signUp', this, 'red')" id="signUpBtn">Sign Up</button>
                </div>
        </div>

        <div id="tabContentDiv">
            <div id="Home" class="tabContent">
              <h2>Home</h2>
              <p>Home is where the heart is..</p>
            </div>

            <div id="News" class="tabContent">
              <h2>News</h2>
              <p>Some news this fine day!</p>
            </div>

            <div id="Contact" class="tabContent">
              <h2>Contact</h2>
              <p>Get in touch, or swing by for a cup of coffee.</p>
            </div>

            <div id="About" class="tabContent">
              <h2>About</h2>
              <p>Who we are and what we do.</p>
            </div>

            <div id="Login" class="tabContent">
                <%@include file="login.jsp" %>
            </div>

            <div id="signUp" class="tabContent">
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