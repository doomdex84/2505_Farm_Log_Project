<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MEMBER JOIN"></c:set>
<%@ include file="../common/head.jspf"%>

<!-- lodash debounce -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>
<script>
	let validLoginId = "";
	function JoinForm__submit(form) {

		form.loginId.value = form.loginId.value.trim();
		if (form.loginId.value == 0) {
			alert('아이디를 입력해주세요');
			return;
		}
		if (form.loginId.value != validLoginId) {
			alert('사용할 수 없는 아이디야');
			form.loginId.focus();
			return;
		}

		form.loginPw.value = form.loginPw.value.trim();
		if (form.loginPw.value == 0) {
			alert('비밀번호를 입력해주세요');
			return;
		}
		form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
		if (form.loginPwConfirm.value == 0) {
			alert('비밀번호 확인을 입력해주세요');
			return;
		}
		if (form.loginPwConfirm.value != form.loginPw.value) {
			alert('비밀번호가 일치하지 않습니다');
			form.loginPw.focus();
			return;
		}
		form.name.value = form.name.value.trim();
		if (form.name.value == 0) {
			alert('이름을 입력해주세요');
			return;
		}
		form.nickname.value = form.nickname.value.trim();
		if (form.nickname.value == 0) {
			alert('닉네임을 입력해주세요');
			return;
		}
		form.email.value = form.email.value.trim();
		if (form.email.value == 0) {
			alert('이메일을 입력해주세요');
			return;
		}
		form.cellphoneNum.value = form.cellphoneNum.value.trim();
		if (form.cellphoneNum.value == 0) {
			alert('전화번호를 입력해주세요');
			return;
		}
		form.submit();
	}

	function checkLoginIdDup(el) {
		$('.checkDup-msg').empty();
		const form = $(el).closest('form').get(0);
		if (form.loginId.value.length == 0) {
			validLoginId = '';
			return;
		}
		$.get('../member/getLoginIdDup', {
			isAjax : 'Y',
			loginId : form.loginId.value
		}, function(data) {
			$('.checkDup-msg').html('<div class="">' + data.msg + '</div>')
			if (data.success) {
				validLoginId = data.data1;
			} else {
				validLoginId = '';
			}
		}, 'json');
	}
	// checkLoginIdDup(); // 매번 실행
	const checkLoginIdDupDebounced = _.debounce(checkLoginIdDup, 600); // 실행 빈도 조절
</script>

<script>
	function validatePassword(pw) {
		// 대소문자 + 숫자 포함, 6~15자
		const pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,15}$/;
		return pwRegex.test(pw);
	}

	$(function() {
		// 비밀번호 유효성 체크
		$('#loginPw').on('input', function() {
			const pw = $(this).val();
			const msgEl = $('#pwValidationMsg');

			if (pw.length === 0) {
				msgEl.text('').css('color', '');
				return;
			}

			if (validatePassword(pw)) {
				msgEl.text('사용 가능한 비밀번호입니다!').css('color', 'green');
			} else {
				msgEl.text('6~15자, 대소문자와 숫자를 포함해야 합니다').css('color', 'red');
			}
		});

		// 비밀번호 확인 일치 여부 체크
		$('#loginPwConfirm').on('input', function() {
			const pw = $('#loginPw').val();
			const confirm = $(this).val();
			const msgEl = $('#pwMatchMsg');

			if (confirm.length === 0) {
				msgEl.text('').css('color', '');
				return;
			}

			if (pw === confirm) {
				msgEl.text('비밀번호가 일치합니다!').css('color', 'green');
			} else {
				msgEl.text('비밀번호가 일치하지 않습니다.').css('color', 'red');
			}
		});
	});
</script>


<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<form action="../member/doJoin" method="POST" onsubmit="JoinForm__submit(this); return false;">
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>
					<tr>
						<th>아이디</th>
						<td style="text-align: center;">
							<input onkeyup="checkLoginIdDupDebounced(this);"
								class="input input-bordered input-primary input-sm w-full max-w-xs" name="loginId" autocomplete="off"
								type="text" placeholder="아이디를 입력해" />
						</td>
					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;">
							<div class="checkDup-msg"></div>
						</td>
					</tr>

					<tr>
						<th>비밀번호</th>
						<td style="text-align: center;">
							<input id="loginPw" class="input input-primary" name="loginPw" autocomplete="off" type="password"
								placeholder="비밀번호 입력" />
							<div id="pwValidationMsg" class="text-sm mt-1"></div>
						</td>
					</tr>
					<tr>
						<th>비밀번호 확인</th>
						<td style="text-align: center;">
							<input id="loginPwConfirm" class="input input-primary" name="loginPwConfirm" autocomplete="off" type="password"
								placeholder="비밀번호 확인 입력" />
							<div id="pwMatchMsg" class="text-sm mt-1"></div>
						</td>
					</tr>

					<tr>
						<th>이름</th>
						<td style="text-align: center;">
							<input class="input input-primary" name="name" autocomplete="off" type="text" placeholder="이름 입력" />
						</td>
					</tr>
					<tr>
						<th>닉네임</th>
						<td style="text-align: center;">
							<input class="input input-primary" name="nickname" autocomplete="off" type="text" placeholder="닉네임 입력" />
						</td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td style="text-align: center;">
							<input class="input input-primary" name=cellphoneNum autocomplete="off" type="text" placeholder="전화번호 입력" />
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td style="text-align: center;">
							<input class="input input-primary" name="email" autocomplete="off" type="text" placeholder="이메일 입력" />
						</td>
					</tr>


					<tr>
						<th></th>
						<td style="text-align: center;">
							<button type="submit" class="btn btn-ghost">가입</button>
						</td>
					</tr>

				</tbody>
			</table>
		</form>
		<div class="btns">
			<button class="btn btn-ghost" type="button" onclick="history.back();">뒤로가기</button>

		</div>
	</div>
</section>


<%@ include file="../common/foot.jspf"%>