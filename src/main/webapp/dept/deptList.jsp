
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	// 2. 업무 처리(model)
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	PreparedStatement stmt = conn.prepareStatement("select dept_no deptNo, dept_name deptName from departments order by dept_no desc");
	ResultSet rs = stmt.executeQuery(); // 모델 데이터 ResultSet 보편적인 타입은 아니다
	// ResultSet 모델 자료구조를 좀 더 일반적이고 독립적인 자료 구조로 변경!!!
	
	ArrayList<Department> list = new ArrayList<Department>(); // arraylist로 변경하여 좀 더 보편성을 가짐
	while(rs.next()){ // ResultSet의 API(사용방법)을 모르면 사용할 수 없는 반복문 
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	
	// 3. 출력(view) 
	// 고객이 원하는 형태로 출력
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Department List</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			img {
				width:20px;
				height: 20px;
			}
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
			th {
				text-align:center
			}
		</style>
	</head>
	
	<body>
		<!-- 메뉴 partial jsp 구성-->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
			<!-- jsp 액션 태그 : 동일페이지 출력, 상대주소 사용할수 없다.(서버가 하는거라. 브라우저 입장에서 처리하는것은 절대주소인 context사용 가능 -->
		</div>
		
		<div>
			<h1 class="text-center">DEPT LIST</h1>
		</div>
			
		<div class = "container">
			<!-- 테이블 -->
			<table class = "table table-hover w-100 rounded" style="table-layout: auto; width: 100%; table-layout: fixed;"> 
				<thead>
					<tr>
						<th style="width:100px;">DEPT NO</th>
						<th>DEPARTMENT NAME</th>
						<th style="width:100px;">ACTION</th>
					</tr>
				</thead>
				
				<tbody>
					<% 
						for(Department d : list){ // 자바 문법에서 제공하는 foreach문 -> 좀 더 보편성
					%>
							<tr>
								<td style="text-align:center"><%=d.deptNo%></td>
								<td><%=d.deptName%></td>
								<td style="text-align:center"> <!-- 수정 아이콘 -->
									<a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>">
										<img class="img-concert" src="<%=request.getContextPath()%>/dept/img/update.png"/>
		  							</a> 
		  							<!-- 삭제 아이콘 -->
									<a href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>">
										<img class="img-concert" src="<%=request.getContextPath()%>/dept/img/delete.png"/>
		  							</a>
								</td>
							</tr>
						<%
						}
						%>
				</tbody>
				<!-- 추가 아이콘 -->
			</table>
			<div> 
				<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">
					<img class="img-concert" src="<%=request.getContextPath()%>/dept/img/add.png"/>부서추가
				</a>
			</div>
		</div>
	</body>
</html>