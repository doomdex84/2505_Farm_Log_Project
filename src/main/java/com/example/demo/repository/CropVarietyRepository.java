package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.CropVariety;

@Mapper
public interface CropVarietyRepository {
	List<CropVariety> findByCropId(int cropId);
}
