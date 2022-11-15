<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	//1
	request.setCharacterEncoding("UTF-8"); //한글
	// 방어 코드
	if(request.getParameter("empNo") == null || request.getParameter("birthDate") == null ||  request.getParameter("firstName") == null ||  request.getParameter("lastName") == null ||  request.getParameter("hireDate") == null ||  request.getParameter("gender") == null
	|| request.getParameter("empNo").equals("") || request.getParameter("birthDate").equals("") ||  request.getParameter("firstName").equals("") || request.getParameter("lastName").equals("") || request.getParameter("hireDate").equals("") || request.getParameter("gender").equals("")){
			response.sendRedirect(request.getContextPath()+"/emp/updateEmpForm.jsp");
			return;
	}
	int empNo = Integer.parseInt(request.getParameter("empNo"));
	String birthDate = request.getParameter("birthDate");
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String gender = request.getParameter("gender");
	String hireDate = request.getParameter("hireDate");

	
	//2 요청처리 
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "UPDATE employees SET birth_date=?, first_name=?, last_name=?, geder=?, hire_date=? WHERE emp_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, birthDate);
	stmt.setString(2, firstName);
	stmt.setString(3, lastName);
	stmt.setString(4, gender);
	stmt.setString(5, hireDate);
	stmt.setInt(6, empNo);
	
	stmt.executeUpdate();	
	response.sendRedirect(request.getContextPath()+"/emp/empList.jsp");
%>
