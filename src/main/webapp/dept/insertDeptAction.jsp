<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8");
	if(request.getParameter("deptNo") == null || request.getParameter("deptName") == null){
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp");
		return;
	}

	// 2. 요청 처리
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	PreparedStatement stmt = conn.prepareStatement(
		"insert into departments(dept_no, dept_name) values(?,?)");
	
	stmt.setString(1, deptNo); 
	stmt.setString(2, deptName); 

	
	// 디버깅
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}

	// 3. 결과출력 
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
