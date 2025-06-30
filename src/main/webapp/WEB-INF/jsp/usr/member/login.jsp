<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MEMBER LOGIN"></c:set>
<%@ include file="../common/head.jspf"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Farm Log - Login</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
      const inputs = document.querySelectorAll("input");

      inputs.forEach(input => {
        const label = input.previousElementSibling;
        input.addEventListener("focus", () => {
          label.style.display = "none";
        });
        input.addEventListener("blur", () => {
          if (!input.value) {
            label.style.display = "block";
          }
        });
      });
    });

    function togglePassword() {
      const pwField = document.getElementById('loginPw');
      pwField.type = pwField.type === 'password' ? 'text' : 'password';
    }
  </script>
</head>
<body>
	<div class="relative mx-auto w-full max-w-[500px] min-h-screen bg-white px-4">
		<main class="flex flex-col items-center pt-12">
			<div class="w-full flex justify-center py-6">
				<img src="${pageContext.request.contextPath}/resources/img/logo.png" alt="Farm Log"
					class="h-[100px] w-auto object-contain" />
			</div>


			<section class="flex flex-col items-center w-full max-w-[475px]">
				<form class="w-full" action="../member/doLogin" method="POST">
					<input type="hidden" name="afterLoginUri" value="${param.afterLoginUri}" />

					<div class="relative mb-5 w-full">
						<label for="loginId" class="absolute left-3 text-lg text-black opacity-45 top-[18px] z-[1]">아이디</label>
						<input id="loginId" name="loginId" type="text"
							class="rounded-md border border-black bg-white h-[50px] w-full px-3 pt-2" required />
					</div>

					<div class="relative mb-5 w-full">
						<label for="loginPw" class="absolute text-lg text-black left-3 opacity-45 top-[18px] z-[1]">비밀번호</label>
						<input id="loginPw" name="loginPw" type="password"
							class="rounded-md border border-black bg-white h-[50px] w-full px-3 pt-2" required />
						<button type="button" onclick="togglePassword()" class="absolute right-3 top-[14px] text-sm text-gray-600">보기</button>
					</div>

					<div class="mb-6 w-full">
						<button type="submit" class="text-xl text-black rounded-md border border-black bg-gray-100 h-[50px] w-full">
							로그인</button>
					</div>

					<div class="text-center text-sm text-gray-600">
						비밀번호를 잊으셨나요?
						<a href="/usr/member/findLoginPw" class="text-blue-600 font-semibold hover:underline">비밀번호 찾기</a>
					</div>

					<div class="text-center text-sm text-gray-600 mt-4">
						아직 회원이 아니신가요?
						<a href="/usr/member/join" class="text-blue-600 font-semibold hover:underline">회원가입 하기</a>
					</div>
				</form>
			</section>
		</main>
	</div>
</body>
</html>
