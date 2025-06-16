<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.5/css/lightbox.css"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.5/css/lightbox.min.css"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.5/css/lightbox.min.css">
<meta name="viewport" content="width=device-width, initial-scale=1">

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>

<c:set var="pageTitle" value=""></c:set>
<%@ include file="../common/head.jspf"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Calendar Page</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
.selected {
	background-color: #bfdbfe !important;
}
</style>
</head>

<body>
	<main class="relative w-full min-h-screen bg-white">
		<section class="relative w-full h-[517px] max-sm:h-[300px]">
			<img
				src="https://images.unsplash.com/photo-1621459555843-9a77f1d03fae?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=60"
				class="object-cover w-full h-full" alt="Summer Farm">
		</section>

		<section class="pb-8 mx-auto mt-20 shadow-sm w-[1295px] max-md:w-[90%] max-sm:w-[95%]">
			<div id="calendar" class="flex flex-wrap w-full"></div>
		</section>
	</main>

	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/index.global.min.js'></script>
	<script>
document.addEventListener('DOMContentLoaded', function() {
  var calendarEl = document.getElementById('calendar');
  var calendar = new FullCalendar.Calendar(calendarEl, {
    headerToolbar: {
      left: 'prevYear,prev,next,nextYear today',
      center: 'title',
      right: 'dayGridMonth,dayGridWeek,dayGridDay'
    },
    selectable: true,
    selectMirror: true,
    navLinks: true,
    editable: true,
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
    	      url: '/usr/farmlog/detail?id=${log.id}'
    	    }
    	    <c:if test="${not empty log.nextSchedule}">
    	    ,{
    	      title: '🌟 [다음일정] ${log.cropName} - ${log.varietyName}',
    	      start: '${log.nextSchedule}',
    	      url: '/usr/farmlog/detail?id=${log.id}',
    	      color: '#EF4444'  // Tailwind red-500
    	    }
    	    </c:if>
    	    <c:if test="${!status.last}">,</c:if>
    	  </c:forEach>
    	]
  });
  calendar.render();
});
</script>

	<script>
const isLogined = ${rq.getLoginedMemberId() != 0};
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".calendar-day").forEach(day => {
    day.addEventListener("click", function (e) {
      if (!isLogined) {
        alert("로그인이 필요합니다.");
        e.preventDefault();
        return;
      }
      const selectedDate = this.dataset.date;
      if (selectedDate) {
        location.href = `/usr/farmlog/write?date=${selectedDate}`;
      }
    });
  });
});
</script>

</body>
</html>
