package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ArticleService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.ResultData;

@Controller
public class UsrArticleController {

	@Autowired
	private ArticleService articleService;

	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public ResultData doModify(int id, String title, String body) {

		System.out.println("id: " + id);
		System.out.println("title : " + title);
		System.out.println("body : " + body);

		Article article = articleService.getArticleById(id);

		if (article == null) {
			return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다", id));
		}

		articleService.modifyArticle(id, title, body);

		return ResultData.from("S-1", Ut.f("%d번 게시글을 수정하였습니다.", id), article);
	}

	@RequestMapping("/usr/article/getArticle")
	@ResponseBody
	public ResultData getArticle(int id) {

		Article article = articleService.getArticleById(id);

		if (article == null) {
			return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다", id));
		}

		return ResultData.from("S-1", Ut.f("%d번 게시글입니다", id), article);
	}

	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public ResultData doDelete(int id) {

		Article article = articleService.getArticleById(id);

		if (article == null) {
			return ResultData.from("F-1", Ut.f("%d번 글은 없음", id));
			
		}

		articleService.deleteArticle(id);

		return ResultData.from("S-1", Ut.f("%d번 글이 삭제되었습니다", id), article);
		
	}

	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	public ResultData doWrite(String title, String body) {
		return ResultData.from("S-1", articleService.writeArticle(title, body));
		
	}

	@RequestMapping("/usr/article/getArticles")
	@ResponseBody
	public ResultData getArticles() {
		
		return ResultData.from("S-1",articleService.getArticles());
		
	}
}




