package com.example.demo.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.example.demo.repository.CropRepository;
import com.example.demo.repository.CropVarietyRepository;
import com.example.demo.vo.CropVariety;

@Service
public class CropService {

	@Autowired
	private CropRepository cropRepository;

	public Map<String, List<String>> getGroupedCropNames() {
		List<Map<String, Object>> rows = cropRepository.getAllCropVarietiesWithCategoryAndName();

		Map<String, List<String>> map = new LinkedHashMap<>();
		for (Map<String, Object> row : rows) {
			String category = (String) row.get("category");
			String cropName = (String) row.get("crop_name");
			if (!map.containsKey(category)) {
				map.put(category, new ArrayList<>());
			}
			if (!map.get(category).contains(cropName)) {
				map.get(category).add(cropName);
			}
		}
		return map;
	}
}