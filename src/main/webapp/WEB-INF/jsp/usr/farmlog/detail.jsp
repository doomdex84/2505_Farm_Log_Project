<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="pageTitle" value="영농일지 상세보기" />
<%@ include file="../common/head.jspf"%>

<div class="bg-white border border-gray-200 rounded-lg p-6 max-w-3xl mx-auto">
	<h1 class="text-3xl font-extrabold text-center text-green-700 mb-8 flex items-center justify-center gap-2">
		<span class="text-2xl">🍀</span>
		영농일지 상세보기
	</h1>

	<div class="grid grid-cols-[150px_1fr] gap-4 text-[17px] text-gray-800 mb-6">
		<div class="font-semibold text-green-800">작업일</div>
		<div class="bg-gray-50 border px-4 py-2 rounded">${farmlog.work_date}</div>

		<div class="font-semibold text-green-800">작업유형</div>
		<div class="bg-gray-50 border px-4 py-2 rounded">${farmlog.work_type_name}</div>

		<div class="font-semibold text-green-800">품목</div>
		<div class="bg-gray-50 border px-4 py-2 rounded">${farmlog.cropName}</div>

		<div class="font-semibold text-green-800">품종</div>
		<div class="bg-gray-50 border px-4 py-2 rounded">${farmlog.varietyName}</div>

		<c:if test="${not empty farmlog.nextSchedule}">
			<div class="font-semibold text-green-800">다음 예정일</div>
			<div class="bg-gray-50 border px-4 py-2 rounded text-red-600 font-semibold">${farmlog.nextSchedule}</div>
		</c:if>
	</div>

	<div class="mb-6">
		<div class="font-semibold text-green-800 mb-2">작업메모</div>
		<div class="bg-gray-50 border rounded p-4 text-sm text-gray-700 leading-relaxed">
			<pre class="whitespace-pre-wrap break-all font-normal" style="font-family: inherit;">
${farmlog.work_memo}
</pre>
		</div>
	</div>

	<c:if test="${not empty farmlog.imgFileName}">
		<div class="mb-6">
			<div class="font-semibold text-green-800 mb-2">작업 사진</div>
			<img src="/gen/farmlog/${farmlog.imgFileName}" alt="작업 이미지"
				class="w-full max-w-lg rounded-lg border border-gray-300 shadow">
		</div>
	</c:if>

	<div class="text-sm text-gray-500 text-right mb-6">작성자: ${farmlog.extrawriterName}</div>

	<div class="text-center space-x-4">
		<c:if test="${farmlog.member_id == loginedMember.id || loginedMember.authLevel >= 7}">
			<a href="/usr/farmlog/modify?id=${farmlog.id}&from=${param.from}" class="btn btn-success">수정</a>
			<a href="javascript:doDelete('${farmlog.id}', '${param.from}')" class="btn btn-error">삭제</a>
		</c:if>

		<!-- 뒤로가기: from 파라미터가 있으면 해당 위치, 없으면 history.back() -->
		<c:choose>
			<c:when test="${not empty param.from}">
				<a href="${param.from}" class="btn btn-outline">뒤로가기</a>
			</c:when>
			<c:otherwise>
				<button type="button" onclick="history.back();" class="btn btn-outline">뒤로가기</button>
			</c:otherwise>
		</c:choose>

		<c:if test="${farmlog.member_id != loginedMember.id}">
			<c:choose>
				<c:when test="${isFavorite}">
					<button id="btnFavorite" data-action="remove" class="btn btn-error">❌ 즐겨찾기 삭제</button>
				</c:when>
				<c:otherwise>
					<button id="btnFavorite" data-action="add" class="btn btn-success">⭐ 즐겨찾기 추가</button>
				</c:otherwise>
			</c:choose>
		</c:if>
	</div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
const farmlogId = "${farmlog.id}";
const fromUrl = "${param.from}";

$('#btnFavorite').click(function() {
	const action = $(this).data('action');
	const url = action === 'add' ? '/usr/favorite/add' : '/usr/favorite/delete';
	$.post(url, { farmlogId })
		.done(function(data) {
			alert(data.msg);
			location.reload();
		})
		.fail(function(xhr) {
			alert('즐겨찾기 처리 실패: ' + xhr.responseText);
		});
});

function doDelete(id, from) {
	if (confirm('정말 삭제하시겠습니까?')) {
		$.post('/usr/farmlog/doDelete', { id: id })
			.done(function(data) {
				alert('삭제되었습니다.');
				if(from){
					location.href = from;
				}else{
					history.back();
				}
			})
			.fail(function(xhr) {
				alert('삭제 실패: ' + xhr.responseText);
			});
	}
}
</script>
