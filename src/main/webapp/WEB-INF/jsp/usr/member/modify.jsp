<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MEMBER MODIFY"></c:set>
<%@ include file="../common/head.jspf"%>
<hr />

<!-- ✅ 카카오 주소 API 스크립트 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
	function MemberModify__submit(form) {
		form.loginPw.value = form.loginPw.value.trim();

		if (form.loginPw.value.length > 0) {
			form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
			if (form.loginPwConfirm.value == 0) {
				alert('비번 확인 써');
				return;
			}
			if (form.loginPwConfirm.value != form.loginPw.value) {
				alert('비번 불일치');
				return;
			}
		}
		form.submit();
	}

	// ✅ 주소 자동 입력
	function execDaumPostcode() {
		new daum.Postcode(
				{
					oncomplete : function(data) {
						document.getElementById('postcode').value = data.zonecode;
						document.getElementById("roadAddress").value = data.roadAddress;
						document.getElementById("jibunAddress").value = data.jibunAddress;
						document.getElementById("extraAddress").value = data.bname
								+ (data.buildingName ? ', ' + data.buildingName
										: '');
						document.getElementById("detailAddress").focus();
					}
				}).open();
	}
</script>

<body class="bg-[#A7C399] min-h-screen flex flex-col">
	<section class="flex-grow flex justify-center px-4 py-10">
		<div class="bg-white w-full max-w-3xl rounded-lg shadow-lg p-8">
			<h1 class="text-2xl font-bold text-green-700 mb-8 text-center">회원 정보 수정</h1>

			<form onsubmit="MemberModify__submit(this); return false;" action="../member/doModify" method="POST">
				<table class="w-full border rounded-lg text-sm">
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
							<th class="bg-green-100 px-4 py-3 text-left">새 비밀번호</th>
							<td class="px-4 py-3">
								<input name="loginPw" type="text" placeholder="새 비밀번호를 입력해" class="input input-bordered w-full max-w-xs"
									autocomplete="off" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">새 비밀번호 확인</th>
							<td class="px-4 py-3">
								<input name="loginPwConfirm" type="text" placeholder="새 비밀번호확인을 입력해"
									class="input input-bordered w-full max-w-xs" autocomplete="off" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">이름</th>
							<td class="px-4 py-3">
								<input name="name" type="text" placeholder="이름 입력해" value="${rq.loginedMember.name}"
									class="input input-bordered w-full max-w-xs" autocomplete="off" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">닉네임</th>
							<td class="px-4 py-3">
								<input name="nickname" type="text" placeholder="닉네임 입력해" value="${rq.loginedMember.nickname}"
									class="input input-bordered w-full max-w-xs" autocomplete="off" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">이메일</th>
							<td class="px-4 py-3">
								<input name="email" type="text" placeholder="이메일을 입력해" value="${rq.loginedMember.email}"
									class="input input-bordered w-full max-w-xs" autocomplete="off" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">전화번호</th>
							<td class="px-4 py-3">
								<input name="cellphoneNum" type="text" placeholder="전화번호를 입력해" value="${rq.loginedMember.cellphoneNum}"
									class="input input-bordered w-full max-w-xs" autocomplete="off" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">주소 검색</th>
							<td class="px-4 py-3">
								<button type="button" onclick="execDaumPostcode()" class="btn btn-sm btn-outline">주소 검색</button>
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">우편번호</th>
							<td class="px-4 py-3">
								<input name="postcode" id="postcode" type="text" readonly value="${rq.loginedMember.postcode}"
									class="input input-bordered w-full max-w-xs" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">도로명 주소</th>
							<td class="px-4 py-3">
								<input name="roadAddress" id="roadAddress" type="text" readonly value="${rq.loginedMember.roadAddress}"
									class="input input-bordered w-full max-w-xs" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">지번 주소</th>
							<td class="px-4 py-3">
								<input name="jibunAddress" id="jibunAddress" type="text" readonly value="${rq.loginedMember.jibunAddress}"
									class="input input-bordered w-full max-w-xs" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">참고항목</th>
							<td class="px-4 py-3">
								<input name="extraAddress" id="extraAddress" type="text" readonly value="${rq.loginedMember.extraAddress}"
									class="input input-bordered w-full max-w-xs" />
							</td>
						</tr>
						<tr class="border-b">
							<th class="bg-green-100 px-4 py-3 text-left">상세주소</th>
							<td class="px-4 py-3">
								<input name="detailAddress" id="detailAddress" type="text" placeholder="예: 101동 1203호"
									value="${rq.loginedMember.detailAddress}" class="input input-bordered w-full max-w-xs" />
							</td>
						</tr>
						<tr>
							<th class="bg-green-100 px-4 py-3 text-left"></th>
							<td class="px-4 py-3">
								<button class="btn btn-primary w-full max-w-xs">수정</button>
							</td>
						</tr>
					</tbody>
				</table>
			</form>

			<div class="mt-6 flex justify-center">
				<button class="btn" type="button" onclick="history.back()">뒤로가기</button>
			</div>
		</div>
	</section>
</body>

<%@ include file="../common/foot.jspf"%>
