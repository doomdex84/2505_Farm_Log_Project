package com.example.demo.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.CropVarietyService;
import com.example.demo.vo.CropVariety;

@Controller
public class UsrAPITestController {

	@Autowired
	private CropVarietyService cropVarietyService;

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

	@GetMapping("/api/crop-varieties")
	@ResponseBody
	public List<CropVariety> getVarieties(@RequestParam int cropId) {
		return cropVarietyService.getByCropId(cropId);
	}

	@GetMapping("/api/openapi-test")
	@ResponseBody
	public String getOpenApiSample() throws IOException {
		String apiUrl = "http://211.237.50.150:7080/openapi/sample/xml/Grid_20200114000000000604_1/1/5";

		URL url = new URL(apiUrl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");

		BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
		String response = in.lines().collect(Collectors.joining());
		in.close();

		return response;
	}

}
