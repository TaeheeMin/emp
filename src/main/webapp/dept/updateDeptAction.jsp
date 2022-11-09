<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.Department"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	// 값 받아오기
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	String deptNo = request.getParameter("deptNo"); // 수정할 부서 번호 list에서 받아옴 
	String deptName = request.getParameter("deptName");  
	
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;
	System.out.println(dept.deptNo);
	System.out.println(dept.deptName);
	
	// 2. 요청 처리
	// 이미 존재하는 값과 동일한 값이 입력되면 예외(에러)가 발생 -> 막는 기능 필요
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	
	String sql = "SELECT dept_name FROM departments WHERE dept_name=?";
	PreparedStatement stmt1 = conn.prepareStatement(sql);
	//stmt1.setString(1, deptNo);
	stmt1.setString(1, dept.deptName);
	
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()) { // 결과물이 있으면 동일값 존재 -> 에러 메세지, 폼이동
		String updaetMsg = URLEncoder.encode("부서명이 중복되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+updaetMsg+"&deptNo="+dept.deptNo+"&deptName="+dept.deptName); // form에서 설정한 이름하고 같게 넣어야 들어감
		System.out.println(updaetMsg);
		return;
	}
	
	// 2-2 수정 sql문
	String sql2 = "UPDATE departments SET dept_name = ? WHERE dept_no = ?"; // 부서명 변경
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, dept.deptNo);
	stmt2.setString(2, dept.deptName);

	// 2-2 dept_name이 중복되지 않을 경우 입력한 값으로 수정
	String sqlUpdate = "update departments set dept_name = ?  Where dept_no = ?";
	PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate);
	
	// sql에 들어갈 값 세팅
	stmtUpdate.setString(1, dept.deptName);
	stmtUpdate.setString(2, dept.deptNo);
	
	// 실행 및 디버깅 변수 선언
	int row = stmtUpdate.executeUpdate();
	
	// 디버깅
	if (row == 1) {
	   System.out.println("수정 성공");
	} else {
	   System.out.println("수정 실패");
	}
	
	// 수정 후 리스트로 돌아감
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	// 3. 출력 -> 출력없음
%>
