package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.service.ArticleService;
import com.example.demo.service.CropVarietyService;
import com.example.demo.service.FarmlogService;
import com.example.demo.util.Ut;
import com.example.demo.util.WorkTypeScheduleMap;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;

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
	public String doWrite(HttpServletRequest req, @RequestParam(required = false) MultipartFile file,
			@RequestParam(required = false) String crop_variety_id, @RequestParam String work_type_name,
			@RequestParam(required = false) String agrochemical_name, @RequestParam String work_date,
			@RequestParam(required = false) String nextSchedule, @RequestParam String work_memo) {

		Rq rq = (Rq) req.getAttribute("rq");

		// 1. 유효성 검사
		if (Ut.isEmptyOrNull(work_memo)) {
			return Ut.jsHistoryBack("F-1", "작업 메모를 입력해 주세요.");
		}

		if (Ut.isEmptyOrNull(crop_variety_id)) {
			return Ut.jsHistoryBack("F-1", "품종을 선택해 주세요.");
		}

		Integer cropVarietyDbId = Integer.parseInt(crop_variety_id);

		// ✅ nextSchedule 자동 계산 (WorkTypeScheduleMap 사용)
		if (Ut.isEmptyOrNull(nextSchedule)) {
			System.out.println("▶ work_type_name = [" + work_type_name + "]");
			Integer daysToAdd = WorkTypeScheduleMap.MAP.get(work_type_name);
			System.out.println("▶ daysToAdd = " + daysToAdd);
			if (daysToAdd != null) {
				LocalDate workDateParsed = LocalDate.parse(work_date);
				LocalDate nextDate = workDateParsed.plusDays(daysToAdd);
				nextSchedule = nextDate.toString();
			} else {
				nextSchedule = work_date;
			}
			System.out.println("▶ 최종 nextSchedule = " + nextSchedule);
		}

		// 2. 이미지 업로드 처리
		String imgFileName = null;
		if (file != null && !file.isEmpty()) {
			String uuid = UUID.randomUUID().toString();
			imgFileName = uuid + "_" + file.getOriginalFilename();

			String uploadDirPath = "C:/upload/farmlog";
			File uploadDir = new File(uploadDirPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			Path uploadFilePath = Paths.get(uploadDirPath, imgFileName);

			String webappDirPath = req.getServletContext().getRealPath("/gen/farmlog");
			File webappDir = new File(webappDirPath);
			if (!webappDir.exists()) {
				webappDir.mkdirs();
			}
			Path webappFilePath = Paths.get(webappDirPath, imgFileName);

			try {
				Files.copy(file.getInputStream(), uploadFilePath);
				Files.copy(uploadFilePath, webappFilePath, StandardCopyOption.REPLACE_EXISTING);
			} catch (IOException e) {
				e.printStackTrace();
				return Ut.jsHistoryBack("F-IMG", "이미지 업로드 중 오류 발생");
			}
		}

		// 3. 영농일지 저장
		ResultData doWriteRd = farmlogService.writeFarmlog(rq.getLoginedMemberId(), cropVarietyDbId, work_type_name,
				agrochemical_name, work_date, nextSchedule, work_memo, imgFileName);

		int id = (int) doWriteRd.getData1();

		// 4. 게시글 등록
		farmlogService.writeArticle(rq.getLoginedMemberId(), "[팜로그] " + work_date, work_memo, 2);

		// 5. 상세페이지로 리다이렉트
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