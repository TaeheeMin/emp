<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	String deptNo = request.getParameter("deptNo"); // list에서 받아오는 거니까 이름 같게! 
	System.out.println(deptNo);
	
	// 2. 요청 처리
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// sql문 작성
	String sql = "delete from departments where dept_no = ?"; // 삭제 쿼리문
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt.setString(1, deptNo);
	
	// 디버깅 
	int row = stmt.executeUpdate();
	if (row == 1) {
		System.out.println("삭제성공");
	} else {
		System.out.println("삭제실패");
	}
	
	// 삭제 후 리스트로 돌아감
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp"); 
	// 3. 출력 -> 출력없음
%>