<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="FARMLOG MODIFY" />
<%@ include file="../common/head.jspf"%>

<section class="max-w-3xl mx-auto mt-12 p-10 rounded-2xl shadow-lg bg-blue-50">
	<h1 class="text-3xl font-bold mb-10 text-center text-gray-800">🌱 영농일지 수정</h1>

	<form action="/usr/farmlog/doModify" method="POST" enctype="multipart/form-data" class="space-y-6">
		<input type="hidden" name="id" value="${farmlog.id}" />

		<!-- 작업일 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📅 작업일 *</label>
			<input type="date" name="work_date" value="${farmlog.work_date}" class="w-full border rounded-md p-2" readonly>
		</div>

		<!-- 날씨 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">☀️ 날씨 *</label>
			<select name="weather" class="w-full border rounded-md p-2">
				<option disabled value="">날씨를 선택해주세요.</option>
				<option value="맑음" <c:if test="${farmlog.weather eq '맑음'}">selected</c:if>>맑음</option>
				<option value="흐림" <c:if test="${farmlog.weather eq '흐림'}">selected</c:if>>흐림</option>
				<option value="비" <c:if test="${farmlog.weather eq '비'}">selected</c:if>>비</option>
				<option value="가벼운 비" <c:if test="${farmlog.weather eq '가벼운 비'}">selected</c:if>>가벼운 비</option>
				<option value="강한 비" <c:if test="${farmlog.weather eq '강한 비'}">selected</c:if>>강한 비</option>
				<option value="눈" <c:if test="${farmlog.weather eq '눈'}">selected</c:if>>눈</option>
				<option value="가벼운 눈" <c:if test="${farmlog.weather eq '가벼운 눈'}">selected</c:if>>가벼운 눈</option>
				<option value="강한 눈" <c:if test="${farmlog.weather eq '강한 눈'}">selected</c:if>>강한 눈</option>
				<option value="낙뢰" <c:if test="${farmlog.weather eq '낙뢰'}">selected</c:if>>낙뢰</option>
				<option value="안개" <c:if test="${farmlog.weather eq '안개'}">selected</c:if>>안개</option>
				<option value="우박" <c:if test="${farmlog.weather eq '우박'}">selected</c:if>>우박</option>
				<option value="강풍" <c:if test="${farmlog.weather eq '강풍'}">selected</c:if>>강풍</option>
			</select>
		</div>

		<!-- 품목 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📝 품목 *</label>
			<select id="crop" name="crop_name" class="w-full border rounded-md p-2">
				<option disabled value="">품목을 선택해주세요.</option>
				<c:forEach items="${cropVarietyListGrouped}" var="entry">
					<optgroup label="${entry.key}">
						<c:forEach items="${entry.value}" var="cropName">
							<option value="${cropName}" <c:if test="${cropName eq farmlog.cropName}">selected</c:if>>${cropName}</option>
						</c:forEach>
					</optgroup>
				</c:forEach>
			</select>
		</div>

		<!-- 품종 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🌾 품종 *</label>
			<select id="cropVariety" name="crop_variety_id" class="w-full border rounded-md p-2">
				<option value="">품종을 선택해주세요.</option>
				<c:forEach items="${cropVarietyList}" var="item">
					<option value="${item.cropVarietyId}" <c:if test="${item.cropVarietyId eq farmlog.crop_variety_id}">selected</c:if>>
						${item.variety}</option>
				</c:forEach>
			</select>
		</div>

		<!-- 활동유형 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🚠 활동유형 *</label>
			<select id="work_type_name" name="work_type_name" class="w-full border rounded-md p-2">
				<option disabled value="">활동유형을 선택해주세요.</option>
				<option value="농약사용" data-next-days="10" <c:if test="${farmlog.work_type_name eq '농약사용'}">selected</c:if>>농약사용</option>
				<option value="관수작업" data-next-days="1" <c:if test="${farmlog.work_type_name eq '관수작업'}">selected</c:if>>관수작업</option>
				<option value="시비작업" data-next-days="20" <c:if test="${farmlog.work_type_name eq '시비작업'}">selected</c:if>>시비작업</option>
				<option value="방제작업" data-next-days="10" <c:if test="${farmlog.work_type_name eq '방제작업'}">selected</c:if>>방제작업</option>
				<option value="제초작업" data-next-days="15" <c:if test="${farmlog.work_type_name eq '제초작업'}">selected</c:if>>제초작업</option>
				<option value="파종작업" data-next-days="30" <c:if test="${farmlog.work_type_name eq '파종작업'}">selected</c:if>>파종작업</option>
				<option value="정식작업" data-next-days="60" <c:if test="${farmlog.work_type_name eq '정식작업'}">selected</c:if>>정식작업</option>
				<option value="수확작업" data-next-days="0" <c:if test="${farmlog.work_type_name eq '수확작업'}">selected</c:if>>수확작업</option>
				<option value="토양관리" data-next-days="15" <c:if test="${farmlog.work_type_name eq '토양관리'}">selected</c:if>>토양관리</option>
				<option value="기타" data-next-days="0" <c:if test="${farmlog.work_type_name eq '기타'}">selected</c:if>>기타</option>
			</select>
		</div>

		<!-- 작업 메모 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📝 작업내용</label>
			<textarea name="work_memo" rows="4" class="w-full border rounded-md p-2">${farmlog.work_memo}</textarea>
		</div>

		<!-- 다음 작업 예정일 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📌 다음 작업 예정일</label>
			<input type="date" name="nextSchedule" value="${farmlog.nextSchedule}" class="w-full border rounded-md p-2" readonly>
		</div>

		<!-- 이미지 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🖼️ 이미지 선택</label>
			<input type="file" name="file" accept="image/*" class="w-full border rounded-md p-2">
			<c:if test="${not empty farmlog.imgFileName}">
				<p class="mt-2 text-sm text-gray-500">현재 이미지: ${farmlog.imgFileName}</p>
			</c:if>
		</div>

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