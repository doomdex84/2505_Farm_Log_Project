<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="" />
<%@ include file="../common/head.jspf"%>

<body class="bg-[#A7C399] min-h-screen flex flex-col">
	<main class="flex-grow flex items-center justify-center px-4 relative">
		<div class="absolute top-[40%] -translate-y-1/2 w-full max-w-md bg-white p-8 rounded-2xl shadow-xl">
			<h1 class="text-2xl font-bold text-center text-gray-800 mb-6">비밀번호 확인</h1>

			<form action="../member/doCheckPw" method="POST" class="space-y-5">
				<div>
					<label class="text-sm font-medium text-gray-700">아이디</label>
					<input type="text" value="${rq.loginedMember.loginId}" readonly
						class="input input-bordered w-full bg-gray-100 cursor-not-allowed" />
				</div>

				<div>
					<label class="text-sm font-medium text-gray-700">비밀번호</label>
					<input type="password" name="loginPw" placeholder="비밀번호를 입력해주세요" class="input input-bordered w-full"
						autocomplete="off" />
				</div>

				<div class="flex flex-col items-center gap-2">
					<button type="submit" class="btn btn-primary w-full">확인</button>
					<a href="javascript:history.back();" class="text-sm text-gray-500 hover:underline">뒤로가기</a>
				</div>
			</form>
		</div>
	</main>

	<%@ include file="../common/foot.jspf"%>
</body>
