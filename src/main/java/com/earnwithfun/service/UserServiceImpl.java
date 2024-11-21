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
        user.setPaymentCode("PC"+getCode());
        user.setReferralCode("RC"+getCode());
        userDao.createUser(user);
    }

    private String getCode() {
        String paymentCodeString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
        StringBuilder paymentCode = new StringBuilder();
        Random rnd = new Random();
        while (paymentCode.length() < 6) {
            int index = (int) (rnd.nextFloat() * paymentCodeString.length());
            paymentCode.append(paymentCodeString.charAt(index));
        }
        return paymentCode.toString();

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

    public void createPayment(String referredByUser, String fullName) {
        PaymentDetail paymentDetail = new PaymentDetail();
        paymentDetail.setAmount(20L);
        paymentDetail.setReferralFullName(fullName);
        paymentDetail.setUsername(referredByUser);
        userDao.createPayment(paymentDetail);
    }

    public User getUserById(Long userId) {
        return userDao.getUserById(userId);
    }
}
