package com.earnwithfun.service;

import com.earnwithfun.dao.UserDaoImpl;
import com.earnwithfun.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
public class UserServiceImpl{

    @Autowired
    private UserDaoImpl userDao;
    public User getUserByUserNameAndPassword(User user) {
        return userDao.getUserByUserNameAndPassword(user);
    }

    public User getUserByPaymentCode(User user) {
        return userDao.getUserByPaymentCode(user);
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
}
