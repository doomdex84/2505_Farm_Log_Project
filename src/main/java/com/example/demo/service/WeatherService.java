package com.example.demo.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class WeatherService {

	// ⛔ 아래 API 키는 여러분의 실제 키로 바꿔야 합니다
	private final String KAKAO_API_KEY = "";
	private final String OPENWEATHER_API_KEY = "";

	public String getAddressFromKakao(double lat, double lon) {
		String url = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=" + lon + "&y=" + lat;
		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "KakaoAK " + KAKAO_API_KEY);
		HttpEntity<String> entity = new HttpEntity<>(headers);

		RestTemplate restTemplate = new RestTemplate();
		try {
			ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
			ObjectMapper mapper = new ObjectMapper();
			JsonNode root = mapper.readTree(response.getBody());
			return root.path("documents").get(0).path("address").path("address_name").asText();
		} catch (Exception e) {
			return "주소 변환 실패";
		}
	}

	public String getWeatherByCoord(double lat, double lon) {
		String url = "https://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&appid="
				+ OPENWEATHER_API_KEY + "&units=metric&lang=kr";

		RestTemplate restTemplate = new RestTemplate();
		try {
			String response = restTemplate.getForObject(url, String.class);
			ObjectMapper mapper = new ObjectMapper();
			JsonNode root = mapper.readTree(response);
			String desc = root.path("weather").get(0).path("description").asText();
			double temp = root.path("main").path("temp").asDouble();
			return String.format("현재 날씨는 '%s', 기온은 %.1f°C 입니다.", desc, temp);
		} catch (Exception e) {
			return "날씨 정보 오류";
		}
	}
}
