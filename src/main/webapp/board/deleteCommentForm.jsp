<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // 삭제할 게시글 번호 받아오기
	int commentNo = Integer.parseInt(request.getParameter("commentNo")); // 삭제할 댓글 번호 받아오기
	String msg = request.getParameter("msg");
	
	if(request.getParameter("boardNo") == null){ // form주소를 직접 호출하면 null값이 되어 막어야 함
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp"); // null 들어오면 리스트로 보냄
		return;
	}
	
	// 2. 요청 처리 -> 내용 안보이게 만들거면 필요 없음
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");

	// sql문 작성
	String delSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no=? AND comment_no=?";
	PreparedStatement delStmt = conn.prepareStatement(delSql); 
	delStmt.setInt(1, boardNo);
	delStmt.setInt(2, commentNo);
	ResultSet delRs = delStmt.executeQuery();
	
	Comment comment = null;
	if(delRs.next()){
		comment = new Comment();
		comment.boardNo = boardNo;
		comment.commentNo = delRs.getInt("commentNo");;
		comment.commentContent = delRs.getString("commentContent");;
	}
	// 3. 출력
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>delete Form</title>
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
			<h1 class="text-center">댓글 삭제</h1>
		</div>
			
		<!-- msg 파라미터값이 있으면 출력 -->
		<%
		if(msg != null){
		%>
			<div class="text-center"><%=msg%></div>
		<%
		}
		%>
		
		<div class = "container">
			<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp?boardNo=<%=boardNo%>&commentNo=<%=commentNo %>" method="post">
				<div>
					<input type="hidden" name="boardNo" value="<%=comment.boardNo %>"> <!-- 부모글 넘버 -->
					<input type="hidden" name="commentNo" value="<%=comment.commentNo %>"> <!-- 댓글 넘버 -->
					<table  class="table table-bordered table-hover w-100 rounded" style="margin-left: auto; margin-right: auto;">
						<tr>
							<th>내용</th>
							<td><%=comment.commentContent %></td>	
						</tr>
						<tr>
							<th>비밀번호</th>
							<td>
								<input type="password" name="commentPw">
							</td>
						</tr>
						<tr>
							<td style="text-align:center;" colspan ="2">
								<button type="submit" class="btn text-black .bg-dark.bg-gradient" style="background-color:#D4D4D4;">DELETE</button>
							</td>
						</tr>
					</table>
				</div>
				
			</form>
		</div>	
	</body>
</html>