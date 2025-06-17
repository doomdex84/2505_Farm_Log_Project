package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.vo.Farmlog;

@Mapper
public interface FarmlogRepository {

	public List<Farmlog> getFarmlogs();

	public Farmlog getFarmlogById(int id);

	void writeFarmlog(@Param("loginedMemberId") int loginedMemberId, @Param("cropVarietyDbId") Integer cropVarietyDbId,
			@Param("work_type_name") String work_type_name, @Param("agrochemical_name") String agrochemical_name,
			@Param("work_date") String work_date, @Param("nextSchedule") String nextSchedule,
			@Param("work_memo") String work_memo, @Param("img_file_name") String imgFileName, // 명시
			@Param("isPublic") int isPublic);
	// ✅ 추가됨

	public int getLastInsertId();

	public List<Map<String, Object>> getAllCropVarieties();

	public void insertFarmlog(int member_id, int crop_variety_id, String workType, String activityType,
			String cropCategory, String nextSchedule, String work_date, String work_memo, String img_file_name);

	List<Farmlog> findByMemberId(int memberId);

	// Farmlog 삭제
	void deleteFarmlog(@Param("id") int id);

	public void modify(int id, int crop_variety_id, String work_type_name, String work_date, String nextSchedule,
			String work_memo, String img_file_name);

	// 공개게시판 + 아이디, 품목, 품종 전용 검색
	List<Farmlog> findPublicLogs(@Param("writerName") String writerName, @Param("cropName") String cropName,
			@Param("varietyName") String varietyName);

	// 검색기능
	int getFarmlogCount(String searchKeywordTypeCode, String searchKeyword);

	List<Farmlog> getForPrintFarmlogs(int limit, int offset, String searchKeywordTypeCode, String searchKeyword);

	List<Farmlog> findPublicLogsUnified(@Param("searchType") String searchType,
			@Param("searchKeyword") String searchKeyword);

}