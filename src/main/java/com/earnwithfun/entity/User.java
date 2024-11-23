package com.earnwithfun.entity;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.ArrayList;
import java.util.Collection;

@Entity
public class User implements UserDetails{

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String paymentCode;
    private Long amount = 0L;
    private String referralCode;
    private String accountNo;
    private String ifscCode;
    private String upiId;
    private char withdrawRequest = 'N';
    private char isAdminUser = 'N';
    private char referralRequest = 'N';
    private String referredByUser;
    private Long paymentPlan;
    private char isRejectedByAdmin = 'N';
    private char isPaymentDone = 'N';

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return new ArrayList<>();
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return false;
    }

    @Override
    public boolean isAccountNonLocked() {
        return false;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return false;
    }

    @Override
    public boolean isEnabled() {
        return false;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPaymentCode() {
        return paymentCode;
    }

    public void setPaymentCode(String paymentCode) {
        this.paymentCode = paymentCode;
    }

    public Long getAmount() {
        return amount;
    }

    public void setAmount(Long amount) {
        this.amount = amount;
    }

    public String getReferralCode() {
        return referralCode;
    }

    public void setReferralCode(String referralCode) {
        this.referralCode = referralCode;
    }

    public String getAccountNo() {
        return accountNo;
    }

    public void setAccountNo(String accountNo) {
        this.accountNo = accountNo;
    }

    public String getIfscCode() {
        return ifscCode;
    }

    public void setIfscCode(String ifscCode) {
        this.ifscCode = ifscCode;
    }

    public String getUpiId() {
        return upiId;
    }

    public void setUpiId(String upiId) {
        this.upiId = upiId;
    }

    public char getWithdrawRequest() {
        return withdrawRequest;
    }

    public void setWithdrawRequest(char withdrawRequest) {
        this.withdrawRequest = withdrawRequest;
    }

    public char getIsAdminUser() {
        return isAdminUser;
    }

    public void setIsAdminUser(char isAdminUser) {
        this.isAdminUser = isAdminUser;
    }

    public char getReferralRequest() {
        return referralRequest;
    }

    public void setReferralRequest(char referralRequest) {
        this.referralRequest = referralRequest;
    }

    public String getReferredByUser() {
        return referredByUser;
    }

    public void setReferredByUser(String referredByUser) {
        this.referredByUser = referredByUser;
    }

    public Long getPaymentPlan() {
        return paymentPlan;
    }

    public void setPaymentPlan(Long paymentPlan) {
        this.paymentPlan = paymentPlan;
    }

    public char getIsRejectedByAdmin() {
        return isRejectedByAdmin;
    }

    public void setIsRejectedByAdmin(char isRejectedByAdmin) {
        this.isRejectedByAdmin = isRejectedByAdmin;
    }

    public char getIsPaymentDone() {
        return isPaymentDone;
    }

    public void setIsPaymentDone(char isPaymentDone) {
        this.isPaymentDone = isPaymentDone;
    }
}
