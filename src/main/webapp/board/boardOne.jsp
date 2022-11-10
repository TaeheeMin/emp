<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	int boardNo=Integer.parseInt(request.getParameter("boardNo"));

	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	
	Board board = null;
	if(rs.next()){
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
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
	</body>
</html>