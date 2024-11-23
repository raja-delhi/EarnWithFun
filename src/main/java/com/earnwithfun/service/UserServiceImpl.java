package com.earnwithfun.service;

import com.earnwithfun.dao.UserDaoImpl;
import com.earnwithfun.entity.PaymentDetail;
import com.earnwithfun.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
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

    public void updatePayments(User mainUser, long paymentPlanAmount) {
        User parentUser = this.getUserByUserName(mainUser.getReferredByUser());
        User adminUser = this.getAdminUserByFlag();

        long mainUserAmount =  0;
        long parentUserAmount = 0;
        long adminUserAmount =  0;
        long baseAmount = paymentPlanAmount / 100;
        if(mainUser.getPaymentPlan()>=500){
            mainUserAmount = baseAmount * 50;
            if(parentUser.getPaymentPlan()>=mainUser.getPaymentPlan()) {
                parentUserAmount = baseAmount * 25;
            }else{
                parentUserAmount = (parentUser.getPaymentPlan() / 100) * 25;
            }
            this.createPayment(mainUser.getUsername(), "Your Login bonus", "+" + mainUserAmount);
            mainUser.setAmount(mainUser.getAmount() != null ? mainUser.getAmount() + mainUserAmount : mainUserAmount);
        }else{
            if(parentUser.getPaymentPlan()>=mainUser.getPaymentPlan()) {
                parentUserAmount = baseAmount * 40;
            }else{
                parentUserAmount = (parentUser.getPaymentPlan() / 100) * 40;
            }
        }
        adminUserAmount = paymentPlanAmount - (mainUserAmount + parentUserAmount);
        this.updateUser(mainUser);

        this.createPayment(parentUser.getUsername(), "Refer To : " + mainUser.getFullName(), "+" + parentUserAmount);
        parentUser.setAmount(parentUser.getAmount() != null ? parentUser.getAmount() + parentUserAmount : parentUserAmount);
        this.updateUser(parentUser);

        adminUser.setAmount(adminUser.getAmount() != null ? adminUser.getAmount() + adminUserAmount : adminUserAmount);
        this.createPayment(adminUser.getUsername(), "Bonus from To : " + mainUser.getFullName(), "+" + adminUserAmount);
        this.updateUser(adminUser);
    }
}
