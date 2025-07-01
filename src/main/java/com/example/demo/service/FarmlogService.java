package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.FarmlogRepository;
import com.example.demo.service.ArticleService;

import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;

@Service
public class FarmlogService {

        @Autowired
        private FarmlogRepository farmlogRepository;

       @Autowired
       private ArticleService articleService;

	// 영농일지 등록
	public ResultData writeFarmlog(int loginedMemberId, Integer crop_variety_id, String work_type, String activity_type,
			String crop_category, String next_schedule, String work_date, String work_memo) {

		farmlogRepository.writeFarmlog(loginedMemberId, crop_variety_id, work_type, activity_type, crop_category,
				next_schedule, work_date, work_memo);

		int id = farmlogRepository.getLastInsertId();

		return ResultData.from("S-1", "영농일지가 등록되었습니다.", "id", id);
	}

	// 단일 영농일지 조회
	public Farmlog getFarmlogById(int id) {

		return farmlogRepository.getFarmlogById(id);
	}

	// 전체 영농일지 리스트 조회
	public List<Farmlog> getFarmlogs() {
		return farmlogRepository.getFarmlogs();

	}

	// 품종 리스트 조회
	public List<Map<String, Object>> getAllCropVarieties() {
		return farmlogRepository.getAllCropVarieties();

	}

	public Farmlog getForPrintFarmlog(int loginedMemberId, int id) {
		// TODO Auto-generated method stub
		return null;
	}

       public void writeArticle(int loginedMemberId, String title, String work_memo, int boardId) {
               articleService.writeArticle(loginedMemberId, title, work_memo, boardId);

       }

	public List<Farmlog> getForPrintFarmlogs(int id, int member_id, int crop_variety_id, int work_type_id,
			int agrochemical_id, String work_date, String work_memo) {
		// TODO Auto-generated method stub
		return null;
	}

	public Map<String, List<String>> getGroupedCropNames() {
		// TODO Auto-generated method stub
		return null;
	}

}