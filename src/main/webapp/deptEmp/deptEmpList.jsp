<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>

<%
	//1. 요청분석
	request.setCharacterEncoding("utf-8");
	// 검색
	String word = request.getParameter("word");
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) { // 현재 페이지 값이 null이면 받아오기
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 요청처리
	// 페이징
	int rowPerPage = 10;
	int beginRow = rowPerPage*(currentPage-1); 
	
	// db 연결
	// 메개변수에 값을 직접 넣기보단 변수 넣어주는게 좋음
	String driver = "org.mariadb.jdbc.Driver"; 
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	// 주소 -> 프로토콜:// + 주소(IP OR 도메인(IP에 맵핑)) + :포트번호
	// jdbc:mariadb://localhost:3306/employees
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
		
	int cnt = 0;
	int lastPage = 0;
	String listSql = null;
	String cntSql = null;
	ResultSet cntRs = null;
	PreparedStatement listStmt = null;
	PreparedStatement cntStmt = null;
	
	if(word == null || word.equals("")) {
		// null일 때 전체 페이지
		cntSql = "SELECT COUNT(*) FROM dept_emp";
		cntStmt = conn.prepareStatement(cntSql);
		cntRs = cntStmt.executeQuery();
		if(cntRs.next()) {
			cnt = cntRs.getInt("COUNT(*)");
		}	
		System.out.println("cnt : " + cnt); // 디버깅
		System.out.println("word null"); // 디버깅
		
		// 마지막 페이지
		lastPage = (int)Math.ceil((double)cnt / (double)rowPerPage);
		System.out.println("lastPage : " + lastPage); // 디버깅
		
		// null일때 목록
		listSql = "SELECT de.emp_no empNo, e.first_name firstName, e.last_name lastName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no	INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1,beginRow);
		listStmt.setInt(2,rowPerPage);
	} else {
		// 검색일 때 페이지
		
/* 		SELECT de.emp_no empNO, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? LIMIT ?, ?;
 */
		cntSql = "SELECT COUNT(*) FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
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
		lastPage = (int)Math.ceil((double)cnt / (double)rowPerPage);
		System.out.println("lastPage : " + lastPage); // 디버깅
		
		// 검색일 때 목록
		listSql = "SELECT de.emp_no empNo, e.first_name firstName, e.last_name lastName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%" + word + "%"); // 공백이나 단어검색 했을때 ;
		listStmt.setString(2, "%" + word + "%"); // 공백이나 단어검색 했을때 ;
		listStmt.setInt(3,beginRow);
		listStmt.setInt(4,rowPerPage);
		
	}
	
	ResultSet listRs = listStmt.executeQuery();
	
	ArrayList<DeptEmp> deptEmpList = new ArrayList<DeptEmp>();
	while(listRs.next()) {
		DeptEmp d = new DeptEmp();
		d.emp = new Employee();
		d.dept = new Department();
		d.emp.empNo = listRs.getInt("empNo");
		d.emp.firstName = listRs.getString("firstName");
		d.emp.lastName = listRs.getString("lastName");
		d.dept.deptName = listRs.getString("deptName");
		d.fromDate = listRs.getString("fromDate"); 
		d.toDate = listRs.getString("toDate");
		deptEmpList.add(d);
	}

	listRs.close();
	listStmt.close();
	conn.close();
	// db 연결 끊어주는 메서드
%> 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>DEPTEMP List</title>
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
			<h1>DEPTEMP List</h1>
		</div>
		
		<div class="container">
			<!-- 검색 기능 -->
			<form method="post" action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp">
				<label for="word">검색 : </label>
				<input type="text" name="word" id="name" value="<%=word%>">
				<button type="submit">검색</button>
			</form>
			<table class="table table-hover w-100 rounded" style="table-layout: auto; width: 100%; table-layout: fixed;">
				<tr>
					<th>EMP NO</th>
					<th>NAME</th>
					<th>DEPT NAME</th>
					<th>FROM DATE</th>
					<th>TO DATE</th>
				</tr>
				<%
					for(DeptEmp d : deptEmpList) {
				%>
					<tr>
						<td><%=d.emp.empNo%></td>					
						<td><%=d.emp.firstName + " " + d.emp.firstName%> </td>					
						<td><%=d.dept.deptName %></td>					
						<td><%=d.fromDate %></td>					
						<td><%=d.toDate %></td>					
					</tr>
				<%
					}
				%>
			</table>
			<div class = "container">
				<%
				if(word == null) {
					%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>">이전</a>
					<%
						}
					%>
					<%
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<%
						}
					%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>">마지막</a>
					<%
				} else {
					%>
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&word=<%=word%>">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
					<%
						}
					%>
					<%
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
					<%
						}
					%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
				<%
				}
				%>
			</div>
		</div>
	</body>
</html>