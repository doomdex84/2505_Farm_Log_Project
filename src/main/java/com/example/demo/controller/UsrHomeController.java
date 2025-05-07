package com.example.demo.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Controller
public class UsrHomeController {
	

	@RequestMapping("/usr/home/getArticle")
	@ResponseBody
	public Article getArticle() {

		Article article = new Article(1, "제목1", "내용1");

		return article;
	}

	@RequestMapping("/usr/home/getList")
	@ResponseBody
	public List<String> getList() {
		List<String> list = new ArrayList<>();
		list.add("철수 나이");
		list.add("영수 나이");

		return list;
	}

	@RequestMapping("/usr/home/getMap")
	@ResponseBody
	public Map<String, Object> getMap() {
		Map<String, Object> map = new HashMap<>();
		map.put("철수 나이", 11);
		map.put("영수 나이", 12);

		return map;
	}

	@RequestMapping("/usr/home/getDouble")
	@ResponseBody
	public double getDouble() {

		return 3.14;
	}

	@RequestMapping("/usr/home/getBoolean")
	@ResponseBody
	public boolean getBoolean() {

		return true;
	}

	@RequestMapping("/usr/home/getString")
	@ResponseBody
	public String getString() {



		return "abc";
	}

	@RequestMapping("/usr/home/getInt")
	@ResponseBody
	public int getInt() {

		return 1;
	}

	
	
	private int count;

	public UsrHomeController() {
		count = 0;
	}

	@RequestMapping("/usr/home/setCountValue")
	@ResponseBody
	public String setCountValue(int value) {
		this.count = value;
		return "count 값 " + value + "(으)로 초기화";
	}

	@RequestMapping("/usr/home/setCount")
	@ResponseBody
	public String setCount() {
		count = 0;
		return "count 값 0으로 초기화";
	}

	@RequestMapping("/usr/home/getCount")
	@ResponseBody
	public int getCount() {
		return count++;
	}
	
	@RequestMapping("/usr/home/main")
	@ResponseBody
	public String showMain() {
		return "안녕하세요";
	}
	
	
	@RequestMapping("/usr/home/main2")
	@ResponseBody
	public String showMain2() {
		return "잘가";
	}
	
	
	@RequestMapping("/usr/home/main3")
	@ResponseBody
	public int showMain3() {
		int a = 1;
		int b = 2;
		
		return a+b;
	}
	
	
	
}



@Data
@AllArgsConstructor
@NoArgsConstructor
class Article {


	int id;
	String title;
	String body;
}