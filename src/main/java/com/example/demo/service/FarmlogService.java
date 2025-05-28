package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.ArticleRepository;
import com.example.demo.repository.FarmlogRepository;
import com.example.demo.vo.Article;
import com.example.demo.vo.Farmlog;

@Service
public class FarmlogService {

	@Autowired
	private FarmlogRepository farmlogRepository;

	public FarmlogService(FarmlogRepository farmlogRepository) {
		this.farmlogRepository = farmlogRepository;
	}

	public List<Farmlog> getFarmlogs() {
		return farmlogRepository.getFarmlogs();
	}
	
	
	public static List<Farmlog> getFarmlogs(int id, int member_id, int crop_variety_id, int work_type_id,
			int agrochemical_id, String work_date, String work_memo) {

		return FarmlogRepository.getFarmlogs(id, member_id, crop_variety_id, work_type_id, agrochemical_id, work_date,
				work_memo);
	}

}
