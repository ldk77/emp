<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//1. 요청 분석
	request.setCharacterEncoding("utf-8");
	Department d = new Department();
	d.deptNo = request.getParameter("dept_no");
	d.deptName = null;

	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT dept_name FROM departments where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,d.deptNo);	
	ResultSet rs = stmt.executeQuery(); 
	// <- 모델데이터로서 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아니다
	// ResultSet rs라는 모델자료구조를 좀더 일반적이고 독립적인 자료구조(List) 변경을 하자
	if(rs.next()) {
		d.deptName = rs.getString("dept_name");
	}

	// 3. 결과 출력	
%>	
<!DOCTYPE html>
<html>
<head>
<style> 
	h2,div, table, tr, td {text-align : center;}	
</style>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
	<h1>부서 목록 수정중</h1>
	</div>	
	<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
		<table class="table table-bordered">
			<tr>
				<td>부서번호</td>
				<td><input type="text" name="dept_no" value="<%=d.deptNo%>" readonly="readonly"></td>
			</tr>			
			<tr>
				<td>부서이름</td>
				<td><input type="text" name="dept_name" value="<%=d.deptName%>"></td>
			</tr>
		</table>
		<div>
		<button type="submit" class="btn btn-danger">수정완료</button>
		</div>
	</form>

</body>
</html>