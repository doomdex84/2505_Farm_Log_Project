package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.MemberService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/usr/social")
public class UsrSocialLoginController {

	@Autowired
	private MemberService memberService;

	@Autowired
	private Rq rq;

	@ResponseBody
	@PostMapping("/doKakaoLogin")
	public ResultData doKakaoLogin(String kakaoId, String email) {
		Member member = memberService.getMemberByKakaoId(kakaoId);
		if (member != null) {
			rq.login(member);
			return ResultData.from("S-1", "카카오 로그인 성공");
		}
		return ResultData.from("F-1", "카카오 계정으로 가입된 정보 없음");
	}

	@ResponseBody
	@PostMapping("/doGoogleLogin")
	public ResultData doGoogleLogin(String googleId, String email) {
		Member member = memberService.getMemberByGoogleId(googleId);
		if (member != null) {
			rq.login(member);
			return ResultData.from("S-1", "구글 로그인 성공");
		}
		return ResultData.from("F-1", "구글 계정으로 가입된 정보 없음");
	}

	@ResponseBody
	@PostMapping("/doNaverLogin")
	public ResultData doNaverLogin(String naverId, String email) {
		Member member = memberService.getMemberByNaverId(naverId);
		if (member != null) {
			rq.login(member);
			return ResultData.from("S-1", "네이버 로그인 성공");
		}
		return ResultData.from("F-1", "네이버 계정으로 가입된 정보 없음");
	}
}
