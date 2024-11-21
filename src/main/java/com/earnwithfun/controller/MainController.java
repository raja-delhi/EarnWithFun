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

    @RequestMapping("/")
    public String home(Model model){
        if(!model.containsAttribute("activeTab")){
            model.addAttribute("activeTab", "newsBtn");
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
        User userDetail = userService.getUserByUserNameAndPassword(user.getUsername(), user.getPassword());
        Map<String, Object> map = new HashMap<>();
        if (userDetail == null) {
            map.put("errorMessage", "Invalid username or password. Please try again.");
            return map;
        }

        User userByPaymentCode = userService.getUserByPaymentCode(user.getPaymentCode());
        if (userByPaymentCode == null) {
            map.put("errorMessage", "Invalid Payment Code.");
            return map;
        }
        map.put("userId", userDetail.getId());
        return map;
    }

    @RequestMapping(value = "/signUp")
    public RedirectView signUp(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        User userByUserName = userService.getUserByUserName(user.getUsername());
        if(userByUserName != null){
            redirectAttributes.addFlashAttribute("errorMessage", "Username Already Exists.");
            redirectAttributes.addFlashAttribute("activeTab", "signUpBtn");
            user.setPaymentCode("");
            redirectAttributes.addFlashAttribute("user", user);
            return new RedirectView(request.getContextPath() + "/main/");
        }
        User parentUser = this.userService.getUserByReferralCode(user.getReferralCode());
        if(parentUser == null){
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid Referral Code.");
            redirectAttributes.addFlashAttribute("activeTab", "signUpBtn");
            user.setPaymentCode("");
            redirectAttributes.addFlashAttribute("user", user);
            return new RedirectView(request.getContextPath() + "/main/");
        }

        user.setReferredByUser(parentUser.getUsername());
        this.userService.createUser(user);
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/main/");
        redirectAttributes.addFlashAttribute("successMessage", "Registration successfully. Please Login.");
        redirectAttributes.addFlashAttribute("activeTab", "loginBtn");
        return redirectView;
    }

    @RequestMapping(value = "/withdraw", method = RequestMethod.POST)
    public RedirectView withdraw(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        user.setWithdrawRequest('Y');
        User userDetail = this.userService.getUserByUserName(user.getUsername());
        Long remainingAmount = userDetail.getAmount() != null ? userDetail.getAmount() - user.getAmount() : null;
        user.setAmount(remainingAmount);
        this.userService.updateUser(user);
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/main/");
        redirectAttributes.addFlashAttribute("successMessage", "Withdraw successfully. Your money will be Credit to your account within 24 hours.");
        redirectAttributes.addFlashAttribute("activeTab", "withdrawBtn");
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
        model.addAttribute("activeTab", "withdrawApproveBtn");
        return "adminDashboard";
    }

    @RequestMapping(value = "/approveWithdrawRequest", method = RequestMethod.POST)
    public RedirectView approveWithdrawRequest(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        user.setWithdrawRequest('N');
        this.userService.updateUser(user);
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/main/");
        redirectAttributes.addFlashAttribute("successMessage", "Withdraw Approve successfully.");
        redirectAttributes.addFlashAttribute("activeTab", "withdrawApproveBtn");
        return redirectView;
    }

    @RequestMapping(value = "/approveReferralRequest", method = RequestMethod.POST)
    public RedirectView approveReferralRequest(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        user.setReferralRequest('N');
        this.userService.updateUser(user);
        this.userService.createPayment(user.getReferredByUser());
        User parentUser = this.userService.getUserByUserName(user.getReferredByUser());
        Long amount = parentUser.getAmount() != null ? parentUser.getAmount() + 20 : null;
        parentUser.setAmount(amount);
        this.userService.updateUser(parentUser);
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/main/");
        redirectAttributes.addFlashAttribute("successMessage", "Referral Approve successfully.");
        redirectAttributes.addFlashAttribute("activeTab", "referralApproveBtn");
        return redirectView;
    }
}
