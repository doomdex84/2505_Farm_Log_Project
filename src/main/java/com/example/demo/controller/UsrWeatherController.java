
package com.example.demo.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class UsrWeatherController {

	// 날씨 + 카카오(지역호출) API
	@GetMapping("/usr/api/weather")
	@ResponseBody
	public Map<String, Object> getWeatherAndLocation(@RequestParam double lat, @RequestParam double lon) {
		String apiKey = "";
		String kakaoKey = "";

		Map<String, Object> resultMap = new LinkedHashMap<>();

		// 1️⃣ OpenWeather 호출
		try {
			String weatherUrl = String.format(
					"https://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=%s&units=metric&lang=kr", lat,
					lon, apiKey);

			URL url = new URL(weatherUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			br.close();

			ObjectMapper mapper = new ObjectMapper();
			Map<String, Object> weatherData = mapper.readValue(sb.toString(), Map.class);
			resultMap.put("weather", weatherData);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultCode", "F-1");
			resultMap.put("msg", "날씨 API 호출 실패");
			return resultMap;
		}

		// 2️⃣ Kakao API 호출
		try {
			String kakaoUrl = String.format("https://dapi.kakao.com/v2/local/geo/coord2address.json?x=%f&y=%f", lon,
					lat);

			URL url = new URL(kakaoUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Authorization", "KakaoAK " + kakaoKey);

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			br.close();

			ObjectMapper mapper = new ObjectMapper();
			Map<String, Object> locationData = mapper.readValue(sb.toString(), Map.class);
			resultMap.put("location", locationData);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("location", Map.of("resultCode", "F-1", "msg", "카카오 API 호출 실패"));
		}

		resultMap.put("resultCode", "S-1");
		resultMap.put("msg", "성공");
		return resultMap;
	}
}