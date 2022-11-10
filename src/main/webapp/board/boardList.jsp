<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	// 페이징
	int currentPage = 1; // 현재페이지
	if(request.getParameter("currentPage") != null) { // 현재 페이지 값이 null이면 받아오기
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 10; // 한 페이지당 행 개수
	int beginRow = ROW_PER_PAGE * (currentPage-1); // sql문에 limit beginRow, ROW_PER_PAGE
	
	// db연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 총 게시글 개수 구하기
	String cntSql = "SELECT COUNT(*) FROM board"; // 총 게시글 개수 구하는 sql문
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt= 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("COUNT(*)");
	}	
	System.out.println("cnt : " + cnt); // 디버깅

	// 마지막 페이지 구하기
	// 올림 : 5.3 -> 6.0 더블로 올려줌 사용하려면 형변환 필요
	int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
	/* // 마지막 페이지 구하는 다른 알고리즘 
	if(cnt % ROW_PER_PAGE != 0 ) { // 나머지가 0 아니면 1 추가
		lastPage++;
	}
	*/
	System.out.println("lastPage : " + lastPage); // 디버깅
	
	//2. 요청처리 후 필요시 모델데이터 생성
	// 한 페이지당 출력할 게시글목록
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no DESC LIMIT ?, ?";

	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1,beginRow);
	listStmt.setInt(2,ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery(); // 모델 source data
	
	// model new data
	ArrayList<Board> boardList = new ArrayList<Board>(); // resultset보다 보편적인 arraylist사용
	while(listRs.next()){ // ResultSet의 API(사용방법)을 모르면 사용할 수 없는 반복문 
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
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
				<%
					if(currentPage > 1){
				%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
				<%
					}
				%>
				<%
					if(currentPage < lastPage){
				%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>
				<%
					}
				%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
			</div>
		</div>
	</body>
</html>
