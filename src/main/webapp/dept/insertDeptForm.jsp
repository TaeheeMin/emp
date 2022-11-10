<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>ADD DEPARTMENT</title>
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
			<div> <!-- 제목 -->
				<h1 class="text-center">
					ADD DEPARTMENT
				</h1>
			</div>
				
			<div class = "container">
				<!-- msg 파라미터값이 있으면 출력 -->
				<%
				if(request.getParameter("msg") != null){
				%>
				<div><%=request.getParameter("msg")%></div>
				<%
				}
				%>
				<form  method="post" action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
					
					<table class="table table-bordered table-hover w-50 rounded" style="margin-left: auto; margin-right: auto;"> 
						<tr>
							<td>DEPT NO</td>
							<td>
								<input type="text" name="deptNo"> 
								
							</td>
						</tr>
						<tr>
							<td>DEPT NAME</td>
							<td>
								<input type="text" name="deptName"> 
							</td>
						<tr>
							<td colspan ="2">
								<button type="submit" class="btn text-black .bg-dark.bg-gradient"  style="background-color:#D4D4D4;">ADD</button>
							</td>
						</tr>
					</table>
				</form>
		</div>	
	</body>
</html>