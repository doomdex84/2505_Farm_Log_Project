package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Farmlog;

@Mapper
public interface FarmlogRepository {

	public List<Farmlog> getFarmlogs();

	public Farmlog getFarmlogById(int id);

}
