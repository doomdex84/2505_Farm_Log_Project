package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Favorite {
	private long id; // 즐겨찾기 PK
	private long memberId; // 회원 ID
	private long farmlogId; // 영농일지 ID
	private LocalDateTime regDate; // 등록일시
}
