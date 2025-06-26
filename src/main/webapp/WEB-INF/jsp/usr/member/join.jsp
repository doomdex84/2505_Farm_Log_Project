<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MEMBER JOIN"></c:set>
<%@ include file="../common/head.jspf"%>

<!-- lodash debounce -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>
<script>
  let validLoginId = "";
  function JoinForm__submit(form) {
    const fields = ['loginId', 'loginPw', 'loginPwConfirm', 'name', 'nickname', 'email', 'cellphoneNum'];
    for (const field of fields) {
      form[field].value = form[field].value.trim();
      if (!form[field].value) {
        alert(field + '\u0020입력해주세요');
        form[field].focus();
        return;
      }
    }
    if (form.loginId.value !== validLoginId) {
      alert('사용할 수 없는 아이디입니다.');
      form.loginId.focus();
      return;
    }
    if (form.loginPw.value !== form.loginPwConfirm.value) {
      alert('비밀번호가 일치하지 않습니다.');
      form.loginPwConfirm.focus();
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
      isAjax: 'Y',
      loginId: form.loginId.value
    }, function(data) {
      $('.checkDup-msg').html('<div>' + data.msg + '</div>');
      validLoginId = data.success ? data.data1 : '';
    }, 'json');
  }

  const checkLoginIdDupDebounced = _.debounce(checkLoginIdDup, 600);
</script>

<script>
  function validatePassword(pw) {
    const pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,15}$/;
    return pwRegex.test(pw);
  }

  $(function () {
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
  });
</script>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
  function sample4_execDaumPostcode() {
    new daum.Postcode({
      oncomplete: function (data) {
        let roadAddr = data.roadAddress;
        let extraRoadAddr = '';
        if (data.bname && /[\uB3D9|\uB85C|\uAC00]$/g.test(data.bname)) extraRoadAddr += data.bname;
        if (data.buildingName && data.apartment === 'Y') extraRoadAddr += (extraRoadAddr ? ', ' + data.buildingName : data.buildingName);
        if (extraRoadAddr) extraRoadAddr = ' (' + extraRoadAddr + ')';

        document.getElementById('sample4_postcode').value = data.zonecode;
        document.getElementById('sample4_roadAddress').value = roadAddr;
        document.getElementById('sample4_jibunAddress').value = data.jibunAddress;
        document.getElementById('sample4_extraAddress').value = extraRoadAddr;

        var guideTextBox = document.getElementById("guide");
        if(data.autoRoadAddress) {
            var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
            guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
            guideTextBox.style.display = 'block';
        } else if(data.autoJibunAddress) {
            var expJibunAddr = data.autoJibunAddress;
            guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
            guideTextBox.style.display = 'block';
        } else {
            guideTextBox.innerHTML = '';
            guideTextBox.style.display = 'none';
        }
      }
    }).open();
  }
</script>

<section class="max-w-3xl mx-auto mt-8 px-4">
	<h2 class="text-2xl font-bold text-center mb-6">회원가입</h2>
	<form action="../member/doJoin" method="POST" onsubmit="JoinForm__submit(this); return false;">
		<div class="grid grid-cols-1 gap-5">
			<div>
				<label>아이디</label>
				<input name="loginId" onkeyup="checkLoginIdDupDebounced(this);" class="input input-bordered w-full" type="text"
					placeholder="아이디 입력" autocomplete="off" />
				<div class="checkDup-msg text-sm mt-1"></div>
			</div>
			<div>
				<label>비밀번호</label>
				<input id="loginPw" name="loginPw" class="input input-bordered w-full" type="password" placeholder="비밀번호 입력"
					autocomplete="off" />
				<div id="pwValidationMsg" class="text-sm mt-1"></div>
			</div>
			<div>
				<label>비밀번호 확인</label>
				<input id="loginPwConfirm" name="loginPwConfirm" class="input input-bordered w-full" type="password"
					placeholder="비밀번호 확인 입력" autocomplete="off" />
				<div id="pwMatchMsg" class="text-sm mt-1"></div>
			</div>
			<div>
				<label>이름</label>
				<input name="name" class="input input-bordered w-full" type="text" placeholder="이름 입력" />
			</div>
			<div>
				<label>닉네임</label>
				<input name="nickname" class="input input-bordered w-full" type="text" placeholder="닉네임 입력" />
			</div>
			<div>
				<label>전화번호</label>
				<div class="flex gap-2">
					<select name="telCompany" class="select select-bordered">
						<option value="">통신사 선택</option>
						<option value="SKT">SKT</option>
						<option value="KT">KT</option>
						<option value="LGU+">LGU+</option>
					</select>
					<input name="cellphoneNum" class="input input-bordered w-full" type="text" placeholder="전화번호 입력" />
				</div>
			</div>
			<div>
				<label>이메일</label>
				<input name="email" class="input input-bordered w-full" type="text" placeholder="이메일 입력" />
			</div>
			<div>
				<label>주소</label>
				<div class="space-y-2">
					<div class="flex gap-2">
						<input class="input input-bordered w-40" type="text" name="postcode" id="sample4_postcode" placeholder="우편번호"
							readonly />
						<button type="button" class="btn btn-sm" onclick="sample4_execDaumPostcode()">우편번호 찾기</button>
					</div>
					<input class="input input-bordered w-full" type="text" name="roadAddress" id="sample4_roadAddress"
						placeholder="도로명주소" readonly />
					<input class="input input-bordered w-full" type="text" name="jibunAddress" id="sample4_jibunAddress"
						placeholder="지번주소" readonly />

					<!-- ✅ 누락되었던 guide 추가 -->
					<span id="guide" class="text-sm text-gray-500" style="display: none;"></span>

					<input class="input input-bordered w-full" type="text" name="detailAddress" id="sample4_detailAddress"
						placeholder="상세주소" />
					<input class="input input-bordered w-full" type="text" name="extraAddress" id="sample4_extraAddress"
						placeholder="참고항목" readonly />
				</div>
			</div>
		</div>
		<div class="mt-6 flex justify-center gap-4">
			<button type="submit" class="btn btn-primary">가입</button>
			<button type="button" class="btn btn-outline" onclick="history.back();">뒤로가기</button>
		</div>
	</form>
</section>

<%@ include file="../common/foot.jspf"%>
