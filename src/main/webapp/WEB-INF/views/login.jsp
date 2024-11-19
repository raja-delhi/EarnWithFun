<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <c:if test="${not empty errorMessage}">
        <div style="color: yellow; text-align:center">
            <strong><c:out value="${errorMessage}"/></strong>
        </div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div style="color: green; text-align:center">
            <strong><c:out value="${successMessage}"/></strong>
        </div>
    </c:if>
    <div class="container">
        <form class="form-login" method="post" action="login" modalAttribute="user">
            <h2 class="mb-3">Login</h2>
            <c:choose>
            <c:when test="${not empty loginUser}">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" value="${loginUser.username}" class="form-control" autocomplete="off" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" value="${loginUser.password}" class="form-control" autocomplete="off" required>
                </div>
                <div class="mb-3">
                    <label for="paymentCode" class="form-label">Payment Code</label>
                    <input type="text" id="paymentCode" name="paymentCode" value="${loginUser.paymentCode}" class="form-control" autocomplete="off" required>
                </div>
            </c:when>
            <c:otherwise>
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-control" autocomplete="off" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-control" autocomplete="off" required>
                </div>
                <div class="mb-3">
                    <label for="paymentCode" class="form-label">Payment Code</label>
                    <input type="text" id="paymentCode" name="paymentCode" class="form-control" autocomplete="off" required>
                </div>
            </c:otherwise>
            </c:choose>
            <button class="btn btn-primary" type="submit">Sign in</button>
        </form>
        <div id="signUp">
              Don not have an account? <button onclick="openPage('signUp', this, 'gray');" class="btn btn-primary">Sign Up</button>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
