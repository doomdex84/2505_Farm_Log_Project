
package com.example.demo.service;

import com.example.demo.repository.FavoriteRepository;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FavoriteService {

	@Autowired
	private FavoriteRepository favoriteRepository;

	public ResultData addFavorite(long memberId, long farmlogId) {
		if (favoriteRepository.selectIsFavorite(memberId, farmlogId) > 0) {
			return ResultData.from("F-1", "이미 즐겨찾기 추가된 항목입니다.");
		}
		favoriteRepository.insertFavorite(memberId, farmlogId);
		return ResultData.from("S-1", "즐겨찾기 추가 완료");
	}

	public ResultData deleteFavorite(long memberId, long farmlogId) {
		if (favoriteRepository.selectIsFavorite(memberId, farmlogId) == 0) {
			return ResultData.from("F-1", "즐겨찾기 항목이 아닙니다.");
		}
		favoriteRepository.deleteFavorite(memberId, farmlogId);
		return ResultData.from("S-1", "즐겨찾기 삭제 완료");
	}

	public boolean checkIsFavorite(long memberId, long farmlogId) {
		return favoriteRepository.selectIsFavorite(memberId, farmlogId) > 0;
	}

	public List<Farmlog> getFavoriteFarmlogs(long memberId) {
		return favoriteRepository.selectFavoriteFarmlogs(memberId);
	}
}