<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>현재 위치 및 날씨 정보</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>














</head>
<body>
	<h1>📌 현재 위치 및 날씨 정보</h1>

	<div id="locationInfo">
		📍 현재 위치:
		<span id="address">불러오는 중...</span>
	</div>
	<div id="weatherInfo">
		🌡 온도:
		<span id="temp">-</span>
		℃
		<br>
		☁ 상태:
		<span id="desc">-</span>
		<br>
		💧 습도:
		<span id="humidity">-</span>
		%
	</div>

	<script>
    $(document).ready(function() {
        // 위치 가져오기
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                const lat = position.coords.latitude;
                const lon = position.coords.longitude;
                console.log(`위치 좌표: ${lat} ${lon}`);

















                // 서버 API 호출
                $.ajax({
                    url: "/usr/api/weather",
                    method: "GET",
                    data: { lat: lat, lon: lon },
                    success: function(data) {
                        console.log("✅ API 응답 데이터:", data);
                        updateWeatherAndLocation(data);
                    },
                    error: function(xhr, status, error) {
                        console.error("❌ 서버 호출 실패", error);
                        $('#address').text('위치 불러오기 실패');







                    }
                });
            }, function(error) {
                console.error("❌ 위치 가져오기 실패", error);
                $('#address').text('위치 접근 권한 없음');


            });
        } else {
            $('#address').text('브라우저에서 위치 지원 안됨');
        }
    });

    function updateWeatherAndLocation(data) {
        // 📍 위치
        if (data.location && data.location.documents && data.location.documents.length > 0) {
            const addr = data.location.documents[0].address.address_name;
            $('#address').text(addr);
        } else {
            $('#address').text('카카오 API 주소 불러오기 실패');
        }




        // 🌡 날씨
        if (data.weather && data.weather.list && data.weather.list.length > 0) {
            const first = data.weather.list[0];
            $('#temp').text(first.main.temp);
            $('#desc').text(first.weather[0]?.description || '정보 없음');
            $('#humidity').text(first.main.humidity);
        } else {
            $('#weatherInfo').append('<br>❌ 날씨 정보 없음');
        }
    }
    </script>
</body>
</html>