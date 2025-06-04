package com.example.demo.controller;

import java.io.BufferedReader;
import java.util.Map;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.service.ArticleService;
import com.example.demo.service.BoardService;
import com.example.demo.service.CropVarietyService;
import com.example.demo.service.FarmlogService;
import com.example.demo.service.ReactionPointService;
import com.example.demo.service.ReplyService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Farmlog;
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
	private JdbcTemplate jdbcTemplate;

	@Autowired
	private BoardService boardService;

	@Autowired
	private ReactionPointService reactionPointService;

	@Autowired
	private ReplyService replyService;

	@Autowired
	private CropVarietyService cropVarietyService;

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

	@GetMapping("/usr/farmlog/write")
	public String showWriteForm(Model model) {
		List<Map<String, Object>> cropVarieties = cropVarietyService.getAllCropVarieties();
		model.addAttribute("cropVarieties", cropVarieties);
		return "usr/farmlog/write";
	}

	@PostMapping("/usr/farmlog/doWrite")
	public String doWrite(@RequestParam String crop_variety_name, @RequestParam String work_type_name,
			@RequestParam(required = false) String agrochemical_name, @RequestParam String work_date,
			@RequestParam String work_memo, @SessionAttribute("loginedMemberId") int memberId) {

		// INSERT 처리 예시 (MyBatis, JPA 또는 직접 처리 방식에 따라 변경)
		String sql = "INSERT INTO farmlog (member_id, crop_variety_name, work_type_name, agrochemical_name, work_date, work_memo) "
				+ "VALUES (?, ?, ?, ?, ?, ?)";
		jdbcTemplate.update(sql, memberId, crop_variety_name, work_type_name, agrochemical_name, work_date, work_memo);

		return "redirect:/usr/farmlog/list";
	}

	@RequestMapping("/usr/farmlog/doWrite")
	@ResponseBody
	public String doWrite(HttpServletRequest req, Model model, int crop_variety_id, int work_type_id,
			int agrochemical_id, String work_date, String work_memo) {

		Rq rq = (Rq) req.getAttribute("rq");
		rq.getLoginedMemberId();

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

		// ✅ 게시판 자동 연동 추가
		int farmBoardId = 2; // 팜로그 게시판 ID (실제 환경에 맞게 수정 필요)
		String title = "[팜로그] " + work_date + " 작업 기록";
		String body = work_memo;

		articleService.writeArticle(rq.getLoginedMemberId(), title, body, farmBoardId);

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

			return "usr/farmlog/write";
		}

	}
}