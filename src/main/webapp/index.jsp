<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
div {border: 1px solid #ffebb5;
		background-colo: #ffebb5;
		border-radius: 20px;
		box-shadow: inset 0 0 10px #deb13a;
		width: 105px; height: 105px		
	}
</style>
<meta charset="UTF-8">
<title>index</title>
</head>
<body>
	<div><h1>INDEX</h1></div>
	<ol>
		<li><a href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a></li>
	</ol>
</body>
</html>