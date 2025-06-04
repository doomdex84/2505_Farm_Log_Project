package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.FarmlogRepository;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;

@Service
public class FarmlogService {

	@Autowired
	private FarmlogRepository farmlogRepository;

	// 영농일지 등록
	public ResultData writeFarmlog(int memberId, int cropVarietyId, String workType, String activityType,
			String cropCategory, String nextSchedule, String workDate, String workMemo) {

		farmlogRepository.insertFarmlog(memberId, cropVarietyId, workType, activityType, cropCategory, nextSchedule,
				workDate, workMemo);

		return ResultData.from("S-1", "영농일지 작성 완료");
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

	public void writeArticle(int loginedMemberId, String string, String work_memo, int i) {
		// TODO Auto-generated method stub

	}

	public Farmlog getForPrintFarmlog(int loginedMemberId, int id) {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Farmlog> getForPrintFarmlogs(int id, int member_id, int crop_variety_id, int work_type_id,
			int agrochemical_id, String work_date, String work_memo) {
		// TODO Auto-generated method stub
		return null;
	}

	public ResultData writeFarmlog(int loginedMemberId, Integer crop_variety_id, Integer work_type_id,
			Integer agrochemical_id, String work_date, String work_memo) {
		// TODO Auto-generated method stub
		return null;
	}
}
