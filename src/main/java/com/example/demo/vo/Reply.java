package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Reply {

	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private int boardId;
	private String body;
	private String relTypeCode;
	private int relId;
	private int hitCount;
	private int goodReactionPoint;
	private int badReactionPoint;
	private String reply;
	
	private String extra__writer;

	private String extra__sumReactionPoint;

	private boolean userCanModify;
	private boolean userCanDelete;
}