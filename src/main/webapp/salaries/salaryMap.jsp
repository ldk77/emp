<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import= "java.util.*" %><!-- hashMap<키,값>,ArrayList<요소> -->
<%
	//1) 요청분석
	// currentPage ...
	int currentPage = 1; 
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//2) 요청처리 
	// 페이징 rowPerPage, ... 
	int rowPerPage = 10;	
	int beginRow = rowPerPage*(currentPage-1);
	int count = 0;
	int lastPage = 0;
	//db 연결 -> 모델생성
	//쿼리 CONCAT 둘이합치는거 as쓰면안됨 
	String driver ="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver); //접속 
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);//("프로토콜://주소:포트번호","","")
	//2-1
	String sql = "SELECT COUNT(*) FROM employees";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs1 = stmt.executeQuery();
	if(rs1.next()) {
		count = rs1.getInt("COUNT(*)");
	}				
	lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {	
		lastPage = lastPage + 1;
	}		
	//2-2
	String sql1 = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name,' ',e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
	//salay안에 있는 외래키가 참조하는게 empolyee 행과행을 합치기	
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setInt(1, beginRow);
	stmt1.setInt(2, rowPerPage);
	ResultSet rs = stmt1.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("salary", rs.getInt("salary"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("name", rs.getString("name"));
		list.add(m);
	}
	
	rs.close();
	stmt1.close();
	stmt.close();
	conn.close();// 연결된 커넥션을 끊는 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
	<div>
		<jsp:include page="../inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
	</div>	
	<div>
	<h1>연봉 목록</h1>
	</div>		
	<table class="table table-bordered">
		<tr class="table-info">
			<th>사원번호</th>
			<th>사원이름</th>
			<th>연봉</th>
			<th>계약일자</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
				<tr>
					<td><%=m.get("empNo")%></td>
					<td><%=m.get("name")%></td>
					<td><%=m.get("salary")+"$"%></td>
					<td><%=m.get("fromDate")%></td>
				</tr>
		<%		
			}
		%>
	</table>
	<div>
		<a href="<%=request.getContextPath()%>/salaries/salaryMap.jsp?currentPage=1">처음</a>
		<%
			if(currentPage > 1){
		%>
				<a href="<%=request.getContextPath()%>/salaries/salaryMap.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
		}
			if(currentPage < lastPage){
		%>
				<a href="<%=request.getContextPath()%>/salaries/salaryMap.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%		
		}
		%>		
		<a href="<%=request.getContextPath()%>/salaries/salaryMap.jsp?currentPage=<%=lastPage%>">마지막</a>
		
	</div>
	<div>현재페이지 : <%=currentPage %></div>
</body>
</html>