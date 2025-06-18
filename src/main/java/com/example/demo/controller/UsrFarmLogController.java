package com.example.demo.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders; // Spring용 HttpHeaders import
import org.springframework.http.HttpMethod;

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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
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
import com.fasterxml.jackson.databind.ObjectMapper;

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
			@RequestParam(required = false) String nextSchedule, @RequestParam String work_memo,
			@RequestParam(required = false, defaultValue = "0") int isPublic) {

		Rq rq = (Rq) req.getAttribute("rq");

		if (Ut.isEmptyOrNull(work_memo)) {
			return Ut.jsHistoryBack("F-1", "작업 메모를 입력해 주세요.");
		}

		if (Ut.isEmptyOrNull(crop_variety_id)) {
			return Ut.jsHistoryBack("F-1", "품종을 선택해 주세요.");
		}

		Integer cropVarietyDbId = Integer.parseInt(crop_variety_id);

		if (Ut.isEmptyOrNull(nextSchedule)) {
			Integer daysToAdd = WorkTypeScheduleMap.MAP.get(work_type_name);
			if (daysToAdd != null) {
				LocalDate workDateParsed = LocalDate.parse(work_date);
				nextSchedule = workDateParsed.plusDays(daysToAdd).toString();
			} else {
				nextSchedule = work_date;
			}
		}

		String imgFileName = null;
		if (file != null && !file.isEmpty()) {
			String uuid = UUID.randomUUID().toString();
			imgFileName = uuid + "_" + file.getOriginalFilename();

			String uploadDirPath = "C:/upload/farmlog";
			File uploadDir = new File(uploadDirPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}

			String webappDirPath = req.getServletContext().getRealPath("/gen/farmlog");
			File webappDir = new File(webappDirPath);
			if (!webappDir.exists()) {
				webappDir.mkdirs();
			}

			try {
				Path uploadFilePath = Paths.get(uploadDirPath, imgFileName);
				Files.copy(file.getInputStream(), uploadFilePath, StandardCopyOption.REPLACE_EXISTING);

				Path webappFilePath = Paths.get(webappDirPath, imgFileName);
				Files.copy(uploadFilePath, webappFilePath, StandardCopyOption.REPLACE_EXISTING);
			} catch (IOException e) {
				e.printStackTrace();
				return Ut.jsHistoryBack("F-IMG", "이미지 업로드 중 오류 발생");
			}
		}

		ResultData doWriteRd = farmlogService.writeFarmlog(rq.getLoginedMemberId(), cropVarietyDbId, work_type_name,
				agrochemical_name, work_date, nextSchedule, work_memo, imgFileName, isPublic);

		int id = (int) doWriteRd.getData1();

		if (isPublic == 1) {
			farmlogService.writeArticle(rq.getLoginedMemberId(), "[팜로그] " + work_date, work_memo, 2);
		}

		return Ut.jsReplace(doWriteRd.getResultCode(), doWriteRd.getMsg(), "/usr/farmlog/detail?id=" + id);
	}

	// 삭제 폼
	@RequestMapping("/usr/farmlog/doDelete")
	@ResponseBody
	public String doDelete(HttpServletRequest req, @RequestParam(required = false) Integer id) {
		if (id == null) {
			return Ut.jsHistoryBack("F-0", "id 파라미터가 없습니다.");
		}

		Rq rq = (Rq) req.getAttribute("rq");

		Farmlog farmlog = farmlogService.getFarmlogById(id);

		if (farmlog == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 영농일지는 존재하지 않습니다.", id));
		}

		ResultData userCanDeleteRd = farmlogService.userCanDelete(rq.getLoginedMemberId(), farmlog);

		if (userCanDeleteRd.isFail()) {
			return Ut.jsHistoryBack(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg());
		}

		farmlogService.deleteFarmlog(id);

		return Ut.jsReplace(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg(), "/usr/farmlog/list");
	}

	@PostMapping("/usr/farmlog/doModify")
	@ResponseBody
	public String doModify(HttpServletRequest req, @RequestParam int id, @RequestParam String work_date,
			@RequestParam int crop_variety_id, @RequestParam String work_type_name,
			@RequestParam(required = false) String work_memo, @RequestParam(required = false) String nextSchedule,
			@RequestParam(required = false) MultipartFile file) {

		Rq rq = (Rq) req.getAttribute("rq");

		// 기존 데이터 조회
		Farmlog oldLog = farmlogService.getForPrintFarmlog(rq.getLoginedMemberId(), id);
		if (oldLog == null) {
			return Ut.jsHistoryBack("F-1", "존재하지 않는 영농일지입니다.");
		}

		// 이미지 처리
		String img_file_name = oldLog.getImgFileName();
		if (file != null && !file.isEmpty()) {
			String uuid = UUID.randomUUID().toString();
			img_file_name = uuid + "_" + file.getOriginalFilename();

			String uploadDirPath = "C:/upload/farmlog";
			File uploadDir = new File(uploadDirPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}

			try {
				Path uploadFilePath = Paths.get(uploadDirPath, img_file_name);
				Files.copy(file.getInputStream(), uploadFilePath, StandardCopyOption.REPLACE_EXISTING);

				String webappDirPath = req.getServletContext().getRealPath("/gen/farmlog");
				File webappDir = new File(webappDirPath);
				if (!webappDir.exists()) {
					webappDir.mkdirs();
				}

				Path webappFilePath = Paths.get(webappDirPath, img_file_name);
				Files.copy(uploadFilePath, webappFilePath, StandardCopyOption.REPLACE_EXISTING);

			} catch (IOException e) {
				e.printStackTrace();
				return Ut.jsHistoryBack("F-IMG", "이미지 업로드 중 오류 발생");
			}
		}

		// DB 수정 처리
		ResultData rd = farmlogService.modifyFarmlog(id, crop_variety_id, work_type_name, work_date, nextSchedule,
				work_memo, img_file_name);
		return Ut.jsReplace(rd.getResultCode(), rd.getMsg(), "/usr/farmlog/detail?id=" + id);
	}

	// 수정 폼
	@RequestMapping("/usr/farmlog/modify")
	public String showModify(HttpServletRequest req, Model model, @RequestParam(required = false) Integer id) {
		if (id == null) {
			return Ut.jsHistoryBack("F-1", "id 값이 없습니다.");
		}

		Rq rq = (Rq) req.getAttribute("rq");
		Farmlog farmlog = farmlogService.getFarmlogById(id); // 작성자 제한 없는 단순 조회

		if (farmlog == null) {
			return Ut.jsHistoryBack("F-2", Ut.f("%d번 게시글은 없습니다", id));
		}

		if (farmlog.getMember_id() != rq.getLoginedMemberId()) {
			return "common/forbidden"; // 작성자 아니면 권한 없음 페이지
		}

		// ✅ 품목-품종 리스트도 함께 넘겨야 JSP에서 드롭다운 렌더링 가능
		List<Map<String, Object>> rawList = cropVarietyService.getAllCropVarietiesWithCategoryAndName();

		Map<String, Set<String>> groupedMap = new LinkedHashMap<>();
		for (Map<String, Object> item : rawList) {
			String category = (String) item.get("category");
			String cropName = (String) item.get("crop_name");

			groupedMap.computeIfAbsent(category, k -> new LinkedHashSet<>()).add(cropName);
		}

		model.addAttribute("farmlog", farmlog);
		model.addAttribute("cropVarietyListGrouped", groupedMap);
		model.addAttribute("cropVarietyList", rawList);

		return "/usr/farmlog/modify";
	}

	@GetMapping("/usr/farmlog/detail")
	public String showFarmlogDetail(@RequestParam("id") int id, HttpServletRequest req, Model model) {
		Farmlog farmlog = farmlogService.getFarmlogById(id);

		if (farmlog == null) {
			return "common/404";
		}

		Rq rq = (Rq) req.getAttribute("rq");

		if (farmlog.getIsPublic() != 1
				&& (rq == null || !rq.isLogined() || farmlog.getMember_id() != rq.getLoginedMemberId())) {
			return "common/forbidden";
		}

		model.addAttribute("farmlog", farmlog);
		model.addAttribute("loginedMember", rq.getLoginedMember());

		return "usr/farmlog/detail";
	}

	// 리스트
	@GetMapping("/usr/farmlog/list")
	public String showFarmlogList(Model model, HttpServletRequest req) {
		Rq rq = (Rq) req.getAttribute("rq");

		if (!rq.isLogined()) {
			return "redirect:/usr/member/login";
		}

		Member member = rq.getLoginedMember(); // ✅ HttpSession 사용하지 말고 Rq로 통일

		List<Farmlog> logs = farmlogService.getFarmlogsByMemberId(member.getId());

		model.addAttribute("farmlogList", logs);
		model.addAttribute("loginedMember", member);

		return "usr/farmlog/list";
	}

	// 공개게시판용
	@GetMapping("/usr/farmlog/publicBoard")
	public String showPublicBoard(Model model) {
		// 전체 공개글 조회
		List<Farmlog> publicLogs = farmlogService.findPublicLogs(null, null, null);
		model.addAttribute("publicLogs", publicLogs);
		return "usr/farmlog/publicBoard";
	}

	// 공개게시판 + 검색기능 (기존 publicList와 publicBoard 통합 개선)
	@GetMapping("/usr/farmlog/publiclist")
	public String showPublicList(@RequestParam(required = false) String searchType,
			@RequestParam(required = false) String searchKeyword, Model model) {
		// 검색 조건에 맞게 서비스 호출
		List<Farmlog> publicLogs = farmlogService.findPublicLogsUnified(searchType, searchKeyword);
		model.addAttribute("publicLogs", publicLogs);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		return "usr/farmlog/publicBoard";
	}

	// 오늘 작업일정 가져오기
	@RequestMapping("/usr/farmlog/calendar")
	public String showCalendar(Model model) {
		int memberId = rq.getLoginedMemberId();
		String todayDate = LocalDate.now().toString(); // 오늘 날짜

		// ✅ 달력 + 알림용 데이터 단일 쿼리
		List<Farmlog> farmlogs = farmlogService.getFarmlogsByMemberId(memberId);
		model.addAttribute("farmlogs", farmlogs);
		model.addAttribute("today", todayDate); // JSP에서 오늘 날짜 비교용

		return "usr/farmlog/calendar";
	}

	// 날씨 + 카카오(지역호출) API
	@GetMapping("/usr/api/weather")
	@ResponseBody
	public Map<String, Object> getWeatherAndLocation(@RequestParam double lat, @RequestParam double lon) {
		String apiKey = "YOUR_OPENWEATHERMAP_KEY";
		String kakaoKey = "YOUR_KAKAO_RESTAPI_KEY";

		Map<String, Object> resultMap = new LinkedHashMap<>();

		// 1️⃣ OpenWeather 호출
		try {
			String weatherUrl = String.format(
					"https://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=%s&units=metric&lang=kr", lat,
					lon, apiKey);

			URL url = new URL(weatherUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			br.close();

			ObjectMapper mapper = new ObjectMapper();
			Map<String, Object> weatherData = mapper.readValue(sb.toString(), Map.class);
			resultMap.put("weather", weatherData);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultCode", "F-1");
			resultMap.put("msg", "날씨 API 호출 실패");
			return resultMap;
		}

		// 2️⃣ Kakao API 호출
		try {
			String kakaoUrl = String.format("https://dapi.kakao.com/v2/local/geo/coord2address.json?x=%f&y=%f", lon,
					lat);

			URL url = new URL(kakaoUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Authorization", "KakaoAK " + kakaoKey);

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			br.close();

			ObjectMapper mapper = new ObjectMapper();
			Map<String, Object> locationData = mapper.readValue(sb.toString(), Map.class);
			resultMap.put("location", locationData);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("location", Map.of("resultCode", "F-1", "msg", "카카오 API 호출 실패"));
		}

		resultMap.put("resultCode", "S-1");
		resultMap.put("msg", "성공");
		return resultMap;
	}

}
