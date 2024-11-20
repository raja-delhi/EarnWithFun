package com.earnwithfun.dao;

import com.earnwithfun.entity.PaymentDetail;
import com.earnwithfun.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.HibernateTemplate;
import org.springframework.stereotype.Component;

import javax.transaction.Transactional;
import java.util.List;

@Component
public class UserDaoImpl{

    @Autowired
    private HibernateTemplate hibernateTemplate;

    @Transactional
    public void createUser(User user) {
        this.hibernateTemplate.save(user);
    }

    public User getUserByUserNameAndPassword(User user) {
        String query = "select u from User u where u.username = ?0 and u.password = ?1";
        Object[] queryParam = {user.getUsername(), user.getPassword()};
        List<User> users = (List<User>) this.hibernateTemplate.find(query, queryParam);
        return users.isEmpty() ? null : users.get(0);
    }

    public User getUserByPaymentCode(User user) {
        String query = "select u from User u where u.paymentCode = ?0 and u.username = ?1 and u.password = ?2";
        Object[] queryParam = {user.getPaymentCode(), user.getUsername(), user.getPassword()};
        List<User> users = (List<User>) this.hibernateTemplate.find(query, queryParam);
        return users.isEmpty() ? null : users.get(0);
    }

    public User getUserByUserName(String username) {
        String query = "select u from User u where u.username = ?0";
        Object[] queryParam = {username};
        List<User> users = (List<User>) this.hibernateTemplate.find(query, queryParam);
        return users.isEmpty() ? null : users.get(0);
    }

    @Transactional
    public void updateUser(User user) {
        this.hibernateTemplate.update(user);
    }

    public User getAdminUser(User user) {
        String query = "select u from User u where u.username = ?0 and u.password = ?1 and isAdminUser= ?2";
        Object[] queryParam = {user.getUsername(), user.getPassword(), 'Y'};
        List<User> users = (List<User>) this.hibernateTemplate.find(query, queryParam);
        return users.isEmpty() ? null : users.get(0);
    }

    public List<PaymentDetail> gePaymentDetails(User user) {
        String query = "select p from PaymentDetail p where p.username = ?0";
        Object[] queryParam = {user.getUsername()};
        return (List<PaymentDetail>) this.hibernateTemplate.find(query, queryParam);
    }

    public List<User> getUserRequestedForWithdraw() {
        String query = "select u from User u where u.withdrawRequest = ?0";
        Object[] queryParam = {'Y'};
        return (List<User>) this.hibernateTemplate.find(query, queryParam);
    }

    public List<User> getReferredUsers() {
        String query = "select u from User u where u.referralRequest = ?0";
        Object[] queryParam = {'Y'};
        return (List<User>) this.hibernateTemplate.find(query, queryParam);
    }

    public User getUserByReferralCode(String referralCode) {
        String query = "select u from User u where u.referralCode = ?0";
        Object[] queryParam = {referralCode};
        List<User> users = (List<User>) this.hibernateTemplate.find(query, queryParam);
        return users.isEmpty() ? null : users.get(0);
    }

    @Transactional
    public void createPayment(PaymentDetail paymentDetail) {
        this.hibernateTemplate.save(paymentDetail);
    }
}
