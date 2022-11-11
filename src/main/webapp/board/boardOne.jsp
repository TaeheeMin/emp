<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 2-1 게시글 부분
	if(request.getParameter("boardNo") == null){ // form주소를 직접 호출하면 null값이 되어 막어야 함
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp"); // null 들어오면 리스트로 보냄
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	// db연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no=?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	
	Board board = null;
	if(boardRs.next()){
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
		board.createdate = boardRs.getString("createdate");
	}
	
	// 2-2 댓글 페이징 
	int currentPage = 1; // 현재페이지
	if(request.getParameter("currentPage") != null) { // 현재 페이지 값이 null이면 받아오기
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 5; // 한 페이지당 댓글 개수
	
	int beginRow = ROW_PER_PAGE * (currentPage-1); // sql문에 limit beginRow, ROW_PER_PAGE
	String cntSql = "SELECT COUNT(comment_no) FROM comment WHERE board_no=?"; // 총 게시글 개수 구하는 sql문
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	cntStmt.setInt(1, board.boardNo);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt= 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("COUNT(comment_no)");
	}	
	System.out.println("cnt : " + cnt); // 디버깅

	// 2-3 마지막 페이지 구하기
	// 올림 : 5.3 -> 6.0 더블로 올려줌 사용하려면 형변환 필요
	int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
	
	// 2-4 댓글 목록 출렦
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no=? ORDER BY comment_no DESC LIMIT ?,?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, ROW_PER_PAGE);
	
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){ // ResultSet의 API(사용방법)을 모르면 사용할 수 없는 반복문 
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
	}	
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>게시글 보기</title>
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
			a {
				text-decoration: none;
				text-align:right;
			}
			th {
				width:100px;
				text-align:center;
			}
			td {
				text-align:left;
			}
			#wrap{
			}
			input, textarea{
			 	display: inline-block;
				font-size: 15px;
				border: 0;
				border-radius: 15px;
				outline: none;
				padding-left: 10px;
				background-color: rgb(233, 233, 233);
				float: left;
				width:100%
			}
			textarea {
				width:100%;
				height:100px;
			}
			#btnSubmit{
		        margin:auto;
		        display:block;
		        background-color:#D4D4D4;
    		}
		</style>
	</head>
	
	<body>
		<!-- 메뉴 partial jsp 구성-->
		<div id="wrap">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
			<!-- jsp 액션 태그 : 동일페이지 출력, 상대주소 사용할수 없다.(서버가 하는거라. 브라우저 입장에서 처리하는것은 절대주소인 context사용 가능 -->
		</div>
		
		<!-- 제목 -->
		<div> 
			<h3 class="text-center">
				게시글 보기
			</h3>
		</div>
		<div class="container">
			<table class="table table-bordered table-hover w-100 rounded" style="margin-left: auto; margin-right: auto;">
				<tr>
					<th>번호</th>
					<td><%=board.boardNo %></td>
				</tr>
				<tr>
					<th>제목</th>
					<td><%=board.boardTitle %></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><%=board.boardContent %></td>
				</tr>
				<tr>
					<th>작성자</th>
					<td><%=board.boardWriter %></td>
				</tr>
				<tr>
					<th>작성일</th>
					<td><%=board.createdate %></td>
				</tr>
			</table>
			<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>">수정</a>
			<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>">삭제</a>
		</div>
		
		<div class="container">
			<!-- msg 파라미터값이 있으면 출력 -->
			<%
			String msg = request.getParameter("msg");
			if(msg != null){
			%>
				<div class="text-center"><%=msg%></div>
			<%
			}
			%>
			<form method="post" action="<%=request.getContextPath()%>/board/insertCommetnAction.jsp">
				<input type="hidden" name="boardNo"value="<%=board.boardNo %>"> <!-- 부모글 넘버 -->
				<table  class="table table-bordered rounded" style="margin-left: auto; margin-right: auto; width:70%;">
					<!--  댓글 리스트 -->
					<%
						for(Comment c : commentList) {
					%>
							<tr>
								<td style="text-align:center"><%=c.commentNo %></td>
								
								<td>
									<%=c.commentContent %>
								</td>
								<td style = "width: 10%;">
									<a href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?boardNo=<%=boardNo %>&commentNo=<%=c.commentNo%>&currentPage=<%=currentPage%>">수정</a>
									<a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?boardNo=<%=boardNo %>&commentNo=<%=c.commentNo%>&currentPage=<%=currentPage%>">삭제</a>
								</td>
							</tr>
					<%
						}
					%>
					<tr>
						<th colspan ="3">
						<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=1">처음</a>
						<%
							if(currentPage > 1){
						%>
								<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage-1%>">이전</a>
						<%
							}

							if(currentPage < lastPage){
						%>
								<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage+1%>">다음</a>
						<%
							}
						%>
						<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=lastPage%>">마지막</a>
						</th>
					</tr>
					
					<!-- 댓글 입력 -->
					<tr>
						<th>내용</th>
						<td colspan ="2" >
							<textarea rows="2" cols="80" name="commentContent"></textarea>
						</td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td colspan ="2" >
							<input type="password" name="commentPw">
						</td>
					</tr>
				</table>
				<button type="submit" class="btn text-black .bg-dark.bg-gradient" id="btnSubmit">comment</button>
			</form>
		</div>
	</body>
</html>