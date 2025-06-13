package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;

import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.interceptor.NeedLoginInterceptor;
import com.example.demo.interceptor.NeedLogoutInterceptor;

@Configuration
public class WebMvcConfigurer implements org.springframework.web.servlet.config.annotation.WebMvcConfigurer {

	// BeforeActionInterceptor 불러오기(연결)
	@Autowired
	BeforeActionInterceptor beforeActionInterceptor;

	// NeedLoginInterceptor 불러오기(연결)
	@Autowired
	NeedLoginInterceptor needLoginInterceptor;

	// NeedLogoutInterceptor 불러오기(연결)
	@Autowired
	NeedLogoutInterceptor needLogoutInterceptor;

	// 인터셉터 등록(적용)
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
//		registry.addInterceptor(beforeActionInterceptor).addPathPatterns("/**").excludePathPatterns("/resource/**")
//				.excludePathPatterns("/error");
//
//		registry.addInterceptor(needLoginInterceptor).addPathPatterns("/usr/article/write")
//				.addPathPatterns("/usr/article/doWrite").addPathPatterns("/usr/article/modify")
//				.addPathPatterns("/usr/article/doModify").addPathPatterns("/usr/article/doDelete")
//				.addPathPatterns("/usr/member/doLogout");
//
//		registry.addInterceptor(needLogoutInterceptor).addPathPatterns("/usr/member/login")
//				.addPathPatterns("/usr/member/doLogin").addPathPatterns("/usr/member/join")
//				.addPathPatterns("/usr/member/doJoin");

		InterceptorRegistration ir;

		// ✅ BeforeActionInterceptor - 모든 요청 전 공통 처리
		ir = registry.addInterceptor(beforeActionInterceptor);
		ir.addPathPatterns("/**");
		ir.addPathPatterns("/favicon.ico");
		ir.excludePathPatterns("/resource/**");
		ir.excludePathPatterns("/error");

		// ✅ NeedLoginInterceptor - 로그인 필수 구간
		ir = registry.addInterceptor(needLoginInterceptor);

		// 📌 글 관련
		ir.addPathPatterns("/usr/article/write");
		ir.addPathPatterns("/usr/article/doWrite");
		ir.addPathPatterns("/usr/article/modify");
		ir.addPathPatterns("/usr/article/doModify");
		ir.addPathPatterns("/usr/article/doDelete");

		// 📌 Farmlog 관련
		ir.addPathPatterns("/usr/farmlog/write");
		ir.addPathPatterns("/usr/farmlog/list");
		ir.addPathPatterns("/usr/farmlog/detail");
		ir.addPathPatterns("/usr/farmlog/modify");
		ir.addPathPatterns("/usr/farmlog/doModify");
		ir.addPathPatterns("/usr/farmlog/delete");
		ir.addPathPatterns("/usr/farmlog/mylist");

		// 📌 회원 관련
		ir.addPathPatterns("/usr/member/myPage");
		ir.addPathPatterns("/usr/member/checkPw");
		ir.addPathPatterns("/usr/member/doCheckPw");
		ir.addPathPatterns("/usr/member/doLogout");
		ir.addPathPatterns("/usr/member/modify");
		ir.addPathPatterns("/usr/member/doModify");

		// 📌 댓글, 반응
		ir.addPathPatterns("/usr/reply/doWrite");
		ir.addPathPatterns("/usr/reactionPoint/doGoodReaction");
		ir.addPathPatterns("/usr/reactionPoint/doBadReaction");

		// ✅ NeedLogoutInterceptor - 로그아웃 상태에서만 접근 가능
		ir = registry.addInterceptor(needLogoutInterceptor);

		// 📌 로그인/회원가입 관련
		ir.addPathPatterns("/usr/member/login");
		ir.addPathPatterns("/usr/member/doLogin");
		ir.addPathPatterns("/usr/member/join");
		ir.addPathPatterns("/usr/member/doJoin");
		ir.addPathPatterns("/usr/member/findLoginId");
		ir.addPathPatterns("/usr/member/doFindLoginId");
		ir.addPathPatterns("/usr/member/findLoginPw");
		ir.addPathPatterns("/usr/member/doFindLoginPw");

		// ❌ 절대 포함 금지: /usr/farmlog/** 는 로그인한 사용자만 접근해야 하므로 제외
	}
}