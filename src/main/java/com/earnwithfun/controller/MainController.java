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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

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
    public String dashboard(@RequestParam("userId") Long userId, Model model){
        User user = userService.getUserById(userId);
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

        User userByPaymentCode = userService.getUserByPaymentCode(user.getPaymentCode() != null ? user.getPaymentCode().trim() : "");
        if (userByPaymentCode == null) {
            map.put("errorMessage", "Invalid Payment Code.");
            return map;
        }

        if(userDetail.getIsRejectedByAdmin() == 'Y'){
            map.put("errorMessage", "Your Account Registration is rejected by admin. Reason, Your payment plan is : " + userDetail.getPaymentPlan() + " and you paid less then Payment plan.");
            return map;
        }

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
    public RedirectView withdraw(@ModelAttribute User user, @RequestParam("username") String username, HttpServletRequest request, RedirectAttributes redirectAttributes){
        User userDetail = this.userService.getUserByUserName(username);
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/main/dashboard?userId="+userDetail.getId());
        redirectAttributes.addFlashAttribute("activeTab", "withdrawBtn");
        if(userDetail.getWithdrawRequest() == 'Y'){
            redirectAttributes.addFlashAttribute("errorMessage", "Your Withdraw Request is pending. you can't withdraw again until your previous withdraw request approved.");
            return redirectView;
        }else if(userDetail.getAmount() == null || userDetail.getAmount()<user.getAmount()){
            redirectAttributes.addFlashAttribute("errorMessage", "Your Amount is less than 50 Rupees. Refer more friends to earn and withdraw.");
            return redirectView;
        }else if(user.getAmount()<50){
            redirectAttributes.addFlashAttribute("errorMessage", "Withdraw amount should be greater than or equal to 50.");
            return redirectView;
        }
        userDetail.setWithdrawRequest('Y');
        userDetail.setAccountNo(user.getAccountNo());
        userDetail.setUpiId(user.getUpiId());
        userDetail.setIfscCode(user.getIfscCode());
        Long remainingAmount = userDetail.getAmount() != null ? userDetail.getAmount() - user.getAmount() : 0L;
        userDetail.setAmount(remainingAmount);
        this.userService.updateUser(userDetail);
        userService.createPayment(userDetail.getUsername(), "Withdraw By : " + userDetail.getFullName(), "-" + user.getAmount());
        redirectAttributes.addFlashAttribute("successMessage", "Withdraw successfully. Your money will be Credit to your account within 24 hours.");
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
    public String adminDashboard(@RequestParam("userId") Long userId, Model model){
        User user = userService.getUserById(userId);
        List<User> withdrawRequestedUsers = userService.getUserRequestedForWithdraw();
        List<User> referredUsers = userService.getReferredUsers();
        model.addAttribute("user", user);
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
        redirectView.setUrl(request.getContextPath()+"/main/adminDashboard?userId="+user.getId());
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
        Long paidAmount = parentUser.getPaymentPlan() / 2;
        this.userService.createPayment(user.getReferredByUser(), "Refer To : "+user.getFullName(), "+" + paidAmount);
        Long amount = parentUser.getAmount() != null ? parentUser.getAmount() + paidAmount : paidAmount;
        parentUser.setAmount(amount);
        this.userService.updateUser(parentUser);
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/main/adminDashboard?userId="+user.getId());
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
        redirectView.setUrl(request.getContextPath()+"/main/adminDashboard?userId="+user.getId());
        redirectAttributes.addFlashAttribute("successMessage", "Referral Approve successfully.");
        redirectAttributes.addFlashAttribute("activeTab", "referralApproveBtn");
        return redirectView;
    }
}
