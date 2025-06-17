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

<!-- Tailwind -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- FontAwesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<!-- Lightbox -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.5/css/lightbox.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.5/js/lightbox.min.js"></script>

<!-- FullCalendar -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/index.global.min.js"></script>

<!-- tippy.js -->
<script src="https://unpkg.com/@popperjs/core@2"></script>
<script src="https://unpkg.com/tippy.js@6"></script>
<link rel="stylesheet" href="https://unpkg.com/tippy.js@6/themes/light.css" />

<style>
.fc-event {
	transition: border 0.2s ease;
}
</style>
</head>

<body class="bg-white">

	<main class="w-full min-h-screen">
		<section class="relative w-full h-[300px]">
			<img
				src="https://images.unsplash.com/photo-1621459555843-9a77f1d03fae?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=60"
				class="object-cover w-full h-full" alt="Summer Farm">
		</section>

		<section class="max-w-5xl mx-auto mt-10 pb-32">
			<!-- 하단 여백 추가 -->
			<div id="calendar"></div>
		</section>
	</main>

	<script>
document.addEventListener('DOMContentLoaded', function() {
  var calendarEl = document.getElementById('calendar');
  var calendar = new FullCalendar.Calendar(calendarEl, {
    headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,dayGridWeek,dayGridDay'
    },
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
          url: '/usr/farmlog/detail?id=${log.id}',
          extendedProps: {
            nextSchedule: '${log.nextSchedule != null ? log.nextSchedule : ""}'
          }
        }
        <c:if test="${not empty log.nextSchedule}">
        ,{
          title: '🌟 [다음일정] ${log.cropName} - ${log.varietyName}',
          start: '${log.nextSchedule}',
          url: '/usr/farmlog/detail?id=${log.id}',
          color: '#EF4444',
          extendedProps: {
            parentWorkDate: '${log.work_date != null ? log.work_date : ""}'
          }
        }
        </c:if>
        <c:if test="${!status.last}">,</c:if>
      </c:forEach>
    ],
    eventDidMount: function(info) {
      const nextDate = info.event.extendedProps.nextSchedule;
      const parentDate = info.event.extendedProps.parentWorkDate;
      let tooltipText = '';

      if (nextDate && nextDate !== 'null' && nextDate.trim() !== '') {
        tooltipText = nextDate;
      } else if (parentDate && parentDate !== 'null' && parentDate.trim() !== '') {
        tooltipText = parentDate;
      } else {
        tooltipText = '다음작업예정일 없음';
      }

      tippy(info.el, {
        content: tooltipText,
        theme: 'light',
        placement: 'top'
      });
    }
  });
  calendar.render();
});
</script>

</body>
</html>
