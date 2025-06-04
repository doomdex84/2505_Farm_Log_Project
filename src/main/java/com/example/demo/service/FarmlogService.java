package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.ArticleRepository;
import com.example.demo.repository.FarmlogRepository;
import com.example.demo.vo.Article;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;

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

	public Farmlog getForPrintFarmlog(int loginedMemberId, int id) {
		// TODO Auto-generated method stub
		return null;
	}

	public ResultData writeFarmlog(int loginedMemberId, int crop_variety_id, int work_type_id, int agrochemical_id,
			String work_date, String work_memo) {

		return null;
	}

	public Farmlog getFarmlogById(int id) {

		return farmlogRepository.getFarmlogById(id);
	}

	public List<Farmlog> getForPrintFarmlogs(int id, int member_id, int crop_variety_id, int work_type_id,
			int agrochemical_id, String work_date, String work_memo) {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Map<String, Object>> getAllCropVarieties() {
		// TODO Auto-generated method stub
		return null;
	}

	public void writeArticle(int loginedMemberId, String string, String work_memo, int i) {
		// TODO Auto-generated method stub

	}

}
