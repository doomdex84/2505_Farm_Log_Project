<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="팜로그 정보 공유 게시판"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="min-h-screen py-10">

	<!-- ✅ 통합 검색 form -->
	<div class="max-w-6xl mx-auto px-4 mb-4">
		<form method="get" action="/usr/farmlog/publiclist" class="flex flex-wrap gap-2 items-center">
			<!-- 검색 유형 드롭다운 -->
			<select name="searchType" class="border rounded p-1">
				<option value="nickname" ${param.searchType == 'nickname' ? 'selected' : ''}>작성자</option>
				<option value="cropName" ${param.searchType == 'cropName' ? 'selected' : ''}>품목</option>
				<option value="varietyName" ${param.searchType == 'varietyName' ? 'selected' : ''}>품종</option>
			</select>

			<!-- 검색어 입력 -->
			<input type="text" name="searchKeyword" class="border rounded p-1" placeholder="검색어" value="${param.searchKeyword}">

			<!-- 검색 버튼 -->
			<button type="submit" class="bg-green-500 text-white rounded px-3">검색</button>
		</form>
	</div>

	<!-- ✅ Farmlog 공개글 목록 -->
	<div class="max-w-6xl mx-auto grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 px-4">
		<c:forEach var="log" items="${publicLogs}">
			<div class="bg-white rounded-lg shadow hover:shadow-lg transition overflow-hidden">

				<!-- 이미지 썸네일 -->
				<c:if test="${not empty log.imgFileName}">
					<img src="/gen/farmlog/${log.imgFileName}" alt="썸네일" class="w-full h-48 object-cover" />
				</c:if>

				<div class="p-4">
					<!-- 품목 - 품종 - 작업유형 -->
					<h2 class="text-lg font-semibold mb-1">${log.cropName}-${log.varietyName}-${log.work_type_name}</h2>

					<!-- 작업 메모 (툴팁) -->
					<p class="text-sm text-gray-600 truncate" title="${log.work_memo}">${log.work_memo}</p>

					<!-- 작성자와 작업일 -->
					<div class="flex justify-between items-center mt-2 text-xs text-gray-400">
						<span>${log.extrawriterName}</span>
						<span>${log.work_date}</span>
					</div>

					<!-- 상세보기 링크 -->
					<div class="mt-2 text-right">
						<a href="/usr/farmlog/detail?id=${log.id}" class="text-green-600 font-medium hover:underline">상세보기 →</a>
					</div>
				</div>

			</div>
		</c:forEach>
	</div>

</section>
