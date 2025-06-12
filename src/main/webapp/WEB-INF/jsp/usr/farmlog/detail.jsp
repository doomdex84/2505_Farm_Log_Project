<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="pageTitle" value="FARMLOG DETAIL" />
<%@ include file="../common/head.jspf"%>

<section class="max-w-3xl mx-auto mt-12 p-10 rounded-2xl shadow-lg bg-white">
	<h1 class="text-3xl font-bold mb-10 text-center text-gray-800">📋 영농일지 상세보기</h1>

	<table class="table-auto w-full border border-gray-300">
		<tbody>
			<tr class="border-b">
				<th class="bg-gray-100 p-3 text-left w-1/4">작성자</th>
				<td class="p-3">${farmlog.extra__writerName}</td>
			</tr>
			<tr class="border-b">
				<th class="bg-gray-100 p-3 text-left">작업일</th>
				<td class="p-3">${farmlog.workDate}</td>
			</tr>
			<tr class="border-b">
				<th class="bg-gray-100 p-3 text-left">날씨</th>
				<td class="p-3">${farmlog.weather}</td>
			</tr>
			<tr class="border-b">
				<th class="bg-gray-100 p-3 text-left">품목</th>
				<td class="p-3">${farmlog.cropName}</td>
			</tr>
			<tr class="border-b">
				<th class="bg-gray-100 p-3 text-left">품종</th>
				<td class="p-3">${farmlog.varietyName}</td>
			</tr>
			<tr class="border-b">
				<th class="bg-gray-100 p-3 text-left">활동유형</th>
				<td class="p-3">${farmlog.workTypeName}</td>
			</tr>
			<tr class="border-b">
				<th class="bg-gray-100 p-3 text-left">작업유형</th>
				<td class="p-3">${farmlog.workType}</td>
			</tr>
			<tr class="border-b">
				<th class="bg-gray-100 p-3 text-left">작업내용</th>
				<td class="p-3 whitespace-pre-wrap">${farmlog.workMemo}</td>
			</tr>
			<tr class="border-b">
				<th class="bg-gray-100 p-3 text-left">다음 일정</th>
				<td class="p-3">${farmlog.nextSchedule}</td>
			</tr>
			<c:if test="${not empty farmlog.imgFileName}">
				<tr class="border-b">
					<th class="bg-gray-100 p-3 text-left">첨부 이미지</th>
					<td class="p-3">
						<img src="/uploaded/farmlog/${farmlog.imgFileName}" alt="첨부 이미지" class="max-w-md rounded shadow" />
					</td>
				</tr>
			</c:if>
		</tbody>
	</table>

	<div class="mt-6 flex justify-end space-x-4">
		<a href="/usr/farmlog/list" class="bg-gray-400 hover:bg-gray-500 text-white px-4 py-2 rounded">목록</a>
		<c:if test="${farmlog.userCanModify}">
			<a href="/usr/farmlog/modify?id=${farmlog.id}" class="bg-yellow-500 hover:bg-yellow-600 text-white px-4 py-2 rounded">수정</a>
		</c:if>
		<c:if test="${farmlog.userCanDelete}">
			<a href="/usr/farmlog/doDelete?id=${farmlog.id}" class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded">삭제</a>
		</c:if>
	</div>
</section>
