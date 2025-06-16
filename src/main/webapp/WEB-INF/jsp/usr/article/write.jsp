<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE WRITE"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/toastUiEditorLib.jspf"%>

<script type="text/javascript">
	function ArticleWrite__submit(form) {
		form.title.value = form.title.value.trim();

		if (form.title.value.length == 0) {
			alert('제목 써');
			return;
		}

		const editor = $(form).find('.toast-ui-editor').data(
				'data-toast-editor');
		const markdown = editor.getMarkdown().trim();

		if (markdown.length == 0) {
			alert('내용 써');
			return;
		}

		form.body.value = markdown;
		form.submit();
	}
</script>

<section class="mt-12 px-4 text-lg">
	<div class="max-w-4xl mx-auto bg-white shadow-md rounded-xl p-8">
		<h1 class="text-2xl font-bold mb-6 text-center">게시글 작성</h1>

		<form onsubmit="ArticleWrite__submit(this); return false;" action="../article/doWrite" method="POST">
			<input type="hidden" name="body" />

			<div class="mb-6">
				<label class="block mb-2 font-semibold">게시판</label>
				<select name="boardId" required class="select select-bordered w-full text-base p-2">
					<option value="" selected disabled>게시판을 선택해주세요</option>

					<%-- ✅ 관리자만 공지사항 옵션 노출 --%>
					<c:if test="${loginedMember.authLevel >= 7}">
						<option value="1">공지사항</option>
					</c:if>

					<option value="3">장터게시판</option>
					<option value="4">QnA</option>
				</select>
			</div>

			<div class="mb-6">
				<label class="block mb-2 font-semibold">제목</label>
				<input class="input input-bordered w-full text-base p-3" required name="title" type="text" placeholder="제목을 입력해주세요" />
			</div>

			<div class="mb-6">
				<label class="block mb-2 font-semibold">내용</label>
				<div class="toast-ui-editor">
					<script type="text/x-template"></script>
				</div>
			</div>

			<div class="flex justify-end space-x-3 mt-6">
				<button class="btn btn-primary text-base px-6 py-2">작성</button>
				<button class="btn btn-error text-base px-6 py-2" type="button" onclick="history.back();">뒤로가기</button>
			</div>
		</form>
	</div>
</section>
