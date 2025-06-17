package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.ArticleRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.ResultData;

@Service
public class ArticleService {

	// ✅ Article 데이터베이스 작업을 수행하는 Repository
	@Autowired
	private ArticleRepository articleRepository;

	// ✅ 생성자 주입 (권장 방식 - @Autowired 대신 사용 가능)
	public ArticleService(ArticleRepository articleRepository) {
		this.articleRepository = articleRepository;
	}

	// ✅ 게시글 작성 처리
	public ResultData writeArticle(int memberId, String title, String body, String boardId) {
		articleRepository.writeArticle(memberId, title, body, boardId);
		int id = articleRepository.getLastInsertId();
		return ResultData.from("S-1", Ut.f("%d번 글이 등록되었습니다", id), "등록 된 게시글 id", id);
	}

	// ✅ 게시글 삭제 처리
	public void deleteArticle(int id) {
		articleRepository.deleteArticle(id);
	}

	// ✅ 게시글 수정 처리
	public void modifyArticle(int id, String title, String body) {
		articleRepository.modifyArticle(id, title, body);
	}

	// ✅ 게시글 수정 권한 체크 (일반 사용자용)
	public ResultData userCanModify(int loginedMemberId, Article article) {
		if (article.getMemberId() != loginedMemberId) {
			return ResultData.from("F-A", Ut.f("%d번 게시글에 대한 수정 권한 없음", article.getId()));
		}
		return ResultData.from("S-1", Ut.f("%d번 게시글 수정 가능", article.getId()));
	}

	// ✅ 게시글 삭제 권한 체크 (일반 사용자용)
	public ResultData userCanDelete(int loginedMemberId, Article article) {
		if (article.getMemberId() != loginedMemberId) {
			return ResultData.from("F-A", Ut.f("%d번 게시글에 대한 삭제 권한 없음", article.getId()));
		}
		return ResultData.from("S-1", Ut.f("%d번 게시글 삭제 가능", article.getId()));
	}

	// ✅ 게시글 수정 권한 체크 (관리자 포함)
	public ResultData userCanModify(int loginedMemberId, int authLevel, Article article) {
		if (authLevel >= 7) {
			return ResultData.from("S-1", Ut.f("관리자 권한으로 %d번 게시글 수정 가능", article.getId()));
		}
		if (article.getMemberId() != loginedMemberId) {
			return ResultData.from("F-A", Ut.f("%d번 게시글에 대한 수정 권한 없음", article.getId()));
		}
		return ResultData.from("S-1", Ut.f("%d번 게시글 수정 가능", article.getId()));
	}

	// ✅ 게시글 삭제 권한 체크 (관리자 포함)
	public ResultData userCanDelete(int loginedMemberId, int authLevel, Article article) {
		if (authLevel >= 7) {
			return ResultData.from("S-1", Ut.f("관리자 권한으로 %d번 게시글 삭제 가능", article.getId()));
		}
		if (article.getMemberId() != loginedMemberId) {
			return ResultData.from("F-A", Ut.f("%d번 게시글에 대한 삭제 권한 없음", article.getId()));
		}
		return ResultData.from("S-1", Ut.f("%d번 게시글 삭제 가능", article.getId()));
	}

	// ✅ 게시글 상세 조회 + 권한 정보 포함
	public Article getForPrintArticle(int loginedMemberId, int id) {
		Article article = articleRepository.getForPrintArticle(id);
		controlForPrintData(loginedMemberId, article);
		return article;
	}

	// ✅ 게시글 상세 조회 + 권한 정보 포함 (관리자 포함)
	public Article getForPrintArticle(int loginedMemberId, int authLevel, int id) {
		Article article = articleRepository.getForPrintArticle(id);
		controlForPrintData(loginedMemberId, authLevel, article);
		return article;
	}

	// ✅ 게시글의 수정/삭제 권한 여부 세팅 (일반 사용자용)
	private void controlForPrintData(int loginedMemberId, Article article) {
		if (article == null) {
			return;
		}
		ResultData userCanModifyRd = userCanModify(loginedMemberId, article);
		article.setUserCanModify(userCanModifyRd.isSuccess());
		ResultData userDeleteRd = userCanDelete(loginedMemberId, article);
		article.setUserCanDelete(userDeleteRd.isSuccess());
	}

