<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 방어코드
	if(request.getParameter("emp_no") == null){
		response.sendRedirect(request.getContextPath()+"/emp/empList.jsp");
		return;	
	}
	int empNo = Integer.parseInt(request.getParameter("emp_no"));
	//2 요청처리 
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT emp_no empNo,birth_date birthDate, first_name firstName,last_name lastName,gender,hire_date hireDate FROM employees WHERE emp_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, empNo);
	ResultSet rs = stmt.executeQuery();
	
	Employee e = null;
	if(rs.next()){
		e = new Employee();
		e.empNo = empNo;
		e.birthDate = rs.getString("birthDate");
		e.firstName = rs.getString("firstName");
		e.lastName = rs.getString("lastName");
		e.gender = rs.getString("gender");
		e.hireDate = rs.getString("hireDate");
	}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<h1>수정중</h1>
	</div>
	<form method="post" action="<%=request.getContextPath()%>/emp/updateEmpAction.jsp">
		<table>
			<tr>
				<td>사원번호</td>
				<td>
					<input type ="text" name="empNo" value=<%=e.empNo%> readonly="readonly" class="box">
				</td>
			</tr>
			<tr>
				<td>사원생일</td>
				<td>
					<input type ="text" name="birthDate" value=<%=e.birthDate%>>
				</td>
			</tr>
			<tr>
				<td>first_name</td>
				<td>
					<input type ="text" name="firstName" value=<%=e.firstName%>>
				</td>
			</tr>		
			<tr>
				<td>last_name</td>
				<td>
					<input type ="text" name="lastName" value=<%=e.lastName%>>
				</td>
			</tr>	
			<tr>
				<td>성별</td>
				<td>
					<input type ="text" name="gender" value=<%=e.gender%>>
				</td>
			</tr>	
			<tr>
				<td>입사일</td>
				<td>
					<input type ="text" name="hireDate" value=<%=e.hireDate%>>
				</td>
			</tr>		
			<tr class="text-center">
				<td colspan="2">
					<button type="submit" class="btn btn-outline-light">수정</button>
				</td>
			</tr>				
		</table>
	</form>
</body>
</html>