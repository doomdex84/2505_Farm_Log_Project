<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE WRITE"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/toastUiEditorLib.jspf"%>

<script type="text/javascript">
	function ArticleWrite__submit(form) {
		form.title.value = form.title.value.trim();

		if (form.title.value.length == 0) {
			alert('제목을 입력하세요');
			return;
		}

		const editor = $(form).find('.toast-ui-editor').data(
				'data-toast-editor');
		const markdown = editor.getMarkdown().trim();

		if (markdown.length == 0) {
			alert('내용을 입력하세요');
			return;
		}

		if (form.boardId.value == '3') {
			const tradeType = form.tradeType.value;
			const price = form.price.value;

			if (!tradeType) {
				alert('거래 유형을 선택하세요');
				return;
			}

			if ((tradeType === '판매' || tradeType === '구매')
					&& (!price || price <= 0)) {
				alert('가격을 입력하세요');
				return;
			}
		}

		form.body.value = markdown;
		form.submit();
	}

	$(document).ready(function() {
		$('select[name="boardId"]').change(function() {
			if ($(this).val() == '3') {
				$('#marketFields').removeClass('hidden');
			} else {
				$('#marketFields').addClass('hidden');
				$('#marketFields').find('input, select').val('');
				$('#priceField').addClass('hidden');
			}
		});

		$('select[name="tradeType"]').change(function() {
			const tradeType = $(this).val();
			if (tradeType === '판매' || tradeType === '구매') {
				$('#priceField').removeClass('hidden');
			} else {
				$('#priceField').addClass('hidden');
				$('input[name="price"]').val('');
			}
		});
	});
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
					<c:if test="${loginedMember.authLevel >= 7}">
						<option value="1">공지사항</option>
					</c:if>
					<option value="3">장터게시판</option>
					<option value="4">QnA</option>
				</select>
			</div>

			<div id="marketFields" class="hidden">
				<div class="mb-6">
					<label class="block mb-2 font-semibold">거래 유형</label>
					<select name="tradeType" class="select select-bordered w-full text-base p-2">
						<option value="" disabled selected>거래 유형 선택</option>
						<option value="판매">판매</option>
						<option value="구매">구매</option>
						<option value="나눔">나눔</option>
						<option value="물물교환">물물교환</option>
					</select>
				</div>
				<div id="priceField" class="mb-6 hidden">
					<label class="block mb-2 font-semibold">가격</label>
					<input type="number" name="price" class="input input-bordered w-full text-base p-3" min="0"
						placeholder="가격을 입력해주세요" />
				</div>
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
