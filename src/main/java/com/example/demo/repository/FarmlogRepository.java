package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.vo.Farmlog;

@Mapper
public interface FarmlogRepository {

	// ✅ 전체 영농일지 (관리자/테스트용)
	List<Farmlog> getFarmlogs();

	// ✅ 특정 ID로 영농일지 상세 조회
	Farmlog getFarmlogById(int id);

	// ✅ 영농일지 작성 (사용자 작성용)
	void writeFarmlog(@Param("loginedMemberId") int loginedMemberId, @Param("cropVarietyDbId") Integer cropVarietyDbId,
			@Param("work_type_name") String work_type_name, @Param("agrochemical_name") String agrochemical_name,
			@Param("work_date") String work_date, @Param("nextSchedule") String nextSchedule,
			@Param("work_memo") String work_memo, @Param("img_file_name") String imgFileName,
			@Param("isPublic") int isPublic);

	// ✅ 마지막 INSERT ID 조회
	int getLastInsertId();

	// ✅ 품종 데이터 전체 조회
	List<Map<String, Object>> getAllCropVarieties();

	// ✅ 영농일지 자동 삽입 (AI용/기타)
	void insertFarmlog(@Param("member_id") int member_id, @Param("crop_variety_id") int crop_variety_id,
			@Param("workType") String workType, @Param("activityType") String activityType,
			@Param("cropCategory") String cropCategory, @Param("nextSchedule") String nextSchedule,
			@Param("work_date") String work_date, @Param("work_memo") String work_memo,
			@Param("img_file_name") String img_file_name);

	// ✅ 로그인 사용자 ID 기반 영농일지 목록 조회
	List<Farmlog> findByMemberId(@Param("memberId") int memberId);

	// ✅ 로그인 사용자 ID + 검색어 기반 영농일지 목록 조회 (검색 + 페이징)
	List<Farmlog> findByMemberIdAndKeyword(@Param("memberId") int memberId, @Param("keyword") String keyword,
			@Param("offset") int offset, @Param("limit") int limit);

	// ✅ 로그인 사용자 ID + 검색어 기반 영농일지 개수 (페이징용)
	int countByMemberIdAndKeyword(@Param("memberId") int memberId, @Param("keyword") String keyword);

	// ✅ 영농일지 삭제
	void deleteFarmlog(@Param("id") int id);

	// ✅ 영농일지 수정 (수정용)
	void modify(@Param("id") int id, @Param("crop_variety_id") int crop_variety_id,
			@Param("work_type_name") String work_type_name, @Param("work_date") String work_date,
			@Param("nextSchedule") String nextSchedule, @Param("work_memo") String work_memo,
			@Param("img_file_name") String img_file_name);

	// ✅ 공개 게시판: 작성자, 품목, 품종 검색
	List<Farmlog> findPublicLogs(@Param("writerName") String writerName, @Param("cropName") String cropName,
			@Param("varietyName") String varietyName);

	// ✅ 공개 게시판: 통합 검색 (유형 + 키워드)
	List<Farmlog> findPublicLogsUnified(@Param("searchType") String searchType,
			@Param("searchKeyword") String searchKeyword);

	// ✅ 공개 게시판: 검색 + 페이징
	List<Farmlog> getForPrintFarmlogs(@Param("limit") int limit, @Param("offset") int offset,
			@Param("searchKeywordTypeCode") String searchKeywordTypeCode, @Param("searchKeyword") String searchKeyword);

	int getFarmlogCount(@Param("searchKeywordTypeCode") String searchKeywordTypeCode,
			@Param("searchKeyword") String searchKeyword);

	// ✅ 오늘 작업한 품목+품종 (작업 완료용)
	List<String> findTodayWorked(@Param("memberId") int memberId, @Param("today") String today);

	// ✅ 오늘 예정된 작업 품목+품종 (작업 예정용)
	List<String> findTodayPlanned(@Param("memberId") int memberId, @Param("today") String today);

}
