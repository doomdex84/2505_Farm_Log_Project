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

	private boolean userCanModify;
	private boolean userCanDelete;
}