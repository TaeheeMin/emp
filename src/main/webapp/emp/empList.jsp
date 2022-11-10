<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	// 2
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	
	// 페이지 알고리즘
	int currentPage = 1; // 현재 페이지
	int rowPerPage = 10; // 페이지당 보이는 목록개수
	
	if(request.getParameter("currentPage") != null){
		// currentPage가 null이 아니면  페이지 받아와서 current에 넣어줌
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 라스트 페이지 개수 찾기
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int count= 0;
	if(countRs.next()) {
		count = countRs.getInt("COUNT(*)");
	}	
	System.out.println("count : " + count); // 디버깅

	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0 ) {
		lastPage++;
	}
	System.out.println("lastPage : " + lastPage); // 디버깅
	
	// 한 페이지당 출력할 emp목록
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";

	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1,rowPerPage*(currentPage - 1));
	empStmt.setInt(2,rowPerPage);
	
	ResultSet empRs = empStmt.executeQuery();
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()){ // ResultSet의 API(사용방법)을 모르면 사용할 수 없는 반복문 
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Employee List</title>
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
			}
			a {
			text-decoration: none;
			}
		</style>
	</head>
	
	<body>
		<div>
			<!-- jsp 액션 태그 : 동일페이지 출력, 상대주소 사용할수 없다.(서버가 하는거라. 브라우저 입장에서 처리하는것은 절대주소인 context사용 가능 -->
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		
		<h1 class="text-center">사원목록</h1>
		
		<div class="text-center">현재 페이지 : <%=currentPage %></div>
		<div>
		<table  class = "table table-hover w-100 rounded" style="table-layout: auto; width: 100%; table-layout: fixed;">
			<tr>
				<th>emp no</th>
				<th>first name</th>
				<th>last name</th>
			</tr>
			<%
				for(Employee e : empList) {
			%>
				<tr>
					<td><%=e.empNo%></td>
					<td>
						<a href="">
						<%=e.firstName%></a>
					</td>
					<td><%=e.lastName%></td>
				</tr>
					
			<%
			
				}
			%>
		
		</table>
		</div>
		
		<!-- 페이징 코드 -->
		<div class = "container">
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
			<%
				if(currentPage > 1){
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%
				}
			%>
			<%
				if(currentPage < lastPage){
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
			<%
				}
			%>
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
		</div>
		
	</body>
</html>