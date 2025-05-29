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



}
