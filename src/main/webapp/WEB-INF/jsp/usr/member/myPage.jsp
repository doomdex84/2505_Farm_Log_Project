<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MYPAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="mt-24 px-4">
	<div class="max-w-3xl mx-auto text-base">
		<table class="w-full border border-gray-300 text-base">
			<h1 class="text-2xl font-bold mb-6 text-center">회원정보 수정</h1>
			<tbody>
				<tr class="border-b">
					<th class="bg-gray-100 text-left px-4 py-3 w-40">가입일</th>
					<td class="text-center px-4 py-3">${rq.loginedMember.regDate}</td>
				</tr>
				<tr class="border-b">
					<th class="bg-gray-100 text-left px-4 py-3">아이디</th>
					<td class="text-center px-4 py-3">${rq.loginedMember.loginId}</td>
				</tr>
				<tr class="border-b">
					<th class="bg-gray-100 text-left px-4 py-3">이름</th>
					<td class="text-center px-4 py-3">${rq.loginedMember.name}</td>
				</tr>
				<tr class="border-b">
					<th class="bg-gray-100 text-left px-4 py-3">닉네임</th>
					<td class="text-center px-4 py-3">${rq.loginedMember.nickname}</td>
				</tr>
				<tr class="border-b">
					<th class="bg-gray-100 text-left px-4 py-3">이메일</th>
					<td class="text-center px-4 py-3">${rq.loginedMember.email}</td>
				</tr>
				<tr class="border-b">
					<th class="bg-gray-100 text-left px-4 py-3">전화번호</th>
					<td class="text-center px-4 py-3">${rq.loginedMember.cellphoneNum}</td>
				</tr>

			</tbody>
		</table>

		<div class="flex justify-end space-x-3 mt-6">
			<button class="btn btn-primary text-base px-6 py-2">수정하기</button>
			<button class="btn btn-error text-base px-6 py-2" type="button" onclick="history.back();">뒤로가기</button>
		</div>
	</div>
</section>

<%@ include file="../common/foot.jspf"%>
