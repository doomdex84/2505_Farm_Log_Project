<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.code } LIST"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="mt-24 text-xl px-4 bg-[#A7C399] min-h-screen">
	<div class="max-w-5xl mx-auto">

		<!-- 위쪽 글쓰기 버튼 -->
		<c:if test="${param.boardId == 3}">
			<div class="flex justify-end mb-4">
				<form method="get" action="./list" class="flex gap-2">
					<input type="hidden" name="boardId" value="${param.boardId}" />
					<select name="tradeType" onchange="this.form.submit()" class="rounded px-2 py-1 border">
						<option value="">전체</option>
						<option value="판매" ${param.tradeType == '판매' ? 'selected' : ''}>판매</option>
						<option value="구매" ${param.tradeType == '구매' ? 'selected' : ''}>구매</option>
						<option value="나눔" ${param.tradeType == '나눔' ? 'selected' : ''}>나눔</option>
						<option value="물물교환" ${param.tradeType == '물물교환' ? 'selected' : ''}>물물교환</option>
					</select>
				</form>
			</div>
		</c:if>

		<!-- 게시글 개수 + 검색 -->
		<div class="mb-4 flex items-center">
			<div>${articlesCount}개</div>
			<div class="flex-grow"></div>
			<form action="">
				<input type="hidden" name="boardId" value="${param.boardId}" />
				<div class="flex space-x-2">
					<select class="select select-sm select-bordered" name="searchKeywordTypeCode"
						data-value="${param.searchKeywordTypeCode}">
						<option value="title">title</option>
						<option value="body">body</option>
						<option value="title,body">title+body</option>
						<option value="nickname">nickname</option>
					</select>
					<label class="input input-bordered input-sm flex items-center gap-2">
						<input type="text" placeholder="Search" name="searchKeyword" value="${param.searchKeyword}" />
						<button type="submit">
							<i class="fa-solid fa-magnifying-glass text-sm"></i>
						</button>
					</label>
				</div>
			</form>
		</div>

		<!-- 테이블 본문 -->
		<div class="overflow-x-auto bg-white rounded shadow">
			<table class="table table-zebra w-full text-sm">
				<thead class="bg-gray-100 text-gray-700 text-sm">
					<tr>
						<th class="text-center">ID</th>
						<th class="text-center">Date</th>
						<th class="text-center">Title</th>
						<th class="text-center">Writer</th>
						<th class="text-center">Views</th>
						<th class="text-center">Like</th>
						<th class="text-center">Dislike</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="article" items="${articles}">
						<tr class="hover:bg-gray-100">
							<td class="text-center">${article.id}</td>
							<td class="text-center">${article.regDate.substring(0,10)}</td>
							<td class="text-center truncate max-w-xs overflow-hidden text-ellipsis whitespace-nowrap">
								<c:choose>
									<%-- QnA 게시판이고 비공개 대상일 경우 제목 숨김 --%>
									<c:when test="${article.boardId == 4 && article.memberId != loginedMember.id && loginedMember.authLevel < 7}">
										<span class="text-gray-500">🔒 비공개글입니다</span>
									</c:when>
									<c:otherwise>
										<a class="hover:underline" href="detail?id=${article.id}">
											<c:choose>
												<c:when test="${article.tradeType == '판매'}">
													<span class="text-red-500 font-bold">[판매]</span>
												</c:when>
												<c:when test="${article.tradeType == '구매'}">
													<span class="text-blue-500 font-bold">[구매]</span>
												</c:when>
												<c:when test="${article.tradeType == '나눔'}">
													<span class="text-green-600 font-bold">[나눔]</span>
												</c:when>
												<c:when test="${article.tradeType == '물물교환'}">
													<span class="text-purple-500 font-bold">[물물교환]</span>
												</c:when>
												<c:otherwise>
													<c:if test="${not empty article.tradeType}">
														<span class="text-gray-500 font-bold">[${article.tradeType}]</span>
													</c:if>
												</c:otherwise>
											</c:choose>
											${article.title}
											<c:if test="${article.price > 0}">
												- ${article.price}원
											</c:if>
											<c:if test="${article.extra__repliesCount > 0}">
												<span class="text-red-500">[${article.extra__repliesCount}]</span>
											</c:if>
										</a>
									</c:otherwise>
								</c:choose>
							</td>
							<td class="text-center">${article.extra__writer}</td>
							<td class="text-center">${article.hitCount}</td>
							<td class="text-center">${article.goodReactionPoint}</td>
							<td class="text-center">${article.badReactionPoint}</td>
						</tr>
					</c:forEach>
					<c:if test="${empty articles}">
						<tr>
							<td colspan="7" class="text-center text-gray-400">게시글이 없습니다</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>

		<!-- 아래쪽 글쓰기 버튼 -->
		<div class="flex justify-end mt-4">
			<a href="write?boardId=${param.boardId}" class="btn btn-sm btn-primary">글쓰기</a>
		</div>

		<!-- 페이징 -->
		<div class="flex justify-center mt-6">
			<div class="btn-group join">
				<c:forEach begin="1" end="${pagesCount}" var="i">
					<a class="join-item btn btn-sm ${param.page == i ? 'btn-active' : ''}" href="?page=${i}&boardId=${param.boardId}">
						${i} </a>
				</c:forEach>
			</div>
		</div>
	</div>
</section>
