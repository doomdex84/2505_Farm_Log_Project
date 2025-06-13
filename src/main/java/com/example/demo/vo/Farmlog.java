package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Farmlog {

	private int id;
	private int member_id;
	private int crop_variety_id;
	private int work_type_id;
	private int agrochemical_id;
	private String work_date;
	private String work_memo;
	private String work_type_name;
	private boolean hasImage;// 이미지 첨부 여부를 알기 위해

	private boolean userCanModify;
	private boolean userCanDelete;

	// 디테일 페이지에 필요한 추가 필드

	private String cropName; // 품목명 (crop.crop_name)
	private String varietyName; // 품종명 (crop_variety.variety)
	private String weather; // 날씨
	private String nextSchedule; // 다음 일정
	private String imgFileName; // 이미지 파일명
	private String extrawriterName; // 작성자 닉네임 (member.nickname)
}
