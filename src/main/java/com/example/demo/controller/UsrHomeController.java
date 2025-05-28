package com.example.demo.controller;

import java.time.LocalDate;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UsrHomeController {
	@RequestMapping("/usr/home/main")
	public String showMain() {
		return "/usr/home/main";
	}

	@RequestMapping("/")
	public String showMain2() {
		return "redirect:/usr/home/main";
	}
	
	@RequestMapping("/list")
	public String showMain3() {
		return "redirect:/usr/article/getArticles";
	}
	
	@RequestMapping("/farmlog")
	public String showMain4() {
	    String today = LocalDate.now().toString(); // java.time.LocalDate 사용
	    return "redirect:/usr/farmlog/write?date=" + today;
	}

}