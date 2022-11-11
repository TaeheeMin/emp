<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "java.util.*" %>
<%
	// 1. 요청 분석
	// 값 받아오기
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw"); 

	Comment comment = new Comment();
	comment.boardNo = boardNo;
	comment.commentNo = commentNo;
	comment.commentPw = commentPw;
	System.out.print("comment.commentNo : " + comment.commentNo);
	
	// 2. 요청 처리
	// 비밀번호 일치시 삭제
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2-1 비밀번호 확인
	String deleteSql = "DELETE FROM comment WHERE comment_no=? AND comment_pw=?";
	// 쿼리 셋팅
	PreparedStatement deletetStmt = conn.prepareStatement(deleteSql);
	deletetStmt.setInt(1, comment.commentNo);
	deletetStmt.setString(2, comment.commentPw);
	
	//ResultSet delCommentRs = deletetStmt.executeQuery();
	// 쿼리 실행결과
	int row = deletetStmt.executeUpdate();
	if (row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?&boardNo="+comment.boardNo);
		System.out.println("삭제 성공");
	} else {
		String deleteMsg = URLEncoder.encode("비밀번호를 확인해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?msg="+deleteMsg+"&boardNo="+comment.boardNo+"&commentNo="+comment.commentNo);
		System.out.println("삭제 실패");
		return;
	}
	
	// 수정 후 리스트로 돌아감

	// 3. 출력 -> 출력없음
%>
