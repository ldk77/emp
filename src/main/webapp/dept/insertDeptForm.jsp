<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<jsp:include page="../inc/menu.jsp"></jsp:include> 
	</div>
	

	<h2>부서 추가하기</h2>
	<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
	<table>
		<tr>
			<td>부서번호</td>
			<td>
               <input type="text" name="dept_no">
            </td>
        <tr>
		<tr>
			<td>부서이름</td>
			<td>
               <input type="text" name="dept_name">
            </td>
        <tr>
            <td colspan="2">
               <button type="submit">CREATE</button>
            </td>
        </tr>
		</tr>
	</table>
</body>
</html>