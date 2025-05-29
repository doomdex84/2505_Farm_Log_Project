
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../common/head.jspf"%>

<%
java.time.LocalDate today = java.time.LocalDate.now();
request.setAttribute("today", today.toString());
%>

<section class="p-8">
	<h1 class="text-2xl font-bold mb-6">Today 영논일지 등록</h1>

	<form action="../farmlog/doWrite" method="POST" enctype="multipart/form-data">
		<div class="grid grid-cols-1 gap-6">
			<div>
				<label class="block font-semibold">시작일 *</label>
				<input type="date" name="work_date" value="${today}" class="w-full border p-2 rounded" readonly />
			</div>

			<div>
				<label class="block font-semibold">날씨정보</label>
				<select name="crop_category" class="w-full border p-2 rounded">
					<option value="" selected disabled>날씨를 선택해주세요.</option>
					<option value="맑음">맑음</option>
					<option value="비">비</option>
					<option value="흐림">흐림</option>
					<option value="낙뢰">낙뢰</option>
					<option value="눈">눈</option>
				</select>
			</div>

			<!-- 품목 선택 -->
			<label class="block font-semibold">품목 *</label>
			<select id="crop" name="crop_id" class="w-full border p-2 rounded">
				<option value="" selected disabled>품목을 선택해주세요.</option>
				<c:forEach var="crop" items="${crops}">
					<option value="${crop.id}">${crop.name}</option>
				</c:forEach>
			</select>

			<!-- 품종 선택 -->
			<label class="block font-semibold mt-4">품종 *</label>
			<select id="cropVariety" name="crop_variety_id" class="w-full border p-2 rounded">
				<option value="" selected disabled>품종을 선택해주세요.</option>
			</select>


			<div>
				<label class="block font-semibold">활동유형 *</label>
				<select name="activity_type" id="activityType" class="w-full border p-2 rounded">
					<option value="" selected disabled>활동유형을 선택해주세요.</option>
					<option value="농약사용" data-next-days="7">농약사용</option>
					<option value="관수작업" data-next-days="3">관수작업</option>
				</select>
			</div>

			<div>
				<label class="block font-semibold">작업유형 *</label>
				<select name="work_type" class="w-full border p-2 rounded">
				<option value="" selected disabled>작업유형을 선택해주세요.</option>
					<option value="제촉작업">제촉작업</option>
					<option value="관수">관수</option>
				</select>
			</div>

			<div>
				<label class="block font-semibold">작업내용</label>
				<textarea name="work_memo" rows="4" class="w-full border p-2 rounded" placeholder="작업 내용을 입력해주세요."></textarea>
			</div>



			<div>
				<label class="block font-semibold">다음 예상일정</label>
				<input type="date" name="next_schedule" id="nextSchedule" class="w-full border p-2 rounded" />
			</div>

			<div>
				<label class="block font-semibold">사진 첨부</label>
				<input type="file" class="file-input file-input-success" />
			</div>

			<div class="flex gap-4">
				<button type="submit" class="bg-blue-700 text-white px-4 py-2 rounded">저장</button>
				<button type="button" onclick="history.back();" class="border px-4 py-2 rounded">취소</button>
			</div>
		</div>
	</form>
</section>

<script>

document.querySelector('#crop').addEventListener('change', function () {
	  const cropId = this.value;
	  fetch(`/api/crop-varieties?cropId=${cropId}`)
	    .then(res => res.json())
	    .then(varieties => {
	      const varietySelect = document.querySelector('#cropVariety');
	      varietySelect.innerHTML = '';
	      varieties.forEach(v => {
	        const option = document.createElement('option');
	        option.value = v.id;
	        option.textContent = v.name;
	        varietySelect.appendChild(option);
	      });
	    });
	});
	
document.addEventListener("DOMContentLoaded", function () {
  document.querySelector('#crop').addEventListener('change', function () {
    const cropId = this.value;

    // 품종 리스트 초기화
    const varietySelect = document.querySelector('#cropVariety');
    varietySelect.innerHTML = '<option value="">품종 선택</option>';

    if (!cropId) return;

    // API 호출
    fetch(`/api/crop-varieties?cropId=${cropId}`)
      .then(res => res.json())
      .then(varieties => {
        varieties.forEach(v => {
          const option = document.createElement('option');
          option.value = v.id;
          option.textContent = v.name;
          varietySelect.appendChild(option);
        });
      })
      .catch(error => {
        console.error('품종 불러오기 실패:', error);
      });
  });
});
</script>


<script>

    // 자동 예상일 계산
    const activitySelect = document.getElementById('activityType');
    const nextSchedule = document.getElementById('nextSchedule');
    const baseDate = new Date(document.querySelector('input[name="work_date"]').value);

    activitySelect.addEventListener('change', () => {
        const days = parseInt(activitySelect.selectedOptions[0].dataset.nextDays);
        const nextDate = new Date(baseDate);
        nextDate.setDate(baseDate.getDate() + days);
        nextSchedule.value = nextDate.toISOString().split('T')[0];
    });

    activitySelect.dispatchEvent(new Event('change'));

</script>

