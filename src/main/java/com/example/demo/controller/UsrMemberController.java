package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.MemberService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;

@Controller
public class UsrMemberController {

	@Autowired
	private MemberService memberService;

	@RequestMapping("/usr/member/doJoin")
	@ResponseBody
	public ResultData doJoin(String loginId, String loginPw, String name, String nickname, String cellphoneNum,
			String email) {

		if (Ut.isEmptyOrNull(loginId)) {
			return ResultData.from("F-1", Ut.f("아이디를 입력해"));			
		}
		if (Ut.isEmptyOrNull(loginPw)) {
			return ResultData.from("F-1", Ut.f("비밀번호를 입력해"));
		}
		if (Ut.isEmptyOrNull(name)) {
			return ResultData.from("F-1", Ut.f("이름을 입력해"));
		}
		if (Ut.isEmptyOrNull(nickname)) {
			return ResultData.from("F-1", Ut.f("닉네임을 입력해"));
		}
		if (Ut.isEmptyOrNull(cellphoneNum)) {
			return ResultData.from("F-1", Ut.f("전화번호를 입력해"));
		}
		if (Ut.isEmptyOrNull(email)) {
			return ResultData.from("F-1", Ut.f("이메일을 입력해"));
		}

		int id = memberService.doJoin(loginId, loginPw, name, nickname, cellphoneNum, email);

		if (id == -1) {
			
			return ResultData.from("F-1", Ut.f("이미 사용중인 아이디(%s)입니다", loginId));
			
		}

		if (id == -2) {
			return ResultData.from("F-1", Ut.f("이미 사용중인 이름(%s)과 이메일(%s)입니다", name, email));
			
		}

		Member member = memberService.getMemberById(id);
		
		return ResultData.from("S-1",member);
		
	}

}