package com.earnwithfun.dao;

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

}
