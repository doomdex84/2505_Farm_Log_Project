<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<title>날씨 API 테스트</title>
</head>
<body>
	<h2>📍 현재 위치 기준 날씨 정보</h2>
	<p id="weather-info">날씨 정보를 불러오는 중...</p>

	<script>
        navigator.geolocation.getCurrentPosition(
            function(position) {
                const lat = position.coords.latitude;
                const lon = position.coords.longitude;

                fetch(`/usr/api/weather?lat=${lat}&lon=${lon}`)
                    .then(res => res.text())
                    .then(data => {
                        document.getElementById("weather-info").innerText = data;
                    })
                    .catch(() => {
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
