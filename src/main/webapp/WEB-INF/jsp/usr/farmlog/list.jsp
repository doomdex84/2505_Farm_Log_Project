<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="pageTitle" value="나의 영농일지" />
<%@ include file="../common/head.jspf"%>

<!-- ✅ 로그인 체크 -->
<c:if test="${empty sessionScope.loginedMember}">
	<script>
		alert("로그인이 필요합니다.");
		location.replace('/usr/member/login');
	</script>
</c:if>

<section class="mt-24 text-xl px-4 bg-[#D7E9B9] min-h-screen">
	<div class="max-w-5xl mx-auto">

		<h1 class="text-2xl font-bold text-center mb-6">📒 나의 영농일지 목록</h1>

		<!-- ✅ 검색 폼 (선택) -->
		<form method="get" action="/usr/farmlog/list" class="mb-4 flex gap-2">
			<input type="text" name="keyword" value="${param.keyword}" placeholder="메모 또는 작업유형 검색"
				class="input input-sm input-bordered w-64" />
			<button type="submit" class="btn btn-sm btn-success">검색</button>
		</form>

		<div class="overflow-x-auto bg-white rounded shadow">
			<table class="table table-zebra w-full text-sm">
				<thead class="bg-gray-100 text-gray-700 text-sm">
					<tr>
						<th class="text-center">번호</th>
						<th class="text-center">작업일</th>
						<th class="text-center">다음예상일</th>
						<th class="text-center">작업유형</th>
						<th class="text-center">메모</th>
						<th class="text-center">사진</th>
						<th class="text-center">상세보기</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="log" items="${farmlogList}" varStatus="status">
						<tr class="hover:bg-gray-100">
							<td class="text-center">${(page - 1) * 10 + status.index + 1}</td>
							<td class="text-center">${log.work_date}</td>
							<td class="text-center text-red-600">${log.nextSchedule}</td>
							<td class="text-center">${log.work_type_name}</td>
							<td class="break-all whitespace-normal">
								<a href="/usr/farmlog/detail?id=${log.id}" class="text-black hover:underline">
									<c:choose>
										<c:when test="${fn:length(log.work_memo) > 30}">
                      ${fn:substring(log.work_memo, 0, 30)}...
                    </c:when>
										<c:otherwise>
                      ${log.work_memo}
                    </c:otherwise>
									</c:choose>
								</a>
							</td>
							<td class="text-center">
								<c:choose>
									<c:when test="${not empty log.imgFileName}">
                    📷 있음
                  </c:when>
									<c:otherwise>
                    - 없음 -
                  </c:otherwise>
								</c:choose>
							</td>
							<td class="text-center">
								<a class="text-blue-600 hover:underline" href="/usr/farmlog/detail?id=${log.id}">보기</a>
							</td>
						</tr>
					</c:forEach>

					<c:if test="${empty farmlogList}">
						<tr>
							<td colspan="7" class="text-center text-gray-400 py-4">기록이 없습니다</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>

		<!-- ✅ 페이징 -->
		<div class="flex justify-center mt-6">
			<div class="btn-group join">
				<c:forEach begin="1" end="${pagesCount}" var="i">
					<a class="join-item btn btn-sm ${i == page ? 'btn-active' : ''}" href="?page=${i}&keyword=${param.keyword}">
						${i} </a>
				</c:forEach>
			</div>
		</div>

	</div>
</section>
