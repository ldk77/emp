<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*"  %>
<%@ page import="java.util.*" %>

<%
	//1 
	int currentPage = 1;
	int rowPerPage =10;
	int beginRow = (currentPage-1)*rowPerPage;
	
	if(request.getParameter("currentPage")!=null){
		currentPage= Integer.parseInt(request.getParameter("currentPage"));
	}	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	
	String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()) {
		Salary s = new Salary();
		s.emp = new Employee();
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
		}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table border = "1">
		<%
			for(Salary s : salaryList){
		%>
				<tr>
				<td><%=s.emp.empNo %></td>
				<td><%=s.salary %></td>
				<td><%=s.fromDate %></td>
				<td><%=s.toDate %></td>
				<td><%=s.emp.firstName %></td>
				<td><%=s.emp.lastName %></td>
				</tr>
		<%
			}
		%>
	</table>

</body>
</html>