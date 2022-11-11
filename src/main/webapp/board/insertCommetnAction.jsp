<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8");
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	
	// 작성 확인
	if(commentContent == null || commentPw == null || commentContent.equals("") || commentPw.equals("")){
		String insertComMsg = URLEncoder.encode("내용을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?msg="+insertComMsg+"&boardNo="+boardNo);
		return;
	} // 내용 미입력시 메세지,boardOne이동
	
	Comment com = new Comment();
	com.commentContent = commentContent;
	com.commentPw = commentPw;
	com.boardNo = boardNo;
	
	// 2. 요청 처리
    Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2. insert
	String insertComSql = "INSERT INTO comment(board_no, comment_content, comment_pw, createdate) values(?,?,?,curdate())";
	PreparedStatement insertStmt = conn.prepareStatement(insertComSql);
	insertStmt.setInt(1, com.boardNo); 
	insertStmt.setString(2, com.commentContent); 
	insertStmt.setString(3, com.commentPw); 
	
	// 디버깅
	int row = insertStmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}

	// 3. 결과출력 
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+com.boardNo);
%>
