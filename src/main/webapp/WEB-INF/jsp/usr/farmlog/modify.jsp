<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="pageTitle" value="FARMLOG MODIFY" />
<%@ include file="../common/head.jspf"%>

<section class="max-w-3xl mx-auto mt-12 p-10 bg-white rounded-xl shadow">
	<h1 class="text-2xl font-bold mb-8 text-center text-gray-700">✏️ 영농일지 수정</h1>

	<form action="/usr/farmlog/doModify" method="post">
		<input type="hidden" name="id" value="${farmlog.id}" />

		<div class="mb-4">
			<label class="block mb-2 font-semibold">작업일</label>
			<input type="date" name="workDate" value="${farmlog.workDate}" class="input input-bordered w-full" required />
		</div>

		<div class="mb-4">
			<label class="block mb-2 font-semibold">작업유형</label>
			<input type="text" name="workTypeName" value="${farmlog.workTypeName}" class="input input-bordered w-full" />
		</div>

		<div class="mb-4">
			<label class="block mb-2 font-semibold">작업내용</label>
			<textarea name="workMemo" class="textarea textarea-bordered w-full h-32">${farmlog.workMemo}</textarea>
		</div>

		<div class="text-right mt-6">
			<button type="submit" class="btn btn-primary">저장</button>
			<a href="/usr/farmlog/detail?id=${farmlog.id}" class="btn ml-2">취소</a>
		</div>
	</form>
</section>
