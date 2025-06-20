<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>현재 위치 및 날씨 정보</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.main-box {
	border: 2px solid #4CAF50;
	padding: 15px;
	border-radius: 10px;
	max-width: 500px;
	margin: 20px auto;
	font-size: 18px;
	background-color: #f9f9f9;
	font-weight: bold;
}

h1 {
	text-align: center;
	color: #4CAF50;
	font-weight: bold;
}
</style>
</head>
<body>
	<h1>🌤 오늘의 날씨</h1>

	<div class="main-box">
		<div id="locationInfo">
			📍
			<span>현재 위치:</span>
			<span id="address">불러오는 중...</span>
		</div>

		<div id="currentTimeInfo" style="margin-top: 10px;">
			⏰
			<span>현재 시간:</span>
			<span id="currentTime">-</span>
		</div>

		<div id="weatherInfo" style="margin-top: 10px;">
			🌡
			<span>온도:</span>
			<span id="temp">-</span>
			℃
			<br>
			☁
			<span>상태:</span>
			<span id="desc">-</span>
			<br>
			💧
			<span>습도:</span>
			<span id="humidity">-</span>
			%
		</div>
	</div>

	<script>
    $(document).ready(function() {
        updateCurrentTime();

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                const lat = position.coords.latitude;
                const lon = position.coords.longitude;
                console.log(`위치 좌표: ${lat} ${lon}`);

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

    function updateCurrentTime() {
        const now = new Date();
        const formatted = now.getFullYear() + "-" 
            + String(now.getMonth() + 1).padStart(2, '0') + "-" 
            + String(now.getDate()).padStart(2, '0') + " "
            + String(now.getHours()).padStart(2, '0') + ":" 
            + String(now.getMinutes()).padStart(2, '0');
        $('#currentTime').text(formatted);
        console.log("✅ 현재 시간:", formatted);
    }

    function updateWeatherAndLocation(data) {
        if (data.location && data.location.documents && data.location.documents.length > 0) {
            const addr = data.location.documents[0].address.address_name;
            $('#address').text(addr);
        } else {
            $('#address').text('카카오 API 주소 불러오기 실패');
        }

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
