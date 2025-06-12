package com.example.demo.interceptor;

import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class BeforeActionInterceptor implements HandlerInterceptor {

	private final ObjectProvider<Rq> rqProvider;

	public BeforeActionInterceptor(ObjectProvider<Rq> rqProvider) {
		this.rqProvider = rqProvider;
	}

	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {
		Rq rq = rqProvider.getObject(); // ✅ 요청마다 fresh하게
		req.setAttribute("rq", rq);
		rq.initBeforeActionInterceptor();
		return true;
	}
}
