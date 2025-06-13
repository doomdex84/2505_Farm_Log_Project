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
		Rq rq = rqProvider.getObject(); // 💡 Prototype Bean (요청마다 새 객체)
		req.setAttribute("rq", rq); // ✅ JSP에서 사용할 수 있게 등록
		rq.initBeforeActionInterceptor(); // 추가 초기화 작업 수행
		return true;
	}

}
