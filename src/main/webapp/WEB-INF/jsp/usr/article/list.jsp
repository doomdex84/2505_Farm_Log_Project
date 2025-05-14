<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.code } LIST"></c:set>
<%@ include file="../common/head.jspf"%>


<section class="mt-24 text-xl px-4">
	<div class="mx-auto">
		<div>${articlesCount }개</div>
		<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">

			<thead>
				<tr>
					<th style="text-align: center;">ID</th>
					<th style="text-align: center;">Registration Date</th>
					<th style="text-align: center;">Title</th>
					<th style="text-align: center;">Writer</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="article" items="${articles }">
					<tr class="hover:bg-base-300">
						<td style="text-align: center;">${article.id}</td>
						<td style="text-align: center;">${article.regDate.substring(0,10)}</td>
						<td style="text-align: center;">
							<a class="hover:underline" href="detail?id=${article.id }">${article.title }</a>
						</td>
						<td style="text-align: center;">${article.extra__writer }</td>
					</tr>
				</c:forEach>

				<c:if test="${empty articles }">
					<tr>
						<td colspan="4" style="text-align: center;">게시글이 없습니다</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
</section>



<div class="mx-auto mt-20 items-center ">
	<ul>
		<li>
			<select class="select select-ghost">
				<option value="0" disabled selected>게시판을 선택하세요</option>
				<option value="1">공지사항</option>
				<option value="2">자유</option>
				<option value="3">QnA</option>
			</select>
			<input type="text" placeholder="검색하기" class="input" ${article.keyword } />

			<div class="join">
				<input class="join-item btn btn-square" type="radio" name="options" aria-label="${article.boardId}" checked="checked" />
				<input class="join-item btn btn-square" type="radio" name="options" aria-label="${article.boardId}" />
				<input class="join-item btn btn-square" type="radio" name="options" aria-label="${article.boardId}" />
				<input class="join-item btn btn-square" type="radio" name="options" aria-label="${article.boardId}" />
			</div>
			
		</li>
	</ul>
</div>



<%@ include file="../common/foot.jspf"%>