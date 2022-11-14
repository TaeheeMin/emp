<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	// word-> 1)null 2)''공백일때 or 3)'단어' -> stmt 수정
	
	// 2. 요청 처리
	// db연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	
	// 페이징
	// 현재 페이지
	int currentPage = 1; // 현재페이지
	if(request.getParameter("currentPage") != null) { // 현재 페이지 값이 null이면 받아오기
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 10; // 한 페이지당 행 개수
	int beginRow = ROW_PER_PAGE * (currentPage-1); // sql문에 limit beginRow, ROW_PER_PAGE
	
	//2. 요청처리 후 필요시 모델데이터 생성
	int cnt = 0;
	int lastPage = 0;
	String listSql = null;
	String cntSql = null;
	ResultSet cntRs = null;
	ResultSet listRs = null;
	PreparedStatement listStmt = null;
	PreparedStatement cntStmt = null;
	// model new data
	ArrayList<Board> boardList = new ArrayList<Board>(); // resultset보다 보편적인 arraylist사용
	
	if(word == null || word.equals("")){
		// null일때 전체 페이지 
		cntSql = "SELECT COUNT(*) FROM board"; 
		cntStmt = conn.prepareStatement(cntSql);
		cntRs = cntStmt.executeQuery();
		if(cntRs.next()) {
			cnt = cntRs.getInt("COUNT(*)"); // COUNT(*)으로 넣으면 오류 뭘 넣어야 하지? 행 개수 카운트한거 총 페이지 개수로 넣어주는 건데 -> 조건별로 카운트
		}	
		System.out.println("cnt : " + cnt); // 디버깅
		
		// 마지막 페이지 구하기
		lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
		
		System.out.println("word null"); // 디버깅
		System.out.println("lastPage : " + lastPage); // 디버깅
		
		// null일때 목록
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no DESC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql); // null이라면 그냥 리스트
		listStmt.setInt(1,beginRow);
		listStmt.setInt(2,ROW_PER_PAGE);
		
	} else {
		// 검색일 때 페이지
		cntSql = "SELECT COUNT(*) FROM board WHERE board_title LIKE ?"; 
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%" + word + "%");
		cntRs = cntStmt.executeQuery();
		if(cntRs.next()) {
			cnt = cntRs.getInt("COUNT(*)"); 
		}
		// 마지막 페이지 구하기
		lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
		System.out.println("lastPage : " + lastPage); // 디버깅
		System.out.println("word : "+word); // 디버깅
				
		// 검색일 때 목록
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_title LIKE ? ORDER BY board_no DESC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%" + word + "%"); // 공백이나 단어검색 했을때 
		listStmt.setInt(2,beginRow);
		listStmt.setInt(3,ROW_PER_PAGE);
		
	}
	
	listRs = listStmt.executeQuery(); // 모델 source data
	while(listRs.next()){ // ResultSet의 API(사용방법)을 모르면 사용할 수 없는 반복문 
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}
		
	/*
	// 마지막 페이지 구하는 다른 알고리즘 
	if(cnt % ROW_PER_PAGE != 0 ) { // 나머지가 0 아니면 1 추가
		lastPage++;
	}*/
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Board List</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			body {
				padding:1.5em;
				background: #f5f5f5
			}
			table {
			 	border: 1px #a39485 solid;
				font-size: .9em;
				box-shadow: 0 2px 5px rgba(0,0,0,.25);
				width: 100%;
				border-collapse: collapse;
				border-radius: 5px;
				overflow: hidden;
			}
			#nav{
			}
			a {
				text-decoration: none;
			}
		
			th {
				text-align:center
			}
		</style>
	</head>
	
	<body>
		<!-- 메뉴 partial jsp 구성-->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
	
		<div class="text-center">
			<h1>자유게시판</h1>
		</div>
		
		
		<!-- 3-1. 모델데이터 출력 -->
		<div class = "container">
			<!-- 검색 기능 -->
			<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post">
				<label for="word">검색 : </label>
				<input type="text" name="word" id="name">
				<button type="submit">검색</button>
			</form>
			<table class = "table table-hover w-100 rounded" style="table-layout: auto; width: 100%; table-layout: fixed;">
				<tr >
					<th style="width:100px;">번호</th>
					<th>제목</th>
				</tr>
				<%
					for(Board b : boardList) {
				%>
						<tr>
							<td style="text-align:center"><%=b.boardNo %></td>
							<td>
								<a href ="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>">
									<%=b.boardTitle %>
								</a>
							</td>
						</tr>
				<%
					}
				%>
			</table>
			<div class="position-relative"> 
				<!-- 글쓰기 버튼 -->
				<a class = "position-absolute top-0 end-0" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">글쓰기</a>
	
				<!-- 3-2. 페이징 -->
				<!-- word가 null일때 원래 페이징 출력, 뭐가 있으면 검색어에 맞게 출력 -->
				<% 
					if(word == null) {
				%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
						<%
							if(currentPage > 1){
						%>
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
						<%
							}
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
