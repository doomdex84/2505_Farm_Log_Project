<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="LOGIN - 비밀번호 찾기"></c:set>
<%@ include file="../common/head.jspf"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${pageTitle}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://cdn.tailwindcss.com"></script>
<script>
	function MemberFindLoginPw__submit(form) {
		form.loginId.value = form.loginId.value.trim();
		form.email.value = form.email.value.trim();

		if (form.loginId.value.length === 0) {
			alert('아이디를 입력해주세요.');
			form.loginId.focus();
			return false;
		}
		if (form.email.value.length === 0) {
			alert('이메일을 입력해주세요.');
			form.email.focus();
			return false;
		}

		alert('메일로 임시 비밀번호를 발송했습니다.');
		return true;
	}
</script>
</head>
<body class="min-h-screen bg-[#A7C399]">

	<main class="flex justify-center items-center min-h-[80vh] px-4">
		<div class="w-full max-w-md bg-white rounded-xl shadow-lg p-8">
			<h1 class="text-2xl font-bold text-center mb-6">비밀번호 찾기</h1>

			<form action="../member/doFindLoginPw" method="POST" onsubmit="return MemberFindLoginPw__submit(this);">
				<input type="hidden" name="afterFindLoginPwUri" value="${param.afterFindLoginPwUri}" />

				<div class="mb-4">
					<label for="loginId" class="block text-sm font-medium text-gray-700 mb-1">아이디</label>
					<input type="text" id="loginId" name="loginId"
						class="input input-bordered w-full max-w-xs px-3 py-2 border rounded-md" placeholder="아이디를 입력해주세요"
						autocomplete="off" />
				</div>

				<div class="mb-4">
					<label for="email" class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
					<input type="text" id="email" name="email" class="input input-bordered w-full max-w-xs px-3 py-2 border rounded-md"
						placeholder="이메일을 입력해주세요" autocomplete="off" />
				</div>

				<div class="mt-6">
					<button type="submit" class="btn btn-primary w-full">임시 비밀번호 발송</button>
				</div>
			</form>

			<div class="mt-4 flex justify-between">
				<a href="../member/login" class="text-sm text-blue-600 hover:underline">로그인 페이지로</a>
				<button onclick="history.back();" class="text-sm text-gray-600 hover:underline">뒤로가기</button>
			</div>
		</div>
	</main>

	<%@ include file="../common/foot.jspf"%>
</body>
</html>
