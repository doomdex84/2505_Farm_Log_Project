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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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

		<!-- 📌 상단 이미지 및 오늘 작업 알림 -->
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
				🌱 오늘은
				<c:choose>
					<c:when test="${fn:length(workedList) > 2}">
						<span style="color: red;">${fn:substring(workedList, 0, fn:length(workedList)-2)}</span> 작업을 하였습니다.
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

		<!-- ☁ 날씨 및 농업 알림 -->
		<div class="max-w-5xl mx-auto mt-6">
			<div class="rounded-lg p-4 shadow flex justify-between items-start" style="background-color: #2785d7; color: black;">
				<!-- 왼쪽: 날씨 정보 -->
				<div>
					<h1 class="text-xl font-bold mb-3">
						<i class="fas fa-sun text-yellow-300"></i>
						오늘의 날씨
					</h1>
					<div class="mb-2">
						📍
						<span>현재 위치:</span>
						<span id="address">불러오는 중...</span>
					</div>
					<div class="mb-4">
						⏰
						<span>현재 시간:</span>
						<span id="currentTime">-</span>
					</div>
					<div id="weatherInfo" class="flex gap-2 flex-wrap">
						<div class="border rounded-lg px-3 py-2 shadow-sm bg-white text-black">
							🌡 온도:
							<span id="temp">-</span>
							℃
						</div>
						<div class="border rounded-lg px-3 py-2 shadow-sm bg-white text-black">
							☁ 상태:
							<span id="desc">-</span>
						</div>
						<div class="border rounded-lg px-3 py-2 shadow-sm bg-white text-black">
							💧 습도:
							<span id="humidity">-</span>
							%
						</div>
					</div>
				</div>
				<!-- 오른쪽: 농업 알림 -->
				<div class="ml-4 bg-white text-black rounded-lg p-3 shadow max-w-xs break-words">
					<h2 class="font-semibold mb-2">🌾 농업 알림</h2>
					<div id="agriAlert">-</div>
				</div>
			</div>
		</div>

		<!-- 📅 캘린더 -->
		<section class="max-w-5xl mx-auto mt-10 pb-32">
			<div id="calendar"></div>
		</section>

	</main>

	<!-- 📌 JS: FullCalendar + Tippy -->
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

	<!-- 📡 JS: 날씨 데이터 기반 고도화 알림 -->
	<script>
$(document).ready(function() {
	updateCurrentTime();

	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			const lat = position.coords.latitude;
			const lon = position.coords.longitude;

			$.ajax({
				url: "/usr/api/weather",
				method: "GET",
				data: { lat: lat, lon: lon },
				success: function(data) {
					updateWeatherAndLocation(data);
				},
				error: function() {
					$('#address').text('위치 불러오기 실패');
				}
			});
		}, function() {
			$('#address').text('위치 접근 권한 없음');
		});
	} else {
		$('#address').text('브라우저에서 위치 지원 안됨');
	}
});

function updateCurrentTime() {
	const now = new Date();
	const formatted = now.getFullYear() + "-" +
		String(now.getMonth() + 1).padStart(2, '0') + "-" +
		String(now.getDate()).padStart(2, '0') + " " +
		String(now.getHours()).padStart(2, '0') + ":" +
		String(now.getMinutes()).padStart(2, '0');
	$('#currentTime').text(formatted);
}

function updateWeatherAndLocation(data) {
	if (data.location && data.location.documents.length > 0) {
		$('#address').text(data.location.documents[0].address.address_name);
	} else {
		$('#address').text('카카오 API 주소 불러오기 실패');
	}

	if (data.weather && data.weather.list.length > 0) {
		const first = data.weather.list[0];
		const main = first.weather[0]?.main.toLowerCase();
		const desc = first.weather[0]?.description.toLowerCase();
		const temp = first.main.temp;
		const humidity = first.main.humidity;
		const rainVolume = first.rain?.['1h'] || 0;

		$('#temp').text(temp);
		$('#desc').text(desc);
		$('#humidity').text(humidity);

		let alert = '';

		if (main.includes('rain')) {
			if (rainVolume > 10) {
				alert = '⛈ 강한 비가 내리고 있습니다. <strong>배수로 정비 및 침수 대비</strong>가 필요합니다.';
			} else if (desc.includes('light')) {
				alert = '🌦 가벼운 비가 내려 <strong>파종/이식 작업</strong>에 적합할 수 있습니다.';
			} else {
				alert = '🌧 비가 내립니다. <strong>비닐하우스 점검 및 물빠짐 관리</strong>에 유의하세요.';
			}
		} else if (main.includes('snow')) {
			alert = '❄ 눈이 옵니다. <strong>비닐하우스 무게 점검</strong>과 <strong>가축 보온</strong>에 유의하세요.';
		} else if (desc.includes('thunderstorm')) {
			alert = '🌩 천둥·번개를 동반한 폭우가 예상됩니다. <strong>전기시설 점검</strong>과 <strong>작업 자제</strong>가 필요합니다.';
		} else if (temp >= 33) {
			alert = '🔥 폭염 주의! <strong>작물 고온 피해 예방</strong>을 위해 <strong>차광막 설치 및 관수 작업</strong>을 강화하세요.';
		} else if (temp <= -5) {
			alert = '🥶 한파 주의! <strong>작물 및 급수 시설의 동파 방지</strong>가 필요합니다.';
		} else if (humidity >= 90) {
			alert = '💧 습도가 매우 높습니다. <strong>곰팡이성 병해 예방 방제</strong>를 고려하세요.';
		} else if (main === 'clear') {
			alert = '☀ 맑은 날씨입니다. <strong>수확 작업이나 비닐 제거</strong>에 좋은 날입니다.';
		} else if (main === 'clouds') {
			alert = '⛅ 흐린 날씨입니다. <strong>광량 부족</strong>에 대비해 작물 상태를 점검하세요.';
		} else {
			alert = '🌤 날씨 정보를 참고하여 <strong>농작업 계획</strong>을 세워보세요.';
		}

		$('#agriAlert').html(alert);
	} else {
		$('#weatherInfo').append('<br>❌ 날씨 정보 없음');
		$('#agriAlert').html('⚠ 날씨 정보가 없어 농업 알림을 제공할 수 없습니다.');
	}
}
</script>

</body>
</html>
