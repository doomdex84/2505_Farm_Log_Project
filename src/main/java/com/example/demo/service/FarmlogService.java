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
	public ResultData writeFarmlog(int loginedMemberId, Integer cropVarietyDbId, String work_type_name,
			String agrochemical_name, String work_date, String nextSchedule, String work_memo, String imgFileName,
			int isPublic) {

		farmlogRepository.writeFarmlog(loginedMemberId, cropVarietyDbId, work_type_name, agrochemical_name, work_date,
				nextSchedule, work_memo, imgFileName, isPublic);

		int newId = farmlogRepository.getLastInsertId();

		return ResultData.from("S-1", "저장 성공", "id", newId);
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
		Farmlog farmlog = farmlogRepository.getFarmlogById(id);

		if (farmlog == null)
			return null;

		if (farmlog.getMember_id() != loginedMemberId)
			return null;

		return farmlog;
	}

	public ResultData modifyFarmlog(int id, int crop_variety_id, String work_type_name, String work_date,
			String nextSchedule, String work_memo, String img_file_name) {
		farmlogRepository.modify(id, crop_variety_id, work_type_name, work_date, nextSchedule, work_memo,
				img_file_name);
		return ResultData.from("S-1", "수정 완료");
	}

	public void writeArticle(int loginedMemberId, String string, String work_memo, int i) {
		// TODO Auto-generated method stub

	}

	public int getFarmlogCount(String searchKeywordTypeCode, String searchKeyword) {
		return farmlogRepository.getFarmlogCount(searchKeywordTypeCode, searchKeyword);
	}

	public List<Farmlog> getForPrintFarmlogs(int itemsInAPage, int page, String searchKeywordTypeCode,
			String searchKeyword) {
		int offset = (page - 1) * itemsInAPage;
		return farmlogRepository.getForPrintFarmlogs(itemsInAPage, offset, searchKeywordTypeCode, searchKeyword);
	}

	public Map<String, List<String>> getGroupedCropNames() {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Farmlog> getFarmlogsByMemberId(int memberId) {
		return farmlogRepository.findByMemberId(memberId);
	}

	public ResultData userCanDelete(int loginedMemberId, Farmlog farmlog) {
		if (farmlog.getMember_id() != loginedMemberId) {
			return ResultData.from("F-2", "삭제 권한이 없습니다.");
		}
		return ResultData.from("S-1", "삭제 완료되었습니다.");
	}

	public void deleteFarmlog(int id) {
		farmlogRepository.deleteFarmlog(id);
	}

	// 작성자(닉네임), 품목, 품종 기반 공개 영농일지 검색
	public List<Farmlog> findPublicLogs(String writerName, String cropName, String varietyName) {
		return farmlogRepository.findPublicLogs(writerName, cropName, varietyName);
	}
	
	public List<Farmlog> findPublicLogsUnified(String searchType, String searchKeyword) {
	    return farmlogRepository.findPublicLogsUnified(searchType, searchKeyword);
	}


}