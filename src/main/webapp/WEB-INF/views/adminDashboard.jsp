<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    #body {
            background-color: black;
            width:100%;
        }
        #tabs{
            text-align: right;
            width:100%;
        }
                .tabLink {
                  background-color: #555;
                  color: white;
                  float: left;
                  border: none;
                  outline: none;
                  cursor: pointer;
                  padding: 10px;
                  font-size: 10px;
                  width: 20%;
                }
        h1{
            color:white;
            text-align:center;
            margin:20px;
        }
        .buttons{
            text-align:right;
            margin-top:20px;
        }

            .tabContent {
              color: white;
              display: none;
              padding: 20px;
              margin:30px;
              overflow: hidden;
            }
            .vertical-line {
                    width: 0;
                    border: 2px solid green;
                    width : 90%;
                    margin:20px;
                }
            .verticalLine{
                width: 0;
                border: 2px solid yellow;
                width : 90%;
                margin:20px;
            }
    .container{
        text:center;
    }
</style>
    <title>Target Page</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body>
        <div id="body">
            <div class="row header">
                   <div id="tabs">
                       <div id="welcome">
                           <h1 class="tabLink">Welcome, <c:out value="${user.fullName}"/>!</h1>
                       <div>
                       <div class="buttons">
                           <button class="tabLink" onclick="openPage('ReferralApprove', this, 'gray')" id="referralApproveBtn" >Referral Approve</button>
                           <button class="tabLink" onclick="openPage('WithdrawApprove', this, 'gray')" id="withdrawApproveBtn" >Withdraw Approve</button>
                       </div>
                   </div>
            </div>
        </div>
        <div class="vertical-line"></div>
        <div id="ReferralApprove" class="tabContent">
            <h2 class="mb-3" style="text-align:center">Referral Approve</h2>
        </div>
        <div id="WithdrawApprove" class="tabContent">
            <h2 class="mb-3" style="text-align:center">Withdraw Approve</h2>
        </div>
</body>
</html>
     <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
     <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
     <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<script>
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