<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../common/head.jspf"%>

<%
java.time.LocalDate today = java.time.LocalDate.now();
request.setAttribute("today", today.toString());
%>

<section class="max-w-3xl mx-auto mt-12 p-10 rounded-2xl shadow-lg" style="background-color: #c8defa;">
	<h1 class="text-3xl font-bold mb-10 text-center text-gray-800">Today 영농일지 등록</h1>

	<form action="../farmlog/doWrite" method="POST" enctype="multipart/form-data" class="space-y-6">

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1"> 📅 시작일 * </label>
			<input type="date" name="work_date" value="${today}"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition" readonly>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1"> 🌤️ 날씨정보 * </label>
			<select name="crop_category"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option disabled selected value="">날씨를 선택해주세요.</option>
				<option value="맑음">맑음</option>
				<option value="비">비</option>
				<option value="흐림">흐림</option>
				<option value="낙뢰">낙뢰</option>
				<option value="눈">눈</option>
			</select>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1"> 🧾 품목 * </label>
			<select id="crop" name="crop_variety_name"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option disabled selected value="">품목을 선택해주세요.</option>
				<option value="논농사">논농사</option>
				<option value="밭농사">밭농사</option>
				<option value="채소">채소</option>
				<option value="버섯">버섯</option>
				<option value="약초">약초</option>
				<option value="과수">과수</option>
			</select>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1"> 🌱 품종 * </label>
			<select id="cropVariety" name="crop_variety_id"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option value="">먼저 품목을 선택해주세요.</option>
			</select>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1"> 🛠️ 활동유형 * </label>
			<select id="activityType" name="activity_type"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option disabled selected value="">활동유형을 선택해주세요.</option>
				<option data-next-days="7" value="농약사용">농약사용</option>
				<option data-next-days="3" value="관수작업">관수작업</option>
			</select>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1"> ⚙️ 작업유형 * </label>
			<select name="work_type"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option disabled selected value="">작업유형을 선택해주세요.</option>
				<option value="제촉작업">제촉작업</option>
				<option value="관수">관수</option>
			</select>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1"> 📝 작업내용 </label>
			<textarea name="work_memo" rows="4"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition"
				placeholder="작업 내용을 입력해주세요."></textarea>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1"> 📆 다음 예상일정 </label>
			<input type="date" id="nextSchedule" name="next_schedule"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1"> 📷 사진 첨부 </label>
			<input type="file" name="file"
				class="w-full border rounded-md p-2 focus:outline-none file:bg-blue-600 file:text-white file:px-4 file:py-2 file:rounded-md file:cursor-pointer">
		</div>

		<div class="flex justify-end space-x-4 pt-4">
			<button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-medium px-6 py-2 rounded-md transition">저장</button>
			<button type="button" onclick="history.back();"
				class="bg-red-500 hover:bg-red-600 text-white font-medium px-6 py-2 rounded-md transition">취소</button>
		</div>

	</form>
</section>

<script>
document.addEventListener("DOMContentLoaded", function () {
  const cropSelect = document.getElementById("crop");
  const varietySelect = document.getElementById("cropVariety");

  const cropVarietyMap = {
    '논농사': ['벼 기계이앙재배', '벼 직파재배', '사료용벼'],
    '밭농사': ['옥수수', '참깨', '콩 (논재배)', '팥'],
    '채소': ['감자', '고구마', '상추', '고추 (보통재배)', '무', '배추', '양파'],
    '버섯': ['느타리버섯', '양송이', '영지버섯', '팽이'],
    '약초': ['구기자', '길경 (도라지)', '더덕 (양유)', '황기'],
    '과수': ['사과', '배', '복숭아', '포도 (무가온)', '대추']
  };

  cropSelect.addEventListener("change", function () {
    const selected = this.value;
    const varieties = cropVarietyMap[selected] || [];

    varietySelect.innerHTML = '<option value="">품종을 선택해주세요.</option>';
    varieties.forEach(v => {
      const option = document.createElement("option");
      option.value = v;
      option.textContent = v;
      varietySelect.appendChild(option);
    });
  });

  varietySelect.addEventListener("focus", function () {
    if (!cropSelect.value) {
      alert("먼저 품목을 선택하세요.");
      cropSelect.focus();
    }
  });
});
</script>

<script>
const activitySelect = document.getElementById('activityType');
const nextSchedule = document.getElementById('nextSchedule');
const baseDate = new Date(document.querySelector('input[name="work_date"]').value);

activitySelect.addEventListener('change', () => {
  const days = parseInt(activitySelect.selectedOptions[0].dataset.nextDays);
  const nextDate = new Date(baseDate);
  nextDate.setDate(baseDate.getDate() + days);
  nextSchedule.value = nextDate.toISOString().split('T')[0];
});
</script>
