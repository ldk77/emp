<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	
	//인코딩
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	// 1. 요청분석
	
	// 현재 페이지 구하기
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 요청처리 후 필요하다면 모델데이터 생성
	
	// 페이지 당 게시글 수, 시작 행 구하기
	final int ROW_PER_PAGE = 10; //  final: 변수 값을 바꿀 수 없게 해줌 + 대문자로 적음(띄어쓰기는 _ 로)
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ...LIMIT beginRow, ROW_PER_PAGE
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	//System.out.println("boardList.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	//System.out.println(conn + "<-- employees db 접속 확인");
	
	// 분기 -> 1) 검색 값이 있을 때 2) 검색 값이 없을 때
	String cntSql = null;
	String listSql = null;
	PreparedStatement cntStmt = null;
	PreparedStatement listStmt = null;	
	if(word == null) {
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
		cntSql = "SELECT COUNT(*) cnt FROM board";
		cntStmt = conn.prepareStatement(cntSql);
	}  else {
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_title LIKE ? ORDER BY board_no ASC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+word+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_title LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");		
	}	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) { // 전체 행의수
		cnt = cntRs.getInt("cnt");
	}
	
	
	// 마지막 페이지 구하기
	// 올림을 하게 되면 5.3 -> 6.0
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
	ResultSet listRs = listStmt.executeQuery(); // 모델의 source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // 모델의 new data
	
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");		
		boardList.add(b);
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>boardList</title>		
	</head>
	<body>
		<div>			
		<div>
			<jsp:include page="../inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
		</div>		
		<!-- 본문시작 -->
		<div>자유게시판</div>
		
		<!-- 검색 폼 -->
		<div>
			<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post">
				<label>
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
		
		<!-- 3-1. 모델 데이터 어레이리스트 출력 -->	
		<table border="1">
			<tr>
				<th>게시물 번호</th>
				<th>제목</th>				
			</tr>
				<%
					for(Board b : boardList){
				%>
					<tr>
						<td><%=b.boardNo%></td>
						<!-- 제목 클릭 시 상세보기로 이동 -->
						<td>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle%></a>
						</td>					
					</tr>
				<%
					}
				%>
		</table>
		<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">새 게시글 작성</a>
		<!-- 3-2. 페이징 -->
		<div>
			<%
	   			if (word == null) {
	   		%>
		   				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>			
			<%
					if(currentPage > 1){
			%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%
				}
			%>			
						<a><%=currentPage%></a>			
			<%
					if(currentPage < lastPage){
			%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>
			<%
				}
			%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
	   		<%
	   		} else {
	   		%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&word=<%=word%>">처음</a>			
			<%
					if(currentPage > 1){
			%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
			<%
				}
			%>			
						<a><%=currentPage%></a>			
			<%
					if(currentPage < lastPage){
			%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
			<%
				}
			%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
			<% 			
			}
			%>
		</div>
	</div>
	</body>
</html>
