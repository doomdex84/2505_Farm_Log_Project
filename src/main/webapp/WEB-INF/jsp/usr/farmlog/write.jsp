<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
			<input type="date" name="work_date" value="${today}" class="w-full border rounded-md p-2" readonly>
		</div>

		<!-- 품목 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🧾 품목 *</label>
			<select id="cropSelect" class="w-full border rounded-md p-2">
				<option disabled selected value="">품목을 선택해주세요</option>
				<c:forEach var="crop" items="${crops}">
					<option value="${crop.crop_code}">${crop.crop_name}</option>
				</c:forEach>
			</select>
		</div>

		<!-- 품종 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🌱 품종 *</label>
			<select name="crop_variety_id" id="varietySelect" class="w-full border rounded-md p-2">
				<option disabled selected value="">먼저 품목을 선택하세요</option>
			</select>
		</div>

		<!-- 활동유형 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🛠️ 활동유형 *</label>
			<select id="activityType" name="activity_type" class="w-full border rounded-md p-2">
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

		<!-- 작업유형 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">⚙️ 작업유형 *</label>
			<select id="workType" name="work_type" class="w-full border rounded-md p-2">
				<option disabled selected value="">활동유형을 먼저 선택하세요.</option>
			</select>
		</div>

		<!-- 작업내용 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📝 작업내용</label>
			<textarea name="work_memo" rows="4" class="w-full border rounded-md p-2" placeholder="작업 내용을 입력해주세요."></textarea>
		</div>

		<!-- 다음일정 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">📆 다음 예상일정</label>
			<input type="date" id="nextSchedule" name="next_schedule" class="w-full border rounded-md p-2">
		</div>

		<!-- 이미지 -->
		<div>
			<label class="block text-sm font-medium text-gray-700 mb-1">🖼️ 이미지 선택</label>
			<input type="file" name="file" accept="image/*" class="w-full border rounded-md p-2">
		</div>

		<!-- 버튼 -->
		<div class="flex justify-end space-x-4 pt-4">
			<button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-md">저장</button>
			<button type="button" onclick="history.back();" class="bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-md">취소</button>
		</div>
	</form>
</section>

<script>
// 활동유형 → 작업유형 연결
document.addEventListener("DOMContentLoaded", function () {
	const activitySelect = document.getElementById("activityType");
	const workTypeSelect = document.getElementById("workType");

	const workTypeMap = {
		'농약사용': ['살균제 살포', '살충제 살포', '제초제 살포'],
		'관수작업': ['스프링클러 관수', '드립관수', '물조리개 관수'],
		'시비작업': ['기비', '추비', '엽면시비'],
		'방제작업': ['끈끈이트랩 설치', '유인포 설치', '해충 포획'],
		'제초작업': ['예초기 제초', '손제초'],
		'파종작업': ['직파', '육묘상 파종'],
		'정식작업': ['모종 정식', '줄파기 이식'],
		'수확작업': ['채소 수확', '곡물 수확', '선별 및 포장'],
		'토양관리': ['로터리', '두둑 만들기', '비닐멀칭'],
		'기타': ['기계 점검', '농기구 세척', '작업 기록']
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

		// 다음 일정 자동 계산
		const days = parseInt(this.selectedOptions[0].dataset.nextDays);
		const baseDate = new Date(document.querySelector('input[name="work_date"]').value);
		baseDate.setDate(baseDate.getDate() + days);
		document.getElementById("nextSchedule").value = baseDate.toISOString().split("T")[0];
	});
});
</script>

<script>
// 품목 선택 → 품종 AJAX 연동
document.getElementById("cropSelect").addEventListener("change", function () {
	const cropCode = this.value;
	const varietySelect = document.getElementById("varietySelect");

	fetch(`/usr/crop/getVarietiesByCategory?category=${cropCode}`)
		.then(response => response.json())
		.then(data => {
			varietySelect.innerHTML = '<option value="">품종을 선택해주세요.</option>';
			data.forEach(function (item) {
				const option = document.createElement("option");
				option.value = item.id;
				option.textContent = item.variety_name;
				varietySelect.appendChild(option);
			});
		})
		.catch(error => {
			alert("품종 정보를 불러오는 데 실패했습니다.");
			console.error(error);
		});
});

const cropData = ${cropListJson};
console.log("품목-품종 데이터", cropData);
</script>