	// ✅ 게시글의 수정/삭제 권한 여부 세팅 (관리자 포함)
	private void controlForPrintData(int loginedMemberId, int authLevel, Article article) {
		if (article == null) {
			return;
		}
		ResultData userCanModifyRd = userCanModify(loginedMemberId, authLevel, article);
		article.setUserCanModify(userCanModifyRd.isSuccess());
		ResultData userDeleteRd = userCanDelete(loginedMemberId, authLevel, article);
		article.setUserCanDelete(userDeleteRd.isSuccess());
	}

	// ✅ ID로 게시글 단건 조회
	public Article getArticleById(int id) {
		return articleRepository.getArticleById(id);
	}

	// ✅ 게시글 전체 리스트 조회
	public List<Article> getArticles() {
		return articleRepository.getArticles();
	}

	// ✅ 조건에 맞는 게시글 목록 조회 (페이징 + 검색)
	public List<Article> getForPrintArticles(int boardId, int itemsInAPage, int page, String searchKeywordTypeCode,
			String searchKeyword) {
		int limitFrom = (page - 1) * itemsInAPage;
		int limitTake = itemsInAPage;
		return articleRepository.getForPrintArticles(boardId, limitFrom, limitTake, searchKeywordTypeCode,
				searchKeyword);
	}

	// ✅ 조건에 맞는 게시글 수 조회
	public int getArticleCount(int boardId, String searchKeywordTypeCode, String searchKeyword) {
		return articleRepository.getArticleCount(boardId, searchKeywordTypeCode, searchKeyword);
	}

	// ✅ 게시글 조회수 증가
	public ResultData increaseHitCount(int id) {
		int affectedRow = articleRepository.increaseHitCount(id);
		if (affectedRow == 0) {
			return ResultData.from("F-1", "해당 게시글 없음", "id", id);
		}
		return ResultData.from("S-1", "조회수 증가", "id", id);
	}

	// ✅ 게시글 조회수 값 가져오기
	public Object getArticleHitCount(int id) {
		return articleRepository.getArticleHitCount(id);
	}

	// ✅ 좋아요 +1
	public ResultData increaseGoodReactionPoint(int relId) {
		int affectedRow = articleRepository.increaseGoodReactionPoint(relId);
		if (affectedRow == 0) {
			return ResultData.from("F-1", "없는 게시물");
		}
		return ResultData.from("S-1", "좋아요 증가", "affectedRow", affectedRow);
	}

	// ✅ 싫어요 +1
	public ResultData increaseBadReactionPoint(int relId) {
		int affectedRow = articleRepository.increaseBadReactionPoint(relId);
		if (affectedRow == 0) {
			return ResultData.from("F-1", "없는 게시물");
		}
		return ResultData.from("S-1", "싫어요 증가", "affectedRow", affectedRow);
	}

	// ✅ 좋아요 -1
	public ResultData decreaseGoodReactionPoint(int relId) {
		int affectedRow = articleRepository.decreaseGoodReactionPoint(relId);
		if (affectedRow == 0) {
			return ResultData.from("F-1", "없는 게시물");
		}
		return ResultData.from("S-1", "좋아요 감소", "affectedRow", affectedRow);
	}

	// ✅ 싫어요 -1
	public ResultData decreaseBadReactionPoint(int relId) {
		int affectedRow = articleRepository.decreaseBadReactionPoint(relId);
		if (affectedRow == 0) {
			return ResultData.from("F-1", "없는 게시물");
		}
		return ResultData.from("S-1", "싫어요 감소", "affectedRow", affectedRow);
	}

	// ✅ 좋아요 개수 조회
	public int getGoodRP(int relId) {
		return articleRepository.getGoodRP(relId);
	}

	// ✅ 싫어요 개수 조회
	public int getBadRP(int relId) {
		return articleRepository.getBadRP(relId);
	}

	// ✅ (미사용) FarmBoard용 글쓰기 stub
	public void writeArticle(int loginedMemberId, String title, String body, int farmBoardId) {
		// TODO: 필요시 구현
	}

	public List<Article> getLatestNotices() {
		int noticeBoardId = 1; // 공지사항 게시판 ID (DB에 맞게 설정)
		return articleRepository.getLatestNotices(noticeBoardId);
	}

}
