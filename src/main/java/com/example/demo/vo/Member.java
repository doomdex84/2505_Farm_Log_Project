package com.example.demo.vo;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Member {

	private int id;
	private LocalDateTime regDate;
	private LocalDateTime updateDate;
	private String loginId;
	private String loginPw;
	private String name;
	private String nickname;
	private String cellphoneNum;
	private String email;
	private boolean delStatus;
	private LocalDateTime delDate;
	private int authLevel;

	// 주소 관련 필요한 필드만
	private String postcode; // 우편번호
	private String roadAddress; // 도로명 주소
	private String jibunAddress; // 지번 주소
	private String detailAddress; // 상세 주소
	private String extraAddress; // 참고항목
}