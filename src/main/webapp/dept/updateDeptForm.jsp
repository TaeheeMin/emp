<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	String deptNo = request.getParameter("deptNo"); // list에서 받아오는 거니까 이름 같게! 
	System.out.println(deptNo);
	
	// 2. 요청 처리
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");

	// sql문 작성
	String sql = "select dept_no deptNo, dept_name deptName from departments where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt.setString(1, deptNo);
	
	String deptName = request.getParameter("deptName");
	
	ResultSet rs = stmt.executeQuery(); // 0행 또는 1행
	if (rs.next()) {
		deptNo = rs.getString("deptNo");
		deptName = rs.getString("deptName");
	}
	
	// 3. 출력
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>update Department Form</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			table, body {
  				font-size: 15px;
  				text-align:center;
			}
		</style>
	</head>
	
	<body>
		<div class = "container">
				<div> <!-- 제목 -->
					<h1 class="h3">
						UPDATE DEPARTMENT<span></span>
					</h1>
				</div>
			<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method="post">
				
				<table class="table table-bordered table-hover w-50 rounded" style="margin-left: auto; margin-right: auto;"> 
					<tr>
						<td>DEPARTMENT NUMBER</td> <!-- 부서번호는 수정 불가 -->
						<td>
							<input type= "text" name="deptNo" value="<%=deptNo%>" readonly="readonly"> 
							
						</td>
					</tr>
					<tr>
						<td>DEPARTMENT NAME</td> <!-- 부서명 입력값 가져오기 -->
						<td>
							<input type= "text" name="deptName" value="<%=deptName%>"> 
						</td>
					<tr>
						<td colspan ="2">
							<button type="submit" class="btn text-black .bg-dark.bg-gradient"  style="background-color:#D4D4D4;">UPDATE</button>
						</td>
					</tr>
				</table>
			</form>
		</div>	
	</body>
</html>