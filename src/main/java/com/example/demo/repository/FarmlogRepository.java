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

	public void writeFarmlog(int loginedMemberId, Integer cropVarietyDbId, String work_type, String activity_type,
			String crop_category, String next_schedule, String work_date, String work_memo);

	public int getLastInsertId();

	public List<Map<String, Object>> getAllCropVarieties();

	void insertFarmlog(@Param("memberId") int memberId, @Param("cropVarietyId") int cropVarietyId,
			@Param("workType") String workType, @Param("activityType") String activityType,
			@Param("cropCategory") String cropCategory, @Param("nextSchedule") String nextSchedule,
			@Param("workDate") String workDate, @Param("workMemo") String workMemo);

}
