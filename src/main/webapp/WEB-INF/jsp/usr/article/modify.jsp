<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE MODIFY"></c:set>
<%@ include file="../common/head.jspf"%>


<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<table border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
			<tbody>

				
				<div>
					새 제목 :
					<input type="text" placeholder="제목 입력" name="title" />
				</div>
				<div>
					새 내용 :
					<textarea type="text" placeholder="내용 입력" name="body"></textarea>
				</div>
			</tbody>
		</table>
		<div class="btns">
			<button type="button" onclick="history.back();">뒤로가기</button>
			<c:if test="${article.modifyArticle }">
				<a href="../article/modify?id=${article.id}">수정완료</a>
			</c:if>
		</div>

	</div>
</section>

