<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>


<% 
	//1. 요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("dept_no");
	String deptName = request.getParameter("dept_name");

	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	PreparedStatement stmt = conn.prepareStatement(
			"insert into departments(dept_no, dept_name) values(?,?)");
	
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
	stmt.executeUpdate();	
	
	// 3. 결과출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	
%>	