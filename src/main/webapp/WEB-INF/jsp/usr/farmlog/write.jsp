
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
					<option value="맑음">맑음</option>
					<option value="비">비</option>
					<option value="흐림">흐림</option>
					<option value="낙뢰">낙뢰</option>
					<option value="눈">눈</option>
				</select>
			</div>

			<div>
				<label class="block font-semibold">품목 *</label>
				<select name="crop_category" class="w-full border p-2 rounded">
					<option value="대추">대추</option>
					<option value="사과">사과</option>
				</select>
			</div>

			<div>
				<label class="block font-semibold">품종 *</label>
				<select name="crop_variety" class="w-full border p-2 rounded">
					<option value="농지 대추">농지 대추</option>
					<option value="황금 사과">황금 사과</option>
				</select>
			</div>
			<div>
				<label class="block font-semibold">활동유형 *</label>
				<select name="activity_type" id="activityType" class="w-full border p-2 rounded">
					<option value="농약사용" data-next-days="7">농약사용</option>
					<option value="관수작업" data-next-days="3">관수작업</option>
				</select>
			</div>

			<div>
				<label class="block font-semibold">작업유형 *</label>
				<select name="work_type" class="w-full border p-2 rounded">
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
});
</script>


