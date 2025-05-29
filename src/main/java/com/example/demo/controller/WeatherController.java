package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.service.WeatherService;

@RestController
@RequestMapping("/usr/home/weatherApi")

public class WeatherController {

	@Autowired
	private WeatherService weatherService;

	@GetMapping // → /usr/api/weather?lat=...&lon=...
	public ResponseEntity<String> getWeather(@RequestParam double lat, @RequestParam double lon) {
		String address = weatherService.getAddressFromKakao(lat, lon);
		String weather = weatherService.getWeatherByCoord(lat, lon);
		return ResponseEntity.ok(address + " 기준 " + weather);
	}
}