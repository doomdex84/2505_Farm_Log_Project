package com.example.demo.util;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class WorkTypeScheduleMap {

	// 외부에서 수정 못하게 불변 맵으로 제공
	public static final Map<String, Integer> MAP;

	static {
		Map<String, Integer> temp = new HashMap<>();

		// ✅ 세부 작업유형
		temp.put("살균제 살포", 7);
		temp.put("살충제 살포", 10);
		temp.put("제초제 살포", 15);
		temp.put("스프링클러 관수", 1);
		temp.put("드립관수", 1);
		temp.put("물조리개 관수", 2);
		temp.put("기비", 30);
		temp.put("추비", 20);
		temp.put("엽면시비", 15);
		temp.put("끈끈이트랩 설치", 10);
		temp.put("유인포 설치", 10);
		temp.put("해충 포획", 5);
		temp.put("예초기 제초", 20);
		temp.put("손제초", 15);
		temp.put("직파", 60);
		temp.put("육묘상 파종", 30);
		temp.put("모종 정식", 60);
		temp.put("줄파기 이식", 60);

		// ✅ 상위 카테고리 작업유형 추가
		temp.put("농약사용", 10);
		temp.put("관수작업", 1);
		temp.put("시비작업", 20);
		temp.put("방제작업", 10);
		temp.put("제초작업", 15);
		temp.put("파종작업", 30);
		temp.put("정식작업", 60);

		MAP = Collections.unmodifiableMap(temp);
	}

	private WorkTypeScheduleMap() {
		// 생성 못 하게 막기
	}
}
