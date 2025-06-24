<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE DETAIL"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/toastUiEditorLib.jspf"%>

<script>
	const params = {};
	params.id = parseInt('${param.id}');
	var isAlreadyAddGoodRp = ${isAlreadyAddGoodRp};
	var isAlreadyAddBadRp = ${isAlreadyAddBadRp};

	function checkRP() {
		if (isAlreadyAddGoodRp) {
			$('#likeButton').removeClass('btn-outline');
		}
		if (isAlreadyAddBadRp) {
			$('#DislikeButton').removeClass('btn-outline');
		}
	}

	function doGoodReaction(articleId) {
		$.post('/usr/reactionPoint/doGoodReaction', { relTypeCode: 'article', relId: articleId }, function(data) {
			if (data.resultCode.startsWith('S-')) {
				$('#likeButton').toggleClass('btn-outline');
				$('.likeCount').text(data.data1);
				if (data.resultCode === 'S-2') {
					$('#DislikeButton').toggleClass('btn-outline');
					$('.DislikeCount').text(data.data2);
				}
			} else {
				alert(data.msg);
			}
		}, 'json');
	}

	function doBadReaction(articleId) {
		$.post('/usr/reactionPoint/doBadReaction', { relTypeCode: 'article', relId: articleId }, function(data) {
			if (data.resultCode.startsWith('S-')) {
				$('#DislikeButton').toggleClass('btn-outline');
				$('.DislikeCount').text(data.data2);
				if (data.resultCode === 'S-2') {
					$('#likeButton').toggleClass('btn-outline');
					$('.likeCount').text(data.data1);
				}
			} else {
				alert(data.msg);
			}
		}, 'json');
	}

	$(function() {
		checkRP();
	});
</script>

<section class="mt-16 max-w-4xl mx-auto bg-white rounded shadow p-8 text-lg">
	<h1 class="text-4xl font-bold text-gray-800 mb-4">${article.title}</h1>

	<div class="text-sm text-gray-500 mb-6 flex items-center justify-between">
		<div>
			작성자:
			<span class="font-semibold text-gray-700">${article.extra__writer}</span>
		</div>
		<div>
			작성일: ${article.regDate} | 조회수:
			<span class="article-detail__hit-count">${article.hitCount}</span>
		</div>
	</div>

	<div class="prose max-w-none text-gray-900 mb-8 text-xl leading-relaxed">
		<div class="toast-ui-viewer">
			<script type="text/x-template">${article.body}</script>
		</div>
	</div>

	<div class="mt-8 flex space-x-4">
		<button id="likeButton" class="btn btn-outline btn-success" onclick="doGoodReaction(${param.id})">
			👍 LIKE
			<span class="likeCount">${article.goodReactionPoint}</span>
		</button>
		<button id="DislikeButton" class="btn btn-outline btn-error" onclick="doBadReaction(${param.id})">
			👎 DISLIKE
			<span class="DislikeCount">${article.badReactionPoint}</span>
		</button>
	</div>

	<div class="mt-6 flex space-x-2">
		<button class="btn btn-outline" onclick="history.back();">뒤로가기</button>

		<!-- ✅ 모든 게시판에서 관리자 권한으로 수정/삭제 버튼 노출 -->
		<c:if test="${article.userCanModify || loginedMember.authLevel >= 7}">
			<a class="btn btn-outline btn-primary" href="../article/modify?id=${article.id}">수정</a>
		</c:if>
		<c:if test="${article.userCanDelete || loginedMember.authLevel >= 7}">
			<a class="btn btn-outline btn-error" href="../article/doDelete?id=${article.id}"
				onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
		</c:if>
	</div>
</section>

<section class="mt-16 max-w-4xl mx-auto bg-white rounded shadow p-6">
	<c:if test="${rq.isLogined()}">
		<c:if test="${article.boardId != 4 || loginedMember.authLevel >= 7}">
			<form action="../reply/doWrite" method="POST" onsubmit="ReplyWrite__submit(this); return false;">
				<input type="hidden" name="relTypeCode" value="article" />
				<input type="hidden" name="relId" value="${article.id}" />
				<textarea name="body" class="textarea textarea-bordered w-full mb-2" placeholder="댓글을 입력하세요"></textarea>
				<div class="text-right">
					<button class="btn btn-sm btn-primary">댓글 작성</button>
				</div>
			</form>
		</c:if>
		<c:if test="${article.boardId == 4 && loginedMember.authLevel < 7}">
			<div class="text-sm text-gray-500">⚠ QnA 게시판은 관리자만 댓글을 작성할 수 있습니다.</div>
		</c:if>
	</c:if>
	<c:if test="${!rq.isLogined()}">
		댓글 작성을 위해 <a class="btn btn-outline btn-primary" href="${rq.loginUri}">로그인</a>이 필요합니다.
	</c:if>

	<table class="table w-full mt-4">
		<thead>
			<tr>
				<th>작성일</th>
				<th>작성자</th>
				<th>내용</th>
				<th>좋아요</th>
				<th>싫어요</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="reply" items="${replies}">
				<tr>
					<td>${reply.regDate.substring(0,10)}</td>
					<td>${reply.extra__writer}</td>
					<td>
						<span id="reply-${reply.id}">${reply.body}</span>
						<form method="POST" id="modify-form-${reply.id}" style="display: none;">
							<input type="text" value="${reply.body}" name="reply-text-${reply.id}" />
						</form>
					</td>
					<td>${reply.goodReactionPoint}</td>
					<td>${reply.badReactionPoint}</td>
					<td>
						<c:if test="${reply.userCanModify || loginedMember.authLevel >= 7}">
							<button onclick="toggleModifybtn('${reply.id}');" id="modify-btn-${reply.id}"
								class="btn btn-xs btn-outline btn-success">수정</button>
							<button onclick="doModifyReply('${reply.id}');" style="display: none;" id="save-btn-${reply.id}"
								class="btn btn-xs btn-outline">저장</button>
						</c:if>
					</td>
					<td>
						<c:if test="${reply.userCanDelete || loginedMember.authLevel >= 7}">
							<a class="btn btn-xs btn-outline btn-error" onclick="if(!confirm('정말 삭제하시겠습니까?')) return false;"
								href="../reply/doDelete?id=${reply.id}">삭제</a>
						</c:if>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty replies}">
				<tr>
					<td colspan="7" class="text-center text-gray-400">댓글이 없습니다.</td>
				</tr>
			</c:if>
		</tbody>
	</table>
</section>
