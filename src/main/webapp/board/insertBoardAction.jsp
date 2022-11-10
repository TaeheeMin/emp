<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String pw1 = request.getParameter("pw1");
	String pw2 = request.getParameter("pw2");
	String boardPw = null;
	
	// 작성 확인
	if(boardTitle == null || boardContent == null || boardWriter == null || pw1 == null || pw2 == null
		|| boardTitle.equals("") || boardContent.equals("") || boardWriter.equals("") || pw1.equals("") || pw2.equals("")){
		String insertMsg = URLEncoder.encode("내용을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+insertMsg);
		return;
	} // 내용 미입력시 메세지, 폼이동
	
	// 비밀번호 확인
	if(pw1.equals(pw2)){
		boardPw = pw1;
	} else {
		String msg = URLEncoder.encode("비밀번호를 확인해 주세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	} // 비밀번호 불일치시 메세지, 폼이동
	
	Board board = new Board();
	board.boardTitle = boardTitle;
	board.boardContent = boardContent;
	board.boardWriter = boardWriter;
	board.boardPw = boardPw;
	
	// 2. 요청 처리
    Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2. insert
	PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO board(board_title, board_content, board_writer, board_pw, createdate) values(?,?,?,?,curdate())");
	insertStmt.setString(1, board.boardTitle); 
	insertStmt.setString(2, board.boardContent); 
	insertStmt.setString(3, board.boardWriter); 
	insertStmt.setString(4, board.boardPw); 
	
	// 디버깅
	int row = insertStmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}

	// 3. 결과출력 
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>
