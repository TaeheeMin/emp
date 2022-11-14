<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	// word-> 1)null 2)''공백일때 or 3)'단어' -> stmt 수정

	// 2 요청 처리
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	
	// 페이지 알고리즘
	int currentPage = 1; // 현재 페이지
	if(request.getParameter("currentPage") != null){
		// currentPage가 null이 아니면  페이지 받아와서 current에 넣어줌
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 10; // 페이지당 보이는 목록개수
	int beginRow = ROW_PER_PAGE * (currentPage-1); // sql문에 limit beginRow, ROW_PER_PAGE
	
	// 2. 요청 처리
	int cnt = 0;
	int lastPage = 0;
	String listSql = null;
	String cntSql = null;
	ResultSet cntRs = null;
	ResultSet listRs = null;
	PreparedStatement listStmt = null;
	PreparedStatement cntStmt = null;
	// model new data
	ArrayList<Employee> empList = new ArrayList<Employee>();
	
	if(word == null || word.equals("")) {
		// null일때 전체 페이지
		cntSql = "SELECT COUNT(*) FROM employees";
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
		listSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC  LIMIT ?, ?;";
		listStmt = conn.prepareStatement(listSql); 
		listStmt.setInt(1,beginRow);
		listStmt.setInt(2,ROW_PER_PAGE);
	} else {
		// 검색일 때 페이지
		cntSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1,"%" + word + "%");
		cntStmt.setString(2,"%" + word + "%");
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
		listSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?;";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%" + word + "%"); // 공백이나 단어검색 했을때 ;
		listStmt.setString(2, "%" + word + "%"); 
		listStmt.setInt(3,beginRow);
		listStmt.setInt(4,ROW_PER_PAGE);
	}
	
	listRs = listStmt.executeQuery();
	while(listRs.next()){ // ResultSet의 API(사용방법)을 모르면 사용할 수 없는 반복문 
		Employee e = new Employee();
		e.empNo = listRs.getInt("empNo");
		e.firstName = listRs.getString("firstName");
		e.lastName = listRs.getString("lastName");
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
		<div>
			<!-- jsp 액션 태그 : 동일페이지 출력, 상대주소 사용할수 없다.(서버가 하는거라. 브라우저 입장에서 처리하는것은 절대주소인 context사용 가능 -->
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		
		<h1 class="text-center">사원목록</h1>
		
		<div class="container">
			<!-- 검색 기능 -->
			<form method="post" action="<%=request.getContextPath()%>/emp/empList.jsp">
				<label for="word">검색 : </label>
				<input type="text" name="word" id="name">
				<button type="submit">검색</button>
			</form>
		
			<table class = "table table-hover w-100 rounded" style="table-layout: auto; width: 100%; table-layout: fixed;">
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
							<%=e.firstName%>
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
			<%
				if(word == null) {
					%>
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
					<%
				} else {
					%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
					<%
						}
					%>
					<%
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
					<%
						}
					%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
					<%
				}
					%>	
		</div>
	</body>
</html>