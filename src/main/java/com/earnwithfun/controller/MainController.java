package com.earnwithfun.controller;

import com.earnwithfun.entity.PaymentDetail;
import com.earnwithfun.entity.User;
import com.earnwithfun.service.UserServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class MainController {

    @Autowired
    private UserServiceImpl userService;

    @RequestMapping("/")
    public String home(Model model){
        if(!model.containsAttribute("activeTab")){
            model.addAttribute("activeTab", "newsBtn");
        }
        model.addAttribute("user", new User());
        return "home";
    }

    @RequestMapping("/dashboard")
    public String dashboard(Model model){
        User user = (User) model.asMap().get("user");
        List<PaymentDetail> paymentDetails = userService.getPaymentDetails(user);
        model.addAttribute("user", user);
        model.addAttribute("paymentDetails", paymentDetails);
        return "dashboard";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public RedirectView login(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        User userDetail = userService.getUserByUserNameAndPassword(user);

        if (userDetail == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid username or password. Please try again.");
            redirectAttributes.addFlashAttribute("activeTab", "loginBtn");
            redirectAttributes.addFlashAttribute("loginUser", user);
            return new RedirectView(request.getContextPath() + "/");
        }

        User userByPaymentCode = userService.getUserByPaymentCode(user);
        if (userByPaymentCode == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid Payment Code.");
            redirectAttributes.addFlashAttribute("activeTab", "loginBtn");
            return new RedirectView(request.getContextPath() + "/");
        }
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/dashboard");
        userDetail.setPaymentCode("");
        redirectAttributes.addFlashAttribute("user", userDetail);
        return redirectView;
    }

    @RequestMapping(value = "/signUp", method = RequestMethod.POST)
    public RedirectView signUp(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        User userByUserName = userService.getUserByUserName(user.getUsername());
        if(userByUserName != null){
            redirectAttributes.addFlashAttribute("errorMessage", "Username Already Exists.");
            redirectAttributes.addFlashAttribute("activeTab", "signUpBtn");
            user.setPaymentCode("");
            redirectAttributes.addFlashAttribute("user", user);
            return new RedirectView(request.getContextPath() + "/");
        }
        User parentUser = this.userService.getUserByReferralCode(user.getReferralCode());
        if(parentUser == null){
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid Referral Code.");
            redirectAttributes.addFlashAttribute("activeTab", "signUpBtn");
            user.setPaymentCode("");
            redirectAttributes.addFlashAttribute("user", user);
            return new RedirectView(request.getContextPath() + "/");
        }

        user.setReferredByUser(parentUser.getUsername());
        this.userService.createUser(user);
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/");
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
        redirectView.setUrl(request.getContextPath()+"/");
        redirectAttributes.addFlashAttribute("successMessage", "Withdraw successfully. Your money will be Credit to your account within 24 hours.");
        redirectAttributes.addFlashAttribute("activeTab", "withdrawBtn");
        return redirectView;
    }

    @RequestMapping(value = "/adminLogin", method = RequestMethod.POST)
    public RedirectView adminLogin(@ModelAttribute User user, HttpServletRequest request, RedirectAttributes redirectAttributes){
        User adminUser = userService.getAdminUser(user);
        if(adminUser == null){
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid Admin Username or password.");
            redirectAttributes.addFlashAttribute("activeTab", "adminLoginBtn");
            return new RedirectView(request.getContextPath() + "/");
        }
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/adminDashboard");
        redirectAttributes.addFlashAttribute("user", adminUser);
        return redirectView;
    }
    @RequestMapping("/adminDashboard")
    public String adminDashboard(Model model){
        User user = (User) model.asMap().get("user");
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
        redirectView.setUrl(request.getContextPath()+"/");
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
        redirectView.setUrl(request.getContextPath()+"/");
        redirectAttributes.addFlashAttribute("successMessage", "Referral Approve successfully.");
        redirectAttributes.addFlashAttribute("activeTab", "referralApproveBtn");
        return redirectView;
    }
}
