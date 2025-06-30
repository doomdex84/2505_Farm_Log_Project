<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MEMBER MODIFY"></c:set>
<%@ include file="../common/head.jspf"%>

<!-- lodash debounce -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

<!-- 다음 주소 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
  $(function () {
    // 비밀번호 유효성 메시지
    $('#loginPw').on('input', function () {
      const msgEl = $('#pwValidationMsg');
      msgEl.text(validatePassword(this.value) ? '사용 가능한 비밀번호입니다!' : '6~15자, 대소문자와 숫자를 포함해야 합니다')
           .css('color', validatePassword(this.value) ? 'green' : 'red');
    });

    $('#loginPwConfirm').on('input', function () {
      const msgEl = $('#pwMatchMsg');
      msgEl.text(this.value === $('#loginPw').val() ? '비밀번호가 일치합니다!' : '비밀번호가 일치하지 않습니다.')
           .css('color', this.value === $('#loginPw').val() ? 'green' : 'red');
    });

    $('input[name="cellphoneNum"]').on('input', function () {
      this.value = this.value.replace(/[^0-9]/g, '').slice(0, 11);
    });

    $('#nickname').on('input', function () {
      const nickname = $(this).val().trim();
      const msgEl = $('#nicknameMsg');
      if (nickname.length >= 2 && nickname.length <= 20) {
        msgEl.text('사용 가능한 닉네임입니다.').css('color', 'green');
      } else {
        msgEl.text('닉네임은 2~20자 이내로 입력해 주세요.').css('color', 'red');
      }
    });
  });

  function validatePassword(pw) {
    const pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,15}$/;
    return pwRegex.test(pw);
  }

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

    if (form.nickname.value.length < 2 || form.nickname.value.length > 20) {
      alert('닉네임은 2~20자 이내로 입력해 주세요.');
      form.nickname.focus();
      return;
    }

    if (!/^010\d{8}$/.test(form.cellphoneNum.value)) {
      alert('전화번호는 010으로 시작하는 11자리 숫자여야 합니다.');
      form.cellphoneNum.focus();
      return;
    }

    form.submit();
  }

  function execDaumPostcode() {
    new daum.Postcode({
      oncomplete: function (data) {
        let roadAddr = data.roadAddress;
        let extraRoadAddr = '';
        if (data.bname && /[\uB3D9|\uB85C|\uAC00]$/g.test(data.bname)) extraRoadAddr += data.bname;
        if (data.buildingName && data.apartment === 'Y') extraRoadAddr += (extraRoadAddr ? ', ' + data.buildingName : data.buildingName);
        if (extraRoadAddr) extraRoadAddr = ' (' + extraRoadAddr + ')';

        document.getElementById('postcode').value = data.zonecode;
        document.getElementById('roadAddress').value = roadAddr;
        document.getElementById('jibunAddress').value = data.jibunAddress;
        document.getElementById('extraAddress').value = extraRoadAddr;
        document.getElementById('detailAddress').focus();
      }
    }).open();
  }
</script>

<section class="max-w-3xl mx-auto mt-12 px-6 py-10 bg-white shadow-xl rounded-xl">
	<h2 class="text-3xl font-bold text-center text-green-700 mb-8">회원 정보 수정</h2>
	<form action="../member/doModify" method="POST" onsubmit="MemberModify__submit(this); return false;">
		<div class="grid grid-cols-1 gap-6">
			<div>
				<label class="block text-sm font-medium mb-1">아이디</label>
				<input class="input input-bordered w-full bg-gray-100" type="text" value="${rq.loginedMember.loginId}" readonly />
			</div>
			<div>
				<label class="block text-sm font-medium mb-1">새 비밀번호</label>
				<input id="loginPw" name="loginPw" class="input input-bordered w-full" type="password" placeholder="새 비밀번호 입력"
					autocomplete="off" />
				<div id="pwValidationMsg" class="text-sm mt-1"></div>
			</div>
			<div>
				<label class="block text-sm font-medium mb-1">비밀번호 확인</label>
				<input id="loginPwConfirm" name="loginPwConfirm" class="input input-bordered w-full" type="password"
					placeholder="비밀번호 확인 입력" autocomplete="off" />
				<div id="pwMatchMsg" class="text-sm mt-1"></div>
			</div>
			<div>
				<label class="block text-sm font-medium mb-1">이름</label>
				<input name="name" class="input input-bordered w-full" type="text" value="${rq.loginedMember.name}" />
			</div>
			<div>
				<label class="block text-sm font-medium mb-1">닉네임</label>
				<input id="nickname" name="nickname" class="input input-bordered w-full" type="text"
					value="${rq.loginedMember.nickname}" />
				<div id="nicknameMsg" class="text-sm mt-1"></div>
			</div>
			<div>
				<label class="block text-sm font-medium mb-1">전화번호</label>
				<input name="cellphoneNum" class="input input-bordered w-full" type="text" value="${rq.loginedMember.cellphoneNum}" />
			</div>
			<div>
				<label class="block text-sm font-medium mb-1">이메일</label>
				<input name="email" class="input input-bordered w-full" type="text" value="${rq.loginedMember.email}" />
			</div>
			<div>
				<label class="block text-sm font-medium mb-1">주소</label>
				<div class="space-y-2">
					<div class="flex gap-2">
						<input class="input input-bordered w-40" type="text" name="postcode" id="postcode"
							value="${rq.loginedMember.postcode}" readonly />
						<button type="button" class="btn btn-outline btn-sm" onclick="execDaumPostcode()">우편번호 찾기</button>
					</div>
					<input class="input input-bordered w-full" type="text" name="roadAddress" id="roadAddress"
						value="${rq.loginedMember.roadAddress}" readonly />
					<input class="input input-bordered w-full" type="text" name="jibunAddress" id="jibunAddress"
						value="${rq.loginedMember.jibunAddress}" readonly />
					<input class="input input-bordered w-full" type="text" name="detailAddress" id="detailAddress"
						value="${rq.loginedMember.detailAddress}" placeholder="상세주소" />
					<input class="input input-bordered w-full" type="text" name="extraAddress" id="extraAddress"
						value="${rq.loginedMember.extraAddress}" readonly />
				</div>
			</div>
		</div>
		<div class="mt-8 flex justify-center gap-4">
			<button type="submit" class="btn btn-primary w-32">수정</button>
			<button type="button" class="btn btn-outline w-32" onclick="history.back();">뒤로가기</button>
		</div>
	</form>
</section>

<%@ include file="../common/foot.jspf"%>
