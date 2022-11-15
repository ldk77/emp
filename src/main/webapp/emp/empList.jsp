<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*"  %>
<%@ page import="java.util.*" %>
<%
		// 1 요청 분석
		int currentPage = 1;
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		String word = request.getParameter("word");		
		// 2 요청 처리		
		final int ROW_PER_PAGE = 10;	
		int count = 0;			
		int lastPage = 0;	
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	
	
		String sql1 = null;
		String sql2 = null;
		PreparedStatement stmt1 = null;
		PreparedStatement stmt2 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;		
		// 2-1 word == null
		if(word == null) {
			sql1 = "SELECT COUNT(*) FROM employees";
			stmt1 = conn.prepareStatement(sql1);
			rs1 = stmt1.executeQuery();			
			if(rs1.next()) {
				count = rs1.getInt("COUNT(*)");
			}				
			lastPage = count / ROW_PER_PAGE;
			if(count % ROW_PER_PAGE != 0) {	
				lastPage = lastPage + 1;
			}			
			sql2 = "SELECT * FROM employees ORDER BY emp_no ASC LIMIT ?,?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setInt(1, ROW_PER_PAGE*(currentPage-1));
			stmt2.setInt(2, ROW_PER_PAGE);			
			rs2 = stmt2.executeQuery();			
		}		
		// 2-2 word != null
		else {			
			sql1 = "SELECT COUNT(*) FROM employees where first_name like ? or last_name like ?";
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setString(1,"%"+word+"%");
			stmt1.setString(2,"%"+word+"%");
			rs1 = stmt1.executeQuery();			
			if(rs1.next()) {
				count = rs1.getInt("COUNT(*)");
			}			
			lastPage = count / ROW_PER_PAGE;
			if(count % ROW_PER_PAGE != 0) {
				lastPage = lastPage + 1;
			}			
			sql2 = "SELECT * FROM employees where first_name like ? or last_name like ? ORDER BY emp_no ASC LIMIT ?,?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1,"%"+word+"%");
			stmt2.setString(2,"%"+word+"%");
			stmt2.setInt(3, ROW_PER_PAGE*(currentPage-1));
			stmt2.setInt(4, ROW_PER_PAGE);			
			rs2 = stmt2.executeQuery();			
		}	
			
			ArrayList<Employee> list = new ArrayList<Employee>();
			while(rs2.next()) {
				Employee emp = new Employee();
				emp.empNo = rs2.getInt("emp_no");
				emp.birthDate = rs2.getString("birth_date");
				emp.firstName = rs2.getString("first_name");
				emp.lastName = rs2.getString("last_name");
				emp.gender = rs2.getString("gender");
				emp.hireDate = rs2.getString("hire_date");
				list.add(emp);
			}
		

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style> 	
	td { padding: 10px; }
	h2,div, table, tr, td {text-align : center;}	
</style>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
<title>Insert title here</title>

</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include> 
	</div>
	<div>
	<h1>사원목록</h1>
	</div>	
		<!-- 검색 폼 -->
	<div>
		<form style= "float: right;" action="<%=request.getContextPath()%>/emp/empList.jsp" method="post">
			<label for ="word">
				Name :
				<%
				if(word != null){
				%>	
					<input type="text" name="word" value="<%=word%>">
				<%
				} else {
				%>				
					<input type="text" name="word">
				<%
				}   
				%>					
				</label>
			<button type="submit">검색</button>
		</form>
	</div>	
	
	<table class="table table-bordered">
		<tr class="table-info">
			<th>사원 번호</th>
			<th>사원 생일</th>
			<th>First_Name</th>
			<th>Last_Name</th>
			<th>성별</th>
			<th>입사일</th>
			<th>수정</th>
			<th>삭제</th>

		</tr>
		<%
		for(Employee emp : list) {
		%>
			<tr>
				<td class = "center"><%=emp.empNo%></td>
				<td class = "center"><%=emp.birthDate%></td>
				<td class = "center"><%=emp.firstName%></td>
				<td class = "center"><%=emp.lastName%></td>
				<td class = "center"><%=emp.gender%></td>
				<td class = "center"><%=emp.hireDate%></td>
				<td class = "center"><a href = "<%=request.getContextPath()%>/emp/updateEmpForm.jsp?emp_no=<%=emp.empNo%>">수정</a></td>
				<td class = "center"><a href = "<%=request.getContextPath()%>/emp/deleteEmp.jsp?emp_no=<%=emp.empNo%>">삭제</a></td>
			</tr>
		<%
		}
		%>
	</table>
	<!-- 페이징 코드 -->
	<div>
		<%
		if (word == null) {		
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
		<%
			if(currentPage > 1){
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%		
			}
			if(currentPage < lastPage){
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%		
			}
		%>		
		<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
		<% 
		}else {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>">처음</a>
		<%
			if(currentPage > 1){
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
		<%		
		}
			if(currentPage < lastPage){
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
		<%		
			}
		%>		
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
		<% 
		}
		%>
	</div>
	<div>현재페이지 : <%=currentPage %></div>
</body>
</html>