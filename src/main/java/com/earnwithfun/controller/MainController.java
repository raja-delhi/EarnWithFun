package com.earnwithfun.controller;

import com.earnwithfun.entity.PaymentDetail;
import com.earnwithfun.entity.User;
import com.earnwithfun.service.UserServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping("/main")
public class MainController {

    @Autowired
    private UserServiceImpl userService;

    @RequestMapping(value = "/loadJsp", method = RequestMethod.GET)
    public String loadJsp(@RequestParam("formId") String formId, Model model){
        model.addAttribute("user", new User());
        if(Objects.equals(formId, "Login")){
            return "login";
        }else if(Objects.equals(formId, "Signup")){
            return "signUp";
        }else if(Objects.equals(formId, "AdminLogin")){
            return "adminLogin";
        }else{
            return "home";
        }
    }

    @RequestMapping(value = "/",method = RequestMethod.GET)
    public String home(Model model){
        if(!model.containsAttribute("activeTab")){
            model.addAttribute("activeTab", "homeBtn");
        }
        model.addAttribute("user", new User());
        return "home";
    }

    @RequestMapping(value = "/dashboard",method = RequestMethod.GET)
    public String dashboard(@Validated User user, Model model){
        if(model.containsAttribute("user")){
            user = (User) model.getAttribute("user");
            if (user != null && user.getId() == null) {
                user = userService.getUserByUserName(user.getUsername());
            }
        }else {
            user = userService.getUserByUserName(user.getUsername());
        }
        List<PaymentDetail> paymentDetails = userService.getPaymentDetails(user);
        model.addAttribute("user", user);
        model.addAttribute("paymentDetails", paymentDetails);
        if(!model.containsAttribute("activeTab")){
            model.addAttribute("activeTab", "checkBalanceBtn");
        }
        return "dashboard";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Map<String, Object> login(@Validated User user, HttpServletRequest request){
        User userDetail = userService.getUserByUserNameAndPassword(user.getUsername() != null ? user.getUsername().trim() : "", user.getPassword() != null ? user.getPassword().trim() : "");
        Map<String, Object> map = new HashMap<>();
        if (userDetail == null) {
            map.put("errorMessage", "Invalid username or password. Please try again.");
            return map;
        }

        if(userDetail.getIsPaymentDone() == 'N') {
            User userByPaymentCode = userService.getUserByPaymentCode(user.getPaymentCode() != null ? user.getPaymentCode().trim() : "");
            if (userByPaymentCode == null) {
                map.put("errorMessage", "Invalid Payment Code.");
                return map;
            }
        }

        if(userDetail.getIsRejectedByAdmin() == 'Y'){
            map.put("errorMessage", "Your Account Registration is rejected by admin. Reason, Your payment plan is : " + userDetail.getPaymentPlan() + " and you paid less then Payment plan.");
            return map;
        }

        userDetail.setIsPaymentDone('Y');
        userService.updateUser(userDetail);
        map.put("userId", userDetail.getId());
        return map;
    }

    @RequestMapping(value = "/forgotPassword", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Map<String, Object> forgotPassword(@Validated User user, HttpServletRequest request){
        User userDetail = userService.getUserByUserName(user.getUsername() != null ? user.getUsername().trim() : "");
        Map<String, Object> map = new HashMap<>();
        if (userDetail == null) {
            map.put("errorMessage", "Invalid username. Please try again.");
            return map;
        }
        userDetail.setPassword(user.getPassword());
        userService.updateUser(userDetail);
        map.put("successMessage", "Password Changed Successfully, Login Now!");
        return map;
    }

    @RequestMapping(value = "/signUp", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Map<String, Object> signUp(@Validated User user){
        Map<String, Object> map = new HashMap<>();
        User userByUserName = userService.getUserByUserName(user.getUsername() != null ? user.getUsername().trim() : "");
        if(userByUserName != null){
            map.put("errorMessage", "Username Already Exists.");
            return map;
        }
        User parentUser = this.userService.getUserByReferralCode(user.getReferralCode() != null ? user.getReferralCode().trim() : "");
        if(parentUser == null){
            map.put("errorMessage", "Invalid Referral Code.");
            return map;
        }
        user.setReferralRequest('Y');
        user.setReferredByUser(parentUser.getUsername());
        this.userService.createUser(user);
        map.put("successMessage", "Registration successfully. Please Login.");
        return map;
    }

    @RequestMapping(value = "/withdraw", method = RequestMethod.POST)
    public RedirectView withdraw(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        User userDetail = this.userService.getUserByUserName(user.getUsername());
        RedirectView redirectView = new RedirectView();
        redirectAttributes.addFlashAttribute("user", userDetail);
        redirectView.setUrl(request.getContextPath() + "/main/dashboard");
        redirectAttributes.addFlashAttribute("activeTab", "withdrawBtn");

        if (userDetail.getWithdrawRequest() == 'Y') {
            redirectAttributes.addFlashAttribute("errorMessage", "Your Withdraw Request is pending. You can't withdraw again until your previous withdrawal request is approved.");
            return redirectView;
        }

        if (userDetail.getAmount() == null || userDetail.getAmount() < user.getAmount()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Insufficient funds. Please check your balance.");
            return redirectView;
        }

        if (user.getAmount() < 250) {
            redirectAttributes.addFlashAttribute("errorMessage", "Withdraw amount should be greater than or equal to 250.");
            return redirectView;
        }

        userDetail.setWithdrawRequest('Y');
        userDetail.setAccountNo(user.getAccountNo());
        userDetail.setUpiId(user.getUpiId());
        userDetail.setIfscCode(user.getIfscCode());

        Long remainingAmount = Optional.ofNullable(userDetail.getAmount()).orElse(0L) - user.getAmount();
        userDetail.setAmount(remainingAmount);

        this.userService.updateUser(userDetail);
        userService.createPayment(userDetail.getUsername(), "Withdraw By: " + userDetail.getFullName(), "-" + user.getAmount());

        redirectAttributes.addFlashAttribute("successMessage", "Withdraw successful. Your money will be credited to your account within 24 hours.");
        return redirectView;
    }

    @RequestMapping(value = "/adminLogin", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Map<String, Object> adminLogin(@Validated User user){
        Map<String, Object> map = new HashMap<>();
        User adminUser = userService.getAdminUser(user);
        if(adminUser == null){
            map.put("errorMessage", "Invalid Admin Username or password.");
            return map;
        }
        map.put("userId", adminUser.getId());
        return map;
    }
    @RequestMapping(value = "/adminDashboard" ,method = RequestMethod.GET)
    public String adminDashboard(@Validated User user, Model model){
        if(model.containsAttribute("user")){
            user = (User) model.getAttribute("user");
            if (user != null && user.getId() == null) {
                user = userService.getUserByUserName(user.getUsername());
            }
        }else {
            user = userService.getUserByUserName(user.getUsername());
        }
        List<User> withdrawRequestedUsers = userService.getUserRequestedForWithdraw();
        List<User> referredUsers = userService.getReferredUsers();
        List<User> paymentPlanChangeUsers = userService.getPaymentPlanChangeUsers();
        model.addAttribute("user", user);
        model.addAttribute("paymentPlanChangeUsers", paymentPlanChangeUsers);
        model.addAttribute("withdrawRequestedUsers", withdrawRequestedUsers);
        model.addAttribute("referredUsers", referredUsers);
        if(!model.containsAttribute("activeTab")) {
            model.addAttribute("activeTab", "withdrawApproveBtn");
        }
        return "adminDashboard";
    }

    @RequestMapping(value = "/approveWithdrawRequest", method = RequestMethod.POST)
    public RedirectView approveWithdrawRequest(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        user = userService.getUserById(user.getId());
        user.setWithdrawRequest('N');
        this.userService.updateUser(user);
        RedirectView redirectView = new RedirectView();
        redirectAttributes.addFlashAttribute("user", user);
        redirectView.setUrl(request.getContextPath()+"/main/adminDashboard");
        redirectAttributes.addFlashAttribute("successMessage1", "Withdraw Approve successfully.");
        redirectAttributes.addFlashAttribute("activeTab", "withdrawApproveBtn");
        return redirectView;
    }

    @RequestMapping(value = "/approveReferralRequest", method = RequestMethod.POST)
    public RedirectView approveReferralRequest(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        user = userService.getUserById(user.getId());
        user.setReferralRequest('N');
        user.setIsRejectedByAdmin('N');
        this.userService.updateUser(user);
        User parentUser = this.userService.getUserByUserName(user.getReferredByUser());
        Long paidAmount = parentUser.getPaymentPlan()<user.getPaymentPlan() ? parentUser.getPaymentPlan() / 2 : user.getPaymentPlan() / 2;
        this.userService.createPayment(user.getReferredByUser(), "Refer To : "+user.getFullName(), "+" + paidAmount);
        Long amount = parentUser.getAmount() != null ? parentUser.getAmount() + paidAmount : paidAmount;
        parentUser.setAmount(amount);
        this.userService.updateUser(parentUser);
        RedirectView redirectView = new RedirectView();
        redirectAttributes.addFlashAttribute("user", user);
        redirectView.setUrl(request.getContextPath()+"/main/adminDashboard");
        redirectAttributes.addFlashAttribute("successMessage", "Referral Approve successfully.");
        redirectAttributes.addFlashAttribute("activeTab", "referralApproveBtn");
        return redirectView;
    }

    @RequestMapping(value = "/rejectReferralRequest", method = RequestMethod.POST)
    public RedirectView rejectReferralRequest(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        user = userService.getUserById(user.getId());
        user.setIsRejectedByAdmin('Y');
        this.userService.updateUser(user);
        RedirectView redirectView = new RedirectView();
        redirectAttributes.addFlashAttribute("user", user);
        redirectView.setUrl(request.getContextPath()+"/main/adminDashboard");
        redirectAttributes.addFlashAttribute("successMessage", "Referral Reject successfully.");
        redirectAttributes.addFlashAttribute("activeTab", "referralApproveBtn");
        return redirectView;
    }

    @RequestMapping(value = "/approveChangePaymentPlanRequest", method = RequestMethod.POST)
    public RedirectView approveChangePaymentPlanRequest(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        user = userService.getUserById(user.getId());
        user.setIsPaymentUpdateRequest('N');
        user.setPaymentPlan(user.getNewPaymentPlan());
        this.userService.updateUser(user);
        RedirectView redirectView = new RedirectView();
        redirectAttributes.addFlashAttribute("user", user);
        redirectView.setUrl(request.getContextPath()+"/main/adminDashboard");
        redirectAttributes.addFlashAttribute("successMessage", "Changed Payment Plan Approve successfully.");
        redirectAttributes.addFlashAttribute("activeTab", "changePaymentPlanApproveBtn");
        return redirectView;
    }

    @RequestMapping(value = "/updatePaymentPlanRequest", method = RequestMethod.POST)
    public RedirectView updatePaymentPlanRequest(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        User userDetail = userService.getUserById(user.getId());
        RedirectView redirectView = new RedirectView();
        redirectAttributes.addFlashAttribute("user", userDetail);
        redirectView.setUrl(request.getContextPath()+"/main/dashboard");
        redirectAttributes.addFlashAttribute("activeTab", "profileBtn");
        if(0 <= userDetail.getPaymentPlan().compareTo(user.getNewPaymentPlan())){
            redirectAttributes.addFlashAttribute("errorMessage", "Your new Payment Plan should be greater then current Payment Plan.");
            return redirectView;
        }
        userDetail.setIsPaymentUpdateRequest('Y');
        userDetail.setNewPaymentPlan(user.getNewPaymentPlan());
        long remainingAmount = user.getNewPaymentPlan() - userDetail.getPaymentPlan();
        this.userService.updateUser(userDetail);
        redirectAttributes.addFlashAttribute("successMessage", "Payment Plan Update request Generated Successfully. Make Payment of " + remainingAmount + " amount to activate your ne Payment Plan");
        return redirectView;
    }
}
