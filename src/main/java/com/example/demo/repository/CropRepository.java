package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface CropRepository {
	int insertIgnoreDuplicate(Map<String, Object> param);

	List<Map<String, Object>> selectJoinWithCropName();

	void insertIgnoreDuplicate(String categoryCode, String categoryName, String cropCode, String cropName);
}
