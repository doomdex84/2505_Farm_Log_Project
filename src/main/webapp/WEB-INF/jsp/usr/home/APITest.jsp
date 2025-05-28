<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="타슈" />

<script>
function callTextApi(url, saveFilePath) {
	  fetch(url)  // fetch를 통해 API 호출
	    .then(response => response.text())  // 응답을 텍스트로 변환
	    .then(xmlData => {
	      // XML 데이터를 파싱
	      const parser = new DOMParser();
	      const xmlDoc = parser.parseFromString(xmlData, 'text/xml');

	      // 파싱된 XML 데이터를 사용하여 필요한 작업을 수행
	      // 이 부분에서 xmlDoc를 사용하여 원하는 작업을 수행하면 됩니다.
	      console.log(xmlDoc);

	      // saveFilePath를 사용하여 데이터를 저장하거나 추가적인 처리를 수행할 수 있습니다.
	    })
	    .catch(error => {
	      console.error('API 호출 중 오류가 발생했습니다:', error);
	      // 오류 처리를 수행할 수 있습니다.
	    });
	}

	// 사용 예시
	const url = "https://cors-anywhere.herokuapp.com/" + "";

	const savePath = "/path/to/save/file.xml";
	callTextApi(apiUrl, savePath);
</script>

<%@ include file="../common/head.jspf"%>
<%@ include file="../common/foot.jspf"%>