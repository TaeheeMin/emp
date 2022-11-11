<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	// 값 받아오기
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // 수정할 게시글 번호 폼에서 받아옴 
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
	String deleteSql = "DELETE FROM board WHERE board_no=? AND board_pw=?";
	// 쿼리 셋팅
	PreparedStatement deletetStmt = conn.prepareStatement(deleteSql);
	deletetStmt.setInt(1, board.boardNo);
	deletetStmt.setString(2, board.boardPw);
	
	/* 쿼리 실행 결과 -> 내가 작성한 코드
	ResultSet deleteRs = deletetStmt.executeQuery();
	
	if(deleteRs.next() == false) { // 없으면 동일값 존재안함 -> 폼으로 돌아가고 비밀번호 확인 메세지 출력
		String deleteMsg = URLEncoder.encode("비밀번호를 확인해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+deleteMsg+"&boardNo="+board.boardNo);
		return;
	}
	*/
	
	// 쿼리 실행
	int row = deletetStmt.executeUpdate();
	
	// 쿼리 실행결과 -> 좀 더 간결한 코드
	if (row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		System.out.println("삭제 성공");
	} else {
		String deleteMsg = URLEncoder.encode("비밀번호를 확인해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+deleteMsg+"&boardNo="+board.boardNo);
		System.out.println("삭제 실패");
		return;
	}
	
	// 수정 후 리스트로 돌아감

	// 3. 출력 -> 출력없음
%>
