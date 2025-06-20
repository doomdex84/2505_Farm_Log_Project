<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="pageTitle" value="팜로그 정보 공유 게시판"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="min-h-screen py-10">

	<!-- ✅ 검색 폼 -->
	<div class="max-w-6xl mx-auto px-4 mb-4">
		<form method="get" action="/usr/farmlog/publiclist" class="flex flex-wrap gap-2 items-center">
			<select name="searchType" class="border rounded p-1">
				<option value="nickname" ${param.searchType == 'nickname' ? 'selected' : ''}>작성자</option>
				<option value="cropName" ${param.searchType == 'cropName' ? 'selected' : ''}>품목</option>
				<option value="varietyName" ${param.searchType == 'varietyName' ? 'selected' : ''}>품종</option>
			</select>
			<input type="text" name="searchKeyword" class="border rounded p-1" placeholder="검색어" value="${param.searchKeyword}">
			<button type="submit" class="bg-green-500 text-white rounded px-3">검색</button>
		</form>
	</div>

	<!-- ✅ 데이터 개수 표시 -->
	<div class="max-w-6xl mx-auto px-4 mb-4 text-sm text-gray-500">
		데이터 개수:
		<c:out value="${fn:length(publicLogs)}" />
	</div>

	<!-- ✅ 카드 리스트 -->
	<div class="max-w-6xl mx-auto grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 px-4">
		<c:forEach var="log" items="${publicLogs}">
			<div
				class="bg-white rounded-lg shadow hover:shadow-lg transition overflow-hidden flex flex-col min-h-[350px] border border-gray-300">

				<!-- ID 표시 (디버그용) -->
				<p class="text-xs text-red-500 p-1">ID: ${log.id}</p>

				<!-- 이미지 또는 No Image -->
				<c:choose>
					<c:when test="${not empty log.imgFileName}">
						<img src="/gen/farmlog/${log.imgFileName}" alt="썸네일" class="w-full h-48 object-cover" />
					</c:when>
					<c:otherwise>
						<div class="w-full h-48 bg-gray-100 flex items-center justify-center text-gray-400 text-sm">No Image</div>
					</c:otherwise>
				</c:choose>

				<!-- 카드 내용 -->
				<div class="p-4 flex flex-col flex-1">
					<div class="flex-grow">
						<h2 class="text-lg font-semibold mb-1">
							<c:out value="${log.cropName}" />
							-
							<c:out value="${log.varietyName}" />
							-
							<c:out value="${log.work_type_name}" />
						</h2>
						<p class="text-sm text-gray-600 truncate" title="${log.work_memo}">
							<c:out value="${log.work_memo}" />
						</p>
					</div>
					<div class="mt-2">
						<div class="flex justify-between items-center text-xs text-gray-400">
							<span>
								<c:out value="${log.extrawriterName}" />
							</span>
							<span>
								<c:out value="${log.work_date}" />
							</span>
						</div>
						<div class="mt-1 text-right">
							<a href="/usr/farmlog/detail?id=${log.id}&from=/usr/farmlog/publiclist"
								class="text-green-600 font-medium hover:underline">상세보기 →</a>

						</div>
					</div>
				</div>

			</div>
		</c:forEach>
	</div>

</section>
