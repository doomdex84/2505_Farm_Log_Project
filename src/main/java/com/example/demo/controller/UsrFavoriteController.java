package com.example.demo.controller;

import com.example.demo.service.FavoriteService;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/usr/favorite")
public class UsrFavoriteController {

	@Autowired
	private FavoriteService favoriteService;

	// 즐겨찾기 등록
	@PostMapping("/add")
	public ResultData addFavorite(HttpSession session, @RequestParam long farmlogId) {
		Member loginedMember = (Member) session.getAttribute("loginedMember");
		if (loginedMember == null) {
			return ResultData.from("F-A", "로그인 후 이용 가능합니다.");
		}
		return favoriteService.addFavorite(loginedMember.getId(), farmlogId);
	}

	// 즐겨찾기 삭제
	@PostMapping("/delete")
	public ResultData deleteFavorite(HttpSession session, @RequestParam long farmlogId) {
		Member loginedMember = (Member) session.getAttribute("loginedMember");
		if (loginedMember == null) {
			return ResultData.from("F-A", "로그인 후 이용 가능합니다.");
		}
		return favoriteService.deleteFavorite(loginedMember.getId(), farmlogId);
	}

	// 즐겨찾기 목록
	@GetMapping("/list")
	public ResultData<List<Farmlog>> getMyFavoriteList(HttpSession session) {
		Member loginedMember = (Member) session.getAttribute("loginedMember");
		if (loginedMember == null) {
			return ResultData.from("F-A", "로그인 후 이용 가능합니다.");
		}

		long memberId = loginedMember.getId();
		List<Farmlog> favorites = favoriteService.getFavoriteFarmlogs(memberId);

		// 기존 ResultData 구조에 맞게 data1Name 지정
		return ResultData.from("S-1", "즐겨찾기 목록 조회 성공", "favorites", favorites);
	}
}
