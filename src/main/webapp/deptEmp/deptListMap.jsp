<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	// 1. 요청분석(페이지 값, 검색 값)
	//paging
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 검색 값 받아오기
	String word = request.getParameter("word");		
	// 2. 요청처리 
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	//디버깅 System.out.println(conn + "<-- db접속 완료");
		
	// 2-1. 페이징
	int rowPerPage = 10; 
	int beginRow = (currentPage-1)*rowPerPage; // 페이지 당 행 시작 값
	int cnt = 0; // 총 결과 행 담을 변수
	String Sql1 = null;
	PreparedStatement stmt1 = null;
	if(word == null){
		Sql1 = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no";
		stmt1 = conn.prepareStatement(Sql1);
	} else {
		Sql1 = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.last_name LIKE ? OR e.first_name LIKE ?";
		stmt1 = conn.prepareStatement(Sql1);
		stmt1.setString(1, "%"+word+"%");
		stmt1.setString(2, "%"+word+"%");
	}
	ResultSet rs1 = stmt1.executeQuery();
	
	if(rs1.next()){ // 쿼리 실행 후 cnt에 값 넣기
		cnt = rs1.getInt("cnt");
	}
	//디버깅 System.out.println("cnt: "+cnt);
	int lastPage = cnt / rowPerPage;
	if(cnt / rowPerPage != 0){
		lastPage++;
	}
	
	// 2-2
	String sql = null;
	PreparedStatement stmt = null;
	if(word == null){
		sql = "SELECT de.emp_no empNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) empName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
	} else {
		sql = "SELECT de.emp_no empNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) empName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.last_name LIKE ? OR e.first_name LIKE ? LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setString(2, "%"+word+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, rowPerPage);
	}
	ResultSet rs = stmt.executeQuery();

	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(); // push와 get 이용
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("empName", rs.getString("empName"));
		m.put("deptName", rs.getString("deptName"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("toDate", rs.getString("toDate"));
		list.add(m);
	}

	// 3. 요청출력
%>

<!DOCTYPE html>
<html>
<head>
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
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<!-- 메뉴는 파티션jsp로 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
	</div>	
	<div>
		<h1>부서별 사원 목록</h1>
	</div>	
			<!-- 검색 폼 -->
	<div>
		<form style= "float: right;" action="<%=request.getContextPath()%>/deptEmp/deptListMap.jsp" method="post">
		이름 :
		<%
			if(word == null){
		%>
				<input type="text" name="word">
		<%
		} else {
		%>
				<input type="text" name="word" value="<%=word%>" >
		<%
		}
		%>		
		<button type="submit">검색</button>
		</form>
	</div>
			<!-- 본문 시작 -->
		<table class="table table-hover align-middle shadow-sm p-4 mb-4 bg-white">
			<tr class="table-info">
				<th>사원번호</th>
				<th>이름</th>
				<th>부서</th>
				<th>입사일</th>
				<th>퇴사일</th>
			</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
			<tr>
				<td><%=m.get("empNo")%></td>
				<td><%=m.get("empName")%></td>
				<td><%=m.get("deptName")%></td>
				<td><%=m.get("fromDate")%></td>
				<td><%=m.get("toDate")%></td>
			</tr>
		<%
		}
		%>
		</table>	
			<!-- 페이징 코드 -->
	<div>
		<%
			if(word == null){
		%>
				<a href="<%=request.getContextPath()%>/deptEmp/deptListMap.jsp?currentPage=1">처음</a>
		<%
				if(currentPage > 1){
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptListMap.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
			}
		%>
		<%
				if(currentPage < lastPage){
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptListMap.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%
			}
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptListMap.jsp?currentPage=<%=lastPage%>">마지막</a>
		<%
		} else {
		%>
				<a href="<%=request.getContextPath()%>/deptEmp/deptListMap.jsp?currentPage=1&word=<%=word%>">처음</a>
		<%
				if(currentPage > 1){
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptListMap.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
		<%
			}
		%>
		<%
				if(currentPage < lastPage){
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptListMap.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
		<%
			}
		%>
				<a href="<%=request.getContextPath()%>/deptEmp/deptListMap.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
		<%
		}
		%>
			<div>현재페이지: <%=currentPage%></div>
			</div>
		</div>
	</body>
</html>
