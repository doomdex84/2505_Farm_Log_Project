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

<section class="mt-24 text-xl px-4">
	<div class="mx-auto">
		<form onsubmit="MemberModify__submit(this); return false;" action="../member/doModify" method="POST">
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>
					<tr>
						<th>가입일</th>
						<td style="text-align: center;">${rq.loginedMember.regDate }</td>
					</tr>
					<tr>
						<th>아이디</th>
						<td style="text-align: center;">${rq.loginedMember.loginId }</td>
					</tr>
					<tr>
						<th>새 비밀번호</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-primary input-sm w-full max-w-xs" name="loginPw" autocomplete="off"
								type="text" placeholder="새 비밀번호를 입력해" />
						</td>
					</tr>
					<tr>
						<th>새 비밀번호 확인</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-primary input-sm w-full max-w-xs" name="loginPwConfirm"
								autocomplete="off" type="text" placeholder="새 비밀번호확인을 입력해" />
						</td>
					</tr>
					<tr>
						<th>이름</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-primary input-sm w-full max-w-xs" name="name" autocomplete="off"
								type="text" placeholder="이름 입력해" value="${rq.loginedMember.name }" />
						</td>
					</tr>
					<tr>
						<th>닉네임</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-primary input-sm w-full max-w-xs" name="nickname" autocomplete="off"
								type="text" placeholder="닉네임 입력해" value="${rq.loginedMember.nickname }" />
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-primary input-sm w-full max-w-xs" name="email" autocomplete="off"
								type="text" placeholder="이메일을 입력해" value="${rq.loginedMember.email }" />
						</td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-primary input-sm w-full max-w-xs" name="cellphoneNum" autocomplete="off"
								type="text" placeholder="전화번호를 입력해" value="${rq.loginedMember.cellphoneNum }" />
						</td>
					</tr>

					<!-- 주소 검색 버튼 -->
					<tr>
						<th>주소 검색</th>
						<td style="text-align: center;">
							<button type="button" onclick="execDaumPostcode()" class="btn btn-sm btn-outline">주소 검색</button>
						</td>
					</tr>

					<!-- 우편번호 -->
					<tr>
						<th>우편번호</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-sm w-full max-w-xs" name="postcode" id="postcode" type="text" readonly
								value="${rq.loginedMember.postcode}" />
						</td>
					</tr>

					<!-- 도로명 주소 -->
					<tr>
						<th>도로명 주소</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-sm w-full max-w-xs" name="roadAddress" id="roadAddress" type="text"
								readonly value="${rq.loginedMember.roadAddress}" />
						</td>
					</tr>

					<!-- 지번 주소 -->
					<tr>
						<th>지번 주소</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-sm w-full max-w-xs" name="jibunAddress" id="jibunAddress" type="text"
								readonly value="${rq.loginedMember.jibunAddress}" />
						</td>
					</tr>

					<!-- 참고 주소 -->
					<tr>
						<th>참고항목</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-sm w-full max-w-xs" name="extraAddress" id="extraAddress" type="text"
								readonly value="${rq.loginedMember.extraAddress}" />
						</td>
					</tr>

					<!-- 상세주소 -->
					<tr>
						<th>상세주소</th>
						<td style="text-align: center;">
							<input class="input input-bordered input-sm w-full max-w-xs" name="detailAddress" id="detailAddress" type="text"
								placeholder="예: 101동 1203호" value="${rq.loginedMember.detailAddress}" />
						</td>
					</tr>

					<tr>
						<th></th>
						<td style="text-align: center;">
							<button class="btn btn-primary">수정</button>
						</td>
					</tr>
				</tbody>
			</table>
		</form>

		<div class="btns mt-4">
			<button class="btn" type="button" onclick="history.back()">뒤로가기</button>
		</div>
	</div>
</section>

<%@ include file="../common/foot.jspf"%>
