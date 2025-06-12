package com.example.demo.interceptor;

import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class NeedLoginInterceptor implements HandlerInterceptor {

	private final ObjectProvider<Rq> rqProvider;

	public NeedLoginInterceptor(ObjectProvider<Rq> rqProvider) {
		this.rqProvider = rqProvider;
	}

	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {
		Rq rq = rqProvider.getObject(); // ✅ 요청마다 fresh한 rq 객체

		if (!rq.isLogined()) {
			String afterLoginUri = rq.getEncodedCurrentUri();
			rq.printReplace("F-A", "로그인 후 이용해주세요", "../member/login?afterLoginUri=" + afterLoginUri);
			return false;
		}

		return true;
	}
}
