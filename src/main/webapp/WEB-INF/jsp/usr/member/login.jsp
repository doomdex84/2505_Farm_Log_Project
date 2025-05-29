<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MEMBER LOGIN"></c:set>
<%@ include file="../common/head.jspf"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
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
  </script>
</head>
<body style="transform: scale(0.72); transform-origin: top center;">
	<div class="relative mx-auto w-full max-w-none min-h-screen bg-white max-md:max-w-[991px] max-sm:max-w-screen-sm">
		<main class="flex flex-col items-center pt-12 max-sm:pt-8">
			<div class="mb-12">
				<img
					src="https://cdn.builder.io/api/v1/image/assets/TEMP/053754f4a05aa3325444e970d07bef34e16c7a4c?placeholderIfAbsent=true"
					alt="Farm Log"
					class="object-cover h-[237px] rounded-[115.5px] w-[237px] max-md:h-[180px] max-md:rounded-[90px] max-md:w-[180px] max-sm:h-[150px] max-sm:rounded-[75px] max-sm:w-[150px]" />
			</div>

			<section class="flex flex-col items-center w-full max-w-[475px]">
				<form class="w-full" action="../member/doLogin" method="POST">
					<div class="relative mb-5 w-full">
						<label for="loginId"
							class="absolute left-3 text-2xl text-black opacity-45 top-[18px] z-[1] max-sm:-top-5 max-sm:text-xl"> 아이디
						</label>
						<input id="loginId" name="loginId" type="text"
							class="rounded-xl border border-black border-solid bg-neutral-600 bg-opacity-0 h-[68px] w-full px-3 pt-2" />
					</div>

					<div class="relative mb-5 w-full">
						<label for="loginPw"
							class="absolute text-2xl text-black left-[18px] opacity-45 top-[18px] z-[1] max-sm:-top-5 max-sm:text-xl">
							비밀번호 </label>
						<input id="loginPw" name="loginPw" type="password"
							class="rounded-xl border border-black border-solid bg-neutral-600 bg-opacity-0 h-[68px] w-full px-3 pt-2" />
					</div>

					<div class="mb-16 w-full">
						<button type="submit"
							class="text-3xl text-black rounded-xl border border-black border-solid cursor-pointer bg-gray-200 bg-opacity-50 h-[67px] w-full max-sm:text-2xl max-sm:h-[60px]">
							로그인</button>
					</div>
				</form>

				<div class="flex relative items-center mb-16 w-full">
					<hr class="flex-grow h-px bg-black">
					<span class="mx-5 text-base text-black max-sm:text-sm"> 다른방법으로 로그인하기 </span>
					<hr class="flex-grow h-px bg-black">
				</div>


				<div class="flex flex-col gap-5 w-full">
					<!-- Google 버튼 -->
					<button class="relative flex justify-center items-center border border-black h-[57px] w-full">
						<span class="text-2xl font-semibold text-black">Google로 시작하기</span>
						<img
							src="https://cdn.builder.io/api/v1/image/assets/TEMP/b99d4e3063d0e77195555605c943c3095b35bf15?placeholderIfAbsent=true"
							alt="Google" class="absolute left-5 top-1/2 -translate-y-1/2 h-[42px] w-[43px]" />
					</button>

					<!-- Kakao 버튼 -->
					<button class="relative flex justify-center items-center border border-black h-[57px] w-full bg-[#ffeb3b]">
						<span class="text-2xl font-semibold text-black">카카오로 시작하기</span>
						<img
							src="https://cdn.builder.io/api/v1/image/assets/TEMP/6a8f3ac12595cf3a754440644989c238bea34e88?placeholderIfAbsent=true"
							alt="Kakao" class="absolute left-5 top-1/2 -translate-y-1/2 h-[42px] w-[43px]" />
					</button>

					<!-- Naver 버튼 -->
					<button class="relative flex justify-center items-center border border-black h-[57px] w-full bg-[#00c70c]">
						<span class="text-2xl font-semibold text-white">네이버로 시작하기</span>
						<img
							src="https://cdn.builder.io/api/v1/image/assets/TEMP/3fa6c5da651f054bba384f7671249a775f1a724e?placeholderIfAbsent=true"
							alt="Naver" class="absolute left-5 top-1/2 -translate-y-1/2 h-[42px] w-[43px]" />
					</button>
				</div>


			</section>
		</main>
	</div>
</body>
</html>
