package com.example.demo.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.service.ArticleService;
import com.example.demo.service.BoardService;
import com.example.demo.service.ReactionPointService;
import com.example.demo.service.ReplyService;
import com.example.demo.service.FarmlogService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.Board;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.Reply;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrFarmLogController {

	private final BeforeActionInterceptor beforeActionInterceptor;

	@Autowired
	private Rq rq;

	@Autowired
	private ArticleService articleService;

	@Autowired
	private FarmlogService farmlogService;

	@Autowired
	private BoardService boardService;

	@Autowired
	private ReactionPointService reactionPointService;

	@Autowired
	private ReplyService replyService;

	UsrFarmLogController(BeforeActionInterceptor beforeActionInterceptor) {
		this.beforeActionInterceptor = beforeActionInterceptor;
	}

	@RequestMapping("/usr/farmlog/modify")
	public String showModify(HttpServletRequest req, Model model, int id) {

		Rq rq = (Rq) req.getAttribute("rq");

		Farmlog farmlog = farmlogService.getForPrintFarmlog(rq.getLoginedMemberId(), id);

		if (farmlog == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다", id));
		}

		model.addAttribute("farmlog", farmlog);

		return "/usr/farmlog/modify";
	}

	@RequestMapping("/usr/farmlog/write")
	public String showWriteForm(@RequestParam("date") String date, Model model) {
		model.addAttribute("date", date);
		return "usr/farmlog/write";
	}

	@RequestMapping("/usr/farmlog/doWrite")
	@ResponseBody
	public String doWrite(HttpServletRequest req, Model model, int member_id, int crop_variety_id, int work_type_id,
			int agrochemical_id, String work_date, String work_memo) {

		Rq rq = (Rq) req.getAttribute("rq");

		if (Ut.isEmptyOrNull(crop_variety_id)) {
			return Ut.jsHistoryBack("F-1", "작물 품종을 선택해 주세요");
		}

		if (Ut.isEmptyOrNull(work_type_id)) {
			return Ut.jsHistoryBack("F-2", "작업 종류를 선택해 주세요");
		}

		if (Ut.isEmptyOrNull(agrochemical_id)) {
			return Ut.jsHistoryBack("F-3", "사용한 농약/비료를 선택해 주세요");
		}
		if (Ut.isEmptyOrNull(work_date)) {
			return Ut.jsHistoryBack("F-4", "작업한 날짜를 선택해 주세요");
		}

		if (Ut.isEmptyOrNull(work_memo)) {
			return Ut.jsHistoryBack("F-5", "작업에 대한 메모(상세 설명 등)을 기입해 주세요");
		}

		ResultData doWriteRd = farmlogService.writeFarmlog(rq.getLoginedMemberId(), crop_variety_id, work_type_id,
				agrochemical_id, work_date, work_memo);

		int id = (int) doWriteRd.getData1();

		Farmlog farmlog = farmlogService.getFarmlogById(id);

		return Ut.jsReplace(doWriteRd.getResultCode(), doWriteRd.getMsg(), "../farmlog/detail?id=" + id);
	}

	@RequestMapping("/usr/farmlog/list")
	public String showList(HttpServletRequest req, Model model, int id, int member_id, int crop_variety_id,
			int work_type_id, int agrochemical_id, String work_date, String work_memo) {

		Rq rq = (Rq) req.getAttribute("rq");

		List<Farmlog> farmlogs = farmlogService.getForPrintFarmlogs(id, member_id, crop_variety_id, work_type_id,
				agrochemical_id, work_date, work_memo);

		return "usr/farmlog/list";
	}

	@RequestMapping("/usr/farmlog")
	public class FarmlogController {

		@GetMapping("/write")
		public String showWrite(@RequestParam("date") String date, Model model) {
			model.addAttribute("today", date);

			// 예: OpenWeather API 사용
			String weather = getWeatherInfo(); // ← 아래 함수에서 날씨를 가져옴
			model.addAttribute("weather", weather);

			return "usr/farmlog/write";
		}

		private String getWeatherInfo() {
			try {
				String apiUrl = "";

				URL url = new URL(apiUrl);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("GET");

				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String result = br.lines().collect(Collectors.joining());

				JSONObject json = new JSONObject(result);
				String description = json.getJSONArray("weather").getJSONObject(0).getString("description");
				double temp = json.getJSONObject("main").getDouble("temp");

				return description + ", " + temp + "°C";
			} catch (Exception e) {
				return "날씨 정보 없음";
			}
		}
	}
}