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
		<header
			class="flex relative justify-between items-center px-20 py-0 w-full h-28 bg-white max-md:px-10 max-md:py-0 max-sm:px-5 max-sm:py-0 max-sm:h-20">
			<img
				src="https://cdn.builder.io/api/v1/image/assets/TEMP/c69148d2b87faab7b5b436a55f4da7ed52fe8175?placeholderIfAbsent=true"
				class="object-cover h-[109px] w-[109px] max-sm:h-[60px] max-sm:w-[60px]" alt="Logo">

			<h1 class="ml-24 text-2xl text-black max-sm:ml-5 max-sm:text-lg">오늘의 날씨</h1>

			<img
				src="https://cdn.builder.io/api/v1/image/assets/TEMP/fb7c0934e482b43399db67da216f4883626120ca?placeholderIfAbsent=true"
				class="object-cover ml-32 h-[52px] w-[52px] max-sm:ml-5 max-sm:w-9 max-sm:h-9" alt="Weather">

			<div
				class="flex relative justify-end items-center pt-1.5 pr-2.5 pb-2 pl-80 bg-white rounded-2xl border border-black border-solid h-[47px] w-[380px] max-sm:py-1 max-sm:pr-1.5 max-sm:pl-40 max-sm:h-9 max-sm:w-[200px]">
				<img
					src="https://cdn.builder.io/api/v1/image/assets/TEMP/db305accc6ef9944c7a7c6c08c29aab6f13cad97?placeholderIfAbsent=true"
					class="object-cover absolute top-1.5 h-[34px] left-[337px] w-[34px] max-sm:top-1 max-sm:left-40 max-sm:w-6 max-sm:h-6"
					alt="Search">
			</div>


			<button aria-label="Menu" class="hamburger-button">
				<svg width="44" height="30" viewBox="0 0 44 30" fill="none" xmlns="http://www.w3.org/2000/svg"
					class="hamburger-menu" style="width: 44px; height: 21px; margin-left: 22px">
          <line y1="3" x2="44" y2="3" stroke="black" stroke-width="6"></line>
          <path d="M0 15.3333C17.1831 15.3333 26.8169 15.3333 44 15.3333" stroke="black" stroke-width="6"></path>
          <path d="M0 27C17.1831 27 26.8169 27 44 27" stroke="black" stroke-width="6"></path>
        </svg>
			</button>
		</header>

		<!-- Hero Section (배경 이미지 복구) -->
		<section class="relative w-full h-[517px] max-sm:h-[300px]">
			<img
				src="https://cdn.builder.io/api/v1/image/assets/TEMP/73e2c6f0f5131087fbf1cac9d00490dfc228edb5?placeholderIfAbsent=true"
				class="object-cover rounded-xl opacity-[0.26] size-full" alt="Hero">
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