package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.CropVarietyRepository;
import com.example.demo.repository.FarmlogRepository;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;

@Service
public class FarmlogService {

	@Autowired
	private FarmlogRepository farmlogRepository;

	@Autowired
	private CropVarietyRepository cropVarietyRepository;

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

		// 저장 처리
		farmlogRepository.insertFarmlog(loginedMemberId, crop_variety_id, work_type_id, agrochemical_id, work_date,
				work_memo);

		// DB insert가 성공했다고 가정하고 임시 ID 반환
		int newId = farmlogRepository.getLastInsertId(); // 또는 직접 생성된 ID 반환

		return ResultData.from("S-1", "영농일지 작성 완료", "id", newId);

	}

	public void saveCropVarieties(List<Map<String, String>> data) {
		for (Map<String, String> row : data) {
			cropVarietyRepository.insertCropVarietyStd(row.get("cropCode"), row.get("cropName"), row.get("varietyCode"),
					row.get("varietyName"));
		}
	}

	public void fetchAndSaveCropData() {
		
	}
	public List<Map<String, String>> getCropAndVarietyList() {
	    return cropVarietyRepository.selectJoinWithCropName();
	}
}
