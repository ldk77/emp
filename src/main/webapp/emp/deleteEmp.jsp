<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String empNo = request.getParameter("emp_no");

	
	//2, 요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	String sql = "delete from employees Where emp_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, empNo);
	stmt.executeUpdate();	
	
	
	response.sendRedirect(request.getContextPath()+"/emp/empList.jsp");
	// 3. 출력
%>