package com.example.demo.controller;

import java.io.BufferedReader;
import java.util.Map;
import java.util.Set;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
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
import com.example.demo.service.CropService;
import com.example.demo.service.CropVarietyService;
import com.example.demo.service.FarmlogService;
import com.example.demo.service.ReactionPointService;
import com.example.demo.service.ReplyService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class UsrFarmLogController {

	@Autowired
	private Rq rq;

	@Autowired
	private ArticleService articleService;

	@Autowired
	private FarmlogService farmlogService;

	@Autowired
	private CropVarietyService cropVarietyService;

	// 품종(crop_variety) 리스트를 AJAX로 비동기 요청 받을 때 사용되는 메서드
	// 사용자가 특정 품목(crop)을 선택하면 해당 품목에 속한 품종만 JSON 형식으로 반환함
	@GetMapping("/usr/farmlog/varieties")
	@ResponseBody
	public List<Map<String, Object>> getVarietiesByCropCode(@RequestParam String cropCode) {
		return cropVarietyService.getVarietiesByCropCode(cropCode);
	}

	// 작성 폼: 품목/품종 리스트 전달
	@GetMapping("/usr/farmlog/write")
	public String showWriteForm(Model model, @RequestParam(required = false) String date) {
		List<Map<String, Object>> rawList = cropVarietyService.getAllCropVarietiesWithCategoryAndName();

		Map<String, Set<String>> groupedMap = new LinkedHashMap<>();
		for (Map<String, Object> item : rawList) {
			String category = (String) item.get("category");
			String cropName = (String) item.get("crop_name");

			groupedMap.computeIfAbsent(category, k -> new LinkedHashSet<>()).add(cropName);
		}

		model.addAttribute("cropVarietyListGrouped", groupedMap);
		model.addAttribute("cropVarietyList", rawList);

		if (date != null) {
			model.addAttribute("today", date);
		}

		return "usr/farmlog/write";
	}

	// 작성 처리
	@PostMapping("/usr/farmlog/doWrite")
	@ResponseBody
	public String doWrite(HttpServletRequest req, @RequestParam(required = false) String crop_variety_id,
			@RequestParam String work_type_name, @RequestParam(required = false) String agrochemical_name,
			@RequestParam String work_date, @RequestParam(required = false) String nextSchedule,
			@RequestParam String work_memo) {

		Rq rq = (Rq) req.getAttribute("rq");

		if (Ut.isEmptyOrNull(work_memo)) {
			return Ut.jsHistoryBack("F-1", "작업 메모를 입력해 주세요.");
		}

		if (Ut.isEmptyOrNull(crop_variety_id)) {
			return Ut.jsHistoryBack("F-1", "품종을 선택해 주세요.");
		}

		if (Ut.isEmptyOrNull(nextSchedule)) {
			nextSchedule = work_date;
		}

		Integer cropVarietyDbId = Integer.parseInt(crop_variety_id);

		ResultData doWriteRd = farmlogService.writeFarmlog(rq.getLoginedMemberId(), cropVarietyDbId, work_type_name,
				agrochemical_name, work_date, nextSchedule, work_memo);

		int id = (int) doWriteRd.getData1();

		farmlogService.writeArticle(rq.getLoginedMemberId(), "[팜로그] " + work_date, work_memo, 2);

		return Ut.jsReplace(doWriteRd.getResultCode(), doWriteRd.getMsg(), "/usr/farmlog/detail?id=" + id);
	}

	// 수정 폼
	@RequestMapping("/usr/farmlog/modify")
	public String showModify(HttpServletRequest req, Model model, @RequestParam(required = false) Integer id) {
		if (id == null) {
			return Ut.jsHistoryBack("F-1", "id 값이 없습니다.");
		}

		Rq rq = (Rq) req.getAttribute("rq");
		Farmlog farmlog = farmlogService.getForPrintFarmlog(rq.getLoginedMemberId(), id);

		if (farmlog == null) {
			return Ut.jsHistoryBack("F-2", Ut.f("%d번 게시글은 없습니다", id));
		}

		model.addAttribute("farmlog", farmlog);
		return "/usr/farmlog/modify";
	}

	@GetMapping("/usr/farmlog/detail")
	public String showFarmlogDetail(@RequestParam("id") int id, HttpServletRequest req, Model model) {
		Rq rq = (Rq) req.getAttribute("rq");
		Farmlog farmlog = farmlogService.getForPrintFarmlog(rq.getLoginedMemberId(), id);

		if (farmlog == null) {
			return "common/404";
		}

		model.addAttribute("farmlog", farmlog);
		return "usr/farmlog/detail";
	}

	// 리스트
	@GetMapping("/usr/farmlog/list")
	public String showFarmlogList(Model model, HttpSession session, HttpServletRequest req) {

		Rq rq = (Rq) req.getAttribute("rq");

		// ✅ 간단한 로그인 상태만 체크
		if (!rq.isLogined()) {
			return "redirect:/usr/member/login";
		}

		Member member = (Member) session.getAttribute("loginedMember");

		List<Farmlog> logs = null;

		if (member != null) {
			logs = farmlogService.getFarmlogsByMemberId(member.getId());
		}

		model.addAttribute("farmlogList", logs);
		model.addAttribute("loginedMember", member); // JSP에서 접근할 수 있도록 넘김

		return "usr/farmlog/mylist"; // JSP 파일명
	}

}