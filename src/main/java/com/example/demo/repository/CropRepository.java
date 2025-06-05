package com.example.demo.repository;

import java.util.List;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.vo.CropVariety;

@Repository
@Mapper
public interface CropRepository {

	List<Map<String, Object>> getAllCropVarietiesWithCategoryAndName();

}
