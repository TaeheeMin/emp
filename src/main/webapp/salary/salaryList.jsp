<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");

	// db연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 페이징
	// 현재 페이지
	int currentPage = 1; // 현재페이지
	if(request.getParameter("currentPage") != null) { // 현재 페이지 값이 null이면 받아오기
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 10; // 한 페이지당 행 개수
	int beginRow = ROW_PER_PAGE * (currentPage-1); // sql문에 limit beginRow, ROW_PER_PAGE
	
	// 2. 요청 처리
	int cnt = 0;
	int lastPage = 0;
	String listSql = null;
	String cntSql = null;
	ResultSet cntRs = null;
	PreparedStatement listStmt = null;
	PreparedStatement cntStmt = null;
	
	if(word == null || word.equals("")) {
		// null일 때 전체 페이지
		cntSql = "SELECT COUNT(*) FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
		cntRs = cntStmt.executeQuery();
		if(cntRs.next()) {
			cnt = cntRs.getInt("COUNT(*)");
		}	
		System.out.println("cnt : " + cnt); // 디버깅
		System.out.println("word null"); // 디버깅
		
		// 마지막 페이지
		lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
		System.out.println("lastPage : " + lastPage); // 디버깅
		
		// null일때 목록
		listSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1,beginRow);
		listStmt.setInt(2,ROW_PER_PAGE);
	} else {
		// 검색일 때 페이지
		cntSql = "SELECT COUNT(*) FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%" + word + "%");
		cntStmt.setString(2, "%" + word + "%");
		
		cntRs = cntStmt.executeQuery();
		if(cntRs.next()) {
			cnt = cntRs.getInt("COUNT(*)");
		}	
		System.out.println("cnt : " + cnt); // 디버깅
		System.out.println("word : " + word); // 디버깅
		
		// 마지막 페이지
		lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
		System.out.println("lastPage : " + lastPage); // 디버깅
		
		// 검색일 때 목록
		listSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%" + word + "%"); // 공백이나 단어검색 했을때 ;
		listStmt.setString(2, "%" + word + "%"); 
		listStmt.setInt(3,beginRow);
		listStmt.setInt(4,ROW_PER_PAGE);
	}
	/*
	SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName
	FROM 
	salaries s INNER JOIN employees e ON s.emp_no = e.emp_no
	LIMIT ?,?;
	*/		
	ResultSet listRs = listStmt.executeQuery();
	// model new data
	ArrayList<Salary> salaryList = new ArrayList<>(); 
	while(listRs.next()){
		Salary s = new Salary();
		s.emp = new Employee(); // Employee 객체 가져와서 사용
		s.emp.empNo = listRs.getInt("empNo");
		s.salary = listRs.getInt("salary");
		s.fromDate = listRs.getString("fromDate");
		s.toDate = listRs.getString("toDate");
		s.emp.firstName = listRs.getString("firstName");
		s.emp.lastName = listRs.getString("lastName");
		salaryList.add(s);
	}
	/*
	while(rs.next()) {
		Salary s = new Salary();
		s.emp = new Employee(); // ☆☆☆☆☆
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
	*/
	// 3. 출력
	
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Salary List</title>
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
			#nav{
			}
			a {
				text-decoration: none;
			}
		
			th {
				text-align:center
			}
		</style>
	</head>
	
	<body>
		<!-- 메뉴 partial jsp 구성-->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
	
		<div class="text-center">
			<h1>Salary List</h1>
		</div>
		
		<div class="container">
			<!-- 검색 기능 -->
			<form method="post" action="<%=request.getContextPath()%>/salary/salaryList.jsp">
				<label for="word">검색 : </label>
				<input type="text" name="word" id="name">
				<button type="submit">검색</button>
			</form>
			
			<table class="table table-hover w-100 rounded" style="table-layout: auto; width: 100%; table-layout: fixed;">
				<tr>
					<th>EMP NO</th>
					<th>SALARY</th>
					<th>FROM DATE</th>
					<th>TO DATE</th>
					<th>FIRST NAME</th>
					<th>LAST NAME</th>
						
				</tr>
				
				<%
					for( Salary s : salaryList){
				%>
					<tr>
						<td><%=s.emp.empNo %></td>
						<td><%=s.salary %></td>
						<td><%=s.fromDate %></td>
						<td><%=s.toDate %></td>
						<td><%=s.emp.firstName %></td>
						<td><%=s.emp.lastName %></td>
					</tr>
				<%		
					}
				%>
			
			</table>
			
			<div class = "container">
				<%
					if(word == null) {
						%>
						<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1">처음</a>
						<%
							if(currentPage > 1){
						%>
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>">이전</a>
						<%
							}
						%>
						<%
							if(currentPage < lastPage){
						%>
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>">다음</a>
						<%
							}
						%>
						<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>">마지막</a>
						<%
					} else {
						%>
						<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1&word=<%=word%>">처음</a>
						<%
							if(currentPage > 1){
						%>
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
						<%
							}
						%>
						<%
							if(currentPage < lastPage){
						%>
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
						<%
							}
						%>
						<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
						<%
					}
						%>	
			</div>
		</div>
	</body>
</html>