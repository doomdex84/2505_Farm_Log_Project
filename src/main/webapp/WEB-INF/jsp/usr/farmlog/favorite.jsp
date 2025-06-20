<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="즐겨찾기 목록" />
<%@ include file="../common/head.jspf"%>

<section class="min-h-screen py-10" style="background-color: #aec8a4;">
	<div class="text-center mb-6 text-2xl font-bold">즐겨찾기 목록</div>

	<!-- ✅ 출력될 박스 컨테이너 -->
	<div id="favoriteListContainer" class="max-w-6xl mx-auto grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 px-4">
		<!-- AJAX로 출력 -->
	</div>

	<!-- ✅ 최소 출력 구조: 네모 박스 스타일로 메시지 -->
	<div id="emptyMsg" class="max-w-6xl mx-auto mt-6 hidden">
		<div class="bg-white rounded-lg shadow p-6 border text-center text-gray-500">즐겨찾기한 영농일지가 없습니다.</div>
	</div>

	<div class="mt-6 text-center">
		<button onclick="history.back()" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">뒤로가기</button>
	</div>
</section>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function() {
	$.get("/usr/farmlog/favorite/list", function(response) {
		console.log("즐겨찾기 JSON 출력: ", response); // 콘솔에 JSON 출력

		if (response.resultCode !== 'S-1') {
			$('#emptyMsg').find('div').text(response.msg || '즐겨찾기 데이터를 불러오지 못했습니다.');
			$('#emptyMsg').removeClass('hidden');
			return;
		}

		const favorites = response.favorites;
		if (!favorites || favorites.length === 0) {
			$('#emptyMsg').removeClass('hidden');
			return;
		}

		let html = '';
		favorites.forEach(farmlog => {
			html += `
				<div 
					onclick="location.href='/usr/farmlog/detail?id=${farmlog.id}'"
					class="bg-white rounded-lg shadow p-4 border cursor-pointer transform transition duration-300 hover:scale-105 hover:shadow-lg"
				>
					<p class="font-semibold text-green-700 mb-1">${farmlog.extrawriterName || '작성자 없음'}</p>
					<p class="text-xs text-gray-400 mb-1">작업일: ${farmlog.work_date || '없음'}</p>
					<p class="text-sm text-gray-600 truncate" title="${farmlog.work_memo || ''}">
						${farmlog.work_type_name || '작업유형 없음'}
					</p>
				</div>`;
		});

		$('#favoriteListContainer').html(html);
	}).fail(function() {
		console.error("AJAX 요청 실패");
		$('#emptyMsg').find('div').text('즐겨찾기 데이터를 불러오지 못했습니다.');
		$('#emptyMsg').removeClass('hidden');
	});
});
</script>
