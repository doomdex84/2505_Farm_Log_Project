<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="pageTitle" value="북마크 영농일지 목록" />
<%@ include file="../common/head.jspf"%>

<section class="min-h-screen py-10 bg-[#c8d8b9]">
	<div class="max-w-6xl mx-auto px-4 mb-4 text-sm text-gray-700">
		북마크 개수:
		<c:out value="${fn:length(bookmarkList)}" />
	</div>

	<div class="max-w-6xl mx-auto grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 px-4">
		<c:choose>
			<c:when test="${empty bookmarkList}">
				<div class="bg-white rounded-lg shadow p-6 border text-center text-gray-500 col-span-full">북마크한 영농일지가 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="log" items="${bookmarkList}" varStatus="status">
					<a href="/usr/farmlog/detail?id=${log.farmlogId}"
						class="block bg-white rounded-lg border border-gray-300 shadow-sm transition transform hover:scale-105 hover:shadow-lg overflow-hidden">

						<div class="flex flex-col min-h-[380px]">

							<div class="p-2 text-xs text-gray-500">ID: ${log.farmlogId}</div>

							<c:choose>
								<c:when test="${not empty log.imgFileName}">
									<img src="/gen/farmlog/${log.imgFileName}" alt="썸네일" class="w-full h-52 object-cover" />
								</c:when>
								<c:otherwise>
									<div class="w-full h-52 bg-gray-100 flex items-center justify-center text-gray-400 text-sm">No Image</div>
								</c:otherwise>
							</c:choose>

							<div class="p-4">
								<h2 class="text-lg font-semibold mb-1">
									<c:out value="${log.cropName}" />
									-
									<c:out value="${log.varietyName}" />
									-
									<c:out value="${log.workTypeName}" />
								</h2>
								<p class="text-xs text-gray-400 mt-1">
									북마크일:
									<c:out value="${log.regDate}" />
								</p>
							</div>

						</div>
					</a>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>

	<div class="mt-6 text-center">
		<button onclick="history.back()" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">뒤로가기</button>
	</div>

</section>
