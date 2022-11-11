<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import = "vo.*" %>

<%
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // 삭제할 게시글 번호 받아오기
	int commentNo = Integer.parseInt(request.getParameter("commentNo")); // 삭제할 게시글 번호 받아오기
	String msg = request.getParameter("msg");
	
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");

	// sql문 작성
	String delSql = "SELECT board_no boardNo, comment_no commentNo, comment_content commentContent FROM comment WHERE board_no=? AND comment_no=?";
	PreparedStatement delStmt = conn.prepareStatement(delSql); 
	delStmt.setInt(1, boardNo);
	delStmt.setInt(2, commentNo);
	ResultSet delRs = delStmt.executeQuery();


%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>비밀번호</h2>
	<%
		if(msg != null) {
	%>
			<div><%=msg%></div>
	<%		
		}
	%>
	<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp" method="post">
	<input type="text" name="boardNo" value="<%=boardNo %>">
	<input type="text" name="commentNo" value="<%=commentNo%>">
	<input type="password" name="commentPw" >
	<button type="submit">비밀번호확인</button>	
	</form>
</body>
</html>