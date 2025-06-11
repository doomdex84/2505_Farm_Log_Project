<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="pageTitle" value="FARMLOF WRITE"></c:set>
<%@ include file="../common/head.jspf"%>

<%
java.time.LocalDate today = java.time.LocalDate.now();
request.setAttribute("today", today.toString());
%>

<section class="max-w-3xl mx-auto mt-12 p-10 rounded-2xl shadow-lg" style="background-color: #c8defa;">
	<h1 class="text-3xl font-bold mb-10 text-center text-gray-800">Today 영농일지 등록</h1>

	<form action="../farmlog/doWrite" method="POST" enctype="multipart/form-data" class="space-y-6">
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📅 시작일 *</label>
			<input type="date" name="work_date" value="${today}"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition" readonly>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🌤️ 날씨정보 *</label>
			<select name="crop_category"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option disabled selected value="">날씨를 선택해주세요.</option>
				<option value="맑음">맑음</option>
				<option value="흐림">흐림</option>
				<option value="비">비</option>
				<option value="가벼운 비">가벼운 비</option>
				<option value="강한 비">강한 비</option>
				<option value="눈">눈</option>
				<option value="가벼운 눈">가벼운 눈</option>
				<option value="강한 눈">강한 눈</option>
				<option value="낙뢰">낙뢰</option>
				<option value="안개">안개</option>
				<option value="우박">우박</option>
				<option value="강풍">강풍</option>
			</select>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🧾 품목 *</label>
			<select id="crop" name="crop_name"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option disabled selected value="">품목을 선택해주세요.</option>
				<c:forEach items="${cropVarietyListGrouped}" var="entry">
					<optgroup label="${entry.key}">
						<c:forEach items="${entry.value}" var="cropName">
							<option value="${cropName}">${cropName}</option>
						</c:forEach>
					</optgroup>
				</c:forEach>
			</select>
		</div>

		<div>
			<label for="cropVariety" class="block text-sm font-medium text-gray-700 mb-1">🌾 품종 *</label>
			<select name="crop_variety_id"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option value="">품종을 선택해주세요</option>
				<c:forEach var="item" items="${cropVarietyList}">
					<option value="${item.cropVarietyId}">${item.variety}</option>
				</c:forEach>
			</select>
		</div>


		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🛠️ 활동유형 *</label>
			<select id="work_type_name" name="work_type_name"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option disabled selected value="">활동유형을 선택해주세요.</option>
				<option data-next-days="7" value="농약사용">농약사용</option>
				<option data-next-days="3" value="관수작업">관수작업</option>
				<option data-next-days="14" value="시비작업">시비작업</option>
				<option data-next-days="7" value="방제작업">방제작업</option>
				<option data-next-days="10" value="제초작업">제초작업</option>
				<option data-next-days="30" value="파종작업">파종작업</option>
				<option data-next-days="30" value="정식작업">정식작업</option>
				<option data-next-days="0" value="수확작업">수확작업</option>
				<option data-next-days="15" value="토양관리">토양관리</option>
				<option data-next-days="0" value="기타">기타</option>
			</select>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">⚙️ 작업유형 *</label>
			<select id="workType" name="work_type"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
				<option disabled selected value="">활동유형을 먼저 선택하세요.</option>
			</select>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📝 작업내용</label>
			<textarea name="work_memo" rows="4"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition"
				placeholder="작업 내용을 입력해주세요."></textarea>
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📆 다음 예상일정</label>
			<input type="date" id="nextSchedule" name="next_schedule"
				class="w-full border rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">
		</div>

		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🖼️ 이미지 선택</label>
			<input type="file" name="file" accept="image/*"
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
	const activitySelect = document.getElementById("work_type_name");
	const workTypeSelect = document.getElementById("workType");
	const nextSchedule = document.getElementById("nextSchedule");
	const baseDate = new Date(document.querySelector('input[name="work_date"]').value);

	// 🌱 품종 맵 생성
	const cropVarietyMap = {};
	<c:forEach items="${cropVarietyList}" var="item">
		if (!cropVarietyMap["${item.crop_name}"]) {
			cropVarietyMap["${item.crop_name}"] = [];
		}
		cropVarietyMap["${item.crop_name}"].push({
			id: "${item.id}",
			variety_name: "${item.variety_name}"
		});
	</c:forEach>

	// 품목 → 품종 필터링
	cropSelect.addEventListener("change", function () {
		const selectedCrop = this.value;
		varietySelect.innerHTML = "<option value=''>품종을 선택해주세요.</option>";

		if (cropVarietyMap[selectedCrop]) {
			cropVarietyMap[selectedCrop].forEach(function (v) {
				const option = document.createElement("option");
				option.value = v.id;
				option.textContent = v.variety_name;
				varietySelect.appendChild(option);
			});
			varietySelect.disabled = false;
		} else {
			varietySelect.disabled = true;
		}
	});

	// 활동유형 → 작업유형 매핑
	const workTypeMap = {
		"농약사용": ["살균제 살포", "살충제 살포", "제초제 살포"],
		"관수작업": ["스프링클러 관수", "드립관수", "물조리개 관수"],
		"시비작업": ["기비", "추비", "엽면시비"],
		"방제작업": ["끈끈이트랩 설치", "유인포 설치", "해충 포획"],
		"제초작업": ["예초기 제초", "손제초"],
		"파종작업": ["직파", "육묘상 파종"],
		"정식작업": ["모종 정식", "줄파기 이식"],
		"수확작업": ["채소 수확", "곡물 수확", "선별 및 포장"],
		"토양관리": ["로터리", "두둑 만들기", "비닐멀칭"],
		"기타": ["기계 점검", "농기구 세척", "작업 기록"]
	};

	activitySelect.addEventListener("change", function () {
		const selected = this.value;
		const workTypes = workTypeMap[selected] || [];

		workTypeSelect.innerHTML = '<option value="">작업유형을 선택해주세요.</option>';
		workTypes.forEach(w => {
			const option = document.createElement("option");
			option.value = w;
			option.textContent = w;
			workTypeSelect.appendChild(option);
		});

		// 예상 일정 계산
		const days = parseInt(this.selectedOptions[0].dataset.nextDays);
		const nextDate = new Date(baseDate);
		nextDate.setDate(baseDate.getDate() + days);
		nextSchedule.value = nextDate.toISOString().split('T')[0];
	});
});
</script>

