<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>adminDashboard</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <link href="<c:url value="/resources/css/common.css" />" rel="stylesheet">
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
                           <button class="tabLink" onclick="logOut();">Logout</button>
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
     <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
     <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<script type="text/javascript">
    var activeTab = <c:out value="${activeTab}"/>;
    function logOut(){
            $.ajax({
                url: '../main/',
                type: 'GET',
                success: function(response) {
                    $('body').html(response);
                },
                error: function(xhr, status, error) {
                    console.log("Error: " + error);
                }
            });
        }
</script>
<script src="<c:url value="/resources/js/common.js" />"></script>
