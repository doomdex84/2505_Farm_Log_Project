package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.example.demo.repository.CropVarietyRepository;
import com.example.demo.vo.CropVariety;

@Service
public class CropVarietyService {

	@Autowired
	private CropVarietyRepository cropVarietyRepository;

	@Autowired
	private JdbcTemplate jdbcTemplate;

	// cropId에 따른 품종 목록 반환
	public List<CropVariety> getByCropId(int cropId) {
		return cropVarietyRepository.findByCropId(cropId);
	}

	public List<Map<String, Object>> getAllCropVarieties() {
		String sql = "SELECT category, crop_name, variety FROM crop_variety ORDER BY category, crop_name";
		return jdbcTemplate.queryForList(sql);
	}

	public Integer getCropVarietyIdByName(String variety) {
		return cropVarietyRepository.getIdByVarietyName(variety);
	}

}