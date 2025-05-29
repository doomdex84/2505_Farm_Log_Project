package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CropVariety {

	private int id;
	private String regDate;
	private String updateDate;

	private int cropId; // 품목 ID
	private String name; // 품종 이름
	private String description; // 설명

	// 확장 필드 (예시: 품목 이름 같이 JOIN한 경우)
	private String extra__cropName;
}
