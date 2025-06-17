package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Article;

@Mapper

public interface ArticleRepository {
	// 게시글 작성
	public int writeArticle(int memberId, String title, String body, String boardId);

	// 게시글 삭제
	public void deleteArticle(int id);

	// 게시글 수정
	public void modifyArticle(int id, String title, String body);

	// 최근 등록된 ID 조회
	public int getLastInsertId();

	// 단건 조회
	public Article getArticleById(int id);

	// 전체 리스트 조회
	public List<Article> getArticles();

	// 상세 조회 (수정/삭제 권한 포함용)
	public Article getForPrintArticle(int loginedMemberId); // ❗ 이 부분 id가 아니라 loginedMemberId로 되어있음 (보통 id로 조회)

	// 목록 조회 (조건 + 페이징)
	public List<Article> getForPrintArticles(int boardId, int limitFrom, int limitTake, String searchKeywordTypeCode,
			String searchKeyword);

	// 게시글 개수 조회
	public int getArticleCount(int boardId, String searchKeywordTypeCode, String searchKeyword);

	// 조회수 증가
	public int increaseHitCount(int id);

	// 조회수 가져오기
	public int getArticleHitCount(int id);

	// 좋아요/싫어요 증가/감소
	public int increaseGoodReactionPoint(int relId);

	public int decreaseGoodReactionPoint(int relId);

	public int increaseBadReactionPoint(int relId);

	public int decreaseBadReactionPoint(int relId);

	// 좋아요/싫어요 수 가져오기
	public int getGoodRP(int relId);

	public int getBadRP(int relId);

	// ❗ reply 관련 (Article repository에서 reply 조회는 어색)
	public Article getForPrintReply(int id);

	List<Article> getLatestNotices(int boardId);

}
