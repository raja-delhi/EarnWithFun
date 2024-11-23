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
}
