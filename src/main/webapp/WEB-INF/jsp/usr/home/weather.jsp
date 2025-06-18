<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>현재 날씨 정보</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
body {
	font-family: sans-serif;
	padding: 20px;
}

#weatherInfo, #locationInfo {
	border: 1px solid #ccc;
	padding: 10px;
	border-radius: 8px;
	max-width: 500px;
	margin-bottom: 10px;
}
</style>
</head>
<body>

	<h1 class="text-xl font-bold mb-4">🌤 현재 날씨 정보</h1>

	<div id="locationInfo">위치를 불러오는 중입니다...</div>
	<div id="weatherInfo">날씨 데이터를 가져오는 중입니다...</div>

	<script>
$(document).ready(function() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const lat = position.coords.latitude;
            const lon = position.coords.longitude;
            console.log("위치 좌표:", lat, lon);

            // 서버에 위치 좌표 전달 → 날씨 + 카카오 주소 함께 받아오기
            $.ajax({
                url: '/usr/api/weather',
                method: 'GET',
                data: { lat: lat, lon: lon },
                success: function(data) {
                    console.log("API 응답:", data);

                    if (data.resultCode === "S-1") {
                        // 위치 출력
                        if (data.location && data.location.documents && data.location.documents.length > 0) {
                            const address = data.location.documents[0].address?.address_name ?? '알 수 없음';
                            $('#locationInfo').html(`📍 현재 위치: ${address}`);
                        } else {
                            $('#locationInfo').html('📍 위치 정보를 가져올 수 없습니다.');
                        }

                        // 날씨 출력
                        if (data.weather && Array.isArray(data.weather.list) && data.weather.list.length > 0) {
                            const weather = data.weather.list[0];
                            const temp = weather.main?.temp ?? 'N/A';
                            const desc = weather.weather?.[0]?.description ?? 'N/A';
                            const humidity = weather.main?.humidity ?? 'N/A';

                            $('#weatherInfo').html(
                                `<div>🌡 온도: ${temp}℃</div>
                                 <div>🌥 상태: ${desc}</div>
                                 <div>💧 습도: ${humidity}%</div>`
                            );
                        } else {
                            $('#weatherInfo').html('<div class="text-red-500">날씨 데이터를 가져올 수 없습니다.</div>');
                        }

                    } else {
                        $('#locationInfo').html('<div class="text-red-500">데이터를 가져올 수 없습니다.</div>');
                        $('#weatherInfo').html('<div class="text-red-500">데이터를 가져올 수 없습니다.</div>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("API 호출 실패:", error);
                    $('#locationInfo').html('<div class="text-red-500">API 호출 실패</div>');
                    $('#weatherInfo').html('<div class="text-red-500">API 호출 실패</div>');
                }
            });

        }, function(err) {
            console.error("위치 권한 에러:", err);
            $('#locationInfo').html('📍 위치 권한이 거부되었습니다.');
            $('#weatherInfo').html('날씨 데이터를 가져올 수 없습니다. (위치 정보 없음)');
        });
    } else {
        $('#locationInfo').html('📍 브라우저가 위치 정보를 지원하지 않습니다.');
        $('#weatherInfo').html('날씨 데이터를 가져올 수 없습니다.');
    }
});
</script>

</body>
</html>
