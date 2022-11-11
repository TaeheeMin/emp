<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	String msg = request.getParameter("msg");
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // 수정할 번호 받아오기
	int commentNo = Integer.parseInt(request.getParameter("commentNo")); // 삭제할 댓글 번호 받아오기
	
	if(request.getParameter("boardNo") == null){ // form주소를 직접 호출하면 null값이 되어 막어야 함
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp"); // null 들어오면 리스트로 보냄
		return;
	}
	
	// 2. 요청 처리
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");

	// sql문 작성
	String updSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no=? AND comment_no=?";
	PreparedStatement updStmt = conn.prepareStatement(updSql); 
	updStmt.setInt(1, boardNo);
	updStmt.setInt(2, commentNo);
	ResultSet updRs = updStmt.executeQuery();
	
	Comment comment = null;
	if(updRs.next()){
		comment = new Comment();
		comment.boardNo = boardNo;
		comment.commentNo = updRs.getInt("commentNo");;
		comment.commentContent = updRs.getString("commentContent");;
	}
	
	// 3. 출력
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>update Form</title>
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
				text-align:center;
			}
			a {
			text-decoration: none;
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
				width:100%;
			}
			textarea {
				width:100%;
				height:150px;
			}
			th {
				width:100px;
				text-align:center;
			}
		</style>
	</head>
	
	<body>
		<!-- 메뉴 partial jsp 구성-->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		
		<!-- 제목 -->
		<div> 
			<h1 class="text-center">게시글 수정</h1>
		</div>
			
		<div class = "container">
			<!-- msg 파라미터값이 있으면 출력 -->
			<%
			if(msg != null){
			%>
				<div class="text-center"><%=msg%></div>
			<%
			}
			%>
			<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp?boardNo=<%=boardNo%>&commentNo=<%=commentNo %>" method="post">
				<input type="hidden" name="boardNo" value="<%=comment.commentNo %>"> 
				<table class="table table-bordered table-hover w-100 rounded" style="margin-left: auto; margin-right: auto;">
					<tr>
						<th>내용</th>
						<td>
							<textarea name="commentContent"><%=comment.commentContent %></textarea>
						</td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td>
							<input type="password" name="commentPw">
						</td>
					</tr>
					<tr>
						<td colspan ="2">
							<button type="submit" class="btn text-black .bg-dark.bg-gradient"  style="background-color:#D4D4D4;">UPDATE</button>
						</td>
					</tr>
				</table>
			</form>
		</div>	
	</body>
</html>