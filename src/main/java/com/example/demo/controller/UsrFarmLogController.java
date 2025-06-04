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


    @GetMapping("/write")
    public String showWriteForm(HttpServletRequest req, Model model) {
        List<Map<String, Object>> cropVarieties = farmlogService.getAllCropVarieties();
        model.addAttribute("cropVarieties", cropVarieties);
        return "usr/farmlog/write";
    }

    @PostMapping("/doWrite")
    public String doWrite(HttpServletRequest req,
                          @RequestParam(required = false) Integer crop_variety_id,
                          @RequestParam(required = false) Integer work_type_id,
                          @RequestParam(required = false) Integer agrochemical_id,
                          @RequestParam String work_date,
                          @RequestParam String work_memo) {

        Rq rq = (Rq) req.getAttribute("rq");

        if (Ut.isEmptyOrNull(work_memo)) {
            return Ut.jsHistoryBack("F-1", "작업 메모를 입력해 주세요.");
        }

        ResultData doWriteRd = farmlogService.writeFarmlog(
                rq.getLoginedMemberId(), crop_variety_id, work_type_id, agrochemical_id, work_date, work_memo
        );

        int id = (int) doWriteRd.getData1();

        farmlogService.writeArticle(rq.getLoginedMemberId(), "[팜로그] " + work_date, work_memo, 2);

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