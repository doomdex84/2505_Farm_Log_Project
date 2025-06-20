package com.example.demo.controller;

import com.example.demo.service.FarmlogService;
import com.example.demo.service.FavoriteService;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class UsrFavoriteController {

	@Autowired
	private FavoriteService favoriteService;

	@Autowired
	private FarmlogService farmlogService;

	@Autowired
	private Rq rq;

	// 즐겨찾기 등록
	@PostMapping("/usr/farmlog/favorite/add")
	@ResponseBody
	public ResultData addFavorite(HttpServletRequest req, @RequestParam long farmlogId) {
		Rq rq = (Rq) req.getAttribute("rq");
		if (!rq.isLogined()) {
			return ResultData.from("F-A", "로그인 후 이용 가능합니다.");
		}
		return favoriteService.addFavorite(rq.getLoginedMemberId(), farmlogId);
	}

	// 즐겨찾기 삭제
	@PostMapping("/usr/farmlog/favorite/delete")
	@ResponseBody
	public ResultData deleteFavorite(HttpServletRequest req, @RequestParam long farmlogId) {
		Rq rq = (Rq) req.getAttribute("rq");
		if (!rq.isLogined()) {
			return ResultData.from("F-A", "로그인 후 이용 가능합니다.");
		}
		return favoriteService.deleteFavorite(rq.getLoginedMemberId(), farmlogId);
	}

	// 즐겨찾기 목록 페이지
	@GetMapping("/usr/farmlog/favorite")
	public String showFavoritePage(Model model, HttpServletRequest req) {
		Rq rq = (Rq) req.getAttribute("rq");
		if (!rq.isLogined()) {
			return "redirect:/usr/member/login";
		}
		return "usr/farmlog/favorite";
	}

	// 즐겨찾기 목록 데이터(JSON)
	@GetMapping("/usr/farmlog/favorite/list")
	@ResponseBody
	public ResultData<List<Farmlog>> getFavoriteList(HttpServletRequest req) {
		Rq rq = (Rq) req.getAttribute("rq");
		if (!rq.isLogined()) {
			return ResultData.from("F-A", "로그인 후 이용 가능합니다.");
		}
		List<Farmlog> favoriteList = favoriteService.getFavoriteFarmlogs(rq.getLoginedMemberId());
		return ResultData.from("S-1", "즐겨찾기 목록 로드 성공", "favorites", favoriteList);
	}
}
