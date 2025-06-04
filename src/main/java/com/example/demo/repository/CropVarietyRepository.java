package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.CropVariety;

@Mapper
public interface CropVarietyRepository {
	List<CropVariety> findByCropId(int cropId);

	List<Map<String, Object>> findAllGrouped();

}
