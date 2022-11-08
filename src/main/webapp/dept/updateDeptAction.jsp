<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	// 1. 요청 분석
	// 값 받아오기
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	String deptNo = request.getParameter("deptNo"); // 수정할 부서 번호 list에서 받아옴 
	String deptName = request.getParameter("deptName");  
	System.out.println(deptNo);
	

	// 2. 요청 처리
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// sql문 작성
	String sql = "update departments set dept_name=? where dept_no = ?"; // 부서명 변경
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	// 디버깅
	System.out.println("deptName : " + deptNo);
	System.out.println("deptName : " + deptName);
	
	
	// 디버깅 
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	// 수정 후 리스트로 돌아감
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	// 3. 출력 -> 출력없음
%>
