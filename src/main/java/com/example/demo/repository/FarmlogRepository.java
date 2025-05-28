package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Farmlog;

@Mapper
public interface FarmlogRepository {

	public static List<Farmlog> getFarmlogs(int id, int member_id, int crop_variety_id, int work_type_id,
			int agrochemical_id, String work_date, String work_memo) {
		
		return null;
	}

	public List<Farmlog> getFarmlogs();

}
