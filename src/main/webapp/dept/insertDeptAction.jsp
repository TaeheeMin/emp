<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.Department"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")){
		String msg = URLEncoder.encode("부서번호와 부서명을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;

	// 2. 요청 처리
	// 이미 존재하는 key(deptNo)값과 동일한 값이 입력되면 예외(에러)가 발생 -> 막는 기능 필요
    Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2-1. 중복검사
	// select해서 데이터에 입력값과 동일한 값이 있는지 먼저 찾고 비교
	String sql = "select * from departments where dept_no=? or dept_name=?";
	PreparedStatement stmt1 = conn.prepareStatement(sql);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()) { // 결과물이 있으면 동일값 존재 -> 에러 메세지, 추가폼이동
		String msg = URLEncoder.encode("부서번호 또는 부서명이 중복되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	// 디버깅
	System.out.println("deptNo : " + deptNo);
	System.out.println("deptName : " + deptName);
	
	// 2-2 insert
	PreparedStatement stmt2 = conn.prepareStatement("insert into departments(dept_no, dept_name) values(?,?)");
	stmt2.setString(1, deptNo); 
	stmt2.setString(2, deptName); 
	
	// 디버깅
	int row = stmt2.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}

	// 3. 결과출력 
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
