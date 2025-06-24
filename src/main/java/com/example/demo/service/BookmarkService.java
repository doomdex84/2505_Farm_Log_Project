package com.example.demo.service;

import com.example.demo.repository.BookmarkRepository;
import com.example.demo.vo.Farmlog;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookmarkService {

	@Autowired
	private BookmarkRepository bookmarkRepository;

	public ResultData addBookmark(long memberId, long farmlogId) {
		if (bookmarkRepository.selectIsBookmark(memberId, farmlogId) > 0) {
			return ResultData.from("F-1", "이미 즐겨찾기 추가된 항목입니다.");
		}

		try {
			bookmarkRepository.insertBookmark(memberId, farmlogId);
			return ResultData.from("S-1", "즐겨찾기 추가 완료");
		} catch (Exception e) {
			System.err.println("북마크 추가 중 DB 오류: " + e.getMessage());
			return ResultData.from("F-2", "DB 오류로 즐겨찾기 추가 실패");
		}
	}

	public ResultData deleteBookmark(long memberId, long farmlogId) {
		if (bookmarkRepository.selectIsBookmark(memberId, farmlogId) == 0) {
			return ResultData.from("F-1", "즐겨찾기 항목이 아닙니다.");
		}

		bookmarkRepository.deleteBookmark(memberId, farmlogId);
		return ResultData.from("S-1", "즐겨찾기 삭제 완료");
	}

	public List<Farmlog> getBookmarkFarmlogsByMemberId(long memberId) {
		return bookmarkRepository.selectBookmarkFarmlogs(memberId);
	}
}
