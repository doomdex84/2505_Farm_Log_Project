<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MYPAGE" />
<%@ include file="../common/head.jspf"%>

<body class="bg-[#A7C399] min-h-screen flex flex-col">
	<section class="flex-grow flex items-center justify-center px-4 py-12">
		<div class="bg-white w-full max-w-2xl rounded-xl shadow-xl p-10">
			<h1 class="text-3xl font-bold text-green-700 text-center mb-10">회원 정보</h1>

			<div class="space-y-4">
				<div>
					<label class="block text-sm font-semibold mb-1">가입일</label>
					<input type="text" readonly value="${rq.loginedMember.regDate}" class="input input-bordered w-full h-[48px] px-3" />
				</div>
				<div>
					<label class="block text-sm font-semibold mb-1">아이디</label>
					<input type="text" readonly value="${rq.loginedMember.loginId}" class="input input-bordered w-full h-[48px] px-3" />
				</div>
				<div>
					<label class="block text-sm font-semibold mb-1">이름</label>
					<input type="text" readonly value="${rq.loginedMember.name}" class="input input-bordered w-full h-[48px] px-3" />
				</div>
				<div>
					<label class="block text-sm font-semibold mb-1">닉네임</label>
					<input type="text" readonly value="${rq.loginedMember.nickname}" class="input input-bordered w-full h-[48px] px-3" />
				</div>
				<div>
					<label class="block text-sm font-semibold mb-1">이메일</label>
					<input type="text" readonly value="${rq.loginedMember.email}" class="input input-bordered w-full h-[48px] px-3" />
				</div>
				<div>
					<label class="block text-sm font-semibold mb-1">전화번호</label>
					<input type="text" readonly value="${rq.loginedMember.cellphoneNum}"
						class="input input-bordered w-full h-[48px] px-3" />
				</div>
				<div
					class="h-auto min-h-[3rem] w-full rounded-md border border-gray-300 bg-white-100 px-3 py-2 text-sm leading-relaxed">
					${rq.loginedMember.postcode}
					<br />
					${rq.loginedMember.roadAddress}${rq.loginedMember.detailAddress}
					<br />
					(${rq.loginedMember.jibunAddress} ${rq.loginedMember.extraAddress})
				</div>
			</div>

			<div class="mt-10 flex flex-col sm:flex-row justify-center sm:justify-end gap-4">
				<a href="../member/checkPw"
					class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-md shadow text-center">회원정보 수정</a>
				<button type="button" onclick="openWithdrawModal()"
					class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded-md shadow">회원 탈퇴</button>
				<button type="button" onclick="history.back();"
					class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-2 rounded-md shadow">뒤로가기</button>
			</div>
		</div>
	</section>

	<!-- ✅ 회원 탈퇴 비밀번호 확인 모달 -->
	<div id="withdrawModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
		<div class="bg-white rounded-xl shadow-xl p-6 w-full max-w-sm">
			<h2 class="text-xl font-semibold mb-4 text-center text-gray-800">비밀번호 확인 후 탈퇴</h2>
			<form id="withdrawForm" onsubmit="return submitWithdraw();">
				<input type="password" id="withdrawPw" name="password" placeholder="비밀번호 입력"
					class="input input-bordered w-full mb-4" required />
				<div class="flex justify-end gap-2">
					<button type="button" class="btn" onclick="closeWithdrawModal()">취소</button>
					<button type="submit" class="btn btn-error">탈퇴</button>
				</div>
			</form>
		</div>
	</div>

	<script>
		function openWithdrawModal() {
			document.getElementById("withdrawModal").classList.remove("hidden");
			document.getElementById("withdrawModal").classList.add("flex");
		}

		function closeWithdrawModal() {
			document.getElementById("withdrawModal").classList.add("hidden");
			document.getElementById("withdrawModal").classList.remove("flex");
		}

		function submitWithdraw() {
			const password = document.getElementById("withdrawPw").value.trim();
			if (password.length === 0) {
				alert("비밀번호를 입력해주세요.");
				return false;
			}

			$.post("/usr/member/doWithdraw", { password }, function(data) {
				$('body').append(data);
			});

			return false;
		}
	</script>

	<%@ include file="../common/foot.jspf"%>
</body>
