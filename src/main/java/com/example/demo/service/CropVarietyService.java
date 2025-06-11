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

	public List<Map<String, Object>> getAllCropVarietiesWithCategoryAndName() {
		String sql = """
				    SELECT
				        v.id AS cropVarietyId,     -- ✅ JSP에서 사용할 ID
				        v.variety_name AS variety, -- ✅ 품종 이름
				        c.crop_name,
				        c.category
				    FROM crop_variety v
				    JOIN crop c ON v.crop_code = c.crop_code
				    ORDER BY c.category, c.crop_name;
				""";
		return jdbcTemplate.queryForList(sql);
	}

	public Integer getCropVarietyIdByName(String variety) {
		return cropVarietyRepository.getIdByVarietyName(variety);
	}

}