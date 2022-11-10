<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	// 값 받아오기
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	// 수정할 게시글 정보둘 폼에서 받아옴
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));  
	String boardTitle = request.getParameter("boardTitle");
	String boardPw = request.getParameter("boardPw");
	String boardContent = request.getParameter("boardContent");  

	Board board = new Board();
	board.boardNo = boardNo;
	board.boardTitle = boardTitle;
	board.boardPw = boardPw;
	board.boardContent = boardContent;
	
	// 2. 요청 처리
	// 비밀번호 일치시 수정
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2-1 비밀번호 확인
	String selectSql = "SELECT board_no boardNo, board_pw boardPw FROM board WHERE board_no=? AND board_pw=?";
	PreparedStatement selectStmt = conn.prepareStatement(selectSql);
	selectStmt.setInt(1, board.boardNo);
	selectStmt.setString(2, board.boardPw);
	
	ResultSet selectRs = selectStmt.executeQuery();
	if(selectRs.next()) { // 결과물이 있으면 동일값 존재 -> 수정 진행
	} else { // 없으면 비밀번호 확인 메세지 출력
		String updaetMsg = URLEncoder.encode("비밀번호를 확인해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+updaetMsg+"&boardNo="+board.boardNo);
		return;
	}
		System.out.println(request.getParameter("updaetMsg"));
	
	// 2-2 비밀번호 동일하면 입력한 값으로 수정
	String updateSql = "UPDATE board SET board_title=?, board_content=? Where board_no = ?";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	// sql에 들어갈 값 세팅
	updateStmt.setString(1, board.boardTitle);
	updateStmt.setString(2, board.boardContent);
	updateStmt.setInt(3, board.boardNo);
	
	
	// 실행 및 디버깅 변수 선언
	int row = updateStmt.executeUpdate();
	
	// 디버깅
	if (row == 1) {
	   System.out.println("수정 성공");
	} else {
	   System.out.println("수정 실패");
	}
	
	// 수정 후 리스트로 돌아감
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");

	// 3. 출력 -> 출력없음
%>
