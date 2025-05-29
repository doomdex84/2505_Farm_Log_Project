<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="weatherApi" />

<html>
<head>
<title>날씨 API 테스트</title>
</head>
<body>
	<h1>날씨 API 테스트 페이지입니다.</h1>

	<div id="weather-info">날씨를 불러오는 중...</div>


	<script>
navigator.geolocation.getCurrentPosition(
		  function(position) {
		    const lat = position.coords.latitude;
		    const lon = position.coords.longitude;

		    fetch(`/usr/api/weather/by-coord?lat=${lat}&lon=${lon}`)
		      .then(res => res.text())
		      .then(data => {
		        document.getElementById("weather-info").innerText = data;
		      })
		      .catch(err => {
		        document.getElementById("weather-info").innerText = "날씨 정보 호출 실패";
		      });
		  },
		  function(error) {
		    document.getElementById("weather-info").innerText = "위치 접근이 차단되었습니다.";
		  }
		);
</script>


</body>
</html>

<%@ include file="../common/head.jspf"%>
<%@ include file="../common/foot.jspf"%>