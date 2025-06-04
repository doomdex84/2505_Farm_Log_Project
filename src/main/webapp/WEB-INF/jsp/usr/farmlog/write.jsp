
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
	<form action="../farmlog/doWrite" enctype="multipart/form-data" method="POST">
		<select class="border p-2 rounded w-full mb-4" name="crop_variety_name">
			<optgroup label="논농사">
				<option value="녹두">녹두</option>
				<option value="들깨">들깨</option>
				<option value="벼 기계이앙재배">벼 기계이앙재배</option>
				<option value="벼 직파재배">벼 직파재배</option>
				<option value="사료용벼">사료용벼</option>
				<option value="옥수수">옥수수</option>
				<option value="참깨">참깨</option>
				<option value="콩 (논재배)">콩 (논재배)</option>
				<option value="팥">팥</option>
			</optgroup>
			<optgroup label="밭농사">
				<option value="감자">감자</option>
				<option value="강낭콩">강낭콩</option>
				<option value="고구마">고구마</option>
				<option value="녹두">녹두</option>
				<option value="들깨 (잎)">들깨 (잎)</option>
				<option value="들깨 (종실)">들깨 (종실)</option>
				<option value="땅콩">땅콩</option>
				<option value="맥주보리">맥주보리</option>
				<option value="메밀">메밀</option>
				<option value="밀">밀</option>
				<option value="수수">수수</option>
				<option value="옥수수">옥수수</option>
				<option value="완두">완두</option>
				<option value="유채">유채</option>
				<option value="일반보리">일반보리</option>
				<option value="조">조</option>
				<option value="참깨">참깨</option>
				<option value="콩">콩</option>
				<option value="팥">팥</option>
				<option value="풋콩">풋콩</option>
			</optgroup>
			<optgroup label="채소">
				<option value="가지">가지</option>
				<option value="갓">갓</option>
				<option value="결구상추">결구상추</option>
				<option value="고들빼기">고들빼기</option>
				<option value="고사리">고사리</option>
				<option value="고추 (꽈리고추 반촉성)">고추 (꽈리고추 반촉성)</option>
				<option value="고추 (보통재배)">고추 (보통재배)</option>
				<option value="고추 (촉성재배)">고추 (촉성재배)</option>
				<option value="곰취">곰취</option>
				<option value="근대">근대</option>
				<option value="냉이">냉이</option>
				<option value="당근">당근</option>
				<option value="두릅">두릅</option>
				<option value="딸기 (사계성여름재배)">딸기 (사계성여름재배)</option>
				<option value="딸기 (촉성재배)">딸기 (촉성재배)</option>
				<option value="마늘">마늘</option>
				<option value="마늘 (잎마늘)">마늘 (잎마늘)</option>
				<option value="멜론">멜론</option>
				<option value="무">무</option>
				<option value="무 (고랭지재배)">무 (고랭지재배)</option>
				<option value="미나리">미나리</option>
				<option value="배추">배추</option>
				<option value="배추 (고랭지재배)">배추 (고랭지재배)</option>
				<option value="부추">부추</option>
				<option value="브로콜리 (녹색꽃양배추 고랭지재배)">브로콜리 (녹색꽃양배추 고랭지재배)</option>
				<option value="브로콜리 (평야지재배)">브로콜리 (평야지재배)</option>
				<option value="비트">비트</option>
				<option value="상추">상추</option>
				<option value="생강">생강</option>
				<option value="셀러리 (양미나리)">셀러리 (양미나리)</option>
				<option value="수박">수박</option>
				<option value="시금치">시금치</option>
				<option value="신선초">신선초</option>
				<option value="쑥갓">쑥갓</option>
				<option value="아스파라거스">아스파라거스</option>
				<option value="아욱">아욱</option>
				<option value="양배추">양배추</option>
				<option value="양파">양파</option>
				<option value="연근">연근</option>
				<option value="오이">오이</option>
				<option value="적채">적채</option>
				<option value="쪽파">쪽파</option>
				<option value="참외">참외</option>
				<option value="참취">참취</option>
				<option value="청경채">청경채</option>
				<option value="치커리 (쌈용, 잎치커리)">치커리 (쌈용, 잎치커리)</option>
				<option value="치커리 (치콘,뿌리치커리)">치커리 (치콘,뿌리치커리)</option>
				<option value="컬리플라워 (백색꽃양배추 고랭지재배)">컬리플라워 (백색꽃양배추 고랭지재배)</option>
				<option value="토란">토란</option>
				<option value="토마토,방울토마토">토마토,방울토마토</option>
				<option value="파">파</option>
				<option value="파드득나물">파드득나물</option>
				<option value="파슬리 (향미나리)">파슬리 (향미나리)</option>
				<option value="파프리카">파프리카</option>
				<option value="피망">피망</option>
				<option value="호박">호박</option>
				<option value="호박 (늙은호박)">호박 (늙은호박)</option>
				<option value="호박 (단호박)">호박 (단호박)</option>
			</optgroup>
			<optgroup label="버섯">
				<option value="느타리버섯">느타리버섯</option>
				<option value="양송이">양송이</option>
				<option value="영지버섯">영지버섯</option>
				<option value="팽이">팽이</option>
			</optgroup>
			<optgroup label="약초">
				<option value="구기자">구기자</option>
				<option value="길경 (도라지)">길경 (도라지)</option>
				<option value="더덕 (양유)">더덕 (양유)</option>
				<option value="두충">두충</option>
				<option value="산약 (마)">산약 (마)</option>
				<option value="오미자">오미자</option>
				<option value="천마">천마</option>
				<option value="황기">황기</option>
			</optgroup>
			<optgroup label="과수">
				<option value="감귤 (노지재배)">감귤 (노지재배)</option>
				<option value="감귤 (시설재배)">감귤 (시설재배)</option>
				<option value="단감">단감</option>
				<option value="매실">매실</option>
				<option value="무화과 (노지재배)">무화과 (노지재배)</option>
				<option value="무화과 (무가온 시설재배)">무화과 (무가온 시설재배)</option>
				<option value="배">배</option>
				<option value="복숭아">복숭아</option>
				<option value="블루베리">블루베리</option>
				<option value="사과">사과</option>
				<option value="살구">살구</option>
				<option value="양앵두 (체리)">양앵두 (체리)</option>
				<option value="유자">유자</option>
				<option value="자두">자두</option>
				<option value="참다래">참다래</option>
				<option value="포도 (무가온)">포도 (무가온)</option>
				<option value="포도 (표준가온)">포도 (표준가온)</option>
				<option value="플럼코트">플럼코트</option>
				<option value="한라봉 (부지화)">한라봉 (부지화)</option>
			</optgroup>
		</select>
		<div class="grid grid-cols-1 gap-6">
			<div>
				<label class="block font-semibold">시작일 *</label>
				<input class="w-full border p-2 rounded" name="work_date" readonly="" type="date" value="${today}" />
			</div>
			<div>
				<label class="block font-semibold">날씨정보</label>
				<select class="w-full border p-2 rounded" name="crop_category">
					<option disabled="" selected="" value="">날씨를 선택해주세요.</option>
					<option value="맑음">맑음</option>
					<option value="비">비</option>
					<option value="흐림">흐림</option>
					<option value="낙뢰">낙뢰</option>
					<option value="눈">눈</option>
				</select>
			</div>
			<!-- 품목 선택 -->
			<label class="block font-semibold">품목 *</label>
			<select class="w-full border p-2 rounded" id="crop" name="crop_id">
				<option disabled="" selected="" value="">품목을 선택해주세요.</option>
				<c:foreach items="${crops}" var="crop">
					<option value="${crop.id}">${crop.name}</option>
				</c:foreach>
			</select>
			<!-- 품종 선택 -->
			<label class="block font-semibold mt-4">품종 *</label>
			<select class="w-full border p-2 rounded" id="cropVariety" name="crop_variety_id">
				<option disabled="" selected="" value="">품종을 선택해주세요.</option>
			</select>
			<div>
				<label class="block font-semibold">활동유형 *</label>
				<select class="w-full border p-2 rounded" id="activityType" name="activity_type">
					<option disabled="" selected="" value="">활동유형을 선택해주세요.</option>
					<option data-next-days="7" value="농약사용">농약사용</option>
					<option data-next-days="3" value="관수작업">관수작업</option>
				</select>
			</div>
			<div>
				<label class="block font-semibold">작업유형 *</label>
				<select class="w-full border p-2 rounded" name="work_type">
					<option disabled="" selected="" value="">작업유형을 선택해주세요.</option>
					<option value="제촉작업">제촉작업</option>
					<option value="관수">관수</option>
				</select>
			</div>
			<div>
				<label class="block font-semibold">작업내용</label>
				<textarea class="w-full border p-2 rounded" name="work_memo" placeholder="작업 내용을 입력해주세요." rows="4"></textarea>
			</div>
			<div>
				<label class="block font-semibold">다음 예상일정</label>
				<input class="w-full border p-2 rounded" id="nextSchedule" name="next_schedule" type="date" />
			</div>
			<div>
				<label class="block font-semibold">사진 첨부</label>
				<input class="file-input file-input-success" type="file" />
			</div>
			<div class="flex gap-4">
				<button class="bg-blue-700 text-white px-4 py-2 rounded" type="submit">저장</button>
				<button class="border px-4 py-2 rounded" onclick="history.back();" type="button">취소</button>
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
