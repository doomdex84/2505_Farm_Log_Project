<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MEMBER JOIN"></c:set>
<%@ include file="../common/head.jspf"%>

<!-- lodash debounce -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

<script>
  let validLoginId = "";

  $(function () {
    // 아이디 입력 시 한글/특수문자 제거
    $('#loginId').on('input', function () {
      const val = this.value;
      const regex = /^[A-Za-z0-9]*$/;

      if (!regex.test(val)) {
        alert('아이디는 영문자와 숫자만 입력할 수 있습니다.');
        this.value = val.replace(/[^A-Za-z0-9]/g, '');
      }
    });

    // 비밀번호 한글 입력 방지
    $('#loginPw, #loginPwConfirm').on('input', function () {
      this.value = this.value.replace(/[ㄱ-ㅎ가-힣]/g, '');
    });

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
    
 // ✅ 전화번호 숫자만 입력 + 11자리 제한
    $('input[name="cellphoneNum"]').on('input', function () {
      this.value = this.value.replace(/[^0-9]/g, '').slice(0, 11);
    });
  });

  // 비밀번호 유효성 검사 함수
  function validatePassword(pw) {
    const pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,15}$/;
    return pwRegex.test(pw);
  }

  // 아이디 중복 확인 함수
  function checkLoginIdDup(el) {
    $('.checkDup-msg').empty();
    const form = $(el).closest('form').get(0);
    const loginId = form.loginId.value.trim();

    const idRegex = /^[A-Za-z0-9]+$/;
    if (!idRegex.test(loginId)) {
      $('.checkDup-msg').html('<div style="color:red;">아이디는 영문자와 숫자만 입력해야 합니다.</div>');
      validLoginId = '';
      return;
    }

    $.get('../member/getLoginIdDup', {
      isAjax: 'Y',
      loginId: loginId
    }, function(data) {
      $('.checkDup-msg').html('<div>' + data.msg + '</div>');
      validLoginId = data.success ? data.data1 : '';
    }, 'json');
  }

  const checkLoginIdDupDebounced = _.debounce(checkLoginIdDup, 600);

  // 회원가입 제출
  function JoinForm__submit(form) {
    const fields = ['loginId', 'loginPw', 'loginPwConfirm', 'name', 'nickname', 'email', 'cellphoneNum'];
    for (const field of fields) {
      form[field].value = form[field].value.trim();
      if (!form[field].value) {
        alert(field + ' 입력해주세요');
        form[field].focus();
        return;
      }
    }

    if (!/^[A-Za-z0-9]+$/.test(form.loginId.value)) {
      alert('아이디는 영문자와 숫자만 입력해야 합니다.');
      form.loginId.focus();
      return;
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
    
    if (!/^010\d{8}$/.test(form.cellphoneNum.value)) {
    	  alert('전화번호는 010으로 시작하는 11자리 숫자여야 합니다.');
    	  form.cellphoneNum.focus();
    	  return;
    	}


    form.submit();
  }
</script>

<!-- 다음 주소 API -->
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

        const guideTextBox = document.getElementById("guide");
        if(data.autoRoadAddress) {
            const expRoadAddr = data.autoRoadAddress + extraRoadAddr;
            guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
            guideTextBox.style.display = 'block';
        } else if(data.autoJibunAddress) {
            const expJibunAddr = data.autoJibunAddress;
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
<section class="max-w-3xl mx-auto mt-12 px-6 py-10 bg-white shadow-xl rounded-xl">
	<h2 class="text-3xl font-bold text-center text-green-700 mb-8">회원가입</h2>
	<form action="../member/doJoin" method="POST" onsubmit="JoinForm__submit(this); return false;">
		<div class="grid grid-cols-1 gap-6">
			<!-- 아이디 -->
			<div>
				<label class="block text-sm font-medium mb-1">아이디</label>
				<input name="loginId" onkeyup="checkLoginIdDupDebounced(this);" class="input input-bordered w-full" type="text"
					placeholder="아이디 입력" autocomplete="off" />
				<div class="checkDup-msg text-sm mt-1"></div>
			</div>

			<!-- 비밀번호 -->
			<div>
				<label class="block text-sm font-medium mb-1">비밀번호</label>
				<input id="loginPw" name="loginPw" class="input input-bordered w-full" type="password" placeholder="비밀번호 입력"
					autocomplete="off" />
				<div id="pwValidationMsg" class="text-sm mt-1"></div>
			</div>

			<!-- 비밀번호 확인 -->
			<div>
				<label class="block text-sm font-medium mb-1">비밀번호 확인</label>
				<input id="loginPwConfirm" name="loginPwConfirm" class="input input-bordered w-full" type="password"
					placeholder="비밀번호 확인 입력" autocomplete="off" />
				<div id="pwMatchMsg" class="text-sm mt-1"></div>
			</div>

			<!-- 이름 -->
			<div>
				<label class="block text-sm font-medium mb-1">이름</label>
				<input name="name" class="input input-bordered w-full" type="text" placeholder="이름 입력" />
			</div>

			<!-- 닉네임 -->
			<div>
				<label class="block text-sm font-medium mb-1">닉네임</label>
				<input name="nickname" class="input input-bordered w-full" type="text" placeholder="닉네임 입력" />
			</div>

			<!-- 전화번호 -->
			<div>
				<label class="block text-sm font-medium mb-1">전화번호</label>
				<div class="flex flex-col sm:flex-row gap-2">
					<select name="telCompany" class="select select-bordered w-full sm:w-auto">
						<option value="">통신사 선택</option>
						<option value="SKT">SKT</option>
						<option value="KT">KT</option>
						<option value="LGU+">LGU+</option>
					</select>
					<input name="cellphoneNum" class="input input-bordered w-full" type="text" placeholder="전화번호 입력" />
				</div>
			</div>

			<!-- 이메일 -->
			<div>
				<label class="block text-sm font-medium mb-1">이메일</label>
				<input name="email" class="input input-bordered w-full" type="text" placeholder="이메일 입력" />
			</div>

			<!-- 주소 -->
			<div>
				<label class="block text-sm font-medium mb-1">주소</label>
				<div class="space-y-2">
					<!-- 우편번호 + 버튼 -->
					<div class="flex gap-2">
						<input class="input input-bordered w-40" type="text" name="postcode" id="sample4_postcode" placeholder="우편번호"
							readonly />
						<button type="button" class="btn btn-outline btn-sm" onclick="sample4_execDaumPostcode()">우편번호 찾기</button>
					</div>

					<!-- 도로명주소 -->
					<input class="input input-bordered w-full" type="text" name="roadAddress" id="sample4_roadAddress"
						placeholder="도로명주소" readonly />

					<!-- 지번주소 -->
					<input class="input input-bordered w-full" type="text" name="jibunAddress" id="sample4_jibunAddress"
						placeholder="지번주소" readonly />

					<!-- 안내문구 -->
					<span id="guide" class="text-sm text-gray-500" style="display: none;"></span>

					<!-- 상세주소 -->
					<input class="input input-bordered w-full" type="text" name="detailAddress" id="sample4_detailAddress"
						placeholder="상세주소" />

					<!-- 참고항목 -->
					<input class="input input-bordered w-full" type="text" name="extraAddress" id="sample4_extraAddress"
						placeholder="참고항목" readonly />
				</div>
			</div>
		</div>

		<!-- 버튼 -->
		<div class="mt-8 flex justify-center gap-4">
			<button type="submit" class="btn btn-primary w-32">가입</button>
			<button type="button" class="btn btn-outline w-32" onclick="history.back();">뒤로가기</button>
		</div>
	</form>
</section>


<%@ include file="../common/foot.jspf"%>
