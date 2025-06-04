package com.example.demo.controller;

import java.util.Map;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.example.demo.service.FarmlogService;
import com.example.demo.service.CropService;
import com.example.demo.service.CropVarietyService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrFarmLogController {

	@Autowired
	private Rq rq;

	@Autowired
	private FarmlogService farmlogService;

	@Autowired
	private CropVarietyService cropVarietyService;

	@Autowired
	private CropService cropService;

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
	public String showWriteForm(@RequestParam String date, Model model) {
		model.addAttribute("today", date);

		List<Map<String, Object>> cropList = cropService.getAllCropWithVariety();
		model.addAttribute("cropList", cropList);

		// JS에서 쓸 JSON 문자열도 같이 전달
		ObjectMapper mapper = new ObjectMapper();
		try {
			String cropListJson = mapper.writeValueAsString(cropList);
			model.addAttribute("cropListJson", cropListJson);
		} catch (JsonProcessingException e) {
			model.addAttribute("cropListJson", "[]");
		}

		return "usr/farmlog/write";
	}

	@PostMapping("/usr/farmlog/doWrite")
	@ResponseBody
	public String doWrite(HttpServletRequest req, @RequestParam(required = false) Integer crop_variety_id,
			@RequestParam(required = false) Integer work_type_id,
			@RequestParam(required = false) Integer agrochemical_id, @RequestParam String work_date,
			@RequestParam String work_memo) {

		Rq rq = (Rq) req.getAttribute("rq");

		if (Ut.isEmptyOrNull(work_memo)) {
			return Ut.jsHistoryBack("F-1", "작업 메모를 입력해 주세요.");
		}

		ResultData doWriteRd = farmlogService.writeFarmlog(rq.getLoginedMemberId(), crop_variety_id, work_type_id,
				agrochemical_id, work_date, work_memo);

		// 🔒 Null 체크 추가
		if (doWriteRd == null) {
			return Ut.jsHistoryBack("F-2", "영농일지 등록 중 오류가 발생했습니다.");
		}

		if (doWriteRd.isFail()) {
			return Ut.jsHistoryBack(doWriteRd.getResultCode(), doWriteRd.getMsg());
		}

		int id = (int) doWriteRd.getData1();

		farmlogService.writeArticle(rq.getLoginedMemberId(), "[팜로그] " + work_date, work_memo, 2);

		return Ut.jsReplace(doWriteRd.getResultCode(), doWriteRd.getMsg(), "./farmlog/detail?id=" + id);
	}

	@RequestMapping("/usr/farmlog")
	public class FarmlogController {
		@GetMapping("/write")
		public String showWrite(@RequestParam("date") String date, Model model) {
			model.addAttribute("today", date);
			return "usr/farmlog/write";
		}
	}

	public List<Map<String, String>> fetchCropVarietyData() throws IOException {
		String url = "http://api.odcloud.kr/api/15060250/v1/uddi:75592a9e-cd61-437c-900d-a56d0ce01618?page=1&perPage=1000&returnType=json&serviceKey=ENCODED_KEY";

		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

		ObjectMapper objectMapper = new ObjectMapper();
		JsonNode root = objectMapper.readTree(response.getBody());
		JsonNode data = root.path("data");

		List<Map<String, String>> result = new ArrayList<>();

		for (JsonNode item : data) {
			Map<String, String> row = new HashMap<>();
			row.put("cropName", item.path("작물명").asText());
			row.put("varietyName", item.path("품종명").asText());
			row.put("cropCode", item.path("작물코드").asText());
			row.put("varietyCode", item.path("품종코드").asText());
			result.add(row);
		}

		return result;
	}

	@ResponseBody
	@GetMapping("/crop-list")
	public List<Map<String, String>> getCropList() {
		return farmlogService.getCropAndVarietyList(); // crop_name + variety_name 목록 반환
	}

	@PostConstruct
	public void init() {
		farmlogService.fetchAndSaveCropData(); // 서버 시작 시 API 데이터 저장
	}
}
