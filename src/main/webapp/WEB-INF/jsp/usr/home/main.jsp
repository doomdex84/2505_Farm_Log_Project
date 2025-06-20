<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../common/head.jspf"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Calendar Page</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.5/js/lightbox.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/index.global.min.js"></script>
<script src="https://unpkg.com/@popperjs/core@2"></script>
<script src="https://unpkg.com/tippy.js@6"></script>
<link rel="stylesheet" href="https://unpkg.com/tippy.js@6/themes/light.css" />

<!-- ✅ 카카오 API (아래 YOUR_KAKAO_APP_KEY 부분에 실제 카카오 앱 키 삽입) -->
<!-- <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_APP_KEY&libraries=services"></script>
 -->
<style>
.fc-event {
	transition: border 0.2s ease;
}

.today-work-alert {
	z-index: 30;
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	background-color: rgba(255, 255, 255, 0.95);
	color: #000000;
	font-weight: bold;
	padding: 1.2rem 2.4rem;
	border-radius: 0.75rem;
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
	border: 2px solid #ccc;
	font-size: 1.4rem;
	text-align: center;
}
</style>
</head>
<body class="bg-white">

	<main class="w-full min-h-screen">
		<section class="relative w-full h-[300px]">
			<img
				src="https://images.unsplash.com/photo-1621459555843-9a77f1d03fae?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=60"
				class="object-cover w-full h-full" alt="Summer Farm">
			<div class="today-work-alert">
				<c:set var="todayDate" value="<%=java.time.LocalDate.now().toString()%>" />
				<c:set var="workedList" value="" />
				<c:set var="plannedList" value="" />
				<c:forEach var="log" items="${farmlogs}">
					<c:if test="${log.work_date eq todayDate}">
						<c:set var="workedList" value="${workedList}${log.cropName} - ${log.varietyName}, " />
					</c:if>
					<c:if test="${log.nextSchedule eq todayDate}">
						<c:set var="plannedList" value="${plannedList}${log.cropName} - ${log.varietyName}, " />
					</c:if>
				</c:forEach>
				🌱 오늘 작업은
				<c:choose>
					<c:when test="${fn:length(workedList) > 2}">
						<span style="color: red;">${fn:substring(workedList, 0, fn:length(workedList)-2)}</span> 입니다.
				</c:when>
					<c:otherwise>
						<span style="color: red;">없습니다.</span>
					</c:otherwise>
				</c:choose>
				<br />
				🌟 오늘 예정 작업은
				<c:choose>
					<c:when test="${fn:length(plannedList) > 2}">
						<span style="color: red;">${fn:substring(plannedList, 0, fn:length(plannedList)-2)}</span> 입니다.
				</c:when>
					<c:otherwise>
						<span style="color: red;">없습니다.</span>
					</c:otherwise>
				</c:choose>
			</div>
		</section>

		<!-- 날씨 관련 -->
		<div class="max-w-5xl mx-auto">
			<div class="rounded-lg p-4 shadow flex justify-between items-start" style="background-color: #2785d7; color: black;">

				<!-- 왼쪽: 날씨 정보 -->
				<div>
					<h1 class="text-xl font-bold mb-3">
						<i class="fas fa-sun text-yellow-300"></i>
						오늘의 날씨
					</h1>
					<div id="locationInfo" class="mb-2">
						📍
						<span>현재 위치:</span>
						<span id="address">불러오는 중...</span>
					</div>
					<div id="currentTimeInfo" class="mb-4">
						⏰
						<span>현재 시간:</span>
						<span id="currentTime">-</span>
					</div>
					<div id="weatherInfo" class="flex gap-2 flex-wrap">
						<div class="border rounded-lg px-3 py-2 shadow-sm bg-white text-black">
							🌡
							<span>온도:</span>
							<span id="temp">-</span>
							℃
						</div>
						<div class="border rounded-lg px-3 py-2 shadow-sm bg-white text-black">
							☁
							<span>상태:</span>
							<span id="desc">-</span>
						</div>
						<div class="border rounded-lg px-3 py-2 shadow-sm bg-white text-black">
							💧
							<span>습도:</span>
							<span id="humidity">-</span>
							%
						</div>
					</div>
				</div>

				<!-- 오른쪽: 알림글 -->
				<div class="ml-4 bg-white text-black rounded-lg p-3 shadow max-w-xs break-words">
					<h2 class="font-semibold mb-2">🌾 농업 알림</h2>
					<div id="agriAlert">
						오늘은 비가 오니
						<strong>물빠짐 관리</strong>
						에 유의하세요.
					</div>
				</div>

			</div>
		</div>




		<section class="max-w-5xl mx-auto mt-10 pb-32">
			<div id="calendar"></div>
		</section>
	</main>

	<script>
document.addEventListener('DOMContentLoaded', function() {
	const calendarEl = document.getElementById('calendar');
	const calendar = new FullCalendar.Calendar(calendarEl, {
		headerToolbar: { left: 'prev,next today', center: 'title', right: 'dayGridMonth,dayGridWeek,dayGridDay' },
		selectable: true,
		navLinks: true,
		dayMaxEvents: true,
		dateClick: function(info) {
			const clickedDate = info.dateStr;
			const isLogined = ${rq.getLoginedMemberId() != 0};
			if (!isLogined) {
				alert("로그인이 필요합니다. 로그인 후 다시 시도해주세요.");
				return;
			}
			window.location.href = '/usr/farmlog/write?date=' + clickedDate;
		},
		events: [
			<c:forEach var="log" items="${farmlogs}" varStatus="status">
			{
				title: '📌 [작업] ${log.cropName} - ${log.varietyName}',
				start: '${log.work_date}',
				url: '/usr/farmlog/detail?id=${log.id}&from=/usr/home/main',
				extendedProps: {
					nextSchedule: '${log.nextSchedule != null ? log.nextSchedule : ""}',
					parentWorkDate: '${log.work_date}'
				}
			}
			<c:if test="${not empty log.nextSchedule}">,{
				title: '🌟 [다음일정] ${log.cropName} - ${log.varietyName}',
				start: '${log.nextSchedule}',
				url: '/usr/farmlog/detail?id=${log.id}',
				color: '#EF4444',
				extendedProps: {
					parentWorkDate: '${log.work_date}'
				}
			}</c:if>
			<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		],
		eventDidMount: function(info) {
			let tooltipText = info.event.title;
			if (info.event.extendedProps.nextSchedule) {
				tooltipText += "<br>🌟 다음 일정: " + info.event.extendedProps.nextSchedule;
			}
			if (info.event.extendedProps.parentWorkDate) {
				tooltipText += "<br>📌 작업일: " + info.event.extendedProps.parentWorkDate;
			}
			tippy(info.el, {
				content: tooltipText,
				theme: 'light',
				placement: 'top',
				appendTo: document.body,
				allowHTML: true
			});
		}
	});
	calendar.render();
});
</script>


	<!-- 날씨불러오기 -->

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
