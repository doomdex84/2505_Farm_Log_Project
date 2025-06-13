<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="pageTitle" value="영농일지 상세보기" />
<%@ include file="../common/head.jspf"%>

<div class="bg-white border border-gray-200 rounded-lg p-6 max-w-3xl mx-auto">
	<h1 class="text-3xl font-extrabold text-center text-green-700 mb-8 flex items-center justify-center gap-2">
		<span class="text-2xl">🍀</span>
		영농일지 상세보기
	</h1>

	<!-- 정보 박스 -->
	<div class="grid grid-cols-[150px_1fr] gap-4 text-[17px] text-gray-800 mb-6">
		<div class="font-semibold text-green-800">작업일</div>
		<div class="bg-gray-50 border px-4 py-2 rounded">${farmlog.work_date}</div>

		<div class="font-semibold text-green-800">작업유형</div>
		<div class="bg-gray-50 border px-4 py-2 rounded">${farmlog.work_type_name}</div>

		<div class="font-semibold text-green-800">품목</div>
		<div class="bg-gray-50 border px-4 py-2 rounded">${farmlog.cropName}</div>

		<div class="font-semibold text-green-800">품종</div>
		<div class="bg-gray-50 border px-4 py-2 rounded">${farmlog.varietyName}</div>

		<c:if test="${not empty farmlog.nextSchedule}">
			<div class="font-semibold text-green-800">다음 예정일</div>
			<div class="bg-gray-50 border px-4 py-2 rounded text-red-600 font-semibold">${farmlog.nextSchedule}</div>
		</c:if>
	</div>

	<!-- 작업메모 -->
	<div class="mb-6">
		<div class="font-semibold text-green-800 mb-2">작업메모</div>
		<div class="bg-gray-50 border rounded p-4 text-sm text-gray-700 leading-relaxed">
			<pre class="whitespace-pre-wrap font-normal" style="font-family: inherit;">${farmlog.work_memo}</pre>
		</div>
	</div>

	<!-- 작업 사진 -->
	<c:if test="${not empty farmlog.imgFileName}">
		<div class="mb-6">
			<div class="font-semibold text-green-800 mb-2">작업 사진</div>
			<img src="/gen/farmlog/${farmlog.imgFileName}" alt="작업 이미지"
				class="w-full max-w-lg rounded-lg border border-gray-300 shadow">
		</div>
	</c:if>

	<!-- 작성자 -->
	<div class="text-sm text-gray-500 text-right mb-6">작성자: ${farmlog.extrawriterName}</div>

	<!-- 버튼 -->
	<div class="text-center space-x-4">
		<a href="/usr/farmlog/modify?id=${farmlog.id}" class="btn btn-success">수정</a>
		<a href="/usr/farmlog/doDelete?id=${farmlog.id}" onclick="return confirm('정말 삭제하시겠습니까?');" class="btn btn-error">
			삭제 </a>
		<a href="/usr/farmlog/list" class="btn btn-outline">목록</a>
	</div>

</div>
