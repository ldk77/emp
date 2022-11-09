<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>index</title>
</head>
<body>
		<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="./inc/menu.jsp"></jsp:include> 
	</div>
	
	<div><h1>INDEX</h1></div>
	<ol>
		<li><a href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a></li>
		<li><a href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a></li>
	</ol>
</body>
</html>