<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MYPAGE" />
<%@ include file="../common/head.jspf"%>

<body class="bg-[#A7C399] min-h-screen flex flex-col">
	<section class="flex-grow flex items-center justify-center px-4">
		<div class="bg-white w-full max-w-3xl rounded-lg shadow-xl p-8">
			<h1 class="text-3xl font-bold text-green-700 text-center mb-8">마이페이지</h1>

			<table class="w-full border rounded-lg text-base">
				<tbody>
					<tr class="border-b">
						<th class="bg-green-100 px-4 py-3 text-left w-1/3">가입일</th>
						<td class="px-4 py-3">${rq.loginedMember.regDate}</td>
					</tr>
					<tr class="border-b">
						<th class="bg-green-100 px-4 py-3 text-left">아이디</th>
						<td class="px-4 py-3">${rq.loginedMember.loginId}</td>
					</tr>
					<tr class="border-b">
						<th class="bg-green-100 px-4 py-3 text-left">이름</th>
						<td class="px-4 py-3">${rq.loginedMember.name}</td>
					</tr>
					<tr class="border-b">
						<th class="bg-green-100 px-4 py-3 text-left">닉네임</th>
						<td class="px-4 py-3">${rq.loginedMember.nickname}</td>
					</tr>
					<tr class="border-b">
						<th class="bg-green-100 px-4 py-3 text-left">이메일</th>
						<td class="px-4 py-3">${rq.loginedMember.email}</td>
					</tr>
					<tr>
						<th class="bg-green-100 px-4 py-3 text-left">전화번호</th>
						<td class="px-4 py-3">${rq.loginedMember.cellphoneNum}</td>
					</tr>
					<tr>
						<th class="bg-green-100 px-4 py-3 text-left">주소</th>
						<td class="px-4 py-3">
							<c:out value="${rq.loginedMember.sido}" />
							&nbsp;
							<c:out value="${rq.loginedMember.sigungu}" />
							&nbsp;
							<c:out value="${rq.loginedMember.eupmyeondong}" />
						</td>

					</tr>

				</tbody>
			</table>

			<div class="mt-8 flex flex-col sm:flex-row justify-center sm:justify-end gap-3">
				<a href="../member/checkPw"
					class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-md shadow text-center">회원정보 수정</a>
				<button type="button" onclick="history.back();"
					class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-2 rounded-md shadow">뒤로가기</button>
			</div>
		</div>
	</section>

	<%@ include file="../common/foot.jspf"%>
</body>
