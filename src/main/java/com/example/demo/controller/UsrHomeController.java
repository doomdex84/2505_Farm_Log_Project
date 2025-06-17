package com.example.demo.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.service.ArticleService;
import com.example.demo.service.FarmlogService;
import com.example.demo.vo.Article;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.Rq;

import org.springframework.ui.Model;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrHomeController {

	@Autowired
	private Rq rq;

	@Autowired
	private FarmlogService farmlogService;

	@Autowired
	private ArticleService articleService; // 공지사항을 가져올 서비스 주입

	@GetMapping("/usr/home/main")
	public String showMainPage(Model model, HttpServletRequest req) {
		int loginedMemberId = rq.getLoginedMemberId();
		List<Farmlog> farmlogs = farmlogService.getFarmlogsByMemberId(loginedMemberId);
		model.addAttribute("farmlogs", farmlogs);

		// 공지사항 가져오기
		List<Article> notices = articleService.getLatestNotices(); // 최신 공지사항 가져오는 메서드 (LIMIT 1~N)
		model.addAttribute("notices", notices);

		return "usr/home/main";
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
		String today = LocalDate.now().toString();
		return "redirect:/usr/farmlog/write?date=" + today;
	}

	@RequestMapping("/usr/home/weatherApi")
	public String showWeatherApiPage() {
		return "/usr/home/weatherApi";
	}
}
