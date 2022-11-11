<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	// 값 받아오기
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	// 수정할 댓글 정보둘 폼에서 받아옴
	String msg = request.getParameter("msg");
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // 수정할 번호 받아오기
	int commentNo = Integer.parseInt(request.getParameter("commentNo")); // 삭제할 댓글 번호 받아오기
	String commentPw = request.getParameter("commentPw");
	String commentContent = request.getParameter("commentContent");

	Comment comment = new Comment();
	comment.boardNo = boardNo;
	comment.commentNo = commentNo;
	comment.commentPw = commentPw;
	comment.commentContent = commentContent;
	System.out.print("comment.commentNo : " + comment.commentNo);
	
	// 2. 요청 처리
	// 비밀번호 일치시 수정
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2-1 비밀번호 확인
	String selectSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no=? AND comment_no=? AND board_pw=?";
	PreparedStatement selectStmt = conn.prepareStatement(selectSql);
	selectStmt.setInt(1,comment.boardNo);
	selectStmt.setInt(2,comment.commentNo);
	selectStmt.setString(3,comment.commentPw );
	
	// 2-2 비밀번호 동일하면 입력한 값으로 수정
	String updateSql = "UPDATE comment SET comment_content=? Where board_no = ? AND comment_no=?";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	// sql에 들어갈 값 세팅
	updateStmt.setString(1, comment.commentContent);
	updateStmt.setInt(2, comment.boardNo);
	updateStmt.setInt(3, comment.commentNo);
	
	int row = updateStmt.executeUpdate();
	if (row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?&boardNo="+comment.boardNo);
		System.out.println("수정 성공");
	} else {
		String updMsg = URLEncoder.encode("비밀번호를 확인해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?msg="+updMsg+"&boardNo="+comment.boardNo+"&commentNo="+comment.commentNo);
		System.out.println("수정 실패");
	}
	
	// 수정 후 리스트로 돌아감
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");

	// 3. 출력 -> 출력없음
%>
