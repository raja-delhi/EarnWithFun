package com.earnwithfun.service;

import com.earnwithfun.dao.UserDaoImpl;
import com.earnwithfun.entity.PaymentDetail;
import com.earnwithfun.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Objects;
import java.util.Random;

@Service
public class UserServiceImpl{

    @Autowired
    private UserDaoImpl userDao;
    public User getUserByUserNameAndPassword(String username, String password) {
        return userDao.getUserByUserNameAndPassword(username, password);
    }

    public User getUserByPaymentCode(String paymentCode) {
        return userDao.getUserByPaymentCode(paymentCode);
    }

    public User getUserByUserName(String username) {
        return userDao.getUserByUserName(username);
    }

    public void createUser(User user) {
        Object count = getUserCount();
        user.setPaymentCode("P" + getCode() + count);
        user.setReferralCode("R" + getCode() + count);
        userDao.createUser(user);
    }

    private Object getUserCount() {
        return userDao.getUsersCount();
    }

    private String getCode() {
        String codeString = "ABCDEFGHIJKLtuvwxyz12345MNOPQRSTUVWXYZabcdefghijklmnopqrs67890";
        StringBuilder code = new StringBuilder();
        Random rnd = new Random();
        while (code.length() < 4) {
            int index = (int) (rnd.nextFloat() * codeString.length());
            code.append(codeString.charAt(index));
        }
        return code.toString();

    }

    public void updateUser(User user) {
        userDao.updateUser(user);
    }

    public User getAdminUser(User user) {
        return userDao.getAdminUser(user);
    }

    public List<PaymentDetail> getPaymentDetails(User user) {
        return userDao.gePaymentDetails(user);
    }

    public List<User> getUserRequestedForWithdraw() {
        return userDao.getUserRequestedForWithdraw();
    }

    public List<User> getReferredUsers() {
        return userDao.getReferredUsers();
    }

    public User getUserByReferralCode(String referralCode) {
        return userDao.getUserByReferralCode(referralCode);
    }

    public void createPayment(String referredByUser, String fullName, String amount) {
        PaymentDetail paymentDetail = new PaymentDetail();
        paymentDetail.setReferralFullName(fullName);
        paymentDetail.setUsername(referredByUser);
        paymentDetail.setAmount(amount);
        userDao.createPayment(paymentDetail);
    }

    public User getUserById(Long userId) {
        return userDao.getUserById(userId);
    }

    public List<User> getPaymentPlanChangeUsers() {
        return userDao.getPaymentPlanChangeUsers();
    }

    public User getAdminUserByFlag() {
        return userDao.getAdminUserByFlag();
    }

    public void updatePayments(User mainUser, String bonusMsg) {
        User parentUser = this.getUserByUserName(mainUser.getReferredByUser());
        User adminUser = this.getAdminUserByFlag();

        BigDecimal mainUserAmount =  BigDecimal.ZERO;
        BigDecimal parentUserAmount;
        BigDecimal parentsParentUserAmount = BigDecimal.ZERO;
        BigDecimal baseAmount = (mainUser.getPaymentPlan().divide(new BigDecimal(100), 2, RoundingMode.HALF_UP));
        if(0 <= mainUser.getPaymentPlan().compareTo(new BigDecimal(500))){
            mainUserAmount = baseAmount .multiply(new BigDecimal(50));
            if(parentUser.getReferredByUser() != null && !Objects.equals(parentUser.getReferredByUser(), "")){
                parentsParentUserAmount = prepareAndUpdateParentsParentUserAmount(mainUser, parentUser, baseAmount);
            }
            parentUserAmount = prepareParentUserAmount(mainUser, parentUser, baseAmount);
            this.createPayment(mainUser.getUsername(), bonusMsg, "+" + mainUserAmount);
            mainUser.setAmount(mainUser.getAmount() != null ? mainUser.getAmount().add(mainUserAmount) : mainUserAmount);
        }else{
            if(parentUser.getReferredByUser() != null && !Objects.equals(parentUser.getReferredByUser(), "")) {
                parentsParentUserAmount = prepareAndUpdateParentsParentUserAmount(mainUser, parentUser, baseAmount);
            }
            parentUserAmount = prepareParentUserAmount(mainUser, parentUser, baseAmount);
        }
        updateAndCreatePaymentForUsers(mainUser, mainUser.getPaymentPlan(), parentUser, parentUserAmount, mainUserAmount, parentsParentUserAmount, adminUser);
    }

    private void updateAndCreatePaymentForUsers(User mainUser, BigDecimal paymentPlanAmount, User parentUser, BigDecimal parentUserAmount, BigDecimal mainUserAmount, BigDecimal parentsParentUserAmount, User adminUser) {
        parentUser.setAmount(parentUser.getAmount() != null ? parentUser.getAmount().add(parentUserAmount) : parentUserAmount);
        BigDecimal adminUserAmount = paymentPlanAmount.subtract(mainUserAmount.add(parentUserAmount).add(parentsParentUserAmount));
        adminUser.setAmount(adminUser.getAmount() != null ? adminUser.getAmount().add(adminUserAmount) : adminUserAmount);

        this.createPayment(parentUser.getUsername(), "Refer Bonus from : " + mainUser.getFullName(), "+" + parentUserAmount);
        this.createPayment(adminUser.getUsername(), "Bonus from : " + mainUser.getFullName(), "+" + adminUserAmount);

        if(parentUser.getReferredByUser() != null && !Objects.equals(parentUser.getReferredByUser(), "")) {
            User parentsParentUser = this.getUserByUserName(parentUser.getReferredByUser());
            parentsParentUser.setAmount(parentsParentUser.getAmount() != null ? parentsParentUser.getAmount().add(parentsParentUserAmount) : parentsParentUserAmount);
            this.updateUser(parentsParentUser);
        }
        this.updateUser(mainUser);

        adminUser.setAmount(adminUser.getAmount() != null ? adminUser.getAmount().add(adminUserAmount) : adminUserAmount);
        this.updateUser(adminUser);

        parentUser.setAmount(parentUser.getAmount() != null ? parentUser.getAmount().add(parentUserAmount) : parentUserAmount);
        this.updateUser(parentUser);
    }

    private static BigDecimal prepareParentUserAmount(User mainUser, User parentUser, BigDecimal baseAmount) {
        BigDecimal parentUserAmount;
        if (0 <= parentUser.getPaymentPlan().compareTo(mainUser.getPaymentPlan())) {
            parentUserAmount = baseAmount.multiply(new BigDecimal(30));
        } else {
            parentUserAmount = (parentUser.getPaymentPlan().divide(new BigDecimal(100), 2, RoundingMode.HALF_UP)).multiply(new BigDecimal(30));
        }
        return parentUserAmount;
    }

    private BigDecimal prepareAndUpdateParentsParentUserAmount(User mainUser, User parentUser, BigDecimal baseAmount) {
        BigDecimal parentsParentUserAmount;
        User parentsParentUser = this.getUserByUserName(parentUser.getReferredByUser());
        if(0 <= parentsParentUser.getPaymentPlan().compareTo(mainUser.getPaymentPlan())){
            parentsParentUserAmount = baseAmount.multiply(new BigDecimal(5));
        }else{
            parentsParentUserAmount = (parentsParentUser.getPaymentPlan().divide(new BigDecimal(100), 2, RoundingMode.HALF_UP)).multiply(new BigDecimal(5));
        }
        this.createPayment(parentsParentUser.getUsername(), "Your Referral's Referral bonus", "+" + parentsParentUserAmount);
        return parentsParentUserAmount;
    }
}
