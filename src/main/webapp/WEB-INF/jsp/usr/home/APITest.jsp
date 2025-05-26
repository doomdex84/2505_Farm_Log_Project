+28
Lines changed: 28 additions & 0 deletions
Original file line number	Original file line	Diff line number	Diff line change
@@ -0,0 +1,28 @@
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="에어코리아 대기오염 테스트" />
<script>
	const API_KEY = 'J%2BgCGpFTEeNQ7yN4ealgfboNceusd9xMnCYQpq5kybMD2OXYg6wQe5GL3m16EklGWviUROtQwwMGxi3F3Mi6sw%3D%3D'; // Encoding된 키
	async function getAirData() {
		const url = 'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty'
			+ '?serviceKey=' + API_KEY
			+ '&returnType=json&numOfRows=5&pageNo=1&sidoName=서울';
		try {
			const response = await fetch(url);
			if (!response.ok) {
				throw new Error(`HTTP 오류! 상태 코드: ${response.status}`);
			}
			const data = await response.json();
			console.log("대기오염 정보:", data);
			console.log("대기오염 정보:", data.response);
			console.log("대기오염 정보:", data.response.body);
			console.log("대기오염 정보:", data.response.body.items);
			console.log("대기오염 정보:", data.response.body.items[0]);
			console.log("대기오염 정보:", data.response.body.items[0].coValue);
		} catch (e) {
			console.error("API 호출 실패:", e);
		}
	}
	getAirData();
</script>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/foot.jspf"%>