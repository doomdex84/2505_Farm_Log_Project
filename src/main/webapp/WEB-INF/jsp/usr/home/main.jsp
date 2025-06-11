<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.5/css/lightbox.css"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.5/css/lightbox.min.css"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.5/css/lightbox.min.css">
<!-- 모바일에서 기기의 해상도 능력에 상관없이 절대적인 크기로 나오도록 -->
<!-- 예를들어, pc에서의 300px이 모바일 에서도 똑같은 크기로 나오도록 -->
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<!-- 폰트어썸 FREE 아이콘 리스트 : https://fontawesome.com/v5.15/icons?d=gallery&p=2&m=free -->

<!-- 테일윈드 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">
<!-- 테일윈드 치트시트 : https://nerdcave.com/tailwind-cheat-sheet -->
<!-- 예시 줄 중 하나만 예시로 보여드림, 나머지도 동일한 방식으로 반복 적용하면 됩니다 -->

<!-- FullCalendar -->
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
	/* Tailwind blue-100 */
}
</style>
</head>

<body>
	<main class="relative w-full min-h-screen bg-white">
		<!-- Header Section -->


		<!-- Hero Section (배경 이미지 복구) -->
		<section class="relative w-full h-[517px] max-sm:h-[300px]">
			<img
				src="https://images.unsplash.com/photo-1621459555843-9a77f1d03fae?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=60"
				class="object-cover w-full h-full " alt="Summer Farm">
		</section>

		<section class="pb-8 mx-auto mt-20 shadow-sm w-[1295px] max-md:w-[90%] max-sm:w-[95%]">
			<!-- Calendar Grid -->
			<div id="calendar" class="flex flex-wrap w-full"></div>
		</section>
	</main>

	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/index.global.min.js'></script>
	<script>
  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
      headerToolbar : {
        left : 'prevYear,prev,next,nextYear today',
        center : 'title',
        right : 'dayGridMonth,dayGridWeek,dayGridDay'
      },
      selectable : true,
      selectMirror : true,
      navLinks : true,
      editable : true,
      dateClick : function(info) {
        const clickedDate = info.dateStr;
        const isLogined = ${rq.getLoginedMemberId() != 0};
        if (!isLogined) {
          alert("로그인이 필요합니다. 로그인 후 다시 시도해주세요.");
          return;
        }
        window.location.href = '/usr/farmlog/write?date=' + clickedDate;
      },
      dayMaxEvents : true,
      events : [
        { title : 'All Day Event', start : '2022-07-01' }
      ]
    });
    calendar.render();
  });
</script>
	<link href='/fullcalendar/main.css' rel='stylesheet' />
	<script src='/fullcalendar/main.js'></script>
	<script>
  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
      headerToolbar : {
        left : 'prevYear,prev,next,nextYear today',
        center : 'title',
        right : 'dayGridMonth,dayGridWeek,dayGridDay'
      },
      selectable : true,
      selectMirror : true,
      navLinks : true,
      editable : true,
      dateClick : function(info) {
        const clickedDate = info.dateStr;
        const isLogined = ${rq.getLoginedMemberId() != 0};
        if (!isLogined) {
          alert("로그인이 필요합니다. 로그인 후 다시 시도해주세요.");
          return;
        }
        window.location.href = '/usr/farmlog/write?date=' + clickedDate;
      },
      dayMaxEvents : true,
      events : [
        { title : 'All Day Event', start : '2022-07-01' }
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