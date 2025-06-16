<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="팜로그 공개 게시판"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="min-h-screen py-10">
	<div class="max-w-6xl mx-auto grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 px-4">
		<c:forEach var="log" items="${publicLogs}">
			<div class="bg-white rounded-lg shadow hover:shadow-lg transition overflow-hidden">

				<c:if test="${not empty log.imgFileName}">
					<img src="/gen/farmlog/${log.imgFileName}" alt="썸네일" class="w-full h-48 object-cover" />
				</c:if>

				<div class="p-4">
					<h2 class="text-lg font-semibold mb-1">${log.cropName}- ${log.varietyName} - ${log.work_type_name}</h2>
					<p class="text-sm text-gray-600 truncate" title="${log.work_memo}">${log.work_memo}</p>
					<div class="flex justify-between items-center mt-2 text-xs text-gray-400">
						<span>${log.extrawriterName}</span>
						<span>${log.work_date}</span>
					</div>
					<div class="mt-2 text-right">
						<a href="/usr/farmlog/detail?id=${log.id}" class="text-green-600 font-medium hover:underline">상세보기 →</a>
					</div>
				</div>

			</div>
		</c:forEach>
	</div>
</section>

