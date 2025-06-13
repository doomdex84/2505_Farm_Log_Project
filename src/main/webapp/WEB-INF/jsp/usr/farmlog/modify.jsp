<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="pageTitle" value="FARMLOG MODIFY" />
<%@ include file="../common/head.jspf"%>

<%
java.time.LocalDate today = java.time.LocalDate.now();
request.setAttribute("today", today.toString());
%>

<section class="max-w-3xl mx-auto mt-12 p-10 rounded-2xl shadow-lg bg-blue-50">
	<h1 class="text-3xl font-bold mb-10 text-center text-gray-800">🌱 영농일지 수정</h1>

	<form action="/usr/farmlog/doModify" method="POST" enctype="multipart/form-data" class="space-y-6">
		<input type="hidden" name="id" value="${farmlog.id}" />

		<!-- 작업일 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📅 시작일 *</label>
			<input type="date" name="work_date" value="${today}" class="w-full border rounded-md p-2" readonly>
		</div>

		<!-- 날씨 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">☀️ 날씨 *</label>
			<select name="crop_category" class="w-full border rounded-md p-2">
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

		<!-- 품목 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📝 품목 *</label>
			<select id="crop" name="crop_name" class="w-full border rounded-md p-2">
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

		<!-- 품종 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🌾 품종 *</label>
			<select id="cropVariety" name="crop_variety_id" class="w-full border rounded-md p-2">
				<option value="">품종을 선택해주세요</option>
			</select>
		</div>

		<!-- 활동유형 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🚠 활동유형 *</label>
			<select id="work_type_name" name="work_type_name" class="w-full border rounded-md p-2">
				<option disabled selected value="">활동유형을 선택해주세요.</option>
				<option data-next-days="10" value="농약사용">농약사용</option>
				<option data-next-days="1" value="관수작업">관수작업</option>
				<option data-next-days="20" value="시비작업">시비작업</option>
				<option data-next-days="10" value="방제작업">방제작업</option>
				<option data-next-days="15" value="제초작업">제초작업</option>
				<option data-next-days="30" value="파종작업">파종작업</option>
				<option data-next-days="60" value="정식작업">정식작업</option>
				<option data-next-days="0" value="수확작업">수확작업</option>
				<option data-next-days="15" value="토양관리">토양관리</option>
				<option data-next-days="0" value="기타">기타</option>
			</select>
		</div>

		<!-- 작업유형 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">⚙️ 작업유형 *</label>
			<select id="workType" name="work_type" class="w-full border rounded-md p-2">
				<option disabled selected value="">활동유형을 먼저 선택하세요.</option>
			</select>
		</div>

		<!-- 작업 메모 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📝 작업내용</label>
			<textarea name="work_memo" rows="4" class="w-full border rounded-md p-2" placeholder="작업 내용을 입력해주세요."></textarea>
		</div>

		<!-- 다음 작업 예정일 -->
		<div class="mb-4">
			<label class="block text-gray-700 text-sm font-bold mb-2" for="next_schedule"> 다음 작업 예정일 </label>
			<input class="input input-bordered w-full" type="date" name="nextSchedule" id="next_schedule" readonly />
		</div>

		<!-- 이미지 업로드 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🖼️ 이미지 선택</label>
			<input type="file" name="file" accept="image/*" class="w-full border rounded-md p-2">
		</div>

		<!-- 버튼 -->
		<div class="flex justify-end space-x-4 pt-4">
			<button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-md">저장</button>
			<button type="button" onclick="history.back();" class="bg-red-500 text-white px-6 py-2 rounded-md">취소</button>
		</div>
	</form>
</section>

<script>
document.addEventListener("DOMContentLoaded", function () {
  const cropSelect = document.getElementById("crop");
  const varietySelect = document.getElementById("cropVariety");
  const activitySelect = document.getElementById("work_type_name");
  const workTypeSelect = document.getElementById("workType");
  const nextSchedule = document.getElementById("next_schedule");
  const baseDate = new Date(document.querySelector('input[name="work_date"]').value);

  const cropVarietyMap = {};
  <c:forEach items="${cropVarietyList}" var="item">
    if (!cropVarietyMap["${item.crop_name}"]) {
      cropVarietyMap["${item.crop_name}"] = [];
    }
    cropVarietyMap["${item.crop_name}"].push({
      id: "${item.cropVarietyId}",
      variety_name: "${item.variety}"
    });
  </c:forEach>

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

  // 활동유형 선택 시 작업유형 및 다음작업예정일 자동 표시
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

    // 👉 다음 작업 예정일 계산 (클라이언트 표시용)
    const days = parseInt(this.selectedOptions[0].dataset.nextDays);
    const nextDate = new Date(baseDate);
    nextDate.setDate(baseDate.getDate() + days);
    nextSchedule.value = nextDate.toISOString().split('T')[0];
  });
});
</script>
