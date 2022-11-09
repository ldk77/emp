<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	Department d = new Department();
	d.deptNo = request.getParameter("dept_no");
	d.deptName = request.getParameter("dept_name");
	if(d.deptNo == null || d.deptName == null || d.deptNo.equals("") || d.deptName.equals("")) {
	      String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요","utf-8"); // get방식 주소창에 문자열 인코딩
	      response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg);
	      return;
	    }


	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	//2-1 dept_no 중복검사
		String sql1 = "SELECT dept_no FROM departments WHERE dept_no = ? OR dept_name = ?";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		stmt1.setString(1, d.deptNo);	
		stmt1.setString(2, d.deptName);
		ResultSet rs = stmt1.executeQuery();
		if(rs.next()) { // 결과물있다 -> 같은 dept_no가 이미 존재한다.
	    String msg = URLEncoder.encode("부서번호 or 부서이름이 중복되었습니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg);
		      return;
		  }

	String sql2 = "update departments set dept_name = ?  Where dept_no = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);	
	stmt2.setString(1, d.deptName);
	stmt2.setString(2, d.deptNo);
	stmt2.executeUpdate();	
	
	// 3. 결과출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	// 3. 출력
%>
