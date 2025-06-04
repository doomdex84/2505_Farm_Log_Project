package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.repository.CropRepository;
import com.example.demo.repository.CropVarietyRepository;
import com.example.demo.vo.CropVariety;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class CropApiService {

	@Autowired
	private CropRepository cropRepository;

	@Autowired
	private CropVarietyRepository cropVarietyRepository;

	public void fetchAndSaveCropData() {
		String apiUrl = "";

		try {
			RestTemplate restTemplate = new RestTemplate();
			ResponseEntity<String> response = restTemplate.getForEntity(apiUrl, String.class);

			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode root = objectMapper.readTree(response.getBody());
			JsonNode dataList = root.path("data");

			for (JsonNode item : dataList) {
				String categoryCode = item.path("품목코드").asText();
				String categoryName = item.path("품목명").asText();
				String cropCode = item.path("작물코드").asText();
				String cropName = item.path("작물명").asText();
				String varietyCode = item.path("품종코드").asText();
				String varietyName = item.path("품종명").asText();

				// crop 저장
				cropRepository.insertIgnoreDuplicate(categoryCode, categoryName, cropCode, cropName);

				// crop_variety 저장
				cropVarietyRepository.insertIgnoreDuplicate(cropCode, varietyCode, varietyName);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}