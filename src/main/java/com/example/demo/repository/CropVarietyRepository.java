package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.CropVariety;

@Mapper
public interface CropVarietyRepository {
	List<CropVariety> findByCropId(int cropId);

	List<Map<String, Object>> findAllGrouped();

	Integer getIdByVarietyName(String variety);

	void insertCropVarietyStd(String string, String string2, String string3, String string4);

	void insertIgnoreDuplicate(String cropCode, String varietyCode, String varietyName);

	List<Map<String, String>> selectJoinWithCropName();

}
