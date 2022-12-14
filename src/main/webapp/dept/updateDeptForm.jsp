<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.Department"%>
<%@ page import = "java.net.URLEncoder" %>

<%
	request.setCharacterEncoding("utf-8"); //값 받아오는거 인코딩
	String deptNo = request.getParameter("deptNo"); // list에서 받아오는 거니까 이름 같게!
	String deptName = request.getParameter("deptName");
	
	if(deptNo == null){ // form주소를 직접 호출하면 null값이 되어 막어야 함
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp"); // null 들어오면 리스트로 보냄
		return;
	}
	
	// 2. 요청 처리
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");

	// sql문 작성
	String sql = "SELECT dept_name deptName FROM departments WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt.setString(1, deptNo);
	ResultSet rs = stmt.executeQuery(); // 0행 또는 1행
	
	Department dept = new Department();
	dept.deptNo = null;
	dept.deptName = null;
	if (rs.next()) {
		dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
	}
	System.out.println("msg : " + request.getParameter("msg")); // 디버깅
	
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
			body {
				padding:1.5em;
				background: #f5f5f5
			}

			table {
			 	border: 1px #a39485 solid;
				font-size: .9em;
				box-shadow: 0 2px 5px rgba(0,0,0,.25);
				width: 100%;
				border-collapse: collapse;
				border-radius: 5px;
				overflow: hidden;
				text-align:center;
			}
			a {
			text-decoration: none;
			}
			input {
				font-size: 15px;
				border: 0;
				border-radius: 15px;
				outline: none;
				padding-left: 10px;
				background-color: rgb(233, 233, 233);
			}
		</style>
	</head>
	
	<body>
		<!-- 메뉴 partial jsp 구성-->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		
		<!-- 제목 -->
		<div> 
			<h1 class="text-center">
				UPDATE DEPARTMENT<span></span>
			</h1>
		</div>
		
		<!-- msg 파라미터값이 있으면 출력 -->
		<%
		if(request.getParameter("msg") != null){
		%>
			<div><%=request.getParameter("msg")%></div>
		<%
		}
		%>
			
		<div class = "container">
			<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method="post">
			<!-- msg 파라미터값이 있으면 출력 -->
			<%
			if(request.getParameter("updaetMsg") != null){
			%>
				<div><%=request.getParameter("updaetMsg")%></div>
			<%
			}
			%>
				<table class="table table-bordered table-hover w-50 rounded" style="margin-left: auto; margin-right: auto;"> 
					<tr>
						<td>DEPARTMENT NUMBER</td> <!-- 부서번호는 수정 불가 -->
						<td>
							<input type= "text" name="deptNo" value="<%=dept.deptNo%>" readonly="readonly"> 
						</td>
					</tr>
					
					<tr>
						<td>DEPARTMENT NAME</td> <!-- 부서명 입력값 가져오기 -->
						<td>
							<input type= "text" name="deptName" value="<%=dept.deptName%>"> 
						</td>
					</tr>
					
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