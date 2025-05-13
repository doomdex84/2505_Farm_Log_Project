<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE WRITE"></c:set>
<%@ include file="../common/head.jspf"%>


<section class=2 "mt-8 text-xlpx-4">
	<div class="mx-auto">
		<form action="../article/doWrite" method="POST">
			<input type="hidden" name="id" value="${article.id}" />
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>
					
					<tr>
						<th style="text-align: center;">Title</th>
						<td style="text-align: center;">
							<input class="input input-primary input-sm" required="required" name="title" value="${article.title }"
								type="text" autocomplete="off" placeholder="새 제목" />
						</td>
					</tr>
					<tr>
						<th style="text-align: center;">Body</th>
						<td style="text-align: center;">
							<input class="input input-primary input-sm" required="required" name="body" value="${article.body }" type="text"
								autocomplete="off" placeholder="새 내용" />
						</td>
					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;">
							<button class="btn btn-primary">저장하기</button>
						</td>
					</tr>

				</tbody>
			</table>
		</form>
		<div class="btns">
			<button class="btn btn-ghost" type="button" onclick="history.back();">취소</button>			
		</div>

	</div>
</section>


