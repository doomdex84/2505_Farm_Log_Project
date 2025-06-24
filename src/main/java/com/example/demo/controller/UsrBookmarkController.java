package com.example.demo.controller;

import com.example.demo.service.BookmarkService;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class UsrBookmarkController {

	@Autowired
	private BookmarkService bookmarkService;

	@Autowired
	private Rq rq;

	@GetMapping("/usr/farmlog/bookmark")
	public String showBookmarkPage(Model model) {
		if (!rq.isLogined()) {
			return "redirect:/usr/member/login";
		}

		List<Farmlog> bookmarkList = bookmarkService.getBookmarkFarmlogsByMemberId(rq.getLoginedMemberId());
		model.addAttribute("bookmarkList", bookmarkList);
		return "usr/farmlog/bookmark"; // JSP 파일 경로와 파일명
	}

	@PostMapping("/usr/farmlog/bookmark/add")
	@ResponseBody
	public ResultData addBookmark(@RequestParam long farmlogId) {
		if (!rq.isLogined()) {
			return ResultData.from("F-A", "로그인 후 이용 가능합니다.");
		}

		long memberId = rq.getLoginedMemberId();
		System.out.println(">>> addBookmark: memberId = " + memberId + ", farmlogId = " + farmlogId);

		return bookmarkService.addBookmark(memberId, farmlogId);
	}

	@PostMapping("/usr/farmlog/bookmark/delete")
	@ResponseBody
	public ResultData deleteBookmark(@RequestParam long farmlogId) {
		if (!rq.isLogined()) {
			return ResultData.from("F-A", "로그인 후 이용 가능합니다.");
		}

		return bookmarkService.deleteBookmark(rq.getLoginedMemberId(), farmlogId);
	}
}
