<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentPw = request.getParameter("commentPw");
	String commentContent = request.getParameter("commentContent");

	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String sql = "INSERT INTO comment(board_no, comment_pw, comment_content, createdate) values(?, ?, ?, CURDATE())";
	PreparedStatement stmt1 = conn.prepareStatement(sql);
	stmt1.setInt(1, boardNo);
	stmt1.setString(2, commentPw);
	stmt1.setString(3, commentContent);
	
	int row = stmt1.executeUpdate();

	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
%>
