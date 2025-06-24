package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Article {

	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private int boardId;
	private String title;
	private String body;
	private int hitCount;
	private int goodReactionPoint;
	private int badReactionPoint;

	private String extra__writer;

	private String extra__repliesCount;

	private String extra__sumReactionPoint;

	private boolean userCanModify;
	private boolean userCanDelete;
	private int isSecret; // 관리자용

	private String tradeType; // 🆕 거래유형
	private int price; // 🆕 가격 (필요 시)
}