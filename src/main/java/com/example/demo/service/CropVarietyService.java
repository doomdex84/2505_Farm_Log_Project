package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.CropVarietyRepository;
import com.example.demo.vo.CropVariety;

@Service
public class CropVarietyService {

	@Autowired
	private CropVarietyRepository cropVarietyRepository;

	// cropId에 따른 품종 목록 반환
	public List<CropVariety> getByCropId(int cropId) {
		return cropVarietyRepository.findByCropId(cropId);
	}

}
