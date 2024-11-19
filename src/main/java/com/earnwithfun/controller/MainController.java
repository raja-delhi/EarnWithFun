package com.earnwithfun.controller;

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
        model.addAttribute("user", user);
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
        this.userService.createUser(user);
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl(request.getContextPath()+"/");
        redirectAttributes.addFlashAttribute("successMessage", "Registration successfully. Please Login.");
        redirectAttributes.addFlashAttribute("activeTab", "loginBtn");
        return redirectView;
    }
}
