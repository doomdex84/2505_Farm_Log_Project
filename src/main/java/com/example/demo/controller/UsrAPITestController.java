package com.example.demo.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UsrAPITestController {

	@RequestMapping("/usr/home/APITest")
	public String showAPITest() {
		return "/usr/home/APITest";
	}

	@RequestMapping("/usr/home/APITest2")
	public String showAPITest2() {
		return "/usr/home/APITest2";
	}

	// 예: Spring Controller에서 서버 측에서 요청
	@RequestMapping("/weather")
	@ResponseBody
	public String getWeather() throws IOException {
		String apiUrl = "https://apihub.kma.go.kr/api/typ01/url/fct_shrt_reg.php?tmfc=0&authKey=...";
		HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
		BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		return reader.lines().collect(Collectors.joining());
	}

}
