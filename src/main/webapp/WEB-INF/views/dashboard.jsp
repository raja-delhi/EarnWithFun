<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        #updatePaymentPlanFormDiv{
           display:none;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>Dashboard</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="<c:url value="/resources/css/common.css" />" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>


</head>
<body>
    <div id="body" class="header">
        <div class="row">
               <div id="tabs">
                   <div id="welcome">
                       <h1 class="tabLink" style="width: 20%;">Welcome, <c:out value="${user.fullName}"/>!</h1>
                   <div>
                   <div class="buttons">
                       <button class="tabLink" style="width: 20%;" onclick="openPage('CheckBalance', this, 'gray');resetErrorDashboard();" id="checkBalanceBtn">Check Balance</button>
                       <button class="tabLink" style="width: 20%;" onclick="openPage('WithDraw', this, 'gray');" id="withdrawBtn">Withdraw</button>
                       <button class="tabLink" style="width: 20%;" onclick="openPage('Profile', this, 'gray');" id="profileBtn">Profile</button>
                       <button class="tabLink" style="width: 20%;" onclick="logOut();">Logout</button>
                   </div>
               </div>
        </div>
    </div>
    <div class="vertical-line"></div>
    <div id="tabContentDiv">
                <div id="WithDraw" class="tabContent">
                   <c:if test="${not empty successMessage}">
                       <div id="errorMessageDashboard" style="color: yellow; text-align:center">
                           <c:out value="${successMessage}"/>
                       </div>
                   </c:if>
                   <c:if test="${not empty errorMessage}">
                       <div id="errorMessageDashboard" style="color: yellow; text-align:center" class="show">
                           <c:out value="${errorMessage}"/>
                       </div>
                   </c:if>
                     <div class="container">
                             <form class="form-login" method="post" action="withdraw?username=<c:out value="${user.username}"/>" modalAttribute="user">
                                 <h2 class="mb-3" style="text-align:center;text-decoration: underline;">Withdraw Amount</h2>
                                    <div class="mb-3">
                                        <label for="amount" class="form-label">Enter Amount.</label>
                                        <input type="number" id="amount" name="amount" class="form-control" autocomplete="off" required>
                                    </div>
                                     <div class="mb-3">
                                         <label for="accountNo" class="form-label">Account No.</label>
                                         <input type="text" id="accountNo" name="accountNo" class="form-control" autocomplete="off" required>
                                     </div>
                                     <div class="mb-3">
                                         <label for="ifscCode" class="form-label">IFSC Code</label>
                                         <input type="text" id="ifscCode" name="ifscCode" class="form-control" autocomplete="off" required>
                                     </div>
                                     <div class="mb-3">
                                         <label for="upiId" class="form-label">Phone Number</label>
                                         <input type="number" id="upiId" name="upiId" class="form-control" autocomplete="off" required>
                                     </div>
                                 <button class="btn btn-primary" type="submit">Withdraw</button>
                             </form>
                       </div>
                </div>

                <div id="CheckBalance" class="tabContent">
                    <h2 class="mb-3" style="text-align:center;text-decoration: underline;">Balance Amount</h2>
                    <div class="mb-3" style="colour:green">
                        <h4>Total Amount : <c:out value="${user.amount}"/></h4>
                    </div>
                    <div class="verticalLine"></div>
                    <div class="mb-3">
                        <h5 style="text-align:center">Amount History</h5>
                        <table class="table table-dark table-hover table-bordered border-primary">
                          <thead>
                            <tr>
                              <th scope="col">#</th>
                              <th scope="col">Action</th>
                              <th scope="col">Amount</th>
                            </tr>
                          </thead>
                          <tbody>
                              <c:choose>
                                  <c:when test="${empty paymentDetails}">
                                   <tr>
                                       <td colspan='100%' class="txt-c_imp">
                                           <h4 style="text-align:center">Payment Detail not found.</h4>
                                       </td>
                                   </tr>
                                  </c:when>
                                  <c:otherwise>
                                    <c:forEach var="payment" items="${paymentDetails}" varStatus="i">
                                        <tr>
                                          <th scope="row"><c:out value="${i.index+1}"/></th>
                                          <td><c:out value="${payment.referralFullName}"/></td>
                                          <td><c:out value="${payment.amount}"/></td>
                                        </tr>
                                    </c:forEach>
                                  </c:otherwise>
                              </c:choose>
                          </tbody>
                        </table>

                    </div>
                </div>

                <div id="Profile" class="tabContent">
                    <h2 class="mb-3" style="text-align:center;text-decoration: underline;">Profile</h2>
                    <h4>Username : <c:out value="${user.username}"/></h4>
                    <h4>Name : <c:out value="${user.fullName}"/> </h4>
                    <h4>Email : <c:out value="${user.email}"/></h4>
                    <h4>Phone Number : <c:out value="${user.phoneNumber}"/></h4>
                    <h4>Your Payment Plan : <c:out value="${user.paymentPlan}"/></h4>
                    <label for="changePaymentPlan">
                        <h4>You want to change Payment Plan? <input type="checkbox" id="changePaymentPlan"></h4>
                    </label>
                    <div id="updatePaymentPlanFormDiv" class="hide">
                        <form id="updatePaymentPlanRequest" action="updatePaymentPlanRequest" method = "post" modalAttribute="user">
                          <input type="hidden" id="username" name="id" value="<c:out value="${user.id}"/>" class="form-control" autocomplete="off">
                          <div class="form-row">
                              <div class="form-group col-md-2">
                                  <select id="paymentPlan" class="form-select form-select-sm" name="paymentPlan" aria-label=".form-select-sm example">
                                    <option value="50" selected>50</option>
                                    <option value="100">100</option>
                                    <option value="500">500</option>
                                    <option value="1000">1000</option>
                                  </select>
                              </div>
                              <div class="form-group col-md-6">
                                <button onclick="updatePaymentPlan(<c:out value="${user.id}"/>);">Update Payment Plan</button>
                              </div>
                          </div>
                        </form>
                    </div>
                    <div class="verticalLine"></div>
                    <h3 style="text-align:center; background-color:blue">Referral Code : <c:out value="${user.referralCode}"/></h3>
                </div>
            </div>
</body>
</html>
     <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
     <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<script type="text/javascript">
    var activeTab = <c:out value="${activeTab}"/>;

    document.getElementById('changePaymentPlan').addEventListener('change', function() {
            var div = document.getElementById('updatePaymentPlanFormDiv');

            if (this.checked) {
                div.style.display = 'block';
            } else {
                div.style.display = 'none';
            }
        });

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
    function resetErrorDashboard(){
        $("#errorMessageDashboard").html('');
        $("#errorMessageDashboard").hide();
    }
</script>
<script src="<c:url value="/resources/js/common.js" />"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

