<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MYPAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="mt-24 px-4">
	<div class="max-w-3xl mx-auto text-base bg-white rounded-lg shadow-lg p-6">
		<h1 class="text-3xl font-extrabold text-center text-green-700 mb-8">회원정보 수정</h1>

		<table class="w-full border rounded-lg overflow-hidden text-sm md:text-base">
			<tbody>
				<tr class="border-b">
					<th class="bg-green-50 text-left px-4 py-3 font-semibold text-green-900 w-40">가입일</th>
					<td class="px-4 py-3 text-gray-800">${rq.loginedMember.regDate}</td>
				</tr>
				<tr class="border-b">
					<th class="bg-green-50 text-left px-4 py-3 font-semibold text-green-900">아이디</th>
					<td class="px-4 py-3 text-gray-800">${rq.loginedMember.loginId}</td>
				</tr>
				<tr class="border-b">
					<th class="bg-green-50 text-left px-4 py-3 font-semibold text-green-900">이름</th>
					<td class="px-4 py-3 text-gray-800">${rq.loginedMember.name}</td>
				</tr>
				<tr class="border-b">
					<th class="bg-green-50 text-left px-4 py-3 font-semibold text-green-900">닉네임</th>
					<td class="px-4 py-3 text-gray-800">${rq.loginedMember.nickname}</td>
				</tr>
				<tr class="border-b">
					<th class="bg-green-50 text-left px-4 py-3 font-semibold text-green-900">이메일</th>
					<td class="px-4 py-3 text-gray-800">${rq.loginedMember.email}</td>
				</tr>
				<tr>
					<th class="bg-green-50 text-left px-4 py-3 font-semibold text-green-900">전화번호</th>
					<td class="px-4 py-3 text-gray-800">${rq.loginedMember.cellphoneNum}</td>
				</tr>
			</tbody>
		</table>

		<div class="flex flex-col md:flex-row justify-center md:justify-end gap-3 mt-6">
			<a href="/usr/member/modify" class="btn bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-lg shadow">수정하기</a>
			<button type="button" onclick="history.back();"
				class="btn bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-2 rounded-lg shadow">뒤로가기</button>
		</div>
	</div>
</section>

<%@ include file="../common/foot.jspf"%>
