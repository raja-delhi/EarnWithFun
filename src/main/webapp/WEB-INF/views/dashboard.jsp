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
                   <div class="buttons">
                       <button class="tabLink" onclick="openPage('Profile', this, 'gray');resetErrorDashboardWithdraw();resetErrorDashboardCheckBalance();" id="profileBtn">Profile</button>
                       <button class="tabLink" onclick="openPage('CheckBalance', this, 'gray');resetErrorDashboardWithdraw();resetErrorDashboardProfile();" id="checkBalanceBtn">Check Balance</button>
                       <button class="tabLink" onclick="openPage('WithDraw', this, 'gray');resetErrorDashboardProfile();resetErrorDashboardCheckBalance();" id="withdrawBtn">Withdraw</button>
                       <button class="tabLink" onclick="logOut();">Logout</button>
                   </div>
               </div>
        </div>
    </div>
    <div class="vertical-line"></div>
    <div id="tabContentDiv">
                <div id="WithDraw" class="tabContent">
                    <c:if test="${not empty successMessage}">
                           <div id="errorMessageDashboardWithdraw" class="errorMessageDashboard" style="color: yellow; text-align:center">
                               <c:out value="${successMessage}"/>
                           </div>
                       </c:if>
                       <c:if test="${not empty errorMessage}">
                           <div id="errorMessageDashboardWithdraw" class="errorMessageDashboard"  style="color: yellow; text-align:center" class="show">
                               <c:out value="${errorMessage}"/>
                           </div>
                       </c:if>
                       <br>
                     <div class="container">
                             <form class="form-login" method="post" action="withdraw" modalAttribute="user">
                                 <h2 class="mb-3" style="text-align:center;text-decoration: underline;">Withdraw Amount</h2>
                                 <input type="hidden" id="username" name="username" value="<c:out value="${user.username}"/>" class="form-control" autocomplete="off">

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
                                     <input type="tel" id="upiId" name="upiId" class="form-control" autocomplete="off" required>
                                 </div>

                                 <button class="btn btn-primary" type="submit">Withdraw</button>
                             </form>
                       </div>
                </div>

                <div id="CheckBalance" class="tabContent">
                        <c:if test="${not empty successMessage}">
                           <div id="errorMessageDashboardCheckBalance" class="errorMessageDashboard" style="color: yellow; text-align:center">
                               <c:out value="${successMessage}"/>
                           </div>
                       </c:if>
                       <c:if test="${not empty errorMessage}">
                           <div id="errorMessageDashboardCheckBalance" class="errorMessageDashboard"  style="color: yellow; text-align:center" class="show">
                               <c:out value="${errorMessage}"/>
                           </div>
                       </c:if>
                       <br>
                       <div class="mb-3" style="colour:green">
                        <div class="form-row">
                             <div class="form-group col-md-3" style="text-align:left">
                                <h5>Balance : <c:out value="${user.amount}"/></h5>
                             </div>
                             <div class="form-group col-md-3" style="text-align:right">
                                <h5>Referral Count : <c:out value="${user.referralCount}"/></h5>
                             </div>
                             <form id="claimRewardPoints" action="claimRewardPoints" method = "post" modalAttribute="user">
                                  <div class="form-row">
                                    <div class="form-group col-md-3" style="text-align:left">
                                        <h5>Reward Points : <c:out value="${user.rewardsPoint}"/></h5>
                                    </div>
                                    <div class="form-group col-md-3" style="text-align:right">
                                        <input type="hidden" id="username" name="id" value="<c:out value="${user.id}"/>" class="form-control" autocomplete="off">
                                        <button onclick="claimRewardPoints(<c:out value="${user.id}"/>);">Claim Reward Points</button>
                                    </div>
                                  </div>
                             </form>
                        </div>
                    </div>
                    <div class="verticalLine"></div>
                    <div class="mb-3 table-responsive">
                        <h5 style="text-align:center">Payment History</h5>
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
                    <c:if test="${not empty successMessage}">
                           <div id="errorMessageDashboardProfile" class="errorMessageDashboard" style="color: yellow; text-align:center">
                               <c:out value="${successMessage}"/>
                           </div>
                       </c:if>
                       <c:if test="${not empty errorMessage}">
                           <div id="errorMessageDashboardProfile" class="errorMessageDashboard" style="color: yellow; text-align:center" class="show">
                               <c:out value="${errorMessage}"/>
                           </div>
                       </c:if>
                       <br>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <h4>Username : <c:out value="${user.username}"/></h4>
                        </div>
                        <div class="form-group col-md-6">
                            <h4>Name : <c:out value="${user.fullName}"/> </h4>
                        </div>
                        <div class="form-group col-md-6">
                            <h4>Email : <c:out value="${user.email}"/></h4>
                        </div>
                        <div class="form-group col-md-6">
                            <h4>Phone Number : <c:out value="${user.phoneNumber}"/></h4>
                        </div>
                        <div class="form-group col-md-6">
                            <h4>Payment Code : <c:out value="${user.paymentCode}"/></h4>
                        </div>
                        <div class="form-group col-md-6">
                            <h4>Your Payment Plan : <c:out value="${user.paymentPlan}"/></h4>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="changePaymentPlan">
                                <h5 style="color:black">You want to change Payment Plan? <input type="checkbox" id="changePaymentPlan"></h5>
                            </label>
                            <div id="updatePaymentPlanFormDiv" class="hide">
                                <form id="updatePaymentPlanRequest" action="updatePaymentPlanRequest" method = "post" modalAttribute="user">
                                  <input type="hidden" id="username" name="id" value="<c:out value="${user.id}"/>" class="form-control" autocomplete="off">
                                  <div class="form-row">
                                      <div class="form-group col-md-1">
                                          <select id="paymentPlan" class="form-select form-select-sm" name="newPaymentPlan" aria-label=".form-select-sm example">
                                              <option value="50" selected>50</option>
                                              <option value="100">100</option>
                                              <option value="150">150</option>
                                              <option value="200">200</option>
                                              <option value="250">250</option>
                                              <option value="300">300</option>
                                              <option value="500">500</option>
                                              <option value="1000">1000</option>
                                              <option value="2000">2000</option>
                                              <option value="5000">5000</option>
                                          </select>
                                      </div>
                                      <div class="form-group col-md-6">
                                        <button onclick="updatePaymentPlan(<c:out value="${user.id}"/>);">Update Payment Plan</button>
                                      </div>
                                  </div>
                                </form>
                            </div>
                        </div>
                        <div class="form-group col-md-6">
                            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#instructions">
                              Read Instruction
                            </button>
                        </div>
                    </div>
                    <div class="verticalLine"></div>
                    <h3 style="text-align:center; color:orange">Referral Code : <c:out value="${user.referralCode}"/></h3>
                </div>
            </div>
    <div class="modal fade" id="instructions" tabindex="-1" role="dialog" aria-labelledby="Instructions" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLongTitle">Instructions</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <%@include file="instruction.jsp" %>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
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
    function resetErrorDashboardWithdraw(){
        $("#errorMessageDashboardWithdraw").html('');
        $("#errorMessageDashboardWithdraw").hide();
    }
    function resetErrorDashboardProfile(){
        $("#errorMessageDashboardProfile").html('');
        $("#errorMessageDashboardProfile").hide();
    }
    function resetErrorDashboardCheckBalance(){
        $("#errorMessageDashboardCheckBalance").html('');
        $("#errorMessageDashboardCheckBalance").hide();
    }
</script>
<script src="<c:url value="/resources/js/common.js" />"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

