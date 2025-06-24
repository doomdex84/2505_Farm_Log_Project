package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.BookmarkRepository;
import com.example.demo.repository.FarmlogRepository;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;

@Service
public class FarmlogService {

	@Autowired
	private FarmlogRepository farmlogRepository;

	@Autowired
	private BookmarkRepository bookmarkRepository;

	// ✅ 영농일지 등록
	public ResultData writeFarmlog(int loginedMemberId, Integer cropVarietyDbId, String work_type_name,
			String agrochemical_name, String work_date, String nextSchedule, String work_memo, String imgFileName,
			int isPublic) {
		farmlogRepository.writeFarmlog(loginedMemberId, cropVarietyDbId, work_type_name, agrochemical_name, work_date,
				nextSchedule, work_memo, imgFileName, isPublic);
		int newId = farmlogRepository.getLastInsertId();
		return ResultData.from("S-1", "저장 성공", "id", newId);
	}

	// ✅ 단일 영농일지 조회
	public Farmlog getFarmlogById(int id) {
		return farmlogRepository.getFarmlogById(id);
	}

	// ✅ 전체 영농일지 리스트 조회 (관리자용)
	public List<Farmlog> getFarmlogs() {
		return farmlogRepository.getFarmlogs();
	}

	// ✅ 품종 리스트 조회
	public List<Map<String, Object>> getAllCropVarieties() {
		return farmlogRepository.getAllCropVarieties();
	}

	// ✅ 로그인 사용자가 본인 글 접근 권한 확인 + 조회
	public Farmlog getForPrintFarmlog(int loginedMemberId, int id) {
		Farmlog farmlog = farmlogRepository.getFarmlogById(id);
		if (farmlog == null)
			return null;
		if (farmlog.getMember_id() != loginedMemberId)
			return null;
		return farmlog;
	}

	// ✅ 영농일지 수정
	public ResultData modifyFarmlog(int id, int crop_variety_id, String work_type_name, String work_date,
			String nextSchedule, String work_memo, String img_file_name) {
		farmlogRepository.modify(id, crop_variety_id, work_type_name, work_date, nextSchedule, work_memo,
				img_file_name);
		return ResultData.from("S-1", "수정 완료");
	}

	// ✅ 영농일지 삭제 권한 체크
	public ResultData userCanDelete(int loginedMemberId, Farmlog farmlog) {
		if (farmlog.getMember_id() != loginedMemberId) {
			return ResultData.from("F-2", "삭제 권한이 없습니다.");
		}
		return ResultData.from("S-1", "삭제 완료되었습니다.");
	}

	// ✅ 영농일지 삭제
	public void deleteFarmlog(int id) {
		farmlogRepository.deleteFarmlog(id);
	}

	// ✅ 로그인 사용자 ID 기반 영농일지 목록
	public List<Farmlog> getFarmlogsByMemberId(int memberId) {
		return farmlogRepository.findByMemberId(memberId);
	}

	// ✅ 로그인 사용자 ID + 검색어 기반 영농일지 목록 (페이징 포함)
	public List<Farmlog> getFarmlogsByMemberIdAndKeyword(int memberId, String keyword, int offset, int limit) {
		return farmlogRepository.findByMemberIdAndKeyword(memberId, keyword, offset, limit);
	}

	// ✅ 로그인 사용자 ID + 검색어 기반 영농일지 개수
	public int getFarmlogCountByMemberIdAndKeyword(int memberId, String keyword) {
		return farmlogRepository.countByMemberIdAndKeyword(memberId, keyword);
	}

	// ✅ 공개 게시판: 작성자, 품목, 품종 기반 검색
	public List<Farmlog> findPublicLogs(String writerName, String cropName, String varietyName) {
		return farmlogRepository.findPublicLogs(writerName, cropName, varietyName);
	}

	// ✅ 공개 게시판: 통합 검색
	public List<Farmlog> findPublicLogsUnified(String searchType, String searchKeyword) {
		return farmlogRepository.findPublicLogsUnified(searchType, searchKeyword);
	}

	// ✅ 공개 게시판: 검색 + 페이징
	public int getFarmlogCount(String searchKeywordTypeCode, String searchKeyword) {
		return farmlogRepository.getFarmlogCount(searchKeywordTypeCode, searchKeyword);
	}

	public List<Farmlog> getForPrintFarmlogs(int itemsInAPage, int page, String searchKeywordTypeCode,
			String searchKeyword) {
		int offset = (page - 1) * itemsInAPage;
		return farmlogRepository.getForPrintFarmlogs(itemsInAPage, offset, searchKeywordTypeCode, searchKeyword);
	}

	// ✅ 오늘 작업한 품목+품종 (작업 완료용)
	public List<String> getTodayWorked(int memberId, String today) {
		return farmlogRepository.findTodayWorked(memberId, today);
	}

	// ✅ 오늘 예정된 작업 품목+품종 (작업 예정용)
	public List<String> getTodayPlanned(int memberId, String today) {
		return farmlogRepository.findTodayPlanned(memberId, today);
	}

	// ✅ 즐겨찾기 여부 확인
	public boolean checkIsBookmark(long memberId, long farmlogId) {
		return bookmarkRepository.selectIsBookmark(memberId, farmlogId) > 0;
	}

	// ✅ (미사용 / TODO) 임시 메서드
	public void writeArticle(int loginedMemberId, String string, String work_memo, int i) {
		// TODO Auto-generated method stub
	}

	// ✅ (미사용 / TODO) 임시 메서드
	public Map<String, List<String>> getGroupedCropNames() {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Map<String, Object>> getBookmarkListByMemberId(int memberId) {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Farmlog> getBookmarkFarmlogsByMemberId(int loginedMemberId) {
		// TODO Auto-generated method stub
		return null;
	}

}
