package com.example.demo.controller;

import java.util.Map;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.service.FarmlogService;
import com.example.demo.service.CropVarietyService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrFarmLogController {

	@Autowired
	private Rq rq;

	@Autowired
	private FarmlogService farmlogService;

	@Autowired
	private CropVarietyService cropVarietyService;

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
}
